/* Settings dialogs: playoff / league mode settings dialog. */
#include "nhl95.h"

/* DrawModeSetDlg (7B4EC) - draw the mode settings dialog: load the SETTING bank of the league (gamemode 2) or of the
   playoffs (from the CD when fileoncd says so), draw its DBOX art at 10 / 13h and free it; in F8h on FFh label
   "Music" / "Sound" with the sound device 10h and "Digitized speech" with music off, reset the clip and draw the
   heading for gamemode (DrawSettingsHeading, colour FAh). */
void DrawModeSetDlg(void)
{
    char path[32];
    int bank;

    if (gamemode == 2)
        MakePath(path, fileoncd[0x177] == 1 ? (char *)cddriveptr : 0, (char *)str_Setting7, 0);
    else
        MakePath(path, fileoncd[0x174] == 1 ? (char *)cddriveptr : 0, (char *)str_Setting4, 0);
    bank = sub_8E83C(path, 0);
    sub_91284(sub_B30B4(bank, (char *)str_Dbox3), 0xA, 0x13);
    jctime(bank);
    sub_8E9C0(0xF8, 0xFF);
    if (sounddev == 0x10) {
        sub_91964((char *)str_Music2, 0x60, 0xAA);
        sub_91964((char *)str_Sound2, 0x60, 0xC0);
    }
    if (!musicon) sub_91964((char *)str_DigitizedSpeech2, 0x60, 0xD6);
    sub_B4BA8();
    DrawSettingsHeading(0xA, 0x13, 4, gamemode, 0xFA);
}
