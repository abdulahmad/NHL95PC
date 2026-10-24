/* Joystick calibration: the calibration screen. */
#define JoystickCalScreen JoystickCalScreen_decl
#define sub_B340B sub_B340B_decl
#define sub_B39D0 sub_B39D0_decl
#include "nhl95.h"
#undef JoystickCalScreen
#undef sub_B340B
#undef sub_B39D0

int __cdecl sub_B340B(int buttons);
int sub_B39D0(void);

typedef struct { char b[17]; } Hdr17;                  /* the shape header the puck background copies */

/* DRAFT: 713 vs 713, 11 differing (GA). pal and state are plain arrays and bank / shape / cur
 a struct whose address is never taken, so the bank stays in esi for the two side calls
 (merged by Watcom) and the puck shape in esi for the 17-byte header copy (a struct copy: movsd x4,
 movsb). The puck shape reuses the shape
 slot; the button exit does not clear the mask. The two draws index with s.cur and prev is
 set after them (the EXE reloads s.cur into esi after sub_91370). Left: the puck size factors
 load into eax then [esi+4] (EXE edx then [eax+4]); see docs/UNSURE.md.
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

    (void)title;
    joycalactive = 1;
    ((void (*)(void))joycalprehook)();
    if (side) sub_B387E();
    else sub_B384E();
    sub_8E9C0(0, 0);
    if (((sub_B3464() >> shift) & 0x30) == 0) {
        sub_8E9E8(state);
        sub_8EA18((int)unk_D45D8);
        sub_B4BA8();
        sub_B392C(0);
        memset(pal, 0, 0x300);
        sub_B4B88(0, 0x100, pal);
        s.bank = sub_8E83C((char *)str_Joycal, 0);
        sub_9121C(sub_B30B4(s.bank, (char *)str_Scrn3));
        if (side) s.shape = sub_B30B4(s.bank, (char *)str_Rite);
        else s.shape = sub_B30B4(s.bank, (char *)str_Left);
        sub_913B4(s.shape);
        memcpy(pal, (unsigned char *)sub_B30B4(s.bank, (char *)str_Pal24) + 0x10, 0x300);
        s.shape = sub_B30B4(s.bank, (char *)str_Puck);
        back = (unsigned char *)sub_8CCA8((char *)str_PuckBack, ((short *)s.shape)[2] * ((short *)s.shape)[3] + 0x11, 0);
        *(Hdr17 *)back = *(Hdr17 *)s.shape;
        FadePalStep(0, pal, 0x10);
        prev = -1;
        for (;;) {
            if (sub_B39D0()) {
                *(int *)&joyenablemask &= ~mask;
                break;
            }
            s.cur = sub_B3464() >> shift;
            if (s.cur & 0x30) break;
            s.cur = sub_B340B(s.cur);
            if (s.cur == prev) continue;
            sub_B4C61();
            if (prev != -1) sub_910E0((int)back, joycalx[prev], joycaly[prev]);
            sub_91400((int)back, joycalx[s.cur], joycaly[s.cur]);
            sub_91370(s.shape, joycalx[s.cur], joycaly[s.cur]);
            prev = s.cur;
            sub_91964((char *)unk_C27F5, 0, 0x14);
        }
        FreeMemBlock((int)back);
        FreeMemBlock(s.bank);
        FadePalStep(1, pal, 0x10);
        sub_8EA00(state);
    } else
        *(int *)&joyenablemask &= ~mask;
    ((void (*)(void))joycalposthook)();
    joycalactive = 0;
    return 0;
}
