/* File dialogs: print a string. */
#include "nhl95.h"

/* PrintTextCopy (2C135) - PC only: copy s into a local buffer (64 bytes) and print the copy at x, y
   (sub_91964). */
void PrintTextCopy(char *s, int x, int y)
{
    char buf[64];
    int i;

    for (i = 0; s[i] != 0; i++) buf[i] = s[i];
    buf[i] = 0;
    sub_91964(buf, x, y);
}
