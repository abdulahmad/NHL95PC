/* Key and team database: load one team's skaters and goalies. */
#define LoadTeamRoster LoadTeamRoster_decl
#include "nhl95.h"
#undef LoadTeamRoster

/* LoadTeamRoster: read one team's 25 skaters and 3 goalies into the roster. mode 0 and 2 rate each
 player from the overall bytes; any other mode copies the lineup slot. The exit jumps to OpenPlayerDBs_x. */
void LoadTeamRoster(int mode, int f1, int f2, int f3, int f4, int n4, int team)
{
    unsigned char buf[0xE8];
    int i;
    int line;
    int gline;
    int base;
    unsigned char *p;

    for (i = 0; i < 25; i++) {
        if (*(int *)((char *)dword_DBC7C + team * 744 + i * 4) >= 0) {
            ReadPlayerRecs(f1, f2, f3, f4, *(int *)((char *)dword_DBC7C + team * 744 + i * 4), buf + 0x38, buf + 0xC4, 0x14,
                buf + 0x6C, 0x2F, buf + 0x9C, n4);
            hmrosterjersey[team * 1092 + i * 39] = buf[0x39];
            byte_DB3AE[team * 1092 + i * 39] = buf[0x3A];
            p = hmroster + team * 1092 + i * 39;
            strcpy((char *)p + 7, (char *)buf + 0x3B);
            strcpy((char *)p + 0x17, (char *)buf + 0x4B);
            if (mode == 0 || mode == 2) {
                if (byte_DC268 < buf[0x92])
                    hmroster[team * 1092 + i * 39] = 1;
                else if (byte_DC268 > buf[0x92])
                    hmroster[team * 1092 + i * 39] = 3;
                else if (byte_DC267 < buf[0x93])
                    hmroster[team * 1092 + i * 39] = 1;
                else
                    hmroster[team * 1092 + i * 39] = 3;
            } else {
                line = ((short *)((char *)hmtmpdst_m2 + (team << 8)))[i + 1];
                if (line > 0)
                    hmroster[team * 1092 + i * 39] = 5;
                else
                    hmroster[team * 1092 + i * 39] = byte_C66B4[(-line) * 2];
            }
            *(struct { unsigned char b[20]; } *)(unk_DACA0 + team * 500 + i * 20) =
                *(struct { unsigned char b[20]; } *)(buf + 0xC4);
            if ((mode & 6) == 0) {
                base = team * 100 + i * 4;
                if (((unsigned char *)&gameopts)[1] & 2) {
                    dword_DEB74[base] = *(unsigned short *)(buf + 0xC0);
                    dword_DEB78[base] = *(unsigned short *)(buf + 0xC0) + *(unsigned short *)(buf + 0xC2);
                    dword_DEB7C[base] = *(unsigned short *)(buf + 0x6E);
                    dword_DEB80[base] = *(unsigned short *)(buf + 0x6E) + *(unsigned short *)(buf + 0x70);
                } else {
                    dword_DEB78[base] = dword_DEB74[base] = 0;
                    dword_DEB7C[base] = *(unsigned short *)(buf + 0x80);
                    dword_DEB80[base] = *(unsigned short *)(buf + 0x80) + *(unsigned short *)(buf + 0x82);
                }
            }
        } else {
            hmroster[team * 1092 + i * 39] = 0;
        }
    }
    for (i = 0; i < 3; i++) {
        if (*(int *)((char *)dword_DBCE0 + team * 744 + i * 4) >= 0) {
            ReadPlayerRecs(f1, f2, f3, 0, *(int *)((char *)dword_DBCE0 + team * 744 + i * 4), buf + 0x38, buf + 0xD8, 0x10,
                buf, 0x36, 0, 0);
            hmrosterjersey[team * 1092 + (i + 25) * 39] = buf[0x39];
            byte_DB3AE[team * 1092 + (i + 25) * 39] = buf[0x3A];
            p = hmroster + team * 1092 + (i + 25) * 39;
            strcpy((char *)p + 7, (char *)buf + 0x3B);
            strcpy((char *)p + 0x17, (char *)buf + 0x4B);
            if (mode == 0 || mode == 2) {
                if (byte_DC268 < buf[0x2E])
                    hmroster[(i + 25) * 39 + team * 1092] = 1;
                else if (byte_DC268 > buf[0x2E])
                    hmroster[(i + 25) * 39 + team * 1092] = 3;
                else if (byte_DC267 < buf[0x2F])
                    hmroster[(i + 25) * 39 + team * 1092] = 1;
                else
                    hmroster[(i + 25) * 39 + team * 1092] = 3;
            } else {
                gline = ((short *)((char *)dword_DF6C2 + (team << 8)))[i + 1];
                if (gline > 0)
                    hmroster[team * 1092 + (i + 25) * 39] = 5;
                else
                    hmroster[team * 1092 + (i + 25) * 39] = byte_C66B4[(-gline) * 2];
            }
            *(struct { unsigned char b[16]; } *)(unk_DAC40 + team * 48 + i * 16) =
                *(struct { unsigned char b[16]; } *)(buf + 0xD8);
        } else {
            hmroster[team * 1092 + (i + 25) * 39] = 0;
        }
    }
}
