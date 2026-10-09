/* Roster / jersey: trade palettes. */
#include "nhl95.h"

/* LoadTradeTeamPals (3E835) - for the trade screen load HOMEPALS.BIN (1C0h bytes per team) twice: team t1's palette part to
   pal+180h and its remap table to byte_DC9D8, team t2's palette part to pal+240h and its remap table to byte_DC8D8
   (entries 90h and up shifted by 40h); then the four fixed colours at pal+171h and remap 7Bh-7Eh to themselves. */
void LoadTradeTeamPals(int t1, int t2, unsigned char *pal)
{
    char path[16];
    unsigned char *buf;
    unsigned char *s;
    int i;

    MakePath(path, fileoncd[0xA1] == 1 ? (char *)cddriveptr : 0, (char *)str_HOMEPALS2, (char *)str_extBIN);
    buf = (unsigned char *)sub_8E8A0(path, 0);
    s = buf + t1 * 0x1C0;
    for (i = 0; i < 0xC0; i++) pal[0x180 + i] = s[i];
    s += 0xC0;
    for (i = 0; i < 0x100; i++) byte_DC9D8[i] = s[i];
    jctime((int)buf);
    MakePath(path, fileoncd[0x2B] == 1 ? (char *)cddriveptr : 0, (char *)str_HOMEPALS2, (char *)str_extBIN);
    buf = (unsigned char *)sub_8E8A0(path, 0);
    s = buf + t2 * 0x1C0;
    for (i = 0; i < 0xC0; i++) pal[0x240 + i] = s[i];
    s += 0xC0;
    for (i = 0; i < 0x90; i++) byte_DC8D8[i] = s[i];
    for (i = 0x90; i < 0x100; i++) byte_DC8D8[i] = s[i] + 0x40;
    jctime((int)buf);
    pal[0x171] = 0x18;
    pal[0x172] = 0;
    pal[0x173] = 0;
    pal[0x174] = 0x2A;
    pal[0x175] = 0;
    pal[0x176] = 0;
    pal[0x177] = 0x3B;
    pal[0x178] = 0x12;
    pal[0x179] = 0;
    pal[0x17A] = 0x3B;
    pal[0x17B] = 0x3B;
    pal[0x17C] = 0x3B;
    byte_D1333 = 0x7B;
    byte_D1334 = 0x7C;
    byte_D1335 = 0x7D;
    byte_D1336 = 0x7E;
}
