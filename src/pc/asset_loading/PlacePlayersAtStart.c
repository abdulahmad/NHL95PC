/* Asset loading: opening spots. */
/* DRAFT: 540 vs 534 (12 differing). The assignment number is a ternary passed straight to
 assinsert (sete al / and eax, 0FFh / add eax, 16h / movsx edx, ax, as in PenShotAssign; the
 (regd1.w == 4) + 16h sum was widened with xor ah, ah). The map negate is an if / else with the
 store in each arm (the arms join at the store, so the word is reloaded as in the original). The
 far-spot mirror negates regd1 in ecx (original neg word [regd1]: the table value still in ax is
 reused), so the loop count is in si, esi is saved and the cookie is 14h. Tried for the mirror:
 0 - x, x *= -1, the two loads swapped, !(...) test, the position stores in both arms, ternaries,
 a comma expression, != pfgoal / ~pflags tests, an empty then-arm; tie orders (tieorder) and
 targetsearch: none. Negating regd1 before regd0 puts regd1 in memory (against the EXE order). */
#include "nhl95.h"

/* PlacePlayersAtStart: with dword_CC0EC clear, forceteams and drop the puck and the
 faceoff spot to 0. Each of the 12 players gets temp5 -100 and assignment 16h, or
 17h when position is 4. A negative position is left there. Otherwise the spot
 comes from apl, indexed by the team map plus 6, shifted up 3, plus the position.
 That byte, doubled, picks the x and y in the faceoff table. pflags bit 7 mirrors
 both. The player faces the puck. A goalie (position 0) takes frame dir*3+196h and
 SPA 1; anyone else takes frame dir*5 and SPA 289h. A left-handed player uses
 facedir, a right-handed player uses (8 - facedir) & 7. pflags2 bit 2 and pflags
 bit 5 are cleared, SPAnum is 0 and SPAcnt is -1. */
void PlacePlayersAtStart(void)
{
    Player *p;

    if (dword_CC0EC) return;
    forceteams();
    fox = foy = 0;
    *puckx = *pucky = 0;
    p = SortCords;
    regd2.w = 12;
    do {
        p->temp5 = -100;
        regd1.w = p->position;
        assinsert(p, regd1.w == 4 ? 0x17 : 0x16);
        if (regd1.w >= 0) {
            if (p->pflags & pfteam) regd4.w = -awtmap;
            else regd4.w = -hmtmap[0];
            regd4.w = (regd4.w + 6) << 3;
            regd4.w = apl[regd4.w + regd1.w];
            regd4.w <<= 1;
            regd0.w = word_CBE8C[regd4.w];
            regd1.w = word_CBE8E[regd4.w];
            if ((p->pflags & pfgoal) == 0) {
                regd0.w = -regd0.w;
                regd1.w = -regd1.w;
            }
            HIWORD(p->Xpos) = regd0.w;
            HIWORD(p->Ypos) = regd1.w;
            p->Yvel = 0;
            p->Xvel = p->Yvel;
            p->facedir = vtoa((short)(*puckx - regd0.w), (short)(*pucky - regd1.w));
            if (p->position == 0) {
                int dir;
                int copy;

                if (p->handed) dir = p->facedir;
                else dir = (8 - p->facedir) & 7;
                copy = dir;
                dir <<= 2;
                dir -= copy;
                p->frame = dir + 0x196;
                regd1.w = 1;
            } else {
                int dir;
                int copy;

                if (p->handed) dir = p->facedir;
                else dir = (8 - p->facedir) & 7;
                copy = dir;
                dir <<= 2;
                dir += copy;
                p->frame = dir;
                regd1.w = 0x289;
            }
            p->pflags2 &= ~4;
            p->pflags &= ~pfalock;
            p->SPAnum = 0;
            p->SPA = regd1.w;
            p->SPAcnt = -1;
        }
        p++;
    } while (--regd2.w);
}
