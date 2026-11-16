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

    GameRecordMonth = hilightrec[0];
    GameRecordDay = hilightrec[1];
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
        awrosterjersey[i * 39] = hilightrec[i + 0x20];
        i++;
    } while (i < 0x1C);
    if (MusicOn && songdata)
        SetDigiChannelVolume(musichandle, 3, 0x64);
    SetPalette(0, 0x100, pal);
    FadePalStep(1, pal, 0x10);
    if (MusicOn && songdata) {
        int slot;

        do
            slot = musicslot;
        while (SndQuery(slot, 3) == 0);
        PushMemDescriptorLocked(songdata);
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
    SetPalette(0, 0x100, pal);
    FadePalStep(1, pal, 0x10);
    TextSetFont(s1font);
    FreePhotoBanks();
    FreeMemBlock(rinkendbank);
    FreeMemBlock(scrbrdshapes);
    FreeMemBlock(numshpbank);
    FreeMemBlock(hilightfont);
    FreeRockMusic();
    FreeRinkGfx();
    ClearInputQueue();
}
