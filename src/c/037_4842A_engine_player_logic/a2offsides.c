/* Engine player logic: offsides. */
#include "nhl95.h"

/* a2offsides (4DCDD) - offsides check for p (offsides option on, no penalty shot): the puck is past the blue line (4Eh,
   toward p's attacking end) while p's team has its offside flag (tmflags bit 4) and play is not stopped
   (gmode bit 4): call offsides (AddPenalty kind 8), return 1. */
int a2offsides(Player *p)
{
    if (!gameopts.offsides) return 0;
    if (penshotlive || penshotstart) return 0;
    regd0.w = *pucky;
    if (!(p->pflags & pfgoal)) regd0.w = -regd0.w;
    if (regd0.w < 0x4E) return 0;
    if (!(p->tmptr->tmflags & 0x10)) return 0;
    if (gmode & 0x10) return 0;
    AddPenalty(p, 8);
    return 1;
}
