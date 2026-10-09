/* Team select: jersey colours. */
#include "nhl95.h"

/* LoadJerseyColours (78A87) - from HOMEPALS.BIN (1C0h bytes per team) take the palette part of the away (VisTeam) or home
   team: its first B4h bytes to dst+CCh, the rest (B4h-BFh) to dst+24Ch, plus the four fixed colours at dst+264h;
   build jerseyremap 80h-FEh from the team's remap table (entries shifted down by 3Ch, those the signed compare
   picks up by 8), with FBh-FEh mapping to themselves, and install it. The second argument is unused. */
void LoadJerseyColours(int away, int unused, unsigned char *dst)
{
    char path[16];
    unsigned char *buf;
    unsigned char *s;
    int i;
    signed char c;
    unsigned char *p;
    unsigned char d;

    MakePath(path, fileoncd[0xA1] == 1 ? (char *)cddriveptr : 0, (char *)str_HOMEPALS3, (char *)str_extBIN);
    buf = (unsigned char *)sub_8E8A0(path, 0);
    s = buf + (away ? VisTeam : HomeTeam) * 0x1C0;
    for (i = 0; i < 0xB4; i++) dst[0xCC + i] = s[i];
    for (i = 0xB4; i < 0xC0; i++) dst[0x198 + i] = s[i];
    dst[0x264] = 0x18;
    dst[0x265] = 0;
    dst[0x266] = 0;
    dst[0x267] = 0x2A;
    dst[0x268] = 0;
    dst[0x269] = 0;
    dst[0x26A] = 0x3B;
    dst[0x26B] = 0x12;
    dst[0x26C] = 0;
    dst[0x26D] = 0x3B;
    dst[0x26E] = 0x3B;
    dst[0x26F] = 0x3B;
    s += 0xC0;
    for (i = 0x80; i < 0xFF; i++) {
        p = &s[i];
        c = *p;
        if (c >= (signed char)0x80 || c <= 0xBB) d = s[i] - 0x3C;
        else d = c + 8;
        jerseyremap[i] = d;
    }
    byte_D1333 = 0xFB;
    byte_D1334 = 0xFC;
    byte_D1335 = 0xFD;
    byte_D1336 = 0xFE;
    jctime((int)buf);
    sub_B4DD4(jerseyremap);
}
