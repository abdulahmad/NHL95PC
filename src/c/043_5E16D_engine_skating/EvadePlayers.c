/* Skating (043_5E16D_engine_skating): EvadePlayers ... StopNA in address order, as one source file because
   later functions end in an earlier one's pop/ret tail (multi-block file, see tools/cc.py). Functions of the
   segment that are still asm are missing; the ones here that do not match yet (EvadePlayers, skateto) are
   compiled for the layout but not spliced. */
#include "nhl95.h"

/* EvadePlayers (5E4C4) - PC-new skateto collision routine (the 93G a0 routine slot; 93G has only EvadePC).
   p = player (eax). Nothing when pflags2 bit 5 is set. Behind the net (|Ypos| > F2h, |Xpos| < 32h): regd0.w = a
   direction round the net from the Xpos / Yvel signs. Else for every other SortCords entry (0-14, not the goalies
   12/13, the puck only while nothing is closer than 50h): if the predicted x and y gaps (position + high byte of
   the velocity) are both within 28h and the closest so far, regd0.w = a sidestep direction from vtoa of the gap,
   turned away from the boards near the ends. Results in the 68k-register statics regd0.w (direction), regd1.w / regd2.w
   (|dy|, |dx|); no return value. */
void EvadePlayers(Player *p)
{
    Player *o;
    short i, best, dx, dy, pv, ov;
    int sum;

    if (p->pflags2 & 0x20) return;
    dy = ABS(HIWORD(p->Ypos));
    if (dy > 0xA2 && dy > 0xF2 && ABS(HIWORD(p->Xpos)) < 0x32) {      /* behind the net */
        if (HIWORD(p->Ypos) > 0) {
            if (p->Yvel > 0) regd0.w = HIWORD(p->Xpos) < 0 ? 7 : 1;
            else regd0.w = HIWORD(p->Xpos) < 0 ? 6 : 2;
        } else {
            if (p->Yvel < 0) regd0.w = HIWORD(p->Xpos) < 0 ? 5 : 3;
            else regd0.w = HIWORD(p->Xpos) < 0 ? 6 : 2;
        }
        return;
    }
    best = 0x64;
    for (o = SortCords, i = 0; i < 15; i++, o++) {
        if (i == 12 || i == 13) continue;               /* not the goalies */
        if (i == 14 && best <= 0x50) continue;          /* the puck only if nothing is close */
        regd2.w = dx = HIWORD(p->Xpos) - HIWORD(o->Xpos);
        pv = HIBYTE(p->Xvel);
        ov = HIBYTE(o->Xvel);
        regd2.w = dx + (pv - ov);                         /* predicted x gap */
        regd2.w = ABS(regd2.w);
        if (regd2.w > 0x28) continue;
        regd1.w = dy = HIWORD(p->Ypos) - HIWORD(o->Ypos);
        pv = HIBYTE(p->Yvel);
        ov = HIBYTE(o->Yvel);
        regd1.w = (pv - ov) + dy;                         /* predicted y gap */
        regd1.w = ABS(regd1.w);
        if (regd1.w > 0x28) continue;
        sum = regd2.w + regd1.w;
        if (best <= sum) continue;            /* closest so far? */
        best = regd2.w + regd1.w;
        regd0.w = vtoa(dx, dy);
        if (HIWORD(p->Xpos) < -0x82) {                  /* near the left end */
            if (regd0.w <= 4 || regd0.w >= 8) continue;
            regd0.w = o->Yvel != 0 ? 4 : 0;
        } else if (HIWORD(p->Xpos) > 0x82) {            /* near the right end */
            if (regd0.w <= 0 || regd0.w >= 4) continue;
            regd0.w = o->Yvel != 0 ? 4 : 0;
        } else if (HIWORD(p->Xpos) > -0x64 && HIWORD(p->Xpos) < 0) {
            if (regd0.w <= 0 || regd0.w >= 4) continue;
            regd0.w = 8 - regd0.w;
            if (regd0.w == 6 && o->Yvel != 0) regd0.w = (dy < 0) + 4;
            else regd0.w = dy > 0 ? 7 : 0;
        } else {
            if (HIWORD(p->Xpos) >= 0x64 || HIWORD(p->Xpos) < 0) continue;
            if (regd0.w <= 4 || regd0.w >= 8) continue;
            regd0.w = 8 - regd0.w;
            if (regd0.w == 2 && o->Yvel != 0) regd0.w = (dy >= 0) + 3;
            else regd0.w = dy > 0;
        }
    }
}

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

/* StopNA (5F82A) - 93G logic93_5 StopNA (stopna): slow player p by one step on each axis, with no animation
   change. The step is 200 + legstr (the goalie: 200 + 3 * legstr; 93G $96 = 150); a velocity that would cross
   zero is clamped to 0.
   Its tail is EvadePlayers' pop/ret (jmp EvadePlayers_popedi): wcc386 merges identical function tails inside
   one source file, so StopNA lives in this file, after the functions between them. */
void StopNA(Player *p)
{
    int str = p->legstr;
    int step = str + 200;               /* step 200+legstr (93G 150) */

    if (p->position == 0) {             /* goalie: +2*legstr */
        str += str;
        step += str;
    }
    if (p->Xvel < 0) {
        p->Xvel += step;
        if (p->Xvel > 0) p->Xvel = 0;
    } else {
        p->Xvel -= step;
        if (p->Xvel < 0) p->Xvel = 0;
    }
    if (p->Yvel < 0) {
        p->Yvel += step;
        if (p->Yvel > 0) p->Yvel = 0;
    } else {
        p->Yvel -= step;
        if (p->Yvel < 0) p->Yvel = 0;
    }
}
