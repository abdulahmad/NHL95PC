/* File dialogs: print a string. */
#include "nhl95.h"

/* PrintTextCopy: copy s into a local buffer (64 bytes) and print the copy at x, y
 (PrintString). */
void PrintTextCopy(char *s, int x, int y)
{
    char buf[64];
    int i;

    for (i = 0; s[i] != 0; i++) buf[i] = s[i];
    buf[i] = 0;
    PrintString(buf, x, y);
}
