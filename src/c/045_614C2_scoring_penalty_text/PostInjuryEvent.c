/* Scoring / penalties: game summary event queue. */
#include "nhl95.h"

/* one queued game summary event: 11 bytes */
typedef struct GSumEvent {
    unsigned char b[11];
} GSumEvent;

/* PostInjuryEvent (62764) - PC only: unless gmode bit 4, build event 3 (injury) in byte_E9AC8: a, b, c, the
   period, d, e; append it to the summary event queue (unk_E9B4C, at most 8: a full queue overwrites the last),
   rebuild the event lines and close the text overlay. f and g are unused. Returns 0. */
int PostInjuryEvent(unsigned char a, unsigned char b, unsigned char c, unsigned char d, unsigned char e, int f, int g)
{
    if ((gmode & 0x10) == 0) {
        byte_E9AC8 = 3;
        byte_E9AC9 = a;
        byte_E9ACA = b;
        byte_E9ACB = c;
        byte_E9ACC = curperiod;
        byte_E9ACD = d;
        byte_E9ACE = e;
        ((GSumEvent *)unk_E9B4C)[gsumqcount] = *(GSumEvent *)&byte_E9AC8;
        if (++gsumqcount >= 8) gsumqcount--;
        BuildEventLines();
        CloseTextOverlay();
    }
    return 0;
}
