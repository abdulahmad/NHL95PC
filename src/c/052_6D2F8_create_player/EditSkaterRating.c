/* Create player: editing a skater or goalie rating. */
#include "nhl95.h"

typedef struct { char c[0x14]; } Msg20;

/* DRAFT: both functions are the original size (777, 754) with every statement in place; EditSkaterRating owns
   the EditSkaterRating_tail return that EditGoalieRating jumps into. Every pushed displayed rating and the two
   unit updates go through the dead v (`v = (*p + 5) * 5`): the EXE computes each of them in v's register (ebx,
   the sum left in the load register), where a plain argument put the product in eax. Left: the min pointer is
   loaded into eax (EXE edx, after clearing eax), which lets the &byte_D0F94 / &byte_D0FE0 constant stay in edx
   for p, and the s.old and compare products take other registers (see docs/UNSURE.md). */
/* EditSkaterRating (6FC60, PC only): a click at *x / *y on the create-player screen's skater ratings (15 rows of
   0Dh pixels from y 12Ah, rows 8-14 in a second column 136h to the right; the value cell spans C8h-E4h). Row 0
   (shoots) asks left or right; another row asks for a new value (shown as (r + 5) * 5) between its minimum
   and maximum (unk_D0FA8 / unk_D0FBC, the range with its name from off_D0880). Lowering a rating gives the
   points back to *field, raising one takes them from it (or says there are not enough units); rows 3 and 0Dh
   are free. Result: 1 when a row was hit, else 0. */
int EditSkaterRating(int *x, int *y, int *field)
{
    struct {
        char range[0x34];
        char msg[0x34];
        char ans[0x20];
        unsigned char *base;
        int done;
        int colx;
        unsigned char *minp;
        int old;
        int rowy;
    } s;
    unsigned char *maxp;
    unsigned char *p;
    int v;
    int nv;
    int i;

    s.done = 0;
    s.colx = 0;
    s.rowy = 0x12A;
    for (i = 0; i < 0xF && !s.done; i++, s.rowy += 0xD) {
        if (i == 8) {
            s.colx = 0x136;
            s.rowy -= 0x68;
        }
        if (s.colx + 0xC8 <= *x && s.colx + 0xE4 > *x && *y >= s.rowy && s.rowy + 0xD > *y) {
            s.done = 1;
            s.base = &byte_D0F94;
            *(Msg20 *)s.msg = *(Msg20 *)str_EnterANewRating;
            msglines[0] = (int)s.msg;
            maxp = unk_D0FBC + i;
            sprintf(s.range, (char *)str_RatingRange, v = (*(s.minp = unk_D0FA8 + i) + 5) * 5, off_D0880[i], v = (*maxp + 5) * 5);
            msglines[1] = (int)s.range;
            p = &byte_D0F94 + i;
            if (i == 0) {
                AskLeftRight(p, (char *)str_ShootsLeftOrRight);
            } else {
                sprintf(s.ans, (char *)str_fmtpd, v = (*p + 5) * 5);
                s.old = (*p + 5) * 5;
                v = (unsigned char)InputDialog(msglines, 2, s.ans, 2, 0x1C, -1, v = (*s.minp + 5) * 5, v = (*maxp + 5) * 5, 0);
                if (v != 0xFF && v >= (*s.minp + 5) * 5 && v <= (*maxp + 5) * 5) {
                    nv = v / 5 - 5;
                    if (v < s.old) {
                        *p = nv;
                        if (i != 0 && i != 3 && i != 0xD) *field += s.old - (v = (*p + 5) * 5);
                    } else {
                        int d;

                        d = v - s.old;
                        if (i != 0 && i != 3 && i != 0xD) {
                            if (d <= *field) {
                                *p = nv;
                                *field -= (v = (*p + 5) * 5) - s.old;
                            } else {
                                msglines[0] = (int)str_NotEnoughRatingUnits;
                                MessageBox(-1, -1, (char *)msglines, 1, 0, 0, (int)x, (int)y, -1);
                            }
                        } else {
                            s.base[i] = v / 5 - 5;
                        }
                    }
                }
            }
        }
    }
    return s.done;
}

/* EditGoalieRating (6FF69, PC only; ends in EditSkaterRating_tail): EditSkaterRating for the create-player
   screen's goalie ratings: rows 6-14 in the second column (36h higher), the ranges in unk_D0FF0 / unk_D1000 with
   their names in off_D09DB, the values in byte_D0FE0; row 0 (glove hand) asks left or right; rows 0 and 8 are
   free. Result: 1 when a row was hit, else 0. */
int EditGoalieRating(int *x, int *y, int *field)
{
    struct {
        char range[0x34];
        char msg[0x34];
        char ans[0x20];
        unsigned char *base;
        int done;
        int colx;
        unsigned char *minp;
        int old;
        int rowy;
    } s;
    int i;
    unsigned char *maxp;
    unsigned char *p;
    int v;
    int nv;
    int d;

    s.done = 0;
    s.colx = 0;
    s.rowy = 0x12A;
    for (i = 0; i < 0xF && !s.done; i++, s.rowy += 0xD) {
        if (i == 6) {
            s.colx = 0x136;
            s.rowy -= 0x4E;
        }
        if (s.colx + 0xC8 <= *x && s.colx + 0xE4 > *x && *y >= s.rowy && s.rowy + 0xD > *y) {
            s.done = 1;
            s.base = &byte_D0FE0;
            *(Msg20 *)s.msg = *(Msg20 *)str_EnterANewRating;
            msglines[0] = (int)s.msg;
            maxp = unk_D1000 + i;
            sprintf(s.range, (char *)str_RatingRange, v = (*(s.minp = unk_D0FF0 + i) + 5) * 5, off_D09DB[i], v = (*maxp + 5) * 5);
            msglines[1] = (int)s.range;
            p = &byte_D0FE0 + i;
            if (i == 0) {
                AskLeftRight(p, (char *)str_GloveHandLeftOr);
            } else {
                sprintf(s.ans, (char *)str_fmtpd, v = (*p + 5) * 5);
                s.old = (*p + 5) * 5;
                v = (unsigned char)InputDialog(msglines, 2, s.ans, 2, 0x1C, -1, v = (*s.minp + 5) * 5, v = (*maxp + 5) * 5, 0);
                if (v != 0xFF && v >= (*s.minp + 5) * 5 && v <= (*maxp + 5) * 5) {
                    nv = v / 5 - 5;
                    if (v < s.old) {
                        *p = nv;
                        if (i != 0 && i != 8) *field += s.old - (v = (*p + 5) * 5);
                    } else {
                        d = v - s.old;
                        if (i != 0 && i != 8) {
                            if (d <= *field) {
                                *p = nv;
                                *field -= (v = (*p + 5) * 5) - s.old;
                            } else {
                                msglines[0] = (int)str_NotEnoughRatingUnits;
                                MessageBox(-1, -1, (char *)msglines, 1, 0, 0, (int)x, (int)y, -1);
                            }
                        } else {
                            s.base[i] = v / 5 - 5;
                        }
                    }
                }
            }
        }
    }
    return s.done;
}
