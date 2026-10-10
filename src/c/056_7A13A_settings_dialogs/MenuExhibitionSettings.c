/* Settings dialogs: exhibition settings (one source block: DrawExhSetChecks ends in MenuExhibitionSettings' exit). */
#include "nhl95.h"

typedef struct Hdr17 { char c[17]; } Hdr17;

/* MenuExhibitionSettings (7BEBB) - menu "exhibition settings": load the settings shapes; save the screen under the
   214 x 297 dialog at 10 / 13h into a BKGD bitmap (pointer sprite header), draw the dialog (DrawExhSetDlg), load the
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
    jctime(bm);
    jctime(settingsfile);
    settingsfile = 0;
    return 0;
}


/* ExhOptsToBits (7BF56) - like ModeOptsToBits for the exhibition settings dialog, plus the period length option as one of
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

/* DrawExhSetChecks (7C0B9) - DrawModeSetChecks for the exhibition dialog (exhsetrects, item 5 skipped), then the period
   length box: the 20 / 10 / 5 minute sprite for setbits 200h / 400h / 800h at the next rect. */
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
