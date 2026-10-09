/* Settings dialogs: control boxes. */
#include "nhl95.h"

/* DrawCtlBoxes (7D671) - draw the 9 control setting boxes (rects of 4 ints at ctldlgrects) on or off from the bits of
   setbits. */
void DrawCtlBoxes(void)
{
    int i;

    for (i = 0; i < 9; i++) {
        if (setbits[0] & (1 << i)) DrawCtlBoxOn(&ctldlgrects[i * 4]);
        else DrawCtlBoxOff(&ctldlgrects[i * 4]);
    }
}
