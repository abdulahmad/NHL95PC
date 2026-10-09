/* Engine player logic: turning. */
#include "nhl95.h"

/* AdjustFacingDirection (4B4E9) - turn p one step (of 8) toward direction want, at most every other frame (word +4Ch
   counts the delay down). The shorter way round, except that a turn between the 1-3 and 5-7 halves goes through
   the side facing the attacked end (pflags bit 7). want is reused for the step (-1/+1), as in the asm. */
#define TURNDELAY(p) (((short *)(p))[0x4C / 2])

void AdjustFacingDirection(Player *p, int want)
{
    short f;
    short w;

    f = p->facedir;
    w = want;
    if (!TURNDELAY(p) && (want = f - want) != 0) {
        want = ((want & 4) >> 1) - 1;
        if (p->pflags & pfgoal) {
            if (f >= 1 && f <= 3 && w >= 5 && w <= 7) want = -1;
            else if (f >= 5 && f <= 7 && w >= 1 && w <= 3) want = 1;
        } else {
            if (f >= 1 && f <= 3 && w >= 5 && w <= 7) want = 1;
            else if (f >= 5 && f <= 7 && w >= 1 && w <= 3) want = -1;
        }
        p->facedir = (p->facedir + want) & 7;
        TURNDELAY(p) = 2;
        return;
    }
    if (--TURNDELAY(p) < 0) TURNDELAY(p) = 0;
}
