/* File utilities: path building. */
#include "nhl95.h"

/* MakePath (1431E) - out = dir + "\\" (when dir is given and not empty) + name + ext (each part optional). */
void MakePath(char *out, char *dir, char *name, char *ext)
{
    if (dir && *dir) {
        strcpy(out, dir);
        strcat(out, (char *)str_backslash2);
    } else {
        *out = 0;
    }
    if (name) strcat(out, name);
    if (ext) strcat(out, ext);
}
