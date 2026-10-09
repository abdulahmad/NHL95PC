/* Joystick calibration file: central registry menu. */
#include "nhl95.h"

/* MenuCentralRegistry (6BE95) - menu "central registry": with music on stop the speech bank's sample
   (sub_8D2F0 of +3B60h); screen pitch A0h, dword_C71E0 = 0; run the roster editor (RunEditRosters), then free the
   free-agent selection and list (falistsel / falist); with music on reload the speech slots (size dword_C4CFC,
   dword_CCC94 = 20h around it). Returns 2. */
int MenuCentralRegistry(void)
{
    if (musicon) sub_8D2F0(*(int *)((char *)speechbank + 0x3B60));
    *(int *)&scrpitch = 0xA0;
    dword_C71E0 = 0;
    RunEditRosters();
    if (falistsel) {
        jctime(falistsel);
        falistsel = 0;
    }
    if (falist) {
        jctime((int)falist);
        falist = 0;
    }
    if (musicon) {
        dword_CCC94 = 0x20;
        InitSpeechSlots(dword_C4CFC);
        dword_CCC94 = 0;
    }
    return 2;
}
