/* Engine player logic: referee. */
#include "nhl95.h"

/* assrefatdot (4DFF7) - referee p at the faceoff dot (not while flag 20h, word_CBEC6 or the clock at 0): a new
   assignment (pflags bit 1) turns him toward the dot (facedir 2/6 by fox side) with SPA C57h; unless gmode2 bit 0,
   stand him 15 off the dot (fox, foy) at rest. */
void assrefatdot(Player *p)
{
    if (p->pflags & 0x20) return;
    if (word_CBEC6) return;
    if (!gameclock && !clockticks[0]) return;
    if (p->pflags & 2) {
        p->pflags &= 0xFD;
        p->facedir = fox <= 0 ? 2 : 6;
        SetSPA(p, 0xC57);
        p->pflags &= 0xFB;
        p->pflags2 &= 0xDF;
    }
    if (gmode2 & 1) return;
    HIWORD(p->Xpos) = fox <= 0 ? fox - 15 : fox + 15;
    HIWORD(p->Ypos) = foy;
    p->Xvel = p->Yvel = 0;
}
