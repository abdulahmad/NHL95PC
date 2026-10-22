/* Database merge: merging a human team's databases into the master league. */
#define WriteTeamRec WriteTeamRec_decl
#define MergeTeamDbs MergeTeamDbs_decl
#define MergeScheduleDb MergeScheduleDb_decl
#include "nhl95.h"
#undef WriteTeamRec
#undef MergeTeamDbs
#undef MergeScheduleDb

int WriteTeamRec(int fh, void *rec, int n);

/* MergeTeamDbs (3A9AA, PC only; owner of MergeTeamDbs_ret): merge the changes one copy of a league made into the
   master copy. For each of the 1Ah teams, the team records of the original league (odir, .DB), the changed copy
   (ndir / next) and the master (mdir / mext) give the master the copy's differences (MergeTeamRecDelta, team
   who); then for each of the changed team's 25 skaters and 3 goalies (record +4Ch / +B0h, -1 for none) its key
   record gives the season record index, and the season (or goalie season) records are merged the same way
   (MergeSeasonRecDelta, MergeGoalieRecDelta). Stops at the first I/O error. odir, ndir, mdir: the three league
   directories; next, mext: the copy's and the master's extensions; who: passed on to the deltas.
   Result: 0 or the I/O error. */
int MergeTeamDbs(char *odir, char *ndir, char *mdir, char *next, char *mext, int who)
{
    int err;
    struct {
        unsigned char nrec[0x2E8];
        unsigned char orec[0x2E8];
        unsigned char mrec[0x2E8];
        unsigned short gn[0x1C];
        unsigned short gm[0x1C];
        unsigned short go[0x1C];
        unsigned char key[0x34];
        short so[0x18];
        short sn[0x18];
        short sm[0x18];
        char path[0x20];
        int sofh;
        int smfh;
        int snfh;
        int kfh;
        int tofh;
        int tmfh;
        int tnfh;
    } s;
    int t;

    s.sofh = s.smfh = s.snfh = s.kfh = s.tofh = s.tmfh = s.tnfh = -1;
    MakePath(s.path, odir, (char *)leaguedbnames[4], (char *)str_extDB);
    err = FileOpenRead(s.path, &s.tofh);
    if (!err) {
        MakePath(s.path, ndir, (char *)leaguedbnames[4], next);
        err = FileOpenRead(s.path, &s.tnfh);
    }
    if (!err) {
        MakePath(s.path, mdir, (char *)leaguedbnames[4], mext);
        err = FileOpenRW(s.path, &s.tmfh);
    }
    if (!err) {
        MakePath(s.path, odir, (char *)leaguedbnames[0], (char *)str_extDB);
        err = FileOpenRead(s.path, &s.kfh);
    }
    if (!err) {
        MakePath(s.path, odir, (char *)leaguedbnames[5], (char *)str_extDB);
        err = FileOpenRead(s.path, &s.sofh);
    }
    if (!err) {
        MakePath(s.path, ndir, (char *)leaguedbnames[5], next);
        err = FileOpenRead(s.path, &s.snfh);
    }
    if (!err) {
        MakePath(s.path, mdir, (char *)leaguedbnames[5], mext);
        err = FileOpenRW(s.path, &s.smfh);
    }
    for (t = 0; t < 0x1A; t++) {
        int k;
        int i;

        if (!err) err = ReadTeamRec(s.tofh, s.orec, t);
        if (!err) err = ReadTeamRec(s.tnfh, s.nrec, t);
        if (!err) err = ReadTeamRec(s.tmfh, s.mrec, t);
        if (!err) {
            MergeTeamRecDelta(s.orec, s.nrec, s.mrec, who, t);
            err = WriteTeamRec(s.tmfh, s.mrec, t);
        }
        if (err) continue;
        for (i = 0; i < 25 && !err; i++) {
            if ((k = ((int *)(s.nrec + 0x4C))[i]) == -1) continue;
            err = ReadKeyRec(s.kfh, s.key, k);
            if (!err) err = ReadSeasonRec(s.sofh, s.so, *(int *)(s.key + 0x2C));
            if (!err) err = ReadSeasonRec(s.snfh, s.sn, *(int *)(s.key + 0x2C));
            if (!err) err = ReadSeasonRec(s.smfh, s.sm, *(int *)(s.key + 0x2C));
            if (!err) {
                MergeSeasonRecDelta(s.so, s.sn, s.sm, who, t);
                err = WriteSeasonRec(s.smfh, s.sm, *(int *)(s.key + 0x2C));
            }
        }
        for (i = 0; i < 3 && !err; i++) {
            if ((k = ((int *)(s.nrec + 0xB0))[i]) == -1) continue;
            err = ReadKeyRec(s.kfh, s.key, k);
            if (!err) err = ReadGoalieSeasonRec(s.sofh, s.go, *(int *)(s.key + 0x2C));
            if (!err) err = ReadGoalieSeasonRec(s.snfh, s.gn, *(int *)(s.key + 0x2C));
            if (!err) err = ReadGoalieSeasonRec(s.smfh, s.gm, *(int *)(s.key + 0x2C));
            if (!err) {
                MergeGoalieRecDelta(s.go, s.gn, s.gm, who, t);
                err = WriteGoalieSeasonRec(s.smfh, s.gm, *(int *)(s.key + 0x2C));
            }
        }
    }
    FileClose(&s.smfh);
    FileClose(&s.snfh);
    FileClose(&s.sofh);
    FileClose(&s.kfh);
    FileClose(&s.tmfh);
    FileClose(&s.tnfh);
    FileClose(&s.tofh);
    return err;
}

/* MergeScheduleDb (3AE1E, PC only; ends in MergeTeamDbs_ret): bring team's games of the copy's schedule
   (leaguedbnames[6] in sdir / sext) into the master's (ddir / dext): the master's game count (*count) becomes the
   larger of the two (written back when the copy's is larger), and every game of the copy (count capped: from
   444h on, 4ADh) with team at home or away is written over the master's. sdir, ddir: the two league directories;
   sext, dext: their extensions; team: the team; count: the master's game count out. Result: 0 or the I/O
   error. */
int MergeScheduleDb(char *sdir, char *ddir, char *sext, char *dext, int team, int *count)
{
    struct {
        char path[0x20];
        unsigned char game[8];
        int sfh;
        int dfh;
        short sn;
        short pad1;
        short dn;
        short pad2;
    } s;
    int err;
    int i;

    s.sfh = s.dfh = -1;
    MakePath(s.path, sdir, (char *)leaguedbnames[6], sext);
    err = FileOpenRead(s.path, &s.sfh);
    if (!err) {
        MakePath(s.path, ddir, (char *)leaguedbnames[6], dext);
        err = FileOpenRW(s.path, &s.dfh);
    }
    if (!err) err = FileReadAt(s.sfh, &s.sn, 0, 2);
    if (!err) err = FileReadAt(s.dfh, &s.dn, 0, 2);
    if (!err) {
        *count = s.dn;
        if (s.sn > s.dn) {
            *count = s.sn;
            err = FileWriteAt(s.dfh, &s.sn, 0, 2);
        }
    }
    if (s.sn >= 0x444) s.sn = 0x4AD;
    for (i = 0; i < s.sn && !err; i++) {
        err = ReadSchedGame(s.sfh, s.game, i);
        if (!err && (team == s.game[2] || team == s.game[3])) err = WriteSchedGame(s.dfh, s.game, i);
    }
    FileClose(&s.dfh);
    FileClose(&s.sfh);
    return err;
}
