/* BuildTeamRosterList - fill list (28 entries of 1Bh bytes) with team's roster: entry i gets index i at +2; the 25
   skater slots (key offsets at team record +4Ch) and the 3 goalie slots (+B0h) become entries 0-24 and 25-27: an
   empty slot (-1) is position 0, number 64h, status 0; else position (key +2), number (+1), status 3, the key offset
   at +4 and "<initial>. <last name>" (key +3 and +13h) at +8. The 8 dressed-player bytes at team record +E4h mark
   their entries with status 2. *rec gets the team record pointer. */
#include "nhl95.h"

void BuildTeamRosterList(int team, unsigned char *list, unsigned char **rec)
{
    int i;
    int k;
    unsigned char *e;
    unsigned char *p;
    unsigned char t;

    for (i = 0; i < 0x1C; i++) list[i * 27 + 2] = i;
    *rec = TeamRecPtr(team);
    for (i = 0; i < 0x19; i++) {
        k = ((int *)(*rec + 0x4C))[i];
        e = list + i * 27;
        if (k == -1) {
            e[0] = 0;
            e[1] = 0x64;
            e[2] = 0;
            e[3] = 0;
        } else {
            p = KeyDbPtr(k);
            e[0] = p[2];
            e[1] = p[1];
            e[3] = 3;
            *(int *)(e + 4) = k;
            e[8] = p[3];
            e[9] = str_dot;
            e[10] = str_space;
            e[11] = 0;
            strcat((char *)e + 8, (char *)p + 0x13);
        }
    }
    for (i = 0; i < 3; i++) {
        k = ((int *)(*rec + 0xB0))[i];
        e = list + (i + 0x19) * 27;
        if (k == -1) {
            e[0] = 0;
            e[1] = 0x64;
            e[2] = 0;
            e[3] = 0;
        } else {
            p = KeyDbPtr(k);
            e[0] = p[2];
            e[1] = p[1];
            e[3] = 3;
            *(int *)(e + 4) = k;
            e[8] = p[3];
            e[9] = str_dot;
            e[10] = str_space;
            e[11] = 0;
            strcat((char *)e + 8, (char *)p + 0x13);
        }
    }
    for (i = 0; i < 8; i++) {
        t = (*rec)[i + 0xE4];
        if (t != 0x64) list[t * 27 + 3] = 2;
    }
}
