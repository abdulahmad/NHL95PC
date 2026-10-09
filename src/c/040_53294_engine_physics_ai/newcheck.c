/* Engine physics / AI: check sounds (93G newcheck). */
#include "nhl95.h"

/* newcheck (58084) - body check sound: kind 2 adds sfx B1h; a hard hit (kind != 0) when word_E9B28 > 20h has a 1 in 2
   chance of sfx 93h, otherwise alternate sfx B0h / B2h (word_CC0DA toggles). */
void newcheck(short kind)
{
    if (kind == 2) sfx(0xB1);
    if (kind && word_E9B28 > 0x20 && !randomd0(2)) {
        kind = 0x93;
    } else {
        kind = word_CC0DA == 0;
        word_CC0DA = kind;
        if (kind) kind = 0xB0;
        else kind = 0xB2;
    }
    sfx(kind);
}
