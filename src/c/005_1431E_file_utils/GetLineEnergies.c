/* File utilities: line energy summary. */
#include "nhl95.h"

/* GetLineEnergies (14BEF) - out[0..7] = energy of each line of team (TeamLineEnergy) minus 60h. */
void GetLineEnergies(short team, int *out)
{
    int i;

    for (i = 0; i < 8; i++) out[i] = TeamLineEnergy(team, i) - 0x60;
}
