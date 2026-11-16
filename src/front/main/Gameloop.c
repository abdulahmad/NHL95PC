/* Game save / IO: the in-game main loop. */
/* DRAFT (10.0 GA): 61 differing, 1685 vs 1678 bytes (own epilogue; the EXE jumps to HandleHotKey_ret, so a
   match belongs in HandleHotKey.c); no goto. Each exit is `FreeGameMemory(); return;` (Watcom merges the calls into
   one, and the period-end demo exit keeps its own `gameresult = 1` as in the EXE). The two `gameresult == 2`
   exits come out as `jne` over a `jmp` where the EXE has one `je` to the exit (a goto shape would give that).
   Left: the register cycle one step behind the EXE from frameaccum on (edi / ebp, ...), the Esc demomode test
   (the EXE loads it into edx and stores that known zero as joysampling = 0). See docs/UNSURE.md. */
#define ShapeBankCount sub_90354_decl
#define ShapeBankEntry sub_9035C_decl
#define TicksSinceLastCall TicksSinceLastCall_decl
#define SetZoneOrigin sub_6AF97_decl
#define BeginZoneFrame sub_6B008_decl
#define SetZoneScreen sub_6AF52_decl
#define DrawRinkOverlays DrawRinkOverlays_decl
#define Crowd_Noise CrowdNoiseUpdate_decl
#define UpdateHudPanel UpdateHudPanel_decl
#define FlushZones sub_6ADA7_decl
#define StartThreeStars StartThreeStars_decl
#define Gameloop GameLoop_decl
#include "nhl95.h"
#undef ShapeBankCount
#undef ShapeBankEntry
#undef TicksSinceLastCall
#undef SetZoneOrigin
#undef BeginZoneFrame
#undef SetZoneScreen
#undef DrawRinkOverlays
#undef Crowd_Noise
#undef UpdateHudPanel
#undef FlushZones
#undef StartThreeStars
#undef Gameloop

int __cdecl ShapeBankCount(int bank);
int __cdecl ShapeBankEntry(int bank, int n);
void TicksSinceLastCall(void);
void SetZoneOrigin(int x, int y);
void BeginZoneFrame(void);
void SetZoneScreen(int x, int y, int x2, int y2);
void DrawRinkOverlays(short x, short y);
void Crowd_Noise(short n);
void UpdateHudPanel(void);
void FlushZones(void);
void StartThreeStars(void);

/* Gameloop (1167B, PC only): run the game until it ends. Each pass (joystick sampling on) while the period
   runs: turn the input ticks into frames (6 per tick, in tenths through frameaccum) and run them, scroll the
   rink view after the camera (clamped to 0..40h / 0..1A8h), draw the rink and its overlays, fade in after a
   desk visit, update the crowd noise and the HUD clock (hundredths; at the period end the clock's own time),
   draw the HUD panel and sprites. Esc (escrequest) goes to the sports desk (in demo mode it fades and ends with
   result 2) and back: screen size, mouse, HUD panel, the overlay's PPV art and the play-by-play clips. Deferred
   calls run between frames. At the period end (exitgame): in demo mode fade and end with result 1, else
   PeriodOver (result 2 ends) and, if the game goes on, redraw the HUD for the next period, centre the mouse
   and reset the period state. When the game is over: the three stars, the post-game desk and result 1. Then
   FreeGameMemory. No arguments, no result. */
void Gameloop(void)
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
            SetZoneOrigin(0, 0);
            BeginZoneFrame();
            SetRinkScroll(viewscrollx, viewscrolly);
            SetZoneScreen(scrollx + bgscrollx * 8, scrolly + bgscrolly * 8, scrollx + bgscrollx * 8 + 0x140,
                scrolly + bgscrolly * 8 + 0xA8);
            spritedrawcount = 0;
            DrawRinkOverlays(viewscrollx, viewscrolly);
            if (fadeinpending) {
                joysampling_save = joysampling;
                joysampling = 0;
                SetPalette(0, 0x100, savepal);
                FadePalette(1, savepal, 0x10);
                FlushGSumQueue();
                joysampling = joysampling_save;
            }
            Crowd_Noise(n);
            if (penshotlive) {
                hudhundstep = 0;
            } else {
                hudhundstep = hudhundaccum / 0x18;
                hudhundaccum %= 0x18;
                if (exitgame && !(gameclock | clockticks[0]))
                    hudhundstep = hudclockhund + (hudclockmin * 60 + hudclocksec) * 100;
            }
            UpdateHudPanel();
            SetZoneOrigin(-(scrollx + bgscrollx * 8), -(bgscrolly * 8 + scrolly));
            FlushZones();
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
                    FreeGameMemory();
                    return;
                }
                joysampling_save = joysampling;
                joysampling = 0;
                if (pad1dev[0] == 1 || pad2dev == 1) {
                    savedmousex = mousex;
                    savedmousey = mousey;
                }
                CrowdFadeOut();
                if (musicon) MusicChanReset();
                else ReleaseAllVoices();
                StopDigiSample();
                SpeechStopQueue();
                FlushGSumQueue();
                TextSetFont(s1font);
                SetPalette(0, 0x100, savepal);
                FadePalette(1, savepal, 0x10);
                SetScreenSize(0x280, 0x1E0);
                SportsDesk(0);
                if (gameresult == 2) {
                    FreeGameMemory();
                    return;
                }
                SetScreenSize(0x140, 0xC8);
                if (pad1dev[0] == 1 || pad2dev == 1) MouseSetPos(savedmousex, savedmousey);
                fadeinpending = 1;
                escrequest = 0;
                PaPreloadClips(teamabbrevs[HomeTeam], teamabbrevs[VisTeam]);
                DrawHudPanel(HomeTeam, VisTeam, curperiod, 0);
                rinkscrollx += 0x3E8;
                rinkscrolly += 0x3E8;
                if (ovlseq != -1 && ovlstep != -1 && !ovlartbank) {
                    MakePath(path, fileoncd[ovlartfiles[ovlseq]] == 1 ? (char *)cddriveptr : 0,
                        (char *)ovlartnames[ovlseq], (char *)str_PPV);
                    ovlartbank = OpenArtArchiveErr(path, 0x20);
                    for (i = 0; i < ShapeBankCount(ovlartbank); i++) ovlstepart[i] = ShapeBankEntry(ovlartbank, i);
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
            FreeGameMemory();
            return;
        }
        PeriodOver();
        if (gameresult == 2) {
                    FreeGameMemory();
                    return;
                }
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
    FreeGameMemory();
}
