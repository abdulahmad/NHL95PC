/* Schedule: swap helper. */
#include "nhl95.h"

/* SwapInt (42F19) - swap arr[a] and arr[b] with the xor trick. */
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
