/* Schedule: playoff round seeding and simulation (one source block: the rounds share SimPlayoffRound1's exit,
 and SeedPlayoffRound1 before it ends there too). */
/* DRAFT: logic and frames right (__STOSD via a local pragma); the game-record index series-length registers differ (cl vs bl, lea edx vs inc eax), plus R1 parameter slots. */
#define WriteTeamRec WriteTeamRec_decl
#define UpdateSeasonSchedule UpdateSeasonSchedule_decl
#define SimScheduleDay SimScheduleDay_decl
#define AdvancePlayoffs AdvancePlayoffs_decl
#include "nhl95.h"
#undef WriteTeamRec
#undef UpdateSeasonSchedule
#undef SimScheduleDay
#undef AdvancePlayoffs

int SimScheduleDay(int fh, int rwfh, int rdfh, int day, unsigned char *teams, char *dir, char *ext,
                   int team, int flags);
int AdvancePlayoffs(int fh, int rwfh, int rdfh, unsigned char *teams, char *dir, char *ext,
                    int team, int flags);

/* Watcom runtime: store n dwords of v at p (the code generator's block fill) */
void __STOSD(void *p, int v, int n);
#pragma aux __STOSD "__STOSD" parm [eax] [edx] [ecx];

int WriteTeamRec(int fh, void *rec, int n);  /* 3A2B8: the callers here test its result */

/* Keep an unchanged copy of the exit owner from UpdateSeasonSchedule.c in this
   translation unit so SeedPlayoffFinal shares its original pop/ret tail.
   The owner itself is still built from UpdateSeasonSchedule.c. */
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

/* a team record of the league file (2E8h bytes): the game slots of the team's playoff games at +26Ch */
typedef struct POTeamRec {
    unsigned char pad[0x26C];
    int games[0x1C];
    unsigned char pad2[0xC];
} POTeamRec;

/* SeedPlayoffRound1 (42FED, PC only; ends in SimPlayoffRound1_pop3): set up the first round of the playoff
   schedule sched from the 16 seeds (seeds[0-7] one conference, seeds[14-21] the other). For a human team (byte
   +17h of its 1Eh-byte entry in teams) the team record of the league file fh is read, its 28 game slots are reset
   (-1) and then given the file positions of its series' games (series s, game k: (s * 7 + 444h / 460h + k) * 6 + 2;
   s = seed pair 1 v 8, 2 v 7, ...), and written back. Each series gets its two teams (SetSeriesTeams) and every
   game k is dated April (month 4) day 2k + 11h in the first conference, 2k + 10h in the second. games: the
   series length. Returns 0, or the error of a record read / write. */
int SeedPlayoffRound1(int *seeds, unsigned char *sched, int fh, int games, unsigned char *teams)
{
    POTeamRec r0;
    POTeamRec r1;
    int i;
    int k;
    int err;

    for (i = 0; i < 8; i++) {
        if (teams[seeds[i] * 30 + 0x17] == 1 && (err = ReadTeamRec(fh, &r0, seeds[i])) != 0) return err;
        if (teams[seeds[i + 14] * 30 + 0x17] == 1 && (err = ReadTeamRec(fh, &r1, seeds[i + 14])) != 0) return err;
        for (k = 0; k < 0x1C; k++) r0.games[k] = r1.games[k] = -1;
        if (teams[seeds[i] * 30 + 0x17] == 1 && (err = WriteTeamRec(fh, &r0, seeds[i])) != 0) return err;
        if (teams[seeds[i + 14] * 30 + 0x17] == 1 && (err = WriteTeamRec(fh, &r1, seeds[i + 14])) != 0) return err;
    }
    for (i = 0; i < 4; i++) {
        if (teams[seeds[i] * 30 + 0x17] == 1 && (err = ReadTeamRec(fh, &r0, seeds[i])) != 0) return err;
        if (teams[seeds[7 - i] * 30 + 0x17] == 1 && (err = ReadTeamRec(fh, &r1, seeds[7 - i])) != 0) return err;
        for (k = 0; k < games; k++) r0.games[k] = r1.games[k] = (i * 7 + 0x444 + k) * 6 + 2;
        if (teams[seeds[i] * 30 + 0x17] == 1 && (err = WriteTeamRec(fh, &r0, seeds[i])) != 0) return err;
        if (teams[seeds[7 - i] * 30 + 0x17] == 1 && (err = WriteTeamRec(fh, &r1, seeds[7 - i])) != 0) return err;
    }
    for (i = 0; i < 4; i++) {
        if (teams[seeds[i + 14] * 30 + 0x17] == 1 && (err = ReadTeamRec(fh, &r0, seeds[i + 14])) != 0) return err;
        if (teams[seeds[7 - i + 14] * 30 + 0x17] == 1 && (err = ReadTeamRec(fh, &r1, seeds[7 - i + 14])) != 0)
            return err;
        for (k = 0; k < games; k++) r0.games[k] = r1.games[k] = (i * 7 + 0x460 + k) * 6 + 2;
        if (teams[seeds[i + 14] * 30 + 0x17] == 1 && (err = WriteTeamRec(fh, &r0, seeds[i + 14])) != 0) return err;
        if (teams[seeds[7 - i + 14] * 30 + 0x17] == 1 && (err = WriteTeamRec(fh, &r1, seeds[7 - i + 14])) != 0)
            return err;
    }
    SetSeriesTeams(sched, seeds[0], seeds[7], games);
    SetSeriesTeams(sched + 0x2A, seeds[1], seeds[6], games);
    SetSeriesTeams(sched + 0x54, seeds[2], seeds[5], games);
    SetSeriesTeams(sched + 0x7E, seeds[3], seeds[4], games);
    SetSeriesTeams(sched + 0xA8, seeds[14], seeds[21], games);
    SetSeriesTeams(sched + 0xD2, seeds[15], seeds[20], games);
    SetSeriesTeams(sched + 0xFC, seeds[16], seeds[19], games);
    SetSeriesTeams(sched + 0x126, seeds[17], seeds[18], games);
    for (i = 0; i < games; i++) {
        sched[i * 6] = sched[(i + 7) * 6] = sched[(i + 0xE) * 6] = sched[(i + 0x15) * 6] = sched[(i + 0x1C) * 6]
            = sched[(i + 0x23) * 6] = sched[(i + 0x2A) * 6] = sched[(i + 0x31) * 6] = 4;
        sched[i * 6 + 1] = sched[(i + 7) * 6 + 1] = sched[(i + 0xE) * 6 + 1] = sched[(i + 0x15) * 6 + 1] = i * 2 + 0x11;
        sched[(i + 0x1C) * 6 + 1] = sched[(i + 0x23) * 6 + 1] = sched[(i + 0x2A) * 6 + 1] = sched[(i + 0x31) * 6 + 1]
            = i * 2 + 0x10;
    }
    return 0;
}

/* SimPlayoffRound1: simulate the 8 first-round series (7 games, 2Ah bytes each) of the playoff schedule sched. Each game of a series not yet played (score byte +4 = FFh)
 is simulated (SimulateGame, schedule slot s * 7 + 0x444 + game, mode 2) and the winner (more goals: +4 vs +5) counted
 once a team has won len 2 + 1 (SeriesLength) the remaining games are blanked (FFh). The win counts index
 by the series' first game's teams. Returns 0.
 DRAFT (10.0 GA, 9 differing): a plain win-count zeroing loop gives the original winning-length
 compare and slot-sum registers. Left: rdfh / series-counter slots and the away score loaded into dh
 instead of compared in memory. */
int SimPlayoffRound1(int sched, int rwfh, int rdfh, char *dir, char *ext)
{
    int wins[26];
    int i;
    int s;
    int len;
    unsigned char *g;
    unsigned char home;
    unsigned char away;

    g = (unsigned char *)sched;
    for (i = 0; i < 26; i++) wins[i] = 0;
    len = SeriesLength(g);
    for (s = 0; s < 8; s++, g += 0x2A) {
        for (i = 0; i < len; i++) {
            if (wins[g[2]] == len / 2 + 1 || wins[g[3]] == len / 2 + 1) {
                g[i * 6 + 3] = 0xFF;
                g[i * 6] = g[i * 6 + 1] = g[i * 6 + 2] = g[i * 6 + 3];
            } else {
                if (g[i * 6 + 4] == 0xFF) SimulateGame(dir, ext, s * 7 + 0x444 + i, g + i * 6, rwfh, rdfh, 2);
                home = g[i * 6 + 4];
                away = g[i * 6 + 5];
                wins[home > away ? g[i * 6 + 2] : g[i * 6 + 3]]++;
            }
        }
    }
    return 0;
}

/* SeedPlayoffRound2 (43757, PC only; ends in SimPlayoffRound1_pop3): set up the second round (series 8-11) of the
   playoff schedule sched. The date goes on from the last played first-round game (a day later in the first
   conference, NormalizeDate), two days per game, series 10 / 11 first. Per conference the four first-round winners
   (SeriesWinner: the higher seed stays at the front of the list, an upset goes to the back) meet 1 v 4 and 2 v 3
   (SetSeriesTeams), and a human team (byte +17h of its 1Eh-byte entry in teams) gets its round-2 game slots in its
   team record of the league file fh (games 7-13: (s * 7 + 47Ch / 48Ah + k) * 6 + 2); *human is set when there is
   one. games: the series length. Returns 0, or the error of a record read / write. */
#define SCHED ((unsigned char *)buf)
#define TEAMS ((unsigned char *)tm)

int SeedPlayoffRound2(int buf, int games, int fh, int tm, int *human)
{
    POTeamRec r0;
    POTeamRec r1;
    int w[8];
    int len;
    unsigned char day;
    unsigned char month;
    unsigned char *g;
    unsigned char *s;
    int i;
    int k;
    int t;
    int err;

    s = (unsigned char *)buf;
    len = SeriesLength(s);
    for (i = len - 1; i >= 0; i--) {
        g = s + i * 6;
        if (g[4] != 0xFF) {
            month = g[0];
            day = g[1] + 1;
            break;
        }
        g = s + (i + 7) * 6;
        if (g[4] != 0xFF) {
            month = g[0];
            day = g[1] + 1;
            break;
        }
        g = s + (i + 0xE) * 6;
        if (g[4] != 0xFF) {
            month = g[0];
            day = g[1] + 1;
            break;
        }
        g = s + (i + 0x15) * 6;
        if (g[4] != 0xFF) {
            month = g[0];
            day = g[1] + 1;
            break;
        }
        g = s + (i + 0x1C) * 6;
        if (g[4] != 0xFF) {
            month = g[0];
            day = g[1];
            break;
        }
        g = s + (i + 0x23) * 6;
        if (g[4] != 0xFF) {
            month = g[0];
            day = g[1];
            break;
        }
        g = s + (i + 0x2A) * 6;
        if (g[4] != 0xFF) {
            month = g[0];
            day = g[1];
            break;
        }
        g = s + (i + 0x31) * 6;
        if (g[4] != 0xFF) {
            month = g[0];
            day = g[1];
            break;
        }
    }
    for (i = 0; i < games; i++) {
        NormalizeDate(&month, &day);
        s[(i + 0x46) * 6] = s[(i + 0x4D) * 6] = month;
        s[(i + 0x4D) * 6 + 1] = day;
        s[(i + 0x46) * 6 + 1] = day;
        day++;
        NormalizeDate(&month, &day);
        s[(i + 0x38) * 6] = s[(i + 0x3F) * 6] = month;
        s[(i + 0x3F) * 6 + 1] = day;
        s[(i + 0x38) * 6 + 1] = day;
        day++;
    }
    __STOSD(w, -1, 8);
    t = SeriesWinner(s, len);
    if (t == s[2]) w[0] = t;
    else w[7] = t;
    t = SeriesWinner(s + 0x2A, len);
    if (t == s[0x2C]) w[1] = t;
    else w[6] = t;
    t = SeriesWinner(s + 0x54, len);
    if (t == s[0x56]) w[2] = t;
    else w[5] = t;
    t = SeriesWinner(s + 0x7E, len);
    if (t == s[0x80]) w[3] = t;
    else w[4] = t;
    for (i = 0, k = 0; i < 8; i++) {
        if (w[i] >= 0 && w[i] < 0x1A) w[k++] = w[i];
    }
    SetSeriesTeams((unsigned char *)buf + 0x150, w[0], w[3], games);
    SetSeriesTeams((unsigned char *)buf + 0x17A, w[1], w[2], games);
    *human = 0;
    for (i = 0; i < 2; i++) {
        if (TEAMS[w[i] * 30 + 0x17] == 1) {
            *human = 1;
            if ((err = ReadTeamRec(fh, &r0, w[i])) != 0) return err;
        }
        if (TEAMS[w[3 - i] * 30 + 0x17] == 1) {
            *human = 1;
            if ((err = ReadTeamRec(fh, &r1, w[3 - i])) != 0) return err;
        }
        for (k = 0; k < games; k++) r0.games[k + 7] = r1.games[k + 7] = (i * 7 + 0x47C + k) * 6 + 2;
        if (TEAMS[w[i] * 30 + 0x17] == 1 && (err = WriteTeamRec(fh, &r0, w[i])) != 0) return err;
        if (TEAMS[w[3 - i] * 30 + 0x17] == 1 && (err = WriteTeamRec(fh, &r1, w[3 - i])) != 0) return err;
    }
    __STOSD(w, -1, 8);
    t = SeriesWinner(s + 0xA8, len);
    if (t == s[0xAA]) w[0] = t;
    else w[7] = t;
    t = SeriesWinner(s + 0xD2, len);
    if (t == s[0xD4]) w[1] = t;
    else w[6] = t;
    t = SeriesWinner(s + 0xFC, len);
    if (t == s[0xFE]) w[2] = t;
    else w[5] = t;
    t = SeriesWinner(s + 0x126, len);
    if (t == s[0x128]) w[3] = t;
    else w[4] = t;
    for (i = 0, k = 0; i < 8; i++) {
        if (w[i] >= 0 && w[i] < 0x1A) w[k++] = w[i];
    }
    SetSeriesTeams((unsigned char *)buf + 0x1A4, w[0], w[3], games);
    SetSeriesTeams((unsigned char *)buf + 0x1CE, w[1], w[2], games);
    for (i = 0; i < 2; i++) {
        if (TEAMS[w[i] * 30 + 0x17] == 1) {
            *human = 1;
            if ((err = ReadTeamRec(fh, &r0, w[i])) != 0) return err;
        }
        if (TEAMS[w[3 - i] * 30 + 0x17] == 1) {
            *human = 1;
            if ((err = ReadTeamRec(fh, &r1, w[3 - i])) != 0) return err;
        }
        for (k = 0; k < games; k++) r0.games[k + 7] = r1.games[k + 7] = (i * 7 + 0x48A + k) * 6 + 2;
        if (TEAMS[w[i] * 30 + 0x17] == 1 && (err = WriteTeamRec(fh, &r0, w[i])) != 0) return err;
        if (TEAMS[w[3 - i] * 30 + 0x17] == 1 && (err = WriteTeamRec(fh, &r1, w[3 - i])) != 0) return err;
    }
    return 0;
}

/* SimPlayoffRound2: the same for the 4 second-round series (sched + 150h). Each game of a series not yet played (score byte +4 = FFh)
 is simulated (SimulateGame, schedule slot s * 7 + 0x47C + game, mode 2) and the winner (more goals: +4 vs +5) counted
 once a team has won len 2 + 1 (SeriesLength) the remaining games are blanked (FFh). The win counts index
 by the series' first game's teams. Returns 0.
 DRAFT (10.0 GA, 3 differing, exact size): the win counts cleared by a loop (Watcom's __STOSD fill, as in
 SimPlayoffRound3) and both score bytes named locals. Left: the away byte is loaded into dh and compared
 (EXE `cmp dl, [eax+5]`, the in-place read of SimPlayoffRound3, which here moves every earlier pick). */
int SimPlayoffRound2(int sched, int rwfh, int rdfh, char *dir, char *ext)
{
    int wins[26];
    unsigned char home;
    unsigned char away;
    int s;
    int i;
    int len;
    unsigned char *g;

    g = (unsigned char *)sched + 0x150;
    for (i = 0; i < 26; i++) wins[i] = 0;
    len = SeriesLength(g);
    for (s = 0; s < 4; s++, g += 0x2A) {
        for (i = 0; i < len; i++) {
            if (wins[g[2]] == len / 2 + 1 || wins[g[3]] == len / 2 + 1) {
                g[i * 6 + 2] = 0xFF;
                g[i * 6] = g[i * 6 + 1] = g[i * 6 + 3] = g[i * 6 + 2];
            } else {
                if (g[i * 6 + 4] == 0xFF) SimulateGame(dir, ext, s * 7 + 0x47C + i, g + i * 6, rwfh, rdfh, 2);
                home = g[i * 6 + 4];
                away = g[i * 6 + 5];
                wins[home > away ? g[i * 6 + 2] : g[i * 6 + 3]]++;
            }
        }
    }
    return 0;
}

/* SeedPlayoffRound3 (43F4B, PC only; ends in SimPlayoffRound1_pop3): set up the conference finals (series 12 / 13)
   from the second round (series 8-11) of the playoff schedule at buf. The date goes on from the last played
   second-round game as in SeedPlayoffRound2, series 13 first. In each conference the two winners meet, the winner of
   the series with the higher seed at home (SetSeriesTeams), and a human team gets its game slots 14-20 in its team
   record ((k + 498h / 49Fh) * 6 + 2); *human is set when there is one. games: the series length. Returns 0, or the
   error of a record read / write. */
int SeedPlayoffRound3(int buf, int games, int fh, int tm, int *human)
{
    int k;
    POTeamRec r0;
    POTeamRec r1;
    int c1;
    int c2;
    int b;
    unsigned char month;
    int a;
    unsigned char day;
    unsigned char *s;
    unsigned char *g;
    int i;
    int err;
    int len;

    s = (unsigned char *)buf + 0x150;
    len = SeriesLength(s);
    for (i = len - 1; i >= 0; i--) {
        g = s + i * 6;
        if (g[4] != 0xFF) {
            month = g[0];
            day = g[1] + 1;
            break;
        }
        g = s + (i + 7) * 6;
        if (g[4] != 0xFF) {
            month = g[0];
            day = g[1] + 1;
            break;
        }
        g = s + (i + 0xE) * 6;
        if (g[4] != 0xFF) {
            month = g[0];
            day = g[1];
            break;
        }
        g = s + (i + 0x15) * 6;
        if (g[4] != 0xFF) {
            month = g[0];
            day = g[1];
            break;
        }
    }
    for (i = 0; i < games; i++) {
        NormalizeDate(&month, &day);
        s[(i + 0x23) * 6] = month;
        s[(i + 0x23) * 6 + 1] = day;
        day++;
        NormalizeDate(&month, &day);
        s[(i + 0x1C) * 6] = month;
        s[(i + 0x1C) * 6 + 1] = day;
        day++;
    }
    a = c1 = SeriesWinner(s, len);
    b = SeriesWinner(s + 0x2A, len);
    if (s[2] == c1) SetSeriesTeams((unsigned char *)buf + 0x1F8, c1, b, games);
    else SetSeriesTeams((unsigned char *)buf + 0x1F8, b, c1, games);
    *human = 0;
    if (TEAMS[(a * 16 - a) * 2 + 0x17] == 1) {
        *human = 1;
        if ((err = ReadTeamRec(fh, &r0, a)) != 0) return err;
    }
    if (TEAMS[(b * 16 - b) * 2 + 0x17] == 1) {
        *human = 1;
        if ((err = ReadTeamRec(fh, &r1, b)) != 0) return err;
    }
    for (k = 0; k < games; k++) r0.games[k + 14] = r1.games[k + 14] = (k + 0x498) * 6 + 2;
    if (TEAMS[(a * 16 - a) * 2 + 0x17] == 1 && (err = WriteTeamRec(fh, &r0, a)) != 0) return err;
    if (TEAMS[(b * 16 - b) * 2 + 0x17] == 1 && (err = WriteTeamRec(fh, &r1, b)) != 0) return err;
    a = c2 = SeriesWinner(s + 0x54, len);
    b = SeriesWinner(s + 0x7E, len);
    if (s[0x56] == c2) SetSeriesTeams((unsigned char *)buf + 0x222, c2, b, games);
    else SetSeriesTeams((unsigned char *)buf + 0x222, b, c2, games);
    if (TEAMS[(a * 16 - a) * 2 + 0x17] == 1) {
        *human = 1;
        if ((err = ReadTeamRec(fh, &r0, a)) != 0) return err;
    }
    if (TEAMS[(b * 16 - b) * 2 + 0x17] == 1) {
        *human = 1;
        if ((err = ReadTeamRec(fh, &r1, b)) != 0) return err;
    }
    for (k = 0; k < games; k++) r0.games[k + 14] = r1.games[k + 14] = (k + 0x49F) * 6 + 2;
    if (TEAMS[(a * 16 - a) * 2 + 0x17] == 1 && (err = WriteTeamRec(fh, &r0, a)) != 0) return err;
    if (TEAMS[(b * 16 - b) * 2 + 0x17] == 1 && (err = WriteTeamRec(fh, &r1, b)) != 0) return err;
    return 0;
}

/* SimPlayoffRound3: the same for the 2 conference finals (sched + 1F8h). Each game of a series not yet played (score byte +4 = FFh)
 is simulated (SimulateGame, schedule slot s * 7 + 0x498 + game, mode 2) and the winner (more goals: +4 vs +5) counted
 once a team has won len 2 + 1 (SeriesLength) the remaining games are blanked (FFh). The win counts index
 by the series' first game's teams. Returns 0. The win counts are cleared by a loop, which Watcom turns into
 the __STOSD fill. */
int SimPlayoffRound3(int sched, int rwfh, int rdfh, char *dir, char *ext)
{
    int wins[26];
    int s;
    int len;
    int i;
    unsigned char *g;

    g = (unsigned char *)sched + 0x1F8;
    for (i = 0; i < 26; i++) wins[i] = 0;
    len = SeriesLength(g);
    for (s = 0; s < 2; s++, g += 0x2A) {
        for (i = 0; i < len; i++) {
            if (wins[g[2]] == len / 2 + 1 || wins[g[3]] == len / 2 + 1) {
                g[i * 6 + 5] = 0xFF;
                g[i * 6] = g[i * 6 + 1] = g[i * 6 + 2] = g[i * 6 + 3] = g[i * 6 + 4] = g[i * 6 + 5];
            } else {
                if (g[i * 6 + 4] == 0xFF) SimulateGame(dir, ext, s * 7 + 0x498 + i, g + i * 6, rwfh, rdfh, 2);
                wins[g[i * 6 + 4] > g[i * 6 + 5] ? g[i * 6 + 2] : g[i * 6 + 3]]++;
            }
        }
    }
    return 0;
}

/* SeedPlayoffFinal (444C9, PC only; ends in UpdateSeasonSchedule_pop3): set up the
   final (series 14) from the conference finals (series 12 / 13) of the playoff schedule at buf. The date goes on
   from the last played conference final game (a day later after series 13), two days per game. The two winners'
   team records of the league file fh get their game slots 21-27 ((k + 4A6h) * 6 + 2) when they are human teams
   (*human is set), and the two are ordered by their season standings (SortStandings: points, wins, goals for and
   against from the records) for home ice. games: the series length; the fifth argument is not used. Returns 0, or
   the error of a record read / write. */
int SeedPlayoffFinal(int buf, int games, int fh, int tm, int unused, int *human)
{
    POTeamRec r[2];
    int w[8];
    struct {
        int gf[2];
        int wins[2];
        int ga[2];
        int pts[2];
    } st;
    int len;
    unsigned char month;
    unsigned char day;
    unsigned char *s;
    unsigned char *g;
    int i;
    int k;
    int err;

    s = (unsigned char *)buf + 0x1F8;
    len = SeriesLength(s);
    for (i = len - 1; i >= 0; i--) {
        g = s + i * 6;
        if (g[4] != 0xFF) {
            month = g[0];
            day = g[1];
            break;
        }
        g = s + (i + 7) * 6;
        if (g[4] != 0xFF) {
            month = g[0];
            day = g[1] + 1;
            break;
        }
    }
    for (i = 0; i < games; i++) {
        day += 2;
        NormalizeDate(&month, &day);
        s[(i + 0xE) * 6] = month;
        s[(i + 0xE) * 6 + 1] = day;
    }
    w[0] = SeriesWinner(s, len);
    w[1] = SeriesWinner(s + 0x2A, len);
    *human = 0;
    if (TEAMS[w[0] * 30 + 0x17] == 1) {
        *human = 1;
        if ((err = ReadTeamRec(fh, &r[0], w[0])) != 0) return err;
    }
    if (TEAMS[w[1] * 30 + 0x17] == 1) {
        *human = 1;
        if ((err = ReadTeamRec(fh, &r[1], w[1])) != 0) return err;
    }
    for (k = 0; k < games; k++) r[0].games[k + 21] = r[1].games[k + 21] = (k + 0x4A6) * 6 + 2;
    if (TEAMS[w[0] * 30 + 0x17] == 1 && (err = WriteTeamRec(fh, &r[0], w[0])) != 0) return err;
    if (TEAMS[w[1] * 30 + 0x17] == 1 && (err = WriteTeamRec(fh, &r[1], w[1])) != 0) return err;
    err = r[0].pad[0x29] * 2;
    st.pts[0] = err + r[0].pad[0x2B];
    st.wins[0] = r[0].pad[0x29];
    st.gf[0] = *(unsigned short *)&r[0].pad[0x2C];
    st.ga[0] = *(unsigned short *)&r[0].pad[0x2E];
    st.pts[1] = r[1].pad[0x29] * 2 + r[1].pad[0x2B];
    st.wins[1] = r[1].pad[0x29];
    st.gf[1] = *(unsigned short *)&r[1].pad[0x2C];
    st.ga[1] = *(unsigned short *)&r[1].pad[0x2E];
    SortStandings(w, st.pts, st.wins, st.gf, st.ga, 2);
    SetSeriesTeams((unsigned char *)buf + 0x24C, w[0], w[1], games);
    return 0;
}

/* SimPlayoffFinal: the same for the final series (sched + 24Ch). Each game of a series not yet played (score byte +4 = FFh)
 is simulated (SimulateGame, schedule slot game + 0x4A6, mode 2) and the winner (more goals: +4 vs +5) counted
 once a team has won len 2 + 1 (SeriesLength) the remaining games are blanked (FFh). The win counts index
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
