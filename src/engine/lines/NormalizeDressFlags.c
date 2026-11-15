/* Engine display: dressed-player flags. */
#include "nhl95.h"

/* NormalizeDressFlags: turn the two 25-entry dress flag tables (dressflags, dressflags_aw) into 0 1 (1 only
 where the entry was exactly 1). */
void NormalizeDressFlags(void)
{
    int i;

    for (i = 0; i < 25; i++) {
        dressflags[i] = dressflags[i] == 1;
        dressflags_aw[i] = dressflags_aw[i] == 1;
    }
}
