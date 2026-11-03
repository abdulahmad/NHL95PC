/* Schedule: blank the rest of a decided playoff series and record the wins. */
#define UpdatePlayoffSeries UpdatePlayoffSeries_decl
#define WriteTeamRec WriteTeamRec_decl
#include "nhl95.h"
#undef UpdatePlayoffSeries
#undef WriteTeamRec

int WriteTeamRec(int fh, void *rec, int n);

/* Watcom runtime: store n dwords of v at p. ebx survives, so the zeroed error stays live. */
void __STOSD(void *p, int v, int n);
#pragma aux __STOSD "__STOSD" parm [eax] [edx] [ecx] modify [eax edx ecx];

/* UpdatePlayoffSeries: game is a playoff schedule index. The round base is 0, 7, 0Eh or 15h
 from the bands 444h, 47Ch, 498h and 4A6h (nothing is stored at or past 4ADh). Count the games
 of that series whose teams are both filled in. Once either team has (played + 1) / 2 wins, blank
 the remaining game's month, day and scores (FFh), write it back, and mark that series slot -1 in
 both team records (the dword at record + 26Ch + (base + game) * 4). Otherwise, if both scores are
 in, give the win to the higher score, or to the away team on a tie. Returns the last file error. */
int UpdatePlayoffSeries(int sched, int teams, int game)
{
    struct {
        unsigned char rec[0x2E8];
        int wins[26];
        unsigned char gm[8];
        int idx;
        int need;
        int base;
        int series;
        int played;
        int team2;
    } s;
    int team1;
    int err;
    int i;

    s.idx = game;
    err = 0;
    __STOSD(s.wins, 0, 26);
    if (s.idx < 0x47C)
        s.base = err;
    else if (s.idx < 0x498)
        s.base = 7;
    else if (s.idx < 0x4A6)
        s.base = 0x0E;
    else if (s.idx < 0x4AD)
        s.base = 0x15;
    s.idx -= 0x444;
    s.series = s.idx - s.idx % 7;
    s.played = 0;
    for (i = 0; i < 7 && !err; i++) {
        err = ReadSchedGame(sched, s.gm, s.series + 0x444 + i);
        if (!err) {
            if (i == 0) {
                team1 = s.gm[2];
                s.team2 = s.gm[3];
            }
            if (s.gm[2] != 0xFF && s.gm[3] != 0xFF)
                s.played++;
        }
    }
    s.need = (s.played + 1) / 2;
    for (i = 0; i < s.played && !err; i++) {
        if (!err && (s.wins[team1] == s.need || s.wins[s.team2] == s.need)) {
            s.gm[0] = 0xFF;
            s.gm[1] = 0xFF;
            s.gm[4] = 0xFF;
            s.gm[5] = 0xFF;
            err = WriteSchedGame(sched, s.gm, s.series + 0x444 + i);
            if (!err)
                err = ReadTeamRec(teams, s.rec, team1);
            if (!err) {
                ((int *)(s.rec + 0x26C))[s.base + i] = -1;
                err = WriteTeamRec(teams, s.rec, team1);
            }
            if (!err)
                err = ReadTeamRec(teams, s.rec, s.team2);
            if (!err) {
                ((int *)(s.rec + 0x26C))[s.base + i] = -1;
                err = WriteTeamRec(teams, s.rec, s.team2);
            }
        } else {
            err = ReadSchedGame(sched, s.gm, s.series + 0x444 + i);
            if (s.gm[4] != 0xFF && s.gm[5] != 0xFF) {
                if (s.gm[4] > s.gm[5])
                    s.wins[s.gm[2]]++;
                else
                    s.wins[s.gm[3]]++;
            }
        }
    }
    return err;
}
