/* Key and team database: start a game summary file. */
#include "nhl95.h"

typedef struct Rec16 { char b[16]; } Rec16;
typedef struct Rec6 { char b[6]; } Rec6;

/* InitGameSummary: record a and b, then HomeTeam and VisTeam, in the 11-byte header at unk_C5423
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
    byte_C5424 = a;
    byte_C5425 = b;
    byte_C5426 = HomeTeam;
    byte_C5427 = VisTeam;
    word_C5428 = 1;
    hmgoalcnt = 0;
    hmshotcnt = 0;
    awgoalcnt = 0;
    awshotcnt = 0;
    if (!gameopts.fullot) LoadCupFinalSeries();
    MakeGSummaryPath();
    if (FileCreate((char *)&gsummarypath, &fh)) FatalError((char *)str_feB1);
    if (FileWriteAt(fh, unk_C5423, -1, 0x0B)) FatalError((char *)str_feB5);
    if (FileWriteAt(fh, unk_C542E, -1, 0x0B)) FatalError((char *)str_feB8);
    FileClose(&fh);
    LoadGameTeams(0);
    word_DB096[0] = 0;
    word_DB094 = 0;
    word_DB092[0] = 0;
    word_DB090[0] = 0;
    word_DB08E[0] = 0;
    word_DB08C[0] = 0;
    word_DB08A[0] = 0;
    dword_DB088[0] = 0;
    t = 0;
    do {
        i = 0;
        do {
            *(Rec16 *)((char *)dword_DB088 + (t * 25 << 4) + (i << 4)) = *(Rec16 *)dword_DB088;
            i++;
        } while (i < 25);
        t++;
    } while (t < 2);
    word_DC244[0] = 0;
    word_DC242[0] = 0;
    unk_DC240[0] = 0;
    t = 0;
    do {
        i = 0;
        do {
            *(Rec6 *)((short *)((char *)unk_DC240 + (t * 9 << 1)) + (i * 3)) = *(Rec6 *)unk_DC240;
            i++;
        } while (i < 3);
        t++;
    } while (t < 2);
}
