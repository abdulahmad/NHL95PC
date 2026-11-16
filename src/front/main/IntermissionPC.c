/* Main startup: intermission. */
#include "nhl95.h"

/* IntermissionPC: between periods: unless the game is being left (exitgame -1) fade the rink out, set 640x480,
 stop the crowd, music (or the sound library) and digital speech and wait (sub_1BAF3 222E0h); then the
 intermission desk with the small font, and on to the next period. */
void IntermissionPC(void)
{
    if (exitgame != -1) {
        SetPalette(0, 0x100, savepal);
        FadePalette(1, savepal, 0x10);
        SetScreenSize(0x280, 0x1E0);
        CrowdFadeOut();
        if (musicon) MusicChanReset();
        else ReleaseAllVoices();
        StopDigiSample();
        sub_1BAF3(0x222E0);
    }
    TextSetFont(s1font);
    IntermissionDesk();
    curperiod++;
}
