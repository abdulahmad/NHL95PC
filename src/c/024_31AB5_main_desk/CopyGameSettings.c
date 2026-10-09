/* Main desk: settings files. */
#include "nhl95.h"

/* CopyGameSettings (32C9E) - copy the game settings record (75h bytes) from file src to dst: a new dst gets the whole
   record; an existing one keeps its own record except the dword at +59h and the 0Dh bytes at +4, which come from
   src. Returns 0, or -1 on any file error. */
typedef struct GameSettings { unsigned char b[0x75]; } GameSettings;

int CopyGameSettings(char *src, char *dst)
{
    GameSettings in;
    GameSettings cur;
    int fh;

    if (FileOpenRead(src, &fh)) return -1;
    if (FileReadAt(fh, &in, -1, 0x75)) return -1;
    if (FileClose(&fh)) return -1;
    if (FileOpenRW(dst, &fh)) {
        if (FileCreate(dst, &fh)) return -1;
        cur = in;
    } else {
        if (FileReadAt(fh, &cur, -1, 0x75)) return -1;
        *(int *)&cur.b[0x59] = *(int *)&in.b[0x59];
        memcpy(&cur.b[4], &in.b[4], 0xD);
    }
    if (FileWriteAt(fh, &cur, 0, 0x75)) return -1;
    if (FileClose(&fh)) return -1;
    return 0;
}
