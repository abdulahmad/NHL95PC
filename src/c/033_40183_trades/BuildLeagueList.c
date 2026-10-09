/* Trades: league list. */
#include "nhl95.h"

typedef struct FindT {
    char reserved[21];
    char attrib;
    unsigned short wr_time;
    unsigned short wr_date;
    unsigned long size;
    char name[13];
} FindT;

/* BuildLeagueList (411C8) - PC only: list the league directories (*.LP, _dos_findfirst / _dos_findnext with the
   directory attribute 10h): count them, allocate the pointer list *list (LLST, 4 bytes each) and the name buffer
   *names (LLSN, 9 bytes each), then go over them again keeping the ones GetLeagueId accepts by flags (bit 0: valid
   leagues, bit 1: the others), each name up to its dot. Returns the number kept (lists cleared when none). */
int BuildLeagueList(char ***list, char **names, int flags)
{
    FindT ft;
    char pat[16];
    int id;
    int len;
    int n;
    int cnt;
    int i;
    int r;
    int done;

    strcpy(pat, (char *)str_star);
    strcat(pat, (char *)str_extLP);
    n = 0;
    if (!unknown_libname_1(pat, 0x10, &ft)) {
        n = 1;
        do {
            done = unknown_libname_2(&ft);
            if (done == 0) n++;
        } while (!done);
    }
    if (n) {
        *list = (char **)sub_8CCA8((char *)str_LLST, n * 4, 0x20);
        memset(*list, 0, n * 4);
        *names = (char *)sub_8CCA8((char *)str_LLSN, n * 9, 0x20);
        memset(*names, 0, n * 9);
        cnt = n;
        for (i = 0; i < cnt; i++) {
            if (i == 0) unknown_libname_1(pat, 0x10, &ft);
            else unknown_libname_2(&ft);
            r = GetLeagueId(ft.name, &id);
            if ((r < 0 && flags & 2) || (r >= 0 && flags & 1)) {
                len = _fstrcspn(ft.name, (char *)&str_dot);
                strncpy(*names + i * 9, ft.name, len);
                (*names + i * 9)[len] = 0;
                (*list)[i] = *names + i * 9;
            } else n--;
        }
    }
    if (!n) {
        *list = 0;
        *names = 0;
    }
    return n;
}
