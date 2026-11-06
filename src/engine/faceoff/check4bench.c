/* Engine assign faceoff: line change. */
#include "nhl95.h"

/* check4bench: 0 when p should stay, 1 when a line change was applied.
 A joystick player (pflags bit 3) stays while the clock runs. pflags2 bit 4 stays.
 The penalty-shot player stays, and so does an assignment of 7 or 9 once a penalty
 shot has started. No pending change (newpos and newpnum both negative) stays.
 At the start of a period, assignment 27h on the same spot stays, and assignment
 29h stays while that team's line-change box is on.
 A different player, or the same player on 29h or 2Dh during a penalty shot, goes
 to the bench (assignment 0Bh) unless that is already the assignment or p has the
 puck: pflags2 bit 2 is set, pflags bit 2 is cleared, temp1 is cleared, and temp5
 is cleared while the clock is stopped.
 Otherwise the change is taken. pflags2 bit 2 and pflags bit 2 are cleared. A
 non-negative newpos is copied to position when (pnum < 19h) differs from
 (newpos == 0). Setplass runs. While the clock is stopped and the period is not
 just starting, temp5 is cleared and assignment 28h (a positive position with the
 line-change box on) or 27h is inserted. newpnum and newpos become -1. */
short check4bench(Player *p)
{
    if (((gmode & gmclock) == 0 && (p->pflags & pfjoy)) || (p->pflags2 & 0x10)) return 0;
    if (p->SCnum == penshotplayer) return 0;
    if (penshotstart) {
        if (p->asslist[p->assnum] == 7 || p->asslist[p->assnum] == 9) return 0;
    }
    if (p->newpos < 0 && p->newpnum < 0) return 0;
    if (gameclock == PerTimeTotal && clockticks[0] == 0) {
        if (p->newpos == p->position && p->newpnum == p->pnum
            && p->asslist[p->assnum] == 0x27) return 0;
        if (lcboxon[(p->pflags & pfteam) != 0] && p->asslist[p->assnum] == 0x29) return 0;
    }
    if (p->newpnum != p->pnum
        || (penshotstart && (p->asslist[p->assnum] == 0x29 || p->asslist[p->assnum] == 0x2D))) {
        if (p->asslist[p->assnum] == 0x0B) return 0;
        if ((short)*puckc == p->SCnum) return 0;
        p->pflags2 |= 4;
        p->pflags &= ~4;
        p->temp1 = 0;
        if (gmode & gmclock) p->temp5 = 0;
        assreplace(p, 0x0B);
    } else {
        int go;

        p->pflags2 &= ~4;
        p->pflags &= ~4;
        if (p->newpos >= 0) {
            if ((p->pnum < 0x19) ^ (p->newpos == 0))
                p->position = p->newpos;
        }
        Setplass(p);
        if (gmode & gmclock) {
            go = gameclock != PerTimeTotal || clockticks[0] != 0;
            if (go) {
                p->temp5 = 0;
                if (p->position > 0 && lcboxon[(p->pflags & pfteam) != 0])
                    assinsert(p, 0x28);
                else
                    assinsert(p, 0x27);
            }
        }
        p->newpnum = -1;
        p->newpos = -1;
    }
    return 1;
}
