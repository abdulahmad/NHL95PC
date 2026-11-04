/* cflags: -od */
/* League schedule: playoff tree of the last playoffs (segment compiled without optimisation). */
#include "nhl95.h"

/* LoadPlayoffModeTree: playoff tree of playoff mode: team names from the stats league's team file
 (ReadTeamNames; else from LSSCHED.DB, opened here), the 15 series pairs from schedule games 444h + 7n, then the
 final's seven games from 4A6h on: count each team's wins (game score bytes +4 +5), the first to 4 is pochampion.
 Closes the file and runs PlayoffTreeScreen when nothing failed. Returns 0.
 The unused 64 bytes, the path, and the schedule record are one buffer: with -od, separate arrays swap
 parameter a with the return temporary. */
int LoadPlayoffModeTree(int a, int b)
{
    short t1;
    short fh;
    short aw;
    short g;
    short idx;
    short hw;
    short t2;
    short err;
    int x0;                     /* unused */
    unsigned char buf[104];

    fh = -1;
    MakePath((char *)(buf + 64), (char *)statsleague, (char *)leaguedbnames[4], (char *)str_extDB);
    err = ReadTeamNames((char *)(buf + 64), (char *)treeteamnames, 0);
    if (err == 0) {
        MakePath((char *)(buf + 64), 0, (char *)str_LSSCHED, (char *)str_extDB);
        err = FileOpenRead((char *)(buf + 64), (int *)&fh);
    }
    for (idx = 0, g = 0; g < 105 && err == 0; g += 7) {
        err = ReadSchedGame(fh, buf + 96, g + 0x444);
        playofftree[idx] = buf[98];
        idx++;
        playofftree[idx] = buf[99];
        idx++;
    }
    hw = 0;
    aw = 0;
    for (g = 0; g < 7 && err == 0; g++) {
        err = ReadSchedGame(fh, buf + 96, g + 0x4A6);
        if (g == 0) {
            t1 = buf[98];
            t2 = buf[99];
        }
        if (buf[100] > buf[101] && buf[98] == t1 || buf[101] > buf[100] && buf[99] == t1) hw++;
        else aw++;
        if (hw == 4 && buf[98] == t1 || aw == 4 && buf[98] == t2) {
            pochampion = buf[98];
            g = 7;
        }
        if (aw == 4 && buf[99] == t2 || hw == 4 && buf[99] == t1) {
            pochampion = buf[99];
            g = 7;
        }
    }
    FileClose((int *)&fh);
    if (err == 0) PlayoffTreeScreen();
    return 0;
}
