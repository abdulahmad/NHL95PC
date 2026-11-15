/* Engine core: raise the coach lines as the score and the clock change. */
#include "nhl95.h"

/* UpdateCoachModes: while the game is running, set each coach from the score
 and, late in the period, push the lines toward a lead or a deficit. diff is
 the home score minus the away score and stays in dx across SetCoachMode.
 Period 2 only adjusts at 10:00. Period 3 walks the clock down: one else-if
 chain per side, whose equal arms Watcom merges into the EXE's shared line
 setups (the jumps back into an earlier arm). */
void UpdateCoachModes(void)
{
    short diff;
    unsigned char prev;

    if (gmode & 0x10)
        return;
    diff = hmscore[0];
    diff -= awscore;
    if (curperiod == 2 && gameclock <= 0x258) {
        prev = hmtmcoachmode;
        SetCoachMode(0);
        if (prev != hmtmcoachmode)
            hmtmcoachflags |= 0x40;
        prev = awtmcoachmode;
        SetCoachMode(1);
        if (prev != awtmcoachmode)
            awtmcoachflags |= 0x40;
        if (gameclock != 0x258)
            return;
        if (diff < -1) {
            if (hmtmcoach_d2 < 4)
                hmtmcoach_d2++;
            if (hmtmcoach_d3 > 1)
                hmtmcoach_d3--;
        }
        if (diff > 1) {
            if (awtmcoach_d2 < 4)
                awtmcoach_d2++;
            if (awtmcoach_d3 > 1)
                awtmcoach_d3--;
        }
        return;
    }
    if (curperiod != 3)
        return;
    prev = hmtmcoachmode;
    if (gameclock <= 0x3C && diff <= -1) {
        hmtmcoachenergy = 0xB33;
        hmtmcoachflags |= 1;
        hmtmcoachmode = 6;
        hmtmcoach_d2 = 4;
        hmtmcoach_d3 = 1;
    } else if (gameclock <= 0x78 && diff < -1) {
        hmtmcoachenergy = 0xB33;
        hmtmcoachflags |= 1;
        hmtmcoachmode = 6;
        hmtmcoach_d2 = 4;
        hmtmcoach_d3 = 1;
    } else if (gameclock <= 0xB4 && diff <= -1) {
        hmtmcoachenergy = 0xB33;
        hmtmcoachflags |= 1;
        hmtmcoachmode = 7;
        hmtmcoach_d2 = 4;
        hmtmcoach_d3 = 1;
    } else if (gameclock <= 0x12C && diff < -1) {
        hmtmcoachenergy = 0xB33;
        hmtmcoachflags |= 1;
        hmtmcoachmode = 7;
        hmtmcoach_d2 = 4;
        hmtmcoach_d3 = 1;
    } else if (gameclock <= 0x258) {
        if (diff < -1) {
            hmtmcoachenergy = 0xB33;
            hmtmcoachflags |= 1;
            hmtmcoachmode = 0x0A;
            hmtmcoach_d2 = 4;
            hmtmcoach_d3 = 1;
        } else {
            if (diff > 2)
                hmtmcoachenergy = 0xCCC;
            else
                hmtmcoachenergy = 0xD9A;
            hmtmcoachflags &= 0xFE;
            hmtmcoachmode = 3;
            hmtmcoach_d2 = 3;
            hmtmcoach_d3 = 2;
        }
    } else
        SetCoachMode(0);
    if (prev != hmtmcoachmode)
        hmtmcoachflags |= 0x40;
    prev = awtmcoachmode;
    if (gameclock <= 0x3C && diff >= 1) {
        awtmcoachenergy = 0xB33;
        awtmcoachflags |= 1;
        awtmcoachmode = 6;
        awtmcoach_d2 = 4;
        awtmcoach_d3 = 1;
    } else if (gameclock <= 0x78 && diff > 1) {
        awtmcoachenergy = 0xB33;
        awtmcoachflags |= 1;
        awtmcoachmode = 6;
        awtmcoach_d2 = 4;
        awtmcoach_d3 = 1;
    } else if (gameclock <= 0xB4 && diff > 1) {
        awtmcoachenergy = 0xB33;
        awtmcoachflags |= 1;
        awtmcoachmode = 7;
        awtmcoach_d2 = 4;
        awtmcoach_d3 = 1;
    } else if (gameclock <= 0x12C && diff > 1) {
        awtmcoachenergy = 0xB33;
        awtmcoachflags |= 1;
        awtmcoachmode = 7;
        awtmcoach_d2 = 4;
        awtmcoach_d3 = 1;
    } else if (gameclock <= 0x258) {
        if (diff > 1) {
            awtmcoachenergy = 0xB33;
            awtmcoachflags |= 1;
            awtmcoachmode = 0x0A;
            awtmcoach_d2 = 4;
            awtmcoach_d3 = 1;
        } else {
            if (diff < -2) {
                awtmcoachenergy = 0xCCC;
                awtmcoachmode = 9;
            } else {
                awtmcoachenergy = 0xD9A;
                awtmcoachmode = 8;
            }
            awtmcoachflags |= 1;
            awtmcoach_d2 = 3;
            awtmcoach_d3 = 2;
        }
    } else
        SetCoachMode(1);
    if (prev != awtmcoachmode)
        awtmcoachflags |= 0x40;
}
