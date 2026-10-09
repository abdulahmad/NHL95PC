/* Engine physics / AI: passing. */
#include "nhl95.h"

/* ScatterPass (54D63) - p passes to player to: p gets no puck collision for 28h frames and (in play) a pass on the team
   stats; passplayer = to, assignment 13h (receive) for to; the puck gets a random velocity scaled by p's pass
   accuracy ((12h - passacc) * 20). */
void ScatterPass(Player *p, Player *to)
{
    p->nopuck = 0x28;
    if (!(gmode & 0x10)) p->tmptr->tmpass++;
    passplayer = to->SCnum;
    p->passlane = 0;
    assinsert(to, 0x13);
    *(short *)puckvz = 0;
    *puckvx = randomd0((0x12 - p->passacc) * 20);
    *puckvy = randomd0((0x12 - p->passacc) * 20);
    word_DFF5A = 0;
}
