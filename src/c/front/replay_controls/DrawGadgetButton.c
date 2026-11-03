/* Gadgets replay: gadget button frame, the instant replay screen and its control panel; the highlight "Save To"
   box (segment 058) also ends in DrawGadgetButton's exit. Functions in address order (InstantReplay,
   ReplayControlLoop and HilightSaveToDlg end in DrawGadgetButton_ret). */
#define bothneitherstrs bothneitherstrs_fn
#define HilightSaveToDlg HilightSaveToDlg_decl
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
#define sub_B500C sub_B500C_decl
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
#undef sub_B500C
#undef bothneitherstrs
#undef HilightSaveToDlg

extern unsigned char bothneitherstrs[];  /* 7E05F: two string pointers in the code segment (Both Teams, Neither Team) */

/* DrawGadgetButton: draw the frame of replay gadget n (gadgetrects: 7 dwords per gadget, x0, y0,
 x1, y1; y made relative to the panel at A8h): top and left edges in colour 10h, right and bottom in 15h. */
void DrawGadgetButton(int n)
{
    int x0;
    int y0;
    int x1;
    int y1;

    n *= 7;
    x0 = gadgetrects[n];
    y0 = gadgetrect_y0[n] - 0xA8;
    x1 = gadgetrect_x1[n];
    y1 = gadgetrect_y1[n] - 0xA8;
    sub_B4FAC(x0, y0, x1, y0, 0x10);
    sub_B4FAC(x0, y0, x0, y1, 0x10);
    sub_B4FAC(x1, y0, x1, y1, 0x15);
    sub_B4FAC(x0, y1, x1, y1, 0x15);
}

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
/* DRAFT (10.0 GA, 22 differing here, same size): the saved crowd level, camera y, view y, camera x and view x
   declared in that order (ocl and ox take si / di, mode is homed with push eax); TicksSinceLastCall is a cdecl
   library call here (it clobbers the scratch registers, so the step zero before the loop is a fresh xor ebp).
   Left: the first rink redraw's y sum loads (ebx / eax swapped), the DrawFrameSprite zero pushed from the
   known-zero ebp (EXE push 0), the closing 1 kept in esi for FadePalette (EXE eax, reloaded), gadgetfile in ebp
   (EXE ebx). See docs/UNSURE.md. */
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

void __cdecl sub_B500C(int art, int x, int y);  /* graphics library: draw art */
void ReplaySaveHilight(int unused, int x, int y);

/* ReplayControlLoop (7E9AC, PC only; ends in DrawGadgetButton_ret): one pass of the replay controls. Read the
   pointer events (the pointer kept on the 320 x 200 screen) until a click; a press arms the buttons (dword_ED6FC),
   a release disarms them. An armed click on a gadget (GadgetHitTest; 7 not while dword_ED6F8) gives its bit; the
   pointer over the rink (above A8h) gives the rink point (dword_ED704 / ED708). Buttons: 1 / 20h rewind / fast
   forward (*step times -4 / 4), 2 / 8 step back / forward (every fifth call with the step, -1 / 1), 4 pause, 10h
   play (*step), 40h camera back to the puck, 80h save (ReplaySaveHilight after the redraw), 100h quit (result 0).
   A click on the rink picks the nearest player (PickNearestPlayer) or a free spot for the camera, moving the
   pointer to it (MouseSetPos). Then, when the pointer or the buttons changed, redraw the panel (gadgetshape, the
   lit buttons, the pointer). *step: the replay speed, set to the frames to move. Result: 1, 0 to quit. */
/* Matched under 10.0 GA here (after DrawGadgetButton, whose exit it ends in): the free-spot branch writes
   dword_ED6EC = -1 as a constant (the EXE still stores the eax it knows holds -1, and the constant takes the
   register slot that puts the pointer clamps in edi / ecx), and the camera button clears dword_ED70C and d in two
   statements (found by tools/permute.py; the chained `dword_ED70C = d = 0` put the step-forward zero in eax and
   the -1 chain in edx). */
int ReplayControlLoop(int *step)
{
    int hit;
    int oldbits;
    int oldx;
    int ev;
    int d;
    int oldy;
    unsigned char *e;
    int b;
    int a;
    int y1;
    int x1;

    d = 0;
    oldbits = dword_ED754;
    oldx = gadgetptrx;
    oldy = gadgetptry;
    ev = d;
    while ((e = GetInputEvent()) != 0) {
        ev = ((int (*)(unsigned char *, int *, int *))ptrupdatefn)(e, &gadgetptrx, &gadgetptry);
        if (gadgetptrx >= 0x140) gadgetptrx = 0x13F;
        if (gadgetptry >= 0xC8) gadgetptry = 0xC7;
        if (ev & 2) break;
    }
    if ((unsigned char)ev & 1) dword_ED6FC = 1;
    else if ((unsigned char)ev & 2) dword_ED6FC = 0;
    if (dword_ED6FC) {
        if (!GadgetHitTest(gadgetptrx, gadgetptry, &hit) || dword_ED6F8 && hit == 7) hit = 0;
        else hit = 1 << hit;
    } else {
        hit = 0;
    }
    if (gadgetptry < 0xA8) {
        dword_ED704 = camx + gadgetptrx - 0xA0;
        dword_ED708 = camy - gadgetptry + 0x54;
    }
    a = dword_ED754 & 0x54;
    b = dword_ED754 & 0x40;
    switch ((unsigned)hit) {
    case 4:
        dword_ED754 = b | 4;
        d = 0;
        break;
    case 0x10:
        if ((dword_ED754 & 0x3F) != 0x10) word_ED758 = 0;
        dword_ED754 = dword_ED754 & 0x40 | 0x10;
        d = *step;
        break;
    case 1:
        dword_ED754 = a | 1;
        d = -(*step << 2);
        break;
    case 0x20:
        dword_ED754 = a | 0x20;
        d = *step << 2;
        break;
    case 2:
        if (dword_ED754 & 2) {
            dword_ED6E8 += *step;
            if (dword_ED6E8 < 5) {
                d = 0;
            } else {
                d = -1;
                dword_ED6E8 -= 5;
            }
        } else {
            dword_ED6E8 = 0;
            d = -1;
            word_ED758 = -0xE;
        }
        dword_ED754 = dword_ED754 & 0x40 | 6;
        break;
    case 8:
        if (dword_ED754 & 8) {
            dword_ED6E8 += *step;
            if (dword_ED6E8 < 5) {
                d = 0;
            } else {
                d = 1;
                dword_ED6E8 -= 5;
            }
        } else {
            dword_ED6E8 = 0;
            d = 1;
            word_ED758 = 0xE;
        }
        dword_ED754 = dword_ED754 & 0x40 | 0xC;
        break;
    case 0x40:
        dword_ED754 |= 0x40;
        dword_ED70C = 0;
        d = 0;
        dword_ED6EC = dword_ED74C = -1;
        word_CD4FC = -1;
        break;
    case 0x80:
        dword_ED754 = b | 0x84;
        break;
    case 0x100:
        return 0;
    default:
        if (gadgetptry < 0xA8) {
            dword_ED74C = PickNearestPlayer(dword_ED704, dword_ED708);
            if (ev & 2) {
                if (dword_ED74C == -1) {
                    dword_ED70C = 1;
                    dword_ED6EC = -1;
                    word_CD4FC = -1;
                    dword_ED6F0 = dword_ED704;
                    dword_ED6F4 = dword_ED708;
                    gadgetptrx = dword_ED6F0;
                    gadgetptry = dword_ED6F4;
                    if (gadgetptrx > 0x20) gadgetptrx = 0x20;
                    else if (gadgetptrx < -0x20) gadgetptrx = -0x20;
                    if (gadgetptry > 0xEC) gadgetptry = 0xEC;
                    else if (gadgetptry < -0xBC) gadgetptry = -0xBC;
                    gadgetptrx = dword_ED6F0 - gadgetptrx + 0xA0;
                    gadgetptry = gadgetptry - dword_ED6F4 + 0x54;
                    if (gadgetptry > 0xA7) gadgetptry = 0xA7;
                    MouseSetPos(gadgetptrx, gadgetptry);
                } else {
                    dword_ED70C = 0;
                    word_CD4FC = dword_ED74C;
                    gadgetptrx = word_E9F18[dword_ED74C];
                    gadgetptry = word_E9F3A[dword_ED74C];
                    if (gadgetptrx > 0x20) gadgetptrx = 0x20;
                    else if (gadgetptrx < -0x20) gadgetptrx = -0x20;
                    if (gadgetptry > 0xEC) gadgetptry = 0xEC;
                    else if (gadgetptry < -0xBC) gadgetptry = -0xBC;
                    gadgetptrx = word_E9F18[dword_ED74C] - gadgetptrx + 0xA0;
                    gadgetptry = gadgetptry - word_E9F3A[dword_ED74C] + 0x54;
                    if (gadgetptry > 0xA7) gadgetptry = 0xA7;
                    MouseSetPos(gadgetptrx, gadgetptry);
                    dword_ED6EC = dword_ED74C;
                }
                dword_ED754 &= 0x14;
            }
        }
        dword_ED754 &= 0x54;
        if (dword_ED754 & 0x10) d = *step;
        else d = 0;
        break;
    }
    if (oldx != gadgetptrx || oldy != gadgetptry || oldbits != dword_ED754) {
        if (oldbits == dword_ED754) {
            x1 = ((short *)pointerspr)[2] + oldx;
            oldy -= 0xA8;
            y1 = ((short *)pointerspr)[3] + oldy;
            if (oldx < 0) oldx = 0;
            else if (oldx > 0x140) oldx = 0x140;
            if (oldy < 0) oldy = 0;
            else if (oldy > 0x20) oldy = 0x20;
            if (x1 < 0) x1 = 0;
            else if (x1 > 0x140) x1 = 0x140;
            if (y1 < 0) y1 = 0;
            else if (y1 > 0x20) y1 = 0x20;
            sub_B4BC4(oldx, x1, oldy, y1);
        }
        sub_B500C(gadgetshape, 0, 0);
        if (oldbits == dword_ED754) sub_B4BC4(0, 0x140, 0, 0x20);
        for (hit = 0; hit < 9; hit++) {
            if (dword_ED754 & 1 << hit) DrawGadgetButton(hit);
        }
        if (gadgetptry >= 0xA8) sub_91370(pointerspr, gadgetptrx, gadgetptry - 0xA8);
    }
    if (dword_ED754 & 0x80) {
        dword_ED6FC = 0;
        ReplaySaveHilight(0, gadgetptrx, gadgetptry);
        ClearInputQueue();
        dword_ED754 = 4;
        SelectScreenBM();
        sub_B4BC4(0, 0x140, 0, 0x20);
        sub_B4CD8(gadgetshape, 0, 0);
        DrawGadgetButton(2);
        sub_91370(pointerspr, gadgetptrx, gadgetptry - 0xA8);
    }
    *step = d;
    return 1;
}

typedef struct { char *s[2]; } StrPair;

/* HilightSaveToDlg (7F724, PC only; highlights segment 058, the same source file: it ends in
   DrawGadgetButton_ret): draw the "Save To" box of the highlight saver: save the text state (sub_8E9E8), the
   highlight font, the box (sub_90D20, two sub_93000 frames), four choice buttons (bevelled 8Ah x 0Eh boxes, 11h
   apart from 4Eh, 50h), then "Save To", "Hilights Reel" and the choices (home and away team names from the team
   records, then "Both Teams" / "Neither Team" from bothneitherstrs) centred in the buttons, first in colour 10h
   one pixel down and right as the shadow, then in 59h. No arguments, no result.
   Its exit is DrawGadgetButton's (DrawGadgetButton_ret), so it sits in this file after it. */
void HilightSaveToDlg(void)
{
    char state[0x40];
    StrPair both;
    int y2;
    int x2;
    int x;
    int y;
    struct { int i; } count;

    both = *(StrPair *)bothneitherstrs;
    sub_8E9E8(state);
    sub_8EA18(hilightfont);
    sub_90D20(0, 0x4B, 0x140, 0x4C, 0x14);
    sub_93000(1, 0x4C, 0x13E, 0x95, 9);
    sub_93000(2, 0x4D, 0x13D, 0x96, 0x10);
    x = 0x4E;
    y = 0x50;
    for (count.i = 0; count.i < 4; count.i++, y += 0x11) {
        sub_B4FAC(x, y, x, y2 = y + 0xE, 0x59);
        sub_B4FAC(x, y, x2 = x + 0x8A, y, 0x59);
        sub_B4FAC(x + 1, y2, x2, y2, 0x10);
        sub_B4FAC(x2, y + 1, x2, y2, 0x10);
        sub_B5DB0(x2, y, 0x13);
        sub_B5DB0(x, y2, 0x13);
    }
    fontcolor = 0x10;
    sub_91964((char *)str_SaveTo, 0xE, 0x6D);
    sub_91964((char *)str_HilightsReel, 0xDF, 0x6D);
    sub_91964((char *)hmteamrec + 5, (0x85 - fputchar((char *)hmteamrec + 5)) / 2 + 0x52, 0x54);
    sub_91964((char *)awteamrec + 5, (0x85 - fputchar((char *)awteamrec + 5)) / 2 + 0x52, 0x65);
    sub_91964(both.s[0], (0x85 - fputchar(both.s[0])) / 2 + 0x52, 0x76);
    sub_91964(both.s[1], (0x85 - fputchar(both.s[1])) / 2 + 0x52, 0x87);
    fontcolor = 0x59;
    sub_91964((char *)str_SaveTo, 0xD, 0x6C);
    sub_91964((char *)str_HilightsReel, 0xDE, 0x6C);
    sub_91964((char *)hmteamrec + 5, (0x85 - fputchar((char *)hmteamrec + 5)) / 2 + 0x51, 0x53);
    sub_91964((char *)awteamrec + 5, (0x85 - fputchar((char *)awteamrec + 5)) / 2 + 0x51, 0x64);
    sub_91964(both.s[0], (0x85 - fputchar(both.s[0])) / 2 + 0x51, 0x75);
    sub_91964(both.s[1], (0x85 - fputchar(both.s[1])) / 2 + 0x51, 0x86);
}
