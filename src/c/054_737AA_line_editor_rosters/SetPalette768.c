/* Line editor / rosters: palette. */
#include "nhl95.h"

/* SetPalette768 (76614) - load a full 256-colour palette (768 bytes of RGB) in two halves of 128 entries, each after a
   retrace. */
void SetPalette768(unsigned char *pal)
{
    int i;
    int o;

    for (i = 0, o = 0; i < 0x100; i += 0x80, o += 0x180) {
        sub_B4C84();
        sub_B4B88(i, 0x80, pal + o);
    }
}
