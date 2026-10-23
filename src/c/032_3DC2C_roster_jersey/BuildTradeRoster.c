/* Roster jersey: trade list. */
#include "nhl95.h"

/* BuildTradeRoster: fill list (28 entries of 22 bytes) from the team database named in dir.
 Entry i gets index i at +2. The 25 skater slots (team record +4Ch) and the 3 goalie slots (+B0h)
 become entries 0-24 and 25-27. An empty slot (-1) stores a zero position byte; otherwise the key
 record supplies position (+2), number (+1) and "<initial>. <last name>" (+3 and +13h). Returns 0
 or the first file error. Both file handles are closed. The counter i is a plain local that Watcom
 keeps on the stack (the frame struct holds only the key record, the path and the two handles). */
int BuildTradeRoster(char *dir, int team, unsigned char *list, unsigned char *rec)
{
    struct {
        unsigned char key[0x34];
        char path[0x20];
        int keyfh;
        int teamfh;
    } f;
    int i;
    int err;
    unsigned char *e;
    int k;

    f.teamfh = -1;
    f.keyfh = -1;
    i = 0;
    do {
        list[(i * 11) * 2 + 2] = i;
        i++;
    } while (i < 0x1C);
    MakePath(f.path, dir, (char *)leaguedbnames[4], (char *)str_extDB);
    err = FileOpenRead(f.path, &f.teamfh);
    if (!err) err = ReadTeamRec(f.teamfh, rec, team);
    FileClose(&f.teamfh);
    if (!err) {
        MakePath(f.path, dir, (char *)leaguedbnames[0], (char *)str_extDB);
        err = FileOpenRead(f.path, &f.keyfh);
    }
    if (!err) {
        for (i = 0; i < 0x19 && !err; i++) {
            k = ((int *)(rec + 0x4C))[i];
            e = list + (i * 11) * 2;
            if (k == -1) {
                e[0] = 0;
            } else {
                err = ReadKeyRec(f.keyfh, f.key, k);
                if (!err) {
                    e[0] = f.key[2];
                    e[1] = f.key[1];
                    e[3] = f.key[3];
                    e[4] = str_dot;
                    e[5] = str_space;
                    e[6] = 0;
                    strcat((char *)e + 3, (char *)f.key + 0x13);
                }
            }
        }
        for (i = 0; i < 3 && !err; i++) {
            k = ((int *)(rec + 0xB0))[i];
            e = list + ((i + 0x19) * 11) * 2;
            if (k == -1) {
                e[0] = 0;
            } else {
                err = ReadKeyRec(f.keyfh, f.key, k);
                if (!err) {
                    e[0] = f.key[2];
                    e[1] = f.key[1];
                    e[3] = f.key[3];
                    e[4] = str_dot;
                    e[5] = str_space;
                    e[6] = 0;
                    strcat((char *)e + 3, (char *)f.key + 0x13);
                }
            }
        }
    }
    FileClose(&f.keyfh);
    return err;
}
