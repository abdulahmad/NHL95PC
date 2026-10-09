/* Settings / locker room: sound card dialog. */
#include "nhl95.h"

typedef struct Hdr17 { char c[17]; } Hdr17;

/* MenuSoundSettings (82579) - menu "sound settings": without music playing (music off or no song) reserve the
   320 KB TEMP buffer (dword_D2435); save the screen under the 128 x 190 dialog at 10 / 13h into a BUFFER bitmap
   (pointer sprite header), draw the sound card dialog and its options, run it, then restore the screen and free
   the bitmap. Returns 0. */
int MenuSoundSettings(void)
{
    int bm;

    if (!musicon || !songdata) dword_D2435 = sub_8CCA8((char *)str_Temp8, 0x4E200, 0);
    bm = sub_8CCA8((char *)str_Buffer, 0x5F11, 0);
    *(Hdr17 *)bm = *(Hdr17 *)pointerspr;
    ((short *)bm)[2] = 0x80;
    ((short *)bm)[3] = 0xBE;
    sub_91400(bm, 0xA, 0x13);
    DrawSoundCardDlg();
    DrawSoundCardOpts();
    SoundCardDlgLoop();
    sub_903F0(bm, 0xA, 0x13);
    jctime(bm);
    return 0;
}
