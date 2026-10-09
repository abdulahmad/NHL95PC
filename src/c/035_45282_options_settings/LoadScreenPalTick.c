/* Options / settings: loading screen palette cycle. */
#include "nhl95.h"

/* LoadScreenPalTick (47951) - timer tick for the loading screen: every 4th call (palcycledelay) step palcyclephase
   through the 3 palettes of loadpals (300h bytes each) and load it after a retrace; palcyclelock guards
   re-entry. */
void LoadScreenPalTick(void)
{
    if (palcyclelock == 1) return;
    if (palcycledelay > 0) {
        palcycledelay--;
        return;
    }
    palcyclelock = 1;
    palcycledelay = 3;
    palcyclephase = (palcyclephase + 1) % 3;
    sub_B4C61();
    sub_B4B88(0, 0x100, loadpals + palcyclephase * 0x300);
    palcyclelock = 0;
}
