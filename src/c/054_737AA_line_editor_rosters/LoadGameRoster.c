/* Line editor / rosters: loading a team's game roster. */
#define LoadGameRoster LoadGameRoster_decl
#include "nhl95.h"
#undef LoadGameRoster

int open(const char *path, int access, ...);  /* Watcom CRT open_ */
int read(int fh, void *buf, unsigned len);  /* Watcom CRT read_ */
int j___close(int fh);  /* CRT close thunk */

/* LoadGameRoster (77FF5, PC only): fill the game roster table (gmroster, 16h-byte entries: status, jersey, slot,
   position byte, ". " and the 16-byte name) for team from the league's KEY file: number the 1Ch slots, then for
   each of the 25 skaters and 3 goalies of the team record (dword_DBC7C / dword_DBCE0, 2E8h per team; negative:
   an empty slot, status 0) read his 34h-byte key record and copy its status, jersey number, position and name.
   A missing or unreadable file is fatal ("A1"-"A8"). team: the team. No result. */
void LoadGameRoster(int team)
{
    struct {
        unsigned char rec[0x34];
        unsigned char find[0x2C];
        char path[0x20];
        int i;
    } s;
    int fh;
    int n;
    int k;

    s.i = 0;
    do { n = s.i * 11; gmrosterslot[n * 2] = s.i; }
    while (++s.i < 0x1C);
    sprintf(s.path, (char *)&leaguedbfmt, (char *)str_Key);
    if (unknown_libname_1(s.path, 0, s.find)) FatalError((char *)str_ErrA1);
    if ((fh = open(s.path, 0x200)) < 0) FatalError((char *)str_ErrA2);
    s.i = 0;
    do {
        if (((int *)((char *)dword_DBC7C + team * 0x2E8))[s.i] < 0) {
            gmroster[s.i * 22] = 0;
            continue;
        }
        if (lseek(fh, 0, 0)) FatalError((char *)str_ErrA3);
        if (lseek(fh, ((int *)((char *)dword_DBC7C + team * 0x2E8))[s.i], 0) < 0) FatalError((char *)str_ErrA4);
        n = read(fh, s.rec, 0x34);
        if (n < 0 || n != 0x34) FatalError((char *)str_ErrA5);
        gmroster[s.i * 22] = s.rec[2];
        gmrosterjersey[s.i * 22] = s.rec[1];
        byte_ED0F7[s.i * 22] = s.rec[3];
        byte_ED0F8[s.i * 22] = '.';
        byte_ED0F9[s.i * 22] = ' ';
        for (k = 0; k < 16; k++) byte_ED0FA[k + s.i * 22] = s.rec[0x13 + k];
    } while (++s.i < 0x19);
    s.i = 0;
    do {
        if (((int *)((char *)dword_DBCE0 + team * 0x2E8))[s.i] < 0) {
            gmroster[(s.i + 0x19) * 22] = 0;
            continue;
        }
        if (lseek(fh, 0, 0)) FatalError((char *)str_ErrA6);
        if (lseek(fh, ((int *)((char *)dword_DBCE0 + team * 0x2E8))[s.i], 0) < 0) FatalError((char *)str_ErrA7);
        n = read(fh, s.rec, 0x34);
        if (n < 0 || n != 0x34) FatalError((char *)str_ErrA8);
        gmroster[(s.i + 0x19) * 22] = s.rec[2];
        gmrosterjersey[(s.i + 0x19) * 22] = s.rec[1];
        byte_ED0F7[(s.i + 0x19) * 22] = s.rec[3];
        byte_ED0F8[(s.i + 0x19) * 22] = '.';
        byte_ED0F9[(s.i + 0x19) * 22] = ' ';
        for (k = 0; k < 16; k++) byte_ED0FA[k + (s.i + 0x19) * 22] = s.rec[0x13 + k];
    } while (++s.i < 3);
    j___close(fh);
}
