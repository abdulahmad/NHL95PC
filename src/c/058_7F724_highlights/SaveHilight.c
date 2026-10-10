/* Highlights: save a highlight. */
#include "nhl95.h"

typedef struct FindT {
    char reserved[21];
    char attrib;
    unsigned short wr_time;
    unsigned short wr_date;
    unsigned long size;
    char name[13];
} FindT;

typedef struct DiskFree {
    unsigned short total_clusters;
    unsigned short avail_clusters;
    unsigned short sectors_per_cluster;
    unsigned short bytes_per_sector;
} DiskFree;

/* SaveHilight (7FA10) - PC only: append the current replay as a highlight to the league's file for team (curleague
   \ team name .HI, created when missing). Needs 9652h bytes free on the current drive (else sets dword_ED6F8 and
   returns 1). The 9652h-byte record hilightrec: the two teams' ids (byte_DC268 / byte_DC267, HomeTeam, VisTeam),
   the 28 jerseys of each roster, period, clock (min / sec / hundredths), sflags, the replay length (recbpr -
   replaystart) and the replay. File errors are fatal. Returns 0. */
int SaveHilight(int team)
{
    FindT ft;
    char name[32];
    DiskFree df;
    int fh;
    int i;                      /* clusters one highlight needs, then the roster slot */

    if (_dos_getdiskfree(0, &df)) FatalError((char *)str_K1);
    i = (int)(0x9652u / df.bytes_per_sector) / df.sectors_per_cluster;
    if (i > df.avail_clusters) {
        dword_ED6F8 = 1;
        return 1;
    }
    hilightrec[0] = byte_DC268;
    hilightrec[1] = byte_DC267;
    hilightrec[2] = HomeTeam;
    hilightrec[0x1F] = VisTeam;
    *(int *)(hilightrec + 0x3C) = curperiod;
    *(int *)(hilightrec + 0x40) = hudclockmin;
    *(int *)(hilightrec + 0x44) = hudclocksec;
    *(int *)(hilightrec + 0x48) = hudclockhund;
    *(short *)(hilightrec + 0x4C) = *(short *)&sflags;
    *(int *)(hilightrec + 0x4E) = recbpr - replaystart;
    for (i = 0; i < 0x1C; i++) {
        hilightrec[3 + i] = hmrosterjersey[i * 0x27];
        hilightrec[0x20 + i] = byte_DB7F1[i * 0x27];
    }
    strcpy(name, (char *)&curleague);
    strcat(name, (char *)unk_C3447);
    strcat(name, (char *)hmteamrec + team * 0x2E8);
    strcat(name, (char *)str_HI);
    if (unknown_libname_1(name, 0, &ft)) {
        if (FileCreate(name, &fh)) FatalError((char *)str_F12);
    } else if (FileOpenWrite(name, &fh)) {
        FatalError((char *)str_CantOpenFile, name);
    }
    lseek(fh, 0, 2);
    if (FileWriteAt(fh, hilightrec, -1, 0x9652)) FatalError((char *)str_F3);
    if (FileClose(&fh)) FatalError((char *)str_F4);
    return 0;
}
