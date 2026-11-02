/* cflags: -od */
/* League schedule: playoff series winner (segment compiled without optimisation). */
/* DRAFT: 379 vs 379, instructions match, stack slots do not. The win counters match
 (ebp-20h and ebp-24h). The series pointer, same and round are reversed against the
 original homes, and the return value sits at ebp-10h (original ebp-4). Do not retry:
 reversing the local order, or putting every local in one block. */
#include "nhl95.h"

/* TreeSeriesWinner: winner of series s (6-byte games: home at +2, away at +3, scores at +4 and +5).
 same is the strcmp of the stats league against the open one. When it is not zero, only the first
 round/2+1 games are counted and a blank score (FFh) returns -1; otherwise walk at most 7 games, or
 until a blank date, and a blank score returns -1. The side with more goals in a game gets the win.
 Returns the series' home team when it has more wins, otherwise the away team. */
int TreeSeriesWinner(unsigned char *s, unsigned round, int same)
{
    int away;
    int i;
    int home;

    home = s[2];
    away = s[3];
    {
        int awins;
        int hwins;

        if (same) {
            round = round / 2 + 1;
            hwins = awins = 0;
            for (; hwins < round && awins < round; s += 6) {
                if (s[4] == 0xFF) return -1;
                if (s[2] == home) {
                    if (s[4] > s[5]) hwins++;
                    else awins++;
                } else {
                    if (s[4] > s[5]) awins++;
                    else hwins++;
                }
            }
        } else {
            if (s[4] == 0xFF) return -1;
            i = 0;
            hwins = awins = 0;
            for (; s[0] != 0xFF && i < 7; s += 6, i++) {
                if (s[4] == 0xFF) return -1;
                if (s[2] == home) {
                    if (s[4] > s[5]) hwins++;
                    else awins++;
                } else {
                    if (s[4] > s[5]) awins++;
                    else hwins++;
                }
            }
        }
        if (hwins > awins) return home;
        return away;
    }
}
