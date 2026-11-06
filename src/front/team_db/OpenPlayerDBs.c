/* Key and team database: open one side's player files. */
#include "nhl95.h"

/* OpenPlayerDBs: build key, att, season, and career paths with sprintf(path, fmt, name) and open
 each (FatalError "9","A", "B","C", "J","K", "L","M" when the name is missing or the open fails).
 key, att, season, and career receive the handles. When mode bits 1 or 2 are set, career is left
 unopened and *out is 0. Otherwise *out is 28h. */
void OpenPlayerDBs(int mode, int *key, int *att, int *season, int *career, char *fmt, int *out)
{
    struct {
        char find[0x2C];
        char path[0x20];
    } s;

    sprintf(s.path, fmt, (char *)str_key);
    if (unknown_libname_1(s.path, 0, s.find)) FatalError((char *)str_fe9);
    if (FileOpenRead(s.path, key)) FatalError((char *)str_feA);
    sprintf(s.path, fmt, (char *)str_att);
    if (unknown_libname_1(s.path, 0, s.find)) FatalError((char *)str_feB);
    if (FileOpenRead(s.path, att)) FatalError((char *)str_feC);
    sprintf(s.path, fmt, (char *)str_season);
    if (unknown_libname_1(s.path, 0, s.find)) FatalError((char *)str_feJ);
    if (FileOpenRead(s.path, season)) FatalError((char *)str_feK);
    if (mode & 6) {
        *out = 0;
    } else {
        sprintf(s.path, fmt, (char *)str_career);
        if (unknown_libname_1(s.path, 0, s.find)) FatalError((char *)str_feL);
        if (FileOpenRead(s.path, career)) FatalError((char *)str_feM);
        *out = 0x28;
    }
}
