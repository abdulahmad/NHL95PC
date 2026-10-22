/* BuildTeamRosterList - DRAFT 344 vs 344 (3 differing, 10.0 GA). The parameter team is reused as the scratch
 variable (the goalie entry index team = i + 19h and the key pointer team = KeyDbPtr(k)), which keeps it in esi
 from the entry as in the EXE. The dressed byte read twice, with no byte local, gives the EXE's add edx, ebx /
 mov ah, [edx+0E4h]. Left: the goalie key load swaps eax / ecx (EXE mov ecx, [edi] / mov eax, ebx). Tried for
 that: *(int *)(*rec + i * 4 + 0xB0), ((int *)*rec)[i + 0x2C], (*(int **)rec)[i + 0x2C], 0xB0 + *rec, team
 assigned before k or inside the e expression, k / i / e declaration orders, the skater load spelled the same
 ways (worse), permute (321 candidates). Earlier: a named team was eliminated, an aux returning esi reloaded eax
 at once, naming the fill byte lengthened the copies. Do not retry those.
 Fill list (28 entries of 1Bh bytes) with team's roster: entry i gets index i at +2; the 25
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
            team = (int)KeyDbPtr(k);
            e[0] = ((unsigned char *)team)[2];
            e[1] = ((unsigned char *)team)[1];
            e[3] = 3;
            *(int *)(e + 4) = k;
            e[8] = ((unsigned char *)team)[3];
            e[9] = str_dot;
            e[10] = str_space;
            e[11] = 0;
            strcat((char *)e + 8, (char *)team + 0x13);
        }
    }
    for (i = 0; i < 3; i++) {
        k = ((int *)(*rec + 0xB0))[i];
        team = i + 0x19;
        e = list + team * 27;
        if (k == -1) {
            e[0] = 0;
            e[1] = 0x64;
            e[2] = 0;
            e[3] = 0;
        } else {
            team = (int)KeyDbPtr(k);
            e[0] = ((unsigned char *)team)[2];
            e[1] = ((unsigned char *)team)[1];
            e[3] = 3;
            *(int *)(e + 4) = k;
            e[8] = ((unsigned char *)team)[3];
            e[9] = str_dot;
            e[10] = str_space;
            e[11] = 0;
            strcat((char *)e + 8, (char *)team + 0x13);
        }
    }
    for (i = 0; i < 8; i++) {
        if ((*rec)[i + 0xE4] != 0x64) list[(*rec)[i + 0xE4] * 27 + 3] = 2;
    }
}
