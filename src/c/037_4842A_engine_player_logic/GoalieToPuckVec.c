/* Engine player logic: goalie vector to the puck. */
#include "nhl95.h"

/* GoalieToPuckVec (4B467) - regd0 / regd1 = puck - player p (x / y words). When p is inside the E8h band at his
   end and the puck is beyond the band at the same end, regd1 is forced to 1 (bottom end) or -1 (top end) so the
   goalie only steps sideways. */
void GoalieToPuckVec(Player *p)
{
    int y;

    y = HIWORD(p->Ypos);
    regd0.w = *puckx - HIWORD(p->Xpos);
    regd1.w = *pucky - HIWORD(p->Ypos);
    if (y < 0) {
        if (y >= -0xE8 && *pucky < -0xE8) {
            regd1.w = 1;
            return;
        }
    } else if (y < 0xE8 && *pucky >= 0xE8) {
        regd1.w = -1;
    }
}
