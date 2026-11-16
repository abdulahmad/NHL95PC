/* Joystick calibration: the calibration screen. */
#define JoystickCalScreen JoystickCalScreen_decl
#define JoyButtonMap sub_B340B_decl
#define KbdGetKey sub_B39D0_decl
#include "nhl95.h"
#undef JoystickCalScreen
#undef JoyButtonMap
#undef KbdGetKey

int __cdecl JoyButtonMap(int buttons);
int KbdGetKey(void);

typedef struct { char b[17]; } Hdr17;                  /* the shape header the puck background copies */

/* MATCH (10.0 GA). pal and state are plain arrays and bank / shape / cur a struct whose address is never
 taken, so the bank stays in esi for the two side calls (merged by Watcom) and the puck shape in esi for the
 17-byte header copy (a struct copy: movsd x4, movsb). The puck shape reuses the shape slot; the button exit
 does not clear the mask. The two draws index with s.cur and prev is set after them (the EXE reloads s.cur
 into esi after DrawArt). The abort test reads the stick's byte of the pad word into an unsigned char
 (buttons): the conversion is one more register conflict before the puck size product, which puts the width
 read in edx and the height read in eax (with an int local, or the test on the expression, they swap).
 JoystickCalScreen: calibrate one stick. mask is the joyenablemask bit, shift selects that
 stick in the pad word, and side picks the right-hand art when it is not 0. The title is the
 caller's string; this screen does not print it. A button already held aborts and clears the
 bit. Otherwise the puck follows the stick until a button or cancel, then the colours fade
 back. Returns 0. */
int __cdecl JoystickCalScreen(int mask, int shift, int side, char *title)
{
    unsigned char pal[0x300];
    char state[0x40];
    struct {
        int bank;
        int shape;
        int cur;
    } s;
    unsigned char *back;
    int prev;
    unsigned char buttons;

    (void)title;
    joycalactive = 1;
    ((void (*)(void))joycalprehook)();
    if (side) sub_B387E();
    else sub_B384E();
    TextSetColors(0, 0);
    buttons = ReadJoyRaw() >> shift;
    if ((buttons & 0x30) == 0) {
        TextSaveState(state);
        TextSetFont((int)DefaultFont);
        SetScreenTarget();
        ClearScreen(0);
        memset(pal, 0, 0x300);
        VgaSetPalette(0, 0x100, pal);
        s.bank = LoadBank((char *)str_Joycal, 0);
        sub_9121C(FindShape(s.bank, (char *)str_Scrn3));
        if (side) s.shape = FindShape(s.bank, (char *)str_Rite);
        else s.shape = FindShape(s.bank, (char *)str_Left);
        DrawShape(s.shape);
        memcpy(pal, (unsigned char *)FindShape(s.bank, (char *)str_Pal24) + 0x10, 0x300);
        s.shape = FindShape(s.bank, (char *)str_Puck);
        back = (unsigned char *)AllocMemBlock((char *)str_PuckBack, ((short *)s.shape)[2] * ((short *)s.shape)[3] + 0x11, 0);
        *(Hdr17 *)back = *(Hdr17 *)s.shape;
        FadePalStep(0, pal, 0x10);
        prev = -1;
        for (;;) {
            if (KbdGetKey()) {
                *(int *)&joyenablemask &= ~mask;
                break;
            }
            s.cur = ReadJoyRaw() >> shift;
            if (s.cur & 0x30) break;
            s.cur = JoyButtonMap(s.cur);
            if (s.cur == prev) continue;
            sub_B4C61();
            if (prev != -1) DrawArtOpaque((int)back, joycalx[prev], joycaly[prev]);
            GrabBlock((int)back, joycalx[s.cur], joycaly[s.cur]);
            DrawArt(s.shape, joycalx[s.cur], joycaly[s.cur]);
            prev = s.cur;
            PrintString((char *)unk_C27F5, 0, 0x14);
        }
        FreeMemBlock((int)back);
        FreeMemBlock(s.bank);
        FadePalStep(1, pal, 0x10);
        TextRestoreState(state);
    } else
        *(int *)&joyenablemask &= ~mask;
    ((void (*)(void))joycalposthook)();
    joycalactive = 0;
    return 0;
}
