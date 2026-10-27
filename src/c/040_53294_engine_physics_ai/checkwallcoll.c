/* Engine physics AI: wall collision. */
/* DRAFT (10.0 GA, 10 differing, 480 vs 481): short limits preserve the EXE's narrowed radius loads; each limit
   is set and then reduced by its radius (`xlim = 0xA0; xlim -= wcradiusx;`, tools/wccre/targetsearch.py), which
   also builds the goal-mouth net offset in eax with the SortCords base loaded into edx, as the EXE. The distance
   is kept in regd3.w, and selecting net 12 or 13 with a ternary keeps the 0Ch addition before the index shift.
   Left: only x's home and ylim swap stack slots ([esp] / [esp+8], the byte of size). countsolve: xlim and ylim
   each at a use count of 8 (x 7) give all three EXE slots; no spelling found that adds those references without
   changing the code. See docs/UNSURE.md. */
#include "nhl95.h"

#define W(v) (*(int *)((char *)&(v) - 2) >> 16)

/* checkwallcoll: keep a player inside the rink. x and y are tested against the wall inset
 (160 and 264 minus the wall radii, then 64 minus those). A point past a corner is pushed
 back along the corner normal when it is at least 64 away (vecdist); a point in the goal
 mouth is handed to checkgoal for net 12 or 13. If the player has no wall vector yet, one
 is built from the nearest boards and wallcollb runs. */
void checkwallcoll(Player *p, short x, short y)
{
    short xlim;
    short ylim;
    short ry0;

    xlim = 0xA0;
    xlim -= wcradiusx;
    ylim = 0x108;
    ylim -= wcradiusy;
    regd4.w = 0x40 - xlim;
    ry0 = word_E03B8 = 0x40 - ylim;
    if (y <= word_E03B8 || y >= (word_E03B8 = -word_E03B8)) {
        if (x < regd4.w || x > (regd4.w = -regd4.w)) {
            regd1.w = x - regd4.w;
            regd0.w = y - word_E03B8;
            regd3.w = vecdist(W(regd0), W(regd1));
            regd1.w = -regd1.w;
            if (regd3.w >= 0x40) {
                regd0.w = (W(regd0) << 8) / regd3.w;
                regd1.w = (W(regd1) << 8) / regd3.w;
                wallcollb(p);
            }
        } else
            checkgoal(p, &SortCords[ry0 == word_E03B8 ? 0x0D : 0x0C], x, y);
    }
    regd0.w = p->Wallsin | p->Wallcos;
    if (regd0.w != 0) return;
    regd0.w = 0x100;
    regd1.w = 0;
    if (y < ylim) {
        ylim = -ylim;
        regd0.w = (short)0xFF00;
        if (y > ylim) {
            regd0.w = 0;
            regd1.w = (short)0xFF00;
            if (x < xlim) {
                xlim = -xlim;
                regd1.w = 0x100;
                if (x > xlim) return;
            }
        }
    }
    wallcollb(p);
}
