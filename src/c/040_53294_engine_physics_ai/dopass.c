/* Engine physics AI: passing (dopass), the shot aim at the open side (shotdiradj), shooting (doshot) and the wall
   bounce (wallcoll); doshot and wallcoll end in dopass_ret6. */
/* DRAFT: both are first passes; see docs/UNSURE.md. Their match belongs in checkob.c: dopass ends in
   checkob_ret5 and shotdiradj in dopass_ret6. Appended to checkob.c as they are, they move the shared pops
   (burst then branches into dopass), so they stay in their own file for now. */
#define dopass dopass_decl
#define shotdiradj shotdiradj_decl
#define PassLaneChk PassLaneChk_decl
#define passtoa0 passtoa0_decl
#define puckvz puckvz_decl
#define sfx sfx_decl
#define imul32 imul32_decl
#include "nhl95.h"
#undef dopass
#undef shotdiradj
#undef PassLaneChk
#undef passtoa0
#undef puckvz
#undef sfx
#undef imul32

int PassLaneChk(Player *p, Player *to);
void passtoa0(Player *to);
void sfx(int n);
extern int puckvz;

/* DRAFT (dopass, 10.0 GA): 17 score differing. Fetch the early scatter target into o and reuse dx for the pass
   speed and dy for each direction product (dead-variable reuse: fresh locals there score 51-85, so it stays until
   a natural shape is found). The candidate score goes straight into s.t (a distance_score copy scored the same).
   Left: the square sum lands in edi and is copied to eax for the compare (EXE: the sum in esi, the 10000h term in
   eax), and the shared exit (checkob_ret5). */
/* dopass (54DF4, 93G dopass; ends in checkob_ret5): pass the puck in passdir. Clear the one-timer flag and the
   spin flag, drop the puck (nopuck 10h, lastplayer). A computer player with a pass lane result (passlane) scatters
   the pass to its target. Otherwise the pass speed is A0h + 4 * passacc (8 for a goalie), and the best teammate
   is the closest one (squared distance, plus 10000h unless straight ahead) within one step of passdir, skipping
   p, goalies and unavailable players (pflags2 bit 2): a human player's pass checks the lane (PassLaneChk) and
   scatters when it is blocked, else the target gets the pass (passtoa0); with no target the puck goes along
   passdir at the pass speed plus p's velocity, with a random lift. A goalie's pass is turned up the ice (puckvy
   sign by side); with a human goalie the controller moves to the receiver (restorepl) or, without one, to the
   next player (changeplayer). Then the swing animation (goalie 1B9h, else Findhittype: 3C1h or 389h), pflags
   bit 5 and the pass sound (98h, 99h for a high pass). p: the passer. No result. */
void dopass(Player *p)
{
    struct {
        int t;
        unsigned best;
        short w;
    } s;
    Player *o;
    Player *target;
    int dx;
    int dy;
    short d;

    onetimerflag = 0;
    sflags &= 0xFB;
    *puckc = -1;
    p->nopuck = 0x10;
    lastplayer = p->SCnum;
    if (!(p->pflags & 8) && p->passlane) {
        o = &SortCords[((short *)p)[0x24]];
        ScatterPass(p, o);
        return;
    }
    if (p->position == 0) s.w = 8;
    else s.w = p->passacc;
    passspeed = (s.w << 2) + 0xA0;
    o = &SortCords[p->SCnum < 6 ? 0 : 6];
    s.best = -1;
    target = 0;
    s.w = 6;
    do {
        if (p != o && o->position > 0 && !(o->pflags2 & 4)) {
            dx = (short)(HIWORD(o->Xpos) - *puckx);
            dy = (short)(HIWORD(o->Ypos) - *pucky);
            d = (vtoa(dx, dy) - passdir) & 7;
            if (d <= 1 || d == 7) {
                s.t = dx * dx + dy * dy + (!d ? 0 : 0x10000);
                if (s.t <= s.best) {
                    s.best = s.t;
                    target = o;
                }
            }
        }
        o++;
    } while (--s.w);
    if (target) {
        if ((p->pflags & 8) && PassLaneChk(p, target)) {
            ScatterPass(p, target);
            return;
        }
        passtoa0(target);
    } else {
        dx = passspeed;
        dy = dirtab_y[passdir * 2] * dx << 10;
        s.t = dy;
        s.t = s.t / 0xBB8;
        *puckvy = s.t + p->Yvel;
        dy = dirtab[passdir * 2] * dx << 10;
        s.t = dy;
        s.t = s.t / 0xBB8;
        *puckvx = s.t + p->Xvel;
        *(short *)puckvz = randomd0(0x1000);
    }
    if (p->position == 0) {
        if (((p->pflags & 0x80) == 0) ^ (*puckvy < 0)) *puckvy = -*puckvy;
        s.w = 0x1B9;
        p->pflags2 |= 2;
        if (p->pflags & 8) {
            if (target && !(target->pflags & 8)) {
                if (p->SCnum == c1playernum[0]) {
                    if (c1playernum[0] != target->SCnum) c1playernum[0] = restorepl(target->SCnum, c1playernum[0]);
                } else {
                    if (target->SCnum != c2playernum[0]) c2playernum[0] = restorepl(target->SCnum, c2playernum[0]);
                }
            } else {
                changeplayer(p, p->SCnum == c1playernum[0] ? 0 : 2);
            }
        }
    } else {
        if (!Findhittype(p, vtoa(*puckvx, *puckvy))) s.w = 0x389;
        else s.w = 0x3C1;
    }
    SetSPA(p, s.w);
    p->pflags |= 0x20;
    sfx((short)(((signed char *)puckvz)[1] >= 6 ? 0x99 : 0x98));
}

/* DRAFT (10.0 GA, 23 differing): gy declared before gdy gives the EXE's postx in edx / gy in eax; *puckx read
   once into the dead q before x0 is set gives the EXE's early ecx load. Left: the EXE stores dist = 1 through
   eax, subtracts *puckx from x0 before the cross product (edx; the cross in ebx), adds the second quotient to a
   without a movsx and clears passdir through edi; see docs/UNSURE.md. */
/* shotdiradj (57A98, 93G shotdiradj; ends in dopass_ret6): a human shooter aims at the side of the net the
   goalie leaves open: from the opposing goalie's position plus half its velocity (relative to the puck), the
   offsets of the two posts (x +-12h at the goal line, E8h / -E8h by side) from the puck-to-goalie line, divided
   by the goalie's distance; beyond 2Ch in total passdir 0 (straight), else 2 or 6 by the sign (mirrored by
   side). No goalie: passdir 8. Computer players are skipped. p: the shooter. No result. */
void shotdiradj(Player *p)
{
    struct {
        int x0;
        int cross;
        int gdx;
        short dist;
    } s;
    Player *g;
    short i;
    short gy;
    int gdy;
    short postx;
    short a;
    int q;

    if (p->pflags & 8) return;
    g = (Player *)(((p->SCnum < 6 ? 6 : 0) << 7) + (int)SortCords);
    for (i = 0; i < 6; i++, g++) {
        if (g->position == 0) break;
    }
    if (i == 6) {
        passdir = 8;
        return;
    }
    s.gdx = (short)((g->Xvel >> 9) + (g->Xpos >> 16) - *puckx);
    gdy = (short)((g->Yvel >> 9) + (g->Ypos >> 16) - *pucky);
    s.dist = vecdist(s.gdx, gdy);
    if (s.dist == 0) s.dist = 1;
    postx = 0x12;
    gy = 0xE8;
    if (!(p->pflags & 0x80)) gy = -0xE8;
    q = *puckx;
    s.x0 = postx;
    s.cross = s.gdx * (gy - *pucky);
    a = (s.cross - (s.x0 - q) * gdy) / s.dist;
    a += (s.cross - (-s.x0 - q) * gdy) / s.dist;
    if (ABS(a) > 0x2C) {
        passdir = 0;
        return;
    }
    if (p->pflags & 0x80) a = -a;
    if (a >= 0) passdir = 2;
    else passdir = 6;
}

int __cdecl imul32(int a, int b);  /* library: 32-bit product */

/* DRAFT (10.0 GA, 45 differing, same size): the scatter divisor and the speed divisor share one int (f, the
   EXE's ebp, so the 3 of f / 3 spills to [esp]); f takes the distance inside the first speed division
   (`/ (f = dist)`: the EXE's movsx ebp, cx right before the idiv); the x scatter range is an int t (r + r)
   declared last, and dy declared before snd, which puts snd at [esp+0Ch] and dy at [esp+10h] as in the EXE.
   Left: register picks (the |y| of the shot-power test in edi, EXE ebx; the puck x pointer, the radius sum, the
   speed quotients in edx, EXE ebx) and the lift, where the EXE converts passspeed (ebp) and dist (ecx) once
   for both terms. */
/* doshot (57C0B, 93G doshot; ends in dopass_ret6): p shoots. The aim is set (shotdiradj), p becomes the shooter
   (shotplayer, sflags bit 3 off, pflags bit 5). Without the puck, and not in a deflection animation (SPA DD3h /
   E2Bh), it only plays the miss sound 99h. Else (gmode2 bit 4) the shot speed: a slapshot (SPA 491h / E2Bh) loses
   a quarter; the shot power (shotspd, +2 within 1F4h of centre ice, +1 over 0Ah, 0Dh and 0Eh) times the
   player's energy (tmpde) scales passspeed, then * 5249h >> 16; a shot on goal checks the lane (ShotLaneOpen ->
   shotongoal). The target is the shot set of passdir (shotsets x / shotsetz height) at the goal line of p's side
   (E8h); unless gmode bit 4, a far shot (over C8h) or a missed accuracy roll (shotacc +1 over 0Dh and 0Eh)
   scatters it by the distance, speed and accuracy, in x, y and height. The puck takes the aim at the shot speed
   (* 59 / distance; during a penalty shot at least the shooter's speed + 1F4h on each axis) and a lift from the
   height and distance (at most 1800h). Then the shot sound (AAh, 9Ah when slow) and, in a penalty shot, the
   shooter's next assignment (11h). p: the shooter. No result. */
void doshot(Player *p)
{
    short sp;
    short r;
    short dist;
    short z;
    short q;
    int e;
    int f;
    short dx;
    short dy;
    short snd;
    short gy;
    int t;

    shotdiradj(p);
    shotplayer = p->SCnum;
    sflags &= 0xF7;
    p->pflags |= 0x20;
    if (*puckc != p->SCnum && p->SPA != 0xDD3 && p->SPA != 0xE2B) {
        sfx(0x99);
        return;
    }
    gmode2 |= 0x10;
    if (p->SPA == 0x491 || p->SPA == 0xE2B) {
        snd = 0xAA;
        passspeed -= passspeed >> 2;
    } else {
        snd = 0xAA;
    }
    sp = p->shotspd;
    if (sp > 0xC && ABS(HIWORD(p->Xpos)) + ABS(HIWORD(p->Ypos)) < 0x1F4) sp += 2;
    if (sp > 0xE) sp++;
    if (sp > 0xD) sp++;
    if (sp > 0xA) sp++;
    passspeed *= (short)(imul32(p->tmptr->tmpde[p->pnum], sp) >> 12) + 0x14;
    passspeed = (unsigned)(passspeed * 0x5249) >> 16;
    if (shotongoal) {
        ShotLaneOpen();
        shotongoal = shotontarget;
    }
    if ((short)(3 - (passspeed >> 4)) > 0) snd = 0x9A;
    *puckc = -1;
    p->nopuck = 0x10;
    lastplayer = p->SCnum;
    gy = 0xE8;
    if (!(p->pflags & 0x80)) gy = -0xE8;
    dx = shotsets[passdir * 2] - *puckx;
    dy = gy - *pucky;
    z = shotsetz[passdir * 2];
    dist = vecdist(dx, dy);
    if (!dist) dist = 1;
    if (!(gmode & 0x10)) {
        sp = p->shotacc;
        if (sp > 0xE) sp++;
        if (sp > 0xD) sp++;
        if (dist > 0xC8 || randomd0(p->shotacc + 0x10) <= 0xE) {
            r = (dist * ((passspeed >> 4) - sp + 0x10) & 0xFFFF) >> 6;
            if (dist < 0xFA) r >>= 1;
            if (r > 0xA0) r = 0xA0;
            t = r + r;
            dx += randomd0(t) - r;
            if (r > 0x3C) r = 0x3C;
            e = dy < 0 ? r >> 1 : r;
            dy += randomd0(e + e) - e;
            f = r;
            q = f >> 1;
            if (dist < 0xA0) q = f / 3;
            if (dist < 0x50) q = r >> 2;
            z += randomd0(q);
        }
    }
    *puckvx = dx * (passspeed * 59) / (f = dist);
    *puckvy = dy * (passspeed * 59) / f;
    if (penshotlive) {
        if ((*puckvx ^ p->Xvel) >= 0 && ABS(*puckvx) < ABS(p->Xvel)) *puckvx = p->Xvel + 0x1F4;
        if ((*puckvy ^ p->Yvel) >= 0 && ABS(*puckvy) < ABS(p->Yvel)) *puckvy = p->Yvel + 0x1F4;
    }
    if (z) {
        z = (unsigned)(passspeed * 68 * z) / (unsigned)dist + (unsigned)(dist * 0xB33) / (unsigned)passspeed;
        if ((unsigned short)z > 0x1800) z = 0x1800;
        *(short *)puckvz = z;
    }
    sfx(snd);
    if (penshotlive) assreplace(p, 0x11);
}

/* wallcoll (587D3, 93G wallcoll; ends in dopass_ret6): bounce p off the wall whose normal is (regd0, regd1) =
   (cos, sin), kept in Wallcos / Wallsin. The velocity is turned into the wall frame (regd2 across, regd3 along).
   The puck (SCnum 0Eh) clears the pass (gmode2 bit 4, passplayer); moving into the wall it loses three quarters
   of its speed across, a hard hit (regd2 -400h or less) pops it up (Zvel, puckflip) with a board sound (95h / 7Bh
   / ADh by speed when loose and low, else AFh / A5h / A7h at random); the speed along the wall loses 3/128, the
   velocity is turned back, a carried or far (|y| > E8h) puck ends a penalty shot, and the one-timer and shot
   flags clear. A player bounces only when moving into the wall (regd2 up to 3E8h): a hard hit (-1000h or less,
   impact 0Ah or more, not dword_CCC2C) plays B1h, the speed across is quartered and at least 3E8h back; with
   dword_CCC2C set (a goal-net hit) a player stopped at the side posts (|old x| 18h) or past the net's back keeps
   its old position on that axis. Then dword_CCC2C and an upward Zvel clear. No result. */
/* DRAFT (10.0 GA, 11 differing, same size): no goto (each board-sound arm calls sfx itself; Watcom merges the two
   calls) and the goal-net y limit in its own lim. Left: the puck branch's Yvel sum lands in eax (EXE edx), a tie
   of the unstable sort. With the limit in the dead sound short s (or t) instead of lim, and the puck branch's
   products as `regd0.w * regd3.w - regd1.w * regd2.w` / `regd1.w * regd3.w + regd0.w * regd2.w` and the regd3
   sum as `regd0.w * p->Xvel + regd1.w * p->Yvel`, it compiles to the EXE bytes, but that is dead-variable reuse
   (ESCALATE); see docs/UNSURE.md. */
void wallcoll(Player *p)
{
    short t;
    short s;
    short v;
    short lim;

    p->Wallcos = regd0.w;
    p->Wallsin = regd1.w;
    regd2.w = -(short)((regd0.w * p->Yvel - p->Xvel * regd1.w) >> 8);
    regd3.w = (p->Xvel * regd0.w + p->Yvel * regd1.w) >> 8;
    if (p->SCnum == 0xE) {
        gmode2 &= 0xEF;
        passplayer = -1;
        if (regd2.w >= 0) {
            dword_CCC2C = 0;
            return;
        }
        regd2.w >>= 2;
        if (regd2.w <= -0x400) {
            p->Zvel = -randomd0(0x800);
            puckflip(p);
            if (!dword_CCC2C) {
                t = (regd2.w >> 10) + 4;
                if (t < 0) t = 0;
                if ((unsigned short)HIWORD(p->Zpos) <= 0xA) {
                    if (*puckc < 0) {
                        s = t % 3;
                        if (s == 2) s = 0x95;
                        else if (s == 1) s = 0x7B;
                        else s = 0xAD;
                        sfx(s);
                    }
                } else {
                    s = randomd0(3);
                    if (s == 0) s = 0xAF;
                    else if (s == 1) s = 0xA5;
                    else s = 0xA7;
                    sfx(s);
                }
            }
        }
        v = regd3.w >> 6;
        regd3.w -= v;
        v >>= 1;
        regd3.w -= v;
        p->Xvel = (regd0.w * regd3.w - regd1.w * regd2.w) >> 8;
        p->Yvel = (regd1.w * regd3.w + regd2.w * regd0.w) >> 8;
        if (*puckc < 0 || ABS(*pucky) > 0xE8) EndPenaltyShot();
        shotongoal = onetimerflag = 0;
    } else {
        if (regd2.w > 0x3E8) {
            dword_CCC2C = 0;
            return;
        }
        if (regd2.w <= -0x1000 && p->impact >= 0xA && !dword_CCC2C) sfx(0xB1);
        regd2.w >>= 2;
        if (regd2.w >= -0x384) regd2.w = -0x3E8;
        p->Xvel = (regd0.w * regd3.w - regd1.w * regd2.w) >> 8;
        p->Yvel = (regd1.w * regd3.w + regd0.w * regd2.w) >> 8;
        if (dword_CCC2C) {
            if (HIWORD(p->OldXpos) <= -0x18 && p->Xvel > 0 || HIWORD(p->OldXpos) >= 0x18 && p->Xvel < 0) {
                p->Xvel = 0;
                HIWORD(p->Xpos) = HIWORD(p->OldXpos);
            }
            lim = HIWORD(p->OldYpos) < 0 ? -0xEC : 0xEC;
            if (HIWORD(p->OldYpos) > lim + 0xA && p->Yvel < 0 || HIWORD(p->OldYpos) < lim - 6 && p->Yvel > 0) {
                p->Yvel = 0;
                HIWORD(p->Ypos) = HIWORD(p->OldYpos);
            }
        }
    }
    dword_CCC2C = 0;
    if (p->Zvel > 0) p->Zvel = 0;
}
