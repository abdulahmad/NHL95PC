/* Engine physics / AI: goalie save rating. */
#include "nhl95.h"

/* SkillForAnim (54134) - the rating byte that decides p's current save / move animation (SPA): the left / right pairs
   passacc / aggress (SPA C9h, E1h, 11D5h; B1h the other way round) and spodds / endurance (119h; 101h and
   121Dh the other way round) are picked by handedness; any other animation uses shotspd. */
int SkillForAnim(Player *p)
{
    switch (p->SPA) {
    case 0xC9:
    case 0xE1:
    case 0x11D5:
        return !p->handed ? p->passacc : p->aggress;
    case 0xB1:
        return !p->handed ? p->aggress : p->passacc;
    case 0x119:
        return !p->handed ? p->endurance : p->spodds;
    case 0x101:
    case 0x121D:
        return !p->handed ? p->spodds : p->endurance;
    default:
        return p->shotspd;
    }
}
