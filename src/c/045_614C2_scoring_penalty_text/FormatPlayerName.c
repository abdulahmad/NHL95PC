/* Scoring / penalties: player name for the score text. */
#include "nhl95.h"

/* FormatPlayerName (61D48) - PC only: write "<prefix>#<num> <first> <last><suffix>" into out in the scor2font
   font, shortening it while it is wider than 124 pixels: first initial only, then no first name, then the last
   name cut letter by letter to fit beside "<prefix>#<num> <suffix>". The font goes back to s1font. */
void FormatPlayerName(char *out, char *prefix, short num, char *first, char *last, char *suffix)
{
    char buf[20];
    int n;
    int room;
    int len;

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
