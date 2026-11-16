/* Import export: team grid cell highlight. */
#include "nhl95.h"

/* HighlightGridCell: for the cell of the 4 x 7 team grid tab holding team (x 62 20 + 85 per
 column, y 86 + 92 per row): on, draw two nested frames in colour 80h (XorRectOutline: the 74 x 61 box and one a pixel
 bigger round it); off, erase them (DrawFrameClipped with 0). */
void HighlightGridCell(int team, unsigned char *tab, int on)
{
    int c;
    int y;
    int x2;
    int y0;
    int x3;
    int x0;
    int x;
    int y2;
    int y3;
    int r;

    for (r = 0; r < 4; r++) {
        for (c = 0; c < 7; c++) {
            if ((tab + r * 7)[c] == team) {
                if (r < 2) x = c * 85 + 0x3E;
                else x = c * 85 + 0x14;
                y = r * 92 + 0x56;
                x2 = x + 0x4A;
                y2 = r * 92 + 0x93;
                x0 = x - 1;
                y0 = r * 92 + 0x55;
                x3 = x + 0x4B;
                y3 = r * 92 + 0x94;
                if (on) {
                    XorRectOutline(x, y, x2, y2, 0x80);
                    XorRectOutline(x0, y0, x3, y3, 0x80);
                } else {
                    DrawFrameClipped(x, y, x2, y2, 0);
                    DrawFrameClipped(x0, y0, x3, y3, 0);
                }
            }
        }
    }
}
