/* File dialogs: game settings file. */
#include "nhl95.h"

/* ReadGameSettings (2D260) - PC only: read the 75h-byte game settings into set from GAMESET in directory dir, or
   from file dir itself when direct (errors "fe d2" / "fe dd2", "fe d3" read, "fe d4" close). Without direct, the
   result needs GAMESAV in dir too (sub_B3CC8). With sound off the music option (byte 5Ah bit 0) is cleared.
   Returns 1, or 0 when the GAMESAV check fails. */
int ReadGameSettings(unsigned char *set, char *dir, int direct)
{
    char path[64];
    int fh;

    if (direct == 0) {
        MakePath(path, dir, (char *)str_GameSet3, 0);
        if (FileOpenRead(path, &fh) != 0) FatalError((char *)str_fed2);
    } else {
        if (FileOpenRead(dir, &fh) != 0) FatalError((char *)str_fedd2);
    }
    if (FileReadAt(fh, set, -1, 0x75) != 0) FatalError((char *)str_fed3);
    if (FileClose(&fh) != 0) FatalError((char *)str_fed4);
    if (direct == 0) {
        MakePath(path, dir, (char *)str_GameSav3, 0);
        dir = (char *)sub_B3CC8(path);
    }
    if (dir != 0) {
        if (!musicon) set[0x5A] &= 0xFE;
        return 1;
    }
    return 0;
}
