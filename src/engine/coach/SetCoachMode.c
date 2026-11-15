/* Engine core: coach AI. */
#include "nhl95.h"

/* SetCoachMode: third-period coach AI mode of the home (away 0) or away team from the score difference d
 (home - away). Home: trailing by 2+ -> mode 5; leading by 4+ -> D9Ah mode 4 with 3/2; else CCCh mode 0
 (flag bit 0 cleared each time). Away: home leading by 2+ -> mode 8; home trailing by 4+ -> D9Ah with 3/2,
 else CCCh, mode 1 (flag bit 0 set each time). Returns d (left in ax by the original); the away trailing test
 and its return go through an int copy (`cwde` in place). */
short SetCoachMode(int away)
{
    short d;
    unsigned char f;
    int di;
    int dw;

    d = hmscore[0] - awscore;
    if (away == 0) {
        di = d;
        f = hmtmcoachflags & 0xFE;
        if (di < -1) {
            hmtmcoachflags = f;
            hmtmcoachmode = 5;
            return d;
        }
        if (d > 3) {
            hmtmcoachenergy = 0xD9A;
            hmtmcoachflags = f;
            hmtmcoachmode = 4;
            hmtmcoach_d2 = 3;
            hmtmcoach_d3 = 2;
            return d;
        }
        hmtmcoachenergy = 0xCCC;
        hmtmcoachmode = 0;
        hmtmcoachflags = f;
        return d;
    }
    f = awtmcoachflags | 1;
    if (d > 1) {
        awtmcoachflags = f;
        awtmcoachmode = 8;
        return d;
    }
    dw = d;
    if (dw < -3) {
        awtmcoachenergy = 0xD9A;
        awtmcoach_d2 = 3;
        awtmcoach_d3 = 2;
    } else {
        awtmcoachenergy = 0xCCC;
    }
    awtmcoachflags = f;
    awtmcoachmode = 1;
    return dw;
}
