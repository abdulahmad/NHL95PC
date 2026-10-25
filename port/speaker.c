/* The PC speaker: PIT channel 2 (ports 42h, 43h) gated and enabled by port 61h. The game's PC beep driver programs a square wave. */
#include "host.h"
#include "audio.h"

static uint8_t port61;                  /* bit0: gate of channel 2, bit1: speaker enable */
static unsigned reload = 0x10000;       /* channel 2 divisor */
static int rw_state;                    /* 0: low byte next, 1: high byte next */
static unsigned lo;
static int mode = 3;
static int64_t reload_time;
static double phase;

static void speaker_render(int32_t *out, int frames, int rate)
{
    double step;
    int i;
    if ((port61 & 3) != 3 || mode != 3 || reload < 2) return;
    step = 1193182.0 / reload / rate;
    if (step >= 0.5) return;                  /* above half the output rate: inaudible */
    for (i = 0; i < frames; i++) {
        int32_t v = phase < 0.5 ? 2500 : -2500;
        out[2 * i] += v;
        out[2 * i + 1] += v;
        phase += step;
        if (phase >= 1.0) phase -= 1.0;
    }
}

void speaker_init(void)
{
    audio_add_source(speaker_render);
}

uint32_t speaker_in(unsigned port)
{
    static unsigned toggle;
    if (port == 0x61) {
        uint32_t v = port61 & 3;
        v |= (++toggle & 1) << 4;                                  /* the refresh bit toggles */
        v |= ((plat_now_ns() * 1193182 / 1000000000 / (reload ? reload : 1)) & 1) << 5;   /* channel 2 output */
        return v;
    }
    if (port == 0x42) {                                            /* the running count of channel 2 */
        uint64_t ticks = (uint64_t)(plat_now_ns() - reload_time) * 1193182 / 1000000000;
        return (reload - (unsigned)(ticks % reload)) & 0xFF;
    }
    return 0xFF;
}

void speaker_out(unsigned port, uint32_t val)
{
    audio_lock();
    if (port == 0x61) port61 = val & 3;
    else if (port == 0x43 && (val >> 6) == 2) { mode = (val >> 1) & 7; if (mode > 5) mode &= 3; rw_state = 0; }
    else if (port == 0x42) {
        if (!rw_state) { lo = val & 0xFF; rw_state = 1; }
        else { reload = (val << 8) | lo; if (!reload) reload = 0x10000; rw_state = 0; reload_time = plat_now_ns(); }
        TRACE("speaker divisor %u\n", reload);
    }
    audio_unlock();
}
