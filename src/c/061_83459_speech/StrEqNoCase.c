/* Speech: string compare. */
#include "nhl95.h"

/* StrEqNoCase (83E32) - 1 when a and b are equal ignoring letter case (bit 20h), else 0. */
int StrEqNoCase(char *a, char *b)
{
    int ca;
    int cb;

    while (*a || *b) {
        ca = *a & 0xDF;
        cb = *b & 0xDF;
        a++;
        b++;
        if (ca != cb) return 0;
    }
    return 1;
}
