/* Scoring penalties: game summary event queue. */
#include "nhl95.h"

/* one queued game summary event: 11 bytes */
typedef struct GSumEvent {
    unsigned char b[11];
} GSumEvent;

/* PostGoalEvent: build event 1 (goal) in curevent for team t: scorer, the assists a1 a2,
 b, the period, c, d and both teams' goalies in net (line table slot 24h + tmgoalie bit 0). Unless gmode bit 4:
 append it to the summary event queue (at most 8) and count the team's goal. For a home goal reload the team
 art (LoadTeamPPV 1 or 5 at random). Rebuild the event lines, close the text overlay, pause joystick sampling
 (saved in joysampling_save) and keep a copy of the event in goalevent. */
void PostGoalEvent(int t, unsigned char scorer, unsigned char a1, unsigned char a2, unsigned char b, unsigned char c,
                   unsigned char d)
{
    curevent = 1;
    curevent_b1 = t;
    curevent_b2 = scorer;
    curevent_b3 = a1;
    curevent_b4 = a2;
    curevent_b5 = b;
    curevent_b6 = curperiod;
    curevent_b7 = c;
    curevent_b8 = d;
    curevent_b9 = (&hmtmstruct)[t].tmlines[0x24 + (short)((&hmtmstruct)[t].tmgoalie & 1)];
    curevent_b10 = ((&hmtmstruct)[t == 0].tmlines + 0x24)[(short)((&hmtmstruct)[t == 0].tmgoalie & 1)];
    if ((gmode & 0x10) == 0) {
        ((GSumEvent *)gsumqueue)[gsumqcount] = *(GSumEvent *)&curevent;
        if (++gsumqcount >= 8) gsumqcount--;
        if (t) awgoalcnt++;
        else hmgoalcnt++;
    }
    if (t == 0) LoadTeamPPV((short)(randomd0(0x14) < 10 ? 1 : 5));
    BuildEventLines();
    CloseTextOverlay();
    joysampling_save = joysampling;
    joysampling = 0;
    *(GSumEvent *)&goalevent = *(GSumEvent *)&curevent;
    joysampling = *(int *)((char *)&joysampling_save - 2) >> 16;
}
