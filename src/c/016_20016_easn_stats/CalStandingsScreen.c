/* EASN stats: calendar standings. */
/* DRAFT: same register blocker as GameStandingsScreen (dword_C65AC lands in edx, EXE ecx, and the bank arg follows it). */
#include "nhl95.h"

/* CalStandingsScreen (216D7) - the standings stats screen from the calendar: GameStandingsScreen (playoff tree with its
   font and background loaded once, else the standings), with the calendar shapes freed first when memory is low and
   reloaded after. Returns 0. */
int CalStandingsScreen(void)
{
    char *bank;
    char path[16];

    FreeCalendarIfLowMem();
    if (statsplayoffs) {
        if (!dword_C65A8) dword_C65A8 = sub_8E8A0((char *)str_EASNvfn, dword_C65A8);
        if ((bank = (char *)dword_C65AC) == 0) {
            if (!statsplayoffs)
                MakePath(path, fileoncd[0x8C] == 1 ? (char *)cddriveptr : 0, (char *)statsbgnames[statsplayoffs],
                         bank);
            else
                MakePath(path, fileoncd[0x8D] == 1 ? (char *)cddriveptr : 0, (char *)statsbgnames[statsplayoffs],
                         bank);
            dword_C65AC = sub_8E83C(path, 0);
        }
        ShowPlayoffTree(statsteambuf, statsteamorder);
        DrawMenuBar(unk_CF54F, 4, 0x40, 0x41, 0x42);
    } else {
        FreeDeskBuffers();
        sub_B4BA8();
        DrawMenuBar(unk_CF54F, 4, 0x40, 0x41, 0x42);
        StandingsScreen(statsteambuf, statsteamorder);
    }
    LoadCalendarShapes();
    return 0;
}
