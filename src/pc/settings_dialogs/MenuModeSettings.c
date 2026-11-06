/* Settings dialogs: game mode settings menu. */
#define ModeSetViewLoop ModeSetViewLoop_decl
#define ModeSetEditLoop ModeSetEditLoop_decl
#include "nhl95.h"
#undef ModeSetViewLoop
#undef ModeSetEditLoop

typedef struct Hdr17 { char c[17]; } Hdr17;

short ModeSetViewLoop(void);  /* 7B846 */
short ModeSetEditLoop(void);  /* 7B9E8 */

/* MenuModeSettings: menu "game settings": save the screen under the 214 x 257 dialog at 10 13h into a
 BKGD bitmap (pointer sprite header), draw it and run it (view only in game mode 2, else edit). With line changes off,
 clear the line change blink box state, every player's pflags2 bit 3 (scpflags2, stride 80h) and both teams' bit 1, and
 reset the 1Ch energy words of both teams to 1000h. Then music (bit 6) and sound effects (bit 7) on or off, restore
 the screen and free the bitmap and the settings file. Returns 0. */
int MenuModeSettings(void)
{
    int bm;
    short i;

    sub_B4BA8();
    LoadSettingsShapes();
    bm = sub_8CCA8((char *)str_BKGD2, 0xE935, 0x20);
    *(Hdr17 *)bm = *(Hdr17 *)pointerspr;
    ((short *)bm)[2] = 0xD6;
    ((short *)bm)[3] = 0x101;
    sub_91400(bm, 0xA, 0x13);
    DrawModeSetDlg();
    ModeOptsToBits();
    if (gamemode == 2) ModeSetViewLoop();
    else ModeSetEditLoop();
    sub_903F0(bm, 0xA, 0x13);
    if (!gameopts.linechanges) {
        lcboxon[0] = lcboxon[1] = lcblink[0] = lcblink[1] = 0;
        for (i = 0; i < 0xC; i++) scpflags2[i * 0x80] &= ~8;
        hmtmflags[0] &= ~2;
        awtmflags &= ~2;
        for (i = 0; i < 0x1C; i++) {
            awtmpde[i] = 0x1000;
            hmtmpde[i] = 0x1000;
        }
    }
    if (gameopts.music) sub_8F979();
    else sub_8F984();
    if (gameopts.sfx) sub_8F963();
    else sub_8F96E();
    FreeMemBlock(bm);
    FreeMemBlock(settingsfile);
    settingsfile = 0;
    return 0;
}

/* ModeSetViewLoop (7B846, PC only; ends in ModeSettings_epilogue): the view-only game settings dialog (game mode
   2). Set four dialog colours (F7h), read the mouse, save the screen under the pointer into a POINTER block with
   the pointer sprite's header (one pixel larger each way) and draw the pointer. Then follow the mouse through
   ptrupdatefn until any button: when the pointer moved, put the old screen back, save the new one and draw the
   pointer again. On a button put the screen back and free the block. Result: 0. The original returns a short:
   with an int result Watcom copies the button bits through edx after the ptrupdatefn call (docs/C_MATCHING.md). */
short ModeSetViewLoop(void)
{
    int ox;
    int oy;
    int x;
    int y;
    int btn;
    int bm;
    int n;
    unsigned char *ev;

    sub_B4B88(0xF7, 4, unk_D16A0);
    sub_B2DCA(&btn, &ox, &oy);
    x = ox;
    y = oy;
    sub_B4BA8();
    n = (((short *)pointerspr)[2] + 1) * (((short *)pointerspr)[3] + 1) + 0x11;
    bm = sub_8CCA8((char *)str_Pointer16, n, 0x20);
    *(Hdr17 *)bm = *(Hdr17 *)pointerspr;
    ((short *)bm)[2] = ((short *)pointerspr)[2] + 1;
    ((short *)bm)[3] = ((short *)pointerspr)[3] + 1;
    sub_91400(bm, x - 4, y);
    sub_91370(pointerspr, x - 4, y);
    ClearInputQueue();
    for (;;) {
        btn = 0;
        for (;;) {
            ev = GetInputEvent();
            if (ev == 0) break;
            btn = ((int (*)(unsigned char *, int *, int *))ptrupdatefn)(ev, &x, &y);
            if (btn & 6) break;
        }
        if (btn != 0) break;
        if (x == ox && y == oy) continue;
        sub_903F0(bm, ox - 4, oy);
        sub_91400(bm, x - 4, y);
        sub_91370(pointerspr, x - 4, y);
        ox = x;
        oy = y;
    }
    sub_903F0(bm, ox - 4, oy);
    FreeMemBlock(bm);
    return 0;
}

/* ModeSetEditLoop (7B9E8, PC only; ends in ModeSettings_epilogue): the game settings dialog. Set four dialog
   colours, read the mouse, remember whether music is on, save the screen under the pointer and draw it (as
   ModeSetViewLoop). Then follow the mouse until event bit 2 or 4. A click (bit 2) on one of the 18 check boxes
   (ModeSetHitTest; boxes 2n / 2n+1 set / clear setbits bit n; the speech pair needs music) redraws the checks.
   OK (box 18) copies setbits into gameopts: bits 0-5, music and sound effects without the 10h sound device (the
   crowd noise stops or restarts with the sound effects bit), speech when there is music; restarts the song when
   music was switched on (or fades it out when switched off), switches the music and sound effects and writes the
   mode state. Cancel (box 19) and event bit 4 leave without changes. Result: 0, a short. */
short ModeSetEditLoop(void)
{
    int oldmusic;
    int ox;
    int oy;
    int x;
    int y;
    int btn;
    int hit;
    int bm;
    int n;
    unsigned char *ev;

    sub_B4B88(0xF7, 4, unk_D16A0);
    sub_B2DCA(&btn, &ox, &oy);
    x = ox;
    y = oy;
    sub_B4BA8();
    oldmusic = gameopts.music;
    n = (((short *)pointerspr)[2] + 1) * (((short *)pointerspr)[3] + 1) + 0x11;
    bm = sub_8CCA8((char *)str_Pointer16, n, 0x20);
    *(Hdr17 *)bm = *(Hdr17 *)pointerspr;
    ((short *)bm)[2] = ((short *)pointerspr)[2] + 1;
    ((short *)bm)[3] = ((short *)pointerspr)[3] + 1;
    sub_91400(bm, x - 4, y);
    sub_91370(pointerspr, x - 4, y);
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
            if (ModeSetHitTest(x, y, &hit)) {
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
                    DrawModeSetChecks();
                } else if (hit == 0x12) {
                    int sfx;  /* declared here: at the top the then-branch copies it into eax */

                    sub_903F0(acptspr, 0x37, 0xF8);
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
                    sfx = (setbits[0] & 0x80) != 0;
                    if (gameopts.sfx && !sfx) CrowdNoiseOff();
                    if (!gameopts.sfx && sfx) {
                        gameopts.sfx = sfx;
                        CrowdNoiseReset();
                    } else {
                        gameopts.sfx = sfx;
                    }
                    if (musicon) gameopts.speech = (setbits[0] & 0x100) != 0;
                    if (gameopts.music) {
                        if (musicon && songdata && !oldmusic && sub_8FC8A(musicslot, 3))
                            sub_8FB8E(songdata, musichandle, 3, 0x7F);
                        sub_8F979();
                    } else {
                        if (musicon && songdata && !sub_8FC8A(musicslot, 3))
                            sub_8FCDF(musichandle, 3, 0x64);
                        sub_8F984();
                    }
                    if (gameopts.sfx) sub_8F963();
                    else sub_8F96E();
                    WriteCurModeState();
                    FreeMemBlock(bm);
                    return 0;
                } else {
                    sub_903F0(fdlg_cancel, 0x81, 0xF8);
                    FreeMemBlock(bm);
                    return 0;
                }
            }
            sub_91400(bm, x - 4, y);
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
