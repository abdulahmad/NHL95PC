/* Settings locker room: selection box bevel. */
#include "nhl95.h"

/* DrawSelBoxOn: draw the bevel of selection box r (l, t, r, b) pressed in: left and top
 edges in colour F8h, right and bottom in FAh (FillRectColor lines). */
void DrawSelBoxOn(Rect4 *r)
{
    FillRectColor(r->l + 10, r->b + 18, r->l + 10, r->t + 19, 0xF8);
    FillRectColor(r->l + 10, r->t + 19, r->r + 9, r->t + 19, 0xF8);
    FillRectColor(r->r + 10, r->t + 20, r->r + 10, r->b + 19, 0xFA);
    FillRectColor(r->r + 10, r->b + 19, r->l + 11, r->b + 19, 0xFA);
}

/* DrawSelBoxOff: the same bevel raised (left top FAh, right bottom F8h). The last line is
 DrawSelBoxOn's (shared tail), so both are in this file. */
void DrawSelBoxOff(Rect4 *r)
{
    FillRectColor(r->l + 10, r->b + 18, r->l + 10, r->t + 19, 0xFA);
    FillRectColor(r->l + 10, r->t + 19, r->r + 9, r->t + 19, 0xFA);
    FillRectColor(r->r + 10, r->t + 20, r->r + 10, r->b + 19, 0xF8);
    FillRectColor(r->r + 10, r->b + 19, r->l + 11, r->b + 19, 0xF8);
}
