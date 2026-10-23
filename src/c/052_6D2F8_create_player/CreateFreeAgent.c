/* Create player: making a new free agent. */
/* DRAFT (10.0 GA): 1963 vs 1963; see docs/UNSURE.md. The cluster size written sectors * bytes loads sectors
   first as the EXE; sp declared in the block that copies the ratings; the jersey number in k (the later loop
   counter: no dead copy); the goalie ratings copied through sp (the attribute record) and pal (dead by then: the
   source table), which gives the EXE's esi / ecx and leaves pal2 in edi. Left: the goalie loop's index and byte
   temporaries in ebx / dl (EXE edx / bl): one register-cycle slot short before it (an extra int temporary in the
   database sizes or at the jersey store gives the match; no natural form found). */
#define CreateFreeAgent CreateFreeAgent_decl
#define RandomizeNewRatings RandomizeNewRatings_decl
#define MessageBox MessageBox_decl
#define InputDialog InputDialog_decl
#include "nhl95.h"
#undef CreateFreeAgent
#undef RandomizeNewRatings
#undef MessageBox
#undef InputDialog

void RandomizeNewRatings(unsigned char *rec, unsigned char *r, unsigned char *out);
int MessageBox(int x, int y, char *msg, int n, int b, int nb, int *mx, int *my, int wait);
int InputDialog(int *lines, int n, char *buf, int len, int a, int b, int c, int d, int e);

typedef struct { unsigned short total, avail, sectors, bytes; } DiskFree;

/* CreateFreeAgent (706E2, PC only): the roster editor's "create player". Check the disk has room for the new
   records in every database (in clusters; else say how many KB are needed) and that the free-agent list is not
   full (30). Ask player or goalie, the name (split into first and last), a skater's position (C, L, R or D,
   asked again until it is one of them) and the jersey number; then run the create-player screen
   (CreatePlayerLoop) on the new key record. When it is kept, write the temporary league databases with the new
   player's key, season, career and attribute records (a skater's ratings from the screen's values, randomized
   into the career record by RandomizeNewRatings; a goalie's from its own table) and reload the rosters; on an
   error say the player was not added. mx, my: the mouse position for the message boxes. No result. */
void CreateFreeAgent(int a, int *mx, int *my)
{
    struct {
        char msg[0x54];
        unsigned char gseason[0x38];
        unsigned char key[0x34];
        unsigned char sseason[0x30];
        unsigned char gcareer[0x2C];
        unsigned char scareer[0x28];
        char input[0x20];
        char name[0x20];
        int sizes[7];
        unsigned char satt[0x14];
        unsigned char gatt[0x10];
        DiskFree df;
        int fhcar;
        int fhsea;
        int fhkey;
        int fhatt;
    } s;
    int csize;
    int n;
    int i;
    int kind;
    int err;
    unsigned char *pal;
    unsigned char *pal2;
    char c;
    int k;
    unsigned char *dp;

    s.fhatt = s.fhcar = s.fhsea = s.fhkey = -1;
    if (_dos_getdiskfree(0, &s.df)) FatalError((char *)str_ErrDiskFree);
    csize = s.df.sectors * s.df.bytes;
    s.sizes[0] = seasondb_size + 0x36;
    s.sizes[1] = careerdb_size + 0x2C;
    s.sizes[5] = attdb_size + 0x14;
    s.sizes[3] = keydb_size + 0x34;
    s.sizes[2] = carteamsdb_size;
    s.sizes[4] = teamsdb_size;
    s.sizes[6] = 0;
    n = 0;
    for (i = 0; i < 6; i++) n += (s.sizes[i] + csize - 1) / csize;
    if (n > s.df.avail) {
        sprintf((char *)str_XXXKbytesOfFree, (char *)str_3dKbytesOfFree, n * csize / 1024);
        MessageBox(-1, -1, (char *)off_D1077, 3, 0, 0, mx, my, 0x320);
        return;
    }
    if (facount >= 0x1E) {
        msglines[0] = (int)str_NotEnoughSpaceTo;
        msglines[1] = (int)str_ANewFreeAgent;
        MessageBox(-1, -1, (char *)msglines, 2, 0, 0, mx, my, -1);
        return;
    }
    msglines[0] = (int)str_CreateAPlayerOr;
    kind = MessageBox(-1, -1, (char *)msglines, 1, (int)unk_D0EDD, 2, mx, my, -1);
    if (kind < 0) return;
    if (kind == 0) msglines[0] = (int)str_EnterNewPlayerName;
    else msglines[0] = (int)str_EnterNewGoalieName;
    s.input[0] = 0;
    if (InputDialog(msglines, 1, s.input, 0x1F, 0xBA, 0, 0, 0, 0) == -1) return;
    if (!strlen(s.input)) return;
    s.key[3] = 0;
    s.key[0x13] = 0;
    SplitPlayerName(s.input, (char *)s.key + 3, (char *)s.key + 0x13);
    strcpy(s.name, (char *)s.key + 3);
    strcat(s.name, (char *)&str_space);
    strcat(s.name, (char *)s.key + 0x13);
    if (kind == 0) {
        msglines[0] = (int)str_EnterAPositionFor;
        msglines[1] = (int)s.name;
        msglines[2] = (int)str_LCRD;
        s.input[0] = 0;
        do {
            if (InputDialog(msglines, 3, s.input, 1, 0xE, 0, 0, 0, 0) == -1) return;
            if (!strlen(s.input)) return;
            strupr(s.input);
            c = s.input[0];
        } while (((c != 'C' && c != 'L' && c != 'R' && c != 'D') != 0) != 0);
        memcpy(s.key + 2, s.input, 1);
    } else {
        s.key[2] = 'G';
    }
    *(int *)(s.key + 0x2C) = seasondb_size;
    *(int *)(s.key + 0x28) = careerdb_size;
    *(int *)(s.key + 0x24) = attdb_size;
    memset(s.key + 0x30, 0, 4);
    msglines[0] = (int)str_EnterAJerseyNumber;
    msglines[1] = (int)s.name;
    s.input[0] = 0;
    k = InputDialog(msglines, 2, s.input, 2, 0x16, -1, 0, 0x63, 0);
    if (k < 0) return;
    s.key[1] = k;
    s.key[0] = 0xFF;
    pal = pal2 = (unsigned char *)sub_8CCA8((char *)str_Temp, 0x300, 0x20);
    sub_8FFB0(0, 0x100, pal2);
    if (CreatePlayerLoop(s.key) >= 1) {
        unsigned char *sp;

        FadePalStep(1, pal, 0x10);
        sub_B392C(0);
        WriteLeagueDbsMem((char *)str_TMP);
        MakePath((char *)unk_EA968, 0, (char *)leaguedbnames[0], (char *)str_TMP);
        err = FileOpenWrite((char *)unk_EA968, &s.fhkey);
        if (!err) {
            MakePath((char *)unk_EA968, 0, (char *)leaguedbnames[5], (char *)str_TMP);
            err = FileOpenWrite((char *)unk_EA968, &s.fhsea);
        }
        if (!err) {
            MakePath((char *)unk_EA968, 0, (char *)leaguedbnames[1], (char *)str_TMP);
            err = FileOpenWrite((char *)unk_EA968, &s.fhcar);
        }
        if (!err) {
            MakePath((char *)unk_EA968, 0, (char *)leaguedbnames[2], (char *)str_TMP);
            err = FileOpenWrite((char *)unk_EA968, &s.fhatt);
        }
        if (!err) {
            if (s.key[2] != 'G') {
                memset(s.sseason, 0, 0x2F);
                memset(s.scareer, 0, 0x28);
                err = FileWriteAt(s.fhsea, s.sseason, *(int *)(s.key + 0x2C), 0x2F);
                if (!err) {
                    dp = s.satt;
                    sp = &byte_D0F94;
                    for (k = 0; k < 0xF; k++) dp[((signed char *)off_D08B9)[k + 3]] = sp[k];
                    RandomizeNewRatings(s.key, s.satt, s.scareer);
                    err = FileWriteAt(s.fhcar, s.scareer, *(int *)(s.key + 0x28), 0x28);
                }
                if (!err) err = FileWriteAt(s.fhatt, s.satt, *(int *)(s.key + 0x24), 0x14);
            } else {
                memset(s.gseason, 0, 0x36);
                memset(s.gcareer, 0, 0x2C);
                err = FileWriteAt(s.fhsea, s.gseason, *(int *)(s.key + 0x2C), 0x36);
                if (!err) {
                    sp = s.gatt;
                    pal = &byte_D0FE0;
                    for (k = 0; k < 0xB; k++) sp[((signed char *)off_D0A04)[k + 3]] = pal[k];
                    err = FileWriteAt(s.fhcar, s.gcareer, *(int *)(s.key + 0x28), 0x2C);
                }
                if (!err) err = FileWriteAt(s.fhatt, s.gatt, *(int *)(s.key + 0x24), 0x10);
            }
            if (!err) err = FileWriteAt(s.fhkey, s.key, keydb_size, 0x34);
        }
        FileClose(&s.fhatt);
        FileClose(&s.fhcar);
        FileClose(&s.fhsea);
        FileClose(&s.fhkey);
        if (!err) {
            LoadTempDatabases();
            LoadRosterList(0);
            LoadRosterList(1);
        }
        DeleteTempDatabases();
        if (err) {
            msglines[0] = (int)str_ErrorWhileMakingNew;
            strcpy(s.msg, (char *)str_NewPlayer);
            strcat(s.msg, (char *)str_NotAddedToDatabases);
            FadePalStep(0, pal2, 0x10);
            msglines[1] = (int)s.msg;
            MessageBox(-1, -1, (char *)msglines, 2, 0, 0, mx, my, -1);
            FadePalStep(1, pal2, 0x10);
        } else {
            dbdirty = 1;
        }
    } else {
        FadePalStep(1, pal, 0x10);
    }
    DrawEditRosters();
    FadePalStep(0, pal2, 0x10);
    FreeMemBlock((int)pal2);
}
