/* Joystick calibration file: central registry menu. */
#include "nhl95.h"

/* MenuCentralRegistry: menu "central registry": with music on stop the speech bank's sample
 (PushMemDescriptorLocked of +3B60h); screen pitch A0h, dword_C71E0 = 0; run the roster editor (RunEditRosters), then free the
 free-agent selection and list (falistsel falist); with music on reload the speech slots (size SpeechSlotMemSize,
 cursndbank = 20h around it). Returns 2. */
int MenuCentralRegistry(void)
{
    if (musicon) PushMemDescriptorLocked(*(int *)((char *)speechbank + 0x3B60));
    *(int *)&scrpitch = 0xA0;
    dword_C71E0 = 0;
    RunEditRosters();
    if (falistsel) {
        FreeMemBlock(falistsel);
        falistsel = 0;
    }
    if (falist) {
        FreeMemBlock((int)falist);
        falist = 0;
    }
    if (musicon) {
        cursndbank = 0x20;
        InitSpeechSlots(SpeechSlotMemSize);
        cursndbank = 0;
    }
    return 2;
}
