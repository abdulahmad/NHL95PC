/* Create player: handedness. */
#include "nhl95.h"

/* AskLeftRight (6FBE8) - ask "L or R" with prompt (default from *left); L / l sets *left 1, R / r sets 0; cancel keeps
   it. */
void AskLeftRight(unsigned char *left, char *prompt)
{
    short v;
    char c;

    if (*left) v = word_C2D0E;
    else v = word_C2D10;
    msglines[0] = (int)prompt;
    if (InputDialog(msglines, 1, (char *)&v, 1, 0x10, 0, 0, 0, 0) == (char)-1) return;
    c = *(char *)&v;
    if (c == 'L' || c == 'l') *left = 1;
    else if (c == 'R' || c == 'r') *left = 0;
}
