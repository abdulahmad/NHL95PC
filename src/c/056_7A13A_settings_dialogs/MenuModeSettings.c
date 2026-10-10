/* Settings dialogs: game mode settings menu. */
#include "nhl95.h"

typedef struct Hdr17 { char c[17]; } Hdr17;

/* MenuModeSettings (7B3A7) - menu "game settings": save the screen under the 214 x 257 dialog at 10 / 13h into a
   BKGD bitmap (pointer sprite header), draw it and run it (view only in game mode 2, else edit). With line changes off,
   clear the line change blink / box state, every player's bit 3 (byte_DF861, 80h per player) and both teams' bit 1, and
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
        for (i = 0; i < 0xC; i++) byte_DF861[i * 0x80] &= ~8;
        hmtmflags[0] &= ~2;
        awtmflags &= ~2;
        for (i = 0; i < 0x1C; i++) {
            word_DF75A[i] = 0x1000;
            word_DF65A[i] = 0x1000;
        }
    }
    if (gameopts.music) sub_8F979();
    else sub_8F984();
    if (gameopts.sfx) sub_8F963();
    else sub_8F96E();
    jctime(bm);
    jctime(settingsfile);
    settingsfile = 0;
    return 0;
}
