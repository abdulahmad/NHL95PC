/* cflags: -od */
/* League schedule: playoff tree of the last playoffs (segment compiled without optimisation). */
#include "nhl95.h"

/* LoadPlayoffModeTree (2970A) - PC only: playoff tree of playoff mode: team names from the stats league's team file
   (ReadTeamNames; else from LSSCHED.DB, opened here), the 15 series pairs from schedule games 444h + 7n, then the
   final's seven games from 4A6h on: count each team's wins (game score bytes +4 / +5), the first to 4 is pochampion.
   Closes the file and runs PlayoffTreeScreen when nothing failed. Returns 0.
   Draft: all code matches; only a (ebp-30h in the asm) and the return temporary (-2Ch) trade slots. Tried
   extra unused ints / arrays and array orders (LoadLeagueTree matched that way). */
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
    unsigned char rec[8];
    char path[32];
    char s[64];                 /* unused */

    fh = -1;
    MakePath(path, (char *)statsleague, (char *)leaguedbnames[4], (char *)str_extDB);
    err = ReadTeamNames(path, (char *)treeteamnames, 0);
    if (err == 0) {
        MakePath(path, 0, (char *)str_LSSCHED, (char *)str_extDB);
        err = FileOpenRead(path, (int *)&fh);
    }
    for (idx = 0, g = 0; g < 105 && err == 0; g += 7) {
        err = ReadSchedGame(fh, rec, g + 0x444);
        playofftree[idx] = rec[2];
        idx++;
        playofftree[idx] = rec[3];
        idx++;
    }
    hw = 0;
    aw = 0;
    for (g = 0; g < 7 && err == 0; g++) {
        err = ReadSchedGame(fh, rec, g + 0x4A6);
        if (g == 0) {
            t1 = rec[2];
            t2 = rec[3];
        }
        if (rec[4] > rec[5] && rec[2] == t1 || rec[5] > rec[4] && rec[3] == t1) hw++;
        else aw++;
        if (hw == 4 && rec[2] == t1 || aw == 4 && rec[2] == t2) {
            pochampion = rec[2];
            g = 7;
        }
        if (aw == 4 && rec[3] == t2 || hw == 4 && rec[3] == t1) {
            pochampion = rec[3];
            g = 7;
        }
    }
    FileClose((int *)&fh);
    if (err == 0) PlayoffTreeScreen();
    return 0;
}
