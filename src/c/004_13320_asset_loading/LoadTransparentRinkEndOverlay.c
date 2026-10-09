/* Asset loading: rink end overlay. */
#include "nhl95.h"

/* LoadTransparentRinkEndOverlay (13A2F) - load the transparent rink end bank (TRINKND.PPV, from the CD when fileoncd
   says so) into rinkendbank and its art 0000 into rinkendart. */
void LoadTransparentRinkEndOverlay(void)
{
    char path[16];

    MakePath(path, fileoncd[0x1AA] == 1 ? (char *)cddriveptr : 0, (char *)str_Trinknd, (char *)str_PPV);
    rinkendbank = sub_8E8A0(path, 0x20);
    rinkendart = sub_B30B4(rinkendbank, (char *)str_0000);
}
