/* Assignments: insert (93G assinsert). */
#include "nhl95.h"

/* assinsert (12011) - 93G assinsert: push assignment a on player p's 8-entry assignment ring (assnum - 1, mod
   8), so the current one resumes when a ends; then assreplace. */
void assinsert(Player *p, short a)
{
    p->assnum = (p->assnum - 1) & 7;
    assreplace(p, a);
}
