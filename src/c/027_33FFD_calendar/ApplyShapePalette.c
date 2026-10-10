/* Calendar: palette of an art bank. */
#include "nhl95.h"

/* ApplyShapePalette (34789) - find the "Pal17" palette entry of art bank (sub_B30B4) and set it at once
   (FadePalStep 0 with 16 steps on its colours, 10h bytes in). */
void ApplyShapePalette(int bank)
{
    FadePalStep(0, (unsigned char *)sub_B30B4(bank, (char *)str_Pal17) + 0x10, 0x10);
}
