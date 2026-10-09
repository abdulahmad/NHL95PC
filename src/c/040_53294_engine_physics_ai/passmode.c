/* Engine physics / AI: pass button (93G passmode). */
#include "nhl95.h"

/* passmode (5514E) - pass button handling for player p: unless regd2 bit 4 (pass now), take the first press only (regd0
   bit 3 marks it, passdir = regd0 & 7); a joystick player whose pad device (pad1dev, by controller) is 1 waits.
   Otherwise dopass. */
void passmode(Player *p)
{
    if (!(regd2.w & 0x10)) {
        if (regd0.w & 8) return;
        passdir = regd0.w & 7;
        regd0.w |= 8;
        if (p->pflags & pfjoy) {
            if (pad1dev[p->SCnum != c1playernum[0]] == 1) return;
        }
    }
    dopass(p);
}
