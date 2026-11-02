/* Scoreboard graphics: Stanley Cup final. */
#include "nhl95.h"

/* LoadCupFinalSeries: for a final between the two conferences (teamdivflags bits 0-1 and 2-3 both set) load the
 7 final-series games (6-byte records from game 4A6h of the schedule database) into a new STANLEY buffer
 cupseries; otherwise cupseries 0. */
typedef struct Game6 { char c[6]; } Game6;

void LoadCupFinalSeries(void)
{
    char *db;
    int f;
    int i;

    f = teamdivflags[HomeTeam] | teamdivflags[VisTeam];
    if ((f & 3) && (f & 0xC)) {
        cupseries = sub_8CCA8((char *)str_Stanley, 0x2A, 0x20);
        LoadScheduleDB((int *)&db);
        f = (int)db + 2;                        /* skip the database header word (f reused) */
        db = (char *)f;
        for (i = 0; i < 7; i++) ((Game6 *)cupseries)[i] = ((Game6 *)db)[i + 0x4A6];
        f = (int)db - 2;
        db = (char *)f;
        if (f) FreeMemBlock(f);
    } else {
        cupseries = 0;
    }
}
