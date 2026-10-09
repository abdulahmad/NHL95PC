/* Engine player logic: player goes into the penalty box (93G logic93_2 / 94G assign94 assdopen). */
#include "nhl95.h"

/* assdopen (4AFFB) - asstab 0Dh: player p goes into the penalty box (93G logic93_2 / 94G assign94 assdopen).
   Nothing while his animation is locked (pfalock, 94G btst #5). Bumps the box count of his team (PBnum[0] home,
   PBnum[1] visitors by pfteam; 94G adds 10h or 1 to one byte), then position = -1 in its high byte (94G
   st position(a3), the 68k high byte) and frame = -1 (94G clr.w frame). */
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
