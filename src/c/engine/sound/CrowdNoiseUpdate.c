/* Engine sound interface: crowd volume. */
#define sub_8FD84 sub_8FD84_decl
#define sub_8FDE5 sub_8FDE5_decl
#define sub_8FE1C sub_8FE1C_decl
#include "nhl95.h"
#undef sub_8FD84
#undef sub_8FDE5
#undef sub_8FE1C

void sub_8FD84(int card, int voice, int vol);
void sub_8FE1C(int card, int voice, int what);
void sub_8FDE5(int card, int voice, int what);

/* CrowdNoiseUpdate: with sound effects and a crowd device (sounddev & 2Ah), ease crowdsmooth toward
 crowdlevel by at most n*30, map that to voice 8 and voice 7, and start or silence those voices.
 n is a signed step. */
void CrowdNoiseUpdate(int n)
{
    int step;
    int v;
    int pan;
    int lim;

    if (!gameopts.sfx) return;
    if (!(sounddev & 0x2A)) return;
    n = (short)n;
    step = n;
    step <<= 4;
    step -= n;
    step += step;
    v = *(int *)((char *)&crowdlevel - 2) >> 16;
    v -= crowdsmooth;
    if ((v < 0 ? -v : v) > step) {
        if (v < 0) step = -step;
        crowdsmooth += step;
    } else
        crowdsmooth = *(int *)((char *)&crowdlevel - 2) >> 16;
    v = crowdsmooth;
    if (v < 0x200)
        v = 0;
    else if (v < 0x390) {
        v = (v - 0x200) / 10;
        if (sounddev & 8) v += 0x20;
    } else {
        n = (v - 0x390) >> 2;
        v = n + 0x28;
        if (sounddev & 8) v += 0x20;
    }
    if (v > 0x7F) v = 0x7F;
    step = crowdsmooth / 12 + 0x0A;
    if (sounddev & 8) step += 0x32;
    if (step > 0x7F) step = 0x7F;
    if (step < 0x0A) step = 0x0A;
    if (crowdvol8 > 0 && v == 0) {
        sub_8FDB2(byte_D2439, 8, 0);
        sub_8FE4F(byte_D2439, 8, 0x24);
    } else if (crowdvol8 == 0 && v > 0) {
        sub_8FD84(byte_D2439, 8, 0x7D);
        sub_8FE1C(byte_D2439, 8, 0x24);
        sub_8FDE5(byte_D2439, 8, 0x40);
    }
    if (v > 0) {
        sub_8FDB2(byte_D2439, 8, v);
        if (v >= 0x7F || crowdvol8 >= 0x7F)
            sub_8FDE5(byte_D2439, 8, 0x40 - (v >= 0x7F ? (short)randomd0(6) : 0));
    }
    crowdvol8 = v;
    if (crowdvol7 == 0 && step > 0) {
        sub_8FD84(byte_D2439, 7, 0x7E);
        sub_8FE1C(byte_D2439, 7, 0x24);
    }
    sub_8FDB2(byte_D2439, 7, step);
    pan = step / 3 + 0x20;
    if (sounddev & 8)
        lim = 0x32;
    else
        lim = 0;
    lim += 0x0A;
    if (step == lim)
        pan += (short)randomd0(6);
    sub_8FDE5(byte_D2439, 7, pan);
    crowdvol7 = step;
}
