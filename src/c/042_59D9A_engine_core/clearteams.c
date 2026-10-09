/* Engine core: reset the team structures. */
#include "nhl95.h"

/* clearteams (5B881) - PC-new: zero both team structs (200h bytes from hmtmstruct), set the goalie words to 0,
   the words at +2Eh to -1 and the bytes at +B6h to -1, and store each team's data pointers (tmsort into
   SortCords, line tables, player stats, roster, team record, ...). */
void clearteams(void)
{
    unsigned char *p;
    short i;

    p = (unsigned char *)&hmtmstruct;
    for (i = 0; (unsigned)i < 0x200; i++) *p++ = 0;
    hmtmgoalie[0] = 0;
    dword_DF642 = -1;
    awtmgoalie = 0;
    word_DF742 = -1;
    byte_DF6CA = 0xFF;
    byte_DF7CA = 0xFF;
    hmtmsort = (int)SortCords;
    dword_DF6F2 = (int)unk_DACA0;
    dword_DF6F6 = (int)unk_DAC40;
    hmtmlines[0] = (int)hmlinetab;
    hmtmplstats = (int)dword_DB088;
    dword_DF6FE = (int)unk_DC240;
    hmtmroster = (int)hmroster;
    hmtmptrF2 = (int)hmteamrec;
    awtmsort = (int)(SortCords + 6);
    dword_DF7F2 = (int)unk_DAE94;
    dword_DF7F6 = (int)unk_DAC70;
    awtmlines = (int)awlinetab;
    awtmplstats = (int)unk_DB218;
    dword_DF7FE = (int)unk_DC252;
    awtmroster = (int)awroster;
    awtmptrF2 = (int)awteamrec;
}
