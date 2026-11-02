/* Main startup: in-game hot keys. */
#define sub_90354 sub_90354_decl
#define sub_9035C sub_9035C_decl
#include "nhl95.h"
#undef sub_90354
#undef sub_9035C

int __cdecl sub_90354(int bank);  /* graphics library: frames in a bank */
int __cdecl sub_9035C(int bank, int n);  /* graphics library: frame n of a bank */

/* HandleHotKey (1118F, PC only; owner of HandleHotKey_ret): act on a hot key from the input queue (bit 7 set, the
   scan code in bits 0-6). F1-F4 / F5-F8 (3Bh-3Eh / 3Fh-42h) request a line change for the home / away team
   (lcrequest, lcreqchoice), F9 / F10 show the home / away goalie banner, Tab (0Fh) toggles the jersey numbers
   (shownumbers), S (1Fh) toggles the sound effects and M (32h) the music (gameopts bits 7 / 6, starting or
   stopping the sound library), Esc (1) requests the exit (escrequest), and R (13h), while the game runs, plays the
   instant replay: save the joystick sampling and the mouse, fade out, stop the crowd, music and speech, run
   InstantReplay with the input handler, then restore the mouse, redraw the HUD panel, fade back in and scroll
   the rink view away so it is redrawn. key: the queued key. Result: 1 for Esc and after a replay, else 0. */
int HandleHotKey(int key)
{
    unsigned char k;

    k = key;
    if (!(k & 0x80)) return 0;
    k &= 0x7F;
    switch (k) {
    case 0x3B:
    case 0x3C:
    case 0x3D:
    case 0x3E:
        lcrequest[0] = 1;
        lcreqchoice[0] = k - 0x3B;
        break;
    case 0x3F:
    case 0x40:
    case 0x41:
    case 0x42:
        lcrequest[1] = 1;
        lcreqchoice[1] = k - 0x3F;
        break;
    case 0x43:
        ShowGoalieBanner(0);
        break;
    case 0x44:
        ShowGoalieBanner(1);
        break;
    case 0x0F:
        shownumbers = !shownumbers;
        break;
    case 0x13:
        if (gmode & 0x10) break;
        if (curperiod == -1) break;
        joysampling_save = joysampling;
        joysampling = 0;
        if (pad1dev[0] == 1 || pad2dev == 1) {
            savedmousex = mousex;
            savedmousey = mousey;
        }
        sub_8FFB0(0, 0x100, savepal);
        FadePalette(1, savepal, 0x10);
        CrowdFadeOut();
        if (musicon) MusicChanReset();
        else sub_8F633();
        SpeechStopQueue();
        StopDigiSample();
        InputInstall();
        InstantReplay(1);
        ClearInputQueue();
        InputRemove();
        if (pad1dev[0] == 1 || pad2dev == 1) {
            MouseSetPos(savedmousex, savedmousey);
            sub_B2E1B(0, 0, 0x140, 0xC8);
        }
        fadeinpending = 1;
        DrawHudPanel(HomeTeam, VisTeam, curperiod, 0);
        joysampling = joysampling_save;
        rinkscrollx += 0x3E8;
        rinkscrolly += 0x3E8;
        return 1;
    case 0x32:
        gameopts.music = !gameopts.music;
        if (gameopts.music) sub_8F979();
        else {
            StopDigiSample();
            sub_8F984();
        }
        break;
    case 0x1F:
        if (gameopts.sfx) {
            CrowdNoiseOff();
            if (musicon) MusicChanReset();
            else sub_8F633();
            sub_8F96E();
        }
        gameopts.sfx = !gameopts.sfx;
        if (gameopts.sfx) {
            CrowdNoiseReset();
            sub_8F963();
        }
        break;
    case 1:
        escrequest = 1;
        return 1;
    }
    return 0;
}

/* SetFullPalette (11550, PC only; ends in HandleHotKey_ret): set all 256 colours from the palette pal (3 bytes
   each) in two halves of 80h, each after a vertical retrace (sub_B4C84). pal: the palette. No result. */
void SetFullPalette(unsigned char *pal)
{
    int i;
    int o;

    for (i = 0, o = 0; i < 0x100; i += 0x80, o += 0x180) {
        sub_B4C84();
        sub_B4B88(i, 0x80, pal + o);
    }
}

/* PlayGame (11D09, PC only; segment 002, ends in HandleHotKey_ret): play a game. A new game (no saved-game file
   open, *fh negative) loads the rock music, the game graphics, the team palettes and the rink (team 0Ch for the
   teams from 1Ah on), sets up the game (failing: result 2 and back to the desk screen) and the goalie menu. A
   resumed game (file *fh) loads the cup final series (unless gameopts bit 9), the game state, closes the file,
   rebuilds the lines and goalie menu and, unless the game was being left (exitgame -1), shows the sports desk
   (result 2: back), then returns to the rink: screen 140h x C8h, the mouse, the HUD panel, an overlay's PPV art
   (loaded once into dword_E0244, its frames into dword_DEF8C) and the play-by-play clips. Then run the game
   (GameLoop); a league game that ended (gamemode, result 1) clears gameopts bit 15 and deletes the league's
   GAME.SAV. Back to the 280h x 1E0h desk screen. fh: the saved-game file handle (-1 for a new game).
   No result. */
void PlayGame(int *fh)
{
    char name[0x20];
    char path[0x20];
    int i;

    if (*fh < 0) {
        LoadRockMusic();
        LoadGameGfx();
        LoadTeamPalette(HomeTeam, VisTeam, gamepal);
        FadeOutPalCycle();
        SetScreenSize(0x140, 0xC8);
        LoadRink(HomeTeam >= 0x1A ? 0xC : HomeTeam);
        rinkscrollx = rinkscrolly = 0;
        if (SetupGame() < 0) {
            gameresult = 2;
            sub_1B982();
            sub_B4BA8();
            goto desk;
        }
        SetupGoalieMenu();
        goto play;
    }
    if (!gameopts.fullot) LoadCupFinalSeries();
    LoadGameState(*fh);
    FileClose(fh);
    *fh = -1;
    BuildDefaultLines();
    NormalizeDressFlags();
    SetupTeamLines(0);
    SetupTeamLines(1);
    MakeGSummaryPath();
    CrowdNoiseReset();
    SetupGoalieMenu();
    if (exitgame != -1) {
        FadeOutPalCycle();
        gameresult = 0;
        SportsDesk(0);
        if (gameresult == 2) {
            sub_1B982();
            return;
        }
        SetScreenSize(0x140, 0xC8);
        if (pad1dev[0] == 1 || pad2dev == 1) MouseSetPos(savedmousex, savedmousey);
        fadeinpending = 1;
        escrequest = 0;
        DrawHudPanel(HomeTeam, VisTeam, curperiod, 0);
        rinkscrollx += 0x3E8;
        rinkscrolly += 0x3E8;
        if (ovlseq != -1 && ovlstep != -1 && !dword_E0244) {
            MakePath(path, fileoncd[dword_CC080[ovlseq]] == 1 ? (char *)cddriveptr : 0, (char *)off_CBED0[ovlseq],
                (char *)str_PPV);
            dword_E0244 = sub_8E8A0(path, 0x20);
            for (i = 0; i < sub_90354(dword_E0244); i++) dword_DEF8C[i] = sub_9035C(dword_E0244, i);
        }
        PaPreloadClips(teamabbrevs[HomeTeam], teamabbrevs[VisTeam]);
    }
play:
    gameresult = introskipped = 0;
    joyq_flush();
    GameLoop();
    ResetGoalieMenu();
    if (gamemode && gameresult == 1) {
        ((unsigned char *)&gameopts)[1] &= 0x7F;
        strcpy(name, (char *)&curleague);
        strcat(name, (char *)str_backslash);
        strcat(name, (char *)str_GameSav2);
        j_unlink(name);
    }
desk:
    SetScreenSize(0x280, 0x1E0);
}
