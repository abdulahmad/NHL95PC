/* CrowdNoiseReset (59863) - PC only: reset the crowd noise mixer state: the smoothed crowd level (crowdsmooth)
   and the two crowd channel volumes (crowdvol8, crowdvol7). Called with crowdlevel = 0 at game start. */
#include "nhl95.h"

void CrowdNoiseReset(void)
{
    crowdvol7 = crowdvol8 = crowdsmooth = 0;
}
