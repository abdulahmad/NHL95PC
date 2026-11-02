/* Engine physics AI: check sounds. */
#include "nhl95.h"

/* newcheck: body check sound: kind 2 adds sfx B1h; a hard hit (kind != 0) when word_E9B28 > 20h has a 1 in 2
 chance of sfx 93h, otherwise alternate sfx B0h B2h (ltack toggles). */
void newcheck(short kind)
{
    if (kind == 2) sfx(0xB1);
    if (kind && word_E9B28 > 0x20 && !randomd0(2)) {
        kind = 0x93;
    } else {
        kind = ltack == 0;
        ltack = kind;
        if (kind) kind = 0xB0;
        else kind = 0xB2;
    }
    sfx(kind);
}
