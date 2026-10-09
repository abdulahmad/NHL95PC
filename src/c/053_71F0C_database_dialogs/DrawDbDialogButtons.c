/* Database dialogs: dialog buttons. */
#include "nhl95.h"

/* DrawDbDialogButtons (72605) - PC only: draw the database dialog's button labels in colour F8h on FFh. Without a tab
   (fdlgtab < 0): Open, Delete, Done (FAh), Current / Original / Temporary and the no-arrow art. Otherwise the
   Temporary / Original / Current choices not masked off (fdlgmask bits 7 / 6 / 5; Current via sub_92CD0), the tab
   art of tab 0-2 (exhibition / playoffs / league playoffs) and Delete (in FAh on tab 2). */
void DrawDbDialogButtons(void)
{
    sub_8E9C0(0xF8, 0xFF);
    if (fdlgtab < 0) {
        sub_91964((char *)str_Open4, 0x2D, 0xC0);
        sub_91964((char *)str_Delete2, 0x6E, 0xC0);
        sub_8E9C0(0xFA, 0xFF);
        sub_91964((char *)str_Done2, 0xB5, 0xC0);
        sub_8E9C0(0xF8, 0xFF);
        sub_91964((char *)str_Current4, 0xB1, 0x4C);
        sub_91964((char *)str_Original2, 0xB1, 0x64);
        sub_91964((char *)str_Temporary, 0xA7, 0x7C);
        sub_91370(fdlg_noarrow, 0x18, 0x46);
        return;
    }
    if (!(fdlgmask[0] & 0x80)) sub_91964((char *)str_Temporary, 0xA7, 0x7C);
    if (!(fdlgmask[0] & 0x40)) sub_91964((char *)str_Original2, 0xB1, 0x64);
    if (!(fdlgmask[0] & 0x20)) sub_92CD0((char *)str_Current4, 0xB1, 0x4C);
    switch ((unsigned)fdlgtab) {
    case 0:
        sub_91370(fdlg_tabexh, 0xA3, 0x4B);
        break;
    case 1:
        sub_91370(fdlg_tabpo, 0xA3, 0x4B);
        break;
    case 2:
        sub_91370(fdlg_tablp, 0xA3, 0x4B);
        break;
    }
    if (fdlgtab == 2) sub_8E9C0(0xFA, 0xFF);
    sub_91964((char *)str_Delete2, 0x6E, 0xC0);
    sub_8E9C0(0xF8, 0xFF);
}
