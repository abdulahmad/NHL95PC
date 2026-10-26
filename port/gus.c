/* The Gravis UltraSound (GF1 chip, 1 MB of sample RAM, 32 voices). The game's driver uses the Gravis SDK, which programs the voice
 * registers through the page/register/data ports (base+102h..107h), polls the interrupt registers and uses the timers. The voices
 * are mixed at the GF1's own rate (617.4 kHz divided by the number of active voices, 44.1 kHz for up to 14) and resampled. */
#include "host.h"
#include "audio.h"
#include <math.h>

#define NVOICES 32
#define DRAM_SIZE (1024 * 1024)

struct voice {
    uint8_t wave_ctrl, vol_ctrl, pan;
    uint16_t fc;
    uint32_t start, end, cur;           /* 1/512 sample units: sample index = value >> 9 */
    uint8_t ramp_rate, ramp_start, ramp_end;
    uint16_t vol;                       /* 16-bit accumulator: the top 12 bits are the logarithmic volume */
    uint32_t ramp_counter;
    int running_wave, running_vol;
    int wave_irq, vol_irq;
};

static struct voice v[NVOICES];
static uint8_t *dram;
static int base = 0x240, irq1 = 5, irq2 = 5, dma1 = 1, dma2 = 1;
static int cur_voice, reg_select;
static uint16_t reg_data;
static uint32_t dram_addr;
static int active_voices = 14;
static uint8_t reset_reg, mix_ctrl, irq_dma_ctrl, dma_ctrl;
static uint16_t dma_start;
static uint8_t timer_ctrl;                          /* GF1 register 45h: timer IRQ enables */
static uint8_t tmr_val[2], tmr_run[2], tmr_mask[2], tmr_flag[2], tmr_cmd_reg, tmr_status;
static int64_t tmr_expiry[2];
static int dma_irq, dma_tc;
static double native_phase;
static int cur_l, cur_r, prev_l, prev_r;
static float vol_table[4096];
static float pan_left[16], pan_right[16];
static int initialised;
static int64_t last_wave_irq_ns;           /* when a voice last raised its wave interrupt */
static uint32_t voice_writes[NVOICES];     /* NHL95_TRACE: voice register writes per voice */

/* Timing facts of the stream, appended to nhl95-audio.log every 10 s while the card is being used (see gus_diag_flush). The game's
 * driver refills one half of a 2 KB ring when the other half has been played; a refill that comes later than the half takes to
 * play (23 ms) replays old music. */
static struct {
    uint32_t refills, lat[10], overlap, underrun_frames, stalls;
    uint32_t n_starts, n_ramps, n_wave_irq, n_vol_irq;       /* native voices (2 and up) */
    int n_max_run;
    double lat_max_ms, gap_max_ms;
} dg;

static uint32_t addr_for(const struct voice *vo, uint32_t a)
{
    uint32_t s = a >> 9;
    if (vo->wave_ctrl & 4) s = (s & 0xC0000) | ((s & 0x1FFFF) << 1);
    return s & (DRAM_SIZE - 1);
}

static void check_irq(void)
{
    int i, wave = 0, vol = 0;
    for (i = 0; i < NVOICES; i++) { if (v[i].wave_irq) wave = 1; if (v[i].vol_irq) vol = 1; }
    if (((timer_ctrl & 4) && tmr_flag[0]) || ((timer_ctrl & 8) && tmr_flag[1]) || wave || vol || dma_irq) {
        if ((reset_reg & 4) && (mix_ctrl & 8)) irq_raise(irq1);
    }
}

static void timers_update(void)
{
    int64_t now = plat_now_ns();
    int i;
    for (i = 0; i < 2; i++) {
        int64_t p;
        if (!tmr_run[i]) continue;
        p = (256 - tmr_val[i]) * (i ? 320000 : 80000);
        while (now >= tmr_expiry[i]) {
            if (!tmr_mask[i]) tmr_status |= (i ? 0x20 : 0x40) | 0x80;
            tmr_flag[i] = 1;
            tmr_expiry[i] += p;
        }
    }
    check_irq();
}

static uint32_t irq_status(void)
{
    uint32_t s = 0;
    int i;
    timers_update();
    if ((timer_ctrl & 4) && tmr_flag[0]) s |= 0x04;
    if ((timer_ctrl & 8) && tmr_flag[1]) s |= 0x08;
    for (i = 0; i < NVOICES; i++) { if (v[i].wave_irq) s |= 0x20; if (v[i].vol_irq) s |= 0x40; }
    if (dma_irq) s |= 0x80;
    return s;
}

static void voice_reset(struct voice *vo)
{
    memset(vo, 0, sizeof *vo);
    vo->wave_ctrl = vo->vol_ctrl = 1;           /* stopped */
    vo->pan = 7;
}

static void gf1_reset(void)
{
    int i;
    for (i = 0; i < NVOICES; i++) voice_reset(&v[i]);
    dma_irq = 0; timer_ctrl = 0; tmr_flag[0] = tmr_flag[1] = 0;
}

/* ---- the register file ---- */
static void write_reg(int reg, uint16_t d)
{
    struct voice *vo = &v[cur_voice];
    if (reg < 0x10) voice_writes[cur_voice]++;
    if (trace_on && reg < 0x10 && cur_voice < 2) TRACE("gus: %.3f v%d reg %02x = %04x\n", plat_now_ns() / 1e9, cur_voice, reg, d);
    switch (reg) {
    case 0x00: vo->wave_ctrl = (d >> 8) & 0x7F; vo->running_wave = !(vo->wave_ctrl & 3);
        if (cur_voice >= 2 && !(vo->wave_ctrl & 3)) dg.n_starts++;
        vo->wave_irq = (d >> 8) & 0x80 ? 1 : 0;     /* bit 7 is the interrupt: written clear it acknowledges it, written set it raises it */
        check_irq(); break;
    case 0x01: vo->fc = d; break;
    case 0x02: vo->start = (vo->start & 0x0000FFFF) | ((uint32_t)(d & 0x1FFF) << 16); break;
    case 0x03: vo->start = (vo->start & 0xFFFF0000) | d; break;
    case 0x04: vo->end = (vo->end & 0x0000FFFF) | ((uint32_t)(d & 0x1FFF) << 16); break;
    case 0x05: vo->end = (vo->end & 0xFFFF0000) | d; break;
    case 0x06: vo->ramp_rate = d >> 8; break;
    case 0x07: vo->ramp_start = d >> 8; break;
    case 0x08: vo->ramp_end = d >> 8; break;
    case 0x09: vo->vol = d; break;
    case 0x0A: vo->cur = (vo->cur & 0x0000FFFF) | ((uint32_t)(d & 0x1FFF) << 16); break;
    case 0x0B: vo->cur = (vo->cur & 0xFFFF0000) | d; break;
    case 0x0C: vo->pan = (d >> 8) & 15; break;
    case 0x0D: vo->vol_ctrl = (d >> 8) & 0x7F; vo->running_vol = !(vo->vol_ctrl & 3); vo->ramp_counter = 0;
        if (cur_voice >= 2 && !(vo->vol_ctrl & 3)) dg.n_ramps++;
        vo->vol_irq = (d >> 8) & 0x80 ? 1 : 0;      /* the same for the volume ramp */
        check_irq(); break;
    case 0x0E: active_voices = ((d >> 8) & 0x3F) + 1; if (active_voices < 14) active_voices = 14; if (active_voices > 32) active_voices = 32; break;
    case 0x41: dma_ctrl = d >> 8; if (!(dma_ctrl & 1)) break;
        /* a DMA transfer of the channel's block into sample RAM */
        {
            int ch = (dma_ctrl & 4) ? dma2 : dma1;
            uint32_t dest = (dma_ctrl & 4) ? ((((uint32_t)dma_start & 0xC000) << 4) | (((uint32_t)dma_start & 0x1FFF) << 5)) : (uint32_t)dma_start << 4;
            uint32_t n = dma_remaining(ch), i;
            uint8_t *src = (uint8_t *)dma_address(ch);
            if (dma_ctrl & 2) break;                    /* sample RAM to memory: not used */
            if (n > DRAM_SIZE) n = DRAM_SIZE;
            for (i = 0; i < n && dest + i < DRAM_SIZE; i++) {
                uint8_t b = src[i];
                /* unsigned data to signed: invert the sign bit of each sample, which for 16-bit data (bit 6) is the top bit of the high
                 * (odd) byte only */
                if ((dma_ctrl & 0x80) && (!(dma_ctrl & 0x40) || ((dest + i) & 1))) b ^= 0x80;
                dram[dest + i] = b;
            }
            dma_advance(ch, n);
            dma_tc = 1;
            if (dma_ctrl & 0x20) { dma_irq = 1; check_irq(); }
            if (n == 1024) {                            /* a refill of the stream: how late after the interrupt, was the half still being played? */
                int j, playing = -1, b;
                double lat = (plat_now_ns() - last_wave_irq_ns) / 1e6;
                for (j = 0; j < NVOICES; j++)
                    if (!(v[j].wave_ctrl & 3)) { uint32_t pa = addr_for(&v[j], v[j].cur); if (pa >= dest && pa < dest + n) playing = j; }
                b = (int)(lat / 4); if (b > 9) b = 9; if (b < 0) b = 0;
                dg.refills++; dg.lat[b]++; if (playing >= 0) dg.overlap++; if (lat > dg.lat_max_ms) dg.lat_max_ms = lat;
            }
            if (trace_on) {                             /* how late was the refill, and was the half still being played? */
                int j, playing = -1;
                for (j = 0; j < NVOICES; j++)
                    if (!(v[j].wave_ctrl & 3)) { uint32_t pa = addr_for(&v[j], v[j].cur); if (pa >= dest && pa < dest + n) playing = j; }
                double sum = 0;
                uint32_t k, same = 0;
                static uint8_t prev_block[2048];
                for (k = 0; k + 1 < n && k < 2046; k += 2) { int smp = (int16_t)(dram[dest + k] | (dram[dest + k + 1] << 8)); sum += (double)smp * smp; }
                for (k = 0; k < n && k < 2048; k++) same += dram[dest + k] == prev_block[k];
                memcpy(prev_block, dram + dest, n < 2048 ? n : 2048);
                TRACE("gus: dma %u bytes to %05x control %02x, %.1f ms after the last wave interrupt, voice playing it: %d, block rms %.0f, %u of %u bytes as in the previous block\n",
                      n, dest, dma_ctrl, (plat_now_ns() - last_wave_irq_ns) / 1e6, playing, sqrt(sum / (n / 2 ? n / 2 : 1)), same, n);
            }
        }
        break;
    case 0x42: dma_start = d; break;
    case 0x43: dram_addr = (dram_addr & 0xFF0000) | d; break;
    case 0x44: dram_addr = (dram_addr & 0x00FFFF) | ((uint32_t)(d >> 8) << 16); break;
    case 0x45: timer_ctrl = d >> 8; if (!(timer_ctrl & 4)) tmr_flag[0] = 0; if (!(timer_ctrl & 8)) tmr_flag[1] = 0; break;
    case 0x46: tmr_val[0] = d >> 8; break;
    case 0x47: tmr_val[1] = d >> 8; break;
    case 0x4C:
        reset_reg = d >> 8;
        if (!(reset_reg & 1)) gf1_reset();
        break;
    }
    if (reg < 0x10 && vo->wave_ctrl == 0xFF) vo->wave_ctrl = 0;
}

static uint16_t read_reg(int reg)
{
    struct voice *vo = &v[cur_voice];
    uint8_t c;
    switch (reg) {
    case 0x80: c = vo->wave_ctrl | (vo->wave_irq ? 0x80 : 0); vo->wave_irq = 0; check_irq(); return c << 8;
    case 0x81: return vo->fc;
    case 0x82: return (vo->start >> 16) & 0x1FFF;
    case 0x83: return vo->start & 0xFFFF;
    case 0x84: return (vo->end >> 16) & 0x1FFF;
    case 0x85: return vo->end & 0xFFFF;
    case 0x86: return vo->ramp_rate << 8;
    case 0x87: return vo->ramp_start << 8;
    case 0x88: return vo->ramp_end << 8;
    case 0x89: return vo->vol;
    case 0x8A: return (vo->cur >> 16) & 0x1FFF;
    case 0x8B: return vo->cur & 0xFFFF;
    case 0x8C: return vo->pan << 8;
    case 0x8D: c = vo->vol_ctrl | (vo->vol_irq ? 0x80 : 0); vo->vol_irq = 0; check_irq(); return c << 8;
    case 0x8E: return (0xC0 | (active_voices - 1)) << 8;
    case 0x8F: {                                    /* which voice has an interrupt */
        int i;
        uint8_t r = 0xE0;                           /* bits 7 and 6 set: nothing pending */
        for (i = 0; i < NVOICES; i++)
            if (v[i].wave_irq || v[i].vol_irq) {
                r = 0xE0 | i;
                if (v[i].wave_irq) r &= ~0x80;      /* both bits are active low: bit 7 clear = the voice's wavetable interrupt, */
                if (v[i].vol_irq) r &= ~0x40;       /* bit 6 clear = its volume ramp interrupt */
                /* The chip queues the interrupts and reading this register takes the reported one off the queue: the SDK's handler
                 * does not touch the voice's own control registers to acknowledge, it reads this one and loops while the status
                 * port (2x6) still shows a pending interrupt. */
                v[i].wave_irq = v[i].vol_irq = 0;
                check_irq();
                break;
            }
        return r << 8;
    }
    case 0x41: c = dma_ctrl & ~0x40; if (dma_irq) c |= 0x40; dma_irq = 0; check_irq(); return c << 8;
    case 0x45: return timer_ctrl << 8;
    case 0x49: return 0;
    case 0x4C: return reset_reg << 8;
    case 0x43: return dram_addr & 0xFFFF;
    case 0x44: return (dram_addr >> 16) << 8;
    }
    return 0;
}

/* ---- mixing ---- */
static void step_voice(struct voice *vo, int *l, int *r)
{
    int s, ls, rs;
    float gain;
    uint32_t a;
    /* the volume ramp */
    if (vo->running_vol) {
        uint32_t period = 1u << (3 * (vo->ramp_rate >> 6));
        if (++vo->ramp_counter >= period) {
            int inc = vo->ramp_rate & 63;
            int up = !(vo->vol_ctrl & 0x40);
            /* The rate is added in steps of the 12-bit volume index (the register holds it in the top 12 of 16 bits), so in register
             * units the step is 16 times the rate value; adding it to the whole register made the envelopes 16 times too slow (the
             * release of a note never finished and the voice was never freed: the anthem's notes sustained and later ones had no voice). */
            int32_t nv = vo->vol + (up ? inc : -inc) * 16;
            int lo = vo->ramp_start << 8, hi = vo->ramp_end << 8;
            vo->ramp_counter = 0;
            vo->vol = nv < 0 ? 0 : nv > 0xFFFF ? 0xFFFF : nv;
            if ((up && nv >= hi) || (!up && nv <= lo)) {
                if (vo->vol_ctrl & 8) {                     /* loop */
                    if (vo->vol_ctrl & 0x10) vo->vol_ctrl ^= 0x40;
                    else vo->vol = up ? lo : hi;
                } else { vo->vol_ctrl |= 1; vo->running_vol = 0; vo->vol = up ? hi : lo; }
                if (vo->vol_ctrl & 0x20) { vo->vol_irq = 1; if (vo >= &v[2]) dg.n_vol_irq++; }
            }
        }
    }
    if (vo->wave_ctrl & 3) { *l = *r = 0; return; }
    /* the sample */
    a = addr_for(vo, vo->cur);
    if (vo->wave_ctrl & 4) s = (int16_t)(dram[a] | (dram[(a + 1) & (DRAM_SIZE - 1)] << 8));
    else s = (int8_t)dram[a] * 256;
    gain = vol_table[vo->vol >> 4];
    ls = (int)(s * gain * pan_left[vo->pan & 15]);          /* constant power across the 16 positions (the same law as DOSBox) */
    rs = (int)(s * gain * pan_right[vo->pan & 15]);
    *l = ls; *r = rs;
    /* advance */
    {
        int32_t add = vo->fc >> 1;
        int backward = vo->wave_ctrl & 0x40;
        int32_t cur = (int32_t)vo->cur;
        cur += backward ? -add : add;
        vo->cur = (uint32_t)cur;
        if (!backward && vo->cur >= vo->end) {
            if (vo->wave_ctrl & 8) {
                if (vo->wave_ctrl & 0x10) { vo->wave_ctrl |= 0x40; vo->cur = vo->end - (vo->cur - vo->end); }
                else vo->cur = vo->start + (vo->cur - vo->end);
            } else { vo->wave_ctrl |= 1; vo->running_wave = 0; vo->cur = vo->end; }
            if (vo->wave_ctrl & 0x20) { vo->wave_irq = 1; last_wave_irq_ns = plat_now_ns(); if (vo >= &v[2]) dg.n_wave_irq++; }
        } else if (backward && (int32_t)vo->cur <= (int32_t)vo->start) {
            if (vo->wave_ctrl & 8) {
                if (vo->wave_ctrl & 0x10) { vo->wave_ctrl &= ~0x40; vo->cur = vo->start + (vo->start - vo->cur); }
                else vo->cur = vo->end - (vo->start - vo->cur);
            } else { vo->wave_ctrl |= 1; vo->running_wave = 0; vo->cur = vo->start; }
            if (vo->wave_ctrl & 0x20) { vo->wave_irq = 1; last_wave_irq_ns = plat_now_ns(); if (vo >= &v[2]) dg.n_wave_irq++; }
        }
    }
}

static void gus_report(void)            /* NHL95_TRACE: what the voices are doing, once a second */
{
    int j, n = 0;
    char line[600] = "";
    for (j = 0; j < NVOICES; j++) {
        struct voice *vo = &v[j];
        if (!(vo->wave_ctrl & 3) && n < 12)
            n += sprintf(line + strlen(line), " [v%d fc=%04x vol=%04x pan=%d cur=%07x end=%07x ctl=%02x]", j, vo->fc, vo->vol, vo->pan, vo->cur, vo->end, vo->wave_ctrl) > 0;
    }
    {
        char w[300] = "";
        int k;
        for (k = 0; k < NVOICES; k++) if (voice_writes[k]) sprintf(w + strlen(w), " v%d:%u", k, voice_writes[k]);
        fprintf(stderr, "gus: register writes so far:%s\n", w);
    }
    fprintf(stderr, "gus: active voices %d, running:%s\n", active_voices, line[0] ? line : " none");
}

/* The card runs by the clock, not by the audio device: its timers, voice end and volume ramp interrupts are what the game's music
 * driver paces itself with, and the audio device asks for samples in bursts of 20 ms or more, which made them (and so the tempo)
 * arrive in lumps. gus_pump_locked steps the voices for the time that has passed and queues the output samples (at the card's own
 * rate, 617400 / voices Hz); gus_render only resamples the queue. It runs with the audio lock held: from the mixer, from the main
 * loop (gus_pump) and when the game reads a GUS port. */
#define GFIFO 4096
static int16_t gfifo_l[GFIFO], gfifo_r[GFIFO];
static uint32_t gfifo_head, gfifo_tail;
static int64_t gpump_last_ns;
static double gpump_acc;

static void gus_pump_locked(void)
{
    int64_t now = plat_now_ns(), dt = now - gpump_last_ns;
    double due;
    int n, i, j;
    gpump_last_ns = now;
    if (dt / 1e6 > dg.gap_max_ms) dg.gap_max_ms = dt / 1e6;
    if (dt > 30000000LL) dg.stalls++;                           /* nobody pumped the card for 30 ms */
    timers_update();
    if (dt > 100000000LL) dt = 100000000LL;                     /* after a long stall: do not play it all at once */
    due = gpump_acc + dt * (617400.0 / active_voices) / 1e9;
    n = (int)due;
    gpump_acc = due - n;
    for (i = 0; i < n; i++) {
        int sl = 0, sr = 0;
        for (j = 0; j < active_voices; j++) {
            int l, r;
            step_voice(&v[j], &l, &r);
            sl += l; sr += r;
        }
        if (gfifo_head - gfifo_tail >= GFIFO) gfifo_tail++;       /* full: the oldest is dropped */
        /* the voices are added as they are (a card does not divide): saturate instead */
        gfifo_l[gfifo_head % GFIFO] = (int16_t)(sl > 32767 ? 32767 : sl < -32768 ? -32768 : sl);
        gfifo_r[gfifo_head % GFIFO] = (int16_t)(sr > 32767 ? 32767 : sr < -32768 ? -32768 : sr);
        gfifo_head++;
        check_irq();
    }
    {                                                           /* how many native voices are running now */
        int run = 0;
        for (j = 2; j < NVOICES; j++) if (!(v[j].wave_ctrl & 3)) run++;
        if (run > dg.n_max_run) dg.n_max_run = run;
    }
}

static void gus_diag_flush(void)
{
    static int64_t last;
    int64_t now = plat_now_ns();
    if (!last) last = now;
    if (now - last < 10000000000LL) return;
    last = now;
    if (dg.n_starts || dg.n_ramps || dg.n_wave_irq || dg.n_vol_irq)
        audio_log("GUS native voices (2 and up), last 10 s: %u started, %u volume ramps started, %u wave end interrupts, %u volume ramp end interrupts, most running at once %d",
                  dg.n_starts, dg.n_ramps, dg.n_wave_irq, dg.n_vol_irq, dg.n_max_run);
    if (dg.refills) {
        audio_log("GUS stream, last 10 s: %u refills; refill delay after the interrupt (ms, 4 ms steps, 40+ last): %u %u %u %u %u %u %u %u %u %u, max %.1f; "
                  "refills while the half was still playing: %u; samples missing in the queue: %u; longest gap between pumps %.1f ms, gaps over 30 ms: %u",
                  dg.refills, dg.lat[0], dg.lat[1], dg.lat[2], dg.lat[3], dg.lat[4], dg.lat[5], dg.lat[6], dg.lat[7], dg.lat[8], dg.lat[9],
                  dg.lat_max_ms, dg.overlap, dg.underrun_frames, dg.gap_max_ms, dg.stalls);
        memset(&dg, 0, sizeof dg);
    }
}

void gus_pump(void)                     /* any thread; takes the audio lock */
{
    if (!initialised) return;
    audio_lock();
    gus_pump_locked();
    gus_diag_flush();
    audio_unlock();
}

static void gus_render(int32_t *out, int frames, int rate)
{
    double native = 617400.0 / active_voices;
    static int report_frames;
    int i;
    if (trace_on && (report_frames += frames) >= rate) { report_frames = 0; gus_report(); }
    gus_pump_locked();
    for (i = 0; i < frames; i++) {
        double t;
        native_phase += native / rate;
        while (native_phase >= 1.0) {
            native_phase -= 1.0;
            prev_l = cur_l; prev_r = cur_r;
            if (gfifo_tail != gfifo_head) { cur_l = gfifo_l[gfifo_tail % GFIFO]; cur_r = gfifo_r[gfifo_tail % GFIFO]; gfifo_tail++; }
            else if (dg.refills) dg.underrun_frames++;  /* an empty queue repeats the last sample (the pump did not keep up) */
        }
        t = native_phase;                       /* the part of the native sample period since the last one was taken: ramp from the previous */
        out[2 * i] += (int32_t)(prev_l + (cur_l - prev_l) * t);          /* sample to this one (one sample of delay) */
        out[2 * i + 1] += (int32_t)(prev_r + (cur_r - prev_r) * t);
    }
}

void gus_init(int b, int i1, int i2, int d1, int d2)
{
    int i;
    base = b; irq1 = i1; irq2 = i2; dma1 = d1; dma2 = d2;
    dram = calloc(1, DRAM_SIZE);
    for (i = 0; i < 16; i++) {                  /* position 0 is hard left, 7 the middle (both at 0.707), 15 hard right */
        double norm = (i - 7.0) / (i < 7 ? 7 : 8), angle = (norm + 1) * 3.14159265358979 / 4;
        pan_left[i] = (float)cos(angle);
        pan_right[i] = (float)sin(angle);
    }
    for (i = 0; i < 4096; i++) vol_table[i] = (float)((256 + (i & 255)) * (double)(1u << (i >> 8)) / 16777216.0);
    for (i = 0; i < NVOICES; i++) voice_reset(&v[i]);
    audio_add_source(gus_render);
    gpump_last_ns = plat_now_ns();
    initialised = 1;
}

int gus_base(void) { return base; }

uint32_t gus_in(unsigned port)
{
    uint32_t r = 0xFF;
    audio_lock();
    switch (port - base) {
    case 0x006: gus_pump_locked(); r = irq_status(); break;
    case 0x008: gus_pump_locked(); r = tmr_status; break;
    case 0x00A: r = tmr_cmd_reg; break;           /* reads back what was written to base+8: the card detection of the GF1 SDK relies on it */
    case 0x102: r = cur_voice; break;
    case 0x103: r = reg_select; break;
    case 0x104: if (reg_select >= 0x80) gus_pump_locked(); reg_data = read_reg(reg_select); r = reg_data & 0xFF; break;
    case 0x105: r = read_reg(reg_select) >> 8; break;
    case 0x107: r = dram[dram_addr & (DRAM_SIZE - 1)]; break;
    }
    audio_unlock();
    return r;
}

void gus_out(unsigned port, uint32_t val)
{
    audio_lock();
    switch (port - base) {
    case 0x000: mix_ctrl = val; check_irq(); break;
    case 0x008: tmr_cmd_reg = val; break;
    case 0x009:
        if (tmr_cmd_reg == 2) tmr_val[0] = val;
        else if (tmr_cmd_reg == 3) tmr_val[1] = val;
        else if (tmr_cmd_reg == 4) {
            if (val & 0x80) { tmr_status = 0; tmr_flag[0] = tmr_flag[1] = 0; }
            else {
                int64_t now = plat_now_ns();
                tmr_mask[0] = (val >> 6) & 1; tmr_mask[1] = (val >> 5) & 1;
                if ((val & 1) && !tmr_run[0]) tmr_expiry[0] = now + (256 - tmr_val[0]) * 80000;
                if ((val & 2) && !tmr_run[1]) tmr_expiry[1] = now + (256 - tmr_val[1]) * 320000;
                tmr_run[0] = val & 1; tmr_run[1] = (val >> 1) & 1;
            }
        }
        break;
    case 0x00B: irq_dma_ctrl = val; break;
    case 0x102: cur_voice = val & 31; break;
    case 0x103: reg_select = val; reg_data = 0; break;
    case 0x104: reg_data = (reg_data & 0xFF00) | (val & 0xFF); break;
    case 0x105: reg_data = (reg_data & 0x00FF) | ((val & 0xFF) << 8); write_reg(reg_select, reg_data); break;
    case 0x107: dram[dram_addr & (DRAM_SIZE - 1)] = val; break;
    }
    audio_unlock();
}
