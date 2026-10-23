/* Skating (043_5E16D_engine_skating): EvadePlayers... StopNA in address order, as one source file because
 later functions end in an earlier one's pop/ret tail (multi-block file, see tools/cc.py): skatetopuck ends in
 EvadePC_x, avdgoal in EvadePlayers_popebp, StopNA in EvadePlayers_popedi (which copy of the pops survives needs
 every function between them here). The one that does not match yet (avdgoal) is
 compiled for the layout but not spliced. vtoa is declared with an int result in this file: as short,
 skatetopuck's registers and most of EvadePlayers' differ. */
#define skatetopuck skatetopuck_decl
#define imul32 imul32_decl
#define vtoa vtoa_decl
#include "nhl95.h"
#undef skatetopuck
#undef imul32
#undef vtoa

int __cdecl imul32(int a, int b);
int vtoa(int dx, int dy);  /* hand-written (8C8E8): the direction in ax, declared with an int result here */

/* EvadePlayers: skateto collision routine.
 p = player (eax). Nothing when pflags2 bit 5 is set. Behind the net (|Ypos| > F2h, |Xpos| < 32h): regd0.w = a
 direction round the net from the Xpos Yvel signs. Else for every other SortCords entry (0-14, not the goalies
 12/13, the puck only while nothing is closer than 50h): if the predicted x and y gaps (position + high byte of
 the velocity) are both within 28h and the closest so far, regd0.w = a sidestep direction from vtoa of the gap,
 turned away from the boards near the ends. Results in the 68k-register statics regd0.w (direction), regd1.w regd2.w
 (|dy|, |dx|); no return value. */
void EvadePlayers(Player *p)
{
    Player *o;
    short i, best, dx, dy, pv, ov;

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
        if (regd2.w + regd1.w >= best) continue;            /* closest so far? */
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
            if (regd0.w == 6 && o->Yvel != 0) regd0.w = dy < 0 ? 5 : 4;
            else regd0.w = dy <= 0 ? 0 : 7;
        } else {
            if (HIWORD(p->Xpos) >= 0x64 || HIWORD(p->Xpos) < 0) continue;
            if (regd0.w <= 4 || regd0.w >= 8) continue;
            regd0.w = 8 - regd0.w;
            if (regd0.w == 2 && o->Yvel != 0) regd0.w = dy >= 0 ? 4 : 3;
            else regd0.w = dy > 0 ? 1 : 0;
        }
    }
}

/* EvadePC (5E7FE, PC only; ends in EvadePlayers_popedi, owner of EvadePC_x): skateto collision routine for the
   offensive wingers and centre: steer round the puck carrier. When the predicted x and y gaps to him (position plus
   the high byte of the velocity, regd2 / regd1) are both within 28h, regd0.w is the direction away from him
   (vtoa of the gap); with offsides on (gameopts bit 1) and p just outside the blue line he attacks (y 4Eh, from
   -32h to +0Ah of it) he skates along the line instead (direction 2 or 6, away from the carrier's x). p: the
   player. No result (regd0.w). */
void EvadePC(Player *p)
{
    Player *c;
    short dx;
    short dy;

    if (*puckc < 0) return;
    c = &SortCords[*puckc];
    dx = HIWORD(p->Xpos) - HIWORD(c->Xpos);
    regd2.w = (HIBYTE(p->Xvel) - HIBYTE(c->Xvel)) + dx;
    if (ABS(regd2.w) > 0x28) return;
    dy = HIWORD(p->Ypos) - HIWORD(c->Ypos);
    regd1.w = (HIBYTE(p->Yvel) - HIBYTE(c->Yvel)) + dy;
    if (ABS(regd1.w) > 0x28) return;
    regd0.w = dx;
    regd1.w = dy;
    regd0.w = vtoa(dx, dy);
    if (!gameopts.offsides) return;
    regd1.w = (!(p->pflags & 0x80) ? -HIWORD(p->Ypos) : HIWORD(p->Ypos)) - 0x4E;
    if (regd1.w > 10) return;
    if (regd1.w < -0x32) return;
    regd1.w = HIWORD(p->Xpos);
    if (regd1.w > HIWORD(c->Xpos)) regd0.w = 2;
    else regd0.w = 6;
}

/* skateto: player p skates to the point regd0/regd1 (a0 = extra routine for
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
        {
            int v;

            v = HIBYTE(p->Xvel);
            px = HIWORD(p->Xpos) + v;
        }
        py = HIBYTE(p->Yvel) + HIWORD(p->Ypos);
        regd0.w -= px;
        regd1.w -= py;
        dx -= px;
        dy -= py;
        dx = ABS(dx);
        dy = ABS(dy);
        if (ABS(regd0.w) <= 0x0C && ABS(regd1.w) <= 0x0C && (dx <= 0x0C || p->Xvel != 0)
            && (dy <= 0x0C || p->Yvel != 0))
            regd0.w = 9;                            /* close enough: no direction */
        else
            regd0.w = vtoa(regd0.w, regd1.w);
        if (evade != NULL) evade(p);                /* jsr (a0) */
        TEMP2_DIR(p) = regd0.w;
        if (regd0.w > 7 && !(px = p->Xvel, (p->Yvel | px))) {   /* the comma loads Xvel first, as the EXE */
            if (puckpflags2 & 1) {                  /* puck in a fight: face xc1/yc1 */
                regd0.w = xc1;
                regd1.w = yc1;
            } else {
                short sy;

                regd0.w = *puckx;
                sy = *pucky;
                regd1.w = sy;
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

/* skatetopuck (5EB17, 93G skatetopuck; ends in EvadePC_x): player p skates to the puck. The target is the puck
   plus half the high byte of its velocity (regd0 / regd1, 93G skatetopuckinit). Every 10 ticks (5 for a
   goalie; the temp2 high byte): avoid the goal (avdgoal), then with a loose puck, a puck faster than 12Ch or a
   target farther than 18h, aim with GetHot (the target less p's position and velocity lead) through vtoa, else
   take p's direction to the puck (puckdir); keep it in the temp2 low byte. A skater then checks for a sweep:
   with the puck coming straight at it (fast pucks only one time in four), facing the puck and between 30 and 38
   away, Sweepcheck. Otherwise doplayeracc in the kept direction. p: the player. No result. */
void skatetopuck(Player *p)
{
    short sx;
    short sy;

    regd0.w = (short)(HIBYTE(*puckvx) >> 1) + *puckx;
    regd1.w = (short)(HIBYTE(*puckvy) >> 1) + *pucky;
    if (--TEMP2_TICKS(p) >= 0) goto ex;
    TEMP2_TICKS(p) += p->position == 0 ? 5 : 10;
    avdgoal(p);
    sx = regd0.w;
    sy = regd1.w;
    if (*puckc < 0 || ABS(*puckvx) > 0x12C || ABS(*puckvy) > 0x12C
        || (unsigned)vecdist(sx - HIWORD(p->Xpos), sy - HIWORD(p->Ypos)) > 0x18) {
        GetHot(p);
        regd0.w = sx - ((signed char)regd0.w + HIBYTE(p->Xvel)) - HIWORD(p->Xpos);
        regd1.w = sy - ((signed char)regd1.w + HIBYTE(p->Yvel)) - HIWORD(p->Ypos);
        regd0.w = vtoa(regd0.w, regd1.w);
    } else {
        regd0.w = p->puckdir;
    }
    TEMP2_DIR(p) = regd0.w;
    if (p->position == 0) goto ex;
    regd0.w = vtoa(*puckvx, *puckvy) ^ 4;
    if (regd0.w == p->facedir) {
        if (ABS(*puckvx) >= 0xFA0 || ABS(*puckvy) >= 0xFA0) {
            if (randomd0(4)) goto ex;
        }
    }
    regd0.w = *puckx - HIWORD(p->Xpos);
    regd1.w = *pucky - HIWORD(p->Ypos);
    if ((short)vtoa(regd0.w, regd1.w) != p->facedir) goto ex;
    regd0.l = imul32(regd0.w, regd0.w) + imul32(regd1.w, regd1.w);
    if (regd0.ul <= 30 * 30 || regd0.ul > 38 * 38) goto ex;
    Sweepcheck(p);
    return;
ex:
    doplayeracc(p, TEMP2_DIR(p));
}

/* playeracc: accelerate player p in direction dir (d2 = direction of acc).
 The dirtab x/y step times (legstr+30h)/64 (PC); no push into a wall (Wallsin Wallcos); accel factor
 32 - weight/8 + legstr (goalie: + legstr + 14h) into regd2; new velocity (regd0, regd1) =
 step * factor 32 + old. Max speed check: speed squared (regd3) against MaxSpeed[legspd * energy >> 12]
 (referee: fixed index 0Fh, or 0Ch when the clock is stopped and he is 74h+ from centre; pflags2 bit 6 cuts it to
 1/8); the velocity is kept only under it. Then the energy drain when fatigue (line changes) is on and the
 clock runs (getpde setpde inline): 1 in 128 calls the energy drops by 28h
 at C00h+ the endurance is added back, at most 1000h. */
void playeracc(Player *p, short dir)
{
    short yacc, xacc;

    dir += dir;
    xacc = dirtab[dir];                             /* x inc */
    yacc = dirtab_y[dir];                           /* y inc */
    xacc = xacc * (p->legstr + 0x30) / 64;
    yacc = yacc * (p->legstr + 0x30) / 64;
    if (p->Wallsin != 0 && (xacc ^ p->Wallsin) < 0) xacc = 0;     /* wallsin: don't push the wall */
    if (p->Wallcos != 0 && (yacc ^ p->Wallcos) >= 0) yacc = 0;
    regd2.w = 0x20 - (short)(p->weight >> 3) + p->legstr;
    if (p->position == 0) regd2.w += (unsigned short)p->legstr + 0x14;  /* goalie adds legstr again plus 14h (16-bit add) */
    regd0.l = xacc * regd2.w >> 5;
    regd1.l = regd2.w * yacc >> 5;
    regd0.w += p->Xvel;
    regd1.w += p->Yvel;
    regd3.l = regd0.w * regd0.w + regd1.w * regd1.w;
    if (p->SCnum == SCref) {                                    /* referee: fixed max speed index */
        if (!(gmode & gmclock) || ABS(HIWORD(p->Ypos)) < 0x74) regd2.l = 0x0F;
        else regd2.l = 0x0C;
    } else {
        regd2.l = (unsigned long)(p->tmptr->tmpde[p->pnum] * p->legspd) >> 12;   /* energy level */
    }
    regd2.l = MaxSpeed[regd2.w];
    if (p->pflags2 & 0x40) regd2.l >>= 3;                       /* pflags2 bit 6 cuts max speed to 1/8 */
    if (regd3.ul <= regd2.ul) {                                 /* max speed check */
        p->Xvel = regd0.w;
        p->Yvel = regd1.w;
    }
    /* .sube */
    if (p->SCnum == SCref || !gameopts.linechanges || (gmode & gmclock) || p->position == 0) return;
    regd0.w = randomd0(0x80);                                   /* 1 in 128 ticks */
    if (regd0.w != 0) return;
    regd0.w = p->tmptr->tmpde[p->pnum] - 0x28;                  /* subi.w # (PC 28h) */
    if (regd0.w < 0xC00) {
        p->tmptr->tmpde[p->pnum] = regd0.w < 0 ? 0 : regd0.w;
        return;
    }
    regd0.w += p->endurance;
    if (regd0.w > 0x1000) regd0.w = 0x1000;                     /* max 1000h */
    p->tmptr->tmpde[p->pnum] = regd0.w < 0 ? 0 : regd0.w;
}

/* avdgoal_box: helper of avdgoal: does the line from player p to the target (regd0 x regd1 y,
 low words) cross this goal's box (x from x1 to x2, y within +-y)? *ps *pt get the side bits of the player
 and the target (4 below x1, 1 from x2 on, 2 8 past y -y). Returns 1 when it crosses, else 0 (both on one
 side). */
int avdgoal_box(Player *p, int x1, int x2, int y, int *ps, int *pt)
{
    int px;
    int py;
    int tx;
    int ty;

    px = HIWORD(p->Xpos);
    py = HIWORD(p->Ypos);
    tx = *(int *)((char *)&regd0 - 2) >> 16;
    ty = *(int *)((char *)&regd1 - 2) >> 16;
    *ps = *pt = 0;
    if (x1 > py) {
        *ps = 4;
        if (ty < x1) return 0;
    } else if (ty < x1) {
        *pt = 4;
    }
    if (x2 > py) {
        if (ty >= x2) *pt = 1;
    } else {
        *ps = 1;
        if (ty >= x2) return 0;
    }
    if (y > px) {
        if (y <= tx) *(unsigned char *)pt |= 2;
    } else {
        *(unsigned char *)ps |= 2;
        if (y <= tx) return 0;
    }
    if (-y <= px) {
        if (-y > tx) *(unsigned char *)pt |= 8;
    } else {
        *(unsigned char *)ps |= 8;
        if (-y > tx) return 0;
    }
    return 1;
}

/* DRAFT (avdgoal), 10.0 GA: 155 differing; the switch cases use the margin sums inline (Watcom hoists them after
   the jump-table range check, as in the EXE); the stack slots still differ (the EXE has g as an int at ebp-0Ch). */
/* the goalie's SortCords number in a team block (the word at +FAh) */
#define TMGOALIE(t) (*(short *)((char *)(t) + 0xFA))

/* avdgoal (5F151, 93G avdgoal, rewritten on the PC; ends in EvadePlayers_popebp): don't skate through a goal. p
   skates to the target in regd0 / regd1 (x / y, changed in place). A goalie or a player on assignment 27h uses a
   tighter box (margin -6, else 0Ah). The referee with the clock stopped keeps a target in front of the goal on his
   own side. avdgoal_box tests the line to the target against the goal at +E8h (then the y values are mirrored
   and the side bits 1 / 4 swapped) and else the one at -E8h; nothing is changed when it crosses neither. ps / pt
   are the side bits of p and the target (1 behind the goal line, 4 in front, 2 / 8 right / left of the posts):
   with the target in the box, it moves beside the posts (x +-(2Ch + margin)) and to the goal mouth (yl) or
   behind the net (yb), round the goalie (gp) when the team has one; else, by p's side, a corner case of a
   13-way switch moves the target to a post side, the goal mouth or behind the net. No result. */
void avdgoal(Player *p)
{
    int ps;
    int pt;
    int gl;
    int tight;
    Player *gp;
    short g;
    int py;
    int tx;
    int m;
    int ty;
    int px;
    int yl;
    int yb;

    tight = p->position == 0 || p->asslist[p->assnum] == 0x27 ? 1 : 0;
    m = tight ? -6 : 0xA;
    if ((gmode & 1) && p->SCnum == 0x10 && ABS(regd1.w) < 0xE8 && (regd1.w ^ HIWORD(p->Ypos)) >= 0) return;
    px = HIWORD(p->Xpos);
    py = HIWORD(p->Ypos);
    tx = regd0.w;
    ty = regd1.w;
    if (avdgoal_box(p, 0xE8 - (tight ? 6 : 0x23), 0xFC, (tight ? -8 : 0) + 0x2C, &ps, &pt)) {
        yb = 0xFD;
        yl = 0xE8 - (tight ? 7 : 0x24);
        py = -py;
        ty = -ty;
        gl = 0xE8;
        g = TMGOALIE(p->pflags & 0x80 ? p->optmptr : p->tmptr);
        if (g >= 0) gp = &SortCords[g];
        if (*(unsigned char *)&ps & 5) *(unsigned char *)&ps ^= 5;
        if (*(unsigned char *)&pt & 5) *(unsigned char *)&pt ^= 5;
    } else {
        if (!avdgoal_box(p, -0xFC, (tight ? 6 : 0x23) - 0xE8, (tight ? -8 : 0) + 0x2C, &ps, &pt)) return;
        yb = -0xFD;
        yl = (tight ? 7 : 0x24) - 0xE8;
        gl = -0xE8;
        g = TMGOALIE(p->pflags & 0x80 ? p->tmptr : p->optmptr);
        if (g >= 0) gp = &SortCords[g];
    }
    if (pt == 0) {
        if (py >= -0xE8) {
            if (tight) {
                if (ty < -0xE8) return;
                regd1.w = yl;
                if (tx >= 0) {
                    if (m + 0x2C > tx) regd0.w = m + 0x2C;
                } else if (-0x2C - m + 1 <= tx) regd0.w = -0x2C - m;
                if (ABS(px) > 0x26) regd1.w = yb;
                return;
            }
            if (ty < -0xE8) {
                regd1.w = yl;
                if (g >= 0 && ((tx - HIWORD(gp->Xpos)) ^ (px - tx)) < 0) {
                    if (px < HIWORD(gp->Xpos)) regd0.w = -0x2C - m;
                    else regd0.w = m + 0x2C;
                } else {
                    if (ABS(px) >= m + 0x2C) return;
                    if (px < 0) regd0.w = -0x2C - m;
                    else regd0.w = m + 0x2C;
                }
                if (ABS(px) > 0x26) regd1.w = yb;
                return;
            }
            if (g < 0) return;
            if (px < tx) {
                if (px >= HIWORD(gp->Xpos)) return;
            } else if (px < HIWORD(gp->Ypos)) return;
            regd1.w = yl;
            return;
        }
        if (ty < -0xE8) return;
        if (px < -0x2C - m + 1) regd0.w = -0x2C - m;
        else if (px >= m + 0x2C) regd0.w = 0x2C + m;
        else {
            regd1.w = yb;
            if (tx >= 0) {
                if (m + 0x2C > tx) regd0.w = 0x2C + m;
            } else if (-0x2C - m + 1 <= tx) regd0.w = -0x2C - m;
        }
        if (ABS(px) > 0x26) regd1.w = yl;
        return;
    }
    switch (ps) {
    case 0:
        if (py < -0xE8) {
            if (px < -0x2C - m + 1) regd0.w = -0x2C - m;
            else if (px >= m + 0x2C) regd0.w = m + 0x2C;
            else {
                regd1.w = yb;
                if (tx >= 0) {
                    if (m + 0x2C > tx) regd0.w = m + 0x2C;
                } else if (-0x2C - m + 1 <= tx) regd0.w = -0x2C - m;
            }
            return;
        }
        if (tight) {
            if (pt & 1) return;
            regd1.w = yl;
            if (tx >= 0) {
                if (m + 0x2C > tx) regd0.w = m + 0x2C;
            } else if (-0x2C - m + 1 <= tx) regd0.w = -0x2C - m;
            return;
        }
        if (ty >= -0xE8) {
            if (g >= 0 && ((tx - HIWORD(gp->Xpos)) ^ (px - tx)) < 0) {
                if (px < HIWORD(gp->Xpos)) regd0.w = -0x2C - m;
                else regd0.w = m + 0x2C;
            } else if (ABS(px) < m + 0x2C) {
                if (px < 0) regd0.w = -0x2C - m;
                else regd0.w = m + 0x2C;
            }
            if (ABS(px) > 0x26) regd1.w = yb;
            return;
        }
        regd1.w = gl;
        if (g >= 0) {
            if (px < HIWORD(gp->Ypos)) regd0.w = -0x2C - m;
            else regd0.w = m + 0x2C;
        } else if (tx >= 0) {
            if (m + 0x2C > tx) regd0.w = m + 0x2C;
        } else if (-0x2C - m + 1 <= tx) regd0.w = -0x2C - m;
        return;
    case 1:
        regd1.w = yl;
        if (pt & 4) return;
        if (tx >= 0) {
            if (tx < m + 0x2C) regd0.w = m + 0x2C;
        } else if (tx >= -0x2C - m + 1) regd0.w = -0x2C - m;
        return;
    case 2:
        regd0.w = m + 0x2C;
        if (pt & 5) return;
        regd1.w = yl;
        return;
    case 3:
        if (pt == 8) regd1.w = yl;
        else regd0.w = m + 0x2C;
        return;
    case 4:
        regd1.w = yb;
        if (!(pt & 1)) return;
        if (tx >= 0) {
            if (tx < m + 0x2C) regd0.w = m + 0x2C;
        } else if (tx >= -0x2C - m + 1) regd0.w = -0x2C - m;
        return;
    case 6:
        if (pt != 8) regd0.w = m + 0x2C;
        else regd1.w = yb;
        return;
    case 8:
        regd0.w = -0x2C - m;
        if (!(pt & 5)) return;
        regd1.w = yl;
        return;
    case 9:
        if (pt == 2) regd1.w = yl;
        else regd0.w = -0x2C - m;
        return;
    case 12:
        if (pt == 2) regd1.w = yb;
        return;
    }
}

void dostop(Player *p)
{
    short spa;

    if (ABS(p->Xvel) > 0x1000 || ABS(p->Yvel) > 0x1000) {     /* .slim */
        if ((p->pflags & pfrev) == 0) {
            p->pflags2 |= pf2aip;
            if (p->SCnum == SCref) {
                if (refsignal != 0 || ((gmode & gmclock) == 0 && ((gmode2 & 0x80) || (gmode & 8))))
                    spa = SPArefstopsig;
                else spa = SPArefstop;
            } else spa = SPAstop;
        } else {
            if (p->SCnum == SCref) {
                if (refsignal != 0 || ((gmode & gmclock) == 0 && ((gmode2 & 0x80) || (gmode & 8))))
                    spa = SPArefglidesig;
                else spa = SPArefglide;
            } else spa = SPAglide;
        }
        SetSPA(p, spa);
    }
    StopNA(p);                  /* stop with no anim */
}

/* StopNA: (stopna): slow player p by one step on each axis, with no animation
 change. The step is 200 + legstr; a velocity that would cross
 zero is clamped to 0.
 Its tail is EvadePlayers' pop/ret (jmp EvadePlayers_popedi): wcc386 merges identical function tails inside
 one source file, so StopNA lives in this file, after the functions between them. */
void StopNA(Player *p)
{
    int str = p->legstr;
    int step = str + 200;               /* step 200+legstr */

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
