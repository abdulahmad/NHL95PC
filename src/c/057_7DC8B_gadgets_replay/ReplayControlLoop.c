/* Gadgets / replay: one pass of the replay control panel. */
/* DRAFT (10.0 GA, 16 differing): the free-spot branch writes dword_ED6EC = -1 as a constant (the EXE still
   stores the eax it knows holds -1, and the constant takes the register slot that puts the pointer clamps in
   edi / ecx). Left: the step-forward else clears dword_ED6E8 through eax (EXE edi, d's register), the camera
   button -1 chain goes through edx (EXE eax), and the own-file pop / ret tail; see docs/UNSURE.md. It ends in
   DrawGadgetButton_ret, so its match belongs in DrawGadgetButton.c (a file whose only marked block is its own
   function, so the draft stays here). */
#define ReplayControlLoop ReplayControlLoop_decl
#define sub_B500C sub_B500C_decl
#define sub_B4CD8 sub_B4CD8_decl
#include "nhl95.h"
#undef ReplayControlLoop
#undef sub_B500C
#undef sub_B4CD8

int ReplayControlLoop(int *step);
void __cdecl sub_B500C(int art, int x, int y);  /* graphics library: draw art */
void __cdecl sub_B4CD8(int art, int x, int y);  /* graphics library: draw art (opaque) */
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
        dword_ED70C = d = 0;
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
