/* cflags: -od */
/* Standings / playoffs: playoff tree cursor. */
#include "nhl95.h"

/* MoveTreeHighlight (27BC3) - PC only: move the playoff tree highlight from slot *from to slot *to: unhighlight
   from (HighlightTreeSlot toggles), highlight to and store it in *from; slots whose team is 26 or more (empty)
   are skipped. This segment was compiled without optimisation (ebp frame, arguments spilled). */
void MoveTreeHighlight(int *from, int *to)
{
    if (from && playofftree[*from] < 26) {
        HighlightTreeSlot(from);
        if (to && playofftree[*to] < 26) {
            HighlightTreeSlot(to);
            *from = *to;
        }
    }
}
