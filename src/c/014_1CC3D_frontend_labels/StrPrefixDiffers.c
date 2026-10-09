/* Front-end labels: string compare. */
#include "nhl95.h"

/* StrPrefixDiffers (1D6BE) - 1 when a and b differ before either string ends, else 0 (one is a prefix of the other). */
int StrPrefixDiffers(char *a, char *b)
{
    while (*a && *b) {
        if (*a != *b) return 1;
        a++;
        b++;
    }
    return 0;
}
