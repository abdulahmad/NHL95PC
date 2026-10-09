/* Highlights: view. */
#include "nhl95.h"

/* ViewHilights (80075) - pick a saved highlight of the current league, read its 9652h-byte record from the file into
   hilightrec and play it. Returns 0 on success, else the error. */
int ViewHilights(void)
{
    char path[0x20];
    char name[0x10];
    int fh;
    int idx;
    int r;

    fh = -1;
    SetDialogColors(0xF9, 0xFA, 0xF8, 0xFA, 0);
    r = SelectHilight(name, &idx, &curleague, 0, 0);
    if (!r) {
        MakePath(path, (char *)&curleague, name, 0);
        r = FileOpenRead(path, &fh);
    }
    if (!r) r = FileReadAt(fh, hilightrec, idx * 0x9652, 0x9652);
    FileClose(&fh);
    if (!r) PlayHilight();
    return r;
}
