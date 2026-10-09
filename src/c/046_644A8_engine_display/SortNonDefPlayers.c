/* Engine display: roster sorting. */
#include "nhl95.h"

/* SortNonDefPlayers (6455F) - out[25] = side's roster sorted by keys, without the defensemen (roster position byte 'D'),
   -1 for the left-out entries. */
void SortNonDefPlayers(short side, signed char *out, short *keys)
{
    int i;
    unsigned short c;

    for (i = 0; i < 0x19; i++) {
        dword_E9C88[i] = i;
        c = byte_DB3AE[side * 0x444 + i * 0x27];
        if (c == 'D') dword_E9C24[i] = -1;
        else dword_E9C24[i] = keys[i];
    }
    sub_93540(0x19, dword_E9C24, dword_E9C88);
    for (i = 0; i < 0x19; i++) /* low byte read 68k-style: dword at -3, sar 18h */
        out[i] = dword_E9C24[i] < 0 ? -1 : *(int *)((char *)&dword_E9C88[i] - 3) >> 24;
}
