/* ShowLoadingScreen - unless it is up: fade the palette out (loadpals) and clear the screen; with enough free
   memory (> 222E0h) load the LOAD bank (str_LoadPic) (from the CD when listed there), take its Pal23 palette and build two
   rotated copies of entries 1-8Fh (by 30h and 60h entries) for the palette cycle, draw LoadPic at 100,75, start
   LoadScreenPalTick on the timer and fade loadpals up to the palette one step per two ticks; loadscreenon = 1. */
#include "nhl95.h"

void ShowLoadingScreen(void)
{
    char pal[768];
    char pal2[768];
    char pal3[768];
    char path[16];
    int bank;
    char *src;
    int i;
    int j;
    int k;
    int done;

    if (loadscreenon) return;
    sub_8FFB0(loadscreenon, 0x100, loadpals);
    FadePalStep(1, loadpals, 8);
    sub_B4BA8();
    sub_B392C(0);
    if (sub_8DAB8() <= 0x222E0) return;
    memset(loadpals, 0, 0x300);
    MakePath(path, fileoncd[0x222] == 1 ? (char *)cddriveptr : 0, (char *)str_LoadPic, 0);
    bank = sub_8E83C(path, 0);
    src = (char *)sub_B30B4(bank, (char *)str_Pal23) + 0x10;
    memcpy(pal, src, 0x300);
    memcpy(pal2, src, 0x300);
    memcpy(pal3, src, 0x300);
    for (i = 1; i < 0x90; i++) {
        if (i < 0x60) j = i + 0x2F;
        else j = i - 0x5F;
        pal2[i * 3] = pal[j * 3];
        pal2[i * 3 + 1] = pal[j * 3 + 1];
        pal2[i * 3 + 2] = pal[j * 3 + 2];
    }
    for (i = 1; i < 0x90; i++) {
        if (i < 0x30) j = i + 0x60;
        else j = i - 0x2F;
        pal3[i * 3] = pal[j * 3];
        pal3[i * 3 + 1] = pal[j * 3 + 1];
        pal3[i * 3 + 2] = pal[j * 3 + 2];
    }
    j = sub_B30B4(bank, (char *)str_LoadPic);
    sub_910E0(j, 0x64, 0x4B);
    jctime(bank);
    palcyclelock = 1;
    palcyclephase = 0;
    palcycledelay = 3;
    sub_8E4C0(LoadScreenPalTick);
    palcyclelock = 0;
    done = 0;
    while (!done) {
        done = 1;
        for (k = 0; k < 3; k++) {
            for (i = 0; i < 0x300; i++) {
                if (((char *)loadpals)[k * 0x300 + i] < pal[k * 0x300 + i]) {
                    loadpals[k * 0x300 + i]++;
                    if (done == 1) done = 0;
                }
            }
        }
        sub_B3989(2);
        sub_B3999();
    }
    loadscreenon = 1;
}
