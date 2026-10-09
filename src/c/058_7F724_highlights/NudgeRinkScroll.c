/* Highlights: rink scroll. */
#include "nhl95.h"

/* NudgeRinkScroll (7FC12) - move the rink scroll position by 1000 in x and y (forces a redraw of the rink). */
void NudgeRinkScroll(void)
{
    rinkscrollx += 1000;
    rinkscrolly += 1000;
}
