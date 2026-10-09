/* dostop (5F745) - 93G logic93_5 dostop: player p stops. While |Xvel| or |Yvel| is above 1000h the stop
   animation starts: SPAstop (and pflags2 pf2aip) when skating forwards, SPAglide when skating backwards (pfrev).
   The referee (sort object 16) has his own stop / glide animations, in a signalling variant while refsignal
   counts down or, when the clock is stopped, if gmode2 bit 7 or gmode bit 3 is set. Then StopNA slows him by
   one step on each axis. */
#include "nhl95.h"

void dostop(Player *p)
{
    short spa;

    if (ABS(p->Xvel) > 0x1000 || ABS(p->Yvel) > 0x1000) {     /* .slim $1000 */
        if ((p->pflags & pfrev) == 0) {
            p->pflags2 |= pf2aip;
            if (p->SCnum == SCref) {
                if (refsignal != 0 || ((gmode & gmclock) == 0 && ((gmode2 & 0x80) || (gmode & 8))))
                    spa = SPArefstopsig;
                else spa = SPArefstop;
            } else spa = SPAstop;
        } else {
            if (p->SCnum == SCref) {
                if (refsignal != 0 || ((gmode & gmclock) == 0 && ((gmode2 & 0x80) || (gmode & 8))))
                    spa = SPArefglidesig;
                else spa = SPArefglide;
            } else spa = SPAglide;
        }
        SetSPA(p, spa);
    }
    StopNA(p);                  /* stop with no anim */
}
