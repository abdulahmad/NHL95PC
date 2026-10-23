/* Schedule: shuffling the teams of a new schedule. */
#define RandomizeSchedule RandomizeSchedule_decl
#define WriteTeamRec WriteTeamRec_decl
#include "nhl95.h"
#undef RandomizeSchedule
#undef WriteTeamRec

int WriteTeamRec(int fh, void *rec, int n);
void __STOSD(void *p, int v, int n);
#pragma aux __STOSD "__STOSD" parm [eax] [edx] [ecx];

/* DRAFT (10.0 GA, 15 differing, 2 bytes short): the division / slot bytes are unsigned char (slot declared in the
   team loop) and h is declared after v. Left: the list count k takes ebp / esi where the EXE uses edx, and the
   second append is `lea ebx, [edx+1]` where C increments in place. See docs/UNSURE.md. */

/* RandomizeSchedule (42295, PC only): with shuffle set, say so (msg_GenSchedule) and shuffle each division's teams
   (divisionteams, 7 per division, 6 in the first two; twelve random swaps), then rewrite the league's first 444h
   schedule games (the schedule database, game bytes +2 / +3) with each team replaced by the team in its place in
   the shuffled division, and add each game (6 * n + 2) to both teams' game lists (the team database, +11Ch, in
   order). Either way the rest of the schedule (games 444h-4ACh) is cleared to FFh, the files are closed and the
   message removed. dir: the league directory; shuffle: as above. Result: 0 or the I/O error. */
int RandomizeSchedule(char *dir, int shuffle)
{
    struct {
        unsigned char rec[0x2E8];
        int count[0x1A];
        char path[0x20];
        unsigned char perm[4][7];
        unsigned char g[8];
        int sfh;
        int tfh;
    } s;
    int err;
    int i;
    int j;
    int n;
    int v;
    int h;
    unsigned char t;
    int k;
    unsigned char dv;

    s.tfh = s.sfh = -1;
    if (shuffle) {
        MessageBox(-1, -1, (char *)msg_GenSchedule, 2, 0, 0, 0, 0, 0);
        __STOSD(s.count, 0, 0x1A);
        for (i = 0; i < 4; i++) {
            for (j = 0; j < 7; j++) s.perm[i][j] = divisionteams[i * 7 + j];
            n = (i >= 2) + 6;
            for (j = 0; j < 0xC; j++) {
                h = rand() % n;
                v = rand() % n;
                t = s.perm[i][h];
                s.perm[i][h] = s.perm[i][v];
                s.perm[i][v] = t;
            }
        }
    }
    MakePath(s.path, dir, (char *)leaguedbnames[6], (char *)str_extDB);
    err = FileOpenRW(s.path, &s.sfh);
    if (!err) {
        MakePath(s.path, dir, (char *)leaguedbnames[4], (char *)str_extDB);
        err = FileOpenRW(s.path, &s.tfh);
    }
    if (!err) {
        for (i = 0; i < 0x444 && !err && shuffle; i++) {
            err = ReadSchedGame(s.sfh, s.g, i);
            if (err) continue;
            h = s.g[2];
            v = s.g[3];
            for (j = 0; j < 0x1A; j++) {
                unsigned char sl;

                dv = teamdivision[h];
                sl = teamdivslot[h];
                if (h >= 0 && h == divisionteams[dv * 7 + sl]) {
                    s.g[2] = s.perm[dv][sl];
                    h = -1;
                }
                dv = teamdivision[v];
                sl = teamdivslot[v];
                if (v >= 0 && v == divisionteams[dv * 7 + sl]) {
                    s.g[3] = s.perm[dv][sl];
                    v = -1;
                }
                if (h < 0 && v < 0) j = 0x1A;
            }
            err = WriteSchedGame(s.sfh, s.g, i);
            if (!err) {
                h = s.g[2];
                v = s.g[3];
                err = ReadTeamRec(s.tfh, s.rec, h);
            }
            if (!err) {
                j = i * 6 + 2;
                k = s.count[h];
                ((int *)(s.rec + 0x11C))[k] = j;
                s.count[h] = k + 1;
                err = WriteTeamRec(s.tfh, s.rec, h);
            }
            if (!err) err = ReadTeamRec(s.tfh, s.rec, v);
            if (!err) {
                j = i * 6 + 2;
                k = s.count[v];
                ((int *)(s.rec + 0x11C))[k] = j;
                s.count[v] = k + 1;
                err = WriteTeamRec(s.tfh, s.rec, v);
            }
        }
        s.g[0] = 0xFF;
        s.g[1] = 0xFF;
        s.g[2] = 0xFF;
        s.g[3] = 0xFF;
        s.g[4] = 0xFF;
        s.g[5] = 0xFF;
        for (i = 0x444; i < 0x4AD && !err; i++) err = WriteSchedGame(s.sfh, s.g, i);
    }
    FileClose(&s.tfh);
    FileClose(&s.sfh);
    RestoreDialogBg();
    return err;
}
