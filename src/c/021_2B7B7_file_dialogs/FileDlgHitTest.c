/* File dialogs: hit test. */
#include "nhl95.h"

typedef struct FRect {
    int x1, y1, x2, y2;
} FRect;

/* FileDlgHitTest (2C3FF) - PC only: the file dialog item (16 rects of 4 dwords, fdlgrects) under point x - 6,
   y - 13h, stored in *item. Returns 1 for a hit, else 0. */
int FileDlgHitTest(int x, int y, int *item)
{
    int i;

    x -= 6;
    y -= 0x13;
    for (i = 0; i < 16; i++) {
        if (x >= ((FRect *)fdlgrects)[i].x1 && x <= ((FRect *)fdlgrects)[i].x2 && y >= ((FRect *)fdlgrects)[i].y1
            && y <= ((FRect *)fdlgrects)[i].y2) {
            *item = i;
            return 1;
        }
    }
    return 0;
}
