/* Gadgets: load the team rock cues and the three tune banks. */
#define LoadRockMusic LoadRockMusic_decl
#define LoadSample sub_8F13B_decl
#define FreeRockMusic FreeRockMusic_decl
#include "nhl95.h"
#undef LoadRockMusic
#undef LoadSample
#undef FreeRockMusic

int LoadSample(char *path);

/* LoadRockMusic (7DC8B, PC only): team 26 and above uses cue row 13. Six team cues, then three random cues that are
 not already on that row and not repeated, then the device bank, the team tune, and ROCKDITI.
 cursndbank is 20h while the banks load and 0 afterwards. */
void LoadRockMusic(void)
{
    struct {
        char path[0x10];
        int picked[3];
        int team;
    } s;
    int i;
    int slot;

    cursndbank = 0x20;
    if ((s.team = *(int *)((char *)&HomeTeam - 2) >> 16) >= 0x1A) s.team = 0x0D;
    i = 0;
    do {
        int team;
        int t3;
        int cue;

        team = s.team;
        t3 = team * 3;
        cue = ((signed char *)teamrockcuetbl)[i + t3 * 2 + 3];
        if (cue >= 0) {
            MakePath(s.path, fileoncd[rockcuepathsel[cue]] == 1 ? (char *)cddriveptr : 0,
                (char *)rockcuefiles[cue], 0);
            rockteamcues[i] = LoadSample(s.path);
        } else {
            slot = 0;
            rockteamcues[i] = slot;
        }
        i++;
    } while (i < 6);
    i = 0;
    do {
        int pickedcue;
        int ok;
        int j;

        do {
            ok = -1;
            slot = (rand() & 0x7FFF) % 0x12;
            for (j = 0; j < 6 && ok; j++) {
                int team;
                int t3;
                int cue;

                team = s.team;
                t3 = team * 3;
                cue = ((signed char *)teamrockcuetbl)[j + t3 * 2 + 3];
                if (cue == rockcuepool[slot]) ok = 0;
            }
            for (j = 0; j < i && ok; j++) {
                pickedcue = rockcuepool[slot];
                if (pickedcue == s.picked[j]) ok = 0;
            }
        } while (ok == 0);
        s.picked[i] = rockcuepool[slot];
        MakePath(s.path, fileoncd[rockcuepathsel[rockcuepool[slot]]] == 1 ? (char *)cddriveptr : 0,
            (char *)rockcuefiles[rockcuepool[slot]], 0);
        rockrandcues[i] = LoadSample(s.path);
        i++;
    } while (i < 3);
    if (sounddev == 8)
        MakePath(s.path, fileoncd[0x100] == 1 ? (char *)cddriveptr : 0, (char *)str_MTROCKU, 0);
    else if (musicon)
        MakePath(s.path, fileoncd[0x166] == 1 ? (char *)cddriveptr : 0, (char *)str_SBROCKU, 0);
    else
        MakePath(s.path, fileoncd[0x1F] == 1 ? (char *)cddriveptr : 0, (char *)str_ADROCKU, 0);
    rocktunes[0] = LoadSample(s.path);
    {
        int tune;

        tune = ((signed char *)teamrocktune)[*(int *)((char *)&HomeTeam - 2) >> 16];
        MakePath(s.path, fileoncd[teamtunepathsel[tune]] == 1 ? (char *)cddriveptr : 0,
            (char *)teamtunefiles[tune], 0);
    }
    rocktunes[1] = LoadSample(s.path);
    MakePath(s.path, fileoncd[0x161] == 1 ? (char *)cddriveptr : 0, (char *)str_ROCKDITI, 0);
    rocktunes[2] = LoadSample(s.path);
    cursndbank = 0;
}

/* FreeRockMusic (7DEC8, PC only): release the six team cues, the three random cues and
   the three tune banks. Its final pops share LoadRockMusic's exit. */
void FreeRockMusic(void)
{
    int i;

    for (i = 0; i < 6; i++) {
        if (rockteamcues[i]) {
            FreeSample(rockteamcues[i]);
            rockteamcues[i] = 0;
        }
    }
    for (i = 0; i < 3; i++) {
        if (rockrandcues[i]) {
            FreeSample(rockrandcues[i]);
            rockrandcues[i] = 0;
        }
    }
    for (i = 0; i < 3; i++) {
        if (rocktunes[i]) {
            FreeSample(rocktunes[i]);
            rocktunes[i] = 0;
        }
    }
}
