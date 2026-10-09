/* Engine input: hold-check animation (94G input94 Acheck). */
#include "nhl95.h"

/* Acheck (4FFAE) - start the hold-check animation of player p against player q (94G input94 Acheck): lock the
   animation (pfalock); the normal hold check, or the stick-in-the-air hold check when p has an impact and q is
   not behind p relative to the goal p shoots at (pfgoal; dy = p's Ypos - q's Ypos, negated when shooting up). */
void Acheck(Player *p, Player *q)
{
    short dy;

    p->pflags |= pfalock;                       /* lock animation */
    if (p->impact == 0) {
        SetSPA(p, SPAholdchk);                  /* normal hold check */
        return;
    }
    dy = HIWORD(p->Ypos) - HIWORD(q->Ypos);
    if (p->pflags & pfgoal)                     /* goal to shoot at: top */
        dy = -dy;
    if (dy < 0) {
        SetSPA(p, SPAholdchk);
        return;
    }
    SetSPA(p, SPAholdchkair);                   /* hold check, stick in the air */
}
