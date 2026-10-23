/* Misc dialogs: list box items (one source block: DrawListItems ends in DrawListItem's exit). */
/* DRAFT: 11 differing under 10.0 GA. Loading the font height before the row calculation and
   reusing c for the centred text width fixes the row's instruction order and the flag lookup.
   y / w still use ebp / edi (EXE edi / ebp), and case 1 updates w in place instead of
   forming eax and sharing case 2's add. DrawListItems needs this tail to match first. */
#include "nhl95.h"

/* DrawListItem: draw list item idx (text) of a list box at x y, w wide, scrolled to top: its row
 (byte_D42C3 + 2 high) filled with boxfillcolor when marks is set and flags[idx] is, else dlgtextfg for the
 selection sel or dlgtextbg; item colours (SetListItemColors), then the text 2 in, 1 down: align 1 right
 aligned, 2 centred (fputchar = text width). */
void DrawListItem(char *text, int x, int y, int w, int top, int idx, int sel, unsigned align, int marks, char *flags)
{
    int c;
    int fontheight;

    fontheight = byte_D42C3;
    y += (idx - top) * (fontheight + 2) + 2;
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
        c = w - fputchar(text);
        x += c / 2;
        break;
    }
    PrintMenuText(x, y + 1, text);
}

/* DrawListItems: draw n items of a list box from top on (DrawListItem for items[top + i]). */
void DrawListItems(char **items, int x, int y, int w, int top, int sel, int n, unsigned align, int marks, char *flags)
{
    int i;

    for (i = 0; i < n; i++) DrawListItem(items[top + i], x, y, w, top, top + i, sel, align, marks, flags);
}
