/* Engine display: game palette. */
#include "nhl95.h"

/* LoadTeamPalette (673C5) - build the in-game palette: home's palette part from HOMEPALS.BIN to pal+180h (its remap table to
   byte_DC9D8), vis's from AWAYPALS.BIN to pal+240h (remap to byte_DC8D8, entries 90h and up shifted by 40h), and
   the rink palette (RINKPAL Pal30 shape) for entries 0-7Fh and the bytes from 2F1h on. */
void LoadTeamPalette(int home, int vis, unsigned char *pal)
{
    char path[16];
    unsigned char *buf;
    unsigned char *s;
    int i;

    MakePath(path, fileoncd[0xA1] == 1 ? (char *)cddriveptr : 0, (char *)str_HOMEPALS4, (char *)str_extBIN);
    buf = (unsigned char *)sub_8E8A0(path, 0);
    s = buf + home * 0x1C0;
    for (i = 0; i < 0xC0; i++) pal[0x180 + i] = s[i];
    s += 0xC0;
    for (i = 0; i < 0x100; i++) byte_DC9D8[i] = s[i];
    jctime((int)buf);
    MakePath(path, fileoncd[0x2B] == 1 ? (char *)cddriveptr : 0, (char *)str_AWAYPALS, (char *)str_extBIN);
    buf = (unsigned char *)sub_8E8A0(path, 0);
    s = buf + vis * 0x1C0;
    for (i = 0; i < 0xC0; i++) pal[0x240 + i] = s[i];
    s += 0xC0;
    for (i = 0; i < 0x90; i++) byte_DC8D8[i] = s[i];
    for (i = 0x90; i < 0x100; i++) byte_DC8D8[i] = s[i] + 0x40;
    jctime((int)buf);
    MakePath(path, fileoncd[0x15F] == 1 ? (char *)cddriveptr : 0, (char *)str_Rinkpal, 0);
    buf = (unsigned char *)sub_8E83C(path, 0);
    s = (unsigned char *)sub_B30B4((int)buf, (char *)str_Pal30) + 0x10;
    for (i = 0; i < 0x180; i++) pal[i] = s[i];
    for (i = 0x2F1; i < 0x300; i++) pal[i] = s[i];
    jctime((int)buf);
}
