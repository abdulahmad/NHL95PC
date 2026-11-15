/* Engine core: reset the team structures. */
#include "nhl95.h"

/* clearteams: zero both team structs (200h bytes from hmtmstruct), set the goalie words to 0,
 the words at +2Eh to -1 and the bytes at +B6h to -1, and store each team's data pointers (tmsort into
 SortCords, line tables, player stats, roster, team record,...). */
void clearteams(void)
{
    unsigned char *p;
    short i;

    p = (unsigned char *)&hmtmstruct;
    for (i = 0; (unsigned)i < 0x200; i++) *p++ = 0;
    hmtmgoalie[0] = 0;
    hmtmextra = -1;
    awtmgoalie = 0;
    awtmextra = -1;
    hmtmpbox = 0xFF;
    awtmpbox = 0xFF;
    hmtmsort = (int)SortCords;
    hmtmplattr = (int)hmplattr;
    hmtmglattr = (int)hmglattr;
    hmtmlines[0] = (int)hmlinetab;
    hmtmplstats = (int)hmplstats;
    hmtmglstats = (int)unk_DC240;
    hmtmroster = (int)hmroster;
    hmtmptrF2 = (int)hmteamrec;
    awtmsort = (int)(SortCords + 6);
    awtmplattr = (int)awplattr;
    awtmglattr = (int)awglattr;
    awtmlines = (int)awlinetab;
    awtmplstats = (int)awplstats;
    awtmglstats = (int)unk_DC252;
    awtmroster = (int)awroster;
    awtmptrF2 = (int)awteamrec;
}
