/* Database merge: team names from a team database file. */
#include "nhl95.h"

/* ReadTeamNames (3DAB9) - PC only: read the names of the 26 teams (records of 2E8h bytes) of file path into out
   (21 bytes per team): the 21-byte name at +5 when full, else the 13-byte name at +1Ah. Stops at the first
   error. Returns the error (0 ok). */
int ReadTeamNames(char *path, char *out, int full)
{
    int fh;
    int err;
    int i;

    fh = -1;
    err = FileOpenRead(path, &fh);
    if (err == 0) {
        for (i = 0; i < 26 && err == 0; i++) {
            if (full) err = FileReadAt(fh, out + i * 21, i * 0x2E8 + 5, 21);
            else err = FileReadAt(fh, out + i * 21, i * 0x2E8 + 0x1A, 13);
        }
    }
    FileClose(&fh);
    return err;
}
