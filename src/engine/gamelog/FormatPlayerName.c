/* Scoring penalties: player name for the score text. */
#include "nhl95.h"

/* FormatPlayerName (61D48; PC version of 93G hockey93 FormatPlayerName, with its own arguments): write "<prefix>#<num> <first> <last><suffix>" into out in the scor2font
 font, shortening it while it is wider than 124 pixels: first initial only, then no first name, then the last
 name cut letter by letter to fit beside "<prefix>#<num> <suffix>". The font goes back to s1font. No result.
 Under 10.0 GA the locals declared room, len, n give the EXE's registers (out edi, first ebp, n esi). */
void FormatPlayerName(char *out, char *prefix, short num, char *first, char *last, char *suffix)
{
    char buf[20];
    int room;
    int len;
    int n;

    sub_8EA18(scor2font);
    sprintf(out, (char *)str_FmtNumFirstLast, prefix, n = num, first, last, suffix);
    if (fputchar(out) > 124) {
        sprintf(out, (char *)str_FmtNumInitialLast, prefix, n, (signed char)*first, last, suffix);
        if (fputchar(out) > 124) {
            sprintf(out, (char *)str_FmtNumNameSuffix, prefix, n, last, suffix);
            if (fputchar(out) > 124) {
                sprintf(out, (char *)str_FmtNumName, prefix, n, suffix);
                room = 124 - fputchar(out);
                strcpy(buf, last);
                len = strlen(buf);
                while (fputchar(buf) > room) buf[--len] = 0;
                sprintf(out, (char *)str_FmtNumNameSuffix, prefix, num, buf, suffix);
            }
        }
    }
    sub_8EA18(s1font);
}
