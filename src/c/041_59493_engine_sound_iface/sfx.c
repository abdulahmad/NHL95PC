/* Engine sound interface: sound effects. */
#include "nhl95.h"

/* sfx (59884) - play sound effect id (remembered in lastsfx): while speech plays only 9Ch passes (and in a replay only
   with dword_CCC98); A0h/A1h not on sound devices 4/8; 7Dh raises crowdlevel by 500; AAh on device 4 starts
   sample dword_ED7A4; 90h also plays 91h (both on device 4). */
void sfx(int id)
{
    lastsfx = id;
    if (PaSpeechBusy()) {
        if (id != 0x9C) return;
        if (gmode & 0x10 && !dword_CCC98) return;
    }
    switch (sounddev) {
    case 8:
    case 4:
        if (id == 0xA0 || id == 0xA1) return;
    }
    if (id == 0x7D) {
        crowdlevel += 500;
        return;
    }
    if (sounddev == 4 && id == 0xAA) {
        sub_8F270((void *)dword_ED7A4, dword_D2427);
        return;
    }
    if (id == 0x90) {
        if (sounddev == 4) sub_8F61D((unsigned short)id);
        id++;
    }
    sub_8F61D((unsigned short)id);
}
