/* Engine physics AI: collision with one neighbour. */
#define checkcheck checkcheck_decl
#include "nhl95.h"
#undef checkcheck

void checkcheck(Player *a, Player *b, short force);

/* checkcx (58DC7, Genesis checkcx): a possible collision between player p and the OOlist neighbour pl
 (SortCords number). x: p's coordinate on the sort axis (y with sflags bit 7); d: the gap on the other axis.
 Skips a neighbour that is out of play (pflags bit 2, pflags2 bit 5) or not a skater / the referee (SCnum
 above 0Bh but not 10h). With the gap within 10h on the axis, the distance squared (regd0) at most 100h and the
 two closing (regd1 = the gap times the relative velocity, >= 0, then / 16): against the other team or the
 referee, regd4 = the impact (regd1 >> 8, at least 5, also word_E9B28) is added to both players' impact and
 sets each one's impactp unless pflags2 bit 0; 14h or more with either of them carrying the puck plays the
 check (newcheck 0); then checkint and checkcheck. Unless collflag is set already, the two bounce off each other
 (the velocity exchange weighted by weight + 8Ch, word_E03B8 the cross term) and collflag is set. While the
 clock runs, team-mates that bump turn: when the hit comes from where a player is heading (temp3 / temp4, or
 standing still facing it), temp2 (low byte) = that direction + 2 and doplayeracc, for p unless pflags bit 3
 and then for pl the same way (its test reads p's velocity, as the EXE does). No result.
 DRAFT (10.0 GA, 1023 vs 1024): locals t, dvy, dx, dvx give the EXE's stack slots. Left: the puckc pointer
 in eax (EXE edx) and the bounce's sign-extended gaps: the EXE extends d into ebx and dx into edi, C extends
 d in place (edi) and dx into ebx; see docs/UNSURE.md. */
void checkcx(Player *p, short x, short d, short pl)
{
    int t;
    short dvy;
    short dx;
    short dvx;
    Player *o;

    o = &SortCords[pl];
    if (o->pflags & 4) return;
    if (o->pflags2 & 0x20) return;
    if (o->SCnum > 0xB && o->SCnum != 0x10) return;
    dx = HIWORD(o->Xpos);
    if (sflags & 0x80) dx = HIWORD(o->Ypos);
    dx -= x;
    if (ABS(dx) > 0x10) return;
    regd0.l = dx * dx + d * d;
    if (regd0.l > 0x100) return;
    dvx = p->Xvel - o->Xvel;
    dvy = p->Yvel - o->Yvel;
    dx = HIWORD(o->Xpos) - HIWORD(p->Xpos);
    d = HIWORD(o->Ypos) - HIWORD(p->Ypos);          /* d is reused for the y gap (di in the EXE) */
    regd1.l = d * dvy + dx * dvx;
    if (regd1.l < 0) return;
    regd1.l >>= 4;
    if (p->SCnum == 0x10 || o->SCnum == 0x10 || (((unsigned char)p->pflags ^ (unsigned char)o->pflags) & 0x40)) {
        regd4.w = regd1.w >> 8;
        if (regd4.w <= 5) regd4.l = 5;
        word_E9B28 = regd4.w;
        p->impact += regd4.w;
        o->impact += regd4.w;
        if (!(o->pflags2 & 1)) o->impactp = p->SCnum;
        if (!(p->pflags2 & 1)) p->impactp = o->SCnum;
        if (regd4.w >= 0x14 && (*puckc == p->SCnum || *puckc == o->SCnum)) newcheck(0);
        checkint(p, o);
        checkcheck(p, o, regd4.w);
    }
    regd4.w = regd1.w;
    if ((signed char)collflag < 0) return;
    regd0.l = d * dvx - dvy * dx;
    word_E03B8 = regd0.l >> 4;
    regd0.w = p->weight + 0x8C;
    regd1.w = o->weight + 0x8C;
    word_E03A0 = 0;
    regd1.w += regd0.w;
    regd0.l = regd0.w * regd4.w / regd1.w;
    regd1.l = regd0.l;
    t = (word_E03B8 * d + regd0.l * dx) >> 4;
    p->Xvel = o->Xvel + t;
    t = (regd0.l * d - word_E03B8 * dx) >> 4;
    p->Yvel = o->Yvel + t;
    o->Xvel += (short)(dx * regd1.l >> 4);
    o->Yvel += (short)(d * regd1.l >> 4);
    collflag = 0xFF;
    if (gmode & 1) return;
    if (((unsigned char)p->pflags ^ (unsigned char)o->pflags) & 0x40) return;
    dx = vtoa((short)(HIWORD(o->Xpos) - HIWORD(p->Xpos)), (short)(HIWORD(o->Ypos) - HIWORD(p->Ypos)));
    if (!(p->pflags & 8)) {
        if (vtoa((short)(p->temp3 - HIWORD(p->Xpos)), (short)(p->temp4 - HIWORD(p->Ypos))) == dx
            || (p->Xvel == 0 && p->Yvel == 0 && dx == p->facedir)) {
            *(signed char *)&p->temp2 = (dx + 2) & 7;
            doplayeracc(p, *(signed char *)&p->temp2);
        }
    }
    if (o->pflags & 8) return;
    dx = (dx + 4) & 7;
    if (vtoa((short)(o->temp3 - HIWORD(o->Xpos)), (short)(o->temp4 - HIWORD(o->Ypos))) == dx
        || (p->Xvel == 0 && p->Yvel == 0 && o->facedir == dx)) {
        *(signed char *)&o->temp2 = (dx + 2) & 7;
        doplayeracc(o, *(signed char *)&o->temp2);
    }
}
