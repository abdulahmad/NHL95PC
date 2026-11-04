/* Database save: save the current databases. */
#define CheckDatabases CheckDatabasesDecl
#define DrawEditRosters DrawEditRostersDecl
#define SaveDbsToDir SaveDbsToDirDecl
#include "nhl95.h"
#undef CheckDatabases
#undef DrawEditRosters
#undef SaveDbsToDir

/* 13 zero bytes in the code segment. A struct copy reloads ds from cs. */
void copy13(void *s, void *d);
#pragma aux copy13 = "movsd" "movsd" "movsd" "movsb" parm [esi] [edi] modify [edi esi];

int CheckDatabases(int x, int y);
void DrawEditRosters(void);
void SaveDbsToDir(char *dir, char *ext);

/* MenuSaveDbs: menu "save databases": confirm (savedbbtns), and when the databases check out
 (CheckDatabases at the dialog x y) copy "current" into curdbname, say they are saving, and write
 them to the empty directory with extension DB. Then restore the dialog background and redraw. */
void MenuSaveDbs(int unused, int x, int y)
{
    char dir[16];
    int ok;

    (void)unused;
    copy13(&unk13_6BF3D, dir);
    msglines[0] = (int)str_SaveAsGameDatabases;
    if (MessageBox(-1, -1, (char *)msglines, 1, (int)savedbbtns, 2, x, y, -1) != 1) return;
    ok = CheckDatabases(x, y);
    DrawEditRosters();
    if (!ok) return;
    *(struct { char b[8]; } *)curdbname = *(struct { char b[8]; } *)str_Current2;
    msglines[0] = (int)str_SavingDatabases;
    MessageBox(-1, -1, (char *)msglines, 1, 0, 0, x, y, 0);
    SaveDbsToDir(dir, (char *)str_extDB);
    RestoreDialogBg();
    DrawEditRosters();
}
