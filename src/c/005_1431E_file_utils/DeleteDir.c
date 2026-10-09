/* File utilities: delete a directory. */
#include "nhl95.h"

/* DeleteDir (14442) - delete every file in dir (dir\*.*), then the directory. */
typedef struct FindT {
    char reserved[21];
    char attrib;
    unsigned short wr_time;
    unsigned short wr_date;
    unsigned long size;
    char name[13];
} FindT;

void DeleteDir(char *dir)
{
    FindT ft;
    char path[32];
    int r;

    strcpy(path, dir);
    strcat(path, (char *)str_backslash2);
    strcat(path, (char *)str_star);
    strcat(path, (char *)&str_dot);
    strcat(path, (char *)str_star);
    if (!unknown_libname_1(path, 0, &ft)) {
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
    rmdir(dir);
}
