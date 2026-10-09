/* Database merge: floppy prompt. */
#include "nhl95.h"

/* WaitLeagueFloppy (3D84F) - ask for the floppy with league file (message box at the mouse); unless cancelled (button
   4) look for it again (FindLeagueFloppy). Returns that result, or -1 when cancelled. */
int WaitLeagueFloppy(char *file, char *name, char *dir)
{
    char buf[0x40];
    int btn;
    int y;
    int x;
    int r;

    FmtFromLeague(buf, name, file);
    msg_InsertDisk_arg = (int)buf;
    sub_B2DCA(&btn, &y, &x);
    r = MessageBox(-1, -1, (char *)msg_InsertDisk, 4, 0, 0, (int)&y, (int)&x, -1);
    if (r != 4) r = FindLeagueFloppy(file, name, dir);
    if (r == 4) return -1;
    return r;
}
