/* Engine core: calcpuckcross and the functions that end in its pop/ret tail (multi-block file, see cc.py). */
#include "nhl95.h"

/* calcpuckcross (5A341) - find puck crossing lines: when (if at all) the puck will cross each goal line
   (94G checks94 findpc). For the goal lines y = +E8h and -E8h: puckcross[0] = x where the puck crosses (bounced
   off the side boards at +-A0h), puckcross[1] = frames until it crosses (dy * 1000h / puckvy); [1] = -1 when it
   will not cross (no y velocity, moving away, or out of range). */
void calcpuckcross(void)
{
    short *pc;
    int goaly;
    short side;
    int t;
    int dy;
    short i;
    short x;

    pc = puckcross;
    goaly = 0xE8;                               /* goal line */
    side = 0xA0;                                /* side boards */
    for (i = 0; i < 2; goaly = -goaly, i++, pc += 2) {
        dy = (short)(goaly - *pucky);
        if (*puckvy != 0) {
            t = (dy << 12) / *puckvy;
            if (t >= 0 && t < 0x10000) {
                pc[1] = t;                      /* time until crossing in frames */
                t = *puckvx * dy / *puckvy;
                if (t < 0x10000) {
                    x = t + *puckx;
                    if (x >= 0xA0) x = side * 2 - x;     /* bounce off the side boards */
                    side = -side;
                    if (x <= side) x = side * 2 - x;
                    side = -side;
                    pc[0] = x;
                    continue;
                }
            }
        }
        pc[1] = -1;                             /* no cross */
    }
}

/* GetHot (5A425) - sprite hot spot (stick blade) of player p (94G checks94 GetHot). regd0/regd1 = the x/y bytes
   of the hot spot table (byte_CC148/byte_CC149, 2 bytes per frame) for the player's frame (word 12h, 94G frame;
   PC remaps frames 378h+ by -F4h and 2DAh+ by -46h, frames outside 0-283h/293h give 0,0); x is negated when the
   sprite is X-flipped (attribute bit 3). Draft: also gives the distance that makes reenergizeteam's exit a near
   jump into calcpuckcross's tail, as in the EXE. */
void GetHot(Player *p)
{
    short f;
    short x;

    regd1.w = regd0.w = 0;
    f = ((short *)p)[0x12 / 2];                 /* frame (structs.inc has no field at 12h yet) */
    if (f < 0 || f >= 0x468) return;
    if (f >= 0x378) f -= 0xF4;
    else if (f > 0x283) return;
    if (f >= 0x2DA) f -= 0x46;
    else if (f > 0x293) return;
    f += f;
    x = byte_CC148[f];
    regd0.w = x;
    regd1.w = byte_CC149[f];
    if (p->attribute & 8)                       /* X flip */
        regd0.w = -x;
}

/* reenergizeteam (5B826) - refill the energy of team t's whole roster (93G/94G reenergizeteam, penalty94):
   tmpde = 1000h for every player; a player marked -3 in tmpdst goes to the bench (tmpdst -2, roster status
   byte 3). The 94G skip of players at -4 is not in the PC code. */
void reenergizeteam(Team *t)
{
    short i;
    short *de;

    de = t->tmpde;
    for (i = 0; i < 28; i++) {
        *de++ = ENERGYMAX;                      /* full energy */
        if (t->tmpdst[i] == -3) {
            t->tmpdst[i] = PDbench;             /* on bench */
            t->tmroster[i * 0x27] = 3;          /* roster status: bench */
        }
    }
}
