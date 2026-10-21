/* File utils: panel line indicator. */
#include "nhl95.h"

#define PUTSPRITE ((void (__cdecl *)(int spr, int x, int y))sub_B4CD8)

/* DrawPanelLine: draw the line indicator of team side (away when set) for line on the screen bitmap:
 crossing between the forward lines (< 4), the extra lines (< 6) and the rest resets that side's line timer
 (dword_C5860 away, dword_C585C home); store the line (hudawayline hudhomeline) and draw its sprite
 (linesprites) at FBh 2Ah, 14h. */
void DrawPanelLine(int side, int line)
{
    SelectScreenBM();
    if ((short)side) {
        if (((hudawayline < 4) ^ ((short)line < 4)) || ((hudawayline < 6) ^ ((short)line < 6))) dword_C5860 = 0;
        hudawayline = (short)line;
        PUTSPRITE(linesprites[hudawayline], 0xFB, 0x14);
    } else {
        if (((hudhomeline < 4) ^ ((short)line < 4)) || ((hudhomeline < 6) ^ ((short)line < 6))) dword_C585C = 0;
        hudhomeline = (short)line;
        PUTSPRITE(linesprites[hudhomeline], 0x2A, 0x14);
    }
    SelectRinkBM();
}

/* One entry of a penalty panel list (hudpenhome / hudpenaway, 8 entries): player (-1 free), minutes, seconds,
   hundredths. */
typedef struct PenSlot { short pl, min, sec, hund; } PenSlot;

/* TickPanelPenalties (15655, PC only; segment 006, the same source file: it ends in DrawPanelLine_x): run the
   first two penalties of a panel list down by hund hundredths (borrowing from the seconds and the minutes); an
   expired one is cleared and freed (player -1). Then pack the list: every used entry after a free one moves up.
   pens: the list (hudpenhome or hudpenaway); hund: hundredths elapsed (UpdateHudPanel passes dword_C583C).
   No result. */
void TickPanelPenalties(PenSlot *pens, int hund)
{
    int i;
    int j;
    int k;
    PenSlot *p;

    for (i = 0; i < 2; i++) {
        p = &pens[i];
        if ((p->hund -= hund) < 0) {
            p->hund += 100;
            if (--p->sec < 0) {
                p->sec = 59;
                if (--p->min < 0) {
                    p->min = 0;
                    p->sec = 0;
                    p->hund = 0;
                    p->pl = -1;
                }
            }
        }
    }
    for (i = 0; i < 7; i++) {
        if (pens[i].pl < 0) {
            k = i;
            for (j = i + 1; j < 8; j++) {
                p = &pens[j];
                if (p->pl >= 0) {
                    pens[k] = *p;
                    p->pl = -1;
                    k++;
                }
            }
        }
    }
}

/* DrawEnergyBar (15707, PC only; segment 006, ends in DrawPanelLine_x): draw a side's energy bar at x, two columns
   of 3-pixel rows 1Ah down: level pixels in colour 67h (or 0 while that side's energywarn is set, side = x > A0h),
   the remaining 8 - level in 0 (or 7 when warned). level: energy / 500 (0..8); x: the bar's left edge. No result.
   The declaration order w2, c2, x2, c1 gives the EXE's stack slots (found by tools/permute.py). */
void DrawEnergyBar(int level, int x)
{
    int w2;
    int c2;
    int x2;
    int c1;

    if (energywarn[x > 0xA0]) {
        c1 = 0;
        c2 = 7;
    } else {
        c1 = 0x67;
        c2 = 0;
    }
    sub_90D20(x + 9 - level, 0x1A, level, 3, c1);
    sub_90D20(x2 = x + 0x10, 0x1A, level, 3, c1);
    sub_90D20(++x, 0x1A, w2 = 8 - level, 3, c2);
    sub_90D20(level += x2, 0x1A, w2, 3, c2);
}

/* DrawPanelPenalties (15995, PC only; segment 006, ends in DrawPanelLine_x): draw the first four entries of a
   penalty panel list at x, rows 5 apart from y 9: the player's number (two digits from x + 0Ah, a leading blank
   under 10), then the minutes (x + 1Bh, leading blank under 10) and the seconds (x + 2Ah) in penaltydigits; a free
   entry (player < 0) is six blanks (dword_DC2B8). pens: the list (hudpenhome or hudpenaway); x: the left edge.
   No result. */
void DrawPanelPenalties(PenSlot *pens, int x)
{
    int i;
    int y;

    for (i = 0, y = 9; i < 4; i++, y += 5) {
        if (pens[i].pl >= 0) {
            if (pens[i].pl < 10) PUTSPRITE(dword_DC2B8, x + 0xA, y);
            else PUTSPRITE(penaltydigits[pens[i].pl / 10], x + 0xA, y);
            PUTSPRITE(penaltydigits[pens[i].pl % 10], x + 0x10, y);
            if (pens[i].min < 10) PUTSPRITE(dword_DC2B8, x + 0x1B, y);
            else PUTSPRITE(penaltydigits[pens[i].min / 10], x + 0x1B, y);
            PUTSPRITE(penaltydigits[pens[i].min % 10], x + 0x21, y);
            PUTSPRITE(penaltydigits[pens[i].sec / 10], x + 0x2A, y);
            PUTSPRITE(penaltydigits[pens[i].sec % 10], x + 0x30, y);
        } else {
            PUTSPRITE(dword_DC2B8, x + 0xA, y);
            PUTSPRITE(dword_DC2B8, x + 0x10, y);
            PUTSPRITE(dword_DC2B8, x + 0x1B, y);
            PUTSPRITE(dword_DC2B8, x + 0x21, y);
            PUTSPRITE(dword_DC2B8, x + 0x2A, y);
            PUTSPRITE(dword_DC2B8, x + 0x30, y);
        }
    }
}
