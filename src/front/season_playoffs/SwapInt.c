/* Schedule: swap helper. */
#include "nhl95.h"

/* SwapInt: swap arr[a] and arr[b] with the xor trick. */
void SwapInt(int a, int b, int *arr)
{
    int *pa;
    int *pb;

    pa = &arr[a];
    pb = &arr[b];
    *pa ^= *pb;
    *pb ^= *pa;
    *pa ^= *pb;
}
