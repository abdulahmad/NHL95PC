/* Engine core: clear the game variables. */
#include "nhl95.h"

/* cleargamevars: zero the 68k register statics regd0-regd4 and their neighbours,
 the faceoff leader threat words, collflag, the mode and sound flags (lastsfx -1), then
 ClearPenaltyBuffer. The chains store right to left, as the asm order shows. */
void cleargamevars(void)
{
    regd0.l = regd1.l = regd2.l = regd3.l = regd4.l = *(int *)&word_E03B8 = *(int *)&word_E03A0 = dword_E03A8 = 0;
    ltack = lldispodd = threat = collflag = fodir2 = fodir1 = foy = fox = yleader = yc1 = xc1 = 0;
    lastsfx = -1;
    *(short *)&sflags3 = *(short *)&gmode2 = *(short *)&sflags = gmode = 0;
    ClearPenaltyBuffer();
}
