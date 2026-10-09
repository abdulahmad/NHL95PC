/* Engine display: dressed-player flags. */
#include "nhl95.h"

/* NormalizeDressFlags (65B48) - turn the two 25-entry dress flag tables (byte_E9E18, byte_E9E31) into 0 / 1 (1 only
   where the entry was exactly 1). */
void NormalizeDressFlags(void)
{
    int i;

    for (i = 0; i < 25; i++) {
        byte_E9E18[i] = byte_E9E18[i] == 1;
        byte_E9E31[i] = byte_E9E31[i] == 1;
    }
}
