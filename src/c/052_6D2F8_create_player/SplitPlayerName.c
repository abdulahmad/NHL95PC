/* Create player: name editing. */
#include "nhl95.h"

/* SplitPlayerName: split name into first and last (at most 15 letters each, letters by the character class table
 byte_C4B6C, bits 6-7): skip leading non-letters, copy the first word; if it was cut at 15 skip the rest of it
 skip to the next word and copy it as the last name. stop / first / last are one struct (their stack slots
 esp+0/+4/+8); the letter is read in place (name[i]) in the test and the copy. */
#define LETTER(c) ((*(int *)((char *)byte_C4B6C + (unsigned char)((c) + 1) - 3) >> 24) & 0xC0)

void SplitPlayerName(char *name, char *first, char *last)
{
    struct {
        int stop;
        char *first;
        char *last;
    } f;
    int len;
    int i;
    int n;

    f.first = first;
    f.last = last;
    len = strlen(name);
    i = 0;
    while (!LETTER(name[i]) && i < len) i++;
    for (f.stop = n = 0; i < len && n < 15 && !f.stop; i++) {
        if (LETTER(name[i])) {
            f.first[n] = name[i];
            n++;
        } else {
            f.stop = -1;
        }
    }
    f.first[n] = 0;
    if (n == 15 && LETTER(name[i]))
        while (LETTER(name[i]) && i < len) i++;
    while (!LETTER(name[i]) && i < len) i++;
    for (f.stop = n = 0; i < len && n < 15 && !f.stop; i++) {
        if (LETTER(name[i])) {
            f.last[n] = name[i];
            n++;
        } else {
            f.stop = -1;
        }
    }
    f.last[n] = 0;
}
