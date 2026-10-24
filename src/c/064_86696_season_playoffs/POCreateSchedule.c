/* Season playoffs: creating the playoff schedule. */
#include "nhl95.h"

void POInitSchedule(unsigned char *po, int *teams);
void POSeedRound2(unsigned char *po);
void POSeedConfFinals(unsigned char *po);
void POSeedFinal(unsigned char *po);

/* POCreateSchedule (8721F, PC only; owner of POCreateSchedule_x): create the playoff schedule file of the league
   in dir. Load the SCHEDULE.DB template (2-byte header), fill the 15 round settings at +50h-+88h with 7 (best of
   seven) and set up the series from the 16 seeded teams (POInitSchedule). When the two human teams (HomeTeam,
   VisTeam) are in different conferences, load the league's season, career and key databases (leaguedbnames,
   .DB) and pre-simulate the rounds before they can meet (POPreSimRound1 / 2 / ConfFinals with the seeding of each
   next round), save the season database and free the three. Then find the series (7 games apart, 2Ah bytes each
   from +1998h) that matches the two up, store its game number (+40h) and round (+44h), and write the schedule
   back. teams: the 16 seeds; dir: the league directory. Result: 1 when the template cannot be loaded or the
   file cannot be opened, else FileWriteAt's result. */
int POCreateSchedule(int *teams, char *dir)
{
    char path[0x40];
    char dbpath[0x40];
    int fh;
    unsigned char *po;
    unsigned char *s;
    int n;
    int size;
    int r;

    MakePath(path, dir, (char *)str_ScheduleDb, 0);
    po = (unsigned char *)sub_8E8B8(path, 0x20) + 2;
    if (!po) return 1;
    *(int *)(po + 0x50) = *(int *)(po + 0x54) = *(int *)(po + 0x58) = *(int *)(po + 0x5C) = *(int *)(po + 0x60)
        = *(int *)(po + 0x64) = *(int *)(po + 0x68) = *(int *)(po + 0x6C) = *(int *)(po + 0x70) = *(int *)(po + 0x74)
        = *(int *)(po + 0x78) = *(int *)(po + 0x7C) = *(int *)(po + 0x80) = *(int *)(po + 0x84) = *(int *)(po + 0x88)
        = 7;
    POInitSchedule(po, teams);
    if (teamconf[HomeTeam] != teamconf[VisTeam]) {
        MakePath(dbpath, dir, (char *)leaguedbnames[5], (char *)str_extDB);
        seasondb = (unsigned char *)sub_8E8A0(dbpath, 0x20);
        seasondb_size = sub_92DE0(dbpath);
        MakePath(dbpath, dir, (char *)leaguedbnames[1], (char *)str_extDB);
        careerdb = (unsigned char *)sub_8E8A0(dbpath, 0x20);
        careerdb_size = sub_92DE0(dbpath);
        MakePath(dbpath, dir, (char *)leaguedbnames[0], (char *)str_extDB);
        keydb = (unsigned char *)sub_8E8A0(dbpath, 0x20);
        keydb_size = sub_92DE0(dbpath);
        POPreSimRound1(po, HomeTeam, VisTeam);
        POSeedRound2(po);
        POPreSimRound2(po, HomeTeam, VisTeam);
        POSeedConfFinals(po);
        POPreSimConfFinals(po, HomeTeam, VisTeam);
        POSeedFinal(po);
        MakePath(dbpath, dir, (char *)leaguedbnames[5], (char *)str_extDB);
        sub_932D0(dbpath, seasondb, seasondb_size);
        if (seasondb) FreeMemBlock((int)seasondb);
        if (careerdb) FreeMemBlock((int)careerdb);
        if (keydb) FreeMemBlock((int)keydb);
        keydb = careerdb = seasondb = 0;
        keydb_size = careerdb_size = seasondb_size = 0;
    }
    for (n = 0, s = po + 0x1998; s[2] != HomeTeam || s[3] != VisTeam; n += 7, s += 0x2A);
    *(int *)(po + 0x40) = n;
    *(int *)(po + 0x44) = n / 7;
    size = sub_92DE0(path);
    if (FileOpenWrite(path, &fh)) {
        po -= 2;
        r = 1;
    } else {
        po -= 2;
        r = FileWriteAt(fh, po, 0, size);
        FileClose(&fh);
    }
    FreeMemBlock((int)po);
    return r;
}

/* POInitSchedule (875A3, PC only; ends in POCreateSchedule_x): set up a new playoff schedule po from the 16 seeded
   teams. Copy the seeds to the start, give the 28 first-round games of each conference (6-byte records at
   +1998h and +1A40h) their dates (month 4, day 17 / 16 plus two days per game in the series, rolling into month 5
   past day 30), pair each conference's teams (teamconf 3, then 0Ch) 1-8, 2-7, 3-6 and 4-5 into its four series
   (POSetSeriesTeams), and clear the 31h later games (+1AE8h: no date, teams FFh). po: the schedule; teams: the
   16 seeds. No result.
   DRAFT (GA, ESCALATE): compiles to the EXE bytes, not marked. sched and day are two extra copies (permute.py
   tempadd) whose only job is to break the savings-30 tie of the seed copy loop's index and value temporaries
   (without them: index copy in eax, value in edx; EXE edx and eax). Dead copies, not evidence; see
   docs/UNSURE.md. */
void POInitSchedule(unsigned char *po, int *teams)
{
    int i;
    int n;
    unsigned char *g;
    int t[8];
    int day;
    unsigned char *sched;

    for (i = 0; i < 16; i++) ((int *)po)[i] = teams[i];
    sched = po + 0x1998;
    g = sched;
    for (i = 0; i < 0x1C; i++) {
        g[i * 6] = 4;
        g[i * 6 + 1] = i % 7 * 2 + 0x11;
        if (g[i * 6 + 1] > 0x1E) {
            g[i * 6]++;
            g[i * 6 + 1] -= 0x1E;
        }
    }
    g = po + 0x1A40;
    for (i = 0; i < 0x1C; i++) {
        g[i * 6] = 4;
        day = i % 7 * 2 + 0x10;
        g[i * 6 + 1] = day;
        if (g[i * 6 + 1] > 0x1E) {
            g[i * 6]++;
            g[i * 6 + 1] -= 0x1E;
        }
    }
    for (i = 0, n = 0; i < 16; i++)
        if (teamconf[teams[i]] == 3) t[n++] = teams[i];
    POSetSeriesTeams(po + 0x1998, t[0], t[7]);
    POSetSeriesTeams(po + 0x19C2, t[1], t[6]);
    POSetSeriesTeams(po + 0x19EC, t[2], t[5]);
    POSetSeriesTeams(po + 0x1A16, t[3], t[4]);
    for (i = 0, n = 0; i < 16; i++)
        if (teamconf[teams[i]] == 0xC) t[n++] = teams[i];
    POSetSeriesTeams(po + 0x1A40, t[0], t[7]);
    POSetSeriesTeams(po + 0x1A6A, t[1], t[6]);
    POSetSeriesTeams(po + 0x1A94, t[2], t[5]);
    POSetSeriesTeams(po + 0x1ABE, t[3], t[4]);
    g = po + 0x1AE8;
    for (i = 0; i < 0x31; i++, g += 6) {
        g[0] = g[1] = 0;
        g[2] = g[3] = 0xFF;
        g[4] = g[5] = 0xFF;
    }
}

/* SeriesWinner (87760, PC only; ends in POCreateSchedule_x): the winner of the playoff series s (6-byte games:
   +2 home team, +3 away team, +4 / +5 home / away score, FFh for not played). Count each team's wins over the
   games until one has more than half of games; a game not yet played first means no winner. s: the series;
   games: its length. Result: the winning team (s[2] or s[3] of the first game), or -1. */
int SeriesWinner(unsigned char *s, unsigned games)
{
    int away;
    int t;
    unsigned w1;
    int home;
    unsigned w2;

    games = games / 2 + 1;
    home = s[2];
    away = s[3];
    for (w2 = 0, w1 = 0; w1 < games && w2 < games; s += 6) {
        if (s[4] == 0xFF) return -1;
        t = s[2];
        if (t == home) {
            if (s[4] > s[5]) w1++;
            else w2++;
        } else {
            if (s[4] > s[5]) w2++;
            else w1++;
        }
    }
    if ((int)w1 > (int)w2) return home;
    return away;
}

/* POSimSeriesTeamWins (87D5A, PC only; ends in POCreateSchedule_x): pre-simulate series s so that team wins it in
   four straight wins after any losses: open the league's databases (leaguedbnames[4] read write, error "E1";
   leaguedbnames[3] read, "E2") and simulate games (SimulateGame, game 44Ch) until team has 4 wins; each game is
   forced for team (mode 0 at home, 1 away) unless team already leads (mode 2, a free result). s: the series
   (6-byte games: +2 home, +4 / +5 scores); team: the team to win. No result. */
void POSimSeriesTeamWins(unsigned char *s, int team)
{
    char path[0x40];
    int rdfh;
    int rwfh;
    int l;
    int w;

    MakePath(path, (char *)&curleague, (char *)leaguedbnames[4], (char *)str_extDB);
    if (FileOpenRW(path, &rwfh) != 0) FatalError((char *)str_E1);
    MakePath(path, (char *)&curleague, (char *)leaguedbnames[3], (char *)str_extDB);
    if (FileOpenRead(path, &rdfh) != 0) FatalError((char *)str_E2);
    for (l = 0, w = 0; w < 4; s += 6) {
        if (l < w) SimulateGame((char *)&curleague, (char *)str_extDB, 0x44C, s, rwfh, rdfh, 2);
        else if (s[2] == team) SimulateGame((char *)&curleague, (char *)str_extDB, 0x44C, s, rwfh, rdfh, 0);
        else SimulateGame((char *)&curleague, (char *)str_extDB, 0x44C, s, rwfh, rdfh, 1);
        if (s[2] == team) {
            if (s[4] > s[5]) w++;
            else l++;
        } else {
            if (s[5] > s[4]) w++;
            else l++;
        }
    }
    FileClose(&rwfh);
    FileClose(&rdfh);
}

/* POSimSeries (87E77, PC only; ends in POCreateSchedule_x): pre-simulate series s to its end: open the league's
   databases (leaguedbnames[4] read write, error "F1"; leaguedbnames[3] read, "F2") and simulate its unplayed
   games (SimulateGame, game 44Ch, mode 2) until one team has more than half of games. s: the series (6-byte
   games: +2 home, +4 / +5 scores, FFh unplayed); games: its length. No result. */
void POSimSeries(unsigned char *s, unsigned games)
{
    char path[0x40];
    int rwfh;
    int rdfh;
    unsigned wh;
    unsigned wo;
    int home;

    games = games / 2 + 1;
    home = s[2];
    MakePath(path, (char *)&curleague, (char *)leaguedbnames[4], (char *)str_extDB);
    if (FileOpenRW(path, &rwfh) != 0) FatalError((char *)str_F1);
    MakePath(path, (char *)&curleague, (char *)leaguedbnames[3], (char *)str_extDB);
    if (FileOpenRead(path, &rdfh) != 0) FatalError((char *)str_F2);
    for (wo = 0, wh = 0; wh < games && wo < games; s += 6) {
        if (s[4] == 0xFF) SimulateGame((char *)&curleague, (char *)str_extDB, 0x44C, s, rwfh, rdfh, 2);
        if (s[2] == home) {
            if (s[4] > s[5]) wh++;
            else wo++;
        } else {
            if (s[4] > s[5]) wo++;
            else wh++;
        }
    }
    FileClose(&rwfh);
    FileClose(&rdfh);
}

/* POHiliteSlot (89B69, PC only; ends in POCreateSchedule_x): highlight slot n of the playoff tree: a double frame
   (sub_92F50, colour 80h) 74h wide at the slot position (dword_D2B70 / dword_D2BEC), 1Fh high for the 28
   first-round slots and 3Ch for the later ones, with a second frame one pixel outside it. n: the slot.
   unused: a value the callers pass and it ignores. No result. */
void POHiliteSlot(int n, int unused)
{
    int x2;
    int y2;
    int x;
    int y;

    x = dword_D2B70[n];
    y = dword_D2BEC[n];
    x2 = x + 0x74;
    y2 = n < 0x1C ? y + 0x1F : y + 0x3C;
    sub_92F50(x, y, x2, y2, 0x80);
    sub_92F50(x - 1, --y, ++x2, ++y2, 0x80);
}
