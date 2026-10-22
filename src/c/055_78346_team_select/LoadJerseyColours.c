/* Team select: jersey colours. Copying the destination aside and writing the palette pointer back into dst puts
 that pointer in ebx (both copy loops). The remap entry is read through a signed char pointer, twice in the compare
 and once in the else arm: lea edx / mov cl,[edx] and mov dl,cl as in the EXE. */
#include "nhl95.h"

/* LoadJerseyColours: from HOMEPALS.BIN (1C0h bytes per team) take the palette part of the away (VisTeam) or home
 team: its first B4h bytes to dst+CCh, the rest (B4h-BFh) to dst+24Ch, plus the four fixed colours at dst+264h
 build jerseyremap 80h-FEh from the team's remap table (entries shifted down by 3Ch, those the signed compare
 picks up by 8), with FBh-FEh mapping to themselves, and install it. The second argument is unused. */
void LoadJerseyColours(int away, int unused, unsigned char *dst)
{
    char path[16];
    unsigned char *out;
    unsigned char *buf;
    int i;
    signed char *p;
    unsigned char d;

    out = dst;
    MakePath(path, fileoncd[0xA1] == 1 ? (char *)cddriveptr : 0, (char *)str_HOMEPALS3, (char *)str_extBIN);
    buf = (unsigned char *)sub_8E8A0(path, 0);
    dst = buf + (away ? VisTeam : HomeTeam) * 0x1C0;
    for (i = 0; i < 0xB4; i++) out[0xCC + i] = dst[i];
    for (i = 0xB4; i < 0xC0; i++) out[0x198 + i] = dst[i];
    out[0x264] = 0x18;
    out[0x265] = 0;
    out[0x266] = 0;
    out[0x267] = 0x2A;
    out[0x268] = 0;
    out[0x269] = 0;
    out[0x26A] = 0x3B;
    out[0x26B] = 0x12;
    out[0x26C] = 0;
    out[0x26D] = 0x3B;
    out[0x26E] = 0x3B;
    out[0x26F] = 0x3B;
    dst += 0xC0;
    for (i = 0x80; i < 0xFF; i++) {
        p = (signed char *)&dst[i];
        if (*p >= (signed char)0x80 || *p <= 0xBB) d = dst[i] - 0x3C;
        else d = *p + 8;
        jerseyremap[i] = d;
    }
    byte_D1333 = 0xFB;
    byte_D1334 = 0xFC;
    byte_D1335 = 0xFD;
    byte_D1336 = 0xFE;
    FreeMemBlock((int)buf);
    sub_B4DD4(jerseyremap);
}
