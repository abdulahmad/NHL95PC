/* Engine input: line change found (93G lcfound). */
#include "nhl95.h"

/* lcfound (50975) - 93G lcfound: the line change choice regd2 was picked for p's team. getlchoice turns it into a
   line in regd0 (negative: none). Marks the change (pflags2 bit 3 off, pflags bit 3, tmflags bit 1 off); a new
   line becomes tmline (regular lines also step tmlcnt mod 3), is drawn on the panel and set up (setpersonel). */
void lcfound(Player *p)
{
    Team *tm;

    tm = p->tmptr;
    regd0.w = regd2.w;
    getlchoice(p);
    if (regd0.w < 0) return;
    p->pflags2 &= ~8;
    p->pflags |= 8;
    tm->tmflags &= ~2;
    if (regd0.w != tm->tmline) {
        tm->tmline = regd0.w;
        if (regd0.w < 4) {
            if (++tm->tmlcnt >= 3) tm->tmlcnt -= 3;
        }
        DrawPanelLine((short)((p->pflags & 0x40) != 0), regd0.w);
        setpersonel(tm);
    }
}
