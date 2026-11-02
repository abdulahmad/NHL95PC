/* Misc dialogs: run a message box. */
#define RunMessageBox RunMessageBox_decl
#include "nhl95.h"
#undef RunMessageBox

typedef struct { char c[17]; } Hdr17;

/* RunMessageBox: track the pointer over n buttons until one is chosen.
 xptr and yptr are the mouse position. Returns the button, 4, or -1. */
int RunMessageBox(int *xptr, int *yptr, int *buttons, int n)
{
    int bits;
    int bm;
    int result;
    int x;
    int y;
    int ox;
    int oy;
    int done;
    int sz;

    sz = ((((short *)pointerspr)[2] << 2) + 4) * (((short *)pointerspr)[3] + 1) + 0x11;
    bm = sub_8CCA8((char *)str_Pointer6, sz, 0x20);
    *(Hdr17 *)bm = *(Hdr17 *)pointerspr;
    ((short *)bm)[2] = ((short *)pointerspr)[2] + 1;
    ((short *)bm)[3] = ((short *)pointerspr)[3] + 1;
    result = 0;
    ox = *xptr;
    x = ox;
    oy = *yptr;
    y = oy;
    MouseSetPos(ox, oy);
    sub_91400(bm, ox, oy);
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
            if (bits & 0x2F) {
                sub_903F0(bm, ox, oy);
                if (n > 0) {
                    if (bits & 4) {
                        result = -1;
                        done = result;
                    } else {
                        result = TrackButtons(buttons, n, x, y, bits);
                        if (result >= 0)
                            done = -1;
                    }
                } else if (bits & 4) {
                    result = 4;
                    done = -1;
                } else if (bits & 0x2A)
                    done = -1;
                sub_91400(bm, ox, oy);
                sub_91370(pointerspr, ox, oy);
            }
            if (ox != x || oy != y) {
                sub_903F0(bm, ox, oy);
                sub_91400(bm, x, y);
                sub_91370(pointerspr, x, y);
                ox = x;
                oy = y;
            }
        }
    } while (done == 0);
    while (sub_B2CBE(1) || sub_B2CBE(0x1C))
        ;
    ClearInputQueue();
    sub_903F0(bm, ox, oy);
    ClearInputQueue();
    MouseSetPos(x, y);
    *xptr = x;
    *yptr = y;
    FreeMemBlock(bm);
    return result;
}
