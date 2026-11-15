/* Engine player logic: enter line change mode. */
#include "nhl95.h"

/* SetLCmode: put player p's team into line change mode: only with line
 changes on (gameopts bit 2) and when the team is not in it already (tmflags bit 1, then set). Clears sflags
 bits 2-3 (sflags), keeps the joystick on p (pflags2 pf2lcm) and asks for the line change
 box. */
void SetLCmode(Player *p)
{
    Team *t;

    if (gameopts.linechanges) {
        t = p->tmptr;
        if (!(t->tmflags & tmflcm)) {
            t->tmflags |= tmflcm;
            sflags &= ~0x0C;
            p->pflags2 |= pf2lcm;
            RequestLineChange(p);
        }
    }
}
