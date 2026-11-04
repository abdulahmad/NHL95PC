/* cflags: -od */
/* Standings playoffs: highlighting a playoff tree slot. */
#define sub_91044 sub_91044_decl
#include "nhl95.h"
#undef sub_91044

typedef struct { short a; short b; } Pair;

void __cdecl sub_91044(int x, int y, int w, int h, int c);

/* HighlightTreeSlot (2785F, PC only): toggle (sub_91044, colour 80h) the highlight bar of playoff tree slot *slot.
   The slot is found in the tree's columns: the eight first-round slots of either side (treecolslots /
   treecol_Er1, bars 64h x 0Dh at the column's x from treecolx), the four second-round slots (treecol_Wr2 /
   treecol_Er2, from treerowy, the east side mirrored from 27Fh), the two conference finals (treecol_Wr3 /
   treecol_Er3, at 47h and 1C5h) and the final (treecolslots +18h / +28h, 5Ch wide at 10Ah); odd entries are the lower
   bar of a pair. slot: the tree slot number. */
void HighlightTreeSlot(int *slot)
{
    short unused;  /* never used; the original has its stack slot */
    short i;
    short x;
    short y;
    short w;
    short h;

    for (i = 0; i < 8; i++) {
        if (treecolslots[i] == *slot) {
            x = ((Pair *)treecolx)[i >> 1].a - 1;
            if (!(i & 1)) y = 0x4A;
            else y = 0x5A;
            w = 0x64;
            h = 0xD;
            sub_91044(x, y, w, h, 0x80);
            return;
        } else if (treecol_Er1[i] == *slot) {
            x = ((Pair *)treecolx)[i >> 1].a - 1;
            if (!(i & 1)) y = 0x180;
            else y = 0x190;
            w = 0x64;
            h = 0xD;
            sub_91044(x, y, w, h, 0x80);
            return;
        }
    }
    for (i = 0; i < 4; i++) {
        if (treecol_Wr2[i] == *slot) {
            x = treerowy[i >> 1] - 1;
            if (!(i & 1)) y = 0x99;
            else y = 0xA9;
            w = 0x64;
            h = 0xD;
            sub_91044(x, y, w, h, 0x80);
            return;
        } else if (treecol_Er2[i] == *slot) {
            x = 0x27F - (treerowy[1 - (i >> 1)] + 0x64);
            if (!(i & 1)) y = 0x133;
            else y = 0x143;
            w = 0x64;
            h = 0xD;
            sub_91044(x, y, w, h, 0x80);
            return;
        }
    }
    for (i = 0; i < 2; i++) {
        if (treecol_Wr3[i] == *slot) {
            if (i == 0) y = 0xE6;
            else y = 0xF6;
            sub_91044(0x47, y, 0x64, 0xD, 0x80);
            return;
        } else if (treecol_Er3[i] == *slot) {
            if (i == 0) y = 0xE6;
            else y = 0xF6;
            sub_91044(0x1C5, y, 0x64, 0xD, 0x80);
            return;
        }
    }
    if (treecolslots[0x18] == *slot) sub_91044(0x10A, 0xE2, 0x5C, 0xD, 0x80);
    else if (treecolslots[0x28] == *slot) sub_91044(0x10A, 0xF2, 0x5C, 0xD, 0x80);
}
