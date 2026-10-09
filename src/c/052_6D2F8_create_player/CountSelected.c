/* Create player: selection lists. */
#include "nhl95.h"

/* CountSelected (6DA88) - number of nonzero (selected) flags in list: facount entries for the free agent list
   (falistsel), else 1Ch (a roster). */
int CountSelected(char *list)
{
    int k;
    int n;

    n = 0;
    k = (int)list == falistsel ? facount : 0x1C;
    while (k > 0) {
        k--;
        if (*list++) n++;
    }
    return n;
}
