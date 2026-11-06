/* File dialogs: qsort compare for file name lists. */
#include "nhl95.h"

/* CmpFileNames: qsort callback; a and b point at name pointers, compared with strcmp. */
int CmpFileNames(const void *a, const void *b)
{
    return strcmp(*(char **)a, *(char **)b);
}
