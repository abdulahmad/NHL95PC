/* Scoring / penalty text: goalie notes. */
#include "nhl95.h"

/* QueueGoalieNote (62C37) - once per goalie (bit tmgoalie, +3 for the visitors, in dword_CC0AC; all 6 done = 3Fh): when
   object word_C90D8 is set, queue the deferred note for its side and roster number (deferpending). Returns 1
   when queued. */
int QueueGoalieNote(void)
{
    Player *p;
    int side;
    int bit;

    if (dword_CC0AC == 0x3F) return 0;
    if (word_C90D8 < 0) return 0;
    p = &SortCords[word_C90D8];
    side = (p->pflags & 0x40) != 0;
    bit = 1 << p->tmptr->tmgoalie;
    if (side) bit <<= 3;
    if (bit & dword_CC0AC) return 0;
    dword_CC0AC |= bit;
    QueueDeferredCall((void *)MenuCallbackTrue, side, p->pnum, 0, 0, 0, 0, 0);
    deferpending = 1;
    return 1;
}
