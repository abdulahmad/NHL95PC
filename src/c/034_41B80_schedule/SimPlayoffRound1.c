/* Schedule: playoff round simulation (one source block: the rounds share SimPlayoffRound1's exit). */
/* DRAFT: logic and frames right (__STOSD via a local pragma); the game-record index / series-length registers differ (cl vs bl, lea edx vs inc eax), plus R1 parameter slots. */
#include "nhl95.h"

/* Watcom runtime: store n dwords of v at p (the code generator's block fill) */
void __STOSD(void *p, int v, int n);
#pragma aux __STOSD "__STOSD" parm [eax] [edx] [ecx];

/* SimPlayoffRound1 (43644) - PC only: simulate the 8 first-round series (7 games, 2Ah bytes each) of the playoff schedule sched. Each game of a series not yet played (score byte +4 = FFh)
   is simulated (SimulateGame, schedule slot s * 7 + 0x444 + game, mode 2) and the winner (more goals: +4 vs +5) counted;
   once a team has won len / 2 + 1 (SeriesLength) the remaining games are blanked (FFh). The win counts index
   by the series' first game's teams. Returns 0. */
int SimPlayoffRound1(int sched, int rwfh, int rdfh, char *dir, char *ext)
{
    int wins[26];
    int s;
    int i;
    int len;
    unsigned char *g;

    g = (unsigned char *)sched;
    __STOSD(wins, 0, 26);
    len = SeriesLength(g);
    for (s = 0; s < 8; s++, g += 0x2A) {
        for (i = 0; i < len; i++) {
            if (wins[g[2]] == len / 2 + 1 || wins[g[3]] == len / 2 + 1) {
                g[i * 6 + 3] = 0xFF;
                g[i * 6] = g[i * 6 + 1] = g[i * 6 + 2] = g[i * 6 + 3];
            } else {
                if (g[i * 6 + 4] == 0xFF) SimulateGame(dir, ext, s * 7 + 0x444 + i, g + i * 6, rwfh, rdfh, 2);
                wins[g[i * 6 + 4] > g[i * 6 + 5] ? g[i * 6 + 2] : g[i * 6 + 3]]++;
            }
        }
    }
    return 0;
}

/* SeedPlayoffRound2 (43757) - not decompiled yet (stays asm); this stub only keeps the file's layout so the
   rounds after it reach SimPlayoffRound1's exit with a near jump as in the EXE. */
int SeedPlayoffRound2(int buf, int series, int a, int c, int *out)
{
    return 0;
}

/* SimPlayoffRound2 (43E40) - PC only: the same for the 4 second-round series (sched + 150h). Each game of a series not yet played (score byte +4 = FFh)
   is simulated (SimulateGame, schedule slot s * 7 + 0x47C + game, mode 2) and the winner (more goals: +4 vs +5) counted;
   once a team has won len / 2 + 1 (SeriesLength) the remaining games are blanked (FFh). The win counts index
   by the series' first game's teams. Returns 0. */
int SimPlayoffRound2(int sched, int rwfh, int rdfh, char *dir, char *ext)
{
    int wins[26];
    int s;
    int i;
    int len;
    unsigned char *g;

    g = (unsigned char *)sched + 0x150;
    __STOSD(wins, 0, 26);
    len = SeriesLength(g);
    for (s = 0; s < 4; s++, g += 0x2A) {
        for (i = 0; i < len; i++) {
            if (wins[g[2]] == len / 2 + 1 || wins[g[3]] == len / 2 + 1) {
                g[i * 6 + 3] = 0xFF;
                g[i * 6] = g[i * 6 + 1] = g[i * 6 + 2] = g[i * 6 + 3];
            } else {
                if (g[i * 6 + 4] == 0xFF) SimulateGame(dir, ext, s * 7 + 0x47C + i, g + i * 6, rwfh, rdfh, 2);
                wins[g[i * 6 + 4] > g[i * 6 + 5] ? g[i * 6 + 2] : g[i * 6 + 3]]++;
            }
        }
    }
    return 0;
}

/* SeedPlayoffRound3 (43F4B) - not decompiled yet (stays asm); this stub only keeps the file's layout so the
   rounds after it reach SimPlayoffRound1's exit with a near jump as in the EXE. */
int SeedPlayoffRound3(int buf, int series, int a, int c, int *out)
{
    return 0;
}

/* SimPlayoffRound3 (443B6) - PC only: the same for the 2 conference finals (sched + 1F8h). Each game of a series not yet played (score byte +4 = FFh)
   is simulated (SimulateGame, schedule slot s * 7 + 0x498 + game, mode 2) and the winner (more goals: +4 vs +5) counted;
   once a team has won len / 2 + 1 (SeriesLength) the remaining games are blanked (FFh). The win counts index
   by the series' first game's teams. Returns 0. */
int SimPlayoffRound3(int sched, int rwfh, int rdfh, char *dir, char *ext)
{
    int wins[26];
    int s;
    int i;
    int len;
    unsigned char *g;

    g = (unsigned char *)sched + 0x1F8;
    __STOSD(wins, 0, 26);
    len = SeriesLength(g);
    for (s = 0; s < 2; s++, g += 0x2A) {
        for (i = 0; i < len; i++) {
            if (wins[g[2]] == len / 2 + 1 || wins[g[3]] == len / 2 + 1) {
                g[i * 6 + 3] = 0xFF;
                g[i * 6] = g[i * 6 + 1] = g[i * 6 + 2] = g[i * 6 + 3];
            } else {
                if (g[i * 6 + 4] == 0xFF) SimulateGame(dir, ext, s * 7 + 0x498 + i, g + i * 6, rwfh, rdfh, 2);
                wins[g[i * 6 + 4] > g[i * 6 + 5] ? g[i * 6 + 2] : g[i * 6 + 3]]++;
            }
        }
    }
    return 0;
}

/* SeedPlayoffFinal (444C9) - not decompiled yet (stays asm); this stub only keeps the file's layout so the
   rounds after it reach SimPlayoffRound1's exit with a near jump as in the EXE. */
int SeedPlayoffFinal(int buf, int series, int a, int c, int fh, int *out)
{
    return 0;
}

/* SimPlayoffFinal (447A6) - PC only: the same for the final series (sched + 24Ch). Each game of a series not yet played (score byte +4 = FFh)
   is simulated (SimulateGame, schedule slot game + 0x4A6, mode 2) and the winner (more goals: +4 vs +5) counted;
   once a team has won len / 2 + 1 (SeriesLength) the remaining games are blanked (FFh). The win counts index
   by the series' first game's teams. Returns 0. */
int SimPlayoffFinal(int sched, int rwfh, int rdfh, char *dir, char *ext)
{
    int wins[26];
    int i;
    int len;
    unsigned char *g;

    g = (unsigned char *)sched + 0x24C;
    __STOSD(wins, 0, 26);
    len = SeriesLength(g);
    for (i = 0; i < len; i++) {
        if (wins[g[2]] == len / 2 + 1 || wins[g[3]] == len / 2 + 1) {
            g[i * 6 + 3] = 0xFF;
            g[i * 6] = g[i * 6 + 1] = g[i * 6 + 2] = g[i * 6 + 3];
        } else {
            if (g[i * 6 + 4] == 0xFF) SimulateGame(dir, ext, i + 0x4A6, g + i * 6, rwfh, rdfh, 2);
            wins[g[i * 6 + 4] > g[i * 6 + 5] ? g[i * 6 + 2] : g[i * 6 + 3]]++;
        }
    }
    return 0;
}
