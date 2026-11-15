/* cflags: -od */
/* Player stats: the team under the mouse (segment compiled without optimisation). */
#define TeamFromMouse TeamFromMouse_decl
#include "nhl95.h"
#undef TeamFromMouse

/* TeamFromMouse (26B5A, PC only): the team slot under the mouse at x / y (x is moved 4 to the right). Outside the
   playoffs: the two standings columns (left: rows of 13 from y A5h, 6 teams, then from 14Ah; right: from A5h as
   0Ch-, from 14Ah as 13h-). In the playoffs: the playoff tree's bars (the west first round at y 4Bh-68h from
   treecolx, the second round at 9Ah-B8h from treerowy, the conference finals and the final at E6h-103h, the
   east second round mirrored at 134h-151h, the east first round at 181h-19Eh); the upper or lower team of the
   pair by y. *idx: the slot (0 when none). Result: 1 on a team, else 0. */
int TeamFromMouse(int x, int y, int *idx)
{
    short u1;  /* five unused shorts: the original's frame has their slots around i (ebp-0Ch) */
    short u2;
    short i;
    short u3;
    short u4;
    short u5;

    x += 4;
    if (statsplayoffs == 0) {
        *idx = 0;
        if (y < 0xA5) return 0;
        if (x < 0x140) {
            if (y < 0xF3) {
                *idx = (y - 0xA5) / 13;
                return 1;
            } else if (y < 0x14A) {
                return 0;
            } else if (y < 0x198) {
                *idx = (y - 0x14A) / 13 + 6;
                return 1;
            }
        } else {
            if (y < 0x100) {
                *idx = (y - 0xA5) / 13 + 0xC;
                return 1;
            } else if (y < 0x14A) {
                return 0;
            } else if (y < 0x1A5) {
                *idx = (y - 0x14A) / 13 + 0x13;
                return 1;
            }
        }
        return 0;
    }
    *idx = 0;
    if (y > 0x4A && y < 0x69) {
        for (i = 0; i < 4; i++) {
            if (x >= ((int *)treecolx)[i] && ((int *)treecolx)[i] + 0x64 >= x) {
                if (y < 0x5A) *idx = treecolslots[i * 2];
                else *idx = treecolslots[i * 2 + 1];
                return 1;
            }
        }
        return 0;
    }
    if (y > 0x99 && y < 0xB9) {
        for (i = 0; i < 2; i++) {
            if (x >= treerowy[i] && treerowy[i] + 0x64 >= x) {
                if (y < 0xA9) *idx = treecol_Wr2[i * 2];
                else *idx = treecol_Wr2[i * 2 + 1];
                return 1;
            }
        }
        return 0;
    }
    if (y > 0xE5 && y < 0x104) {
        if (x >= 0x48 && x <= 0xAC) {
            if (y < 0xF5) *idx = treecolslots[0x10];
            else *idx = treecolslots[0x11];
            return 1;
        }
        if (x >= 0x10C && x <= 0x170) {
            if (y < 0xF2) *idx = treecolslots[0x18];
            else *idx = treecolslots[0x28];
            return 1;
        }
        if (x >= 0x1CD && x <= 0x231) {
            if (y < 0xF5) *idx = treecolslots[0x30];
            else *idx = treecolslots[0x31];
            return 1;
        }
        return 0;
    }
    if (y > 0x133 && y < 0x152) {
        for (i = 0; i < 2; i++) {
            if (0x280 - (treerowy[1 - i] + 0x64) <= x && 0x280 - treerowy[1 - i] >= x) {
                if (y < 0x143) *idx = treecol_Er2[i * 2];
                else *idx = treecol_Er2[i * 2 + 1];
                return 1;
            }
        }
        return 0;
    }
    if (y > 0x180 && y < 0x19F) {
        for (i = 0; i < 4; i++) {
            if (x >= ((int *)treecolx)[i] && ((int *)treecolx)[i] + 0x64 >= x) {
                if (y < 0x190) *idx = treecol_Er1[i * 2];
                else *idx = treecol_Er1[i * 2 + 1];
                return 1;
            }
        }
        return 0;
    }
    return 0;
}
