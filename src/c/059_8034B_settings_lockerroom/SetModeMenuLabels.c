/* Settings / locker room: settings menu labels. */
#include "nhl95.h"

/* SetModeMenuLabels (805C4) - PC only: name the settings menu for game mode mode: "Exhibition Settings" / "Playoff
   Settings" / "Show League Settings" (modesetlabel, "Settings" after the mode word) and the return item
   (off_CECFF / off_CED3F: "Sports Central", "Playoff Tree", "Return"). */
void SetModeMenuLabels(unsigned mode)
{
    switch (mode) {
    case 0:
        strcpy((char *)modesetlabel, (char *)str_Exhibition2);
        strcpy((char *)modesetlabel + 0xA, (char *)str_Settings3);
        off_CED3F = off_CECFF = (int)str_SportsCentral2;
        return;
    case 1:
        strcpy((char *)modesetlabel, (char *)str_Playoff);
        strcpy((char *)modesetlabel + 7, (char *)str_Settings3);
        off_CED3F = off_CECFF = (int)str_PlayoffTree2;
        return;
    case 2:
        strcpy((char *)modesetlabel, (char *)str_ShowLeague);
        strcpy((char *)modesetlabel + 0xB, (char *)str_Settings3);
        off_CED3F = off_CECFF = (int)str_Return;
        return;
    }
}
