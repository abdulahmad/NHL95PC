/* Misc dialogs: list box items (one source block: DrawListItems ends in DrawListItem's exit). */
/* DRAFT: y / w land in ebp / edi (EXE edi / ebp); DrawListItems short-jumps into this exit, so mark both as one block. */
#include "nhl95.h"

/* DrawListItem (302B9) - draw list item idx (text) of a list box at x / y, w wide, scrolled to top: its row
   (byte_D42C3 + 2 high) filled with boxfillcolor when marks is set and flags[idx] is, else dlgtextfg for the
   selection sel or dlgtextbg; item colours (SetListItemColors), then the text 2 in, 1 down: align 1 right
   aligned, 2 centred (fputchar = text width). */
void DrawListItem(char *text, int x, int y, int w, int top, int idx, int sel, unsigned align, int marks, char *flags)
{
    int c;

    y += (byte_D42C3 + 2) * (idx - top) + 2;
    x += 2;
    w -= 4;
    if (marks && flags[idx]) c = boxfillcolor;
    else if (sel == idx) c = dlgtextfg;
    else c = dlgtextbg;
    sub_90D20(x, y, w, byte_D42C3 + 2, c);
    SetListItemColors(idx, sel);
    switch (align) {
    case 1:
        w -= fputchar(text);
        x += w - 4;
        break;
    case 2:
        x += (w - fputchar(text)) / 2;
        break;
    }
    PrintMenuText(x, y + 1, text);
}

/* DrawListItems (3039C) - draw n items of a list box from top on (DrawListItem for items[top + i]). */
void DrawListItems(char **items, int x, int y, int w, int top, int sel, int n, unsigned align, int marks, char *flags)
{
    int i;

    for (i = 0; i < n; i++) DrawListItem(items[top + i], x, y, w, top, top + i, sel, align, marks, flags);
}
