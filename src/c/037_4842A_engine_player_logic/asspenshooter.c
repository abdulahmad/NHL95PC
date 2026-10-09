/* Engine player logic: penalty shot shooter (93G asspenshooter). */
/* DRAFT: register allocation only - EXE loads the puckc pointer into edx for the first test (C: eax). */
#include "nhl95.h"

/* asspenshooter (4FAE8) - 93G asspenshooter: the penalty shot skater. Leave (assexit) without the puck or with
   pflags bit 3; not while flag 20h; in a stoppage stand (SPA 289h, nopuck 60) and StopIfFree. A new assignment (bit
   1): temp1 0, steering byte +29h 0 / +28h 8, path point 0, a random temp3 (0-3) and a path from his y (mirrored by
   end; StartShotPath). Past the path end (sopathend < 0): when not facing the path direction, shoot now and then
   (1 in 4 when turned 3 or more steps, else 1 in 32): pass direction 2-3 (+3 on the left side, pspathside), shot
   timer 20, aimed at the goal (vtoa to x 0, y +-E8h), SPA DD3h for a hit type (Findhittype) else E2Bh, animate,
   SPAcnt 2 and shoot (doshot). Else move to the next path point when past it, and skate to the path point. */
void asspenshooter(Player *p)
{
    int y;

    if (*puckc != p->SCnum) {
        assexit(p);
        return;
    }
    if (p->pflags & 8) {
        assexit(p);
        return;
    }
    if (p->pflags & 0x20) return;
    if (gmode & 1) {
        SetSPA(p, 0x289);
        p->nopuck = 0x3C;
        StopIfFree(p);
        return;
    }
    y = p->Ypos >> 16;
    if (!(p->pflags & 0x80)) y = -y;
    if (p->pflags & 2) {
        p->pflags &= 0xFD;
        p->temp1 = 0;
        ((signed char *)p)[0x29] = 0;
        ((signed char *)p)[0x28] = 8;
        sopathpoint = 0;
        p->temp3 = randomd0(4);
        StartShotPath(p, y);
    }
    if (sopathend < 0) {
        y = p->facedir - pspathdir;
        if (y != 0) {
            y = (y + 1) & 7;
            if ((y >= 3 && !randomd0(4)) || (y < 3 && !randomd0(0x20))) {
                y = randomd0(2) + 2;
                if (pspathside < 0) y += 3;
                passdir = y;
                word_C90A6 = 0x14;
                regd0.w = -HIWORD(p->Xpos);
                regd1.w = (!(p->pflags & 0x80) ? -0xE8 : 0xE8) - (p->Ypos >> 16);
                y = vtoa(regd0.w, regd1.w);
                SetSPA(p, Findhittype(p, y) ? 0xDD3 : 0xE2B);
                updateanim(p);
                p->SPAcnt = 2;
                doshot(p);
                return;
            }
        }
    } else if (y >= sopathend) {
        NextPathPoint();
        pspathdir = p->facedir;
    }
    regd0.w = sopathx;
    regd1.w = sopathy;
    if (!(p->pflags & 0x80)) regd1.w = -regd1.w;
    ((signed char *)p)[0x29] -= 2;
    skateto(p, 0);
}
