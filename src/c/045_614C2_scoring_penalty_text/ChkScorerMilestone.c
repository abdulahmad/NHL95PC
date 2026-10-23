/* Scoring penalty text: scorer milestones. */
#include "nhl95.h"

/* The exit owner is compilation context for ChkScorerMilestone's shared tail (fileio_popebpx).
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

/* per player stat rows, 16 bytes, 25 to a team: game goals / assists (shorts at DB088 / DB08A) and the season
   (DEB74 career goals, DEB78 career points, DEB7C season goals, DEB80 season points; ints) */
#define REC(a, t, p) (((int (*)[25][4])(a))[t][p][0])
#define GOALS(t, p) (((short (*)[25][8])dword_DB088)[t][p][0])
#define ASSISTS(t, p) (((short (*)[25][8])word_DB08A)[t][p][0])

/* DRAFT: same size, all but 8 instructions (two t * 400 / p * 16 address pairs use the other two registers);
   see docs/UNSURE.md. */
/* ChkScorerMilestone (62807, PC only): after a goal, look for a milestone of the scoring team (the puck's half
   against gmdir) unless both its E024C flags are set. The scorer (low byte of the team's goal record at DF644):
   a hat trick (1); with gamemode, in full-length games (gameopts.fullot) a first goal (6), a 50-goal season mark
   (2), a 100-point season mark (4), a 100-goal career mark (3) or a 100-point career mark (5), else a 10-goal
   (7) or 20-point (8) mark. Then the first and second assists (DF646 / DF648, -1 for none) for the point marks
   (4 / 5, or 8). A milestone is queued as a deferred MenuCallbackTrue2(team, player, kind, count), with
   deferpending set and ovltimer = -1. */
void ChkScorerMilestone(void)
{
    int sum;
    unsigned t;
    int what;
    int p;
    int g;
    int pts;

    t = (*pucky < 0) ^ ((gmode & gmdir) != 0);
    if (((unsigned char *)byte_E024C)[t * 2] && byte_E024D[t * 2]) return;
    what = 0;
    p = (short)(word_DF644[t * 128] & 0xFF);
    if (p < 0x19) {
        g = GOALS(t, p);
        pts = ASSISTS(t, p) + g;
        if (g == 3) {
            what = 1;
            pts = g;
        } else if (gamemode) {
            if (gameopts.fullot) {
                sum = REC(dword_DEB7C, t, p) + REC(dword_DEB74, t, p);
                if (sum + g == 1) {
                    what = 6;
                    pts = sum + g;
                } else if ((g += REC(dword_DEB7C, t, p)) >= 50 && g % 50 == 0) {
                    what = 2;
                    pts = g;
                } else if ((pts += REC(dword_DEB80, t, p)) >= 100 && pts % 100 == 0) {
                    what = 4;
                } else if ((g += REC(dword_DEB74, t, p)) >= 100 && g % 100 == 0) {
                    what = 3;
                    pts = g;
                } else if ((pts += REC(dword_DEB78, t, p)) >= 100 && pts % 100 == 0) {
                    what = 5;
                }
            } else if ((g += REC(dword_DEB7C, t, p)) >= 10 && g % 10 == 0) {
                what = 7;
                pts = g;
            } else if ((pts += REC(dword_DEB80, t, p)) >= 20 && pts % 20 == 0) {
                what = 8;
            }
        }
    }
    if (gamemode && !what && (p = *(short *)((char *)dword_DF646 + (t << 8))) >= 0 && p < 0x19) {
        pts = ASSISTS(t, p) + GOALS(t, p);
        if (gameopts.fullot) {
            if ((pts += REC(dword_DEB80, t, p)) >= 100 && pts % 100 == 0) what = 4;
            else if ((pts += REC(dword_DEB78, t, p)) >= 100 && pts % 100 == 0) what = 5;
        } else if ((pts += REC(dword_DEB80, t, p)) >= 20 && pts % 20 == 0) {
            what = 8;
        }
        if (!what && (p = *(short *)((char *)dword_DF648 + (t << 8))) >= 0 && p < 0x19) {
            g = ASSISTS(t, p);
            pts = GOALS(t, p) + g;
            if (gameopts.fullot) {
                if ((pts += REC(dword_DEB80, t, p)) >= 100 && pts % 100 == 0) what = 4;
                else if ((pts += REC(dword_DEB78, t, p)) >= 100 && pts % 100 == 0) what = 5;
            } else if ((pts += REC(dword_DEB80, t, p)) >= 20 && pts % 20 == 0) {
                what = 8;
            }
        }
    }
    if (what) {
        QueueDeferredCall((void *)MenuCallbackTrue2, t, p, what, pts, 0, 0, 0);
        deferpending = 1;
        ovltimer = -1;
    }
}
