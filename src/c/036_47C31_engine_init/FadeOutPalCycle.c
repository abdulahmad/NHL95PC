/* Engine init: loading screen. */
#include "nhl95.h"

/* FadeOutPalCycle (47C31) - end the loading screen palette cycle: step all 3 loadpals palettes down to black (one level
   per 2 ticks, the cycle locked while changing them), then remove the LoadScreenPalTick timer and clear
   loadscreenon. */
void FadeOutPalCycle(void)
{
    int done;
    int i;
    int j;
    signed char c;

    if (!loadscreenon) return;
    done = 0;
    while (!done) {
        palcyclelock = done = 1;
        for (i = 0; i < 3; i++) {
            for (j = 0; j < 0x300; j++) {
                c = loadpals[i * 0x300 + j];
                if (c > 0) {
                    loadpals[i * 0x300 + j] = c - 1;
                    if (done == 1) done = 0;
                }
            }
        }
        palcyclelock = 0;
        sub_B3989(2);
        sub_B3999();
    }
    palcyclelock = 1;
    sub_8E4F8(LoadScreenPalTick);
    loadscreenon = 0;
}
