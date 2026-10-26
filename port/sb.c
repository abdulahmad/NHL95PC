/* The Sound Blaster (Pro compatible): the DSP at base+6..0xE, the mixer at base+4/5, and 8-bit PCM played from a DMA channel. The FM
 * ports (base+0..3, base+8/9) go to the OPL in sound_ports.c. */
#include "host.h"
#include "audio.h"

static int base = 0x220, irq = 7, dma = 1, version = 0x0302;
static uint8_t outbuf[64];
static int out_n;
static int resetting;
static int cmd = -1, cmd_need, cmd_got;
static uint8_t cmd_data[4];
static int speaker_on;
static int time_constant = 0xA6;          /* 11 kHz */
static uint32_t block_size = 0x7FF;       /* set by 0x48: bytes minus one */
static int active, autoinit, paused, high_speed;
static int64_t remaining;                 /* bytes left in the current block, or silent samples */
static int silence;
static int irq_pending;
static uint8_t test_reg;
static int direct_level = 128;
static uint8_t mixer_idx, mixer[256];
static double acc;
static int64_t pump_last_ns;              /* the clock of the DMA pump (sb_pump), and the fraction of a sample it owes */
static double pump_acc;
static int prev_l, prev_r, cur_l, cur_r;      /* cur: the last sample taken from the DMA channel; prev, out: the output side */
static int out_l, out_r;

static void mixer_reset(void)
{
    memset(mixer, 0, sizeof mixer);
    mixer[0x04] = 0xCC; mixer[0x0A] = 0x00; mixer[0x0C] = 0x00; mixer[0x0E] = 0x00;
    mixer[0x22] = 0xEE; mixer[0x26] = 0xEE; mixer[0x28] = 0x00; mixer[0x2E] = 0x00;
}

static void sb_render(int32_t *out, int frames, int rate);

void sb_init(int b, int i, int d, int v)
{
    base = b; irq = i; dma = d; version = v;
    mixer_reset();
    audio_add_source(sb_render);
}

int sb_base(void) { return base; }

static int stereo(void) { return (mixer[0x0E] >> 1) & 1; }

static double sample_rate(void)
{
    double r = 1000000.0 / (256 - time_constant);
    return stereo() ? r / 2 : r;
}

static void raise_irq(void)
{
    irq_pending = 1;
    irq_raise(irq);
}

static void dsp_reset(void)
{
    active = autoinit = paused = high_speed = silence = 0;
    remaining = 0;
    irq_pending = 0;
    speaker_on = 0;
    cmd = -1;
    out_n = 0;
    outbuf[out_n++] = 0xAA;
    time_constant = 0xA6;
    block_size = 0x7FF;
    mixer_reset();
}

static void push_out(uint8_t b)
{
    if (out_n < (int)sizeof outbuf) outbuf[out_n++] = b;
}

static int cmd_params(int c)
{
    switch (c) {
    case 0x10: case 0x40: case 0xE0: case 0xE4: case 0x38: return 1;
    case 0x14: case 0x16: case 0x17: case 0x48: case 0x80: case 0x41: case 0x42: case 0x24: return 2;
    default: return 0;
    }
}

static void start_block(int len_minus_one, int auto_init, int high)
{
    remaining = (int64_t)len_minus_one + 1;
    autoinit = auto_init;
    high_speed = high;
    active = 1;
    paused = 0;
    silence = 0;
    acc = 1.0;
    pump_last_ns = plat_now_ns(); pump_acc = 0;                  /* the clock starts with the block */
    TRACE("sb: start %s%s block %d rate %.0f%s dma%d\n", auto_init ? "auto-init " : "single ", high ? "high-speed" : "", len_minus_one + 1,
          sample_rate(), stereo() ? " stereo" : "", dma);
}

static void run_command(int c)
{
    uint8_t *d = cmd_data;
    switch (c) {
    case 0x10: direct_level = d[0]; break;
    case 0x14: start_block(d[0] | (d[1] << 8), 0, 0); break;
    case 0x1C: start_block(block_size, 1, 0); break;
    case 0x91: start_block(block_size, 0, 1); break;
    case 0x90: start_block(block_size, 1, 1); break;
    case 0x40: time_constant = d[0]; break;
    case 0x41: case 0x42: { double r = (d[0] << 8) | d[1]; time_constant = (int)(256 - 1000000.0 / (r ? r : 1)); if (time_constant < 0) time_constant = 0; break; }
    case 0x48: block_size = d[0] | (d[1] << 8); break;
    case 0x80: remaining = (d[0] | (d[1] << 8)) + 1; silence = 1; active = 1; autoinit = 0; acc = 1.0; pump_last_ns = plat_now_ns(); pump_acc = 0; break;
    case 0xD0: paused = 1; break;
    case 0xD4: paused = 0; break;
    case 0xDA: case 0xD9: autoinit = 0; break;
    case 0xD1: speaker_on = 1; break;
    case 0xD3: speaker_on = 0; break;
    case 0xD8: push_out(speaker_on ? 0xFF : 0x00); break;
    case 0xE0: out_n = 0; push_out(~d[0]); break;
    case 0xE1: push_out(version >> 8); push_out(version & 0xFF); break;
    case 0xE4: test_reg = d[0]; break;
    case 0xE8: push_out(test_reg); break;
    case 0xF2: raise_irq(); break;
    case 0x20: push_out(0x80); break;
    case 0x04: push_out(0xFF); break;
    default: TRACE("sb: unknown DSP command %02x\n", c); break;
    }
}

/* Playback is paced by the clock, not by the audio device: the DMA position the game's driver reads back (it decides when to refill
 * its buffer from it) has to move smoothly, like on the card, and the audio device asks for samples in bursts of 20 ms or more.
 * sb_pump takes the samples that are due by the time of day from the DMA channel (raising the block interrupts) into a queue;
 * sb_render only resamples the queue to the output. sb_pump runs with the audio lock held: from the mixer, from the main loop and
 * when the game reads the DMA position. */
#define FIFO_SIZE 8192
static int16_t fifo_l[FIFO_SIZE], fifo_r[FIFO_SIZE];
static uint32_t fifo_head, fifo_tail;           /* tail: next to read */

static void fifo_push(int l, int r)
{
    if (fifo_head - fifo_tail >= FIFO_SIZE) fifo_tail++;              /* full: the oldest is dropped */
    fifo_l[fifo_head % FIFO_SIZE] = (int16_t)l;
    fifo_r[fifo_head % FIFO_SIZE] = (int16_t)r;
    fifo_head++;
}

static void sb_pump_locked(void)
{
    int64_t now = plat_now_ns(), dt = now - pump_last_ns;
    double due;
    int n, i;
    pump_last_ns = now;
    if (!active) { pump_acc = 0; return; }
    if (dt > 100000000LL) dt = 100000000LL;                       /* after a long stall: do not play it all at once */
    due = pump_acc + dt * sample_rate() / 1e9;
    n = (int)due;
    pump_acc = due - n;
    for (i = 0; i < n && active; i++) {
        int l = cur_l, r = cur_r;
        if (paused) { l = r = 0; }
        else if (silence) { l = r = 0; remaining--; }
        else if (dma_masked(dma)) { /* the card has nothing to play: hold the last sample */ }
        else {
            uint8_t *p = (uint8_t *)dma_address(dma);
            l = (p[0] - 128) << 8; r = l;
            dma_advance(dma, 1);
            remaining--;
            if (stereo() && remaining > 0) {
                r = (*(uint8_t *)dma_address(dma) - 128) << 8;
                dma_advance(dma, 1);
                remaining--;
            }
        }
        cur_l = l; cur_r = r;
        fifo_push(l, r);
        if (!paused && remaining <= 0) {
            raise_irq();
            if (autoinit && !silence) remaining = (int64_t)block_size + 1;
            else { active = 0; silence = 0; }
        }
    }
}

void sb_pump(void)                      /* any thread; takes the audio lock */
{
    if (!active) return;
    audio_lock();
    sb_pump_locked();
    audio_unlock();
}

static void sb_render(int32_t *out, int frames, int rate)
{
    int i;
    double step;
    sb_pump_locked();
    if (!active && fifo_head == fifo_tail) {
        if (speaker_on && direct_level != 128) {            /* direct DAC writes: hold the last value */
            int32_t v = (direct_level - 128) << 6;
            for (i = 0; i < frames; i++) { out[2 * i] += v; out[2 * i + 1] += v; }
        }
        return;
    }
    step = sample_rate() / rate;
    for (i = 0; i < frames; i++) {
        double t;
        while (acc >= 1.0) {
            acc -= 1.0;
            prev_l = out_l; prev_r = out_r;
            if (fifo_tail != fifo_head) { out_l = fifo_l[fifo_tail % FIFO_SIZE]; out_r = fifo_r[fifo_tail % FIFO_SIZE]; fifo_tail++; }
            /* an empty queue repeats the last sample */
        }
        t = acc > 1.0 ? 1.0 : acc;              /* the part of the sample period since the last sample was taken: ramp from the previous one */
        if (speaker_on) {                       /* to this one (one sample of delay), not back toward the previous */
            out[2 * i] += (int32_t)(prev_l + (out_l - prev_l) * t);
            out[2 * i + 1] += (int32_t)(prev_r + (out_r - prev_r) * t);
        }
        acc += step;
    }
}

uint32_t sb_in(unsigned port)
{
    uint32_t v = 0xFF;
    audio_lock();
    switch (port - base) {
    case 0x5: v = mixer[mixer_idx];
        if (mixer_idx == 0x80) v = irq == 2 ? 1 : irq == 5 ? 2 : irq == 7 ? 4 : 8;
        if (mixer_idx == 0x81) v = 1 << dma;
        if (mixer_idx == 0x82) v = irq_pending ? 1 : 0;
        break;
    case 0xA:
        if (out_n) { v = outbuf[0]; memmove(outbuf, outbuf + 1, --out_n); }
        break;
    case 0xC: v = 0x7F; break;                              /* ready for a command */
    case 0xE: v = (out_n ? 0x80 : 0) | 0x7F; irq_pending = 0; break;
    case 0xF: v = 0x7F; break;
    case 0x6: v = 0xFF; break;
    }
    audio_unlock();
    return v;
}

void sb_out(unsigned port, uint32_t val)
{
    audio_lock();
    switch (port - base) {
    case 0x4: mixer_idx = val; break;
    case 0x5: if (mixer_idx == 0) mixer_reset(); else mixer[mixer_idx] = val; break;
    case 0x6:
        if (val & 1) resetting = 1;
        else if (resetting) { resetting = 0; dsp_reset(); }
        break;
    case 0xC:
        if (cmd < 0) {
            cmd = val & 0xFF; cmd_need = cmd_params(cmd); cmd_got = 0;
            if (!cmd_need) { run_command(cmd); cmd = -1; }
        } else {
            cmd_data[cmd_got++] = val;
            if (cmd_got >= cmd_need) { run_command(cmd); cmd = -1; }
        }
        break;
    }
    audio_unlock();
}
