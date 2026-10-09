/* Settings / locker room: selection box bevel. */
#include "nhl95.h"

/* DrawSelBoxOn (8245A) - PC only: draw the bevel of selection box r (l, t, r, b) pressed in: left and top
   edges in colour F8h, right and bottom in FAh (sub_B4FAC lines). */
void DrawSelBoxOn(Rect4 *r)
{
    sub_B4FAC(r->l + 10, r->b + 18, r->l + 10, r->t + 19, 0xF8);
    sub_B4FAC(r->l + 10, r->t + 19, r->r + 9, r->t + 19, 0xF8);
    sub_B4FAC(r->r + 10, r->t + 20, r->r + 10, r->b + 19, 0xFA);
    sub_B4FAC(r->r + 10, r->b + 19, r->l + 11, r->b + 19, 0xFA);
}

/* DrawSelBoxOff (824F8) - PC only: the same bevel raised (left / top FAh, right / bottom F8h). The last line is
   DrawSelBoxOn's (shared tail), so both are in this file. */
void DrawSelBoxOff(Rect4 *r)
{
    sub_B4FAC(r->l + 10, r->b + 18, r->l + 10, r->t + 19, 0xFA);
    sub_B4FAC(r->l + 10, r->t + 19, r->r + 9, r->t + 19, 0xFA);
    sub_B4FAC(r->r + 10, r->t + 20, r->r + 10, r->b + 19, 0xF8);
    sub_B4FAC(r->r + 10, r->b + 19, r->l + 11, r->b + 19, 0xF8);
}
