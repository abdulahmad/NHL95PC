/* Line editor: dressed roster is complete. */
#define CheckRosterComplete CheckRosterComplete_decl
#define str_RosterIncomplete str_RosterIncomplete_fn
#define str_Scratch str_Scratch_fn
#define str_Dress str_Dress_fn
#define str_Player str_Player_fn
#define str_GoalieW str_GoalieW_fn
#include "nhl95.h"
#undef CheckRosterComplete
#undef str_RosterIncomplete
#undef str_Scratch
#undef str_Dress
#undef str_Player
#undef str_GoalieW

extern unsigned char str_RosterIncomplete[];
extern unsigned char str_Scratch[];
extern unsigned char str_Dress[];
extern unsigned char str_Player[];
extern unsigned char str_GoalieW[];

typedef struct { char c[27]; } T27;
typedef struct { char c[8]; } T8;
typedef struct { char c[6]; } T6;
typedef struct { char c[7]; } T7;

/* CheckRosterComplete: team is the roster index. Count dressed skaters and goalies (status 3, a G in the
 record is a goalie). 18 and 2 is complete. Anything else formats "Dress/Scratch  n  Player/Goalie." and
 asks MessageBox, using x and y as the last two arguments. 1 means the roster was short or long. */
int CheckRosterComplete(int x, int y, int team)
{
    unsigned char buf[0x7C];
    int skaters;
    int i;
    char *fmt;

    buf[0x78] = team;
    skaters = 0;
    *(int *)(buf + 0x74) = skaters;
    *(T27 *)(buf + 0x38) = *(T27 *)str_RosterIncomplete;
    *(T8 *)(buf + 0x54) = *(T8 *)str_Scratch;
    *(T6 *)(buf + 0x6C) = *(T6 *)str_Dress;
    *(T7 *)(buf + 0x64) = *(T7 *)str_Player;
    *(T7 *)(buf + 0x5C) = *(T7 *)str_GoalieW;
    fmt = (char *)str_S2dSS;
    i = 0;
    do {
        int off;

        off = (unsigned char)buf[0x78] * 756 + i * 27;
        if (rosterstat[off] == 3) {
            if (rosterlist[off] != 'G') skaters++;
            else (*(int *)(buf + 0x74))++;
        }
        i++;
    } while (i < 28);
    if (skaters != 0x12 || *(int *)(buf + 0x74) != 2) {
        char *pl;

        if (skaters < 0x12) {
            if (0x12 - skaters == 1) pl = (char *)unk_C311D;
            else pl = (char *)str_S6;
            sprintf((char *)buf, fmt, buf + 0x6C, 0x12 - skaters, buf + 0x64, pl);
        } else if (skaters > 0x12) {
            if (skaters - 0x12 == 1) pl = (char *)unk_C311D;
            else pl = (char *)str_S6;
            sprintf((char *)buf, fmt, buf + 0x54, skaters - 0x12, buf + 0x64, pl);
        }
        if (*(int *)(buf + 0x74) < 2) {
            if (2 - *(int *)(buf + 0x74) == 1) pl = (char *)unk_C311D;
            else pl = (char *)str_S6;
            sprintf((char *)buf + 0x1C, fmt, buf + 0x6C, 2 - *(int *)(buf + 0x74), buf + 0x5C, pl);
        } else if (*(int *)(buf + 0x74) > 2) {
            if (*(int *)(buf + 0x74) - 2 == 1) pl = (char *)unk_C311D;
            else pl = (char *)str_S6;
            sprintf((char *)buf + 0x1C, fmt, buf + 0x54, *(int *)(buf + 0x74) - 2, buf + 0x5C, pl);
        }
        if (skaters != 0x12 && *(int *)(buf + 0x74) != 2) {
            msglines[0] = (int)(buf + 0x38);
            msglines[1] = (int)buf;
            msglines[2] = (int)(buf + 0x1C);
            MessageBox(-1, -1, (char *)msglines, 3, 0, 0, x, y, -1);
        } else if (skaters != 0x12) {
            msglines[0] = (int)(buf + 0x38);
            msglines[1] = (int)buf;
            MessageBox(-1, -1, (char *)msglines, 2, 0, 0, x, y, -1);
        } else {
            msglines[0] = (int)(buf + 0x38);
            msglines[1] = (int)(buf + 0x1C);
            MessageBox(-1, -1, (char *)msglines, 2, 0, 0, x, y, -1);
        }
        return 1;
    }
    return 0;
}
