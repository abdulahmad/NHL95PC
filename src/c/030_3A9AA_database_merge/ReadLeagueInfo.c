/* Database merge: league info file. */
#include "nhl95.h"

/* ReadLeagueInfo (3D8DD) - PC only: read the league header PINFO.DB of directory dir (see WriteLeagueInfo): words
   a at 0, b at 2, *saved at 4, the 13-byte name at 6, word d at 13h, the 11-byte password pw at 15h and the
   30Ch-byte team table teams at 20h, stopping at the first error; then *saved = GAME.SAV exists there. Without
   PINFO.DB: "can't read league <current league name>" message box at the mouse and error 1. Returns the error. */
int ReadLeagueInfo(char *dir, void *teams, char *pw, short *b, void *a, void *d, int *saved, char *name)
{
    int btn;
    int fh;
    int mx;
    int my;
    char lg[16];
    char path[32];
    int err;

    fh = -1;
    MakePath(path, dir, (char *)str_PINFO, (char *)str_extDB);
    if (sub_B3CC8(path) == 0) {
        err = 1;
        strcpy(lg, (char *)&curleague);
        lg[_fstrcspn(lg, (char *)&str_dot)] = 0;
        *(char **)(lgreaderrmsg + 4) = lg;
        SetDialogColors(0xB, 0x11, 5, 0x11, 0);
        sub_B2DCA(&mx, &my, &btn);
        MessageBox(-1, -1, (char *)lgreaderrmsg, 2, 0, 0, (int)&my, (int)&btn, -1);
    } else {
        err = FileOpenRead(path, &fh);
        if (err == 0) err = FileReadAt(fh, a, 0, 2);
        if (err == 0) err = FileReadAt(fh, b, 2, 2);
        if (err == 0) err = FileReadAt(fh, saved, 4, 2);
        if (err == 0) err = FileReadAt(fh, name, 6, 13);
        if (err == 0) err = FileReadAt(fh, d, 0x13, 2);
        if (err == 0) err = FileReadAt(fh, pw, 0x15, 11);
        if (err == 0) err = FileReadAt(fh, teams, 0x20, 0x30C);
        FileClose(&fh);
        MakePath(path, dir, (char *)str_Game2, (char *)str_Sav2);
        *saved = FileExists(path);
    }
    return err;
}
