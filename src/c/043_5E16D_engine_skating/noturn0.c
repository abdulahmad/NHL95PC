/* Engine: skating. */
#include "nhl95.h"

/* noturn0 (5F98A) - 93G noturn0: player p keeps skating (regd4 = 2, or 6 and chg flipped by 4 when skating backwards,
   pfrev). With a direction change chg: if moving and the velocity direction (vtoa, regd0) is less than 4 steps
   past facedir + regd4, stop (dostop); otherwise turn one step (down with attribute bit 3, else up) and glide
   (SPAglideback backwards; the referee his glide, signalling variant as in dostop). Without one: skate (backwards
   SPAskateback, the referee his skate, the puck carrier SPAskatewp, pflags2 bit 6 8D3h, else SPAskate) unless an
   animation is in progress (pf2aip), then accelerate in direction dir (flipped by 4 backwards; playeracc). */
void noturn0(Player *p, short chg, short dir)
{
    short spa;
    short a;

    regd4.w = 2;                                    /* moveq #2,d4 */
    if (p->pflags & pfrev) {
        chg ^= 4;
        regd4.w = 6;                                /* addq #4,d4 */
    }
    if (chg) {
        a = vtoa(p->Xvel, p->Yvel);                 /* vtoa(Xvel,Yvel) */
        regd0.w = a;
        if (!(a & 8)) {                             /* not moving */
            a = (a - p->facedir + regd4.w) & 7;
            regd0.w = a;
            if (a < 4) {
                dostop(p);
                return;
            }
        }
        if (p->attribute & 8) p->facedir--;
        else p->facedir++;
        a = p->facedir & 7;
        p->facedir = a;
        if (p->pflags & pfrev) spa = SPAglideback;
        else if (p->SCnum == SCref) {
            if (refsignal != 0 || ((gmode & gmclock) == 0 && ((gmode2 & 0x80) || (gmode & 8))))
                spa = SPArefglidesig;
            else spa = SPArefglide;
        } else spa = SPAglide;
        SetSPA(p, spa);
        return;
    }
    if (!(p->pflags & pfrev)) {
        if (p->SCnum == SCref) {
            if (refsignal != 0 || ((gmode & gmclock) == 0 && ((gmode2 & 0x80) || (gmode & 8))))
                spa = SPArefskatesig;               /* referee skate, signalling */
            else spa = SPArefskate;
        } else if (*puckc == p->SCnum) spa = SPAskatewp;
        else if (p->pflags2 & 0x40) spa = 0x8D3;    /* 93G $13A0 (pflags2 bit 6) */
        else spa = SPAskate;
    } else spa = SPAskateback;
    if (!(p->pflags2 & pf2aip)) SetSPA(p, spa);     /* pf2aip */
    if (p->pflags & pfrev) dir ^= 4;
    playeracc(p, dir);
}
