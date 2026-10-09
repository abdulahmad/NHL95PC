/* Misc dialogs: list colours. */
#include "nhl95.h"

/* SetListItemColors (30209) - text colours for list item: the selected item (item == sel) is drawn inverted. */
void SetListItemColors(int sel, int item)
{
    int fg;
    int bg;

    if (item == sel) {
        fg = dlgtextbg;
        bg = dlgtextfg;
    } else {
        fg = dlgtextfg;
        bg = dlgtextbg;
    }
    sub_8E9C0(fg, bg);
}
