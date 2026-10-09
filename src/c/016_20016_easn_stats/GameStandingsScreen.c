/* EASN stats: in-game standings screen. */
#include "nhl95.h"

/* GameStandingsScreen (203FA) - stats menu "standings" in a game: in the playoffs load the EASN font (EASN.VFN,
   dword_C65A8) and the background bank for the stats source (statsbgnames, from the CD when fileoncd 8Ch / 8Dh
   says so; dword_C65AC) once, show the playoff tree and redraw the menu bar; otherwise free the desk buffers, reset
   the clip, redraw the menu bar and show the standings. Returns 0. */
int GameStandingsScreen(void)
{
    char *bank;
    char path[16];

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
    return 0;
}
