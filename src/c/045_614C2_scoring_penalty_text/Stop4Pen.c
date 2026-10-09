/* Scoring / penalties: stop play for a penalty (93G Stop4Pen). */
#include "nhl95.h"

/* Stop4Pen (63543) - 93G Stop4Pen: stop play for penalty entry n of PenBuf (penalty, player). Unless already
   stopped (gmode bit 0): pick the faceoff spot fox / foy - centre for 7, the last touch (ltx / lty) for 3 / 1Dh,
   else the puck; for 8 (offside-like) the nearer end dot (y +-4Eh) when inside the blue lines, for 6 the
   offender's end (y -258h / 258h); the penalty shot spot when penshotstart. Clamp x to +-60h and pull deep spots
   to the end dots (+-60h, y +-B8h); then for every queued penalty move the dot out of the offender's zone (y -3Dh /
   3Dh, x +-100). Then Pencntdwn 0, gmode bit 2, the whistle (sfx A4h) and the ref (SetPA 5). */
void Stop4Pen(short n)
{
    signed char pen;
    signed char pl;
    short i;
    Player *o;

    pen = PenBuf[n * 2];
    pl = PenBuf_pl[n * 2];
    if (!(gmode & 1)) {
        gmode |= 1;
        fox = foy = 0;
        if (pen != 7) {
            fox = ltx;
            foy = lty;
            if (pen != 3 && pen != 0x1D) {
                fox = *puckx;
                foy = *pucky;
                if (pen == 8) {
                    if (ABS(foy) < 0x4E) foy = foy < 0 ? -0x4E : 0x4E;
                } else if (pen == 6) {
                    o = &SortCords[pl];
                    foy = o->pflags & 0x80 ? -0x258 : 0x258;
                }
            }
        }
        if (penshotstart) {
            fox = penshotfox;
            foy = penshotfoy;
        }
        if (fox >= 0x60) fox = 0x60;
        else if (fox <= -0x60) fox = -0x60;
        if (foy >= 0x90) {
            fox = fox < 0 ? -0x60 : 0x60;
            foy = 0xB8;
        } else if (foy <= -0x90) {
            fox = fox < 0 ? -0x60 : 0x60;
            foy = -0xB8;
        }
        i = 0;
        do {
            o = &SortCords[(signed char)(PenBuf_pl[i * 2] & 0x7F)];
            if (!(o->pflags & 0x80)) {
                if (foy <= -0x4E) {
                    foy = -0x3D;
                    fox = fox < 0 ? -100 : 100;
                }
            } else if (foy >= 0x4E) {
                foy = 0x3D;
                fox = fox < 0 ? -100 : 100;
            }
            i++;
        } while (PenBuf[i * 2]);
    }
    Pencntdwn = 0;
    gmode |= 4;
    sfx(0xA4);
    SetPA(5);
}
