/* Settings locker room: sound card dialog. */
#include "nhl95.h"

/* RedrawSoundCardOpts: draw the eight sound card boxes on or off by setbits and print the names of the cards not
 present (sndcardmissing bits clear) in grey: PC Speaker, Sound Blaster, AdLib, MT-32, UltraSound. */
void RedrawSoundCardOpts(void)
{
    int i;
    Rect4 *r;

    for (i = 0; i < 8; i++) {
        if (setbits[0] & (1 << i)) DrawSelBoxOn((Rect4 *)soundcardrects + i);
        else DrawSelBoxOff((Rect4 *)soundcardrects + i);
    }
    r = (Rect4 *)soundcardrects;
    TextSetColors(0xF8, 0xFF);
    if (!(sndcardmissing & 1)) PrintString((char *)str_PCSpeaker, r->l + 0x18, r->t + 0x13);
    r++;
    if (!(sndcardmissing & 2)) PrintString((char *)str_SoundBlaster, r->l + 0x0E, r->t + 0x13);
    r++;
    if (!(sndcardmissing & 4)) PrintString((char *)str_ADLib, r->l + 0x29, r->t + 0x13);
    r++;
    if (!(sndcardmissing & 8)) PrintString((char *)str_MT32, r->l + 0x28, r->t + 0x13);
    r += 2;
    if (!(sndcardmissing & 0x20)) PrintString((char *)str_UltraSound, r->l + 0x18, r->t + 0x13);
}
