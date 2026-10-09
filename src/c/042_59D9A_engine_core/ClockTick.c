/* Engine core: game clock. */
#include "nhl95.h"

#define CLK (*(int *)((char *)&gameclock - 2) >> 16)  /* gameclock, read as the top word of a dword */

/* ClockTick (5DC10) - PC-new, run from the main loop. During a penalty shot replay (penshotlive) count penshottimer
   down and end it (EndPenaltyShot) at 0. Otherwise, while there is time left, count clockticks (18h per second) and
   the game clock (seconds) down. At 61 / 60 s the horn (sfx 97h), or with music and announcer on the "one minute
   left" call at 60 s (joystick sampling paused). On each full minute: UpdateCoachModes in the third period at 1, 2,
   3, 5 and 10 minutes left, in the second at 10. */
void ClockTick(void)
{
    short t;

    if (penshotlive) {
        if (--penshottimer <= 0) EndPenaltyShot();
        return;
    }
    if (gameclock == 0 && clockticks[0] == 0) return;
    if ((t = --clockticks[0]) >= 0) return;
    if (gameclock > 0) {
        gameclock = gameclock - 1;
        clockticks[0] = t + 0x18;
    } else {
        clockticks[0] = 0;
    }
    if (gameclock == 0x3D || gameclock == 0x3C) {
        if (!musicon || !gameopts.speech) {
            sfx(0x97);
        } else if (gameclock == 0x3C) {
            joysampling_save = joysampling;
            joysampling = 0;
            PaOneMinuteLeft();
            joysampling = *(int *)((char *)&joysampling_save - 2) >> 16;
        }
    }
    if (CLK % 60 != 0) return;
    if (curperiod == 3 && (gameclock == 60 || gameclock == 120 || gameclock == 180 || gameclock == 300
                           || gameclock == 600)) {
        UpdateCoachModes();
        return;
    }
    if (curperiod == 2 && gameclock == 600) UpdateCoachModes();
}
