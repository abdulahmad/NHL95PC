/* Engine display: roster sorting. */
#include "nhl95.h"

/* SortNonDefPlayers: out[25] = side's roster sorted by keys, without the defensemen (roster position byte 'D'),
 -1 for the left-out entries. */
void SortNonDefPlayers(short side, signed char *out, short *keys)
{
    int i;
    unsigned short c;

    for (i = 0; i < 0x19; i++) {
        linesortidx[i] = i;
        c = hmrosterpos[side * 0x444 + i * 0x27];
        if (c == 'D') lineslotmark[i] = -1;
        else lineslotmark[i] = keys[i];
    }
    SortIndices(0x19, lineslotmark, linesortidx);
    for (i = 0; i < 0x19; i++) /* low byte read 68k-style: dword at -3, sar 18h */
        out[i] = lineslotmark[i] < 0 ? -1 : *(int *)((char *)&linesortidx[i] - 3) >> 24;
}
