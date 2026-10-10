/* Database save: save the databases under a new name. */
#include "nhl95.h"

typedef struct FindT {
    char reserved[21];
    char attrib;
    unsigned short wr_time;
    unsigned short wr_date;
    unsigned long size;
    char name[13];
} FindT;

int mkdir(const char *path);  /* Watcom CRT mkdir_ */

/* DRAFT (MenuSaveDbsAs): 1 byte short; x / y / err get ebp / stack / edi where the EXE has edi / ebp / stack, and the
   dir / name buffers swap slots (declaration orders tried). */
/* MenuSaveDbsAs (6C3BB) - PC only: menu "save databases as": ask for a new database name (up to 8 characters); unless
   cancelled, make the directory NAME.DBX - when it exists already, ask (dbexistsmsg at x, y) whether to replace it
   (DeleteDir) - and save the databases there (SaveDbsToDir, extension DB) as the current database curdbname, then
   redraw the roster screen. */
void MenuSaveDbsAs(int unused, int x, int y)
{
    FindT ft;
    char dir[16];
    char name[16];
    int err;
    int exists;
    int key;

    err = exists = 0;
    key = TextInputDialog((char *)str_EnterANewDatabase, dir, 8, 0x30, 0, 0, 0, 0, 5);
    if (dir[0] == 0 || key == 0x1B) return;
    strcpy(name, dir);
    strcat(dir, (char *)str_DBX);
    if ((unsigned char)(unknown_libname_1(dir, 0x10, &ft) == 0)) {
        if (MessageBox(-1, -1, (char *)dbexistsmsg, 2, (int)btn_LeagueExists, 2, x, y, -1) == 1) DeleteDir(dir);
        else exists = 1;
    }
    if (!exists) err = mkdir(dir);
    if (!exists && !err) {
        strcpy((char *)curdbname, name);
        SaveDbsToDir(dir, (char *)str_extDB);
        DrawEditRosters();
    }
}
