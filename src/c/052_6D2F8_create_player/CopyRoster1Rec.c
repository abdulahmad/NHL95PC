/* Create player: roster record copy. */
#include "nhl95.h"

typedef struct { int d[0xBA]; } RosterRec;      /* 2E8h bytes: one team database record */

/* CopyRoster1Rec (6DE4C) - roster editor mode 2 (dword_D0B12): copy the current team record (rosterteamrec) into the
   edit buffer and redraw the roster editor. */
void CopyRoster1Rec(void)
{
    dword_D0B12 = 2;
    *(RosterRec *)unk_EAFB8 = *(RosterRec *)rosterteamrec[0];
    DrawEditRosters();
}
