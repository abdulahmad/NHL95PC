/* Engine core: stick position of a player sprite (PC only). */
#include "nhl95.h"

/* GetHotStick (5A4AD) - PC only, as GetHot for the stick table: regd0/regd1 = the x/y bytes of byte_CC7A4 /
   byte_CC7A5 (2 bytes per frame) for the player's frame when it is a stick frame (196h-219h, or 3CEh-44Fh
   remapped by -1B4h), else 0,0; x is negated when the sprite is X-flipped (attribute bit 3). */
void GetHotStick(Player *p)
{
    short f;
    short x;

    regd0.w = regd1.w = 0;
    f = p->frame;
    if (f < 0) return;
    if ((f < 0x196 || f > 0x219) && (f < 0x3CE || f > 0x44F)) return;
    if (f >= 0x3CE) f -= 0x1B4;
    f -= 0x196;
    f += f;
    x = byte_CC7A4[f];
    regd0.w = x;
    regd1.w = byte_CC7A5[f];
    if (p->attribute & 8)                       /* X flip */
        regd0.w = -x;
}
