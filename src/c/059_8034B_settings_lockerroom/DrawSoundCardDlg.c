/* Settings / locker room: sound card dialog. */
#include "nhl95.h"

/* DrawSoundCardDlg (8261C) - draw the sound card dialog box: load the SOUND bank (from the CD when fileoncd says so),
   draw its DBX art at 10 / 13h and free the bank (jctime). */
void DrawSoundCardDlg(void)
{
    char path[32];
    int bank;

    sub_B4BA8();
    MakePath(path, fileoncd[0x191] == 1 ? (char *)cddriveptr : 0, (char *)str_Sound4, 0);
    bank = sub_8E83C(path, 0);
    sub_91284(sub_B30B4(bank, (char *)str_Dbx2), 0xA, 0x13);
    jctime(bank);
}
