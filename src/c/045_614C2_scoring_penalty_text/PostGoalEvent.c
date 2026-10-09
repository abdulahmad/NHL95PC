/* Scoring / penalties: game summary event queue. */
#include "nhl95.h"

/* one queued game summary event: 11 bytes */
typedef struct GSumEvent {
    unsigned char b[11];
} GSumEvent;

/* PostGoalEvent (62343) - PC only: build event 1 (goal) in byte_E9AC8 for team t: t, scorer, the assists a1 / a2,
   b, the period, c, d and both teams' goalies in net (line table slot 24h + tmgoalie bit 0). Unless gmode bit 4:
   append it to the summary event queue (at most 8) and count the team's goal. For a home goal reload the team
   art (LoadTeamPPV 1 or 5 at random). Rebuild the event lines, close the text overlay, pause joystick sampling
   (saved in joysampling_save) and keep a copy of the event in byte_E9AD3. */
void PostGoalEvent(int t, unsigned char scorer, unsigned char a1, unsigned char a2, unsigned char b, unsigned char c,
                   unsigned char d)
{
    byte_E9AC8 = 1;
    byte_E9AC9 = t;
    byte_E9ACA = scorer;
    byte_E9ACB = a1;
    byte_E9ACC = a2;
    byte_E9ACD = b;
    byte_E9ACE = curperiod;
    byte_E9ACF = c;
    byte_E9AD0 = d;
    byte_E9AD1 = (&hmtmstruct)[t].tmlines[0x24 + (short)((&hmtmstruct)[t].tmgoalie & 1)];
    byte_E9AD2 = ((&hmtmstruct)[t == 0].tmlines + 0x24)[(short)((&hmtmstruct)[t == 0].tmgoalie & 1)];
    if ((gmode & 0x10) == 0) {
        ((GSumEvent *)unk_E9B4C)[gsumqcount] = *(GSumEvent *)&byte_E9AC8;
        if (++gsumqcount >= 8) gsumqcount--;
        if (t) awgoalcnt++;
        else hmgoalcnt++;
    }
    if (t == 0) LoadTeamPPV((short)(randomd0(0x14) < 10 ? 1 : 5));
    BuildEventLines();
    CloseTextOverlay();
    joysampling_save = joysampling;
    joysampling = 0;
    *(GSumEvent *)&byte_E9AD3 = *(GSumEvent *)&byte_E9AC8;
    joysampling = *(int *)((char *)&joysampling_save - 2) >> 16;
}
