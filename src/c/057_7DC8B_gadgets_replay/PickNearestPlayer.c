/* Gadgets / replay: nearest player to a point. */
#include "nhl95.h"

#define PX(i) (*(int *)((char *)dword_E9F16 + (i) * 2) >> 16)  /* word_E9F18[i], as the top word of a dword */
#define PY(i) (*(int *)((char *)dword_E9F38 + (i) * 2) >> 16)  /* word_E9F3A[i], likewise */

/* PickNearestPlayer (7E93E) - PC only: the object (0-16, skipping 12-15) whose replay position (word_E9F18 /
   word_E9F3A) is nearest to x, y and within distance 10 (squared distance up to 100). Returns it, or -1. */
int PickNearestPlayer(int x, int y)
{
    int best;
    int bestd;
    int i;
    int dx;
    int dy;
    int yy;

    best = -1;
    bestd = 10000;
    i = 0;
    yy = y;
    for (; i < 17; i++) {
        if (i >= 12 && i <= 15) continue;
        dx = PX(i) - x;
        dy = PY(i) - yy;
        dy = dy * dy + dx * dx;
        if (dy <= 100 && dy < bestd) {
            bestd = dy;
            best = i;
        }
    }
    return best;
}
