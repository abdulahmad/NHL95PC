/* Database save: header. */
#include "nhl95.h"

/* DrawDatabaseName (6D256) - print "DATABASE: <current database name>" centred at y 18h (the name is upper-cased in
   place). */
typedef struct Str12 { char c[12]; } Str12;

void DrawDatabaseName(void)
{
    char buf[0x34];

    *(Str12 *)buf = *(Str12 *)str_DATABASE;
    strupr((char *)curdbname);
    strcat(buf, (char *)curdbname);
    PrintCenteredText(0x18, buf);
}
