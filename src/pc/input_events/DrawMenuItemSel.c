/* Joystick calibration file: menu items (one source block: Norm ends in Sel's tail). */
#include "nhl95.h"

/* one menu item: box, text and two "enabled" words (32 bytes, as in DrawMenuBar) */
typedef struct MenuItem {
    int x1, y1, x2, y2;
    char *text;
    int on1, on2;
    int pad;
} MenuItem;

/* DrawMenuItemSel (6B94E, PC only): draw an enabled item (on1 or on2 set) of a menu at x y as selected: fill its
   box (1 in from the left, one row less on the top row) in selfill, then its text 2 in 1 down in colour col on
   FFh. m: the item; x, y: the menu origin; col, selfill, normfill: the text colour and the selected / normal fill
   (the callers pass FAh, F9h, F8h to both DrawMenuItemSel and DrawMenuItemNorm; normfill is unused here). No result.
   The y update is one expression: `y += m->y1; y += m->y1 == 0` puts x in ebp and y in edi (original edi, ebp). */
void DrawMenuItemSel(MenuItem *m, int x, int y, int col, int selfill, int normfill)
{
    int w;
    int h;

    if (!m->on1 && !m->on2) return;
    w = m->x2 - m->x1 - 2;
    h = m->y2 - m->y1 - (m->y1 == 0);
    x += m->x1 + 1;
    y = y + m->y1 + (m->y1 == 0);
    sub_90D20(x, y, w, h, selfill);
    sub_8E9C0(col, 0xFF);
    SetTextColors(col, 0);
    PrintMenuText(x + 2, y + 1, m->text);
}

/* DrawMenuItemNorm (6B9EB, PC only): the same for an unselected item, filled with normfill. Arguments as
   DrawMenuItemSel (selfill unused). No result. Watcom merges its tail into DrawMenuItemSel's (from the push of the
   fill colour: DrawMenuItemSel_common, and the early exit DrawMenuItemSel_ret). */
void DrawMenuItemNorm(MenuItem *m, int x, int y, int col, int selfill, int normfill)
{
    int w;
    int h;

    if (!m->on1 && !m->on2) return;
    w = m->x2 - m->x1 - 2;
    h = m->y2 - m->y1 - (m->y1 == 0);
    x += m->x1 + 1;
    y = y + m->y1 + (m->y1 == 0);
    sub_90D20(x, y, w, h, normfill);
    sub_8E9C0(col, 0xFF);
    SetTextColors(col, 0);
    PrintMenuText(x + 2, y + 1, m->text);
}
