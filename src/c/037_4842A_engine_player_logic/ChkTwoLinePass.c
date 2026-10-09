/* Engine player logic: two-line pass. */
#include "nhl95.h"

/* ChkTwoLinePass (4DD51) - two-line pass by receiver p (option on, play live): p was not flagged by MarkTwoLinePlayers
   past the red line, or the puck is on p's attacking side; the pass came from a teammate (lasttouch) from behind
   the blue line (lty 4Eh, by end) to p across the red line. Returns 1 for a two-line pass. */
int ChkTwoLinePass(Player *p)
{
    short sc;
    short lt;

    if (gmode & 0x10) return 0;
    if (!gameopts.twolinepass) return 0;
    if (!(p->pflags2 & 0x80)) {
        if (!(p->pflags & pfgoal) ^ (*pucky > 0)) return 0;
    }
    sc = p->SCnum;
    lt = lasttouch;
    if (sc == lt) return 0;
    if ((sc < 6) != (lt < 6)) return 0;
    if (!(p->pflags & pfgoal)) {
        if (lty < 0x4E) return 0;
        if (HIWORD(p->Ypos) > 0) return 0;
    } else {
        if (lty > -0x4E) return 0;
        if (HIWORD(p->Ypos) < 0) return 0;
    }
    return 1;
}
