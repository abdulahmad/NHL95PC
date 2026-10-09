/* Database save: roster panels. */
#include "nhl95.h"

/* DrawRosterPanel (6D299) - draw the left (side 0) or right (side 1) roster panel: title and list, then the database
   name. */
void DrawRosterPanel(int side)
{
    if (!side) {
        DrawRosterTitle(0x64, 0x25, 0);
        DrawRosterList(0x2D, 0x35, 0);
    } else {
        DrawRosterTitle(0x19E, 0x25, 1);
        DrawRosterList(0x167, 0x35, 1);
    }
    DrawDatabaseName();
}
