/* Scoring penalties: game summary event queue. */
#include "nhl95.h"

/* one queued game summary event: 11 bytes */
typedef struct GSumEvent {
    unsigned char b[11];
} GSumEvent;

/* PostInjuryEvent: unless gmode bit 4, build event 3 (injury) in curevent: a, b, c, the
 period, d, e; append it to the summary event queue (gsumqueue, at most 8: a full queue overwrites the last),
 rebuild the event lines and close the text overlay. f and g are unused. Returns 0. */
int PostInjuryEvent(unsigned char a, unsigned char b, unsigned char c, unsigned char d, unsigned char e, int f, int g)
{
    if ((gmode & 0x10) == 0) {
        curevent = 3;
        curevent_b1 = a;
        curevent_b2 = b;
        curevent_b3 = c;
        curevent_b4 = curperiod;
        curevent_b5 = d;
        curevent_b6 = e;
        ((GSumEvent *)gsumqueue)[gsumqcount] = *(GSumEvent *)&curevent;
        if (++gsumqcount >= 8) gsumqcount--;
        BuildEventLines();
        CloseTextOverlay();
    }
    return 0;
}

/* NullCallback0C: do-nothing event callback with PostInjuryEvent's seven arguments (three on
 the stack). Returns 0. */
int NullCallback0C(int a, int b, int c, int d, int e, int f, int g)
{
    return 0;
}
