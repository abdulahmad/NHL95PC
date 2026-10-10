/* Settings dialogs: exhibition settings menu. */
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
