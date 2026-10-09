/* Settings dialogs: options to check bits. */
#include "nhl95.h"

/* ModeOptsToBits (7B604) - copy the game option bits into the mode-settings dialog check bits (setbits): bits 0-5 as they
   are, music and sound effects only without the 10h sound device, speech only with a 22h device; draw the checks
   and, on a 10h device, print Music/Sound over them (greyed); without music print Digitized Speech greyed. */
void ModeOptsToBits(void)
{
    setbits[0] = gameopts.optbit0 | gameopts.offsides << 1 | gameopts.linechanges << 2
        | gameopts.twolinepass << 3 | gameopts.optbit4 << 4 | gameopts.optbit5 << 5
        | ((sounddev & 0x10) ? 0 : gameopts.music << 6)
        | ((sounddev & 0x10) ? 0 : gameopts.sfx << 7)
        | ((sounddev & 0x22) ? gameopts.speech << 8 : 0);
    DrawModeSetChecks();
    sub_8E9C0(0xF8, 0xFF);
    if (sounddev == 0x10) {
        sub_91964((char *)str_Music2, 0x60, 0xAA);
        sub_91964((char *)str_Sound2, 0x60, 0xC0);
    }
    if (musicon == 0) sub_91964((char *)str_DigitizedSpeech2, 0x60, 0xD6);
    sub_B4BA8();
}
