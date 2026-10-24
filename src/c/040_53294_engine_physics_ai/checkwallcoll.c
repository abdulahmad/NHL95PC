/* Engine physics AI: wall collision. */
/* DRAFT (10.0 GA, 15 differing, 485 vs 481): the limits are short locals, so `0xA0 - wcradiusx` is the
   EXE's narrowed `mov dx, [wcradiusx] / sub eax, edx` (no inline asm); declared ylim, ry0, xlim for the EXE
   registers. No goto: the corner and goal-mouth tests are two conditions with the negation in the second
   compare (`y >= (word_E03B8 = -word_E03B8)`), the same code as the old goto chain. Left: x's home and ylim
   swap stack slots ([esp] / [esp+8]), and the goal-mouth net index: Watcom folds
   `&SortCords[0x0C + (ry0 == word_E03B8)]` into `shl edx, 7 / add edx, 600h / add edx, SortCords` where the
   EXE adds 0Ch before the shift and adds SortCords from a register. See docs/UNSURE.md. */
#include "nhl95.h"

#define W(v) (*(int *)((char *)&(v) - 2) >> 16)

/* checkwallcoll: keep a player inside the rink. x and y are tested against the wall inset
 (160 and 264 minus the wall radii, then 64 minus those). A point past a corner is pushed
 back along the corner normal when it is at least 64 away (vecdist); a point in the goal
 mouth is handed to checkgoal for net 12 or 13. If the player has no wall vector yet, one
 is built from the nearest boards and wallcollb runs. */
void checkwallcoll(Player *p, short x, short y)
{
    short ylim;
    short ry0;
    short xlim;
    int dist;

    xlim = 0xA0 - wcradiusx;
    ylim = 0x108 - wcradiusy;
    regd4.w = 0x40 - xlim;
    ry0 = word_E03B8 = 0x40 - ylim;
    if (y <= word_E03B8 || y >= (word_E03B8 = -word_E03B8)) {
        if (x < regd4.w || x > (regd4.w = -regd4.w)) {
            regd1.w = x - regd4.w;
            regd0.w = y - word_E03B8;
            dist = vecdist(W(regd0), W(regd1));
            regd3.w = dist;
            regd1.w = -regd1.w;
            if ((short)dist >= 0x40) {
                regd0.w = (W(regd0) << 8) / (short)dist;
                regd1.w = (W(regd1) << 8) / (short)dist;
                wallcollb(p);
            }
        } else
            checkgoal(p, &SortCords[0x0C + (ry0 == word_E03B8)], x, y);
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
