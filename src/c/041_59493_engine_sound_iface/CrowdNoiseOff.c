/* Engine sound interface: crowd. */
#include "nhl95.h"

/* CrowdNoiseOff (59748) - with sound effects on and an FM / digital card (sounddev & 2Ah): silence and stop the two crowd
   voices (8 and 7) that are playing (crowdvol8 / crowdvol7 > 0). */
void CrowdNoiseOff(void)
{
    if (!gameopts.sfx) return;
    if (!(sounddev & 0x2A)) return;
    if (crowdvol8 > 0) {
        sub_8FDB2(byte_D2439, 8, 0);
        sub_8FE4F(byte_D2439, 8, 0x24);
        crowdvol8 = 0;
    }
    if (crowdvol7 > 0) {
        sub_8FDB2(byte_D2439, 7, 0);
        sub_8FE4F(byte_D2439, 7, 0x24);
        crowdvol7 = 0;
    }
}
