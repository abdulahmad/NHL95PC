/* Highlights: team from a highlight file name. */
#include "nhl95.h"

/* TeamFromHiName (7FC5C) - cut s at the first separator (unk_C3470) and return the team whose abbreviation matches
   (ignoring case; the last match of the 26), or -1. */
int TeamFromHiName(char *s)
{
    int r;
    int i;

    r = -1;
    s[strcspn(s, (char *)unk_C3470)] = 0;
    for (i = 0; i < 26; i++) {
        if (!stricmp(s, (char *)teamabbrevs[i])) r = i;
    }
    return r;
}
