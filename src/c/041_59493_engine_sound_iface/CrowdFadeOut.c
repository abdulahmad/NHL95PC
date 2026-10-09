/* Engine sound interface: crowd fade. */
#include "nhl95.h"

/* CrowdFadeOut (597E3) - with sound effects on and a crowd-capable sound device (sounddev & 2Ah): lower
   crowdlevel by 50 a tick (sub_B3989(1) / sub_B3999 wait) down to 0, updating the crowd noise each step, then
   switch the crowd noise off and restore crowdlevel to its old value. */
void CrowdFadeOut(void)
{
    int save;

    save = crowdlevel;
    if (gameopts.sfx && (sounddev & 0x2A)) {
        while (crowdlevel > 0) {
            sub_B3989(1);
            crowdlevel -= 50;
            if (crowdlevel < 0) crowdlevel = 0;
            CrowdNoiseUpdate(2);
            sub_B3999();
        }
        CrowdNoiseOff();
        crowdlevel = save;
    }
}
