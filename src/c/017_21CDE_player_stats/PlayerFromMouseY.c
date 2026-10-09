/* Player stats: mouse picking. */
#include "nhl95.h"

/* PlayerFromMouseY (24453) - stats list row under mouse y (13-pixel rows): skaters from y 40h, goalies from y 1A5h
   (after the skaters in *idx). Returns 1 on a row, else 0 (*idx 0). */
int PlayerFromMouseY(int x, int y, int *idx)
{
    *idx = 0;
    if (y >= 0x40) {
        if (y < statsnumskaters * 13 + 0x40) {
            *idx = (y - 0x40) / 13;
            return 1;
        }
        if (y >= 0x1A5 && y < statsnumgoalies * 13 + 0x1A5) {
            *idx = statsnumskaters + (y - 0x1A5) / 13;
            return 1;
        }
    }
    return 0;
}
