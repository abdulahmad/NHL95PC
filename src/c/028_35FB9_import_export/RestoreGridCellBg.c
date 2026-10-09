/* Import / export: grid cell background. */
#include "nhl95.h"

/* RestoreGridCellBg (37E5B) - put the saved grid cell background back at (gridcellx, gridcelly) and free it. The two
   arguments are not used (they arrive in eax / edx and edx is not saved). */
void RestoreGridCellBg(int unused1, int unused2)
{
    if (gridcellbuf) {
        sub_903F0(gridcellbuf, gridcellx, gridcelly);
        jctime(gridcellbuf);
        gridcellbuf = 0;
    }
}
