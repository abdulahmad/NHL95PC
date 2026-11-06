/* Scoreboard: line energy bars. */
#include "nhl95.h"

/* DrawLineGroupBars: draw one group's energy bars for the line-change box.
 x above A0h is the away side. When that side's line box is on, the group follows lcline;
 otherwise it follows line. Lines 0-3, 4-5 and 6-7 are the three groups. The first time
 through, the group's indicator shape is drawn and *drawn is set. Each bar is energy/200
 pixels, in the blink colour when this is the boxed line and it is blinking, in the selected
 colour when it is line, and in the plain colour otherwise. The bar locals are declared in the loop body: at
 the top of the function color / color2 and the two widths take swapped stack slots. */
void DrawLineGroupBars(int *drawn, int *inds, int line, int *energy, int x)
{
    int side;
    int cur;
    int start;
    int end;
    int color2;
    int i;
    int row;

    side = x > 0xA0;
    if (lcboxon[side]) cur = lcline[side];
    else cur = line;
    switch (cur) {
    case 0:
    case 1:
    case 2:
    case 3:
        if (!*drawn) {
            sub_B4CF2(inds[0]);
            *drawn = 1;
        }
        row = 8;
        start = 0;
        end = 4;
        break;
    case 4:
    case 5:
        if (!*drawn) {
            sub_B4CF2(inds[1]);
            *drawn = 1;
        }
        row = 0xE;
        start = 4;
        end = 6;
        break;
    case 6:
    case 7:
        if (!*drawn) {
            sub_B4CF2(inds[2]);
            *drawn = 1;
        }
        row = 0xE;
        start = 6;
        end = 8;
        break;
    }
    for (i = start; i < end;) {
        int w2;
        int x1;
        int w;
        int color;

        if (i == cur && lcblink[side]) {
            color = 0x61;
            color2 = 7;
        } else {
            color = i == line ? 0x21 : 0x67;
            color2 = 0;
        }
        w = energy[i] / 200;
        sub_90D20(x + 0x15 - w, row, w, 3, color);
        sub_90D20(x1 = x + 0x20, row, w, 3, color);
        sub_90D20(x + 1, row, w2 = 0x14 - w, 3, color2);
        sub_90D20(x1 + w, row, w2, 3, color2);
        i++;
        row += 6;
    }
}
