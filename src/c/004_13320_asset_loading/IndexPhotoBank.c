/* Asset loading: player photos. */
#include "nhl95.h"

/* IndexPhotoBank (13867) - PC only: look up the 50 photos of photo bank b (entries named "%04d", numbered from
   b * 50) in the bank (sub_B30BB) and store their pointers in photoptrs, up to the 1134 photos. */
void IndexPhotoBank(int b)
{
    char name[12];
    int n;
    int i;

    n = b * 50;
    for (i = 0; i < 50; i++) {
        sprintf(name, (char *)str_04d, n);
        photoptrs[n] = sub_B30BB(photobanks[b], name);
        if (++n >= 1134) break;
    }
}
