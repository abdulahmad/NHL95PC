/* StopNA (5F82A) - 93G logic93_5 StopNA (stopna): slow player p by one step on each axis, with no animation
   change. The step is 200 + legstr (the goalie: 200 + 3 * legstr; 93G $96 = 150); a velocity that would cross
   zero is clamped to 0.
   NON-MATCHING: the original ends with jmp EvadePlayers_popedi (it shares the pop/ret epilogue of EvadePlayers,
   which wcc386 only does inside one source file), so this has to move into EvadePlayers' file. */
#include "nhl95.h"

void StopNA(Player *p)
{
    int str = p->legstr;
    int step = str + 200;               /* step 200+legstr (93G 150) */
    short xv, xneg, xpos, yv, yneg, ypos;

    if (p->position == 0) {             /* goalie: +2*legstr */
        str += str;
        step += str;
    }
    xv = p->Xvel;
    if (xv < 0) {
        xneg = xv + step;
        p->Xvel = xneg;
        if (xneg > 0) p->Xvel = 0;
    } else {
        xpos = xv - step;
        p->Xvel = xpos;
        if (xpos < 0) p->Xvel = 0;
    }
    yv = p->Yvel;
    if (yv < 0) {
        yneg = yv + step;
        p->Yvel = yneg;
        if (yneg > 0) p->Yvel = 0;
    } else {
        ypos = yv - step;
        p->Yvel = ypos;
        if (ypos < 0) p->Yvel = 0;
    }
}
