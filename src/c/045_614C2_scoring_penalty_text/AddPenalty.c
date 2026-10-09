/* Scoring / penalties: call a penalty (93G AddPenalty). */
#include "nhl95.h"

/* AddPenalty (62CF9) - 93G AddPenalty: call penalty pen on player p (AddPenalty2) unless the clock is stopped,
   p is SCnum 10h or a penalty shot is on. Penalty 6 always goes through; 8 (offside) only with the offsides
   option, 1Dh (two-line pass) only with that option; the others need the penalties option (gameopts bit 0),
   fewer than 8 players in p's team's box (PBnum) and CanRemovePlayer. */
void AddPenalty(Player *p, short pen)
{
    if (gmode & 1) return;
    if (p->SCnum == 0x10) return;
    if (penshotlive != 0) return;
    if (pen != 6) {
        if (pen == 8) {
            if (gameopts.offsides == 0) return;
        } else if (pen == 0x1D) {
            if (gameopts.twolinepass == 0) return;
        } else {
            if (gameopts.optbit0 == 0) return;
            if (((signed char *)&PBnum)[(p->pflags & 0x40) != 0] >= 8) return;
            if (CanRemovePlayer(p) == 0) return;
        }
    }
    AddPenalty2(p, pen);
}
