/* Engine input: line change by number (PC). */
#include "nhl95.h"

/* lcselect (50434) - PC line change request n for p's team (line changes on): with unequal strength only choices 0-1
   (+4 short-handed, +6 power play), else 0-3. Marks the change (pflags bit 3, tmflags bit 1 off); a new line
   becomes tmline (regular lines also step tmlcnt mod 3), is drawn on the panel and set up (setpersonel).
   Returns 1 when taken. */
int lcselect(Player *p, int n)
{
    Team *tm;
    Team *op;
    short d;

    if (!gameopts.linechanges) return 0;
    tm = p->tmptr;
    op = p->optmptr;
    d = op->tmap - tm->tmap;
    if (d && n > 1) return 0;
    if (!d && n > 3) return 0;
    if (d < 0) n += 4;
    else if (d > 0) n += 6;
    p->pflags2 &= ~8;
    p->pflags |= 8;
    tm->tmflags &= ~2;
    if (tm->tmline != n) {
        tm->tmline = n;
        if (n < 4) {
            if (++tm->tmlcnt >= 3) tm->tmlcnt -= 3;
        }
        DrawPanelLine((short)((p->pflags & 0x40) != 0), (short)n);
        setpersonel(tm);
    }
    return 1;
}
