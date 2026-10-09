/* Settings dialogs: options to check bits. */
#include "nhl95.h"

/* LeagueOptsToBits (7A88E) - like ExhOptsToBits for the league settings dialog, plus the league option in bits 12-14 as
   one check bit (1 -> 10h, 3 -> 20h, 5 -> 40h, 7 -> 80h in the second byte), then draw the checks. */
void LeagueOptsToBits(void)
{
    setbits[0] = gameopts.optbit0 | gameopts.offsides << 1 | gameopts.linechanges << 2
        | gameopts.twolinepass << 3 | gameopts.optbit4 << 4 | gameopts.optbit5 << 5
        | ((sounddev & 0x10) ? 0 : gameopts.music << 6)
        | ((sounddev & 0x10) ? 0 : gameopts.sfx << 7)
        | ((sounddev & 0x22) ? gameopts.speech << 8 : 0);
    switch (gameopts.pertime) {
    case 2: ((unsigned char *)setbits)[1] |= 2; break;
    case 1: ((unsigned char *)setbits)[1] |= 4; break;
    case 0: ((unsigned char *)setbits)[1] |= 8; break;
    }
    switch (gameopts.optbits12) {
    case 1: ((unsigned char *)setbits)[1] |= 0x10; break;
    case 3: ((unsigned char *)setbits)[1] |= 0x20; break;
    case 5: ((unsigned char *)setbits)[1] |= 0x40; break;
    case 7: ((unsigned char *)setbits)[1] |= 0x80; break;
    }
    DrawLeagueSetChecks();
}
