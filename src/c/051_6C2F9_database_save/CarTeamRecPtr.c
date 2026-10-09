/* Database save: career team record pointers. */
#include "nhl95.h"

/* CarTeamRecPtr (6CB6B) - address of team record number team in the career team database (4Ch bytes each). */
unsigned char *CarTeamRecPtr(int team)
{
    return carteamsdb + team * 0x4C;
}
