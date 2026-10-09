/* Scoring / penalty text: penalty box door. */
#include "nhl95.h"

/* SetBoxDoorObject (61576) - show the penalty box door open (rink object 13h, frame 88h) or closed (12h, 87h). */
void SetBoxDoorObject(int open)
{
    if (open) SetRinkObject(0x13, 0x88);
    else SetRinkObject(0x12, 0x87);
}
