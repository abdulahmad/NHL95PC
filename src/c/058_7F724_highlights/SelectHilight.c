/* Highlights: choosing a saved highlight. */
#define SelectHilight SelectHilight_decl
#define ListDialog ListDialog_decl
#include "nhl95.h"
#undef SelectHilight
#undef ListDialog

int ListDialog(char **items, int n, char *title, int a, int b, unsigned char *marks);

/* SelectHilight (7FCF8, PC only): pick a saved highlight of the league in dir. List the teams that have a
   highlight file (*.HI2, TeamFromHiName, sorted, by city) and, once one is chosen, the highlights in that team's
   file (9652h bytes each; FormatHilightDesc of each 4Ch-byte header into a 51h-byte string table, HLT / HLTL).
   With multi set the second list can mark several (a cleared byte per highlight, HLTS, returned in *marks) and
   *idx becomes the count. With no highlight files say so (msg_NoHilights). name: gets the team's file name;
   idx: gets the chosen highlight; dir: the league directory; multi, marks: as above. Result: 0, an I/O error,
   or -1 when nothing was chosen.
   DRAFT (10.0 GA): 893 vs 893. The counter and the two table pointers are plain locals declared i, tbl, strs (i's
   address is taken for sub_B2DCA, so the city loop stores i + 1 from a register as the EXE does), and both
   failures set err = -1 before the one return err. Left: the two FreeMemBlock pushes load into esi / ebp (EXE
   eax / edx). */
int SelectHilight(char *name, int *idx, unsigned char *dir, int multi, unsigned char **marks)
{
    struct {
        char *names[0x1A];
        int teams[0x1A];
        char path[0x54];
        unsigned char hdr[0x4C];
        char ft[0x2C];
        unsigned char tmarks[0x1C];
        int fh;
        int x;
        int y;
    } s;
    int i;
    char **tbl;
    char *strs;
    int n;
    int err;
    int r;
    int size;

    s.fh = -1;
    n = 0;
    MakePath(s.path, (char *)dir, (char *)str_star, (char *)str_HI2);
    if (!unknown_libname_1(s.path, 0, s.ft)) {
        s.teams[0] = TeamFromHiName(s.ft + 0x1E);
        s.names[0] = (char *)teamcitynames[s.teams[0]];
        n = 1;
        do {
            err = unknown_libname_2(s.ft);
            if (!err) {
                s.teams[n] = TeamFromHiName(s.ft + 0x1E);
                n++;
            }
        } while (!err);
    }
    if (n) {
        qsort(s.teams, n, 4, CmpInt);
        for (i = 0; i < n; i++) s.names[i] = (char *)teamcitynames[s.teams[i]];
        r = ListDialog(s.names, n, (char *)str_SelectATeam, 2, 0, s.tmarks);
        if (r >= 0) {
            MakePath(name, 0, (char *)teamabbrevs[s.teams[r]], (char *)str_HI2);
            MakePath(s.path, (char *)dir, name, 0);
            size = sub_92DE0(s.path);
            err = FileOpenRead(s.path, &s.fh);
            if (!err) {
                n = size / 0x9652;
                tbl = (char **)sub_8CCA8((char *)str_HLTL, n * 4, 0x20);
                strs = (char *)sub_8CCA8((char *)str_HLT, n * 0x51, 0x20);
                if (multi) {
                    *marks = (unsigned char *)sub_8CCA8((char *)str_HLTS, n, 0x20);
                    for (i = 0; i < n && !err; i++) (*marks)[i] = 0;
                }
                for (i = 0; i < n && !err; i++) {
                    err = FileReadAt(s.fh, s.hdr, i * 0x9652, 0x4C);
                    tbl[i] = strs + i * 0x51;
                    FormatHilightDesc(s.path, s.hdr);
                    strcpy(strs + i * 0x51, s.path);
                }
                if (!err) {
                    if ((*idx = ListDialog(tbl, n, (char *)str_SelectAHilight, 2, multi, *marks)) < 0) err = -1;
                    if (multi) *idx = n;
                }
                FreeMemBlock((int)strs);
                FreeMemBlock((int)tbl);
            }
            FileClose(&s.fh);
        } else err = -1;
    } else {
        sub_B2DCA(&i, &s.y, &s.x);
        MessageBox(-1, -1, (char *)msg_NoHilights, 1, 0, 0, (int)&s.y, (int)&s.x, -1);
        err = -1;
    }
    return err;
}
