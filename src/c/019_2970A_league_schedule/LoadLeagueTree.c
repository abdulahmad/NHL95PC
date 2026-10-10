/* cflags: -od */
/* League schedule: playoff tree of a league (segment compiled without optimisation). */
#include "nhl95.h"

/* LoadLeagueTree (29B07) - PC only: fill the playoff tree from the stats league's schedule file: team names
   (26 city names, then a blank entry), the 15 series (two teams each, FFh -> 26 = empty) from the series table at
   +1998h of the file, the champion from TreeSeriesWinner on the final at +1BE4h (FFFFFFFF -> 26; same league as the
   open one decides how), then free the file and run PlayoffTreeScreen. Returns 0.
   Draft: code matches up to the frame: the asm has 40h of locals (i -4, same -18, sched -1C, p -20, b -28, a -30)
   and 16 unused bytes at -14..-8; Watcom -od here packs them in another order. */
int LoadLeagueTree(int a, int b)
{
    int i;
    int same;
    unsigned char *sched;
    unsigned char *p;

    same = strcmp((char *)statsleague, (char *)lgstate + 4);
    for (i = 0; i < 26; i++) strcpy((char *)treeteamnames + i * 21, (char *)teamcitynames[i]);
    strcpy((char *)treeteamnames + 0x222, (char *)str_Space2);
    OpenStatsSchedule((void **)&sched);
    sched += 2;
    p = sched + 0x1998;
    for (i = 0; i < 30; i += 2, p += 42) {
        playofftree[i] = p[2];
        playofftree_p1[i] = p[3];
        if (playofftree[i] == 0xFF) playofftree[i] = 26;
        if (playofftree_p1[i] == 0xFF) playofftree_p1[i] = 26;
    }
    p = sched + 0x1BE4;
    pochampion = TreeSeriesWinner(p, *(int *)(sched + 0x88), same);
    if (pochampion == -1) pochampion = 26;
    jctime((int)(sched - 2));
    PlayoffTreeScreen();
    return 0;
}
