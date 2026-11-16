/* Engine sound interface: sound effects. */
#include "nhl95.h"

/* sfx: play sound effect id (remembered in lastsfx): while speech plays only 9Ch passes (and in a replay only
 with oneminsaid); A0h/A1h not on sound devices 4/8; 7Dh raises Crowdlevel by 500; AAh on device 4 starts
 sample SfxTestSample; 90h also plays 91h (both on device 4). */
void sfx(int id)
{
    lastsfx = id;
    if (PaSpeechBusy()) {
        if (id != 0x9C) return;
        if (gmode & 0x10 && !oneminsaid) return;
    }
    if (sounddev == 8 || sounddev == 4) {
        if (id == 0xA0 || id == 0xA1) return;
    }
    if (id == 0x7D) {
        Crowdlevel += 500;
        return;
    }
    if (sounddev == 4 && id == 0xAA) {
        PlaySong((void *)SfxTestSample, musicdriver);
        return;
    }
    if (id == 0x90) {
        if (sounddev == 4) PlayPatchFull((unsigned short)id);
        id++;
    }
    PlayPatchFull((unsigned short)id);
}
