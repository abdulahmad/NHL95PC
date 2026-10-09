/* Engine input: line choice (93G getlchoice). */
#include "nhl95.h"

/* getlchoice (50908) - regd0 = line choice for p's team from lchoicetab: the request in regd0 (+20h when the strengths
   differ, +40h when p's team is short-handed) plus 4 * the current line tmline (also in regd1). */
void getlchoice(Player *p)
{
    Team *tm;
    Team *op;
    short d;

    tm = p->tmptr;
    op = p->optmptr;
    d = op->tmap - tm->tmap;
    if (d) {
        regd0.w += 0x20;
        if (d > 0) regd0.w += 0x20;
    }
    regd1.w = tm->tmline;
    regd0.w += tm->tmline * 4;
    regd0.w = lchoicetab[regd0.w];
}
