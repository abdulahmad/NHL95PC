/* Gadgets / replay: the instant replay screen. */
/* DRAFT (10.0 GA, 88 -> 27 differing, same size): the saved crowd level, camera y, view y, camera x and view x
   declared in that order (ocl and ox take si / di, mode is homed with push eax); TicksSinceLastCall is a cdecl
   library call here (it clobbers the scratch registers, so the step zero before the loop is a fresh xor ebp).
   Left: the first rink redraw's y sum loads (ebx / eax swapped), the DrawFrameSprite zero pushed from the
   known-zero ebp (EXE push 0), the closing 1 kept in esi for FadePalette (EXE eax, reloaded), gadgetfile in ebp
   (EXE ebx) and the exit. See docs/UNSURE.md. It ends in DrawGadgetButton_ret, so its match belongs in
   DrawGadgetButton.c (a file whose only marked block is its own function, so the draft stays here). */
#define ReplayStep ReplayStep_decl
#define sub_6AF97 sub_6AF97_decl
#define sub_6B008 sub_6B008_decl
#define sub_6AF52 sub_6AF52_decl
#define sub_6ADA7 sub_6ADA7_decl
#define DrawRinkSideObjects DrawRinkSideObjects_decl
#define ReplayControlLoop ReplayControlLoop_decl
#define sub_B4CD8 sub_B4CD8_decl
#define replayplay replayplay_decl
#define TicksSinceLastCall TicksSinceLastCall_decl
#include "nhl95.h"
#undef ReplayStep
#undef sub_6AF97
#undef sub_6B008
#undef sub_6AF52
#undef sub_6ADA7
#undef DrawRinkSideObjects
#undef ReplayControlLoop
#undef sub_B4CD8
#undef replayplay
#undef TicksSinceLastCall

short ReplayStep(short n, short sound);
void sub_6AF97(int x, int y);
void sub_6B008(void);
void sub_6AF52(int x0, int y0, int x1, int y1);
void sub_6ADA7(void);
void DrawRinkSideObjects(short vx, short vy);
int ReplayControlLoop(int *step);
void __cdecl sub_B4CD8(int art, int x, int y);  /* graphics library: draw art (opaque) */
extern unsigned char *replayplay;  /* E03A4: the replay frame being played */
int __cdecl TicksSinceLastCall(void);

/* InstantReplay (7E0FA, PC only; ends in DrawGadgetButton_ret): the instant replay. The save button stays off
   (dword_ED6F8) in exhibition or without a human team. Show the control panel (GADGET6 / GADGET5 PPV, from the CD
   when listed; buttons 6 and 2 lit, the pointer at 100h, BCh), keep the camera, view, crowd level, rewind the
   replay to its first frame and draw it (DrawRinkSideObjects), fade the game palette in. Then each pass: the
   controls (ReplayControlLoop) give the step, the fraction kept in word_ED758 (twentieths), ReplayStep moves the
   replay (with sound when playing); the camera follows the chosen spot (dword_ED6F0 / ED6F4) or player
   (word_CD4FC), clamped, the rink is redrawn with the cursor on the spot or player (the pointer moved onto a
   newly picked player). On quit: stop the crowd noise and the replay sounds, restore the camera, view and crowd,
   fade the saved palette in, free the panel and, when mode is 0, restore the 640 x 480 screen. No result. */
void InstantReplay(int mode)
{
    char path[0x10];
    int step;
    short ocl;
    short ocy;
    short oy;
    short ocx;
    short ox;

    if (gamemode == 0 || ctl1team[0] < 0 && ctl2team < 0) dword_ED6F8 = 1;
    else dword_ED6F8 = 0;
    dword_ED754 = 0x44;
    dword_ED750 = 8;
    gadgetptrx = 0x100;
    gadgetptry = 0xBC;
    sub_B2E1B(0, 0, 0x140, 0xC1);
    MouseSetPos(gadgetptrx, gadgetptry);
    SelectScreenBM();
    sub_B4BC4(0, 0x140, 0, 0x20);
    if (dword_ED6F8)
        MakePath(path, fileoncd[0x223] == 1 ? (char *)cddriveptr : 0, (char *)str_Gadget6, (char *)str_PPV);
    else
        MakePath(path, fileoncd[0x96] == 1 ? (char *)cddriveptr : 0, (char *)str_Gadget5, (char *)str_PPV);
    gadgetfile = sub_8E8A0(path, 0);
    gadgetshape = sub_B30B4(gadgetfile, (char *)str_Gad1);
    sub_B4CD8(gadgetshape, 0, 0);
    DrawGadgetButton(6);
    DrawGadgetButton(2);
    sub_91370(pointerspr, gadgetptrx, gadgetptry - 0xA8);
    dword_C66D0 = dword_C66D4 = 1;
    ocx = camx;
    ocy = camy;
    ox = viewscrollx;
    oy = viewscrolly;
    ocl = crowdlevel;
    dword_ED70C = 0;
    word_CD4FC = -1;
    dword_ED6EC = dword_ED74C = -1;
    dword_ED6FC = 0;
    word_ED758 = 0;
    rinkscrollx += 0x3E8;
    rinkscrolly += 0x3E8;
    replayplay = ReplayFirstFrame();
    step = 0;
    ReplayStep(0, 0);
    crowdsmooth = crowdlevel;
    viewscrollx = camx + 0x20;
    if (viewscrollx > 0x40) viewscrollx = 0x40;
    if (viewscrollx < 0) viewscrollx = 0;
    viewscrolly = 0x140 - camy - 0x54;
    if (viewscrolly > 0x1A8) viewscrolly = 0x1A8;
    if (viewscrolly < 0) viewscrolly = 0;
    SelectRinkBM();
    sub_6AF97(0, 0);
    sub_6B008();
    SetRinkScroll(viewscrollx, viewscrolly);
    sub_6AF52(scrollx + (bgscrollx << 3), scrolly + (bgscrolly << 3), scrollx + (bgscrollx << 3) + 0x140,
        scrolly + (bgscrolly << 3) + 0xA8);
    spritedrawcount = 0;
    DrawRinkSideObjects(viewscrollx, viewscrolly);
    sub_6AF97(-((bgscrollx << 3) + scrollx), -(scrolly + (bgscrolly << 3)));
    sub_6ADA7();
    FadePalette(0, gamepal, 0x10);
    TicksSinceLastCall();
    ClearInputQueue();
    step = 0;
    for (;;) {
        SelectScreenBM();
        if (!ReplayControlLoop(&step)) break;
        word_ED758 += step * 6;
        step = word_ED758 / 0x14;
        word_ED758 = word_ED758 % 0x14;
        step = ReplayStep(step, (dword_ED754 & 0x3F) == 0x10);
        SelectRinkBM();
        if (dword_ED70C) {
            camx = dword_ED6F0;
            camy = dword_ED6F4;
            if (camx > 0x20) camx = 0x20;
            else if (camx < -0x20) camx = -0x20;
            if (camy > 0xEC) camy = 0xEC;
            else if (camy < -0xBC) camy = -0xBC;
            dword_ED6F0 = camx;
            dword_ED6F4 = camy;
        } else if (word_CD4FC >= 0) {
            camx = word_E9F18[word_CD4FC];
            camy = word_E9F3A[word_CD4FC];
            if (camx > 0x20) camx = 0x20;
            else if (camx < -0x20) camx = -0x20;
            if (camy > 0xEC) camy = 0xEC;
            else if (camy < -0xBC) camy = -0xBC;
        }
        viewscrollx = camx + 0x20;
        if (viewscrollx > 0x40) viewscrollx = 0x40;
        if (viewscrollx < 0) viewscrollx = 0;
        viewscrolly = 0x140 - camy - 0x54;
        if (viewscrolly > 0x1A8) viewscrolly = 0x1A8;
        if (viewscrolly < 0) viewscrolly = 0;
        sub_6AF97(0, 0);
        sub_6B008();
        SetRinkScroll(viewscrollx, viewscrolly);
        sub_6AF52((bgscrollx << 3) + scrollx, scrolly + (bgscrolly << 3), (bgscrollx << 3) + scrollx + 0x140,
            scrolly + (bgscrolly << 3) + 0xA8);
        spritedrawcount = 0;
        DrawRinkSideObjects(viewscrollx, viewscrolly);
        if (gadgetptry < 0xA8) {
            if (dword_ED74C == -1) {
                dword_ED6EC = dword_ED74C;
                dword_ED704 = camx + gadgetptrx - 0xA0;
                dword_ED708 = camy - gadgetptry + 0x54;
                DrawFrameSprite(0x188, (short)dword_ED704 + 1, (short)dword_ED708 + 1, 0, 0);
            } else {
                DrawFrameSprite(0x188, word_E9F18[dword_ED74C] + 1, word_E9F3A[dword_ED74C] + 1, 0, 1);
                if (dword_ED6EC != dword_ED74C) {
                    gadgetptrx = word_E9F18[dword_ED74C] - camx + 0xA0;
                    gadgetptry = camy - word_E9F3A[dword_ED74C] + 0x54;
                    if (gadgetptry > 0xA7) gadgetptry = 0xA7;
                    MouseSetPos(gadgetptrx, gadgetptry);
                    dword_ED6EC = dword_ED74C;
                }
            }
        }
        sub_6AF97(-((bgscrollx << 3) + scrollx), -(scrolly + (bgscrolly << 3)));
        sub_6ADA7();
        step = TicksSinceLastCall();
    }
    CrowdNoiseOff();
    replaysfx = lastsfx = -1;
    camx = ocx;
    camy = ocy;
    viewscrollx = ox;
    viewscrolly = oy;
    crowdlevel = ocl;
    crowdsmooth = ocl;
    dword_C66D0 = dword_C66D4 = 1;
    sub_8FFB0(0, 0x100, savepal);
    FadePalette(1, savepal, 0x10);
    FreeMemBlock(gadgetfile);
    sub_B4BA8();
    if (!mode) SetScreenSize(0x280, 0x1E0);
}
