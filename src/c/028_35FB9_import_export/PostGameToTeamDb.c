/* Import / export: posting a played game to a team's databases. */
/* DRAFT under 10.0 GA: 2,341 vs 2,342 bytes, 115 differing instructions. The loop index is a plain local, so
   Watcom turns the played-flags loop into a __STOSB fill as in the EXE; the visitors-win arm tests !side first
   (the EXE's je / jmp into the home-win arm's increments). The skater and goalie keys have their own local (key)
   rather than k (the goal count / stat offset), declared in tools/wccre/declsearch.py's order (6 of 9 slots), with
   j before res (tools/wccre/tieorder.py's real-compiled declaration move).
   Left: i / j / score slots, the visitors-win score reloads hmscore where the EXE reuses ax (cwde); k still
   serves as the goal count and the stat offsets (separate locals for those grow the frame). */
#define PostGameToTeamDb PostGameToTeamDb_decl
#define WriteTeamRec WriteTeamRec_decl
#define ReadGSummaryRec ReadGSummaryRec_decl
#include "nhl95.h"
#undef PostGameToTeamDb
#undef WriteTeamRec
#undef ReadGSummaryRec

int PostGameToTeamDb(char *dir, char *ext, int team, int side, int game, char *gdir);
int WriteTeamRec(int fh, void *rec, int n);  /* 3A2B8 */
int ReadGSummaryRec(int fh, void *rec, int n);  /* 147FF */

/* PostGameToTeamDb (3626D, PC only): post a played game to one team's league databases. Open the team (read write),
   key, season and game summary databases (the summary in gdir); read the team record and count the game in its
   season or playoff block (game 444h and on): games, wins / losses / ties (side 0 home, 1 visitors), goals for and
   against, power plays and power-play goals for and against, penalty minutes against. A team's three stars get a
   star count in their season records (goalies in the goalie records). Find the goalie of record: for a tie the
   goalies in net at the end, else the goalies in net at the winning goal (counted from the game summary's goal
   events, home and visitors). Then each dressed skater who played (not on the scratch list) adds his game stats
   (games, goals, assists, points, the other columns), and each goalie who played (from the lines' goalie slots, with
   playing time) his games, minutes, shots and goals against, the decision and shutout for the goalie of record, the
   goals-against average (per hundred) and save percentage (per thousand); write the records back and close the
   files. dir / ext: the league directory and database extension; team: the team; side: 0 home, 1 visitors; game:
   the schedule index; gdir: the game summary directory. Result: 0, or the first file error. */
int PostGameToTeamDb(char *dir, char *ext, int team, int side, int game, char *gdir)
{
    struct {
        unsigned char team[0x2E8];
        unsigned char grec[0x38];
        unsigned char key[0x34];
        unsigned char srec[0x30];
        char path[0x20];
        unsigned char played[0x1C];
        unsigned char gsum[0xC];
        unsigned char *lines[2];
        int fgsum;
        int fseason;
        int fkey;
        int fteam;
    } f;
    unsigned short *gs;
    short *ss;
    unsigned char gk[2];
    short *st;
    int r;
    int ngames;
    unsigned char *rec;
    int i;
    int sideofs;
    int j;
    int res;
    int score;
    int k;
    int key;
    int goalieslot;
    int scratchslot;

    f.fgsum = f.fseason = f.fkey = f.fteam = -1;
    f.lines[0] = hmlinetab;
    f.lines[1] = awlinetab;
    if (game < 0x444) {
        rec = f.team + 0x28;
        ss = (short *)f.srec;
        gs = (unsigned short *)f.grec;
    } else {
        rec = f.team + 0x3A;
        ss = (short *)(f.srec + 0x12);
        gs = (unsigned short *)(f.grec + 0x16);
    }
    MakePath(f.path, dir, (char *)leaguedbnames[4], ext);
    r = FileOpenRW(f.path, &f.fteam);
    if (!r) {
        MakePath(f.path, dir, (char *)leaguedbnames[0], ext);
        r = FileOpenRead(f.path, &f.fkey);
    }
    if (!r) {
        MakePath(f.path, dir, (char *)leaguedbnames[5], ext);
        r = FileOpenRW(f.path, &f.fseason);
    }
    if (!r) {
        MakePath(f.path, gdir, (char *)str_GSUMMARY, (char *)str_extDB);
        r = FileOpenRW(f.path, &f.fgsum);
    }
    if (!r) r = ReadTeamRec(f.fteam, f.team, team);
    if (!r) {
        rec[0]++;
        if (hmscore[0] > awscore) {
            score = awscore + 1;
            res = 0;
            if (!side) rec[1]++;
            else rec[2]++;
        } else if (hmscore[0] < awscore) {
            score = hmscore[0] + 1;
            res = 1;
            if (!side) rec[2]++;
            else rec[1]++;
        } else {
            res = -1;
            rec[3]++;
            score = hmscore[0];
        }
        st = (short *)rec;
        sideofs = side << 8;
        st[2] += *(short *)((char *)hmscore + sideofs);
        st[3] += *(short *)((char *)hmscore + ((side ^ 1) << 8));
        st[5] += *(short *)((char *)&hmtmstruct + sideofs + 4);
        st[4] += *(short *)((char *)&hmtmstruct + sideofs + 2);
        st[7] += *(short *)((char *)&hmtmstruct + ((side ^ 1) << 8) + 4);
        st[6] += *(short *)((char *)&hmtmstruct + ((side ^ 1) << 8) + 2);
        st[8] = st[8] + *(short *)((char *)&hmtmstruct + ((side ^ 1) << 8) + 0xC);
        for (i = 0; i < 3 && !r; i++) {
            if (startm[i * 2] == side) {
                r = ReadKeyRec(f.fkey, f.key, *(int *)(f.team + 0x4C + starpl[i * 2] * 4));
                if (!r) {
                    if (f.key[2] == 'G') r = ReadGoalieSeasonRec(f.fseason, f.grec, *(int *)(f.key + 0x2C));
                    else r = ReadSeasonRec(f.fseason, f.srec, *(int *)(f.key + 0x2C));
                }
                if (!r) {
                    if (f.key[2] == 'G') {
                        ((short *)(f.grec + 0x30))[i]++;
                        r = WriteGoalieSeasonRec(f.fseason, f.grec, *(int *)(f.key + 0x2C));
                    } else {
                        ((short *)(f.srec + 0x28))[i]++;
                        r = WriteSeasonRec(f.fseason, f.srec, *(int *)(f.key + 0x2C));
                    }
                }
            }
        }
    }
    if (res < 0) {
        gk[0] = ((unsigned char *)hmtmlines[0])[(hmtmgoalie[0] & 1) + 0x24];
        gk[1] = ((unsigned char *)awtmlines)[(awtmgoalie & 1) + 0x24];
    } else {
        if (!r) r = ReadGSummaryRec(f.fgsum, f.gsum, 0);
        if (!r) {
            k = 0;
            j = 0;
            gk[1] = gk[0] = 0xFF;
            ngames = *(short *)(f.gsum + 5);
            for (i = 0; i <= ngames && !r; i++) {
                r = ReadGSummaryRec(f.fgsum, f.gsum, i);
                if (!r && f.gsum[0] == 1) {
                    if (f.gsum[1] == 0) k++;
                    else j++;
                    if (res == 0) {
                        if (k == score) {
                            gk[0] = f.gsum[9];
                            gk[1] = f.gsum[10];
                        }
                    } else if (j == score) {
                        gk[0] = f.gsum[10];
                        gk[1] = f.gsum[9];
                    }
                }
            }
        }
    }
    for (i = 0; i < 0x19; i++) f.played[i] = 1;
    i = 0;
    do {
        scratchslot = f.lines[side][i + 0x28];
        if (scratchslot < 0x19) f.played[scratchslot] = 0;
        i++;
    } while (i < 8);
    for (i = 0; i < 0x19 && !r; i++) {
        key = *(int *)(f.team + 0x4C + i * 4);
        if (key != -1) {
            r = ReadKeyRec(f.fkey, f.key, key);
            if (!r) r = ReadSeasonRec(f.fseason, f.srec, *(int *)(f.key + 0x2C));
            if (!r && f.played[i]) {
                k = side * 0x190 + i * 16;
                ss[0]++;
                ss[1] += *(short *)((char *)dword_DB088 + k);
                ss[2] += *(short *)((char *)word_DB08A + k);
                ss[3] += *(short *)((char *)dword_DB088 + k);
                ss[3] += *(short *)((char *)word_DB08A + k);
                ss[6] += *(short *)((char *)word_DB08C + k);
                ss[8] += *(short *)((char *)word_DB08E + k);
                ss[4] += *(short *)((char *)word_DB090 + k);
                ss[5] += *(short *)((char *)word_DB092 + k);
                ss[7] += *(short *)((char *)word_DB096 + k);
                r = WriteSeasonRec(f.fseason, f.srec, *(int *)(f.key + 0x2C));
            }
        }
    }
    for (i = 0; i < 3; i++) f.played[i + 0x19] = 0;
    i = 0;
    do {
        goalieslot = f.lines[side][i + 0x24];
        if (goalieslot < 0x1C) f.played[goalieslot]++;
        i++;
    } while (i < 2);
    for (i = 0; i < 3 && !r; i++) {
        key = *(int *)(f.team + 0xB0 + i * 4);
        if (key != -1) {
            r = ReadKeyRec(f.fkey, f.key, key);
            if (!r) r = ReadGoalieSeasonRec(f.fseason, f.grec, *(int *)(f.key + 0x2C));
            if (!r && f.played[i + 0x19]) {
                k = side * 18 + i * 6;
                if (*(short *)((char *)unk_DC240 + k)) {
                    gs[0]++;
                    gs[6] = gs[6] + *(short *)((char *)unk_DC240 + k) / 0x3C;
                    gs[9] += *(short *)((char *)word_DC242 + k);
                    gs[7] += *(short *)((char *)word_DC244 + k);
                    if ((signed char)gk[side] == (unsigned char)(i + 0x19)) {
                        if (hmscore[0] > awscore) {
                            if (!side) gs[1]++;
                            else gs[2]++;
                        } else if (hmscore[0] < awscore) {
                            if (!(side)) gs[2]++;
                            else gs[1]++;
                        } else {
                            gs[3]++;
                        }
                        if (awscore == 0 && !side || hmscore[0] == 0 && side == 1) gs[4]++;
                    }
                    if (gs[0]) gs[8] = gs[7] * 100 / gs[0];
                    else gs[8] = gs[0];
                    if (gs[9]) gs[10] = ((gs[9] - gs[7]) * 1000 + gs[9] / 2) / gs[9];
                    else gs[10] = gs[9];
                    r = WriteGoalieSeasonRec(f.fseason, f.grec, *(int *)(f.key + 0x2C));
                }
            }
        }
    }
    if (!r) r = WriteTeamRec(f.fteam, f.team, team);
    FileClose(&f.fgsum);
    FileClose(&f.fseason);
    FileClose(&f.fkey);
    FileClose(&f.fteam);
    return r;
}
