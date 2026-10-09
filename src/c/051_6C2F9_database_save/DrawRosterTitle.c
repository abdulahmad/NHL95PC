/* Database save: roster panels. */
#include "nhl95.h"

/* DrawRosterTitle (6CEFB) - print the title of roster panel side at x / y: "Free Agents", or the team name (team record
   +1Ah) cut to 91h pixels. */
void DrawRosterTitle(int x, int y, int side)
{
    char buf[0x54];

    if (rosterisfa[side] != 1) {
        sprintf(buf, (char *)str_S5, (char *)rosterteamptr[side] + 0x1A);
        while (fputchar(buf) > 0x91) buf[strlen(buf) - 1] = 0;
        PrintShadowText(x, y, buf);
    } else {
        PrintShadowText(x, y, (char *)str_FreeAgents);
    }
}
