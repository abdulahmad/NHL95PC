/* Game save / IO: the in-game main loop. */
/* DRAFT: 1668 vs 1673 bytes before the exit, 348 of 395 instructions, first pass; see docs/UNSURE.md. Its match
   belongs in HandleHotKey.c, whose HandleHotKey_ret tail it uses. */
#define sub_90354 sub_90354_decl
#define sub_9035C sub_9035C_decl
#define TicksSinceLastCall TicksSinceLastCall_decl
#define sub_6AF97 sub_6AF97_decl
#define sub_6B008 sub_6B008_decl
#define sub_6AF52 sub_6AF52_decl
#define DrawRinkOverlays DrawRinkOverlays_decl
#define CrowdNoiseUpdate CrowdNoiseUpdate_decl
#define UpdateHudPanel UpdateHudPanel_decl
#define sub_6ADA7 sub_6ADA7_decl
#define StartThreeStars StartThreeStars_decl
#define GameLoop GameLoop_decl
#include "nhl95.h"
#undef sub_90354
#undef sub_9035C
#undef TicksSinceLastCall
#undef sub_6AF97
#undef sub_6B008
#undef sub_6AF52
#undef DrawRinkOverlays
#undef CrowdNoiseUpdate
#undef UpdateHudPanel
#undef sub_6ADA7
#undef StartThreeStars
#undef GameLoop

int __cdecl sub_90354(int bank);
int __cdecl sub_9035C(int bank, int n);
void TicksSinceLastCall(void);
void sub_6AF97(int x, int y);
void sub_6B008(void);
void sub_6AF52(int x, int y, int x2, int y2);
void DrawRinkOverlays(short x, short y);
void CrowdNoiseUpdate(short n);
void UpdateHudPanel(void);
void sub_6ADA7(void);
void StartThreeStars(void);

/* GameLoop (1167B, PC only): run the game until it ends. Each pass (joystick sampling on) while the period
   runs: turn the input ticks into frames (6 per tick, in tenths through frameaccum) and run them, scroll the
   rink view after the camera (clamped to 0..40h / 0..1A8h), draw the rink and its overlays, fade in after a
   desk visit, update the crowd noise and the HUD clock (hundredths; at the period end the clock's own time),
   draw the HUD panel and sprites. Esc (escrequest) goes to the sports desk (in demo mode it fades and ends with
   result 2) and back: screen size, mouse, HUD panel, the overlay's PPV art and the play-by-play clips. Deferred
   calls run between frames. At the period end (exitgame): in demo mode fade and end with result 1, else
   PeriodOver (result 2 ends) and, if the game goes on, redraw the HUD for the next period, centre the mouse
   and reset the period state. When the game is over: the three stars, the post-game desk and result 1. Then
   sub_1B982. No arguments, no result. */
void GameLoop(void)
{
    char path[0x20];
    int n;
    int i;

    TicksSinceLastCall();
    for (;;) {
        joysampling = 1;
        if (gameover) break;
        while (!exitgame) {
            frameaccum += ResetInputSampling() * 6;
            n = frameaccum / 10;
            frameaccum %= 10;
            RunGameFrames(n);
            viewscrollx = camx + 0x20;
            viewscrolly = 0x140 - camy - 0x54;
            if (viewscrollx > 0x40) viewscrollx = 0x40;
            else if (viewscrollx < 0) viewscrollx = 0;
            if (viewscrolly > 0x1A8) viewscrolly = 0x1A8;
            else if (viewscrolly < 0) viewscrolly = 0;
            sub_6AF97(0, 0);
            sub_6B008();
            SetRinkScroll(viewscrollx, viewscrolly);
            sub_6AF52(scrollx + bgscrollx * 8, scrolly + bgscrolly * 8, scrollx + bgscrollx * 8 + 0x140,
                scrolly + bgscrolly * 8 + 0xA8);
            spritedrawcount = 0;
            DrawRinkOverlays(viewscrollx, viewscrolly);
            if (fadeinpending) {
                joysampling_save = joysampling;
                joysampling = 0;
                sub_8FFB0(0, 0x100, savepal);
                FadePalette(1, savepal, 0x10);
                FlushGSumQueue();
                joysampling = joysampling_save;
            }
            CrowdNoiseUpdate(n);
            if (penshotlive) {
                hudhundstep = 0;
            } else {
                hudhundstep = hudhundaccum / 0x18;
                hudhundaccum %= 0x18;
                if (exitgame && !(gameclock | clockticks[0]))
                    hudhundstep = hudclockhund + (hudclockmin * 60 + hudclocksec) * 100;
            }
            UpdateHudPanel();
            sub_6AF97(-(scrollx + bgscrollx * 8), -(bgscrolly * 8 + scrolly));
            sub_6ADA7();
            if (fadeinpending) {
                joysampling_save = joysampling;
                joysampling = 0;
                FadePalette(0, gamepal, 0x10);
                fadeinpending = 0;
                joysampling = joysampling_save;
            }
            if (escrequest) {
                if (demomode) {
                    FadePalette(1, gamepal, 0x10);
                    gameresult = 2;
                    goto out;
                }
                joysampling_save = joysampling;
                joysampling = 0;
                if (pad1dev[0] == 1 || pad2dev == 1) {
                    savedmousex = mousex;
                    savedmousey = mousey;
                }
                CrowdFadeOut();
                if (musicon) MusicChanReset();
                else sub_8F633();
                StopDigiSample();
                SpeechStopQueue();
                FlushGSumQueue();
                sub_8EA18(s1font);
                sub_8FFB0(0, 0x100, savepal);
                FadePalette(1, savepal, 0x10);
                SetScreenSize(0x280, 0x1E0);
                SportsDesk(0);
                if (gameresult == 2) goto out;
                SetScreenSize(0x140, 0xC8);
                if (pad1dev[0] == 1 || pad2dev == 1) MouseSetPos(savedmousex, savedmousey);
                fadeinpending = 1;
                escrequest = 0;
                PaPreloadClips(teamabbrevs[HomeTeam], teamabbrevs[VisTeam]);
                DrawHudPanel(HomeTeam, VisTeam, curperiod, 0);
                rinkscrollx += 0x3E8;
                rinkscrolly += 0x3E8;
                if (ovlseq != -1 && ovlstep != -1 && !dword_E0244) {
                    MakePath(path, fileoncd[dword_CC080[ovlseq]] == 1 ? (char *)cddriveptr : 0,
                        (char *)off_CBED0[ovlseq], (char *)str_PPV);
                    dword_E0244 = sub_8E8A0(path, 0x20);
                    for (i = 0; i < sub_90354(dword_E0244); i++) dword_DEF8C[i] = sub_9035C(dword_E0244, i);
                }
                joysampling = joysampling_save;
                joyq_flush();
            }
            if (deferpending) {
                joysampling_save = joysampling;
                joysampling = 0;
                RunDeferredCalls();
                deferpending = 0;
                joysampling = joysampling_save;
                joyq_flush();
            }
        }
        joysampling = 0;
        if (demomode) {
            FadePalette(1, gamepal, 0x10);
            gameresult = 1;
            goto out;
        }
        PeriodOver();
        if (gameresult == 2) goto out;
        if (!gameover) {
            SelectScreenBM();
            PaPreloadClips(teamabbrevs[HomeTeam], teamabbrevs[VisTeam]);
            DrawHudPanel(HomeTeam, VisTeam, curperiod, 1);
            PlayCrowdSample(0);
        }
        if (pad1dev[0] == 1 || pad2dev == 1) MouseSetPos(0xA0, 0x64);
        lcrequest[1] = 0;
        lcrequest[0] = 0;
        deferpending = 0;
        inputframes = 0;
        exitgame = 0;
        frameaccum = 0;
        hudhundaccum = 0;
        joyq_flush();
    }
    joysampling = 0;
    FlushGSumQueue();
    StartThreeStars();
    PostGameDesk();
    gameresult = 1;
out:
    sub_1B982();
}
