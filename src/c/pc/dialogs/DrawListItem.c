/* Misc dialogs: list box items (one source block: DrawListItems ends in DrawListItem's exit). */
/* DRAFT: 6 differing under 10.0 GA, original size. A separate right-alignment
   delta and the text-line increment put y (savings 9) ahead of w (7), matching
   EDI / EBP. The right-alignment delta still computes in EDX instead of
   updating EBP and forming EAX for the shared add. DrawListItems needs this tail. */
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
        c = w - fputchar(text);
        c -= 4;
        x += c;
        break;
    case 2:
        c = w - fputchar(text);
        x += c / 2;
        break;
    }
    y++;
    PrintMenuText(x, y, text);
}

/* DrawListItems: draw n items of a list box from top on (DrawListItem for items[top + i]). */
void DrawListItems(char **items, int x, int y, int w, int top, int sel, int n, unsigned align, int marks, char *flags)
{
    int i;

    for (i = 0; i < n; i++) DrawListItem(items[top + i], x, y, w, top, top + i, sel, align, marks, flags);
}
