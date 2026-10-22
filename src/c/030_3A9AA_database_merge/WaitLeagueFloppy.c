/* Database merge: floppy prompt. */
#include "nhl95.h"

/* WaitLeagueFloppy: ask for the floppy with league file (message box at the mouse); unless cancelled (button
 4) look for it again (FindLeagueFloppy). Returns that result, or -1 when cancelled.
 DRAFT: 134 vs 142. The EXE keeps r in edx (mov edx, eax after both calls, mov eax, edx at the end); C keeps it
 in eax. The x / y slots are swapped too. The ternary return gives the EXE file / name registers. */
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
    return r == 4 ? -1 : r;
}
