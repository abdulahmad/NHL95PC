/* Engine player logic: centre on defence. */
#include "nhl95.h"

/* asscenterd (4A53A) - centre in the defensive zone (93G assignment role): not while flag 20h or heading to the bench
   (check4bench); in a stoppage StopIfFree. Ignored with pflags bit 3. A new assignment (bit 1) resets temp1 and
   temp2 = 8. Every aioff frames (countdown in byte +27h, the high byte of temp1) re-check: when the puck is with
   p's own team switch to assignment 6. Else skate to half the puck's x and halfway between the puck's y and
   the blue line side (y -71h; mirrored by end), straight (no evade). */
void asscenterd(Player *p)
{
    short r;
    signed char f;

    if (p->pflags & 0x20) return;
    r = check4bench(p);
    if (r) return;
    if (gmode & 1) {
        StopIfFree(p);
        return;
    }
    f = p->pflags;
    if (f & 8) return;
    if (f & 2) {
        p->pflags = f & 0xFD;
        p->temp1 = r;
        p->temp2 = 8;
    }
    if (--((signed char *)p)[0x27] < 0) {
        ((signed char *)p)[0x27] = p->aioff;
        if (*puckc >= 0 && (p->SCnum < 6) == (*puckc < 6)) {
            assreplace(p, 6);
            return;
        }
    }
    regd0.w = *puckx >> 1;
    regd2.w = *pucky;
    if (!(p->pflags & pfgoal)) regd2.w = -regd2.w;
    regd1.w = -0x71;
    if (regd2.w >= -0x4E) regd1.w = (*pucky - 0x71) >> 1;
    if (!(p->pflags & pfgoal)) regd1.w = -regd1.w;
    skateto(p, 0);
}
