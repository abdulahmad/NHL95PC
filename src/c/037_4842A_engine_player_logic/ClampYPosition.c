/* Engine player logic: target clamp. */
#include "nhl95.h"

/* ClampYPosition (4B6F4) - clamp the target y (regd1) of player p while he is within E8h of centre ice in y:
   the puck carrier also gets regd0 = 0; regd1 is limited to +-E3h. Then regd1 -= regd3 (always). */
void ClampYPosition(Player *p)
{
    int y;

    if (HIWORD(p->Ypos) < 0) y = -HIWORD(p->Ypos);
    else y = HIWORD(p->Ypos);
    if (y < 0xE8) {
        if (*puckc == p->SCnum) regd0.w = 0;
        if (regd1.w > 0xE3) regd1.w = 0xE3;
        if (regd1.w < -0xE3) regd1.w = -0xE3;
    }
    regd1.w -= regd3.w;
}
