/* Speech: string compare. */
#include "nhl95.h"

/* StrEqNoCase: 1 when a and b are equal ignoring letter case (bit 20h), else 0. */
int StrEqNoCase(char *a, char *b)
{
    int ca;
    int cb;

    while (*a || *b) {
        ca = (signed char)*a & 0xDF;
        cb = (signed char)*b & 0xDF;
        a++;
        b++;
        if (ca != cb) return 0;
    }
    return 1;
}
