/* File utilities: delete files. */
#include "nhl95.h"

/* DeleteFiles (14368) - delete every file dir\name.ext matches (_dos_findfirst / _dos_findnext). Returns the find result
   that ended the search (non-zero). */
typedef struct FindT {
    char reserved[21];
    char attrib;
    unsigned short wr_time;
    unsigned short wr_date;
    unsigned long size;
    char name[13];
} FindT;

int DeleteFiles(char *dir, char *name, char *ext)
{
    FindT ft;
    char path[32];
    int r;

    strcpy(path, dir);
    strcat(path, (char *)str_backslash2);
    strcat(path, name);
    strcat(path, (char *)&str_dot);
    strcat(path, ext);
    r = unknown_libname_1(path, 0, &ft);
    if (!r) {
        strcpy(path, dir);
        strcat(path, (char *)str_backslash2);
        strcat(path, ft.name);
        j_unlink(path);
        do {
            r = unknown_libname_2(&ft);
            if (!r) {
                strcpy(path, dir);
                strcat(path, (char *)str_backslash2);
                strcat(path, ft.name);
                j_unlink(path);
            }
        } while (!r);
    }
    return r;
}
