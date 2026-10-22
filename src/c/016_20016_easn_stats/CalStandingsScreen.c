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
        if (!dword_C65A8) dword_C65A8 = sub_8E8A0((char *)str_EASNvfn, 0);
        if (!dword_C65AC) {
            if (!statsplayoffs)
                MakePath(path, fileoncd[0x8C] == 1 ? (char *)cddriveptr : 0, (char *)statsbgnames[statsplayoffs], 0);
            else
                MakePath(path, fileoncd[0x8D] == 1 ? (char *)cddriveptr : 0, (char *)statsbgnames[statsplayoffs], 0);
            dword_C65AC = sub_8E83C(path, 0);
        }
        ShowPlayoffTree(statsteambuf, (int)statsteamorder);
        DrawMenuBar(unk_CF54F, 4, 0x40, 0x41, 0x42);
    } else {
        FreeDeskBuffers();
        sub_B4BA8();
        DrawMenuBar(unk_CF54F, 4, 0x40, 0x41, 0x42);
        StandingsScreen(statsteambuf, (int)statsteamorder);
    }
    LoadCalendarShapes();
    return 0;
}
