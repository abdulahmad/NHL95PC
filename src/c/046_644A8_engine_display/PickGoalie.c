/* Engine display: line table goalie choice. */
#include "nhl95.h"

/* PickGoalie (652D6) - PC only: choose the goalie (line table slot 25h; 24h is the starter) of team side (home
   hmlinetab, away awlinetab). For slot 24h the starter is taken over first. The first of roster players 25-27
   that is neither: with a roster status that byte_CD418 marks as available (1) he is taken; with status 2 (when
   force) he becomes 3 (bench) and is removed from the line slots 28h-2Fh (100). Else the starter. */
void PickGoalie(short side, short slot, short force)
{
    signed char *tab;
    short i;
    short j;
    int r;
    short st;

    tab = (signed char *)(side ? awlinetab : hmlinetab);
    if (slot == 0x24) tab[0x24] = tab[0x25];
    for (i = 25; i < 28; i++) {
        if (i == tab[0x24] || i == tab[0x25]) continue;
        r = side * 0x444 + i * 39;
        st = hmroster[r];
        if (byte_CD418[hmroster[r]] == 1) {
take:
            tab[0x25] = i;
            return;
        }
        if (st == 2 && force) {
            hmroster[r] = 3;
            for (j = 0x28; j < 0x30; j++) {
                if (tab[j] == i) tab[j] = 100;
            }
            goto take;
        }
    }
    tab[0x25] = tab[0x24];
}
