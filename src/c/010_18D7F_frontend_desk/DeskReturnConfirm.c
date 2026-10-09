/* Front end: sports desk. */
#include "nhl95.h"

/* DeskReturnConfirm (1A5D4) - "Returning to Sports Central / the playoff / out of the league ... Do you wish to
   return?" (by gamemode) at the mouse position; on yes set dword_C66D0 / C66D4 and return 5, else 0. */
int DeskReturnConfirm(void)
{
    int x;
    int y;
    int r;

    sub_B2DCA(&x, &y, &r);
    switch ((unsigned)gamemode) {
    case 0:
        dword_C66A4 = (int)str_ReturningToSportsCentral;
        break;
    case 2:
        dword_C66A4 = (int)str_ReturningOutOfThe;
        break;
    case 1:
        dword_C66A4 = (int)str_ReturningToThePlayoff;
        break;
    }
    dword_C66AC = (int)str_DoYouWishToReturn;
    SetDialogColors(0xF9, 0xFA, 0xF8, 0xFA, 0);
    r = MessageBox(-1, -1, (char *)&dword_C66A4, 3, (int)btn_POHumanOut, 2, (int)&x, (int)&y, -1);
    if (r <= 0) return 0;
    dword_C66D0 = dword_C66D4 = 1;
    return 5;
}
