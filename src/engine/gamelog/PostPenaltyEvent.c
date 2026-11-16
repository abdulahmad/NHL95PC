/* Scoring penalties: queue a penalty and say it. */
#define PostPenaltyEvent PostPenaltyEvent_decl
#include "nhl95.h"
#undef PostPenaltyEvent

/* These calls leave edx alone, so the penalty length stays in the register it arrived in. */
#pragma aux randomd0 modify [eax ecx];
#pragma aux LoadTeamPPV modify [eax ecx];
#pragma aux BuildEventLines modify [eax ecx];
#pragma aux CloseTextOverlay modify [eax ecx];

/* one queued game summary event: 11 bytes */
typedef struct GSumEvent {
    unsigned char b[11];
} GSumEvent;

/* PostPenaltyEvent: event type 2. team, player, the penalty number and its length, then the two
 clock bytes, are stored with the period. Unless a replay is up (gmode bit 4), the 11-byte record
 is queued (at most 8). While the overlay is down and this is not a penalty shot, a random team
 picture is loaded for penalties 4, 5, 6 and, on the visiting team, any penalty. The crowd is
 capped at 190h. A penalty shot (penalty 11h) names the shooter's team; any other penalty is said
 with the length, and the running team (penevteam) selects the wording. Returns 0. */
int PostPenaltyEvent(int team, int player, int pen, int len, int min, int sec, int who)
{
    int side;
    int cnt;
    int idx;
    int last;

    if ((gmode & 0x10) == 0) {
        curevent = 2;
        curevent_b1 = team;
        curevent_b2 = player;
        curevent_b3 = pen;
        curevent_b4 = len;
        curevent_b5 = curperiod;
        curevent_b6 = min;
        curevent_b7 = sec;
        ((GSumEvent *)gsumqueue)[gsumqcount] = *(GSumEvent *)&curevent;
        if (++gsumqcount >= 8) gsumqcount = gsumqcount - 1;
        if ((*(int *)((char *)&ovltimer - 2) >> 16) == -1 && pen != 0x11) {
            if (team != 0 && randomd0(4) == 0)
                LoadTeamPPV(0x0A);
            else if (pen == 4) {
                if (randomd0(3) == 0) LoadTeamPPV(6);
            } else if (pen == 6) {
                if (randomd0(3) == 0) LoadTeamPPV(7);
            } else if (pen == 5) {
                if (randomd0(3) == 0) LoadTeamPPV(9);
            }
        }
        BuildEventLines();
        CloseTextOverlay();
        joysampling_save = joysampling;
        joysampling = 0;
        if (Crowdlevel > 0x190) Crowdlevel = 0x190;
        side = team ? VisTeam : HomeTeam;
        if (pen == 0x11) {
            side = penshotteam ? VisTeam : HomeTeam;
            PaPenaltyShot((char *)teamabbrevs[side],
                          hmrosterjersey[penshotteam * 0x444 + penshotpnum * 39], min, sec);
        } else {
            last = who == 0;
            if ((*(int *)((char *)&penevteam - 2) >> 16) == team)
                idx = 2;
            else {
                idx = 1;
                penevteam = team;
            }
            if (who && (((((signed char *)PenBuf_pl_m2)[who * 2] & 0x1F) < 6) ^ team) != 0)
                cnt = idx + 1;
            else
                cnt = idx;
            PaPenalty((char *)teamabbrevs[side],
                      hmrosterjersey[team * 0x444 + player * 39], len, (char *)pennametab[pen],
                      min, sec, idx, cnt, last);
            if (last) penevteam = -1;
        }
        joysampling = *(int *)((char *)&joysampling_save - 2) >> 16;
    }
    return 0;
}
