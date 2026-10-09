/* Create player: database errors. */
#include "nhl95.h"

/* DrawDBErrorsScreen (6EC95) - draw the database errors screen (background 41h, menu bar, title area, OK buttons) and clear
   *sel; on the first call (*first) print the "errors found" header at text line *line (13-pixel lines from
   1Fh) and advance it by 2. */
void DrawDBErrorsScreen(int *sel, int *line, int *first)
{
    SetDrawBitmap(fullscrbmp);
    sub_B392C(0x41);
    DrawMenuBar(unk_D0450, 5, 0x40, 0x41, 0x42);
    sub_90D20(0, 0x13, 0x280, 0x1CD, 0x41);
    DrawButtons((Button *)unk_D0CA2, 2);
    *sel = 0;
    if (*first) {
        PrintCenteredText(*line * 13 + 0x1F, (char *)str_ErrorsFoundInDatabases);
        *line += 2;
        *first = 0;
    }
}
