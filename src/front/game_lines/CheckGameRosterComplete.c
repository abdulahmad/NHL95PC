/* Game roster: dressed skaters and goalies before the period starts. */
#define CheckGameRosterComplete CheckGameRosterComplete_decl
#define str_Scratch2 str_Scratch2_fn
#define str_Dress2 str_Dress2_fn
#define str_Player2 str_Player2_fn
#define str_GoalieW2 str_GoalieW2_fn
#define str_RosterIncomplete2 str_RosterIncomplete2_fn
#include "nhl95.h"
#undef CheckGameRosterComplete
#undef str_Scratch2
#undef str_Dress2
#undef str_Player2
#undef str_GoalieW2
#undef str_RosterIncomplete2

extern unsigned char str_Scratch2[];
extern unsigned char str_Dress2[];
extern unsigned char str_Player2[];
extern unsigned char str_GoalieW2[];
extern unsigned char str_RosterIncomplete2[];

typedef struct { char c[8]; } T8;
typedef struct { char c[6]; } T6;
typedef struct { char c[7]; } T7;
typedef struct { char c[27]; } T27;

/* CheckGameRosterComplete: once curperiod is set, the roster is left alone. Before that, team selects a
 game roster. 18 dressed skaters and 2 goalies is complete. Each short or extra group is one formatted
 line under "Your Roster is incomplete.", and MessageBox gets x and y. */
int CheckGameRosterComplete(unsigned char team, int x, int y)
{
    unsigned char buf[0x80];
    int fmt;
    int skaters;
    int goals;
    int lines;
    int i;

    skaters = 0;
    goals = 0;
    *(T8 *)(buf + 0x60) = *(T8 *)str_Scratch2;
    *(T6 *)(buf + 0x78) = *(T6 *)str_Dress2;
    *(T7 *)(buf + 0x70) = *(T7 *)str_Player2;
    *(T7 *)(buf + 0x68) = *(T7 *)str_GoalieW2;
    fmt = (int)str_S2dSS2;
    *(T27 *)(buf + 0x38) = *(T27 *)str_RosterIncomplete2;
    *(int *)(buf + 0x54) = (int)(buf + 0x38);
    lines = 1;
    if (curperiod < 0) {
        i = 0;
        do {
            int rec;
            int slot;
            int off;

            rec = i * 22;
            slot = gmrosterslot[rec];
            off = slot * 39;
            if (hmroster[off + team * 0x444] == 3) {
                if (gmroster[rec] != 'G') skaters++;
                else goals++;
            }
            i++;
        } while (i < 28);
        if (skaters != 0x12 || goals != 2) {
            char *pl;

            if (skaters < 0x12) {
                if (0x12 - skaters == 1) pl = (char *)unk_C3283;
                else pl = (char *)str_S7;
                sprintf((char *)buf + 0x1C, (char *)fmt, buf + 0x78, 0x12 - skaters, buf + 0x70, pl);
                *(int *)(buf + 0x54 + lines * 4) = (int)(buf + 0x1C);
                lines++;
            } else if (skaters > 0x12) {
                if (skaters - 0x12 == 1) pl = (char *)unk_C3283;
                else pl = (char *)str_S7;
                sprintf((char *)buf + 0x1C, (char *)fmt, buf + 0x60, skaters - 0x12, buf + 0x70, pl);
                *(int *)(buf + 0x54 + lines * 4) = (int)(buf + 0x1C);
                lines++;
            }
            if (goals < 2) {
                if (2 - goals == 1) pl = (char *)unk_C3283;
                else pl = (char *)str_S7;
                sprintf((char *)buf, (char *)fmt, buf + 0x78, 2 - goals, buf + 0x68, pl);
                *(int *)(buf + 0x54 + lines * 4) = (int)buf;
                lines++;
            } else if (goals > 2) {
                if (goals - 2 == 1) pl = (char *)unk_C3283;
                else pl = (char *)str_S7;
                sprintf((char *)buf, (char *)fmt, buf + 0x60, goals - 2, buf + 0x68, pl);
                *(int *)(buf + 0x54 + lines * 4) = (int)buf;
                lines++;
            }
            MessageBox(-1, -1, (char *)(buf + 0x54), lines, 0, 0, x, y, -1);
            return 1;
        }
    }
    return 0;
}
