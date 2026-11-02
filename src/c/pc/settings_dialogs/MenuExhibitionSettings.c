/* Settings dialogs: exhibition settings (one source file: DrawExhSetChecks and ExhSetEditLoop end in MenuExhibitionSettings' exit). */
#define ExhSetEditLoop ExhSetEditLoop_decl
#define sub_96440 sub_96440_decl
#include "nhl95.h"
#undef ExhSetEditLoop
#undef sub_96440

typedef struct Hdr17 { char c[17]; } Hdr17;

short ExhSetEditLoop(void);  /* 7C317 */
void __cdecl sub_96440(int buf, int x, int y);  /* graphics library: save a screen block, clipped */

/* MenuExhibitionSettings: menu "exhibition settings": load the settings shapes; save the screen under the
 214 x 297 dialog at 10 13h into a BKGD bitmap (pointer sprite header), draw the dialog (DrawExhSetDlg), load the
 options into the check bits (ExhOptsToBits) and run it (ExhSetEditLoop); then restore the screen, free the bitmap
 and the settings file. Returns 0. */
int MenuExhibitionSettings(void)
{
    int bm;

    LoadSettingsShapes();
    bm = sub_8CCA8((char *)str_BKGD3, 0x10AA5, 0x20);
    *(Hdr17 *)bm = *(Hdr17 *)pointerspr;
    ((short *)bm)[2] = 0xD6;
    ((short *)bm)[3] = 0x129;
    sub_91400(bm, 0xA, 0x13);
    sub_B4BA8();
    DrawExhSetDlg();
    ExhOptsToBits();
    ExhSetEditLoop();
    sub_903F0(bm, 0xA, 0x13);
    FreeMemBlock(bm);
    FreeMemBlock(settingsfile);
    settingsfile = 0;
    return 0;
}


/* ExhOptsToBits: like ModeOptsToBits for the exhibition settings dialog, plus the period length option as one of
 three check bits in the second byte (pertime 0 -> 8, 1 -> 4, 2 -> 2); greyed labels drawn after the checks. */
void ExhOptsToBits(void)
{
    setbits[0] = gameopts.optbit0 | gameopts.offsides << 1 | gameopts.linechanges << 2
        | gameopts.twolinepass << 3 | gameopts.optbit4 << 4 | gameopts.optbit5 << 5
        | ((sounddev & 0x10) ? 0 : gameopts.music << 6)
        | ((sounddev & 0x10) ? 0 : gameopts.sfx << 7)
        | ((sounddev & 0x22) ? gameopts.speech << 8 : 0);
    switch (gameopts.pertime) {
    case 2: ((unsigned char *)setbits)[1] |= 2; break;
    case 1: ((unsigned char *)setbits)[1] |= 4; break;
    case 0: ((unsigned char *)setbits)[1] |= 8; break;
    }
    DrawExhSetChecks();
    sub_8E9C0(0xF8, 0xFF);
    if (musicon == 0) sub_91964((char *)str_DigitizedSpeech3, 0x60, 0xD6);
    if (sounddev == 0x10) {
        sub_91964((char *)str_Music3, 0x60, 0xAA);
        sub_91964((char *)str_Sound3, 0x60, 0xC0);
    }
}

/* DrawExhSetChecks: DrawModeSetChecks for the exhibition dialog (exhsetrects, item 5 skipped), then the period
 length box: the 20 10 5 minute sprite for setbits 200h 400h 800h at the next rect. */
void DrawExhSetChecks(void)
{
    Rect4 *r;
    int i;

    r = (Rect4 *)exhsetrects;
    for (i = 0; i < 9; i++, r += 2) {
        if (i == 5) {
            i++;
            r += 2;
        }
        if (setbits[0] & (1 << i)) sub_903F0(chkonspr, r->l + 10, r->t + 0x13);
        else sub_903F0(chkoffspr, r->l + 10, r->t + 0x13);
    }
    switch (setbits[0] & 0xE00) {
    case 0x200: sub_903F0(pl20spr, r->l + 10, r->t + 0x13); break;
    case 0x400: sub_903F0(pl10spr, r->l + 10, r->t + 0x13); break;
    case 0x800: sub_903F0(pl05spr, r->l + 10, r->t + 0x13); break;
    }
}

/* ExhSetEditLoop (7C317, PC only; ends in ExhSettings_ret): the exhibition settings dialog, as ModeSetEditLoop
   with the period length: boxes 18-20 pick one of setbits bits 9-11, which OK (box 21) turns into pertime 2, 1
   or 0; Cancel is box 22. Speech follows its box with a 22h sound device, there is no crowd noise, and switching
   the music off fades the song out faster (28h). After a click the screen under the pointer is saved clipped
   (sub_96440). Result: 0, a short. */
short ExhSetEditLoop(void)
{
    int ox;
    int oy;
    int x;
    int y;
    int btn;
    int hit;
    int bm;
    int n;
    int oldmusic;
    unsigned char *ev;

    sub_B4B88(0xF7, 4, unk_D16A0);
    sub_B2DCA(&btn, &ox, &oy);
    x = ox;
    y = oy;
    sub_B4BA8();
    n = (((short *)pointerspr)[2] + 1) * (((short *)pointerspr)[3] + 1) + 0x11;
    bm = sub_8CCA8((char *)str_Pointer17, n, 0x20);
    *(Hdr17 *)bm = *(Hdr17 *)pointerspr;
    ((short *)bm)[2] = ((short *)pointerspr)[2] + 1;
    ((short *)bm)[3] = ((short *)pointerspr)[3] + 1;
    sub_91400(bm, x - 4, y);
    sub_91370(pointerspr, x - 4, y);
    oldmusic = gameopts.music;
    ClearInputQueue();
    for (;;) {
        btn = 0;
        for (;;) {
            ev = GetInputEvent();
            if (ev == 0) break;
            btn = ((int (*)(unsigned char *, int *, int *))ptrupdatefn)(ev, &x, &y);
            if (btn & 6) break;
        }
        if (!(btn & 6)) {
            if (x != ox || y != oy) {
                sub_903F0(bm, ox - 4, oy);
                sub_91400(bm, x - 4, y);
                sub_91370(pointerspr, x - 4, y);
                ox = x;
                oy = y;
            }
        } else if (btn & 2) {
            sub_903F0(bm, ox - 4, oy);
            if (ExhSetHitTest(x, y, &hit)) {
                if (hit < 0x12) {
                    if (hit % 2) {
                        if (musicon || hit != 0x11) {
                            hit /= 2;
                            setbits[0] &= ~(1 << hit);
                        }
                    } else {
                        if (musicon || hit != 0x10) {
                            hit /= 2;
                            setbits[0] |= 1 << hit;
                        }
                    }
                    DrawExhSetChecks();
                } else if (hit < 0x15) {
                    hit -= 9;
                    setbits[0] = (setbits[0] & 0xF1FF) | 1 << hit;
                    DrawExhSetChecks();
                } else if (hit == 0x15) {
                    sub_903F0(acptspr, 0x37, 0x120);
                    gameopts.optbit0 = (setbits[0] & 1) != 0;
                    gameopts.offsides = (setbits[0] & 2) != 0;
                    gameopts.linechanges = (setbits[0] & 4) != 0;
                    gameopts.twolinepass = (setbits[0] & 8) != 0;
                    gameopts.optbit4 = (setbits[0] & 0x10) != 0;
                    gameopts.optbit5 = (setbits[0] & 0x20) != 0;
                    if (sounddev != 0x10) {
                        gameopts.music = (setbits[0] & 0x40) != 0;
                        gameopts.sfx = (setbits[0] & 0x80) != 0;
                    }
                    if (sounddev & 0x22) gameopts.speech = (setbits[0] & 0x100) != 0;
                    switch (setbits[0] & 0xE00) {
                    case 0x200:
                        gameopts.pertime = 2;
                        break;
                    case 0x400:
                        gameopts.pertime = 1;
                        break;
                    case 0x800:
                        gameopts.pertime = 0;
                        break;
                    }
                    if (gameopts.music) {
                        if (musicon && songdata && !oldmusic && sub_8FC8A(musicslot, 3))
                            sub_8FB8E(songdata, musichandle, 3, 0x7F);
                        sub_8F979();
                    } else {
                        if (musicon && songdata && !sub_8FC8A(musicslot, 3))
                            sub_8FCDF(musichandle, 3, 0x28);
                        sub_8F984();
                    }
                    if (gameopts.sfx) sub_8F963();
                    else sub_8F96E();
                    WriteCurModeState();
                    FreeMemBlock(bm);
                    return 0;
                } else {
                    sub_903F0(fdlg_cancel, 0x81, 0x120);
                    FreeMemBlock(bm);
                    return 0;
                }
            }
            sub_96440(bm, x - 4, y);
            sub_91370(pointerspr, x - 4, y);
            ox = x;
            oy = y;
        } else if (btn & 4) {
            sub_903F0(bm, ox - 4, oy);
            FreeMemBlock(bm);
            return 0;
        } else {
            sub_903F0(bm, ox - 4, oy);
            sub_91400(bm, x - 4, y);
            sub_91370(pointerspr, x - 4, y);
            ox = x;
            oy = y;
        }
    }
}
