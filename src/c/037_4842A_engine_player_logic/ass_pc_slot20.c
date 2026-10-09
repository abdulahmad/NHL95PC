/* Engine player logic: PC assignment slot 20h (skate a path). */
#include "nhl95.h"

/* path points: 2 sides x 4 points of x, y words */
typedef struct PathPt {
    short x, y;
} PathPt;
#define PATHX(s, i) (((PathPt (*)[4])word_CC9EA)[s][i].x)
#define PATHY(s, i) (((PathPt (*)[4])word_CC9EC)[s][i].x)  /* the y words, addressed from CC9ECh */

/* ass_pc_slot20 (49460) - PC assignment slot 20h: skate a 4-point path (word_CC9EA / word_CC9EC x / y pairs, one
   set per pflags bit 6 side). Not while flag 20h. A new assignment (bit 1) starts at point 0 (temp5), temp2 = 8,
   and picks the stop point temp1: a random 0-7 when on the ice (position) on side 0 with the home team ahead,
   else -1 (never). Within 30 of the current point (temp3 / temp4; squared distance < 384h) go on to the next:
   after the last leave the assignment (assexit), at the stop point set flag 20h and SPA 731h. Else steer to the
   point (SteerToTarget). */
void ass_pc_slot20(Player *p)
{
    short side;
    short n;

    if (p->pflags & 0x20) return;
    if (p->pflags & 2) {
        p->pflags &= 0xFD;
        p->temp5 = 0;
        p->temp2 = 8;
        side = (p->pflags & 0x40) != 0;
        if (p->position && !side && hmscore[0] > awscore) p->temp1 = randomd0(8);
        else p->temp1 = -1;
        p->temp3 = PATHX(side, p->temp5);
        p->temp4 = PATHY(side, p->temp5);
    }
    if (((p->Xpos >> 16) - p->temp3) * ((p->Xpos >> 16) - p->temp3)
        + ((p->Ypos >> 16) - p->temp4) * ((p->Ypos >> 16) - p->temp4) < 0x384) {
        n = ++p->temp5;
        if (n > 3) {
            assexit(p);
            return;
        }
        side = (p->pflags & 0x40) != 0;
        p->temp3 = PATHX(side, p->temp5);
        p->temp4 = PATHY(side, p->temp5);
        if (p->temp1 == p->temp5) {
            p->pflags |= 0x20;
            SetSPA(p, 0x731);
            return;
        }
    }
    regd0.w = p->temp3;
    regd1.w = p->temp4;
    SteerToTarget(p);
}
