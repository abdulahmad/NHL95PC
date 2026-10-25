/* Where the sound hardware sits on the ISA bus. The addresses and IRQs come from the BLASTER and ULTRASND variables of the host's
 * environment (as a DOS machine would have them), with the usual defaults; NHL95_SOUND=none leaves the machine silent. */
#include "host.h"
#include "audio.h"
#include <ctype.h>

static int sb_b = 0x220, mpu_b = 0x330, gus_b = 0x240;
static int have_sb, have_mpu, have_gus;

static int hexopt(const char *env, char key, int def, int base)
{
    const char *p = env;
    while (p && *p) {
        if (toupper((unsigned char)*p) == key && (p == env || p[-1] == ' ')) return (int)strtol(p + 1, 0, base);
        while (*p && *p != ' ') p++;
        while (*p == ' ') p++;
    }
    return def;
}

void sound_init(void)
{
    const char *blaster = getenv("BLASTER"), *ultra = getenv("ULTRASND"), *none = getenv("NHL95_SOUND");
    int irq = 7, dma = 1, type = 3, version = 0x0302;
    int gb = 0x240, gd1 = 1, gd2 = 1, gi1 = 5, gi2 = 5;
    audio_init();
    if (none && !strcmp(none, "none")) return;
    if (!blaster) blaster = "A220 I7 D1 T3";
    sb_b = hexopt(blaster, 'A', 0x220, 16);
    irq = hexopt(blaster, 'I', 7, 10);
    dma = hexopt(blaster, 'D', 1, 10);
    type = hexopt(blaster, 'T', 3, 10);
    mpu_b = hexopt(blaster, 'P', 0x330, 16);
    version = type == 1 ? 0x0105 : type == 2 ? 0x0201 : type >= 6 ? 0x0405 : 0x0302;
    sb_init(sb_b, irq, dma, version);
    have_sb = 1;
    mpu_init(mpu_b);
    have_mpu = 1;
    if (ultra) {
        gb = (int)strtol(ultra, 0, 16);
        sscanf(ultra, "%x,%d,%d,%d,%d", &gb, &gd1, &gd2, &gi1, &gi2);
    }
    gus_b = gb;
    gus_init(gb, gi1, gi2, gd1, gd2);
    have_gus = 1;
}

/* FM chip: the AdLib ports 388h-38Bh, and the Sound Blaster's at base+0..3 and base+8..9 */
int sound_port_in(unsigned port, uint32_t *v)
{
    if (have_sb && port >= (unsigned)sb_b && port < (unsigned)sb_b + 16) {
        unsigned o = port - sb_b;
        if (o < 4 || o == 8 || o == 9) *v = opl_in(o & 3);
        else *v = sb_in(port);
        return 1;
    }
    if (have_mpu && (port == (unsigned)mpu_b || port == (unsigned)mpu_b + 1)) { *v = mpu_in(port); return 1; }
    if (have_gus && ((port >= (unsigned)gus_b && port < (unsigned)gus_b + 16) || (port >= (unsigned)gus_b + 0x100 && port < (unsigned)gus_b + 0x108))) {
        *v = gus_in(port); return 1;
    }
    return 0;
}

int sound_port_out(unsigned port, uint32_t val)
{
    if (have_sb && port >= (unsigned)sb_b && port < (unsigned)sb_b + 16) {
        unsigned o = port - sb_b;
        if (o < 4 || o == 8 || o == 9) opl_out(o & 3, val);
        else sb_out(port, val);
        return 1;
    }
    if (have_mpu && (port == (unsigned)mpu_b || port == (unsigned)mpu_b + 1)) { mpu_out(port, val); return 1; }
    if (have_gus && ((port >= (unsigned)gus_b && port < (unsigned)gus_b + 16) || (port >= (unsigned)gus_b + 0x100 && port < (unsigned)gus_b + 0x108))) {
        gus_out(port, val); return 1;
    }
    return 0;
}
