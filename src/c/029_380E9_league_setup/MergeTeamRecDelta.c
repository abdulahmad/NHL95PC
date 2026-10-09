/* League setup: database merge. */
#include "nhl95.h"

/* MergeTeamRecDelta (3A5FC) - add the changes of a team record (cur - old: bytes 28h-2Bh, words 2Ch-38h, bytes 3Ah-3Dh,
   words 3Eh-4Ah) to dst; for the same team (a == b) also copy the 30h bytes at +BCh. */
typedef struct Block30 { int d[0xC]; } Block30;

void MergeTeamRecDelta(unsigned char *old, unsigned char *cur, unsigned char *dst, int a, int b)
{
    ((unsigned char *)dst)[0x28] += ((unsigned char *)cur)[0x28] - ((unsigned char *)old)[0x28];
    ((unsigned char *)dst)[0x29] += ((unsigned char *)cur)[0x29] - ((unsigned char *)old)[0x29];
    ((unsigned char *)dst)[0x2A] += ((unsigned char *)cur)[0x2A] - ((unsigned char *)old)[0x2A];
    ((unsigned char *)dst)[0x2B] += ((unsigned char *)cur)[0x2B] - ((unsigned char *)old)[0x2B];
    *(short *)((char *)dst + 0x2C) += *(short *)((char *)cur + 0x2C) - *(short *)((char *)old + 0x2C);
    *(short *)((char *)dst + 0x2E) += *(short *)((char *)cur + 0x2E) - *(short *)((char *)old + 0x2E);
    *(short *)((char *)dst + 0x30) += *(short *)((char *)cur + 0x30) - *(short *)((char *)old + 0x30);
    *(short *)((char *)dst + 0x32) += *(short *)((char *)cur + 0x32) - *(short *)((char *)old + 0x32);
    *(short *)((char *)dst + 0x34) += *(short *)((char *)cur + 0x34) - *(short *)((char *)old + 0x34);
    *(short *)((char *)dst + 0x36) += *(short *)((char *)cur + 0x36) - *(short *)((char *)old + 0x36);
    *(short *)((char *)dst + 0x38) += *(short *)((char *)cur + 0x38) - *(short *)((char *)old + 0x38);
    ((unsigned char *)dst)[0x3A] += ((unsigned char *)cur)[0x3A] - ((unsigned char *)old)[0x3A];
    ((unsigned char *)dst)[0x3B] += ((unsigned char *)cur)[0x3B] - ((unsigned char *)old)[0x3B];
    ((unsigned char *)dst)[0x3C] += ((unsigned char *)cur)[0x3C] - ((unsigned char *)old)[0x3C];
    ((unsigned char *)dst)[0x3D] += ((unsigned char *)cur)[0x3D] - ((unsigned char *)old)[0x3D];
    *(short *)((char *)dst + 0x3E) += *(short *)((char *)cur + 0x3E) - *(short *)((char *)old + 0x3E);
    *(short *)((char *)dst + 0x40) += *(short *)((char *)cur + 0x40) - *(short *)((char *)old + 0x40);
    *(short *)((char *)dst + 0x42) += *(short *)((char *)cur + 0x42) - *(short *)((char *)old + 0x42);
    *(short *)((char *)dst + 0x44) += *(short *)((char *)cur + 0x44) - *(short *)((char *)old + 0x44);
    *(short *)((char *)dst + 0x46) += *(short *)((char *)cur + 0x46) - *(short *)((char *)old + 0x46);
    *(short *)((char *)dst + 0x48) += *(short *)((char *)cur + 0x48) - *(short *)((char *)old + 0x48);
    *(short *)((char *)dst + 0x4A) += *(short *)((char *)cur + 0x4A) - *(short *)((char *)old + 0x4A);
    if (a == b) *(Block30 *)(dst + 0xBC) = *(Block30 *)(cur + 0xBC);
}
