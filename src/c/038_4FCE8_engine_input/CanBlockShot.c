/* Engine input: the defender's hold / shot-block checks (one source block: OppInReach ends in CanBlockShot's
   exits). */
#include "nhl95.h"

/* CanBlockShot (4FFEE, PC only): may player p dive to block a shot? Not when his own team has the puck. The puck
   must be 4Eh-E8h from centre ice, within 50h of him (+4Eh), coming at his goal (puckcross of his side at least
   10), and the shooter (the carrier, or shotplayer of the other team when it is loose and moving at his goal)
   in a shooting SPA. p must be between the puck and his goal (y), facing the shooter, and nearer the goalie
   (SortCords 12 + side) than the puck is; outside line change mode (pflags bit 3) not straight sideways and
   80h+ deep and within 64h of the middle. Result: 0, or the dive direction + 1 (0Ah straight), the direction
   also in the word at +4Ah (holdplayer passes it to BlockShotDive).
   DRAFT (10.0 GA, 76 -> 60 differing): the same-team test written `(*puckc < 6) == (p->SCnum < 6)` gives the
   EXE's `cmp eax, edx` / `xor eax, edx` return; the |pucky| range test computed once; the last test inverted
   so the shared `return 0` sits at the bottom (every early exit jumps there, as in the EXE); `(int)puckcross[]`
   for the load / sar compare; the goalie index through k (add 0Ch before the shift); |pucky| in e and the
   goalie distance in the dead side (side in ebp, g on the stack, as in the EXE; 42 differing). Left: s in ax
   (EXE bx), the pflags byte loaded into bh, the closing registers (EXE d in ebx, b in ebp), and the SPA read
   (`q = &SortCords[k]; spa = q->SPA` gives the EXE's separate add of SortCords, but scores worse).
   Kept as the owner of the CanBlockShot_ret5 / _ret6 exits. */
int CanBlockShot(Player *p)
{
    int dx;
    int dist;
    int dir;
    int side;
    int y;
    int a;
    int b;
    int e;
    int spa;
    Player *g;
    short s;
    int k;

    if (*puckc >= 0 && (*puckc < 6) == (p->SCnum < 6)) return 0;
    s = *pucky;
    e = s < 0 ? -s : s;
    if (e > 0xE8 || e < 0x4E) return 0;
    if (p->puckdist > 0x50) return 0;
    side = (p->pflags & pfgoal) != 0;
    k = ((p->pflags & pfgoal) != 0) + 12;
    g = &SortCords[k];
    if ((int)puckcross[side ? 3 : 1] < 10) return 0;
    if (*puckc >= 0) k = *puckc;
    else {
        if (side && *puckvy > 0) return 0;
        if (!side && *puckvy < 0) return 0;
        s = shotplayer;
        if (s < 0) return 0;
        if (!((p->SCnum < 6) ^ (s < 6))) return 0;
        k = shotplayer;
    }
    spa = SortCords[k].SPA;
    if (spa != 0x3F9 && spa != 0x491 && spa != 0xDD3 && spa != 0xE2B && spa != 0x1265 && spa != 0x12DD
        && spa != 0x1355 && spa != 0x138D) return 0;
    dx = *puckx - HIWORD(g->Xpos);
    y = *pucky - HIWORD(g->Ypos);
    dist = vecdist(dx, y);
    dir = vtoa((short)dx, (short)y);
    y = HIWORD(p->Ypos);
    if (!(side && y < -0x4E && y > -0xE8 && y < *pucky)) {
        if (side || y <= 0x4E || y >= 0xE8 || y <= *pucky) return 0;
    }
    dx = HIWORD(p->Xpos) - HIWORD(g->Xpos);
    y -= HIWORD(g->Ypos);
    side = vecdist(dx, y);
    a = vtoa((short)dx, (short)y);
    if (!(p->pflags & pfjoy)) {
        if (a == 2 || a == 6) return 0;
        if ((HIWORD(p->Ypos) < 0 ? -HIWORD(p->Ypos) : HIWORD(p->Ypos)) < 0x80) return 0;
        if ((HIWORD(p->Xpos) < 0 ? -HIWORD(p->Xpos) : HIWORD(p->Xpos)) > 0x64) return 0;
    }
    e = ((signed char *)p)[0x52];
    b = (e - p->facedir + 2) & 7;
    a = (dir - a + 2) & 7;
    if (((e - dir + 1) & 7) > 2) return 0;
    if (!((p->pflags & pfjoy) && b <= 4 && a <= 4)) {
        if (p->pflags & pfjoy) return 0;
        if (b < 1 || a < 1 || b > 3 || a > 3) return 0;
    }
    if (side >= dist) return 0;
    side += p->puckdist;
    if (side < dist + dist) {
        if (b == 2 && a == b) return 10;
        ((short *)p)[0x25] = dir;
        return a + 1;
    }
    return 0;
}

/* OppInReach (5033D, PC only; ends in CanBlockShot_ret6): is one of the six opponents within reach of p for a
   hold: in the front half of p's facing (vtoa of the offset against facedir) and under 1Eh away in x and "y". The
   original computes both offsets from Xpos (the y offset is the x one again), which this keeps. p: the player.
   Result: 1 or 0. */
int OppInReach(Player *p)
{
    Player *q;
    int i;
    int dx;
    int dy;
    int t;

    q = &SortCords[p->SCnum < 6 ? 6 : 0];
    i = 0;
    do {
        dx = HIWORD(q->Xpos) - HIWORD(p->Xpos);
        dy = HIWORD(q->Xpos) - HIWORD(p->Xpos);
        t = vtoa((short)dx, (short)dy);
        if (((t - p->facedir + 2) & 7) <= 4) {
            if (ABS(dx) < 0x1E && ABS(dy) < 0x1E) return 1;
        }
        i++;
        q++;
    } while (i < 6);
    return 0;
}

/* lineinput (4FD8E; 93G logic93 lineinput "process input for line changes", PC version; ends in
   CanBlockShot_ret5): the player in line change mode. A pending line change request (tmflags bit 0) is cleared
   and raised (RequestLineChange). The PC box is one-button: a press (bit 6 of the new presses in regd2) takes the
   highlighted choice (lcsel into regd2, lcfound) and closes the box (lcblink, lcboxon 0); else the choice cycles
   every 60 frames (lctimer; two choices on the special lines above 3, else four; lcline steps through linenext)
   and blinks every 12 (lcblinktime, lcblink). Then a joystick player that is not animation-locked or fighting
   (and with dword_CCC9C clear) skates (doplayeracc with the direction in regd0). p: the player. No result. */
void lineinput(Player *p)
{
    Team *t;
    short side;

    t = p->tmptr;
    if (t->tmflags & 1) {
        t->tmflags &= ~1;
        RequestLineChange(p);
    }
    side = (p->pflags & pfteam) != 0;
    if (*(unsigned char *)&regd2 & 0x40) {
        regd2.w = lcsel[side];
        lcfound(p);
        lcboxon[side] = lcblink[side] = 0;
        return;
    }
    if (lctimer[side]-- == 0) {
        lctimer[side] += 0x3C;
        if (lcline[side] > 3) lcsel[side] = (lcsel[side] + 1) % 2;
        else lcsel[side] = (lcsel[side] + 1) % 4;
        lcline[side] = linenext[lcline[side]];
        lcblink[side] = 1;
        lcblinktime[side] = 0xC;
    }
    if (lcblinktime[side]-- == 0) {
        lcblinktime[side] += 0xC;
        lcblink[side] = lcblink[side] == 0;
    }
    if (!(p->pflags & pfjoy) || dword_CCC9C || (p->pflags & pfalock) || (p->pflags2 & 1)) return;
    doplayeracc(p, regd0.w);
}

/* asspassrec (50F3F; 93G logic93 asspassrec, "assignment for catching pass", asstab 13h; segment 039, ends in
   CanBlockShot_ret5): not while animation-locked; with the clock stopped leave the assignment (assexit,
   StopIfFree, onetimerflag 0). Count the high byte of temp1 down. A joystick player waits for the one-timer
   (PassRecOneTimer). On a new assignment (pfna): pflags bit 0 on, temp2 8, and when the puck is loose and p's team
   (regd0 = pfteam + 1) has no human controller, OneTimerChk may arm the one-timer (onetimerflag). An armed
   one-timer clears bits 4 and 6 of the new presses (regd1) and goes to PassRecOneTimer. Otherwise, while the puck
   is loose, skate to it (skatetopuck) when it is slow (both velocities under 168h), and keep waiting until the
   counter passes -5; then (or once someone has the puck) leave the assignment, and a pass to p's own number is
   completed (PassCompleted), else passplayer is cleared. p: the receiver. No result. */
void asspassrec(Player *p)
{

    if (p->pflags & pfalock) return;
    if (gmode & 1) {
        onetimerflag = 0;
        assexit(p);
        StopIfFree(p);
        return;
    }
    ((signed char *)&p->temp1)[1]--;
    if (p->pflags & pfjoy) {
one:
        PassRecOneTimer(p);
        return;
    }
    if (p->pflags & pfna) {
        p->pflags &= 0xFC;
        p->pflags |= 1;
        p->temp2 = 8;
        regd0.w = ((p->pflags & pfteam) != 0) + 1;
        if (*puckc < 0 && cont1team != regd0.w && regd0.w != cont2team && OneTimerChk(p)) onetimerflag = 1;
    }
    if (onetimerflag) {
        *(unsigned char *)&regd1 &= 0xAF;
        goto one;
    }
    if (*puckc < 0) {
        if ((*puckvx < 0 ? -*puckvx : *puckvx) < 0x168 && (*puckvy < 0 ? -*puckvy : *puckvy) < 0x168) skatetopuck(p);
        if (((signed char *)&p->temp1)[1] >= -5) return;
    }
    p->pflags &= ~1;
    assexit(p);
    onetimerflag = 0;
    if (*puckc == p->SCnum) {
        PassCompleted(p);
        return;
    }
    if (*puckc >= 0) passplayer = -1;
}

/* PassRecOneTimer (50B55, PC only; segment 039, ends in CanBlockShot_ret5): the one-timer of a pass receiver
   (asspassrec). Once someone has the puck or the wait (the high byte of temp1) is past -19h: a pass to p is
   completed (PassCompleted), passplayer cleared, the assignment left (pflags bit 0 off, assexit, onetimerflag 0).
   Else, armed (onetimerflag): in the one-timer wind-up (SPA DD3h / E2Bh) a press of button 4 or 6 (regd1) early in
   it locks the swing (SPA 1355h / 138Dh, sflags bit 3 off, onetimerflag 0); the stick blade (byte_CCBBA by facing,
   mirrored by the x-flip attribute bit 3) is measured against the puck: close enough the swing steps on
   (SPAcnt 0, updateanim), and within 64h (90h while the wait is under -10) the shot goes (passdir at most 8,
   passspeed shotspd / 2 + 1Eh, frame 4, team one-timers +1 at +18h, crowd +64h, a2touchpuck, doshot,
   PassCompleted, assexit). Not winding up yet, with the wait between -10 and 16h and p in the attacking zone
   (y 46h toward the net, or joystick controlled): count a try at team +16h and start the wind-up toward the net
   from where the puck will be (Findhittype: E2Bh, else DD3h). p: the receiver. No result. */
void PassRecOneTimer(Player *p)
{
    int t;
    int d;
    short c;

    if (*puckc >= 0 || (t = ((signed char *)&p->temp1)[1]) < -0x19) {
        if (*puckc == p->SCnum) PassCompleted(p);
        passplayer = -1;
        p->pflags &= 0xFE;
        assexit(p);
        onetimerflag = 0;
        return;
    }
    if (!onetimerflag) return;
    if (p->SPA == 0xDD3 || p->SPA == 0xE2B) {
        if (p->SPAnum <= 2 && (*(unsigned char *)&regd1 & 0x10 || *(unsigned char *)&regd1 & 0x40)) {
            sflags &= 0xF7;
            p->pflags |= 0x20;
            if (p->SPA == 0xDD3) p->SPA = 0x1355;
            else p->SPA = 0x138D;
            onetimerflag = 0;
        }
        p->nopuck = 5;
        regd0.w = p->facedir & 7;
        if (p->attribute & 8) regd0.w = (8 - regd0.w) & 7;
        regd1.w = byte_CCBBB[regd0.w * 2];
        regd0.w = byte_CCBBA[regd0.w * 2];
        if (p->attribute & 8) regd0.w = -regd0.w;
        d = (short)(HIWORD(p->Xpos) + regd0.w - *puckx);
        c = (short)(regd1.w + HIWORD(p->Ypos) - *pucky);
        d = d * d + c * c;
        if (p->SPAnum == 0 && (((signed char *)&p->temp1)[1] < -4 || d < 0x190) || p->SPAnum == 2 && d < 0x100) {
            p->SPAcnt = 0;
            updateanim(p);
        }
        if (d > 0x64 && (d > 0x90 || ((signed char *)&p->temp1)[1] >= -10)) return;
        if (passdir > 8) passdir = 8;
        passspeed = p->shotspd / 2 + 0x1E;
        p->SPAnum = 4;
        p->SPAcnt = 4;
        ((signed char *)p)[0x46] = 0;
        updateanim(p);
        ((short *)p->tmptr)[0xC]++;
        crowdlevel += 0x64;
        a2touchpuck(p);
        doshot(p);
        PassCompleted(p);
        p->pflags &= 0xFE;
        assexit(p);
        onetimerflag = 0;
        return;
    }
    if (((signed char *)&p->temp1)[1] > 0x16 || t < -10) return;
    if (!(p->pflags & 8)) {
        if ((p->pflags & 0x80) && HIWORD(p->Ypos) < 0x46) return;
        if (!(p->pflags & 0x80) && HIWORD(p->Ypos) > -0x46) return;
    }
    ((short *)p->tmptr)[0xB]++;
    t = (short)((((signed char *)&p->temp1)[1] + 0xA) << 4);
    d = -(short)((*puckvx * t >> 16) + *puckx);
    t = (short)(t * *puckvy >> 16);
    c = ((p->pflags & 0x80) ? 0xE8 : -0xE8) - (t + *pucky);
    if (Findhittype(p, vtoa((short)d, c))) SetSPA(p, 0xE2B);
    else SetSPA(p, 0xDD3);
}
