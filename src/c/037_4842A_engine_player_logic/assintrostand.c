/* Engine player logic: intro (93G assintrostand). */
#include "nhl95.h"

/* assintrostand (4842A) - assignment while the players stand for the intro: unless locked (pflags bit 5) or parked
   (temp5 -100), count temp5 down; meanwhile shuffle x around temp3 now and then and play one of 5 random idle
   animations (dword_CC9CE high words); when it runs out insert assignment 27h. */
void assintrostand(Player *p)
{
    if (p->pflags & 0x20) return;
    if (p->temp5 == -100) return;
    if (--p->temp5 > 0) {
        if (!randomd0(100)) HIWORD(p->Xpos) = p->temp3 + randomd0(2);
        if (p->pflags2 & 2) return;
        if (randomd0(0x50)) return;
        SetSPA(p, HIWORD(dword_CC9CE[randomd0(9) % 5]));
        p->pflags2 |= 2;
        return;
    }
    assinsert(p, 0x27);
}
