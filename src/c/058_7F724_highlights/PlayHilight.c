/* Highlights: play the recorded highlight as a replay. */
#define PlayHilight PlayHilight_decl
#include "nhl95.h"
#undef PlayHilight

/* PlayHilight (8011C, PC only): copy the highlight record into the game (teams, clock, jerseys), fade the music out,
 load the rink and play the replay, then free the shapes. A home team of 26 or higher uses rink 12. No arguments
 and no result. Adding the replay offset straight to p (no temporary) gives the EXE's registers (found by
 tools/permute.py). */
void PlayHilight(void)
{
    unsigned char pal[0x300];
    int i;

    byte_DC268 = hilightrec[0];
    byte_DC267 = hilightrec[1];
    HomeTeam = hilightrec[2];
    VisTeam = hilightrec[0x1F];
    curperiod = *(int *)(hilightrec + 0x3C);
    hudclockmin = *(int *)(hilightrec + 0x40);
    hudclocksec = *(int *)(hilightrec + 0x44);
    hudclockhund = *(int *)(hilightrec + 0x48);
    *(unsigned short *)&sflags = *(unsigned short *)(hilightrec + 0x4C);
    {
        unsigned char *p;

        p = replaystart;
        p += *(int *)(hilightrec + 0x4E);
        recbpr = p;
    }
    i = 0;
    do {
        hmrosterjersey[i * 39] = hilightrec[i + 3];
        byte_DB7F1[i * 39] = hilightrec[i + 0x20];
        i++;
    } while (i < 0x1C);
    if (musicon && songdata)
        sub_8FCDF(musichandle, 3, 0x64);
    sub_8FFB0(0, 0x100, pal);
    FadePalStep(1, pal, 0x10);
    if (musicon && songdata) {
        int slot;

        do
            slot = musicslot;
        while (sub_8FC8A(slot, 3) == 0);
        sub_8D2F0(songdata);
        songdata = 0;
    }
    ShowLoadingScreen();
    LoadTeamPalette(HomeTeam, VisTeam, gamepal);
    LoadRockMusic();
    LoadGameGfx();
    FadeOutPalCycle();
    SetScreenSize(0x140, 0xC8);
    if (HomeTeam >= 0x1A)
        LoadRink(0xC);
    else
        LoadRink(HomeTeam);
    InstantReplay(0);
    sub_8FFB0(0, 0x100, pal);
    FadePalStep(1, pal, 0x10);
    sub_8EA18(s1font);
    sub_1BAB1();
    FreeMemBlock(rinkendbank);
    FreeMemBlock(scrbrdshapes);
    FreeMemBlock(numshpbank);
    FreeMemBlock(hilightfont);
    FreeRockMusic();
    FreeRinkGfx();
    ClearInputQueue();
}
