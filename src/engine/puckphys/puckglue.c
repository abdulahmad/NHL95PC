/* Engine physics AI: a player takes the puck. */
#include "nhl95.h"

/* puckglue: (92 puckstick.glue): player p takes the puck. puckc gets his SCnum
 a live penalty shot ends when his team's tmpsplayer takes it. The other team's assist slots are cleared and
 its tmflags bit 3 set. After a faceoff (sflags3 bit 4) count a faceoff won (and one won in the attacking
 end), raise crowdlevel by 200 (max 1000) and the home crowd's CwdExciteLvl by 10; otherwise play sfx 9Bh
. Then the pass completion, clear the pass/shot dir modes (sflags bits 2-3); a goalie
 checks the shot stat and gets temp5 hold time (5 after SPA 181h, else 8Ch). Falls into setd0player:
 GiveControl(regd0). The attacking-end count is two increments (if / else if): one `||` test moved the
 registers of the crowdlevel clamp after it. */
void puckglue(Player *p)
{
    Team *tm;
    Team *op;

    regd0.w = p->SCnum;             /* move.w SCnum(a2),d0 */
    {
        signed char c;

        c = *(signed char *)&regd0;
        *puckc = c;                 /* move.w d0,(puckc).w */
    }
    tm = p->tmptr;
    op = p->optmptr;
    if (penshotlive && p->pnum == tm->tmpsplayer) {
        EndPenaltyShot();
        onetimerflag = 0;
        shotongoal = 0;
    }
    op->tmast1 = -1;                /* st (a0): assist 1 */
    op->tmast2 = -1;                /* st (a0): assist 2 */
    op->tmflags |= 8;               /* bset #3,tmflags(a0) */
    if (sflags3 & 0x10) {           /* bclr #4,(sflags3).w */
        sflags3 &= ~0x10;
        if ((gmode & 0x10) == 0) {
            tm->tmfowon++;          /* addq.w #1,(a1): faceoff won */
            if (*pucky > 0x4E && (p->pflags & 0x80)) tm->tmfowonoz++; /* in the attacking end */
            else if (*pucky < -0x4E && (p->pflags & 0x80) == 0) tm->tmfowonoz++;
        }
        if (crowdlevel <= 1000) {   /* addi.w #,(crowdlevel).w */
            crowdlevel += 200;
            if (crowdlevel > 1000) crowdlevel = 1000;
        }
        if ((p->pflags & 0x40) == 0) CwdExciteLvl += 10; /* home team: addi.w #,(CwdExciteLvl).w */
    } else {
        sfx(0x9B);
    }
    PassCompleted(p);
    sflags &= 0xF3;                 /* bclr #sfspdir #sfssdir */
    if (p->position == 0) {         /* goalie */
        ChkShotStat();
        EndPenaltyShot();
        if (p->SPA == 0x181) p->temp5 = 5; /* SPAgdive */
        else p->temp5 = 0x8C;
    }
    GiveControl(regd0.w);           /* setd0player */
}
