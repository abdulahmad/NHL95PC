/* Speech: sample request list lookup. */
#include "nhl95.h"

/* IsSampleRequested (83F61) - PC only: 1 when name is in the sample request list (samplereq: 13-byte names,
   count at +108h; compared without case), else 0. */
int IsSampleRequested(char *name)
{
    int i;

    for (i = 0; i < *(int *)(samplereq + 0x108); i++) {
        if (StrEqNoCase(name, (char *)samplereq + i * 13)) return 1;
    }
    return 0;
}
