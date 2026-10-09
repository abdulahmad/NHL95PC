/* Settings dialogs: exhibition settings dialog. */
#include "nhl95.h"

/* DrawExhSetDlg (7C1AC) - draw the exhibition settings dialog: load the SETTING bank (from the CD when fileoncd says
   so), draw its DBOX art at 10 / 13h and free it; label "Music" / "Sound" with the sound device 10h and "Digitized
   speech" with music off (the greyed items), then the heading for gamemode (DrawSettingsHeading, colour FAh). */
void DrawExhSetDlg(void)
{
    char path[32];
    int bank;

    sub_B4BA8();
    MakePath(path, fileoncd[0x176] == 1 ? (char *)cddriveptr : 0, (char *)str_Setting6, 0);
    bank = sub_8E83C(path, 0);
    sub_91284(sub_B30B4(bank, (char *)str_Dbox4), 0xA, 0x13);
    jctime(bank);
    if (sounddev == 0x10) {
        sub_91964((char *)str_Music3, 0x60, 0xAA);
        sub_91964((char *)str_Sound3, 0x60, 0xC0);
    }
    if (!musicon) sub_91964((char *)str_DigitizedSpeech3, 0x60, 0xD6);
    DrawSettingsHeading(0xA, 0x13, 6, gamemode, 0xFA);
}
