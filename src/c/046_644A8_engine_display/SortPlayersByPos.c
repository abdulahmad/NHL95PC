/* Engine display: roster sorting. */
#include "nhl95.h"

/* SortPlayersByPos (644A8) - out[25] = side's roster players at position letter pos, sorted by keys; -1 for the others. */
void SortPlayersByPos(short side, signed char *out, short *keys, char pos)
{
    int i;

    for (i = 0; i < 0x19; i++) {
        dword_E9C88[i] = i;
        if (byte_DB3AE[side * 0x444 + i * 0x27] != pos) dword_E9C24[i] = -1;
        else dword_E9C24[i] = keys[i];
    }
    sub_93540(0x19, dword_E9C24, dword_E9C88);
    for (i = 0; i < 0x19; i++) /* low byte read 68k-style: dword at -3, sar 18h */
        out[i] = dword_E9C24[i] < 0 ? -1 : *(int *)((char *)&dword_E9C88[i] - 3) >> 24;
}
