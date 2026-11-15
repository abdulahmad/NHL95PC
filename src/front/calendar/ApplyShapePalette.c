/* Calendar: palette of an art bank. */
#include "nhl95.h"

/* ApplyShapePalette: find the "Pal17" palette entry of art bank (FindShape) and set it at once
 (FadePalStep 0 with 16 steps on its colours, 10h bytes in). */
void ApplyShapePalette(int bank)
{
    FadePalStep(0, (unsigned char *)FindShape(bank, (char *)str_Pal17) + 0x10, 0x10);
}
