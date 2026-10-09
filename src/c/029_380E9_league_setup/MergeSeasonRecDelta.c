/* League setup: database merge. */
#include "nhl95.h"

/* MergeSeasonRecDelta (3A71C) - add the changes of a player's season record (cur - old, the 18 stat words) to dst; for the
   same player (a == b) also copy the 4 bytes at +24h. */
void MergeSeasonRecDelta(short *old, short *cur, short *dst, int a, int b)
{
    dst[0] += cur[0] - old[0];
    dst[1] += cur[1] - old[1];
    dst[2] += cur[2] - old[2];
    dst[3] += cur[3] - old[3];
    dst[4] += cur[4] - old[4];
    dst[5] += cur[5] - old[5];
    dst[6] += cur[6] - old[6];
    dst[7] += cur[7] - old[7];
    dst[8] += cur[8] - old[8];
    dst[9] += cur[9] - old[9];
    dst[10] += cur[10] - old[10];
    dst[11] += cur[11] - old[11];
    dst[12] += cur[12] - old[12];
    dst[13] += cur[13] - old[13];
    dst[14] += cur[14] - old[14];
    dst[15] += cur[15] - old[15];
    dst[16] += cur[16] - old[16];
    dst[17] += cur[17] - old[17];
    if (a == b) {
        ((unsigned char *)dst)[0x24] = ((unsigned char *)cur)[0x24];
        ((unsigned char *)dst)[0x25] = ((unsigned char *)cur)[0x25];
        ((unsigned char *)dst)[0x26] = ((unsigned char *)cur)[0x26];
        ((unsigned char *)dst)[0x27] = ((unsigned char *)cur)[0x27];
    }
}
