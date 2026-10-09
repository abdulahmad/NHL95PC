/* Rink tiles: crest palette. */
#include "nhl95.h"

/* LoadCrestsPalette (33F02) - PC only: read the current palette (sub_8FFB0) and fade it out, then build the crest
   palette: entries A0h-FFh from CRESTS3.BIN (bytes 1E0h-2FFh), entries 0-7Fh and FBh-FEh from the "pal16" art of
   the bank at unk_DC890; fade in to it. */
void LoadCrestsPalette(void)
{
    unsigned char pal[0x300];
    char path[16];
    unsigned char *src;
    int bank;
    int i;

    sub_8FFB0(0, 0x100, pal);
    FadePalStep(1, pal, 0x10);
    MakePath(path, fileoncd[0x55] == 1 ? (char *)cddriveptr : 0, (char *)str_CRESTS3, (char *)str_extBIN);
    bank = sub_8E8A0(path, 0);
    for (i = 0x1E0; i < 0x300; i++) pal[i] = ((unsigned char *)bank)[i - 0x1E0];
    jctime(bank);
    bank = sub_8E83C((char *)unk_DC890, 0);
    src = (unsigned char *)sub_B30B4(bank, (char *)str_Pal16) + 0x10;
    for (i = 0; i < 0x180; i++) pal[i] = src[i];
    for (i = 0x2F1; i < 0x2FD; i++) pal[i] = src[i];
    jctime(bank);
    FadePalStep(0, pal, 0x10);
}
