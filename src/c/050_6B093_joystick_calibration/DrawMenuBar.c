/* Joystick calibration file: menu bar. */
#include "nhl95.h"

/* one menu bar title: 32 bytes */
typedef struct BarItem {
    int x1, y1, x2, y2;
    char *text;
    int pad[3];
} BarItem;

/* DrawMenuBar (6B5E4) - draw the menu bar of n titles: text colour col1 on FFh (shadow 0); each title's box
   (DrawMenuBox from x1 / 0 to x2 / y2 in col1 / col2 / col3) with its text 3 in and 2 down (PrintMenuText), then
   the empty bar from after the last title to x 27Fh. */
void DrawMenuBar(void *bar, int n, int col1, int col2, int col3)
{
    int i;

    sub_8E9C0(col1, 0xFF);
    SetTextColors(col1, 0);
    for (i = 0; i < n; i++) {
        DrawMenuBox(((BarItem *)bar)[i].x1, 0, ((BarItem *)bar)[i].x2, ((BarItem *)bar)[i].y2, col1, col2, col3);
        PrintMenuText(((BarItem *)bar)[i].x1 + 3, 2, ((BarItem *)bar)[i].text);
    }
    DrawMenuBox(((BarItem *)bar)[n - 1].x2 + 1, 0, 0x27F, ((BarItem *)bar)[n - 1].y2, col1, col2, col3);
}
