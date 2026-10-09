/* Season / playoffs: simulate a playoff series. */
#include "nhl95.h"

/* POSimSeriesTo (88625) - PC only: for series n of the league playoff tree (42-byte series from +1998h of lg) that
   is still undecided (SeriesWinner with the series length option, gameopts bits 12-14): open the league's
   databases (leaguedbnames[4] read / write, error "E31"; leaguedbnames[3] read, "E32") and simulate its
   unplayed games (6-byte game records, byte +4 FFh) up to game upto, stopping once the series is decided. */
void POSimSeriesTo(unsigned char *lg, int n, int upto)
{
    unsigned char *g;
    unsigned char *s;
    char path[32];
    int rwfh;
    int rdfh;
    int i;

    g = lg + 0x1998 + n * 42;
    s = g;
    if (SeriesWinner(g, gameopts.optbits12) >= 0) return;
    MakePath(path, (char *)&curleague, (char *)leaguedbnames[4], (char *)str_extDB);
    if (FileOpenRW(path, &rwfh) != 0) FatalError((char *)str_E31);
    MakePath(path, (char *)&curleague, (char *)leaguedbnames[3], (char *)str_extDB);
    if (FileOpenRead(path, &rdfh) != 0) FatalError((char *)str_E32);
    for (i = 0; i < upto; i++, g += 6) {
        if (g[4] == 0xFF) {
            if (SeriesWinner(s, gameopts.optbits12) >= 0) break;
            SimulateGame((char *)&curleague, (char *)str_extDB, 0x4B0, g, rwfh, rdfh, 2);
        }
    }
    FileClose(&rwfh);
    FileClose(&rdfh);
}
