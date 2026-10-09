/* Engine core: coach AI. */
#include "nhl95.h"

/* SetCoachMode (5A581) - third-period coach AI mode of the home (away 0) or away team from the score difference d
   (home - away). Home: trailing by 2+ -> mode 5; leading by 4+ -> D9Ah / mode 4 with 3/2; else CCCh / mode 0
   (flag bit 0 cleared each time). Away: home leading by 2+ -> mode 8; home trailing by 4+ -> D9Ah with 3/2,
   else CCCh, mode 1 (flag bit 0 set each time). Returns d (left in ax by the original). */
short SetCoachMode(int away)
{
    short d;
    unsigned char f;
    int di;

    d = hmscore[0] - awscore;
    if (away == 0) {
        di = d;
        f = byte_DF6E8 & 0xFE;
        if (di < -1) {
            byte_DF6E8 = f;
            byte_DF6E9 = 5;
            return d;
        }
        if (d > 3) {
            dword_DF6EA = 0xD9A;
            byte_DF6E8 = f;
            byte_DF6E9 = 4;
            byte_DF6E6 = 3;
            byte_DF6E7 = 2;
            return d;
        }
        dword_DF6EA = 0xCCC;
        byte_DF6E9 = 0;
        byte_DF6E8 = f;
        return d;
    }
    f = byte_DF7E8 | 1;
    if (d > 1) {
        byte_DF7E8 = f;
        byte_DF7E9 = 8;
        return d;
    }
    if (d < -3) {
        dword_DF7EA = 0xD9A;
        byte_DF7E6 = 3;
        byte_DF7E7 = 2;
    } else {
        dword_DF7EA = 0xCCC;
    }
    byte_DF7E8 = f;
    byte_DF7E9 = 1;
    return d;
}
