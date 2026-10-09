/* Engine sound interface: crowd samples. */
#include "nhl95.h"

/* PlayCrowdSample (59A11) - PC only: play crowd cue n. Below 6: the rock cue rockteamcues[n] when loaded (then
   n becomes 12, nothing more), else a random cue 6-8. Cues 6-8 play dword_ED374[n], 9-11 leaguesetimg[n] (the
   tables as the original indexes them); 12 and up play nothing. */
void PlayCrowdSample(int n)
{
    if (n < 6) {
        if (rockteamcues[n] != 0) {
            PlayDigiSample((void *)rockteamcues[n]);
            n = 12;
        } else {
            n = (rand() & 0x7FFF) % 3 + 6;
        }
    }
    if (n < 9) PlayDigiSample((void *)dword_ED374[n]);
    else if (n < 12) PlayDigiSample((void *)leaguesetimg[n]);
}
