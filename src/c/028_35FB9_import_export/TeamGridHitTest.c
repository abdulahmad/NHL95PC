/* Import / export: team grid hit test. */
#include "nhl95.h"

/* TeamGridHitTest (37B92) - PC only: the team of the 4 x 7 team grid tab (team bytes, row by row) under point
   x, y: cells 70 x 57 pixels every 85 / 92, rows 0-1 from x 40h, rows 2-3 from x 16h, from y 58h. Returns the team,
   or -1 outside the grid or on an empty cell (99). */
int TeamGridHitTest(int x, int y, unsigned char *tab)
{
    int team;
    int cell;
    int r;
    int c;
    int top;
    int cx;
    int bottom;
    int right;

    team = -1;
    for (r = 0; r < 4; r++) {
        for (c = 0; c < 7; c++) {
            cell = (tab + r * 7)[c];
            if (r < 2) cx = c * 85 + 0x40;
            else cx = c * 85 + 0x16;
            top = r * 92 + 0x58;
            right = cx + 0x46;
            bottom = r * 92 + 0x91;
            if (x >= cx && x <= right && y >= top && y <= bottom) {
                team = cell;
                r = 4;
                c = 6;
            }
        }
    }
    if (team == 99) return -1;
    return team;
}
