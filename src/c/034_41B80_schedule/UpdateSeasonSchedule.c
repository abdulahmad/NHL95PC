/* Schedule: open the league files and play one schedule day, or advance the playoffs. */
#define UpdateSeasonSchedule UpdateSeasonSchedule_decl
#define SimScheduleDay SimScheduleDay_decl
#define AdvancePlayoffs AdvancePlayoffs_decl
#define BuildPlayoffs BuildPlayoffs_decl
#define SeedPlayoffRound1 SeedPlayoffRound1_decl
#include "nhl95.h"
#undef UpdateSeasonSchedule
#undef SimScheduleDay
#undef AdvancePlayoffs
#undef BuildPlayoffs
#undef SeedPlayoffRound1

int SimScheduleDay(int fh, int rwfh, int rdfh, int day, unsigned char *teams, char *dir, char *ext,
                   int team, int flags);
int AdvancePlayoffs(int fh, int rwfh, int rdfh, unsigned char *teams, char *dir, char *ext,
                    int team, int flags);
int SeedPlayoffRound1(int *seeds, unsigned char *buf, int rwfh, int series, unsigned char *teams);  /* 42FED */

/* UpdateSeasonSchedule: open SCHEDULE and TEAMS read/write and CARTEAMS read-only under dir/ext.
 When the schedule is not yet at the end marker 4ADh, read that game. Load the season, career and
 key databases. A day still inside the regular schedule (below 444h), or the first playoff slot
 while either team byte is empty, is simulated; a later day, or that slot with both teams filled,
 advances the playoffs. The season database is written back, the three buffers are freed, and the
 handles are closed. BuildPlayoffs, SortStandings and SimPlayoffRound3 jump to the pops
 (UpdateSeasonSchedule_pop3).
 Returns the last file error. */
int UpdateSeasonSchedule(char *dir, char *ext, int day, unsigned char *teams, int team, int flags)
{
    struct {
        char path[0x20];
        unsigned char game[8];
        int rdfh;
        int rwfh;
        int fh;
    } s;
    int err;
    int play;

    s.rdfh = s.rwfh = s.fh = -1;
    byte_DE268 = 0;
    MakePath(s.path, dir, (char *)leaguedbnames[6], ext);
    err = FileOpenRW(s.path, &s.fh);
    if (!err) {
        MakePath(s.path, dir, (char *)leaguedbnames[4], ext);
        err = FileOpenRW(s.path, &s.rwfh);
    }
    if (!err) {
        MakePath(s.path, dir, (char *)leaguedbnames[3], ext);
        err = FileOpenRead(s.path, &s.rdfh);
    }
    if (!err) {
        if (day < 0x4AD)
            err = ReadSchedGame(s.fh, s.game, day);
    }
    if (!err) {
        MakePath(s.path, dir, (char *)leaguedbnames[5], ext);
        seasondb = (unsigned char *)sub_8E8A0(s.path, 0x20);
        seasondb_size = sub_92DE0(s.path);
        MakePath(s.path, dir, (char *)leaguedbnames[1], ext);
        careerdb = (unsigned char *)sub_8E8A0(s.path, 0x20);
        careerdb_size = sub_92DE0(s.path);
        MakePath(s.path, dir, (char *)leaguedbnames[0], ext);
        keydb = (unsigned char *)sub_8E8A0(s.path, 0x20);
        keydb_size = sub_92DE0(s.path);
    }
    if (!err && day > 0) {
        if (day <= 0x444) {
            play = day != 0x444 || s.game[2] == 0xFF || s.game[3] == 0xFF;
            if (play) {
                err = SimScheduleDay(s.fh, s.rwfh, s.rdfh, day, teams, dir, ext, team, flags);
                goto played;
            }
        }
        err = AdvancePlayoffs(s.fh, s.rwfh, s.rdfh, teams, dir, ext, team, flags);
    played:;
    }
    if (!err && seasondb) {
        MakePath(s.path, dir, (char *)leaguedbnames[5], ext);
        sub_932D0(s.path, seasondb, seasondb_size);
    }
    if (seasondb) FreeMemBlock((int)seasondb);
    if (careerdb) FreeMemBlock((int)careerdb);
    if (keydb) FreeMemBlock((int)keydb);
    keydb_size = careerdb_size = seasondb_size = keydb = careerdb = seasondb = 0;
    FileClose(&s.rdfh);
    FileClose(&s.rwfh);
    FileClose(&s.fh);
    return err;
}

/* BuildPlayoffs (428AB, PC only; ends in UpdateSeasonSchedule_pop3): after the last regular season day, seed the
   playoffs (GetPlayoffSeeds from the teams file rwfh) and make the 69h six-byte playoff game slots (all FFh). When
   a seeded team of either conference is human (team byte +17h is 1), only the first round is seeded
   (SeedPlayoffRound1) and the slots are written to the schedule file fh at 199Ah (game 444h). Otherwise every
   round is seeded and simulated (SeedPlayoffRound1..SimPlayoffFinal; the seeding gets the league option bits
   12-14), the slots are written, the season database is saved under dir / ext, the awards ceremony is shown,
   byte_DE268 is set to FFh and the schedule's game count becomes 4ADh (the end). rdfh: the read-only career
   teams file the simulations use; teams: the league team bytes. Returns 0 or the first error.
   Plain locals: rdfh stays a parameter (its home is stored in the prologue) and the short count has its own
   4-byte slot (a dword store). */
int BuildPlayoffs(int fh, int rwfh, int rdfh, unsigned char *teams, char *dir, char *ext)
{
    int seeds[28];
    char path[0x20];
    int human;
    int err;
    short n;
    unsigned char *buf;
    unsigned char *q;
    int i;
    int r;

    human = 0;
    if ((r = GetPlayoffSeeds(seeds, fh, rwfh)) != 0) return r;
    buf = (unsigned char *)sub_8CCA8((char *)str_sche, 0x276, 0x20);
    for (i = 0; i < 0x69; i++) {
        q = buf + i * 6;
        q[0] = q[1] = q[2] = q[3] = q[4] = q[5] = 0xFF;
    }
    for (i = 0; i < 8; i++) {
        if (teams[seeds[i] * 30 + 0x17] == 1) {
            human = 1;
            break;
        }
        if (teams[seeds[i + 14] * 30 + 0x17] == 1) {
            human = 1;
            break;
        }
    }
    if (human) {
        if (!(err = SeedPlayoffRound1(seeds, buf, rwfh, gameopts.optbits12, teams)))
            err = FileWriteAt(fh, buf, 0x199A, 0x276);
    } else if (!(err = SeedPlayoffRound1(seeds, buf, rwfh, gameopts.optbits12, teams))
        && !(err = SimPlayoffRound1((int)buf, rwfh, rdfh, dir, ext))
        && !(err = SeedPlayoffRound2((int)buf, gameopts.optbits12, rwfh, (int)teams, &human))
        && !(err = SimPlayoffRound2((int)buf, rwfh, rdfh, dir, ext))
        && !(err = SeedPlayoffRound3((int)buf, gameopts.optbits12, rwfh, (int)teams, &human))
        && !(err = SimPlayoffRound3((int)buf, rwfh, rdfh, dir, ext))
        && !(err = SeedPlayoffFinal((int)buf, gameopts.optbits12, rwfh, (int)teams, fh, &human))
        && !(err = SimPlayoffFinal((int)buf, rwfh, rdfh, dir, ext))
        && !(err = FileWriteAt(fh, buf, 0x199A, 0x276))) {
        MakePath(path, dir, (char *)leaguedbnames[5], ext);
        sub_932D0(path, seasondb, seasondb_size);
        AwardsCeremony();
        byte_DE268 = -1;
        n = 0x4AD;
        err = FileWriteAt(fh, &n, 0, 2);
    }
    FreeMemBlock((int)buf);
    return err;
}

/* SortStandings (42DAA, PC only; ends in UpdateSeasonSchedule_pop3): sort n teams into standings order. Each later
   entry j is compared with entry i: more points first, then more wins, more goals for, fewer goals against, else
   the higher team index; when j wins, entries i and j swap in all five arrays (SwapInt). idx: the team indexes;
   pts, wins, gf, ga: the keys, one per entry; n: the entry count. No result.
   DRAFT: 365 vs 367. The original computes j * 4 into ebx and &pts[j] first and keeps i * 4 and the i-side key
   pointers in stack temps; this computes i * 4 first. See docs/UNSURE.md. */
void SortStandings(int *idx, int *pts, int *wins, int *gf, int *ga, int n)
{
    int i;
    int j;
    int w;

    for (i = 0; i < n - 1; i++) {
        for (j = i + 1; j < n; j++) {
            if (pts[i] < pts[j]) w = idx[j];
            else if (pts[i] > pts[j]) w = idx[i];
            else if (wins[i] < wins[j]) w = idx[j];
            else if (wins[i] > wins[j]) w = idx[i];
            else if (gf[i] < gf[j]) w = idx[j];
            else if (gf[i] > gf[j]) w = idx[i];
            else if (ga[i] < ga[j]) w = idx[i];
            else if (ga[i] > ga[j]) w = idx[j];
            else w = idx[i] < idx[j] ? idx[j] : idx[i];
            if (w == idx[j]) {
                SwapInt(i, j, idx);
                SwapInt(i, j, pts);
                SwapInt(i, j, wins);
                SwapInt(i, j, gf);
                SwapInt(i, j, ga);
            }
        }
    }
}
