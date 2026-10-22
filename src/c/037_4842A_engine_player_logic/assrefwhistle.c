/* Engine player logic: referee whistles, signals and drops. */
#include "nhl95.h"

/* assdefd (49E3A; 94G assign94 assdefd, PC version; ends in ass_popx): the defenceman's defensive assignment.
   Not while locked (pflags bit 5), at the bench (check4bench) or joystick controlled (bit 3); with the clock
   stopped (gmode bit 0) just stop (StopIfFree). A new assignment (bit 1) clears temp1 and sets temp2 8. Every aidef
   ticks (the high byte of temp1): when the puck (its y plus the forward part of its y velocity / 40h, toward
   the attacked end) is past 4Eh, not offside (tmflags bit 4) and his own team has it (and, with gmode2 bit 5, he
   is on the gmode2 bit 6 side) switch to the offensive defenceman (assignment 1). Else hold the blue line: x
   50h (left, position 2) or -50h, y 32h beyond the deepest opposing skater (his y plus his velocity toward the
   goal / 10h; not those in the box, pflags2 bit 2), at least C3h deep at the far end (AAh and beyond); mirrored
   for the other end (pflags bit 7). With the puck on the other side of the ice go to the middle (x 0, B6h on the
   goal line). Skate there with EvadePC, then check for a body check (check4check). p: the defenceman.
   No result. */
void assdefd(Player *p)
{
    Player *q;

    if (p->pflags & 0x20) return;
    if (check4bench(p)) return;
    if (gmode & 1) {
        StopIfFree(p);
        return;
    }
    if (p->pflags & 8) return;
    if (p->pflags & 2) {
        p->pflags &= 0xFD;
        p->temp1 = 0;
        p->temp2 = 8;
    }
    if (--((signed char *)p)[0x27] < 0) {
        ((signed char *)p)[0x27] = p->aidef;
        regd1.w = *pucky;
        regd3.w = *puckvy >> 6;
        if (!(p->pflags & 0x80)) {
            regd1.w = -regd1.w;
            regd3.w = -regd3.w;
        }
        if (regd3.w < 0) regd3.w = 0;
        regd3.w += regd1.w;
        if (regd3.w >= 0x4E && !(p->tmptr->tmflags & 0x10) && *puckc >= 0
            && (!(gmode2 & 0x20) || !(((unsigned char)p->pflags & 0x40) ^ (*(short *)&gmode2 & 0x40)) ? 1 : 0)
            && *puckc >= 0 && (*puckc < 6) == (p->SCnum < 6)) {
            assreplace(p, 1);
            return;
        }
        p->temp3 = p->position == 2 ? 0x50 : -0x50;
        q = &SortCords[p->SCnum < 6 ? 6 : 0];
        regd2.w = 6;
        if (p->pflags & 0x80) {
            regd0.w = 0x3E8;
            do {
                if (!(q->pflags2 & 4) && q->position >= 0) {
                    regd1.w = q->Yvel;
                    if (regd1.w > 0) regd1.w = 0;
                    regd1.w = (regd1.w >> 4) + HIWORD(q->Ypos);
                    if (regd1.w <= regd0.w) regd0.w = regd1.w;
                }
                q++;
            } while (--regd2.w);
            regd0.w -= 0x32;
            if (regd0.w <= -0xAA) regd0.w = -0xC3;
            p->temp4 = regd0.w;
        } else {
            regd0.w = -0x3E8;
            do {
                if (!(q->pflags2 & 4) && q->position >= 0) {
                    regd1.w = q->Yvel;
                    if (regd1.w < 0) regd1.w = 0;
                    regd1.w = (regd1.w >> 4) + HIWORD(q->Ypos);
                    if (regd1.w >= regd0.w) regd0.w = regd1.w;
                }
                q++;
            } while (--regd2.w);
            regd0.w += 0x32;
            if (regd0.w >= 0xAA) regd0.w = 0xC3;
            p->temp4 = regd0.w;
            p->temp3 = -p->temp3;
        }
        if ((p->temp3 ^ *puckx) < 0) {
            p->temp3 = 0;
            if ((regd0.w < 0 ? -regd0.w : regd0.w) == 0xC3) p->temp4 = regd0.w < 0 ? -0xB6 : 0xB6;
        }
    }
    regd0.w = p->temp3;
    regd1.w = p->temp4;
    skateto(p, (void (*)(Player *))EvadePC);
    check4check(p);
}

/* asswingd (4A1A6; 94G assign94 asswingd, PC version; ends in ass_popx, owner of asswingd_skate0 /
   asswingd_skateto): the winger's defensive assignment. Not while locked (pflags bit 5), at the bench
   (check4bench) or joystick controlled (bit 3); with the clock stopped (gmode bit 0) just stop (StopIfFree). A new
   assignment (bit 1) clears temp1 and sets temp2 8. Every aioff ticks (the high byte of temp1) switch to the
   offensive winger (assignment 4) when his own team has the puck. Else skate to the wing (x 78h, -78h for the
   right wing, toward the puck's side when the puck is on it) between the blue line (8Eh) and the slot (44h,
   following the puck down to the goal line E8h; offside, tmflags bit 4: stay at 44h); mirrored for the other
   end (pflags bit 7). p: the winger. No result. */
void asswingd(Player *p)
{
    if (p->pflags & 0x20) return;
    if (check4bench(p)) return;
    if (gmode & 1) {
        StopIfFree(p);
        return;
    }
    if (p->pflags & 8) return;
    if (p->pflags & 2) {
        p->pflags &= 0xFD;
        p->temp1 = 0;
        p->temp2 = 8;
    }
    if (--((signed char *)p)[0x27] < 0) {
        ((signed char *)p)[0x27] = p->aioff;
        if (*puckc >= 0 && (*puckc < 6) == (p->SCnum < 6)) {
            assreplace(p, 4);
            return;
        }
    }
    regd0.l = p->position == 5 ? -0x78 : 0x78;
    regd1.w = 0x8E;
    regd2.w = 0x44;
    if (p->pflags & 0x80) {
        regd0.w = -regd0.w;
        regd1.w = -0x8E;
        regd2.w = -0x44;
        if (p->tmptr->tmflags & 0x10) regd1.w = regd2.w;
        else if (*pucky >= regd2.w) regd1.w = *pucky;
        else {
            regd2.w = -0xE8;
            if (regd2.w >= *pucky) regd1.w = regd2.w;
        }
    } else {
        if (p->tmptr->tmflags & 0x10) regd1.w = regd2.w;
        else if (*pucky <= regd2.w) regd1.w = *pucky;
        else {
            regd2.w = 0xE8;
            if (regd2.w <= *pucky) regd1.w = regd2.w;
        }
    }
    if ((*puckx ^ regd0.w) >= 0) regd0.w = *puckx;
    skateto(p, 0);
}

/* asswingo (4A343; 94G assign94 asswingo, PC version; ends in asswingd_skateto): the winger's offensive
   assignment. Not while locked (pflags bit 5), at the bench (check4bench) or joystick controlled (bit 3); with the
   clock stopped (gmode bit 0) just stop (StopIfFree). A new assignment (bit 1) sets the high byte of temp5 to -1,
   clears temp1 and sets temp2 8. Every aioff ticks (the high byte of temp1) switch to the defensive winger
   (assignment 3) when the other team has the puck. The puck's zone (its y plus the y velocity / 40h, toward the
   attacked end: 0 before the far blue line, 4 neutral, 8 in the zone, 0Ch below the goal line; 4 while offside,
   tmflags bit 4) picks a spot from word_CCA18 (x, x range, y, y range per zone): a new zone, or 1 in 80h ticks,
   picks a random spot into temp3 (+ aioff) / temp4. Skate there (x mirrored for the right wing, both for the
   other end, pflags bit 7) with EvadePC. p: the winger. No result. */
void asswingo(Player *p)
{
    short d;

    if (p->pflags & 0x20) return;
    if (check4bench(p)) return;
    if (gmode & 1) {
        StopIfFree(p);
        return;
    }
    if (p->pflags & 8) return;
    if (p->pflags & 2) {
        p->pflags &= 0xFD;
        ((signed char *)p)[0x2F] = -1;
        p->temp1 = 0;
        p->temp2 = 8;
    }
    if (--((signed char *)p)[0x27] < 0) {
        ((signed char *)p)[0x27] = p->aioff;
        if (*puckc >= 0 && (p->SCnum < 6) ^ (*puckc < 6)) {
            assreplace(p, 3);
            return;
        }
        regd0.w = *pucky;
        regd3.w = (*puckvy >> 6) + regd0.w;
        if (!(p->pflags & 0x80)) {
            regd0.w = -regd0.w;
            regd3.w = -regd3.w;
        }
        d = 0;
        if (regd3.w >= -0x4E) {
            d = 4;
            if (regd0.w >= 0x4E && !(p->tmptr->tmflags & 0x10)) {
                d = 8;
                if (regd3.w >= 0xE8) d = 0xC;
            }
        }
        if (d != p->temp5 || !(regd0.w = randomd0(0x80))) {
            p->temp5 = d;
            p->temp3 = word_CCA18[d] + (randomd0(word_CCA1A[d] * 2) - word_CCA1A[d]) + p->aioff;
            p->temp4 = randomd0(word_CCA1E[d] * 2) - word_CCA1E[d] + word_CCA1C[d];
        }
    }
    regd0.w = p->temp3;
    if (p->position != 5) regd0.w = -regd0.w;
    regd1.w = p->temp4;
    if (!(p->pflags & 0x80)) {
        regd0.w = -regd0.w;
        regd1.w = -regd1.w;
    }
    skateto(p, (void (*)(Player *))EvadePC);
}

/* asscentero (4A65C; 94G assign94 asscentero, PC version; ends in ass_popx / asswingo_evade): the centre's
   offensive assignment, asswingo without the wing side. Not while locked (pflags bit 5), at the bench
   (check4bench) or joystick controlled (bit 3); with the clock stopped (gmode bit 0) just stop (StopIfFree). A
   new assignment (bit 1) sets the high byte of temp5 to -1, clears temp1 and sets temp2 8. Every aioff ticks (the
   high byte of temp1) switch to the defensive centre (assignment 5) when the other team has the puck. The puck's
   zone (its y toward the attacked end: 0 before the far blue line, 4 neutral, 8 in the zone, 0Ch below the goal
   line; 4 while offside, tmflags bit 4) picks a spot from word_CCA38 (x, x range, y, y range per zone): a new
   zone, or 1 in 80h ticks, picks a random spot into temp3 / temp4. Skate there (y mirrored for the other end,
   pflags bit 7) with EvadePC. p: the centre. No result. */
void asscentero(Player *p)
{
    short d;

    if (p->pflags & 0x20) return;
    if (check4bench(p)) return;
    if (gmode & 1) {
        StopIfFree(p);
        return;
    }
    if (p->pflags & 8) return;
    if (p->pflags & 2) {
        p->pflags &= 0xFD;
        ((signed char *)p)[0x2F] = -1;
        p->temp1 = 0;
        p->temp2 = 8;
    }
    if (--((signed char *)p)[0x27] < 0) {
        ((signed char *)p)[0x27] = p->aioff;
        if (*puckc >= 0 && (p->SCnum < 6) ^ (*puckc < 6)) {
            assreplace(p, 5);
            return;
        }
        regd0.w = *pucky;
        if (!(p->pflags & 0x80)) regd0.w = -regd0.w;
        d = 0;
        if (regd0.w >= -0x4E) {
            d = 4;
            if (regd0.w >= 0x4E && !(p->tmptr->tmflags & 0x10)) {
                d = 8;
                if (regd0.w >= 0xE8) d = 0xC;
            }
        }
        if (d != p->temp5 || !(regd0.w = randomd0(0x80))) {
            p->temp5 = d;
            p->temp3 = randomd0(word_CCA3A[d] * 2) - word_CCA3A[d] + word_CCA38[d];
            p->temp4 = randomd0(word_CCA3E[d] * 2) - word_CCA3E[d] + word_CCA3C[d];
        }
    }
    regd0.w = p->temp3;
    regd1.w = p->temp4;
    if (!(p->pflags & 0x80)) regd1.w = -regd1.w;
    skateto(p, (void (*)(Player *))EvadePC);
}

/* asspenalty (4ADAB; 94G assign94 asspenalty "player a3 goes to the penalty box", PC version; ends in ass_popx /
   asswingd_skate0): not while locked (pflags bit 5). A new assignment (bit 1) marks him unavailable (pflags2 bit
   2), takes a human controller off him (changeplayer: controller 0 for c1playernum, else 2) and picks his seat in
   his team's box (x A0h, y 3 + the number already there (PBnum, at most 2) times -11 / 11 by team, pflags bit 6).
   Away from it (y more than 0Ch, x short of it by 18h) he skates there (skateto); in it, every 8 ticks (temp1) he
   turns toward facing 4 (SPA 289h, pflags bit 2) gliding in (x speed 1000h); once past x -8 and facing it he
   sits: locked, facing 2, SPA 7A1h, pflags2 bit 4 off, his team's tmap one less (down to 4), assignment 0Dh.
   p: the player. No result. */
void asspenalty(Player *p)
{
    if (p->pflags & 0x20) return;
    if (p->pflags & 2) {
        p->pflags &= 0xFD;
        p->pflags2 |= 4;
        if (p->pflags & 8) {
            if (p->SCnum == c1playernum[0]) regd4.w = 0;
            else regd4.w = 2;
            changeplayer(p, regd4.w);
        }
        p->temp2 = 8;
        if (!(p->pflags & 0x40)) {
            regd1.w = PBnum[0];
            regd0.l = -11;
        } else {
            regd1.w = PBnum[1];
            regd0.l = 11;
        }
        regd1.w &= 0xF;
        if (regd1.w > 2) regd1.l = 2;
        regd1.w += 3;
        p->temp4 = regd1.w * regd0.w;
        p->temp3 = 0xA0;
        p->temp1 = 0;
        p->pflags2 |= 0x20;
        p->Wallcos = 0;
        p->Wallsin = 0;
    }
    regd0.w = HIWORD(p->Ypos) - p->temp4;
    if ((regd0.w < 0 ? -regd0.w : regd0.w) > 0xC) goto skate;
    regd0.w = HIWORD(p->Xpos) - p->temp3;
    if (regd0.w < -0x18) goto skate;
    if (--p->temp1 >= 0) return;
    p->temp1 += 8;
    p->pflags |= 4;
    SetSPA(p, 0x289);
    regd2.w = 4;
    if (p->facedir != regd2.w) {
        regd2.w = (regd2.w - p->facedir) & 7;
        p->facedir = (regd2.w < 5 ? 1 : -1) + (*(int *)((char *)&p->facedir - 2) >> 16) & 7;
    }
    p->Yvel = 0;
    p->Xvel = 0x1000;
    if (regd0.w < -8) return;
    p->Xvel = 0;
    if (regd2.w != p->facedir) return;
    p->pflags |= 0x20;
    p->facedir = 2;
    SetSPA(p, 0x7A1);
    p->pflags2 &= 0xEF;
    if (p->tmptr->tmap > 4) p->tmptr->tmap--;
    assreplace(p, 0xD);
    return;
skate:
    regd0.w = p->temp3;
    regd1.w = p->temp4;
    skateto(p, 0);
}

/* CountPuckThreat (4C632, PC only; ends in ass_popx): count into threat the opposing skaters within 14h (x and
   y) of where the puck goes next (the puck plus the goalie's velocity / 100h), each skater also taken one step
   ahead. p: the goalie (SCnum below 6 is the home side: look at the away skaters, SortCords + 6). No result. */
void CountPuckThreat(Player *p)
{
    short y;
    Player *q;
    short x;
    short i;
    short d;

    x = (p->Xvel >> 8) + *puckx;
    y = (p->Yvel >> 8) + *pucky;
    threat = 0;
    q = &SortCords[p->SCnum < 6 ? 6 : 0];
    for (i = 0; i < 6; q++, i++) {
        d = (q->Xvel >> 8) + HIWORD(q->Xpos) - x;
        if ((d < 0 ? -d : d) > 0x14) continue;
        d = (q->Yvel >> 8) + HIWORD(q->Ypos) - y;
        if ((d < 0 ? -d : d) > 0x14) continue;
        threat++;
    }
}

#define OLDYPOS(p) (*(short *)((char *)(p) + 0x7A))  /* integer word of the 93G OldYpos (+78h, after OldXpos) */

/* pucknorm_body (4D6B4; 93G logic93 / 94G pucknorm after the new-assignment part, PC version; ends in ass_popx):
   the puck's normal assignment. Count down the two line-crossing timers (puckcross) and every 5 ticks
   recompute them (temp1, calcpuckcross). A carried puck is pulled a quarter of the way toward its carrier's hot
   spot (a2touchpuck, GetHot into regd0 / regd1) and takes his velocity. Then the ice / offside / two-line checks
   (puckIChk, ChkOffsides, MarkTwoLinePlayers). While the clock runs: a carried puck resets temp2 (78h) and the
   penalty-shot send count (psendcount); a loose one on a live penalty shot moving back toward the shooter's
   own end (puckvy by penshotteam and the gmode bit 1 rink flip) for 1Eh ticks ends the shot (EndPenaltyShot). A
   puck that has stopped (same position as last tick), outside the middle (x A3h, y 10Eh) or with dword_DF652 /
   dword_DF752 at 14h or less, counts temp2 down and at 0 calls a delay of game (AddPenalty2 3); a moving one
   resets temp2. A puck almost still on the ice (z speed below 100h, z 0) is put flat (puckunflip); then the
   collisions (PuckCheckColl). p: the puck. No result. */
void pucknorm_body(Player *p)
{
    Player *c;
    int e;

    puckcross[1]--;
    puckcross[3]--;
    if (--p->temp1 < 0) {
        p->temp1 += 5;
        ((void (*)(Player *))calcpuckcross)(p);
    }
    if (*puckc >= 0) {
        c = &SortCords[*puckc];
        a2touchpuck(c);
        GetHot(c);
        HIWORD(p->Xpos) += (regd0.w + (c->Xpos >> 16) - HIWORD(p->Xpos)) >> 2;
        HIWORD(p->Ypos) += (regd1.w + (c->Ypos >> 16) - HIWORD(p->Ypos)) >> 2;
        p->Xvel = c->Xvel;
        p->Yvel = c->Yvel;
    }
    puckIChk();
    ChkOffsides(p);
    MarkTwoLinePlayers(p);
    if (!(gmode & 1)) {
        if (*puckc >= 0) {
            psendcount = 0;
reset:
            p->temp2 = 0x78;
        } else {
            e = !(gmode & 2) ^ penshotteam;
            if (penshotlive && (!e && *puckvy >= 0 || e && *puckvy <= 0)) {
                if (++psendcount >= 0x1E) {
                    EndPenaltyShot();
                    psendcount = 0;
                }
            } else psendcount = 0;
            if (HIWORD(p->Xpos) != HIWORD(p->OldXpos) || HIWORD(p->Ypos) != OLDYPOS(p)) goto reset;
            if ((*puckx < 0 ? -*puckx : *puckx) < 0xA3 && (*pucky < 0 ? -*pucky : *pucky) < 0x10E
                && dword_DF652 > 0x14 && dword_DF752 > 0x14) goto reset;
            if (--p->temp2 < 0) AddPenalty2(p, 3);
        }
    }
    if ((p->Zvel < 0 ? -p->Zvel : p->Zvel) < 0x100 && !HIWORD(p->Zpos)) puckunflip(p);
    PuckCheckColl(p);
}

/* RequestLineChange (4D938, PC only; ends in ass_popx): open the line change box for p's team (pflags bit 6 =
   away): the choice 1 through getlchoice gives the line (lcsel 1, lcline), or when there is none lcsel 0 and the
   team's current line (tmline); then the box shows (lctimer 3Ch, lcblink 1, lcblinktime 0Ch, lcboxon 1) and that
   side's dword_C585C / dword_C5860 is cleared. p: a player of the team. No result. */
void RequestLineChange(Player *p)
{
    short side;
    short s;
    short one;

    side = (p->pflags & 0x40) != 0;
    s = side;
    one = 1;
    regd0.w = one;
    getlchoice(p);
    if (regd0.w < 0) {
        lcsel[side] = 0;
        lcline[s] = (side > 0 ? &awtmstruct : &hmtmstruct)->tmline;
    } else {
        lcsel[side] = one;
        lcline[side] = regd0.w;
    }
    lctimer[s] = 0x3C;
    lcblink[s] = 1;
    lcblinktime[s] = 0xC;
    lcboxon[s] = 1;
    if (s) dword_C5860 = 0;
    else dword_C585C = 0;
}

/* Endfaceoff (4DA7B; 93G logic93 / 94G checks94 Endfaceoff "drop the puck: pick the faceoff winner and send the
   puck off", PC version; ends in ass_popx): stop the sample, play sfx ABh, end the faceoff (gmode2 bits 0 and 2,
   the clock bit of gmode, p's pflags2 bit 0; sflags3 bit 4). The odds (regd2) are 10h less the first centre's
   faceoff stance (byte_CCA95 by fofdata2) plus the second's, plus the away centre's faceoff rating less the home
   centre's (byte_DAEA7 / byte_DACB3 by pnum; the centres are the skaters with position 4): randomd0(21h) below
   them gives the puck to the away centre (lasttouch, his input word_E0396), else to the home centre (word_E0392).
   The winner's input bit 0Bh picks the direction (fodir2 with y speed -800h, else fodir1 / +800h); a held
   direction (bit 3 clear) is used 3 times in 4, else a random one of the 5 around the y direction (mirrored by
   the sign of the y speed). The puck p gets that velocity (dirtab * 20h, plus the y speed), a random z velocity
   (below 800h), z 0, loses pflags bit 2 and takes assignment 18h (pucknorm); the referee (SortCords + 16) takes
   1Fh and word_E0028 is set to 500h toward his side. p: the puck. No result. */
void Endfaceoff(Player *p)
{
    short j;
    short i;
    short w;

    StopDigiSample();
    sfx(0xAB);
    gmode2 &= 0xFA;
    gmode &= 0xFE;
    p->pflags2 &= 0xFE;
    sflags3 |= 0x10;
    regd2.w = 0x10 - byte_CCA95[fofdata2[0]] + byte_CCA95[word_E0394];
    for (i = 0; i < 6; i++) {
        if (SortCords[i].position == 4) break;
    }
    for (j = 6; j < 12; j++) {
        if (SortCords[j].position == 4) break;
    }
    regd2.w += byte_DAEA7[SortCords[j].pnum * 20] - byte_DACB3[SortCords[i].pnum * 20];
    if (randomd0(0x21) < regd2.w) {
        w = word_E0396;
        lasttouch = j;
    } else {
        w = word_E0392;
        lasttouch = i;
    }
    if (w & 0x800) {
        regd3.w = fodir2;
        regd4.w = -0x800;
    } else {
        regd3.w = fodir1;
        regd4.w = 0x800;
    }
    regd0.w = regd3.w;
    if (!(regd0.w & 8)) {
        regd0.w &= 7;
        if (!randomd0(4)) {
            regd0.w = (randomd0(5) - 2) & 7;
            if (regd4.w < 0) *(unsigned char *)&regd0 ^= 4;
        }
    } else {
        regd0.w = (randomd0(5) - 2) & 7;
        if (regd4.w < 0) *(unsigned char *)&regd0 ^= 4;
    }
    regd0.w += regd0.w;
    p->Xvel = dirtab[regd0.w] << 5;
    p->Yvel = (dirtab_y[regd0.w] << 5) + regd4.w;
    p->Zvel = randomd0(0x800);
    *(short *)puckz = 0;
    p->pflags &= 0xFB;
    assreplace(p, 0x18);
    assreplace(&SortCords[16], 0x1F);
    word_E0028 = HIWORD(SortCords[16].Xpos) > 0 ? 0x500 : -0x500;
}

/* assreffollow (4E0BD; 93G hockey93 assreffollow?, PC version; ends in ass_popx / asswingd_skateto): the
   referee follows the play. Not while locked (pflags bit 5); with the clock at 0 he slows down (doplayeracc 8). A
   new assignment (bit 1) sets SPA A5Bh. With the puck in the middle (x below 32h) between the top of the circles
   and the goal line (y ACh-E8h) he stands at the goal line (x 46h toward his side, y EDh toward the puck's end);
   deeper than 62h with the puck loose or attacking that end (the carrier's pflags bit 7 against the puck's side)
   at x 78h, y E8h; else at x 90h, following the camera (camy) when more than 32h away from it. He skates there
   with EvadePlayers. p: the referee. No result. */
void assreffollow(Player *p)
{
    Player *c;
    int d;

    c = &SortCords[*puckc];
    if (p->pflags & 0x20) return;
    if (!gameclock && !clockticks[0]) {
        doplayeracc(p, 8);
        return;
    }
    if (p->pflags & 2) {
        p->pflags &= 0xFD;
        SetSPA(p, 0xA5B);
    }
    if ((*puckx < 0 ? -*puckx : *puckx) < 0x32 && (*pucky < 0 ? -*pucky : *pucky) > 0xAC
        && (*pucky < 0 ? -*pucky : *pucky) < 0xE8) {
        p->temp3 = HIWORD(p->Xpos) > 0 ? 0x46 : -0x46;
        p->temp4 = *pucky > 0 ? 0xED : -0xED;
    } else if ((*pucky < 0 ? -*pucky : *pucky) > 0x62 && (*puckc < 0 || ((c->pflags & 0x80) != 0) != (*pucky < 0))) {
        p->temp3 = HIWORD(p->Xpos) > 0 ? 0x78 : -0x78;
        p->temp4 = *pucky > 0 ? 0xE8 : -0xE8;
    } else {
        p->temp3 = HIWORD(p->Xpos) > 0 ? 0x90 : -0x90;
        d = HIWORD(p->Ypos);
        d -= camy;
        if (d < 0) d = -d;
        if (d > 0x32) p->temp4 = camy;
    }
    regd0.w = p->temp3;
    regd1.w = p->temp4;
    skateto(p, EvadePlayers);
}

/* assrefwhistle (4E8EF; 93G hockey93 assrefwhistle?, PC version): referee p blows the whistle. Not while he is
   locked (pflags bit 5). A new assignment (pflags bit 1): when the play is over (word_CBEC6, the clock at 0, or a
   tied shootout-period game gsp 3 decided), end the stoppage (RefStep -1, overlay timer 100h -> 258h) and hand the
   puck and p their next assignments (1Bh, 1Eh); else start the whistle (RefStep 1, PenShotAssign, spot A0h, 0 in
   temp3 / temp4, SPA A5Bh) unless the crowd reacts (CrowdOnStoppage). Then skate to the spot (SkateToSpot) until
   within 6 / -10 of it, turn toward facing 2 every 8 ticks (temp1) and, facing it, lock with SPA C1Bh and take
   assignment 22h. p: the referee. No result. */
void assrefwhistle(Player *p)
{
    short d;

    if (p->pflags & 0x20) return;
    if (p->pflags & 2) {
        if (word_CBEC6 || (!gameclock && !clockticks[0]) || (gsp == 3 && hmscore[0] != awscore)) {
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
        p->temp4 = 0;
        p->temp3 = 0xA0;
        p->temp1 = 0;
        p->pflags2 |= 0x20;
        p->Wallcos = 0;
        p->Wallsin = 0;
        SetSPA(p, 0xA5B);
        if (CrowdOnStoppage()) return;
        if (ovltimer == 0x100) ovltimer = 0x258;
    }
    regd0.w = HIWORD(p->Ypos) - p->temp4;
    if ((regd0.w < 0 ? -regd0.w : regd0.w) > 6) goto skate;
    regd0.w = HIWORD(p->Xpos) - p->temp3;
    if (regd0.w < -10) goto skate;
    if (--p->temp1 >= 0) return;
    p->temp1 += 8;
    SetSPA(p, 0xA5B);
    regd2.l = 2;
    if (regd2.w != p->facedir) {
        regd2.w = (regd2.w - p->facedir) & 7;
        p->facedir = (regd2.w < 5 ? 1 : -1) + (*(int *)((char *)&p->facedir - 2) >> 16) & 7;
    }
    p->Yvel = 0;
    p->Xvel = 0;
    if (regd2.w != p->facedir) return;
    p->pflags |= 0x20;
    SetSPA(p, 0xC1B);
    assreplace(p, 0x22);
    return;
skate:
    regd0.w = p->temp3;
    regd1.w = p->temp4;
    SkateToSpot(p, 0);
}

/* assrefdrop (4F5BF; 93G hockey93 assrefdrop?, PC version; ends in ass_popx / ass_skate_temp34): the referee
   drops the puck. On a penalty shot (penshotmode) hand over to assignment 2Ch. Not while locked (pflags bit 5). A
   new assignment (bit 1) picks the spot 15 beside the faceoff dot (fox, foy) into temp3 / temp4, gives him the
   puck (puckc 10h, puck still, z -100) and SPA A5Bh. Away from the spot (8 or more) or still moving (10h) he
   skates there (SkateToSpot); on it he turns every 8 ticks (temp1) toward the dot (facing 2 / 6 by the side of
   fox) and, facing it, stops; when no play-by-play is talking (PaSpeechBusy) and no overlay runs (ovlseq -1) the
   drop ends the stoppage (RefStep -1, assignment 1Eh). p: the referee. No result. */
void assrefdrop(Player *p)
{
    int dx;
    int dy;

    if (penshotmode) {
        assreplace(p, 0x2C);
        return;
    }
    if (p->pflags & 0x20) return;
    if (p->pflags & 2) {
        p->pflags &= 0xFD;
        p->temp2 = 8;
        p->temp1 = 0;
        p->temp3 = fox <= 0 ? fox - 15 : fox + 15;
        p->temp4 = foy;
        p->pflags2 |= 0x20;
        p->Wallcos = 0;
        p->Wallsin = 0;
        *puckc = 0x10;
        *puckvx = 0;
        *puckvy = 0;
        *(short *)puckvz = 0;
        *(short *)puckz = -100;
        SetSPA(p, 0xA5B);
    }
    dx = HIWORD(p->Xpos) - p->temp3;
    dy = HIWORD(p->Ypos) - p->temp4;
    if (dx * dx + dy * dy >= 0x40) goto skate;
    if ((p->Xvel < 0 ? -p->Xvel : p->Xvel) >= 0x10) goto skate;
    if ((p->Yvel < 0 ? -p->Yvel : p->Yvel) >= 0x10) goto skate;
    HIWORD(p->Xpos) = p->temp3;
    HIWORD(p->Ypos) = p->temp4;
    if (--p->temp1 >= 0) return;
    p->temp1 += 8;
    SetSPA(p, 0xA5B);
    regd2.l = fox <= 0 ? 2 : 6;
    if (regd2.w != p->facedir) {
        regd2.w = (regd2.w - p->facedir) & 7;
        p->facedir = (regd2.w < 5 ? 1 : -1) + (*(int *)((char *)&p->facedir - 2) >> 16) & 7;
        return;
    }
    p->Yvel = 0;
    p->Xvel = p->Yvel;
    if (PaSpeechBusy()) return;
    if (ovlseq != -1) return;
    RefStep[0] = -1;
    assreplace(p, 0x1E);
    return;
skate:
    regd0.w = p->temp3;
    regd1.w = p->temp4;
    SkateToSpot(p, 0);
}

/* assrefgoalline (4F7D0; 93G hockey93 assrefgoalline?, PC version; ends in ass_popx / ass_replace_popx /
   ass_skate_temp34): the referee goes to the goal line. Not while locked (pflags bit 5). A new assignment
   (bit 1) picks the spot on the goal line of the puck's end (y E6h / -E6h) on his side (x 32h / -32h) into
   temp3 / temp4. More than 0Ch away (y, or x toward the middle) or farther out than the line, he skates there
   (SkateToSpot); on it he turns every 8 ticks (temp1) toward the centre dot (vtoa) and, facing it, stops, locks
   (SPA C1Bh) and takes assignment 20h. p: the referee. No result. */
void assrefgoalline(Player *p)
{
    if (p->pflags & 0x20) return;
    if (p->pflags & 2) {
        p->pflags &= 0xFD;
        p->temp2 = 8;
        p->temp1 = 0;
        p->temp4 = *pucky > 0 ? 0xE6 : -0xE6;
        p->temp3 = HIWORD(p->Xpos) > 0 ? 0x32 : -0x32;
        p->pflags2 |= 0x20;
        p->Wallcos = 0;
        p->Wallsin = 0;
    }
    regd0.w = HIWORD(p->Ypos) - p->temp4;
    if ((regd0.w < 0 ? -regd0.w : regd0.w) > 0xC) goto skate;
    if ((HIWORD(p->Ypos) < 0 ? -HIWORD(p->Ypos) : HIWORD(p->Ypos)) > (p->temp4 < 0 ? -p->temp4 : p->temp4)) goto skate;
    regd0.w = HIWORD(p->Xpos) - p->temp3;
    if ((regd0.w < 0 ? -regd0.w : regd0.w) > 0xC) goto skate;
    if (--p->temp1 >= 0) return;
    p->temp1 += 8;
    SetSPA(p, 0xA5B);
    regd2.l = (short)vtoa((short)-HIWORD(p->Xpos), (short)(p->temp4 - HIWORD(p->Ypos)));
    if (regd2.w != p->facedir) {
        regd2.w = (regd2.w - p->facedir) & 7;
        p->facedir = (regd2.w < 5 ? 1 : -1) + (*(int *)((char *)&p->facedir - 2) >> 16) & 7;
        return;
    }
    p->Yvel = 0;
    p->Xvel = p->Yvel;
    p->pflags |= 0x20;
    SetSPA(p, 0xC1B);
    assreplace(p, 0x20);
    return;
skate:
    regd0.w = p->temp3;
    regd1.w = p->temp4;
    SkateToSpot(p, 0);
}
