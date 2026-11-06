/* Front end: menu callbacks that always accept. */
#include "nhl95.h"

/* MenuCallbackTrue: menu callback (seven arguments, three on the stack) that does nothing and returns 1. */
int MenuCallbackTrue(int a, int b, int c, int d, int e, int f, int g)
{
    return 1;
}

/* MenuCallbackTrue2: the same; Watcom reduced it to a jump into MenuCallbackTrue after its __CHK push. */
int MenuCallbackTrue2(int a, int b, int c, int d, int e, int f, int g)
{
    return 1;
}
