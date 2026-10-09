/* Engine core: stick vs hot spot. */
#include "nhl95.h"

/* GetHotOrStick (5A534) - regd0 / regd1 = stick position (GetHotStick) minus hot spot (GetHot) of player p. */
void GetHotOrStick(Player *p)
{
    short x;
    short y;

    GetHotStick(p);
    x = regd0.w;
    y = regd1.w;
    GetHot(p);
    regd0.w = x - regd0.w;
    regd1.w = y - regd1.w;
}
