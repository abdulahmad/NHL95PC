/* Create player: name editing. */
#include "nhl95.h"

/* SplitPlayerName (6F159) - split name into first and last (at most 15 letters each, letters by the character class table
   byte_C4B6C, bits 6-7): skip leading non-letters, copy the first word; if it was cut at 15 skip the rest of it;
   skip to the next word and copy it as the last name. */
#define LETTER(c) ((*(int *)((char *)byte_C4B6C + (unsigned char)((c) + 1) - 3) >> 24) & 0xC0)

void SplitPlayerName(char *name, char *first, char *last)
{
    int stop;
    int len;
    int i;
    int n;
    char *p;

    len = strlen(name);
    i = 0;
    while (!LETTER(name[i]) && i < len) i++;
    for (stop = n = 0; i < len && n < 15 && !stop; i++) {
        p = &name[i];
        if (LETTER(*p)) {
            first[n] = *p;
            n++;
        } else {
            stop = -1;
        }
    }
    first[n] = 0;
    if (n == 15 && LETTER(name[i]))
        while (LETTER(name[i]) && i < len) i++;
    while (!LETTER(name[i]) && i < len) i++;
    for (stop = n = 0; i < len && n < 15 && !stop; i++) {
        p = &name[i];
        if (LETTER(*p)) {
            last[n] = *p;
            n++;
        } else {
            stop = -1;
        }
    }
    last[n] = 0;
}
