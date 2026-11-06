/* cflags: -od */
/* Standings: series win counts from the playoff schedule. */
#include "nhl95.h"

/* CountSeriesWins: open the schedule (LoadScheduleDB when mode is set, otherwise OpenStatsSchedule)
 and walk four blocks of games at +199Ah. Each played game (teams and scores not FFh) gives a win to
 the higher score, team byte +2 or +3. Those counts are written through teams[] into out[] for
 slots 0-0Fh, 10h-17h, 18h-1Bh and 1Ch-1Dh. The win bytes are cleared before each block. The
 schedule block is freed with FreeMemBlock. */
void CountSeriesWins(int *teams, int *out, int mode)
{
    unsigned char wins[0x20];
    int sched;
    unsigned char *g;                   /* unused: under -od it keeps the frame slot at ebp-0Ch */
    int i;
    unsigned char *p;

    if (mode)
        LoadScheduleDB(&sched);
    else
        OpenStatsSchedule((void **)&sched);
    sched += 2;
    p = (unsigned char *)sched + 0x1998;
    for (i = 0; i < 0x1C; i++)
        wins[i] = 0;
    for (i = 0; i < 0x38; i++, p += 6) {
        if (p[2] != 0xFF && p[3] != 0xFF)
            if (p[4] != 0xFF && p[5] != 0xFF) {
                if (p[4] > p[5])
                    wins[p[2]]++;
                else
                    wins[p[3]]++;
            }
    }
    for (i = 0; i < 0x10; i++)
        out[i] = wins[teams[i]];
    for (i = 0; i < 0x1A; i++)
        wins[i] = 0;
    for (i = 0; i < 0x1C; i++, p += 6) {
        if (p[2] != 0xFF && p[3] != 0xFF)
            if (p[4] != 0xFF && p[5] != 0xFF) {
                if (p[4] > p[5])
                    wins[p[2]]++;
                else
                    wins[p[3]]++;
            }
    }
    for (i = 0x10; i < 0x18; i++)
        out[i] = wins[teams[i]];
    for (i = 0; i < 0x1A; i++)
        wins[i] = 0;
    for (i = 0; i < 0x0E; i++, p += 6) {
        if (p[2] != 0xFF && p[3] != 0xFF)
            if (p[4] != 0xFF && p[5] != 0xFF) {
                if (p[4] > p[5])
                    wins[p[2]]++;
                else
                    wins[p[3]]++;
            }
    }
    for (i = 0x18; i < 0x1C; i++)
        out[i] = wins[teams[i]];
    for (i = 0; i < 0x1A; i++)
        wins[i] = 0;
    for (i = 0; i < 7; i++, p += 6) {
        if (p[2] != 0xFF && p[3] != 0xFF)
            if (p[4] != 0xFF && p[5] != 0xFF) {
                if (p[4] > p[5])
                    wins[p[2]]++;
                else
                    wins[p[3]]++;
            }
    }
    for (i = 0x1C; i < 0x1E; i++)
        out[i] = wins[teams[i]];
    FreeMemBlock(sched - 2);
}
