/* EASN stats: calendar standings. */
/* statsteamorder is cast to int so the call matches ShowPlayoffTree(int, int). */
#include "nhl95.h"

/* CalStandingsScreen: the standings stats screen from the calendar: GameStandingsScreen (playoff tree with its
 font and background loaded once, else the standings), with the calendar shapes freed first when memory is low and
 reloaded after. Returns 0. */
int CalStandingsScreen(void)
{
    char path[16];

    FreeCalendarIfLowMem();
    if (statsplayoffs) {
        if (!easnfontbuf) easnfontbuf = sub_8E8A0((char *)str_EASNvfn, 0);
        if (!embscupbank) {
            if (!statsplayoffs)
                MakePath(path, fileoncd[0x8C] == 1 ? (char *)cddriveptr : 0, (char *)statsbgnames[statsplayoffs], 0);
            else
                MakePath(path, fileoncd[0x8D] == 1 ? (char *)cddriveptr : 0, (char *)statsbgnames[statsplayoffs], 0);
            embscupbank = LoadBank(path, 0);
        }
        ShowPlayoffTree(statsteambuf, (int)statsteamorder);
        DrawMenuBar(standingsmenubar, 4, 0x40, 0x41, 0x42);
    } else {
        FreeDeskBuffers();
        SetScreenTarget();
        DrawMenuBar(standingsmenubar, 4, 0x40, 0x41, 0x42);
        StandingsScreen(statsteambuf, (int)statsteamorder);
    }
    LoadCalendarShapes();
    return 0;
}
