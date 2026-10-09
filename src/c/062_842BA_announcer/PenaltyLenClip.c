/* Announcer: penalty length clip names. */
#include "nhl95.h"

/* PenaltyLenClip (842BA) - name of the announcer clip for a penalty of length len: 5 minutes, 2 minutes (default), or for
   -1 the misconduct clip (str_GamemiscS format with str_Cor). */
void PenaltyLenClip(int len, char *out)
{
    char *s;

    switch (len) {
    case 5:
        s = (char *)str_5minCor;
        break;
    case -1:
        sprintf(out, (char *)str_GamemiscS, str_Cor);
        return;
    case 2:
    default:
        s = (char *)str_2minCor;
        break;
    }
    strcpy(out, s);
}
