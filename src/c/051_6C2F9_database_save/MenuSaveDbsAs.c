/* Database save: the databases under a new name. */
#include "nhl95.h"

typedef struct FindT {
    char reserved[21];
    char attrib;
    unsigned short wr_time;
    unsigned short wr_date;
    unsigned long size;
    char name[0x0E];
} FindT;

int mkdir(const char *path);  /* Watcom CRT mkdir_ */

/* MenuSaveDbsAs: menu "save databases as": ask for a new database name (up to 8 characters); unless
 cancelled, make the directory NAME.DBX - when it exists already, ask (dbexistsmsg at x, y) whether to replace it
 (DeleteDir) - and save the databases there (SaveDbsToDir, extension DB) as the current database curdbname, then
 redraw the roster screen. */
void MenuSaveDbsAs(int unused, int x, int y)
{
    struct {
        FindT ft;
        char name[16];
        char dir[16];
        int err;
    } s;
    int exists;
    int key;

    s.err = exists = 0;
    key = TextInputDialog((char *)str_EnterANewDatabase, s.dir, 8, 0x30, 0, 0, 0, 0, 5);
    if (s.dir[0] == 0 || key == 0x1B) return;
    strcpy(s.name, s.dir);
    strcat(s.dir, (char *)str_DBX);
    key = (unsigned char)(unknown_libname_1(s.dir, 0x10, &s.ft) == 0);  /* key reused: the directory exists */
    if (key) {
        if (MessageBox(-1, -1, (char *)dbexistsmsg, 2, (int)btn_LeagueExists, 2, x, y, -1) == 1) DeleteDir(s.dir);
        else exists = 1;
    }
    if (!exists) s.err = mkdir(s.dir);
    if (!exists && !s.err) {
        strcpy((char *)curdbname, s.name);
        SaveDbsToDir(s.dir, (char *)str_extDB);
        DrawEditRosters();
    }
}
