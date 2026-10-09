/* Menu / dialog callbacks. */
#include "nhl95.h"

/* EditRostersReturn (6D5BB) - leave the roster editor: editrosters_exit = -1. */
void EditRostersReturn(void)
{
    editrosters_exit = -1;
}
