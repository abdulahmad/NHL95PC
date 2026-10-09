/* Front-end labels: string helpers. */
#include "nhl95.h"

/* StrLenToDot (1D5D5) - length of s up to (not including) the first '.' or the end: the base of a file name. */
int StrLenToDot(char *s)
{
    int n;

    for (n = 0; *s && *s != '.'; s++) n++;
    return n;
}
