/* Temp files: league merge and update. */
#include "nhl95.h"

/* MenuMergeUpdateDbs (333D7) - merge and update the league team databases (MergeUpdateDbs) with the league mode state loaded (exhibition state saved and
   restored around it); on success reload the menu palette (TEMP4, fade in) and return 2, else 0. */
int MenuMergeUpdateDbs(void)
{
    int r;
    int pal;

    SaveModeState(exhstate);
    LoadModeState(lgstate);
    r = MergeUpdateDbs();
    SaveModeState((unsigned char *)lgstate);
    LoadModeState(exhstate);
    if (r) {
        pal = sub_8CCA8((char *)str_Temp4, 0x300, 0x20);
        sub_8FFB0(0, 0x100, (unsigned char *)pal);
        FadePalStep(1, (unsigned char *)pal, 0x10);
        jctime(pal);
        return 2;
    }
    return 0;
}
