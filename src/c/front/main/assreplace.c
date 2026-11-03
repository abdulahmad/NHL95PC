/* Assignments: replace insert (assinsert). */
#include "nhl95.h"

/* assreplace: replace player p's current assignment (asslist[assnum]) with a and set
 pfna so it starts on the next update. */
void assreplace(Player *p, int a)
{
    p->asslist[p->assnum] = a;
    p->pflags |= pfna;
}
