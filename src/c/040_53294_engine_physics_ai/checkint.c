/* Engine physics / AI: interference check (93G checkint). */
#include "nhl95.h"

#define PFLAGS_PNUM(p) (*(int *)&(p)->pflags >> 24)  /* pnum, read as the top byte of the dword at +44h */
#define PDST(t, n) (*(int *)((char *)(t)->tmpdst + (n) * 2 - 2) >> 16)  /* tmpdst[n], as the top word of a dword */

/* checkint (53E6A) - 93G checkint: for both orders of a collision pair (a hits b, then b hits a): when b has no
   position (0), not in a stoppage (gmode bit 0) and a carries the puck or hits hard (impact > 25), with impact > 2: b
   falls (FallDown). Then, with word_E9B28 at least 8 (10 against a puck carrier) and b at least A0h from the centre
   line in y: an interference penalty (11h) on a when a is not SCnum 16, is on the ice (tmpdst > -3), b's impact is
   over 30, a's pflags2 bit 4 is clear, randomd0(20 - aggression) <= 2, not gmode bit 4 and b's Ypos+2 bit 2 clear. */
void checkint(Player *a, Player *b)
{
    Player *t;
    signed char i;

    for (i = 0; i < 2; i++) {
        if (b->position == 0 && !(gmode & 1) && (*(signed char *)puckc == a->SCnum || a->impact > 25)
            && a->impact > 2) {
            FallDown(b, a);
            if (word_E9B28 >= 8 && (*(signed char *)puckc != a->SCnum || word_E9B28 >= 10)
                && (HIWORD(b->Ypos) < 0 ? -(b->Ypos >> 16) : b->Ypos >> 16) >= 0xA0 && a->SCnum != 16
                && PDST(a->tmptr, PFLAGS_PNUM(a)) > -3 && b->impact > 30 && !(a->pflags2 & 0x10)
                && randomd0((short)(20 - a->aggress)) <= 2 && !(gmode & 0x10) && !(*((unsigned char *)b + 6) & 4))
                AddPenalty(a, 0x11);
        }
        t = a;
        a = b;
        b = t;
    }
}
