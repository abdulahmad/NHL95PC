/* Joystick calibration file: drop-down menu and menu boxes (one source block: DrawMenuBox ends in the
   dropdown's exit). */
#include "nhl95.h"

/* one menu item: box, text and two "enabled" words (32 bytes, as in DrawMenuBar) */
typedef struct MenuItem {
    int x1, y1, x2, y2;
    char *text;
    int on1, on2;
    int pad;
} MenuItem;

/* DrawMenuDropdown (6B684) - draw the drop-down of n items at x / y: one box from the first item's top left to
   the last item's bottom right (DrawMenuBox in col1 / col2 / col3), then each item's text 3 in (2 down for the
   first, 1 for the others): enabled items (on1 or on2) in col1 (PrintMenuText), disabled ones greyed in col3
   (PrintMenuTextGrey). */
void DrawMenuDropdown(MenuItem *m, int n, int x, int y, int col1, int col2, int col3)
{
    int i;

    DrawMenuBox(m->x1 + x, m->y1 + y, m[n - 1].x2 + x, m[n - 1].y2 + y, col1, col2, col3);
    if (!m->on1 && !m->on2) {
        sub_8E9C0(col3, 0xFF);
        SetTextColors(col3, 0);
        PrintMenuTextGrey(m->x1 + 3 + x, m->y1 + 2 + y, m->text);
    } else {
        sub_8E9C0(col1, 0xFF);
        SetTextColors(col1, 0);
        PrintMenuText(m->x1 + 3 + x, m->y1 + 2 + y, m->text);
    }
    for (i = 1; i < n; i++) {
        if (!m[i].on1 && !m[i].on2) {
            sub_8E9C0(col3, 0xFF);
            SetTextColors(col3, 0);
            PrintMenuTextGrey(m[i].x1 + 3 + x, m[i].y1 + 1 + y, m[i].text);
        } else {
            sub_8E9C0(col1, 0xFF);
            SetTextColors(col1, 0);
            PrintMenuText(m[i].x1 + 3 + x, m[i].y1 + 1 + y, m[i].text);
        }
    }
}

/* DrawMenuBox (6B7FC) - a 3-D menu box from x1 / y1 to x2 / y2: filled with col2, top and left edges in col1
   (the light side), bottom and right edges in col3. */
void DrawMenuBox(int x1, int y1, int x2, int y2, int col1, int col2, int col3)
{
    sub_90D20(x1, y1, x2 - x1 + 1, y2 - y1 + 1, col2);
    sub_B4FAC(x1, y1, x2 - 1, y1, col1);
    sub_B4FAC(x1, y1, x1, y2 - 1, col1);
    sub_B4FAC(x2, y1 + 1, x2, y2, col3);
    sub_B4FAC(x1 + 1, y2, x2, y2, col3);
}
