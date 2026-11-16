/* Settings locker room: sound card dialog. */
#include "nhl95.h"

/* DrawSoundCardDlg: draw the sound card dialog box: load the SOUND bank (from the CD when fileoncd says so),
 draw its DBX art at 10 13h and free the bank (FreeMemBlock). */
void DrawSoundCardDlg(void)
{
    char path[32];
    int bank;

    SetScreenTarget();
    MakePath(path, fileoncd[0x191] == 1 ? (char *)cddriveptr : 0, (char *)str_Sound4, 0);
    bank = LoadBank(path, 0);
    DrawArtKeyFF(FindShape(bank, (char *)str_Dbx2), 0xA, 0x13);
    FreeMemBlock(bank);
}
