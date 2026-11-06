/* Database save: team database record pointers. */
#include "nhl95.h"

/* TeamRecPtr: address of team record number team in the team database (2E8h bytes per team). */
unsigned char *TeamRecPtr(int team)
{
    return teamsdb + team * 0x2E8;
}
