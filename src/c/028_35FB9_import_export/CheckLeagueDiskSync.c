/* Import/export: the league on disk has to match the one loaded. */
#define CheckLeagueDiskSync CheckLeagueDiskSync_decl
#define GetLeagueId GetLeagueId_decl
#define ReadLeagueTeamEntry ReadLeagueTeamEntry_decl
#include "nhl95.h"
#undef CheckLeagueDiskSync
#undef GetLeagueId
#undef ReadLeagueTeamEntry

/* GetLeagueId saves ecx, so the sync flag can stay there across the call. */
int GetLeagueId(char *dir, void *out);
#pragma aux GetLeagueId parm [eax] [edx] value [eax] modify [eax edx ebx];

int ReadLeagueTeamEntry(int fh, void *entry, int n);

/* CheckLeagueDiskSync: team is an entry of teams (1Eh bytes). When its byte +17h is 1 and this
 league's id is that team, or the id cannot be read and the entry's +18h or +16h says so, the
 disk must be imported (bit 2 of +16h) before a game. Otherwise, when sync is set, probe or wait
 for the floppy and compare PINFO.DB: bit 0 of the disk entry's +16h means it must be exported.
 With sync clear, say to pick the first team. A set message is filled with the league name (cut
 at the dot) and the team name. Returns 0, 4 when a message was shown, or the file error. */
int CheckLeagueDiskSync(char *dir, char *teams, int team, int sync, int probe)
{
    struct {
        char fmt[0x40];
        char path[0x20];
        unsigned char entry[0x20];
        char league[0x10];
        char teamname[0x0C];
        int id;
        int btn;
        int my;
        int mx;
        int fh;
    } s;
    int err;
    char *rec;
    int id;

    s.fh = -1;
    err = 0;
    rec = teams + team * 30;
    *(char **)(leaguediskmsg + 8) = 0;
    id = GetLeagueId(dir, &s.id);
    if (rec[0x17] == 1) {
        if (id == team || (id < 0 && (rec[0x18] == 1 || (rec[0x16] & 1)))) {
            if (rec[0x16] & 2) {
                *(char **)(leaguediskmsg + 8) = (char *)str_MustBeImportedFrom;
                err = 4;
            }
        } else if (sync) {
            if (probe) {
                FmtFromLeague(s.fmt, rec, dir);
                msg_InsertDisk_arg = (int)s.fmt;
                err = FindLeagueFloppy(dir, rec, (char *)-1);
            } else
                err = WaitLeagueFloppy(dir, rec, (char *)-1);
            if (!err) {
                MakePath(s.path, (char *)&str_floppydrv, (char *)str_PINFO, (char *)str_extDB);
                err = FileOpenRead(s.path, &s.fh);
                if (!err)
                    err = ReadLeagueTeamEntry(s.fh, s.entry, team);
                FileClose(&s.fh);
                if (!err && (s.entry[0x16] & 1)) {
                    *(char **)(leaguediskmsg + 8) = (char *)str_MustBeExportedTo;
                    err = 4;
                }
            }
        } else {
            sub_B2DCA(&s.mx, &s.my, &s.btn);
            MessageBox(-1, -1, (char *)firstteammsg, 2, 0, 0, (int)&s.my, (int)&s.btn, -1);
            err = 4;
        }
    }
    if (*(int *)(leaguediskmsg + 8)) {
        strcpy(s.league, dir);
        s.league[_fstrcspn(s.league, (char *)&str_dot)] = 0;
        *(char **)(leaguediskmsg + 4) = s.league;
        strcpy(s.teamname, rec);
        *(char **)(leaguediskmsg + 12) = s.teamname;
        sub_B2DCA(&s.mx, &s.my, &s.btn);
        MessageBox(-1, -1, (char *)leaguediskmsg, 5, 0, 0, (int)&s.my, (int)&s.btn, -1);
    }
    return err;
}
