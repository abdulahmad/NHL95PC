#include "nhl95.h"

/* pucknothing (4D8FD) - 92G/93G pucknothing (asstab slot 26, the puck carrier has nothing to do): just ends
   the puck flip animation. The call to puckunflip, which follows in this file, compiles to a fall-through (wcc386 turns the
   tail call into a jmp and drops the jmp to the next function), so both live in one file. */
void pucknothing(Player *p)
{
    puckunflip(p);
}

/* puckunflip (4D907) - 93G/92G puckunflip: end the puck flip animation of player p. When the animation stopped in
   its middle frames (SPAnum 4-11) the facing gets bit 1 flipped back; then facedir bit 2 is set and the
   animation is restarted (SPAnum = 0, SPAcnt = -1, as SetSPA does). */
void puckunflip(Player *p)
{
    short frame = p->SPAnum;

    if (frame >= 4 && frame < 12) p->facedir ^= 2;
    p->facedir |= 4;
    p->SPAnum = 0;
    p->SPAcnt = -1;             /* restart animation */
}
