/* Create player: roster record copy. */
#include "nhl95.h"

typedef struct { int d[0xBA]; } RosterRec;      /* 2E8h bytes: one team database record */

/* CopyRoster1Rec: roster editor mode 2 (rostereditmode): copy the current team record (rosterteamrec) into the
 edit buffer and redraw the roster editor. */
void CopyRoster1Rec(void)
{
    rostereditmode = 2;
    *(RosterRec *)rosterteamcopy = *(RosterRec *)rosterteamrec[0];
    DrawEditRosters();
}
