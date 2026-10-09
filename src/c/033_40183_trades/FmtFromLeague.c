/* Trades: labels. */
#include "nhl95.h"

/* FmtFromLeague (41171) - dst = name + " from league " + file without its extension. */
void FmtFromLeague(char *dst, char *name, char *file)
{
    char buf[16];

    strcpy(buf, file);
    buf[_fstrcspn(buf, (char *)&str_dot)] = 0;
    strcpy(dst, name);
    strcat(dst, (char *)str_FromLeague);
    strcat(dst, buf);
}
