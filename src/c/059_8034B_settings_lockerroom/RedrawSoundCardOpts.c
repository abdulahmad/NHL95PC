/* Settings / locker room: sound card dialog. */
#include "nhl95.h"

/* RedrawSoundCardOpts (82805) - draw the eight sound card boxes on or off by setbits and print the names of the cards not
   present (byte_C541B bits clear) in grey: PC Speaker, Sound Blaster, AdLib, MT-32, UltraSound. */
void RedrawSoundCardOpts(void)
{
    int i;
    Rect4 *r;

    for (i = 0; i < 8; i++) {
        if (setbits[0] & (1 << i)) DrawSelBoxOn((Rect4 *)soundcardrects + i);
        else DrawSelBoxOff((Rect4 *)soundcardrects + i);
    }
    r = (Rect4 *)soundcardrects;
    sub_8E9C0(0xF8, 0xFF);
    if (!(byte_C541B & 1)) sub_91964((char *)str_PCSpeaker, r->l + 0x18, r->t + 0x13);
    r++;
    if (!(byte_C541B & 2)) sub_91964((char *)str_SoundBlaster, r->l + 0x0E, r->t + 0x13);
    r++;
    if (!(byte_C541B & 4)) sub_91964((char *)str_ADLib, r->l + 0x29, r->t + 0x13);
    r++;
    if (!(byte_C541B & 8)) sub_91964((char *)str_MT32, r->l + 0x28, r->t + 0x13);
    r += 2;
    if (!(byte_C541B & 0x20)) sub_91964((char *)str_UltraSound, r->l + 0x18, r->t + 0x13);
}
