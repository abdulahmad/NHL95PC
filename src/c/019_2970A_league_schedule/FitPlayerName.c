/* League schedule: names. */
#include "nhl95.h"

/* FitPlayerName (29C75) - dst = "first last" fitted to maxw pixels: "F. last" when too wide, then cut from the end;
   just last when there is no first name. */
void FitPlayerName(char *dst, char *first, char *last, int maxw)
{
    if (first) {
        strcpy(dst, first);
        strcat(dst, (char *)&str_space);
        strcat(dst, last);
        if (fputchar(dst) > maxw) {
            dst[0] = first[0];
            dst[1] = '.';
            dst[2] = ' ';
            dst[3] = 0;
            strcat(dst, last);
        }
    } else {
        strcpy(dst, last);
    }
    while (fputchar(dst) > maxw) dst[strlen(dst) - 1] = 0;
}
