/* Engine player logic: player goes into the penalty box. */
#include "nhl95.h"

/* assdopen: asstab 0Dh: player p goes into the penalty box.
 Nothing while his animation is locked (pfalock). Bumps the box count of his team (PBnum[0] home), then position = -1 in its high byte (the 68k high byte) and frame = -1. */
void assdopen(Player *p)
{
    if (!(p->pflags & pfalock)) {
        if (!(p->pflags & pfteam))
            PBnum[0]++;                         /* home */
        else
            PBnum[1]++;                         /* visitors */
        HIBYTE(p->position) = -1;               /* st position(a3) */
        p->frame = -1;
    }
}
