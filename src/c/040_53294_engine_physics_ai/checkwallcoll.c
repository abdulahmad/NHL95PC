/* Engine physics AI: wall collision. */
/* DRAFT (10.0 GA, 15 differing, 482 vs 481): short limits preserve the EXE's narrowed radius loads.
   The distance is kept in regd3.w, and selecting net 12 or 13 with a ternary keeps the 0Ch addition
   before the index shift, as in the EXE (three bytes closer than the additive-boolean index).
   Left: x's home and ylim swap stack slots ([esp] / [esp+8]). The net offset is built in edx instead
   of eax: an extra mov edx, eax precedes the mask, and the SortCords base is added as an immediate
   instead of mov edx, SortCords / add edx, eax. See docs/UNSURE.md. */
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

    xlim = 0xA0 - wcradiusx;
    ylim = 0x108 - wcradiusy;
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
