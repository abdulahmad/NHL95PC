/* Import / export: team grid cell background. */
#include "nhl95.h"

/* SaveGridCellBg (37D6A) - PC only: allocate the 78 x 65 "back" bitmap gridcellbuf (4688h bytes, header cleared,
   width / height at +4 / +6) and, for the cell of the 4 x 7 team grid tab holding team (x 60 / 18 + 85 per column,
   y 84 + 92 per row, kept in gridcellx / gridcelly), draw the saved bitmap bm at x - 4, y (sub_903F0) and grab the cell into it
   (sub_91400). */
void SaveGridCellBg(int team, unsigned char *tab, int bm, int x, int y)
{
    int r;
    int c;

    gridcellbuf = sub_8CCA8((char *)str_Back, 0x4688, 0x20);
    memset((void *)gridcellbuf, 0, 0x11);
    *(short *)(gridcellbuf + 4) = 0x4E;
    *(short *)(gridcellbuf + 6) = 0x41;
    for (r = 0; r < 4; r++) {
        for (c = 0; c < 7; c++) {
            if ((tab + r * 7)[c] == team) {
                if (r < 2) gridcellx = c * 85 + 0x3C;
                else gridcellx = c * 85 + 0x12;
                gridcelly = r * 92 + 0x54;
                sub_903F0(bm, x - 4, y);
                sub_91400(gridcellbuf, gridcellx, gridcelly);
            }
        }
    }
}
