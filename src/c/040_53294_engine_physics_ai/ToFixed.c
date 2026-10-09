/* ToFixed (53294) - PC only: integer to 16.16 fixed point (v << 16). Called from passtoa0 to turn the pass
   target coordinates into the fixed-point form of Xpos/Ypos. */
#include "nhl95.h"

int ToFixed(int v)
{
    return v << 16;
}
