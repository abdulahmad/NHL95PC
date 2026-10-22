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
        prev = byte_DF6E9;
        SetCoachMode(0);
        if (prev != byte_DF6E9)
            byte_DF6E8 |= 0x40;
        prev = byte_DF7E9;
        SetCoachMode(1);
        if (prev != byte_DF7E9)
            byte_DF7E8 |= 0x40;
        if (gameclock != 0x258)
            return;
        if (diff < -1) {
            if (byte_DF6E6 < 4)
                byte_DF6E6++;
            if (byte_DF6E7 > 1)
                byte_DF6E7--;
        }
        if (diff > 1) {
            if (byte_DF7E6 < 4)
                byte_DF7E6++;
            if (byte_DF7E7 > 1)
                byte_DF7E7--;
        }
        return;
    }
    if (curperiod != 3)
        return;
    prev = byte_DF6E9;
    if (gameclock <= 0x3C && diff <= -1) {
        dword_DF6EA = 0xB33;
        byte_DF6E8 |= 1;
        byte_DF6E9 = 6;
        byte_DF6E6 = 4;
        byte_DF6E7 = 1;
    } else if (gameclock <= 0x78 && diff < -1) {
        dword_DF6EA = 0xB33;
        byte_DF6E8 |= 1;
        byte_DF6E9 = 6;
        byte_DF6E6 = 4;
        byte_DF6E7 = 1;
    } else if (gameclock <= 0xB4 && diff <= -1) {
        dword_DF6EA = 0xB33;
        byte_DF6E8 |= 1;
        byte_DF6E9 = 7;
        byte_DF6E6 = 4;
        byte_DF6E7 = 1;
    } else if (gameclock <= 0x12C && diff < -1) {
        dword_DF6EA = 0xB33;
        byte_DF6E8 |= 1;
        byte_DF6E9 = 7;
        byte_DF6E6 = 4;
        byte_DF6E7 = 1;
    } else if (gameclock <= 0x258) {
        if (diff < -1) {
            dword_DF6EA = 0xB33;
            byte_DF6E8 |= 1;
            byte_DF6E9 = 0x0A;
            byte_DF6E6 = 4;
            byte_DF6E7 = 1;
        } else {
            if (diff > 2)
                dword_DF6EA = 0xCCC;
            else
                dword_DF6EA = 0xD9A;
            byte_DF6E8 &= 0xFE;
            byte_DF6E9 = 3;
            byte_DF6E6 = 3;
            byte_DF6E7 = 2;
        }
    } else
        SetCoachMode(0);
    if (prev != byte_DF6E9)
        byte_DF6E8 |= 0x40;
    prev = byte_DF7E9;
    if (gameclock <= 0x3C && diff >= 1) {
        dword_DF7EA = 0xB33;
        byte_DF7E8 |= 1;
        byte_DF7E9 = 6;
        byte_DF7E6 = 4;
        byte_DF7E7 = 1;
    } else if (gameclock <= 0x78 && diff > 1) {
        dword_DF7EA = 0xB33;
        byte_DF7E8 |= 1;
        byte_DF7E9 = 6;
        byte_DF7E6 = 4;
        byte_DF7E7 = 1;
    } else if (gameclock <= 0xB4 && diff > 1) {
        dword_DF7EA = 0xB33;
        byte_DF7E8 |= 1;
        byte_DF7E9 = 7;
        byte_DF7E6 = 4;
        byte_DF7E7 = 1;
    } else if (gameclock <= 0x12C && diff > 1) {
        dword_DF7EA = 0xB33;
        byte_DF7E8 |= 1;
        byte_DF7E9 = 7;
        byte_DF7E6 = 4;
        byte_DF7E7 = 1;
    } else if (gameclock <= 0x258) {
        if (diff > 1) {
            dword_DF7EA = 0xB33;
            byte_DF7E8 |= 1;
            byte_DF7E9 = 0x0A;
            byte_DF7E6 = 4;
            byte_DF7E7 = 1;
        } else {
            if (diff < -2) {
                dword_DF7EA = 0xCCC;
                byte_DF7E9 = 9;
            } else {
                dword_DF7EA = 0xD9A;
                byte_DF7E9 = 8;
            }
            byte_DF7E8 |= 1;
            byte_DF7E6 = 3;
            byte_DF7E7 = 2;
        }
    } else
        SetCoachMode(1);
    if (prev != byte_DF7E9)
        byte_DF7E8 |= 0x40;
}
