/* Key and team database: start a game summary file. */
#include "nhl95.h"

typedef struct Rec16 { char b[16]; } Rec16;
typedef struct Rec6 { char b[6]; } Rec6;

/* InitGameSummary: record a and b, then HomeTeam and VisTeam, in the 11-byte header at gsumheader
 and write 1 at the word after the four bytes. Clear the goal and shot counters. Unless full overtime
 is on, load the cup-final series. Create the gsummary file (two 11-byte headers), load both teams,
 then clear the 25 skater lines of each team and the 3 goalie lines of each team by copying the
 zeroed first record over every slot. */
void InitGameSummary(int a, int b)
{
    int fh;
    int t;
    int i;

    byte_DC268 = a;
    byte_DC267 = b;
    curperiod = -1;
    gsumheader_b1 = a;
    gsumheader_b2 = b;
    gsumheader_b3 = HomeTeam;
    gsumheader_b4 = VisTeam;
    gsumcount = 1;
    hmgoalcnt = 0;
    hmshotcnt = 0;
    awgoalcnt = 0;
    awshotcnt = 0;
    if (!gameopts.fullot) LoadCupFinalSeries();
    MakeGSummaryPath();
    if (FileCreate((char *)&gsummarypath, &fh)) FatalError((char *)str_feB1);
    if (FileWriteAt(fh, gsumheader, -1, 0x0B)) FatalError((char *)str_feB5);
    if (FileWriteAt(fh, gsumtail, -1, 0x0B)) FatalError((char *)str_feB8);
    FileClose(&fh);
    LoadGameTeams(0);
    hmplstats_w14[0] = 0;
    hmplstats_w12 = 0;
    hmplstats_w10[0] = 0;
    hmplstats_w8[0] = 0;
    hmplstats_w6[0] = 0;
    hmplstats_w4[0] = 0;
    hmplstats_w2[0] = 0;
    hmplstats[0] = 0;
    t = 0;
    do {
        i = 0;
        do {
            *(Rec16 *)((char *)hmplstats + (t * 25 << 4) + (i << 4)) = *(Rec16 *)hmplstats;
            i++;
        } while (i < 25);
        t++;
    } while (t < 2);
    hmglstats_w4[0] = 0;
    hmglstats_w2[0] = 0;
    hmglstats[0] = 0;
    t = 0;
    do {
        i = 0;
        do {
            *(Rec6 *)((short *)((char *)hmglstats + (t * 9 << 1)) + (i * 3)) = *(Rec6 *)hmglstats;
            i++;
        } while (i < 3);
        t++;
    } while (t < 2);
}
