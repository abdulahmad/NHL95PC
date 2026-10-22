/* Announcer: penalty length clip names. */
#include "nhl95.h"

/* PenaltyLenClip: name of the announcer clip for a penalty of length len: 5 minutes, 2 minutes (default), or for
 -1 the misconduct clip (str_GamemiscS format with str_Cor). */
void PenaltyLenClip(int len, char *out)
{
    switch (len) {
    case 5:
        strcpy(out, (char *)str_5minCor);
        break;
    case -1:
        sprintf(out, (char *)str_GamemiscS, str_Cor);
        break;
    case 2:
    default:
        strcpy(out, (char *)str_2minCor);
        break;
    }
}
