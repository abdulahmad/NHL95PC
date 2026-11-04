/* Key and team database: loading the two teams of a game. */
#include "nhl95.h"

void LoadTeamRoster(int mode, int key, int att, int season, int career, int out, int side);

typedef struct LineTab {
    int w[12];
} LineTab;

/* LoadGameTeams (1BBCC, PC only): load the home and away teams of a game from the league files (leaguedbfmt /
   leaguedbfmt2 with "teams"): each team's 2E8h-byte team record (HomeTeam / VisTeam) into hmteamrec /
   awteamrec, then its players (OpenPlayerDBs, LoadTeamRoster; the career file only outside modes with bit 1 or
   2). Modes 0 and 2 take the saved lines (team record +BCh) into hmlinetab / awlinetab. The scratched players
   (hmscratch / awscratch, 64h for none) get roster status 2. Any missing or unreadable file is fatal ("1"-"8").
   mode: the game mode bits. No result. */
void LoadGameTeams(int mode)
{
    struct {
        unsigned char find[0x2C];
        char path[0x20];
        int out;
        int career;
        int season;
        int att;
        int fh;
    } s;
    int i;

    sprintf(s.path, (char *)&leaguedbfmt, (char *)str_teams);
    if (unknown_libname_1(s.path, 0, s.find)) FatalError((char *)str_fe1);
    if (FileOpenRead(s.path, &s.fh)) FatalError((char *)str_fe2);
    if (lseek(s.fh, 0, 0)) FatalError((char *)str_fe3);
    if (lseek(s.fh, HomeTeam * 0x2E8, 0) < 0) FatalError((char *)str_fe4);
    if (FileReadAt(s.fh, hmteamrec, -1, 0x2E8)) FatalError((char *)str_fe5);
    FileClose(&s.fh);
    sprintf(s.path, (char *)&leaguedbfmt2, (char *)str_teams);
    if (unknown_libname_1(s.path, 0, s.find)) FatalError((char *)str_fe1);
    if (FileOpenRead(s.path, &s.fh)) FatalError((char *)str_fe2);
    if (lseek(s.fh, 0, 0)) FatalError((char *)str_fe3);
    if (lseek(s.fh, VisTeam * 0x2E8, 0) < 0) FatalError((char *)str_fe7);
    if (FileReadAt(s.fh, awteamrec, -1, 0x2E8)) FatalError((char *)str_fe8);
    FileClose(&s.fh);
    OpenPlayerDBs(mode, &s.fh, &s.att, &s.season, &s.career, (char *)&leaguedbfmt, &s.out);
    LoadTeamRoster(mode, s.fh, s.att, s.season, s.career, s.out, 0);
    FileClose(&s.fh);
    FileClose(&s.att);
    FileClose(&s.season);
    if (!(mode & 6)) FileClose(&s.career);
    OpenPlayerDBs(mode, &s.fh, &s.att, &s.season, &s.career, (char *)&leaguedbfmt2, &s.out);
    LoadTeamRoster(mode, s.fh, s.att, s.season, s.career, s.out, 1);
    FileClose(&s.fh);
    FileClose(&s.att);
    FileClose(&s.season);
    if (!(mode & 6)) FileClose(&s.career);
    if (mode == 0 || mode == 2) {
        *(LineTab *)hmlinetab = *(LineTab *)(hmteamrec + 0xBC);
        *(LineTab *)awlinetab = *(LineTab *)(awteamrec + 0xBC);
    }
    for (i = 0; i < 8; i++) {
        if (hmscratch[i] != 0x64) hmroster[hmscratch[i] * 0x27] = 2;
        if (awscratch[i] != 0x64) awroster[awscratch[i] * 0x27] = 2;
    }
}
