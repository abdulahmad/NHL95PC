/* Scoring penalty text: the event text lines. */
#include "nhl95.h"

/* The existing exit owner is compilation context for BuildEventLines shared tail.
   Its original C file continues to supply RunDeferredCalls to the build. */
/* one queued call: 7 arguments and the function (20h bytes, table at E9BA4) */
typedef struct DeferCall {
    int a, b, c, d, e, f, g;
    void (*fn)(int, int, int, int, int, int, int);
} DeferCall;

#define Q(i) ((DeferCall *)dword_E9BA4)[i]

/* RunDeferredCalls: make the defercount queued calls (dword_E9BA4 table: arguments in eax, edx,
 ebx, ecx, then 3 on the stack) in order and empty the queue. */
void RunDeferredCalls(void)
{
    int i;

    for (i = 0; i < defercount; i++) {
        Q(i).fn(Q(i).a, Q(i).b, Q(i).c, Q(i).d, Q(i).e, Q(i).f, Q(i).g);
    }
    defercount = 0;
}


typedef struct { char c[13]; } T13;
typedef struct { char c[15]; } T15;
typedef struct { char c[16]; } T16;

/* BuildEventLines (61E99, PC only; ends in fileio_popebpx, RunDeferredCalls' exit): build the five text lines of
   the event in byte_E9AC8 on (type, side, player, then per type). 1, a goal: the time and the team; the scorer
   with a short-handed / power-play tag and, outside exhibition games and game mode bit 10h, the goals so far;
   "unassisted" or the one or two assists. 2, a penalty: for a penalty shot (11h) "PENALTY SHOT" / "TO BE TAKEN
   BY" and the shooter (penshotteam, penshotpnum); else the player, the penalty name (penaltynames) and the
   minutes, FFh a game misconduct. 3, an injury: the player and whether it is for the game (a positive length) or
   for one period. Rosters are 444h bytes a side, 27h a player (jersey at +5, names at +7 and +17h); team records
   2E8h. No result. */
void BuildEventLines(void)
{
    char buf[0xC];
    int side;
    int pl;
    int f;
    int n;

    textline3 = textline1 = textline2 = textline4 = textline5 = 0;
    if (byte_E9AC8 == 1) {
        side = byte_E9AC9;
        sprintf((char *)&textline3, (char *)str_FmtClockEvent, byte_E9ACF, byte_E9AD0,
                (char *)hmteamrec + side * 0x2E8 + 0x1A);
        f = byte_E9ACD;
        pl = byte_E9ACA;
        n = sprintf(buf, (char *)str_S8, (f & 2) ? (char *)str_SHTag : (f & 4) ? (char *)str_PPTag : (char *)unk_C1B49);
        if (gamemode != 0 && !(gmode & 0x10) && pl < 0x19)
            sprintf(buf + n, (char *)str_FmtParenD, *(short *)((char *)dword_DB088 + side * 400 + pl * 16)
                    + *(int *)((char *)dword_DEB7C + side * 400 + pl * 16));
        FormatPlayerName((char *)&textline1, (char *)unk_C1B49, hmrosterjersey[side * 0x444 + pl * 0x27],
                         (char *)hmroster + side * 0x444 + pl * 0x27 + 7, (char *)hmroster + side * 0x444 + pl * 0x27 + 0x17, buf);
        pl = (unsigned char)byte_E9ACB;
        if (pl == 0xFF) {
            sprintf((char *)&textline2, (char *)str_Unassisted);
        } else {
            sprintf((char *)&textline2, (char *)str_Assists);
            FormatPlayerName((char *)&textline4, (char *)unk_C1B49, hmrosterjersey[side * 0x444 + pl * 0x27],
                             (char *)hmroster + side * 0x444 + pl * 0x27 + 7, (char *)hmroster + side * 0x444 + pl * 0x27 + 0x17,
                             (char *)unk_C1B49);
        }
        pl = byte_E9ACC;
        if (pl != 0xFF)
            FormatPlayerName((char *)&textline5, (char *)unk_C1B49, hmrosterjersey[side * 0x444 + pl * 0x27],
                             (char *)hmroster + side * 0x444 + pl * 0x27 + 7, (char *)hmroster + side * 0x444 + pl * 0x27 + 0x17,
                             (char *)unk_C1B49);
    } else if (byte_E9AC8 == 2) {
        side = byte_E9AC9;
        pl = byte_E9ACA;
        if (byte_E9ACB == 0x11) {
            sprintf((char *)&textline3, (char *)str_FmtClockEvent, byte_E9ACE, byte_E9ACF,
                    (char *)hmteamrec + penshotteam * 0x2E8);
            *(T13 *)&textline1 = *(T13 *)str_PenaltyShot;
            *(T15 *)&textline2 = *(T15 *)str_ToBeTakenBy;
            FormatPlayerName((char *)&textline4, (char *)unk_C1B49, hmrosterjersey[penshotteam * 0x444 + penshotpnum * 0x27],
                             (char *)hmroster + penshotteam * 0x444 + penshotpnum * 0x27 + 7,
                             (char *)hmroster + penshotteam * 0x444 + penshotpnum * 0x27 + 0x17, (char *)unk_C1B49);
        } else {
            sprintf((char *)&textline3, (char *)str_02d02dSPenalty, byte_E9ACE, byte_E9ACF,
                    (char *)hmteamrec + side * 0x2E8);
            FormatPlayerName((char *)&textline1, (char *)unk_C1B49, hmrosterjersey[side * 0x444 + pl * 0x27],
                             (char *)hmroster + side * 0x444 + pl * 0x27 + 7, (char *)hmroster + side * 0x444 + pl * 0x27 + 0x17,
                             (char *)unk_C1B49);
            strcpy((char *)&textline2, (char *)penaltynames[(unsigned char)byte_E9ACB]);
            n = byte_E9ACC;
            if (n == 0xFF)
                *(T16 *)&textline4 = *(T16 *)str_GameMisconduct;
            else
                sprintf((char *)&textline4, (char *)str_DMinutes, n);
        }
    } else if (byte_E9AC8 == 3) {
        side = byte_E9AC9;
        pl = byte_E9ACA;
        n = byte_E9ACB;
        sprintf((char *)&textline3, (char *)str_02d02dSInjury, byte_E9ACD, byte_E9ACE, (char *)hmteamrec + side * 0x2E8);
        FormatPlayerName((char *)&textline1, (char *)unk_C1B49, hmrosterjersey[side * 0x444 + pl * 0x27],
                         (char *)hmroster + side * 0x444 + pl * 0x27 + 7, (char *)hmroster + side * 0x444 + pl * 0x27 + 0x17,
                         (char *)unk_C1B49);
        if (n > 0) sprintf((char *)&textline2, (char *)str_GoneForTheGame);
        else sprintf((char *)&textline2, (char *)str_GoneFor1Period);
    }
}
