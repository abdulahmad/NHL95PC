/* Engine display: roster sorting. */
#include "nhl95.h"

/* SortPlayersByPos: out[25] = side's roster players at position letter pos, sorted by keys; -1 for the others. */
void SortPlayersByPos(short side, signed char *out, short *keys, char pos)
{
    int i;

    for (i = 0; i < 0x19; i++) {
        linesortidx[i] = i;
        if (hmrosterpos[side * 0x444 + i * 0x27] != pos) lineslotmark[i] = -1;
        else lineslotmark[i] = keys[i];
    }
    sub_93540(0x19, lineslotmark, linesortidx);
    for (i = 0; i < 0x19; i++) /* low byte read 68k-style: dword at -3, sar 18h */
        out[i] = lineslotmark[i] < 0 ? -1 : *(int *)((char *)&linesortidx[i] - 3) >> 24;
}
