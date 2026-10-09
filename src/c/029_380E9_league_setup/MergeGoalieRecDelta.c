/* League setup: database merge. */
#include "nhl95.h"

/* MergeGoalieRecDelta (3A826) - add the changes of a goalie's record (cur - old, all stat words but the two computed ones)
   to dst, recompute word 8 = word 7 * 100 / word 0 and word 19 = word 18 * 100 / word 11 (0 when dividing by 0);
   for the same goalie (a == b) also copy the 4 bytes at +2Ch. */
void MergeGoalieRecDelta(unsigned short *old, unsigned short *cur, unsigned short *dst, int a, int b)
{
    dst[0] += cur[0] - old[0];
    dst[1] += cur[1] - old[1];
    dst[2] += cur[2] - old[2];
    dst[3] += cur[3] - old[3];
    dst[4] += cur[4] - old[4];
    dst[5] += cur[5] - old[5];
    dst[6] += cur[6] - old[6];
    dst[7] += cur[7] - old[7];
    dst[9] += cur[9] - old[9];
    dst[10] += cur[10] - old[10];
    dst[11] += cur[11] - old[11];
    dst[12] += cur[12] - old[12];
    dst[13] += cur[13] - old[13];
    dst[14] += cur[14] - old[14];
    dst[15] += cur[15] - old[15];
    dst[16] += cur[16] - old[16];
    dst[17] += cur[17] - old[17];
    dst[18] += cur[18] - old[18];
    dst[20] += cur[20] - old[20];
    dst[21] += cur[21] - old[21];
    if (dst[0]) dst[8] = (int)(dst[7] * 100) / (int)dst[0];
    else dst[8] = dst[0];
    if (dst[11]) dst[19] = (int)(dst[18] * 100) / (int)dst[11];
    else dst[19] = 0;
    if (a == b) {
        ((unsigned char *)dst)[0x2C] = ((unsigned char *)cur)[0x2C];
        ((unsigned char *)dst)[0x2D] = ((unsigned char *)cur)[0x2D];
        ((unsigned char *)dst)[0x2E] = ((unsigned char *)cur)[0x2E];
        ((unsigned char *)dst)[0x2F] = ((unsigned char *)cur)[0x2F];
    }
}
