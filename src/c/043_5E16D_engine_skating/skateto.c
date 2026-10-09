/* Skating: skate to a point (93G logic93_5 skateto). */
#include "nhl95.h"

/* skateto (5E93B) - player p skates to the point regd0/regd1 (93G logic93_5 skateto, a0 = extra routine for
   collision avoidance, d0/d1 = x/y cord to skate to). evade = that routine (NULL = none).
   Only every 12/60 sec. (temp2 high byte countdown): avdgoal, aim with the velocity lead (position + high byte of
   the velocity), vtoa of the gap (9 = close enough: within 0Ch, and still moving on any axis that is farther),
   the evade routine, keep the direction in the temp2 low byte. No direction and stopped: turn one step toward the
   puck (or xc1/yc1 when the puck is in a fight). Then doplayeracc with the kept direction every tick. */
void skateto(Player *p, void (*evade)(Player *))
{
    int dx, dy, px, py;

    if (--TEMP2_TICKS(p) < 0) {                     /* only execute every 12/60 sec. */
        dx = regd0.w;
        dy = regd1.w;
        TEMP2_TICKS(p) += 0x0C;
        avdgoal(p);
        px = HIBYTE(p->Xvel) + HIWORD(p->Xpos);
        py = HIBYTE(p->Yvel) + HIWORD(p->Ypos);
        regd0.w -= px;
        regd1.w -= py;
        dx -= px;
        dy -= py;
        if (dx < 0) dx = -dx;
        if (dy < 0) dy = -dy;
        if (ABS(regd0.w) <= 0x0C && ABS(regd1.w) <= 0x0C && (dx <= 0x0C || p->Xvel != 0)
            && (dy <= 0x0C || p->Yvel != 0))
            regd0.w = 9;                            /* close enough: no direction */
        else
            regd0.w = vtoa(regd0.w, regd1.w);
        if (evade != NULL) evade(p);                /* jsr (a0) */
        TEMP2_DIR(p) = regd0.w;
        if (regd0.w > 7 && !(p->Xvel | p->Yvel)) {
            if (puckpflags2 & 1) {                  /* puck in a fight: face xc1/yc1 */
                regd0.w = xc1;
                regd1.w = yc1;
            } else {
                regd0.w = *puckx;
                regd1.w = *pucky;
            }
            regd0.w -= HIWORD(p->Xpos);
            regd1.w -= HIWORD(p->Ypos);
            regd0.w = p->facedir - vtoa(regd0.w, regd1.w);     /* face towards puck */
            if (regd0.w != 0)
                p->facedir = (p->facedir + ((regd0.w & 4) >> 1) - 1) & 7;
        }
    }
    doplayeracc(p, TEMP2_DIR(p));
}
