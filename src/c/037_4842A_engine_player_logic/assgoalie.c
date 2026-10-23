/* Engine player logic: the goalie's assignment and the assignments that end in its exit (assnearest,
   assrefsignal, assrefgoalpa). */
/* DRAFT: assgoalie same size, 25 differing under 10.0 GA (x and y are reused for the post distance and the
   far-side y, as in the EXE; the vecdist result is declared in its own block). Left: the vecdist result
   (`mov edx, eax` in the EXE), the SortCords loop's puckdist load (di in the EXE), the setl copy of the carrier
   side test and the epilogue (`pop ebp; jmp ass_popx`); see docs/UNSURE.md. assgoalie ends in ass_popx
   (assrefwhistle.c), so its match belongs in assrefwhistle.c between asspenalty and CountPuckThreat; the draft
   sits in its own file so the matched blocks there stay as they are. */
#define imul32 imul32_decl
#define PostGoalEvent PostGoalEvent_decl
#define ChkScorerMilestone ChkScorerMilestone_decl
#include "nhl95.h"
#undef imul32
#undef PostGoalEvent
#undef ChkScorerMilestone

int __cdecl imul32(int a, int b);  /* library: 32-bit product */
void PostGoalEvent(int side, int scorer, int a1, int a2, int b, int min, int sec);  /* 62343: int arguments here */
void ChkScorerMilestone(void);  /* 62807 */

#define CROWDUP() \
    if (crowdlevel <= 0x4B0 && (crowdlevel += 0x96) > 0x4B0) crowdlevel = 0x4B0

/* assgoalie (4B774; 93G assgoalie, PC version; ends in ass_popx): the goalie. Count down the save timer (+4Ah),
   lose the puck hold flag (+63h) when he has not got it, and set the crease flags (+48h bits 1 and 2, cleared in
   the crease, the inner one only between x -28h and 28h). Not at the bench (check4bench); a new assignment (bit 1)
   clears temp1, temp2 8 and +2Dh. Behind the goal line (y beyond E4h) skate out in front of the post (x A0h toward
   his side, or his own x beyond 30h). Out of the crease area (x beyond 34h, y from B3h to EFh) skate back to the
   crease (x 4 toward his side, y C4h). In it: the stance (SPA 99h with the puck, 1); with the clock stopped
   nothing else. Holding the puck in the crease counts down temp5 (a delay penalty when it runs out) and moves him
   toward the boards. Every aidef / 3 ticks (temp1): with the puck in the other half stand at the crease (D4h);
   holding it, after a while pass or freeze it (SPA 1135h when an attacker is within 14h, else chk4pass with threat
   set); against a shooter, now and then poke check (SPA 1095h) or dive (SPA 181h, the crowd up). Otherwise play
   the angle: face the puck, move toward the point on the line from the puck through the net (the shot speed and
   ShotLaneOpen pick the depth), or to the post the puck will cross (puckcross), with the save stances for a puck
   coming at him (dword_CCA5A by side and height, the crowd up) and a stop for a wraparound (assinsert 0Fh). Skate
   there (playeracc) or stop (StopNA). p: the goalie. No result. */
void assgoalie(Player *p)
{
    Player *q;
    short *pc;
    int x;
    int y;
    int ok;
    int ay;
    int a;
    short k;

    ok = 1;
    if (*(short *)((char *)p + 0x4A) > 0) (*(short *)((char *)p + 0x4A))--;
    if (*puckc != p->SCnum) ((unsigned char *)p)[0x63] = 0;
    ((unsigned char *)p)[0x48] |= 6;
    x = HIWORD(p->Xpos);
    y = HIWORD(p->Ypos);
    y = ABS(y);
    if (x >= -0x28 && x < 0x29 && y >= 0xC5 && y < 0xE4) ((unsigned char *)p)[0x48] &= 0xFB;
    if (x >= -0x30 && x < 0x31 && y >= 0xC5) ((unsigned char *)p)[0x48] &= 0xFD;
    if (check4bench(p)) return;
    if (p->pflags & 2) {
        p->pflags &= 0xFD;
        p->temp1 = 0;
        p->temp2 = 8;
        ((unsigned char *)p)[0x2D] = 0xFF;
    }
    if (y > 0xE4) {
        regd2.w = 0;
        if (ABS(x) <= 0x30) {
post:
            regd0.w = HIWORD(p->Xpos) < 0 ? -0xA0 : 0xA0;
        } else {
            regd0.w = x;
        }
        goto move;
    }
    if (ABS(x) > 0x34 || y >= 0xEF || y < 0xB3) {
        regd0.w = x >= 0 ? 4 : -4;
        regd1.w = p->pflags & 0x80 ? -0xC4 : 0xC4;
        skateto(p, 0);
        return;
    }
    if (!(p->pflags2 & 2) && !(p->pflags & 0x20)) SetSPA(p, *puckc == p->SCnum ? 0x99 : 1);
    if (gmode & 1) return;
    if (p->temp5 >= 0) {
        if (*puckc == p->SCnum) {
            if (y < 0x9B) p->temp5 = 0;
            if (--p->temp5 < 0) AddPenalty2(p, 4);
        } else {
            p->temp5 = -1;
        }
    }
    if (p->pflags2 & 2) return;
    if (--p->temp1 >= 0) {
        regd2.w = ((signed char *)p)[0x28];
        if (regd2.w <= 7) goto skate;
stop:
        StopNA(p);
        return;
    }
    p->temp1 = p->aidef / 3;
    if (!(p->pflags & 8)) {
        regd1.w = *pucky ^ HIWORD(p->Ypos);
        if (regd1.w < 0) {
            regd0.w = 0;
            regd2.w = p->pflags & 0x80 ? -0xD4 : 0xD4;
            goto move;
        }
        p->temp4--;
        if (*puckc == p->SCnum) {
            if (p->temp5 < 0) p->temp5 = 0x5A;
            p->temp4 = -1;
            if (p->temp5 < 0x5A && !randomd0(4)) {
                q = &SortCords[p->SCnum < 6 ? 6 : 0];
                for (k = 0; k < 6; k++, q++) {
                    if (!(q->pflags2 & 4) && q->position > 0 && q->puckdist < 0x23 && q->puckdist < 0x14) {
                        p->pflags |= 0x20;
                        p->pflags2 |= 2;
                        SetSPA(p, 0x1135);
                        return;
                    }
                }
                threat = 1;
                if (chk4pass(p)) return;
            }
            goto angle;
        }
    }
    regd0.w = *puckx - HIWORD(p->Xpos);
    regd1.w = *pucky - HIWORD(p->Ypos);
    if (*puckc >= 0) {
        if (*puckc >= 0 && (p->SCnum < 6) ^ (*puckc < 6) && *(short *)((char *)p + 0x4A) == 0
            && randomd0(0x100) < 0xA && p->puckdist < 0x23 && ABS(*pucky) < 0xE9) {
            p->facedir = vtoa(regd0.w, regd1.w);
            p->pflags |= 0x20;
            p->pflags2 |= 2;
            SetSPA(p, 0x1095);
            *(short *)((char *)p + 0x4A) = 0xF0;
            return;
        }
    } else {
        if (p->temp4 == 0 && p->puckdist < 0x2D && ABS(*pucky) < 0xE9
            && *(int *)((char *)p->optmptr + 0x3E) < 0x3C && randomd0(0x100) < 0xA) {
            p->facedir = vtoa(regd0.w, regd1.w);
            p->nopuck = 8;
            p->pflags |= 0x20;
            p->pflags2 |= 2;
            SetSPA(p, 0x181);
            *(short *)((char *)p + 0x4A) = 0x168;
            CROWDUP();
            return;
        }
    }
angle:
    pc = puckcross;
    regd3.w = 0xE4;
    regd4.w = 0xE8;
    if (p->pflags & 0x80) {
        regd3.w = -0xE4;
        regd4.w = -0xE8;
        pc += 2;
    }
    if (ABS(HIWORD(p->Ypos)) > 0xE4) {
        regd0.w = regd2.w = 0;
        if (ABS(HIWORD(p->Xpos)) > 0x30) goto move;
        goto post;
    }
    regd0.w = *puckx;
    regd1.w = *pucky;
    ClampYPosition(p);
    regd0.w = vtoa(regd0.w, regd1.w);
    regd1.w = p->facedir;
    if ((regd0.w -= regd1.w) != 0) {
        regd0.w = ((-regd0.w & 4) >> 1) - 1;
        if (!(1 << regd1.w & 0x42)) {
            regd1.w += regd0.w;
        } else {
            regd1.w += regd0.w;
            if ((!(p->pflags & 0x80) ? 0x83 : 0x38) & 1 << regd1.w) {
                regd0.w = -regd0.w;
                regd1.w += regd0.w * 2;
            }
        }
        regd1.w &= 7;
        p->facedir = regd1.w;
    }
    regd0.w = 0xE0;
    if (ABS(*pucky) > 0xBB) regd0.w -= 0x40;
    regd1.w = regd0.w;
    regd0.w = *puckx + (imul32(*puckvx, regd0.w) >> 16);
    regd1.w = *pucky + (imul32(*puckvy, regd1.w) >> 16);
    ClampYPosition(p);
    {
        int dist;

        dist = vecdist(regd0.w, regd1.w);
        if (dist >= 0x1E) {
            dist++;
            regd2.w = dist;
            if (ABS(*pucky) < 0x74 && ShotLaneOpen()) {
                regd4.w = 0x14;
                if (sflags & 8) regd4.w = 0x1C;
            } else {
                regd4.w = 0x12;
                if (sflags & 8) regd4.w = 0x1A;
            }
            regd1.w = regd1.w * regd4.w / regd2.w;
            regd4.w += 8;
            regd0.w = regd0.w * regd4.w / regd2.w;
        }
    }
    regd2.w = regd1.w += regd3.w;
    y = (*puckvy >> 9) + *pucky;
    if (*puckc < 0 && ABS(*pucky) < 0xE8 && ABS(HIWORD(p->Ypos)) > 0x74 && p->puckdist < 0x1E
        && ABS(y) > ABS(HIWORD(p->Ypos)))
        ok = 0;
    if (ok && (unsigned short)pc[1] >= 0x23) goto move;
    x = pc[0];
    if (ok && ABS(x) >= 0x19) {
        if (*puckc >= 0 || iflags & 4 || ABS(*puckx) < 0x44 || ABS(*puckvy) < 0x3800 || ABS(*pucky) < 0x98
            || (p->pflags & 0x80 ? -*puckvy : *puckvy) < -0x190 || *(int *)((char *)p->tmptr + 0x3E) < 0x132
            || *(int *)((char *)p->optmptr + 0x3E) < 0x132)
            goto move;
        assinsert(p, 0xF);
        return;
    }
    x -= HIWORD(p->Xpos);
    if (x < 0) x = -x;
    x -= 8;
    if (x > 0x10) x = 0x10;
    if (x < 0) x = 0;
    x >>= 2;
    ay = ABS(HIWORD(p->Ypos));
    if (y < 0) y = -y;
    if (y > ay) x += 4;
    if (ok && (p->puckdist > 0x19 || ABS(*pucky) > 0xE8)
        && ((unsigned short)pc[1] >= x + 0xC || ABS(*pucky) > 0xE9)) {
        regd0.w = pc[0];
        if (ABS(*pucky) > 0xDC) regd0.w = *puckx > 0 ? 0x18 : -0x18;
        goto move;
    }
    if (*puckc == p->SCnum || ABS(*puckx) >= 0x64 || *(short *)puckz >= 0x14) goto move;
    p->Xvel >>= 1;
    p->Yvel >>= 1;
    if (!(((unsigned char *)p)[0x48] & 2)) {
        regd0.w = (*puckvx >> 10) + *puckx - HIWORD(p->Xpos);
        regd1.w = (*puckvy >> 10) + *pucky - HIWORD(p->Ypos);
        a = vtoa(regd0.w, regd1.w);
        if (a == 8) regd3.w = 0;
        else regd3.w = (a - p->facedir) & 7;
    } else {
        regd3.w = (p->puckdir - p->facedir) & 7;
    }
    if (regd3.w == 4 && ABS(*puckvy) + ABS(*puckvx) <= 0x1200) {
        regd0.w = 8;
    } else {
        if (regd3.w == 0 || regd3.w == 4) {
            a = p->facedir;
            if (a == 0) regd3.w = regd0.w >= 0 ? 1 : 7;
            else if (a == 4) regd3.w = regd0.w >= 0 ? 7 : 1;
            else if (a == 1 || a == 5) regd3.w = ABS(regd0.w) >= ABS(regd1.w) ? 1 : 7;
            else if (a == 3 || a == 7) regd3.w = ABS(regd0.w) >= ABS(regd1.w) ? 7 : 1;
            else regd3.w = randomd0(2);
        }
        regd0.w = dword_E03AE >> 0x12;
        if (p->attribute & 8) regd0.w = regd0.w == 0;
        if (regd3.w >= 4) regd3.w = 7 - regd3.w;
        if (regd3.w >= 2 && *(short *)puckz < 0xA && *(short *)puckvz < 0x800) {
            regd0.w += 6;
        } else if (*(short *)puckz < 8 && *(short *)puckvz < 0x800) {
            regd0.w += 4;
            if ((unsigned short)pc[1] >= 9 && p->facedir != 2 && p->facedir != 6 && *puckc >= 0) regd0.w -= 2;
        }
    }
    p->pflags |= 0x20;
    p->pflags2 |= 2;
    SetSPA(p, ((short *)dword_CCA5A)[regd0.w + 1]);
    CROWDUP();
    regd0.w = pc[0];
    if (ABS(*pucky) > 0xDC) regd0.w = *puckx > 0 ? 0x18 : -0x18;
move:
    regd1.w = regd2.w;
    regd0.w -= ((signed char *)p)[0x0D] + (p->Xpos >> 16);
    regd1.w -= ((signed char *)p)[0x0F] + (p->Ypos >> 16);
    if (ok) {
        k = 5;
        if (ABS(regd0.w) < k && ABS(regd1.w) < k) regd0.w = regd1.w = 0;
    }
    regd2.w = ((signed char *)p)[0x28] = vtoa(regd0.w, regd1.w);
    if (regd2.w > 7) goto stop;
skate:
    playeracc(p, regd2.w);
}

/* assnearest (4CD4B; 93G assnearest, PC version; ends in assgoalie_popebp): the player nearest the puck. A new
   assignment (bit 1) clears temp1 and temp3 and sets temp2 8. Holding the puck: the goalie plays it (assgoalie),
   a skater not joystick controlled takes assignment 10h. Every aioff ticks (the byte at +27h): when his own team
   has the puck the carrier is the nearest; else find his team's skater nearest the puck's next spot (hot spot plus
   position minus the puck and its velocity / 40h, squared distances in regd0-regd2, not in the box, not on the
   bench, not assignment 13h; none for the penalty shooter), remembering the deepest one toward his own net (not
   behind the goal line), and store the distance in the team (+3Ah). Another player nearer takes the chase
   (assinsert 11h, this one exits). Otherwise maybe stay on him for 12Ch ticks (temp3): the odds grow with the
   distance (190h, E10h, a slow puck), the zone (position beyond 4Eh, as in the 93G code), a power play (gmode2
   bits 5 and 6) and a defenceman's aggression, checking and aidef, unless he is the deepest. Then, unless locked
   or joystick controlled (with the clock stopped stop, StopIfFree): chase the puck (skatetopuck), or while temp3
   runs with the opponents holding the puck, cut it off between the puck's next spot and his net (y halfway to
   D4h, x three quarters, kept within C8h / D2h of the goal line near the middle). Then check4check.
   p: the player. No result. */
void assnearest(Player *p)
{
    Player *q;
    Player *r;
    Team *t;
    short deep;
    short y;
    int dy;

    q = p;
    t = p->tmptr;
    if (p->pflags & 2) {
        p->pflags &= 0xFD;
        p->temp1 = 0;
        p->temp2 = 8;
        p->temp3 = 0;
    }
    if (*puckc == p->SCnum) {
        if (p->position == 0) assgoalie(p);
        else if (!(p->pflags & 8)) assinsert(p, 0x10);
        return;
    }
    if (--((signed char *)p)[0x27] < 0) {
        ((signed char *)p)[0x27] = p->aioff;
        *(int *)((char *)t + 0x3A) = 0;
        if (*puckc >= 0 && (*puckc < 6) == (p->SCnum < 6)) {
            q = &SortCords[*puckc];
            goto found;
        }
        deep = p->SCnum;
        y = HIWORD(p->Ypos);
        regd2.l = -1;
        regd4.w = 6;
        r = &SortCords[p->SCnum < 6 ? 0 : 6];
        if (p->SCnum != penshotplayer) {
            do {
                if (r->position > 0 && r->nopuck == 0 && !(r->pflags2 & 4) && r->asslist[r->assnum] != 0x13) {
                    if (ABS(HIWORD(r->Ypos)) < 0xE8
                        && (p->pflags & 0x80 && y >= HIWORD(r->Ypos) || !(p->pflags & 0x80) && y <= HIWORD(r->Ypos))) {
                        deep = r->SCnum;
                        y = HIWORD(r->Ypos);
                    }
                    GetHot(r);
                    regd0.w = regd0.w + HIWORD(r->Xpos) - *puckx - (*puckvx >> 6);
                    regd0.l = regd0.w * regd0.w;
                    dy = regd1.w + HIWORD(r->Ypos);
                    regd1.w = dy - *pucky - (*puckvy >> 6);
                    regd1.l = regd1.w * regd1.w;
                    regd0.l += regd1.l;
                    if ((unsigned long)regd0.l <= (unsigned long)regd2.l) {
                        regd2.l = regd0.l;
                        q = r;
                    }
                }
                r++;
            } while (--regd4.w);
        }
        if (regd2.l < 0) goto chance;
        *(int *)((char *)t + 0x3A) = regd2.l;
found:
        if (q != p && !(gmode & 1) && q->position > 0 && !(q->pflags2 & 4)) {
            q->pflags &= 0xFE;
            assinsert(q, 0x11);
            assexit(p);
            return;
        }
chance:
        if (p->pflags & 0x20) return;
        regd1.l = 2;
        if (regd2.w <= 0x190 || regd2.w <= 0xE10 && ABS(*puckvx) < 0x1F4 && ABS(*puckvy) < 0x1F4
            || p->position > 2 && (p->pflags & 0x80 && p->position > 0x4E || !(p->pflags & 0x80) && p->position < -0x4E)) {
            regd1.w -= 2;
            if (p->position <= 2
                && (p->SCnum == deep || randomd0((0x32 - p->aggress - p->checking - p->aidef) / 2)))
                goto play;
        }
        if (ABS(*puckvx) < 0x1F4 && ABS(*puckvy) < 0x1F4) regd1.w--;
        if (gmode2 & 0x20) {
            regd1.w -= 2;
            if (((unsigned char)p->pflags & 0x40) ^ (*(short *)&gmode2 & 0x40)) regd1.l += 4;
        }
        if (regd1.w < 0) regd0.w = (0x14 - p->checking) >> -regd1.w;
        else regd0.w = (0x14 - p->checking) << regd1.w;
        if ((unsigned short)randomd0(regd0.w) <= 1) p->temp3 = 0x12C;
    }
play:
    if (p->pflags & 0x20) return;
    if (gmode & 1) {
        if (!check4bench(p)) StopIfFree(p);
        return;
    }
    if (p->pflags & 8) return;
    if (*puckc < 0 || --p->temp3 >= 0) {
        skatetopuck(p);
    } else {
        p->temp3 = 0;
        regd0.w = *puckx + (short)(((signed char *)puckvx)[1] >> 1);
        regd1.w = *pucky + (short)(((signed char *)puckvy)[1] >> 1);
        regd0.w = regd0.w * 3 / 4;
        regd1.w += ((p->pflags & 0x80 ? -0xD4 : 0xD4) - regd1.w) >> 1;
        if (ABS(regd1.w) > ABS(*pucky) && ABS(*puckx) < 0x41 && ABS(regd1.w - *pucky) > 0x14) {
            if (ABS(regd0.w) < 0x14) {
                if (ABS(regd1.w) > 0xC8) regd1.w = regd1.w < 0 ? -0xC8 : 0xC8;
            } else if (ABS(regd0.w) < 0x28) {
                if (ABS(regd1.w) > 0xD2) regd1.w = regd1.w < 0 ? -0xD2 : 0xD2;
            }
        }
        skateto(p, 0);
    }
    check4check(p);
}

/* assrefsignal (4EB04; 93G assrefsignal, PC version; ends in assgoalie_popebp): the referee's call. Not while
   locked (pflags bit 5). A new assignment (bit 1): for a call without a signal direction (word_CCA9C by RefPen
   negative) post a goal event for a goal call (RefPen 7: the scoring team from the puck's end and the period, its
   scorer and assists, the time left in the period in minutes and seconds) and go on to assignment 21h; else stand
   at (A0h, 0) with temp2 8 (pflags2 bit 5). Then skate to the spot (SkateToSpot) unless within 0Ch in y and not
   more than 14h short in x; there, every 8 ticks (temp1) take the signal stance (SPA A5Bh), stop and turn one step
   toward the call's direction (word_CCA9C by RefPen); facing it, make the signal (SPA from dword_CCAD8 by RefPen,
   locked) and go on to assignment 21h. p: the referee. No result. */
void assrefsignal(Player *p)
{
    Team *t;
    int tm;
    int side;

    if (p->pflags & 0x20) return;
    if (p->pflags & 2) {
        p->pflags &= 0xFD;
        if (word_CCA9C[RefPen] < 0) {
            if (RefPen == 7) {
                side = (*pucky < 0) ^ ((gmode & 2) != 0);
                t = side > 0 ? &awtmstruct : &hmtmstruct;
                tm = PerTimeTotal - gameclock;
                if (gameclock < 0x3C && clockticks[0]) tm--;
                PostGoalEvent(side, *(short *)((char *)t + 0x30),
                    *(short *)((char *)t + 0x32) < 0 ? -1 : *(short *)((char *)t + 0x32),
                    *(short *)((char *)t + 0x34) < 0 ? -1 : *(short *)((char *)t + 0x34), word_E9AB0, tm / 0x3C,
                    tm % 0x3C);
            }
            assreplace(p, 0x21);
            return;
        }
        p->temp2 = 8;
        p->temp4 = 0;
        p->temp3 = 0xA0;
        p->temp1 = 0;
        p->pflags2 |= 0x20;
        p->Wallcos = 0;
        p->Wallsin = 0;
    }
    regd0.w = HIWORD(p->Ypos) - p->temp4;
    if (ABS(regd0.w) <= 0xC) {
        regd0.w = HIWORD(p->Xpos) - p->temp3;
        if (regd0.w >= -0x14) {
            if (--p->temp1 >= 0) return;
            p->temp1 += 8;
            SetSPA(p, 0xA5B);
            regd2.w = word_CCA9C[RefPen];
            if (regd2.w != p->facedir) {
                regd2.w = (regd2.w - p->facedir) & 7;
                p->facedir = (p->facedir + (regd2.w < 5 ? 1 : -1)) & 7;
            }
            p->Yvel = 0;
            p->Xvel = 0;
            if (regd2.w == p->facedir) {
                p->pflags |= 0x20;
                SetSPA(p, ((short *)dword_CCAD8)[RefPen + 1]);
                assreplace(p, 0x21);
            }
            return;
        }
    }
    regd0.w = p->temp3;
    regd1.w = p->temp4;
    SkateToSpot(p, 0);
}

/* DRAFT: 2,114 vs 2,115 bytes under 10.0 GA, 67 differing: each branch stores regd1 itself (the EXE's 16-bit
   y difference, the shared store cross-jumped). The EXE saves ebp too (it holds temp3 - puckx in the goal-line
   crossings, computed after the constant - pucky factor) and keeps the goal-call bytes in other registers; see
   docs/UNSURE.md. */
/* assrefgoalpa (4ED7C; 93G assrefgoalpa, PC version; ends in assgoalie_popebp): the referee after a goal or a
   penalty call goes to the puck. Not while locked (pflags bit 5). While the goal overlay runs (ovlseq neither 0 nor
   2, ovltimer below 100h) hold the signal stance (SPA A5Bh); from ovltimer ECh on, once (byte_E9AD3 1) have the
   announcer call the goal (PaGoal: the scoring team's abbreviation, the number of assists and the jersey numbers of
   scorer and assistants, byte_E9AD4-E9AD7; input sampling off meanwhile) and in overtime cut the overlay short. With
   a penalty pending (PenBuf) just signal. With the puck beyond A0h / 112h go on to assignment 24h. A new
   assignment: at the end of the period (or after an overtime goal, or with word_CBEC6) stop the play (assignment 1Eh,
   the puck 1Bh); else set up the faceoff walk (RefStep 1, PenShotAssign, the signal stance) and react to the call:
   a penalty to a goalie (RefPen 4: the goalie note, else the team's PPV overlay), a goal (RefPen 7: in the
   shoot-out end the game, else ChkScorerMilestone), others the crowd (CrowdOnStoppage). Then, with no deferred call:
   take the puck from its carrier (assignment 1Ah); after 258h ticks drop it and go to assignment 22h. Skate to the
   puck's resting spot (where it will cross the goal line, or the puck itself when it is too close to the net) and,
   within 0Ch of it (not behind the net), every 8 ticks turn toward the puck and, facing it, pick it up (the puck
   held at -100, SPA C03h, assignment 22h). p: the referee. No result. */
void assrefgoalpa(Player *p)
{
    short a1;
    short sc;
    short team;
    short side;
    short a2;
    short n;
    int c;
    int ok;

    if (p->pflags & 0x20) return;
    if (ovlseq != 2 && ovlseq != 0 && ovltimer >= 0 && ovltimer < 0x100) {
        SetSPA(p, 0xA5B);
        if (ovltimer < 0xEC) return;
        if (byte_E9AD3 != 1) return;
        side = byte_E9AD4;
        sc = byte_E9AD5;
        a1 = byte_E9AD6;
        a2 = byte_E9AD7;
        n = 0;
        if (a1 != 0xFF) n = 1;
        if (a2 != 0xFF) n++;
        team = side ? VisTeam : HomeTeam;
        joysampling_save = joysampling;
        joysampling = 0;
        PaGoal((char *)teamabbrevs[team], n, hmrosterjersey[side * 0x444 + sc * 39],
            hmrosterjersey[side * 0x444 + a1 * 39], hmrosterjersey[side * 0x444 + a2 * 39]);
        joysampling = joysampling_save;
        byte_E9AD3 = 0xFF;
        if (gsp >= 3) ovltimer = 0x38;
        return;
    }
    if (PenBuf[0]) {
        SetSPA(p, 0xA5B);
        RefStep[0] = -1;
        return;
    }
    if (ABS(*puckx) > 0xA0 || ABS(*pucky) > 0x112) {
        assreplace(p, 0x24);
        return;
    }
    if (p->pflags & 2) {
        if (word_CBEC6 || !gameclock && !clockticks[0] || gsp == 3 && hmscore[0] != awscore) {
            RefStep[0] = -1;
            if (ovltimer == 0x100) ovltimer = 0x258;
            assreplace((Player *)puckstruct, 0x1B);
            assreplace(p, 0x1E);
            return;
        }
        RefStep[0] = 1;
        p->pflags &= 0xFD;
        PenShotAssign();
        p->temp2 = 8;
        p->temp1 = 0;
        p->temp5 = 0;
        p->pflags2 |= 0x20;
        p->Wallcos = 0;
        p->Wallsin = 0;
        SetSPA(p, 0xA5B);
        if (RefPen == 4) {
            if (!QueueGoalieNote()) {
                if (byte_DF87F[word_C90D8 << 7] && !dword_E9A9E) {
                    byte_DF87F[word_C90D8 << 7] = 0;
                    LoadTeamPPV(8);
                    if (ovlseq != -1) {
                        dword_E9A9E = 1;
                        CloseTextOverlay();
                        return;
                    }
                } else if (CrowdOnStoppage()) {
                    return;
                }
            }
        } else if (RefPen == 7) {
            if (gmode & 0x10) {
                exitgame = 1;
                return;
            }
            ChkScorerMilestone();
        } else if (CrowdOnStoppage()) {
            return;
        }
        if (ovltimer == 0x100) ovltimer = 0x258;
    }
    if (deferpending) return;
    if (*puckc >= 0) {
        *puckc = -1;
        assreplace((Player *)puckstruct, 0x1A);
    }
    if (p->temp5 > 0x258) {
        *puckc = 0x10;
        *puckvx = 0;
        *puckvy = 0;
        *(short *)puckvz = 0;
        *(short *)puckz = 0x64;
        assreplace(p, 0x22);
        return;
    }
    if (ABS(*puckx) == 6 && ABS(*pucky) == 0xF0) {
        p->temp3 = *puckx;
        p->temp4 = *pucky < 0 ? -0xE3 : 0xE3;
        regd0.w = HIWORD(p->Xpos) - p->temp3;
        regd1.w = HIWORD(p->Ypos) - (*pucky < 0 ? -0xEE : 0xEE);
    } else {
        p->temp3 = *puckx + (*puckvx >> 7);
        p->temp4 = *pucky + (*puckvy >> 7);
        regd0.w = vtoa(*puckvx, *puckvy);
        regd1.w = vtoa((short)(HIWORD(p->Xpos) - *puckx), (short)(HIWORD(p->Ypos) - *pucky));
        if (regd0.w > 7 || regd1.w > 7 || regd1.w == regd0.w) {
            p->temp3 = *puckx;
            p->temp4 = *pucky;
        }
        if ((*pucky - 0xE8 ^ p->temp4 - 0xE8) < 0) {
            c = (p->temp3 - *puckx) * (0xE8 - *pucky);
            if (p->temp4 - *pucky) c /= p->temp4 - *pucky;
            regd0.w = c + *puckx;
            if (ABS(regd0.w) < 0x19) {
                p->temp3 = *puckx;
                p->temp4 = *pucky;
            }
        }
        if ((*pucky + 0xE8 ^ p->temp4 + 0xE8) < 0) {
            c = (-0xE8 - *pucky) * (p->temp3 - *puckx);
            if (p->temp4 - *pucky) c /= p->temp4 - *pucky;
            regd0.w = c + *puckx;
            if (ABS(regd0.w) < 0x19) {
                p->temp3 = *puckx;
                p->temp4 = *pucky;
            }
        }
        regd0.w = HIWORD(p->Xpos) - *puckx;
        regd1.w = HIWORD(p->Ypos) - *pucky;
    }
    if (ABS(regd0.w) <= 0xC && ABS(regd1.w) <= 0xC) {
        ok = ABS(*puckx) != 6 || ABS(*pucky) != 0xF0 || ABS(HIWORD(p->Ypos)) <= 0xE8;
        if (ok) {
            if (--p->temp1 >= 0) return;
            p->temp1 += 8;
            SetSPA(p, 0xA5B);
            regd2.w = vtoa((short)(*puckx - HIWORD(p->Xpos)), (short)(*pucky - HIWORD(p->Ypos)));
            if (regd2.w < 8 && (regd2.w - p->facedir + 1 & 7) > 2) {
                regd2.w = (regd2.w - p->facedir) & 7;
                p->facedir = ((regd2.w < 5 ? 1 : -1) + p->facedir) & 7;
            } else {
                p->Xvel = p->Yvel = 0;
                *puckc = 0x10;
                *puckvx = 0;
                *puckvy = 0;
                *(short *)puckvz = 0;
                *(short *)puckz = -100;
                if (regd2.w < 8) p->facedir = regd2.w;
                p->pflags |= 0x20;
                SetSPA(p, 0xC03);
                assreplace(p, 0x22);
                return;
            }
        }
    }
    p->temp5++;
    regd0.w = p->temp3;
    regd1.w = p->temp4;
    SkateToSpot(p, 0);
}
