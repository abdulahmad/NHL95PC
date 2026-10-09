/* ClearSortCords (5BA4E) - PC only (93G defaultsprites2 .0 loop): zero the 17 sort objects of SortCords (12
   players and the other rink objects), 80h bytes each, byte by byte. */
#include "nhl95.h"

void ClearSortCords(void)
{
    short i, k;
    unsigned char *o;

    for (i = 0; i < 17; i++) {
        o = (unsigned char *)&SortCords[i];
        for (k = 0; k < sizeof(Player); k++) *o++ = 0;
    }
}
