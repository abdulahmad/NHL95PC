/* Schedule: playoff seeding. */
#include "nhl95.h"

/* GetPlayoffSeeds (42BBA) - PC only: seed the playoffs into seeds: read the team records (ReadTeamRec from file fd)
   of the 12 teams of the first conference (confteams) and sort them by standings (SortStandings: points = 2 x wins
   (+29h) + ties (+2Bh), wins, goals for (+2Ch), goals against (+2Eh)); unless the top two come from both
   divisions (teamdivflags or-ed 3), the best team of the other division moves up to seed 2. The same for the 14
   teams of the second conference (dword_C5619, seeds + 38h, divisions 0Ch). b unused. Returns 0 or the read
   error. */
int GetPlayoffSeeds(int *seeds, int b, int fd)
{
    unsigned char rec[0x2E8];
    int gf[14];
    int pts[14];
    int wins[14];
    int ga[14];
    int i;
    int t;
    int r;

    for (i = 0; i < 12; i++) {
        r = ReadTeamRec(fd, rec, confteams[i]);
        if (r) return r;
        seeds[i] = confteams[i];
        pts[i] = rec[0x29] * 2 + rec[0x2B];
        wins[i] = rec[0x29];
        gf[i] = *(unsigned short *)(rec + 0x2C);
        ga[i] = *(unsigned short *)(rec + 0x2E);
    }
    SortStandings(seeds, pts, wins, gf, ga, 12);
    if ((teamdivflags[seeds[0]] | teamdivflags[seeds[1]]) != 3) {
        for (i = 2; i < 12; i++) {
            if ((teamdivflags[seeds[0]] | teamdivflags[seeds[i]]) == 3) break;
        }
        t = seeds[i];
        for (; i >= 2; i--) seeds[i] = seeds[i - 1];
        seeds[1] = t;
    }
    for (i = 0; i < 14; i++) {
        r = ReadTeamRec(fd, rec, dword_C5619[i]);
        if (r) return r;
        seeds[i + 14] = dword_C5619[i];
        pts[i] = rec[0x29] * 2 + rec[0x2B];
        wins[i] = rec[0x29];
        gf[i] = *(unsigned short *)(rec + 0x2C);
        ga[i] = *(unsigned short *)(rec + 0x2E);
    }
    SortStandings(seeds + 14, pts, wins, gf, ga, 14);
    if ((teamdivflags[seeds[14]] | teamdivflags[seeds[15]]) != 0xC) {
        for (i = 2; i < 14; i++) {
            if ((teamdivflags[seeds[14]] | teamdivflags[seeds[i + 14]]) == 0xC) break;
        }
        t = seeds[i + 14];
        for (; i >= 2; i--) seeds[i + 14] = seeds[i + 13];
        seeds[15] = t;
    }
    return 0;
}
