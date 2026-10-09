/* Key / team database: game summary path. */
#include "nhl95.h"

/* MakeGSummaryPath (1C807) - gsummarypath = league directory + "\\" (when a league is loaded) + the game summary file
   name. */
void MakeGSummaryPath(void)
{
    (&gsummarypath)[0] = 0;
    if (curleague) {
        strcpy((char *)&gsummarypath, (char *)&curleague);
        strcat((char *)&gsummarypath, (char *)str_backslash3);
    }
    strcat((char *)&gsummarypath, (char *)str_GsummaryDb2);
}
