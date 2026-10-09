/* Trades: team palettes. */
#include "nhl95.h"

/* LoadHomePals (40792) - load HOMEPALS.BIN (1C0h bytes per team: C0h palette bytes, then the 100h-byte remap table) and set
   palette entries 80h-FFh: home's palette part, vis's palette part, with the four fixed colours FBh-FEh
   (18h,0,0 / 2Ah,0,0 / 3Bh,12h,0 / 3Bh,3Bh,3Bh); home's remap table goes to byte_DC9D8, vis's to
   byte_DC8D8 (entries 90h and up shifted by 40h). */
void LoadHomePals(int home, int vis)
{
    unsigned char pal[0x180];
    char path[16];
    unsigned char *buf;
    unsigned char *s;
    int i;

    MakePath(path, fileoncd[0xA1] == 1 ? (char *)cddriveptr : 0, (char *)str_HOMEPALS, (char *)str_extBIN);
    buf = (unsigned char *)sub_8E8A0(path, 0);
    s = buf + home * 0x1C0;
    for (i = 0; i < 0xC0; i++) pal[i] = s[i];
    s += 0xC0;
    for (i = 0; i < 0x100; i++) byte_DC9D8[i] = s[i];
    s = buf + vis * 0x1C0;
    for (i = 0; i < 0xC0; i++) pal[0xC0 + i] = s[i];
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
    sub_B4B88(0x80, 0x80, pal);
}
