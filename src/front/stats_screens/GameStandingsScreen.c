/* EASN stats: in-game standings screen. */
#include "nhl95.h"

/* GameStandingsScreen: stats menu "standings" in a game: in the playoffs load the EASN font (EASN.VFN,
 easnfontbuf) and the background bank for the stats source (statsbgnames, from the CD when fileoncd 8Ch 8Dh
 says so; embscupbank) once, show the playoff tree and redraw the menu bar; otherwise free the desk buffers, reset
 the clip, redraw the menu bar and show the standings. Returns 0. The font and bank loads pass a literal 0
 (Watcom reuses the tested global's zero register: the bank test in ecx is the extension). */
int GameStandingsScreen(void)
{
    char path[16];

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
    return 0;
}
