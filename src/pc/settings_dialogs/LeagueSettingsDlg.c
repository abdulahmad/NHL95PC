/* Settings dialogs: the league and playoff settings dialogs and the functions that end in their shared exit (one
   source block). With only the five dialogs in the file Watcom keeps the pops in MenuPlayoffSettings; with
   DrawLeagueSetChecks after them (it ends in LeagueSettingsDlg_ret4) they stay in LeagueSettingsDlg, as in the EXE. */
#define MenuShowLeagueSettings2 MenuShowLeagueSettings2_decl
#define LeagueSetViewLoop LeagueSetViewLoop_decl
#define LeagueSetEditLoop LeagueSetEditLoop_decl
#define sub_96440 sub_96440_decl
#include "nhl95.h"
#undef LeagueSetViewLoop
#undef LeagueSetEditLoop
#undef sub_96440
#undef MenuShowLeagueSettings2

typedef struct Hdr17 { char c[17]; } Hdr17;

void DrawLeagueSetDlg(int playoffs);  /* 7A6BD */
short LeagueSetEditLoop(int mode);  /* 7ADD3 */
void __cdecl sub_96440(int buf, int x, int y);  /* graphics library: save a screen block, clipped */
short LeagueSetViewLoop(void);  /* 7AC31 */

/* LeagueSettingsDlg (7A13A, PC only; owner of LeagueSettingsDlg_ret4 / _ret / _ret0): the league settings dialog: with the series game number cleared (restored after),
 load the settings shapes, save the screen under the 230 x 338 dialog at 10 13h into a BKGD bitmap (pointer
 sprite header), draw the dialog (DrawLeagueSetDlg 0), load the options into the check bits and run it (edit mode
 1); then restore the screen and free the bitmap and the settings file. Returns 0. */
int LeagueSettingsDlg(void)
{
    int bm;
    int sg;

    sg = seriesgameno;
    seriesgameno = 0;
    LoadSettingsShapes();
    sub_B4BA8();
    bm = sub_8CCA8((char *)str_BKGD, 0x1436B, 0x20);
    *(Hdr17 *)bm = *(Hdr17 *)pointerspr;
    ((short *)bm)[2] = 0xE6;
    ((short *)bm)[3] = 0x152;
    sub_91400(bm, 0xA, 0x13);
    DrawLeagueSetDlg(0);
    LeagueOptsToBits();
    LeagueSetEditLoop(1);
    sub_903F0(bm, 0xA, 0x13);
    FreeMemBlock(bm);
    FreeMemBlock(settingsfile);
    settingsfile = 0;
    seriesgameno = sg;
    return 0;
}

/* MenuPlayoffSettings (7A1FC, PC only; ends in LeagueSettingsDlg_ret): menu "playoff settings": the same dialog for the playoffs (DrawLeagueSetDlg 1,
 edit mode 0). Returns 0. */
int MenuPlayoffSettings(void)
{
    int bm;

    LoadSettingsShapes();
    sub_B4BA8();
    bm = sub_8CCA8((char *)str_BKGD, 0x1436B, 0x20);
    *(Hdr17 *)bm = *(Hdr17 *)pointerspr;
    ((short *)bm)[2] = 0xE6;
    ((short *)bm)[3] = 0x152;
    sub_91400(bm, 0xA, 0x13);
    DrawLeagueSetDlg(1);
    LeagueOptsToBits();
    LeagueSetEditLoop(0);
    sub_903F0(bm, 0xA, 0x13);
    FreeMemBlock(bm);
    FreeMemBlock(settingsfile);
    settingsfile = 0;
    return 0;
}

/* EditPlayoffSettings (7A29C, PC only; ends in MenuPlayoffSettings' close): edit the playoff settings: the league dialog (DrawLeagueSetDlg 0, edit mode 1)
 run on the playoff state (exhibition state saved, postate loaded, then written back and the exhibition state
 reloaded). Returns 0. */
int EditPlayoffSettings(void)
{
    int bm;

    LoadSettingsShapes();
    sub_B4BA8();
    bm = sub_8CCA8((char *)str_BKGD, 0x1436B, 0x20);
    *(Hdr17 *)bm = *(Hdr17 *)pointerspr;
    ((short *)bm)[2] = 0xE6;
    ((short *)bm)[3] = 0x152;
    sub_91400(bm, 0xA, 0x13);
    SaveModeState(exhstate);
    LoadModeState(postate);
    DrawLeagueSetDlg(0);
    LeagueOptsToBits();
    LeagueSetEditLoop(1);
    WriteModeState(postate);
    LoadModeState(exhstate);
    sub_903F0(bm, 0xA, 0x13);
    FreeMemBlock(bm);
    FreeMemBlock(settingsfile);
    settingsfile = 0;
    return 0;
}

/* MenuLeagueSettingsEdit (7A335, PC only; ends in MenuPlayoffSettings' edit): menu "edit league settings": the dialog with the selection drawn
 (DrawLeagueSetDlgSel), edit mode 1. Returns 0. */
int MenuLeagueSettingsEdit(void)
{
    int bm;

    sub_B4BA8();
    LoadSettingsShapes();
    bm = sub_8CCA8((char *)str_BKGD, 0x1436B, 0x20);
    *(Hdr17 *)bm = *(Hdr17 *)pointerspr;
    ((short *)bm)[2] = 0xE6;
    ((short *)bm)[3] = 0x152;
    sub_91400(bm, 0xA, 0x13);
    DrawLeagueSetDlgSel();
    LeagueOptsToBits();
    LeagueSetEditLoop(1);
    sub_903F0(bm, 0xA, 0x13);
    FreeMemBlock(bm);
    FreeMemBlock(settingsfile);
    settingsfile = 0;
    return 0;
}

/* MenuShowLeagueSettings (7A39F, PC only; ends in MenuPlayoffSettings' close): menu "show league settings": the dialog with the selection drawn, view only
 (LeagueSetViewLoop). Returns 0. */
int MenuShowLeagueSettings(void)
{
    int bm;

    LoadSettingsShapes();
    bm = sub_8CCA8((char *)str_BKGD, 0x1436B, 0x20);
    *(Hdr17 *)bm = *(Hdr17 *)pointerspr;
    ((short *)bm)[2] = 0xE6;
    ((short *)bm)[3] = 0x152;
    sub_91400(bm, 0xA, 0x13);
    DrawLeagueSetDlgSel();
    LeagueOptsToBits();
    LeagueSetViewLoop();
    sub_903F0(bm, 0xA, 0x13);
    FreeMemBlock(bm);
    FreeMemBlock(settingsfile);
    settingsfile = 0;
    return 0;
}


/* MenuShowLeagueSettings2 (7A404, PC only; ends in LeagueSettingsDlg_ret): show the league settings (view only)
   in the box art: load the SETTING bank (from the CD when fileoncd says so), save the screen under its DBOX at 10
   13h into a BKGD bitmap and draw the box, label the music / sound rows for sound device 10h and the speech row
   without music, draw the heading for the game mode, load the options into the check bits and view them
   (LeagueSetViewLoop); then restore the screen and free the bitmap and the settings file. Result: 0. */
int MenuShowLeagueSettings2(void)
{
    char path[0x20];
    int bank;
    int bm;
    int box;
    int sz;

    LoadSettingsShapes();
    sub_B4BA8();
    MakePath(path, fileoncd[0x175] == 1 ? (char *)cddriveptr : 0, (char *)str_Setting5, 0);
    bank = sub_8E83C(path, 0);
    box = sub_B30B4(bank, (char *)str_Dbox2);
    sz = (((short *)box)[2] + 1) * (((short *)box)[3] + 1) + 0x11;
    bm = sub_8CCA8((char *)str_BKGD, sz, 0x20);
    *(Hdr17 *)bm = *(Hdr17 *)box;
    sub_91400(bm, 0xA, 0x13);
    sub_91370(box, 0xA, 0x13);
    FreeMemBlock(bank);
    sub_8E9C0(0xF8, 0xFF);
    if (sounddev == 0x10) {
        sub_91964((char *)str_Music, 0x68, 0xAA);
        sub_91964((char *)str_Sound, 0x68, 0xC0);
    }
    if (!musicon) sub_91964((char *)str_DigitizedSpeech, 0x68, 0xD6);
    DrawSettingsHeading(0xA, 0x13, 5, gamemode, 0xFA);
    LeagueOptsToBits();
    LeagueSetViewLoop();
    sub_903F0(bm, 0xA, 0x13);
    FreeMemBlock(bm);
    FreeMemBlock(settingsfile);
    settingsfile = 0;
    return 0;
}


/* DrawLeagueSetDlg (7A6BD, PC only; ends in LeagueSettingsDlg_ret0): draw the league settings dialog: an identity
   colour remap (for the playoffs FAh-F7h become 40h-43h), the SETTING bank's DBOX art at 10 13h (from the CD when
   fileoncd says so), the labels in F8h (42h for the playoffs) on FFh: "Music" "Sound" with sound device 10h and
   "Digitized speech" with music off; in the playoffs (gamemode 1) the series length sprite by the game number
   (5 or more, 3, 1); then the heading (colour FAh, 40h for the playoffs). playoffs: nonzero for the playoff
   settings. No result. */
void DrawLeagueSetDlg(int playoffs)
{
    unsigned char remap[0x100];
    char path[0x20];
    int i;
    int bank;

    sub_B4BA8();
    for (i = 0; i < 0x100; i++) remap[i] = i;
    if (playoffs) {
        remap[0xFA] = 0x40;
        remap[0xF9] = 0x41;
        remap[0xF8] = 0x42;
        remap[0xF7] = 0x43;
    }
    sub_B4DD4(remap);
    MakePath(path, fileoncd[0x173] == 1 ? (char *)cddriveptr : 0, (char *)str_Setting3, 0);
    bank = sub_8E83C(path, 0);
    sub_931FC(sub_B30B4(bank, (char *)str_Dbox2), 0xA, 0x13);
    FreeMemBlock(bank);
    if (playoffs) sub_8E9C0(0x42, 0xFF);
    else sub_8E9C0(0xF8, 0xFF);
    if (sounddev == 0x10) {
        sub_91964((char *)str_Music, 0x68, 0xAA);
        sub_91964((char *)str_Sound, 0x68, 0xC0);
    }
    if (!musicon) sub_91964((char *)str_DigitizedSpeech, 0x68, 0xD6);
    if (gamemode == 1) {
        if (seriesgameno >= 5) sub_91FE0(na05spr, 0x85, 0x125);
        else if (seriesgameno >= 3) sub_91FE0(na03spr, 0x85, 0x125);
        else if (seriesgameno >= 1) sub_91FE0(na01spr, 0x85, 0x125);
    }
    if (playoffs) DrawSettingsHeading(0xA, 0x13, 3, gamemode, 0x40);
    else DrawSettingsHeading(0xA, 0x13, 3, gamemode, 0xFA);
}


/* DrawLeagueSetChecks (7AAAA, PC only; ends in LeagueSettingsDlg_ret4): draw the league settings dialog's 9
   check boxes (on or off sprite by setbits bit i) at their rects (2 rects per item; item 5 is skipped), then the
   period length choice (setbits 200h / 400h / 800h: the 20, 10 or 5 minute sprite) and the playoff series length
   (1000h-8000h: best of 1, 3, 5 or 7) at the next rects. No arguments, no result. */
void DrawLeagueSetChecks(void)
{
    Rect4 *r;
    int i;

    r = (Rect4 *)leaguesetrects;
    for (i = 0; i < 9; i++, r += 2) {
        if (i == 5) {
            i++;
            r += 2;
        }
        if (setbits[0] & (1 << i)) sub_91FE0(chkonspr, r->l + 10, r->t + 0x13);
        else sub_91FE0(chkoffspr, r->l + 10, r->t + 0x13);
    }
    switch (setbits[0] & 0xE00) {
    case 0x200:
        sub_91FE0(pl20spr, r->l + 10, r->t + 0x13);
        break;
    case 0x400:
        sub_91FE0(pl10spr, r->l + 10, r->t + 0x13);
        break;
    case 0x800:
        sub_91FE0(pl05spr, r->l + 10, r->t + 0x13);
        break;
    }
    r += 3;
    switch (setbits[0] & 0xF000) {
    case 0x1000:
        sub_91FE0(pg01spr, r->l + 10, r->t + 0x13);
        break;
    case 0x2000:
        sub_91FE0(pg03spr, r->l + 10, r->t + 0x13);
        break;
    case 0x4000:
        sub_91FE0(pg05spr, r->l + 10, r->t + 0x13);
        break;
    case 0x8000:
        sub_91FE0(pg07spr, r->l + 10, r->t + 0x13);
        break;
    }
}

/* LeagueSetViewLoop (7AC31, PC only; ends in LeagueSettingsDlg_ret): the view-only league settings dialog, as
   ModeSetViewLoop: set four dialog colours, save the screen under the pointer into a POINTER block and draw the
   pointer, follow the mouse until any button (moving the saved screen with the pointer), then put the screen back
   and free the block. Result: 0, a short (an int result copies the ptrupdatefn result through edx). */
short LeagueSetViewLoop(void)
{
    struct {
        int btn;
        int y;
        int x;
        int oy;
        int ox;
    } s;
    int bm;
    int n;
    unsigned char *ev;

    sub_B4B88(0xF7, 4, unk_D16A0);
    sub_B2DCA(&s.btn, &s.ox, &s.oy);
    s.x = s.ox;
    s.y = s.oy;
    sub_B4BA8();
    n = (((short *)pointerspr)[2] + 1) * (((short *)pointerspr)[3] + 1) + 0x11;
    bm = sub_8CCA8((char *)str_Pointer15, n, 0x20);
    *(Hdr17 *)bm = *(Hdr17 *)pointerspr;
    ((short *)bm)[2] = ((short *)pointerspr)[2] + 1;
    ((short *)bm)[3] = ((short *)pointerspr)[3] + 1;
    sub_91400(bm, s.x - 4, s.y);
    sub_91370(pointerspr, s.x - 4, s.y);
    ClearInputQueue();
    for (;;) {
        s.btn = 0;
        for (;;) {
            ev = GetInputEvent();
            if (ev == 0) break;
            s.btn = ((int (*)(unsigned char *, int *, int *))ptrupdatefn)(ev, &s.x, &s.y);
            if (s.btn & 6) break;
        }
        if (s.btn != 0) break;
        if (s.x == s.ox && s.y == s.oy) continue;
        sub_903F0(bm, s.ox - 4, s.oy);
        sub_91400(bm, s.x - 4, s.y);
        sub_91370(pointerspr, s.x - 4, s.y);
        s.ox = s.x;
        s.oy = s.y;
    }
    sub_903F0(bm, s.ox - 4, s.oy);
    FreeMemBlock(bm);
    return 0;
}

/* LeagueSetEditLoop (7ADD3, PC only; ends in LeagueSettingsDlg_ret): the league settings dialog, as
   ModeSetEditLoop (mode nonzero: set the dialog colours first) with two option groups: boxes 18-20 pick one of
   setbits bits 9-11 (pertime 2, 1, 0) and boxes 21-24 one of bits 12-15 (optbits12 1, 3, 5, 7); OK is box 25 and
   Cancel box 26 (their buttons drawn with sub_91FE0). Speech follows its box with a 22h sound device and there is
   no crowd noise. After a click the screen under the pointer is saved clipped (sub_96440). Result: 0, a short. */
short LeagueSetEditLoop(int mode)
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

    if (mode) sub_B4B88(0xF7, 4, unk_D16A0);
    sub_B2DCA(&btn, &ox, &oy);
    x = ox;
    y = oy;
    oldmusic = gameopts.music;
    sub_B4BA8();
    n = (((short *)pointerspr)[2] + 1) * (((short *)pointerspr)[3] + 1) + 0x11;
    bm = sub_8CCA8((char *)str_Pointer15, n, 0x20);
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
            if (LeagueSetHitTest(x, y, &hit)) {
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
                } else if (hit < 0x15) {
                    hit -= 9;
                    setbits[0] = (setbits[0] & 0xF1FF) | 1 << hit;
                } else if (hit < 0x19) {
                    hit -= 9;
                    setbits[0] = (setbits[0] & 0xFFF) | 1 << hit;
                } else if (hit == 0x19) {
                    sub_91FE0(acptspr, 0x3F, 0x148);
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
                    switch (setbits[0] & 0xF000) {
                    case 0x1000:
                        gameopts.optbits12 = 1;
                        break;
                    case 0x2000:
                        gameopts.optbits12 = 3;
                        break;
                    case 0x4000:
                        gameopts.optbits12 = 5;
                        break;
                    case 0x8000:
                        gameopts.optbits12 = 7;
                        break;
                    }
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
                    sub_91FE0(fdlg_cancel, 0x89, 0x148);
                    FreeMemBlock(bm);
                    return 0;
                }
                DrawLeagueSetChecks();
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
