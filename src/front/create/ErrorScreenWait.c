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
    sub_91400(editptrspr, ox, oy);
    sub_91370(pointerspr, ox, oy);
    while (sub_B2CBE(1) || sub_B2CBE(0x1C))
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
                sub_903F0(editptrspr, ox, oy);
                if (type > 0) {
                    result = TrackButtons((int *)title, type, x, y, bits);
                    if (result >= 0) done = -1;
                } else if (bits & 2)
                    done = -1;
                sub_91400(editptrspr, ox, oy);
                sub_91370(pointerspr, ox, oy);
            }
            if (ox != x || oy != y) {
                sub_903F0(editptrspr, ox, oy);
                sub_91400(editptrspr, x, y);
                sub_91370(pointerspr, x, y);
                ox = x;
                oy = y;
            }
        }
    } while (done == 0);
    while (sub_B2CBE(1) || sub_B2CBE(0x1C))
        ;
    ClearInputQueue();
    sub_903F0(editptrspr, ox, oy);
    ClearInputQueue();
    MouseSetPos(x, y);
    *(int *)msg = x;
    *(int *)arg = y;
    return result;
}
