/* Engine init: loading screen. */
#define ThreeStarsLoop ThreeStarsLoop_decl
#include "nhl95.h"
#undef ThreeStarsLoop

int ThreeStarsLoop(void);
#define REF ((Player *)puckstruct + 2)   /* the referee (E001C) */

/* FadeOutPalCycle: end the loading screen palette cycle: step all 3 loadpals palettes down to black (one level
 per 2 ticks, the cycle locked while changing them), then remove the LoadScreenPalTick timer and clear
 loadscreenon. */
void FadeOutPalCycle(void)
{
    int done;
    int i;
    int j;

    if (!loadscreenon) return;
    done = 0;
    while (!done) {
        palcyclelock = done = 1;
        for (i = 0; i < 3; i++) {
            for (j = 0; j < 0x300; j++) {
                if ((signed char)loadpals[i * 0x300 + j] > 0) {
                    loadpals[i * 0x300 + j]--;
                    if (done == 1) done = 0;
                }
            }
        }
        palcyclelock = 0;
        SetTickDeadline(2);
        WaitTickDeadline();
    }
    palcyclelock = 1;
    RemoveTimerCallback(LoadScreenPalTick);
    loadscreenon = 0;
}

/* DRAFT (first pass from Ghidra): the EXE has ThreeStarsLoop's frame loop and exit (PreGameIntro_scroll ..
   PreGameIntro_popx) right after this function and ends it with a jump to those pops. */
/* PreGameIntro (47CD6, PC only): set up the pre-game skate: the crowd sample, the home team's power play colours
   (LoadTeamPPV), the text lines, period, seed (mixed with both teams), the 1800-tick sequence timer and no
   controlled players; both teams' energy, lines and players (reenergizeteam, setpersonel, forcepldata); then the
   six players of each team (walking down from unk_DFD9C): the ones not dressed (position 0) stand at the centre
   line facing their end, the others skate in from five random lanes by their side, all with the skate-in
   assignment (25h); the puck held at the boards (1Ah) and the referee at centre ice (26h). Two game frames and a
   sprite sort, the camera and view at the start, the text overlay closed and the HUD panel redrawn. No arguments
   and no result. */
void PreGameIntro(void)
{
    short side;
    short i;
    short y;
    short lane;
    short v;
    short team;
    char used[5];
    Player *p;

    PlayCrowdSample(0xA);
    team = byte_CC9B0[HomeTeam];
    y = word_CC9CC[byte_CC9B0[HomeTeam]];
    LoadTeamPPV((team != 1) + 3);
    textline5 = 0;
    textline4 = 0;
    textline2 = 0;
    textline1 = 0;
    textline3 = 0;
    curperiod = -1;
    *(int *)&fox = 0;
    seed[0] += VisTeam + (HomeTeam << 16);
    shownumbers = 0;
    seqtimer = 0x708;
    exitgame = 0;
    c2playernum[0] = -1;
    c1playernum[0] = -1;
    reenergizeteam(&hmtmstruct);
    setpersonel(&hmtmstruct);
    forcepldata(&hmtmstruct);
    reenergizeteam(&awtmstruct);
    setpersonel(&awtmstruct);
    forcepldata(&awtmstruct);
    resetplstuff();
    p = (Player *)unk_DFD9C;
    for (side = 0; side < 2; side++) {
        for (i = 0; i < 5; i++) used[i] = 0;
        for (i = 0; i < 6; i++) {
            if (p->position == 0) {
                HIWORD(p->Xpos) = 0;
                p->temp3 = 0;
                v = (p->pflags & 0x80) ? -0xDC : 0xDC;
                HIWORD(p->Ypos) = v;
                p->temp4 = v;
                p->temp5 = -0x64;
                p->Yvel = 0;
                p->Xvel = p->Yvel;
                p->facedir = (p->pflags & 0x80) ? 0 : 4;
                SetSPA(p, 0x99);
            } else {
                lane = randomd0(5);
                while (used[lane]) lane = (lane + 1) % 5;
                used[lane] = 1;
                v = lane * 0x28 + randomd0(8) - 0x54;
                HIWORD(p->Xpos) = v;
                p->temp3 = v;
                HIWORD(p->Xpos) += randomd0(2);
                v = ((p->pflags & 0x80) ? -0x3A : 0x30) + randomd0(4) - 2;
                HIWORD(p->Ypos) = v;
                p->temp4 = v;
                p->facedir = 4;
                p->Yvel = 0;
                p->Xvel = p->Yvel;
                p->temp5 = y + randomd0(0x28) - 0x14;
                SetSPA(p, 0);
                p->frame = 0x171;
            }
            assreplace(p, 0x25);
            p--;
        }
    }
    ((Player *)puckstruct)->temp2 = 0x78;
    HIWORD(((Player *)puckstruct)->Xpos) = 200;
    HIWORD(((Player *)puckstruct)->Ypos) = -0x12C;
    ((Player *)puckstruct)->Xvel = 0;
    ((Player *)puckstruct)->Yvel = 0;
    assreplace((Player *)puckstruct, 0x1A);
    word_E0042 = team;
    HIWORD((REF)->Xpos) = 0x8E;
    word_E0046 = 0x8E;
    HIWORD((REF)->Xpos) += randomd0(2);
    HIWORD((REF)->Ypos) = 0;
    word_E0048 = 0;
    (REF)->facedir = 4;
    word_E002A = 0;
    word_E0028 = 0;
    word_E004A = y;
    SetSPA(REF, 0);
    word_E002E = 0x289;
    assreplace(REF, 0x26);
    RefStep[0] = 0;
    sflags |= 0x40;
    DoGameFrame();
    DoGameFrame();
    SprSort();
    frameaccum = 0;
    inputframes = 0;
    *(unsigned char *)puckc = 0xFF;
    joysampling = 0;
    joyq_flush();
    camx = 0;
    xc1 = 0;
    camy = 0;
    yc1 = 0;
    viewscrollx = 0x20;
    viewscrolly = 0xEC;
    if (ovlseq != -1) CloseTextOverlay();
    SelectScreenBM();
    lcblink[1] = 0;
    lcblink[0] = 0;
    energywarn[1] = 0;
    energywarn[0] = 0;
    UpdateHudPanel();
}

/* DRAFT (first pass from Ghidra): the EXE places its entry and frame start (to ThreeStarsLoop_tick) after
   StartPreGame, which falls into it, and its frame loop and exit after PreGameIntro (pieces of ThreeStarsLoop:
   PreGameIntro_scroll PreGameIntro_end). */
/* ThreeStarsLoop (48333, PC only): run the pre-game skate until the sequence timer (seqtimer) runs out, Escape
   (escrequest) or a button (fire 10h / 20h on either pad: skip, with a palette fade): each 4-tick frame run the
   game frames due (6 per 10 input samples), follow the camera with the view (clamped to 0-40h, 0-1A8h), draw
   the rink and its overlays, fade the palette in once (fadeinpending) and update the crowd. At the end free the
   overlay sequence, fade out on Escape (and stop the crowd) or on a skip, and stop the sound and speech.
   Result: -1 after Escape, else 0. */
int ThreeStarsLoop(void)
{
    short n;
    int a;
    int js;

    TicksSinceLastCall();
    joysampling = 1;
    escrequest = 0;
    rinkscrollx += 0x3E8;
    rinkscrolly += 0x3E8;
    while (seqtimer != 0) {
        SetTickDeadline(4);
        a = frameaccum + ResetInputSampling() * 6;
        frameaccum = a % 10;
        n = a / 10;
        RunGameFrames(n);
        seqtimer -= n;
        if (seqtimer < 0) seqtimer = 0;
        viewscrollx = camx + 0x20;
        viewscrolly = 0xEC - camy;
        if (viewscrollx > 0x40) viewscrollx = 0x40;
        else if (viewscrollx < 0) viewscrollx = 0;
        if (viewscrolly > 0x1A8) viewscrolly = 0x1A8;
        else if (viewscrolly < 0) viewscrolly = 0;
        sub_6AF97(0, 0);
        sub_6B008();
        SetRinkScroll(viewscrollx, viewscrolly);
        sub_6AF52(bgscrollx * 8 + scrollx, bgscrolly * 8 + scrolly, bgscrollx * 8 + scrollx + 0x140, bgscrolly * 8 + scrolly + 0xA8);
        spritedrawcount = 0;
        DrawRinkOverlays(viewscrollx, viewscrolly);
        sub_6AF97(-(scrollx + bgscrollx * 8), -(bgscrolly * 8 + scrolly));
        sub_6ADA7();
        if (fadeinpending) {
            js = joysampling;
            joysampling = 0;
            FadePalette(0, gamepal, 0x10);
            fadeinpending = 0;
            joysampling = js;
        }
        CrowdNoiseUpdate(n);
        if (escrequest) break;
        Readjoy1();
        if (*(unsigned char *)&regd1 & 0x30) {
            introskipped = 1;
            fadeinpending = 1;
            break;
        }
        Readjoy2();
        if (*(unsigned char *)&regd1 & 0x30) {
            introskipped = 1;
            fadeinpending = 1;
            break;
        }
        WaitTickDeadline();
    }
    joysampling = 0;
    if (ovlseq != -1) {
        FreeMemBlock(dword_E0244);
        ovlseq = -1;
    }
    if (escrequest) {
        sub_8FFB0(0, 0x100, savepal);
        FadePalette(1, savepal, 0x10);
        CrowdFadeOut();
        StopDigiSample();
        SpeechStopQueue();
        escrequest = 0;
        return -1;
    }
    if (introskipped) {
        sub_8FFB0(0, 0x100, savepal);
        FadePalette(1, savepal, 0x10);
    }
    StopDigiSample();
    SpeechStopQueue();
    return 0;
}

/* StartPreGame (4830E, PC only): start the game's pre-game skate unless dword_CC0EC is set (then result 0): the
   intro set-up (PreGameIntro) unless skip, the crowd noise reset, then the skate itself (ThreeStarsLoop, which it
   falls into). skip: leave the set-up out. Result: ThreeStarsLoop's. */
int StartPreGame(int skip)
{
    if (dword_CC0EC) return 0;
    if (!(short)skip) PreGameIntro();
    CrowdNoiseReset();
    return ThreeStarsLoop();
}

