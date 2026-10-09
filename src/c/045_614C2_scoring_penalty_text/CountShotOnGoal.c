/* Scoring / penalty text: shots on goal. */
#include "nhl95.h"

/* CountShotOnGoal (64338) - after a shot: ShotLaneOpen decides shotontarget; a shot on target raises the crowd (+100)
   and, outside penalty shots, counts a shot for the carrier's team (word at +1Ch: visitors when puckc > 5).
   Returns 1 when counted. */
int CountShotOnGoal(void)
{
    ShotLaneOpen();
    shotongoal = shotontarget;
    if (shotongoal) {
        crowdlevel += 100;
        if (!penshotmode) {
            short *t;
            int vis;

            vis = *puckc > 5;
            t = vis ? (short *)&awtmstruct : (short *)&hmtmstruct;
            t[0x1C / 2]++;
            return 1;
        }
    }
    return 0;
}
