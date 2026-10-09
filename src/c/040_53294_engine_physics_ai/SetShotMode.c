/* Engine physics / AI: shooting. */
#include "nhl95.h"

/* SetShotMode (5786E) - p winds up a shot: pass direction 8 (shot), sflags bit 3; regd0 = direction from p to the
   attacked goal (x 0, y +/-F0h by pflags bit 7), word_C90A6 = 15, then the slap (SPA 491h, when Findhittype finds
   a hit type) or wrist shot animation (3F9h). */
void SetShotMode(Player *p)
{
    passdir = 8;
    sflags |= 8;
    regd0.w = 0;
    regd1.w = !(p->pflags & pfgoal) ? -0xF0 : 0xF0;
    regd0.w = vtoa((short)(regd0.w - HIWORD(p->Xpos)), (short)(regd1.w - HIWORD(p->Ypos)));
    word_C90A6 = 0xF;
    if (Findhittype(p, (short)regd0.w)) SetSPA(p, 0x491);
    else SetSPA(p, 0x3F9);
}
