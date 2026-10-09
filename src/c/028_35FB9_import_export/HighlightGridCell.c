/* Import / export: team grid cell highlight. */
#include "nhl95.h"

/* HighlightGridCell (37EA6) - PC only: for the cell of the 4 x 7 team grid tab holding team (x 62 / 20 + 85 per
   column, y 86 + 92 per row): on, draw two nested frames in colour 80h (sub_92F50: the 74 x 61 box and one a pixel
   bigger round it); off, erase them (sub_93000 with 0). */
void HighlightGridCell(int team, unsigned char *tab, int on)
{
    int r;
    int c;
    int x;
    int y;
    int x2;
    int y2;
    int x0;
    int y0;
    int x3;
    int y3;

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
                    sub_92F50(x, y, x2, y2, 0x80);
                    sub_92F50(x0, y0, x3, y3, 0x80);
                } else {
                    sub_93000(x, y, x2, y2, on);
                    sub_93000(x0, y0, x3, y3, 0);
                }
            }
        }
    }
}
