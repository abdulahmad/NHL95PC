/* Create player: line errors. */
#include "nhl95.h"

typedef struct { char c[39]; } Msg39;
typedef struct { char c[42]; } Msg42;
typedef struct { char c[47]; } Msg47;
typedef struct { char c[38]; } Msg38;
typedef struct { char c[46]; } Msg46;
typedef struct { char c[33]; } Msg33;
typedef struct { char c[34]; } Msg34;

/* CheckTeamLines: for each of 10 line-error bits in flags, and a set selection (*sel), draw the
 error screen and one centered line: the matching message, then the team name at record +1Ah.
 *line is the row; it steps by one and the text sits at row*13+1Fh. At row 1Eh, ShowDBError
 can stop the list (its result is returned). Starts at -2. 1 or -1 ends the walk. */
int CheckTeamLines(int team, int *line, int *sel, int *first, int flags, int x, int y)
{
    char msg[0x54];
    int ret;
    int i;
    unsigned char *rec;

    ret = -2;
    rec = TeamRecPtr(team);
    for (i = 0; i < 10 && ret != 1 && ret != -1; i++) {
        int bit;

        ret = -2;
        if (*sel) DrawDBErrorsScreen(sel, line, first);
        bit = flags & dword_D0CDA[i];
        if (bit) {
            switch (bit) {
            case 1:
                *(Msg39 *)msg = *(Msg39 *)str_TheForwardLinesAre;
                break;
            case 2:
                *(Msg39 *)msg = *(Msg39 *)str_TheDefenceLinesAre;
                break;
            case 4:
                *(Msg42 *)msg = *(Msg42 *)str_ThePowerPlayLines;
                break;
            case 8:
                *(Msg47 *)msg = *(Msg47 *)str_ThePenaltyKillingLines;
                break;
            case 0x10:
                *(Msg38 *)msg = *(Msg38 *)str_TheGoalieLinesAre;
                break;
            case 0x20:
                *(Msg46 *)msg = *(Msg46 *)str_TheExtraAttackerLines;
                break;
            case 0x40:
                *(Msg33 *)msg = *(Msg33 *)str_NotEnoughPlayers;
                break;
            case 0x80:
                *(Msg33 *)msg = *(Msg33 *)str_NotEnoughGoalies;
                break;
            case 0x100:
                *(Msg34 *)msg = *(Msg34 *)str_NotEnoughForwards;
                break;
            case 0x200:
                *(Msg33 *)msg = *(Msg33 *)str_NotEnoughDefence;
                break;
            }
            strcat(msg, (char *)rec + 0x1A);
            PrintCenteredText(*line * 13 + 0x1F, msg);
            if (++*line >= 0x1E) ret = ShowDBError(sel, line, x, y);
        }
    }
    return ret;
}
