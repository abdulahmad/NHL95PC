/* Input: pointer events. */
#include "nhl95.h"

/* EventToPointer (6B4BB) - move the pointer (*x, *y, clamped to 0..275h x 0..1D5h) for input event ev: a mouse event
   (type 1) gives the position (dwords at +5, +9); otherwise the direction bits at +5 (8 left, 4 right, 1 up,
   2 down) step it by ptrstep = 8 << (inputrepeat / 5) (inputrepeat capped at 1Dh) and the mouse is moved there.
   Returns the event's button byte (+4). */
int EventToPointer(unsigned char *ev, int *x, int *y)
{
    if (*(int *)ev == 1) {
        *x = *(int *)(ev + 5);
        *y = *(int *)(ev + 9);
        if (*x < 0) *x = 0;
        else if (*x > 0x275) *x = 0x275;
        if (*y < 0) *y = 0;
        else if (*y > 0x1D5) *y = 0x1D5;
    } else {
        if (inputrepeat >= 0x1E) inputrepeat = 0x1D;
        ptrstep = 8 << (inputrepeat / 5);
        if (ev[5] & 8) *x -= ptrstep;
        if (ev[5] & 4) *x += ptrstep;
        if (ev[5] & 1) *y -= ptrstep;
        if (ev[5] & 2) *y += ptrstep;
        if (*x < 0) *x = 0;
        else if (*x > 0x275) *x = 0x275;
        if (*y < 0) *y = 0;
        else if (*y > 0x1D5) *y = 0x1D5;
        MouseSetPos(*x, *y);
        mousex = *x;
        mousey = *y;
    }
    return ev[4];
}
