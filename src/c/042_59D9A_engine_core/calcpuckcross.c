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
