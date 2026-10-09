/* Joystick calibration file: menu items (one source block: Norm ends in Sel's tail). */
/* DRAFT: x / y parameters land in ebp / edi (EXE edi / ebp); Norm also needs the cross-jumps into Sel_ret / Sel_common. */
#include "nhl95.h"

/* one menu item: box, text and two "enabled" words (32 bytes, as in DrawMenuBar) */
typedef struct MenuItem {
    int x1, y1, x2, y2;
    char *text;
    int on1, on2;
    int pad;
} MenuItem;

/* DrawMenuItemSel (6B94E) - draw an enabled item (on1 or on2 set) of a menu at x / y as selected: fill its box
   (1 in from the left, one row less on the top row) in fill, then its text 2 in / 1 down in colour col on FFh. */
void DrawMenuItemSel(MenuItem *m, int x, int y, int col, int fill)
{
    int w;
    int h;

    if (!m->on1 && !m->on2) return;
    w = m->x2 - m->x1 - 2;
    h = m->y2 - m->y1 - (m->y1 == 0);
    x += m->x1 + 1;
    y += m->y1;
    y += m->y1 == 0;
    sub_90D20(x, y, w, h, fill);
    sub_8E9C0(col, 0xFF);
    SetTextColors(col, 0);
    PrintMenuText(x + 2, y + 1, m->text);
}

/* DrawMenuItemNorm (6B9EB) - the same for an unselected item, filled with fill (the 6th argument; sel unused). */
void DrawMenuItemNorm(MenuItem *m, int x, int y, int col, int sel, int fill)
{
    int w;
    int h;

    if (!m->on1 && !m->on2) return;
    w = m->x2 - m->x1 - 2;
    h = m->y2 - m->y1 - (m->y1 == 0);
    x += m->x1 + 1;
    y += m->y1;
    y += m->y1 == 0;
    sub_90D20(x, y, w, h, fill);
    sub_8E9C0(col, 0xFF);
    SetTextColors(col, 0);
    PrintMenuText(x + 2, y + 1, m->text);
}
