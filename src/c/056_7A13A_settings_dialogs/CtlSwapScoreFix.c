/* Settings dialogs: goalie restore. */
#include "nhl95.h"

/* CtlSwapScoreFix (7CBB3) - put side's pulled goalie back (tmgoalie negative with a goalie choice in bits 4-7): keep the
   choice (low nibble); not while side trails by 1-2 in the third period with more than 60 seconds left, nor
   while the other team has the puck in a stoppage. Then the goalie is back (high byte 0), the menu shows him
   checked (off_CD498) and "pulled" unchecked (off_CD4A0), setpersonel. */
void CtlSwapScoreFix(int side)
{
    Team *t;
    int d;
    unsigned char f;

    t = &(&hmtmstruct)[side];
    if (t->tmgoalie >= 0) return;
    if (!(*(unsigned char *)&t->tmgoalie & 0xF0)) return;
    *(unsigned char *)&t->tmgoalie &= 0xF;
    d = (&hmtmstruct)[side == 0].tmscore - t->tmscore;
    if (d > 0 && d <= 2 && gsp == 2 && gameclock <= 0x3C) return;
    f = gmode;
    if (!(f & 1)) {
        signed char c = *puckc;
        if (c >= 0 && ((c < 6) ^ side) && (f & 8)) return;
    }
    ((unsigned char *)&t->tmgoalie)[1] = 0;
    *(unsigned char *)((int (*)[3])off_CD4A0)[side][0] = 2;
    *(unsigned char *)((int (*)[3])off_CD498)[side][(short)(t->tmgoalie & 0xF)] = 1;
    setpersonel(t);
}
