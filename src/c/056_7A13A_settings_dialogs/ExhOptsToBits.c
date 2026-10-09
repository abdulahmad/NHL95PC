/* Settings dialogs: options to check bits. */
#include "nhl95.h"

/* ExhOptsToBits (7BF56) - like ModeOptsToBits for the exhibition settings dialog, plus the period length option as one of
   three check bits in the second byte (pertime 0 -> 8, 1 -> 4, 2 -> 2); greyed labels drawn after the checks. */
void ExhOptsToBits(void)
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
    DrawExhSetChecks();
    sub_8E9C0(0xF8, 0xFF);
    if (musicon == 0) sub_91964((char *)str_DigitizedSpeech3, 0x60, 0xD6);
    if (sounddev == 0x10) {
        sub_91964((char *)str_Music3, 0x60, 0xAA);
        sub_91964((char *)str_Sound3, 0x60, 0xC0);
    }
}
