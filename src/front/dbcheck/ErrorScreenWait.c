/* Create player: wait on the database error screen. */
#include "nhl95.h"

/* ErrorScreenWait: msg and arg are the mouse x and y. title is the button list and type is how many.
 Draw the pointer, wait until key 1 and key 1Ch are up, then track the mouse until a button or bit 2.
 Writes the final x and y back and returns the button, or -1. */
int ErrorScreenWait(int msg, int arg, char *title, int type)
{
    int result;
    int x;
    int y;
    int ox;
    int oy;
    int done;
    int bits;

    result = -1;
    ox = *(int *)msg;
    x = ox;
    oy = *(int *)arg;
    y = oy;
    MouseSetPos(ox, oy);
    GrabBlock(editptrspr, ox, oy);
    DrawArt(pointerspr, ox, oy);
    while (KeyDown(1) || KeyDown(0x1C))
        ;
    ClearInputQueue();
    done = 0;
    do {
        unsigned char *ev;

        ev = GetInputEvent();
        if (ev) {
            bits = ((int (*)(unsigned char *, int *, int *))ptrupdatefn)(ev, &x, &y);
            if (bits & 4) {
                result = -1;
                done = -1;
            } else if (bits & 3) {
                PutBlock(editptrspr, ox, oy);
                if (type > 0) {
                    result = TrackButtons((int *)title, type, x, y, bits);
                    if (result >= 0) done = -1;
                } else if (bits & 2)
                    done = -1;
                GrabBlock(editptrspr, ox, oy);
                DrawArt(pointerspr, ox, oy);
            }
            if (ox != x || oy != y) {
                PutBlock(editptrspr, ox, oy);
                GrabBlock(editptrspr, x, y);
                DrawArt(pointerspr, x, y);
                ox = x;
                oy = y;
            }
        }
    } while (done == 0);
    while (KeyDown(1) || KeyDown(0x1C))
        ;
    ClearInputQueue();
    PutBlock(editptrspr, ox, oy);
    ClearInputQueue();
    MouseSetPos(x, y);
    *(int *)msg = x;
    *(int *)arg = y;
    return result;
}
