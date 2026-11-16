/* Gadgets / replay: save the replay as a highlight. */
/* DRAFT: same size (1,653 bytes), every statement in place; register picks of the pushed globals' temporaries
   differ (the zero for r outside the rows takes ebx where the EXE has eax). See docs/UNSURE.md. */
#define ReplaySaveHilight ReplaySaveHilight_decl
#define sub_B500C sub_B500C_decl
#include "nhl95.h"
#undef ReplaySaveHilight
#undef sub_B500C
void __cdecl sub_B500C(int art, int x, int y);  /* graphics library: draw art */
void ReplaySaveHilight(int unused, int x, int y);  /* the caller passes 0, gadgetptrx, gadgetptry */

typedef struct Hdr17 { char c[17]; } Hdr17;

/* ReplaySaveHilight (7F0AF, PC only): save the replay as a highlight. With one controller team (or both the same)
   it saves straight to that team's slot list (SaveHilight 0 home, 1 away; "no room" box on failure). Else the
   save-to dialog: the gadget panel and button 7 redrawn, a pointer save buffer the size of the pointer
   (POINTER19), HilightSaveToDlg, the pointer at (EEh, 8Ah) in a 4Bh..96h window; a click inside x 4Eh-D8h on one
   of the four rows (y 50h-5Eh, 61h-6Fh, 72h-80h, 83h-91h) picks hilightslot = 0-3 and ends the loop. The row
   gets a bevel frame, then 0: home, 1: away, 2: home else away (SaveHilight), 3: cancel. A failed save shows
   the "no room" box and reloads the gadget art (GADGET6 / GAD1). Last the rink scroll is nudged, the pointer goes
   back to (x, y) and a failure is reported once more (box at -1, -1), the pointer buffer freed and the full screen
   view restored. The first argument is unused. No result. */
void ReplaySaveHilight(int unused, int x, int y)
{
    char st[0x40];
    char path[0x20];
    int r;
    unsigned char *p;
    int ox;
    int oy;
    unsigned char *ev;
    int n;
    int w;

    SetScreenTarget();
    if (ctl1team[0] < 0 || ctl2team < 0 || ctl1team[0] == ctl2team) {
        SetTickDeadline(0x64);
        if (ctl1team[0] >= 0) r = SaveHilight(HomeTeam == ctl1team[0] ? HomeTeam ^ ctl1team[0] : 1);
        else r = SaveHilight(HomeTeam == ctl2team ? HomeTeam ^ ctl2team : 1);
        if (r) {
            TextSaveState(st);
            TextSetFont(mainfont);
            SetTickDeadline(0x1F4);
            SetDialogColors(0x14, 0x59, 0x11, 0x59, 0);
            MessageBox(0, 0, (char *)msg_NoHilightSpace, 3, 0, 0, 0, 0, 0);
            TextRestoreState(st);
            FreeMemBlock(gadgetfile);
            MakePath(path, fileoncd[0x223] == 1 ? (char *)cddriveptr : 0, (char *)str_Gadget6, (char *)str_PPV);
            gadgetfile = sub_8E8A0(path, 0);
            gadgetshape = FindShape(gadgetfile, (char *)str_Gad1);
            WaitTickDeadline();
            RestoreDialogBg();
        } else {
            WaitTickDeadline();
        }
        return;
    }
    SelectScreenBM();
    SetClipWindow(0xC2, 0xF0, 0, 0x20);
    sub_B500C(gadgetshape, 0, 0);
    DrawGadgetButton(7);
    SetScreenTarget();
    SetClipWindow(0, 0x140, 0, 0xC8);
    w = ((short *)pointerspr)[2];
    w *= ((short *)pointerspr)[3];
    n = w + 0x11;
    p = (unsigned char *)AllocMemBlock((char *)str_Pointer19, n, 0x20);
    *(Hdr17 *)p = *(Hdr17 *)pointerspr;
    ((short *)p)[2] = ((short *)pointerspr)[2];
    ((short *)p)[3] = ((short *)pointerspr)[3];
    HilightSaveToDlg();
    hilightslot = 3;
    gadgetptrx = 0xEE;
    gadgetptry = 0x8A;
    SetViewRect(0, 0x4B, 0x136, 0x96);
    MouseSetPos(0xEE, 0x8A);
    GrabBlock((int)p, 0xEE, 0x8A);
    DrawArt(pointerspr, 0xEE, 0x8A);
    ClearInputQueue();
    r = 0;
    while (!(r & 2)) {
        while (!(ev = GetInputEvent()));
        ox = gadgetptrx;
        oy = gadgetptry;
        r = ((int (*)(unsigned char *, int *, int *))ptrupdatefn)(ev, &gadgetptrx, &gadgetptry);
        if (r & 2) {
            if (!(gadgetptrx < 0x4E || gadgetptrx > 0xD8)) {
                if (gadgetptry >= 0x50 && gadgetptry <= 0x5E) hilightslot = 0;
                else if (gadgetptry >= 0x61 && gadgetptry <= 0x6F) hilightslot = 1;
                else if (gadgetptry >= 0x72 && gadgetptry <= 0x80) hilightslot = 2;
                else if (gadgetptry >= 0x83 && gadgetptry <= 0x91) hilightslot = 3;
                else r = 0;
            } else {
                r = 0;
            }
        }
        DrawArt((int)p, ox, oy);
        GrabBlock((int)p, gadgetptrx, gadgetptry);
        DrawArt(pointerspr, gadgetptrx, gadgetptry);
    }
    SetTickDeadline(0x64);
    SetClipWindow(0, 0x140, 0, 0xC8);
    FillRectColor(0x4E, hilightslot * 0x11 + 0x50, 0x4E, hilightslot * 0x11 + 0x5E, 0x10);
    FillRectColor(0x4E, hilightslot * 0x11 + 0x50, 0xD8, hilightslot * 0x11 + 0x50, 0x10);
    FillRectColor(0x4F, hilightslot * 0x11 + 0x5E, 0xD8, hilightslot * 0x11 + 0x5E, 0x59);
    FillRectColor(0xD8, hilightslot * 0x11 + 0x51, 0xD8, hilightslot * 0x11 + 0x5E, 0x59);
    PlotPixel(0xD8, hilightslot * 0x11 + 0x50, 0x13);
    PlotPixel(0x4E, hilightslot * 0x11 + 0x5E, 0x13);
    DrawArt(pointerspr, gadgetptrx, gadgetptry);
    switch (hilightslot) {
    case 0:
        r = SaveHilight(0);
        break;
    case 1:
        r = SaveHilight(1);
        break;
    case 2:
        if ((r = SaveHilight(0)) == 0) r = SaveHilight(1);
        break;
    case 3:
        r = 0;
        break;
    }
    if (r) {
        SetTickDeadline(0x1F4);
        SetDialogColors(0x14, 0x59, 0x11, 0x59, 0);
        MessageBox(0, 0, (char *)msg_NoHilightSpace, 3, 0, 0, 0, 0, 0);
        FreeMemBlock(gadgetfile);
        MakePath(path, fileoncd[0x223] == 1 ? (char *)cddriveptr : 0, (char *)str_Gadget6, (char *)str_PPV);
        gadgetfile = sub_8E8A0(path, 0);
        gadgetshape = FindShape(gadgetfile, (char *)str_Gad1);
        WaitTickDeadline();
        RestoreDialogBg();
    } else {
        WaitTickDeadline();
    }
    NudgeRinkScroll();
    gadgetptrx = x;
    gadgetptry = y;
    MouseSetPos(x, y);
    if (r) {
        SetTickDeadline(0x1F4);
        SetDialogColors(0x14, 0x59, 0x11, 0x59, 0);
        SetScreenTarget();
        MessageBox(-1, -1, (char *)msg_NoHilightSpace, 3, 0, 0, 0, 0, 0);
        WaitTickDeadline();
        RestoreDialogBg();
    }
    SetClipWindow(0, 0x140, 0, 0xC8);
    FreeMemBlock((int)p);
    SetViewRect(0, 0, 0x140, 0xC1);
}
