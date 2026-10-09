/* Engine physics / AI: checking. */
#include "nhl95.h"

/* FacingBoards (5378D) - 1 when p is near the boards and facing them (so a check pins him): left side (x < -78h) facing 6,
   or 7 / 5 in the top / bottom corners (|y| > E8h); right side (x > 78h) facing 2, or 1 / 3 in the corners;
   otherwise the end boards (|y| > F2h) facing 0 / 4. */
int FacingBoards(Player *p)
{
    short x;
    short y;
    short f;

    x = HIWORD(p->Xpos);
    y = HIWORD(p->Ypos);
    f = p->facedir;
    if (x < -0x78) {
        if (f == 6 || y > 0xE8 && f == 7 || y < -0xE8 && f == 5) return 1;
    } else if (x > 0x78) {
        if (f == 2 || y > 0xE8 && f == 1 || y < -0xE8 && f == 3) return 1;
    } else {
        if (y > 0xF2 && f == 0 || y < -0xF2 && f == 4) return 1;
    }
    return 0;
}
