/* Asset loading: rink end overlay. */
#include "nhl95.h"

/* LoadTransparentRinkEndOverlay: load the transparent rink end bank (TRINKND.PPV, from the CD when fileoncd
 says so) into rinkendbank and its art 0000 into rinkendart. */
void LoadTransparentRinkEndOverlay(void)
{
    char path[16];

    MakePath(path, fileoncd[0x1AA] == 1 ? (char *)cddriveptr : 0, (char *)str_Trinknd, (char *)str_PPV);
    rinkendbank = OpenArtArchiveErr(path, 0x20);
    rinkendart = FindShape(rinkendbank, (char *)str_0000);
}
