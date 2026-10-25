/* The Yamaha OPL2/OPL3 FM chip of the AdLib (ports 388h-389h) and of the Sound Blaster (base+0..3 and base+8..9, mapped here by
 * sound_ports.c). The sound is made by Nuked OPL3; the two timers and the status flags the drivers use to detect the card are done
 * here against the clock. */
#include "host.h"
#include "audio.h"
#include "third_party/nuked-opl3/opl3.h"

static opl3_chip chip;
static unsigned latch[2];
static uint8_t status;
static uint8_t t_val[2], t_mask[2], t_run[2];
static int64_t t_expiry[2];
static const int64_t t_period_ns[2] = { 80000, 320000 };

static void timers_update(void)
{
    int64_t now = plat_now_ns();
    int i;
    for (i = 0; i < 2; i++) {
        int64_t p;
        if (!t_run[i]) continue;
        p = (256 - t_val[i]) * t_period_ns[i];
        while (now >= t_expiry[i]) {
            if (!t_mask[i]) status |= (i ? 0x20 : 0x40) | 0x80;
            t_expiry[i] += p;
        }
    }
}

static void write_reg(unsigned array, unsigned reg, uint8_t val)
{
    if (!array) {
        if (reg == 2 || reg == 3) { t_val[reg - 2] = val; return; }
        if (reg == 4) {
            if (val & 0x80) { status = 0; return; }
            t_mask[0] = (val >> 6) & 1;
            t_mask[1] = (val >> 5) & 1;
            timers_update();
            if ((val & 1) && !t_run[0]) t_expiry[0] = plat_now_ns() + (256 - t_val[0]) * t_period_ns[0];
            if ((val & 2) && !t_run[1]) t_expiry[1] = plat_now_ns() + (256 - t_val[1]) * t_period_ns[1];
            t_run[0] = val & 1;
            t_run[1] = (val >> 1) & 1;
            return;
        }
    }
    OPL3_WriteRegBuffered(&chip, (array << 8) | reg, val);
}

static void opl_render(int32_t *out, int frames, int rate)
{
    int i;
    (void)rate;
    for (i = 0; i < frames; i++) {
        int16_t s[2];
        OPL3_GenerateResampled(&chip, s);
        out[2 * i] += s[0] * 3 / 5;
        out[2 * i + 1] += s[1] * 3 / 5;
    }
}

void opl_init(void)
{
    OPL3_Reset(&chip, audio_rate());
    audio_add_source(opl_render);
}

uint32_t opl_in(unsigned port)
{
    uint32_t v = 0;
    audio_lock();
    if ((port & 3) == 0 || (port & 3) == 2) { timers_update(); v = status; }
    audio_unlock();
    return v;
}

void opl_out(unsigned port, uint32_t val)
{
    audio_lock();
    switch (port & 3) {
    case 0: latch[0] = val & 0xFF; break;
    case 1: write_reg(0, latch[0], val); break;
    case 2: latch[1] = val & 0xFF; break;
    case 3: write_reg(1, latch[1], val); break;
    }
    audio_unlock();
}
