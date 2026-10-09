/* Import / export: team database file name. */
#include "nhl95.h"

/* MakeTeamDbFmt (36207) - PC only: build the file name of team n's database in out: dir, a backslash, the
   name pattern str_S4 and ".nn" when team entry n of tab (30 bytes each) has byte 17h = 1, else an empty name. */
void MakeTeamDbFmt(char *out, char *dir, unsigned char *tab, int n)
{
    char ext[4];

    if (tab[n * 30 + 0x17] == 1) {
        sprintf(ext, (char *)str_02d, n);
        strcpy(out, dir);
        strcat(out, (char *)str_backslash2);
        strcat(out, (char *)str_S4);
        strcat(out, ext);
    } else {
        *out = 0;
    }
}
