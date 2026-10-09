/* Engine core: functions that share changeplayer's epilogue (changeplayer_ret5), in address order:
   changeplayer (59E69), setplayer (5B2C5, jumps to changeplayer_ret5 at 5B821) and DrawRinkOverlays
   (5D7xx, jumps at 5D7F2). Unmarked functions here are drafts; see tools/c_functions.csv. */
#include "nhl95.h"

/* changeplayer (59E69) - 93G logic93_1 changeplayer: human control moves to the teammate of p nearest the
   puck's next position (puck + velocity/256). Controller cont (0 = 1, else 2) scans its team's six
   players: on the ice (position > 0), not pflags2 bit 2, not animation locked (pfalock), and not the other
   controller's player; the nearest by squared distance wins (default p->SCnum). If that is the
   controller's own player already, Sweepcheck(p); else restorepl hands the joystick over. */
void changeplayer(Player *p, short cont)
{
    short pick;
    short py;
    short px;
    unsigned long best;
    Player *q;
    short n;
    long dx;
    long dy;
    short s;

    px = (*puckvx >> 8) + *puckx;
    py = (*puckvy >> 8) + *pucky;
    best = 0xFFFFFFFF;
    q = ((cont ? cont2team : cont1team) != 1) ? &SortCords[6] : SortCords;
    pick = p->SCnum;
    n = 6;
    do {
        if (q->position > 0 && !(q->pflags2 & 4) && !(q->pflags & pfalock)) {
            dx = px - HIWORD(q->Xpos);
            dy = py - HIWORD(q->Ypos);
            dx *= dx;
            dy *= dy;
            dx += dy;
            if ((unsigned long)dx <= best) {
                s = q->SCnum;
                if (s != (cont ? c1playernum[0] : c2playernum[0])) {
                    best = dx;
                    pick = s;
                }
            }
        }
        q++;
    } while (--n);
    if ((cont ? c2playernum[0] : c1playernum[0]) == pick) {
        Sweepcheck(p);
    } else if (!cont) {
        if (pick != c1playernum[0]) c1playernum[0] = restorepl(pick, c1playernum[0]);
    } else {
        if (pick != c2playernum[0]) c2playernum[0] = restorepl(pick, c2playernum[0]);
    }
}
