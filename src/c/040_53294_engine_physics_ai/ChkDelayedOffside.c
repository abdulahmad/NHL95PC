/* Engine physics / AI: delayed offside (PC only). */
#include "nhl95.h"

/* ChkDelayedOffside (541CA) - PC only (called from checkpuckcoll before puckstick / puckgoalie): with the
   offsides option on, no penalty shot and gmode bit 4 clear, the puck inside the goal lines (|y| <= E8h)
   heading for a crossing near the middle (|puckcross x| <= 2Ch at the end p faces, pflags bit 7) while the
   other team is flagged offside (tmflags bit 4): when p and the last player to touch the puck (lasttouch) are
   on different teams, AddPenalty2 8 (offside) on SortCords[lasttouch] and return 1; else 0. */
int ChkDelayedOffside(Player *p)
{
    int y;
    int x;

    if ((gameopts.offsides) == 0) return 0;
    if (gmode & 0x10) return 0;
    if (penshotlive != 0) return 0;
    if (penshotstart != 0) return 0;
    y = *pucky;
    if (y < 0) y = -y;
    if (y > 0xE8) return 0;
    x = puckcross[(p->pflags & 0x80) ? 2 : 0];
    if (x < 0) x = -x;
    if (x > 0x2C) return 0;
    if ((p->optmptr->tmflags & 0x10) == 0) return 0;
    if ((p->SCnum < 6) == (lasttouch < 6)) return 0;
    AddPenalty2(&SortCords[lasttouch], 8);
    return 1;
}
