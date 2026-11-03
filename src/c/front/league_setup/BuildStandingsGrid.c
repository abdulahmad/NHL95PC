/* League setup: the standings grid. */
#define BuildStandingsGrid BuildStandingsGrid_decl
#include "nhl95.h"
#undef BuildStandingsGrid

#define BETTER(a, b) (s.pts[a] > s.pts[b] \
    || s.pts[a] == s.pts[b] && s.gp[a] < s.gp[b] \
    || s.pts[a] == s.pts[b] && s.gp[a] == s.gp[b] && s.wins[a] > s.wins[b] \
    || s.pts[a] == s.pts[b] && s.gp[a] == s.gp[b] && s.wins[a] == s.wins[b] && s.gf[a] > s.gf[b] \
    || s.pts[a] == s.pts[b] && s.gp[a] == s.gp[b] && s.wins[a] == s.wins[b] && s.gf[a] == s.gf[b] \
       && s.ga[a] < s.ga[b])

/* DRAFT: 1640 vs 1645, 333 of 381 instructions; see docs/UNSURE.md. */
/* BuildStandingsGrid (384B8, PC only): read the 26 team records from fd (ReadTeamRec) and rank each division's
   teams (divisionteams, rows of 7; the first two divisions have 6 teams): points (2 per win plus ties), then
   fewer of the +28h count, more wins, more goals for, fewer goals against; a bubble sort with xor swaps.
   order: the ranked team numbers, 7 per division. Result: the last ReadTeamRec result. */
int BuildStandingsGrid(int fd, unsigned char (*order)[7])
{
    struct {
        unsigned char rec[0x2E8];
        int pts[4][7];
        int gp[4][7];
        int wins[4][7];
        int ga[4][7];
        int gf[4][7];
        int w[0x1A];
        int t[0x1A];
        int l[0x1A];
        int f[0x1A];
        int a[0x1A];
        int g[0x1A];
        int p;
        int r;
    } s;
    int i;
    int j;
    int k;
    int n;

    for (i = 0; i < 0x1A; i++) {
        s.r = ReadTeamRec(fd, s.rec, i);
        s.g[i] = s.rec[0x28];
        s.w[i] = s.rec[0x29];
        s.l[i] = s.rec[0x2A];
        s.t[i] = s.rec[0x2B];
        s.f[i] = *(unsigned short *)(s.rec + 0x2C);
        s.a[i] = *(unsigned short *)(s.rec + 0x2E);
    }
    for (i = 0; i < 4; i++) {
        for (j = 0; j < 7; j++) {
            n = ((unsigned char (*)[7])divisionteams)[i][j];
            s.p = s.w[n] * 2 + s.t[n];
            s.pts[i][j] = s.p;
            s.gp[i][j] = s.g[n];
            s.wins[i][j] = s.w[n];
            s.gf[i][j] = s.f[n];
            s.ga[i][j] = s.a[n];
            order[i][j] = ((unsigned char (*)[7])divisionteams)[i][j];
        }
    }
    for (i = 0; i < 2; i++) {
        for (j = 0; j < 5; j++) {
            for (k = j + 1; k < 6; k++) {
                if (BETTER(i][k, i][j)) {
                    s.pts[i][k] ^= s.pts[i][j];
                    s.pts[i][j] ^= s.pts[i][k];
                    s.pts[i][k] ^= s.pts[i][j];
                    s.gp[i][k] ^= s.gp[i][j];
                    s.gp[i][j] ^= s.gp[i][k];
                    s.gp[i][k] ^= s.gp[i][j];
                    s.wins[i][k] ^= s.wins[i][j];
                    s.wins[i][j] ^= s.wins[i][k];
                    s.wins[i][k] ^= s.wins[i][j];
                    s.gf[i][k] ^= s.gf[i][j];
                    s.gf[i][j] ^= s.gf[i][k];
                    s.gf[i][k] ^= s.gf[i][j];
                    s.ga[i][k] ^= s.ga[i][j];
                    s.ga[i][j] ^= s.ga[i][k];
                    s.ga[i][k] ^= s.ga[i][j];
                    order[i][k] ^= order[i][j];
                    order[i][j] ^= order[i][k];
                    order[i][k] ^= order[i][j];
                }
            }
        }
    }
    for (; i < 4; i++) {
        for (j = 0; j < 6; j++) {
            for (k = j + 1; k < 7; k++) {
                if (BETTER(i][k, i][j)) {
                    s.pts[i][k] ^= s.pts[i][j];
                    s.pts[i][j] ^= s.pts[i][k];
                    s.pts[i][k] ^= s.pts[i][j];
                    s.gp[i][k] ^= s.gp[i][j];
                    s.gp[i][j] ^= s.gp[i][k];
                    s.gp[i][k] ^= s.gp[i][j];
                    s.wins[i][k] ^= s.wins[i][j];
                    s.wins[i][j] ^= s.wins[i][k];
                    s.wins[i][k] ^= s.wins[i][j];
                    s.gf[i][k] ^= s.gf[i][j];
                    s.gf[i][j] ^= s.gf[i][k];
                    s.gf[i][k] ^= s.gf[i][j];
                    s.ga[i][k] ^= s.ga[i][j];
                    s.ga[i][j] ^= s.ga[i][k];
                    s.ga[i][k] ^= s.ga[i][j];
                    order[i][k] ^= order[i][j];
                    order[i][j] ^= order[i][k];
                    order[i][k] ^= order[i][j];
                }
            }
        }
    }
    return s.r;
}
