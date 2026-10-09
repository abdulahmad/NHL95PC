/* Engine skating: goal avoidance box test. */
#include "nhl95.h"

/* avdgoal_box (5F04E) - PC-new helper of avdgoal: does the line from player p to the target (regd0 x / regd1 y,
   low words) cross this goal's box (x from x1 to x2, y within +-y)? *ps / *pt get the side bits of the player
   and the target (4 below x1, 1 from x2 on, 2 / 8 past y / -y). Returns 1 when it crosses, else 0 (both on one
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
    y = -y;
    if (y <= px) {
        if (y > tx) *(unsigned char *)pt |= 8;
    } else {
        *(unsigned char *)ps |= 8;
        if (y > tx) return 0;
    }
    return 1;
}
