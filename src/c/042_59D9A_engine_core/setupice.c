/* Engine core: set up the rink for a period (93G/94G setup94 setupice, PC part). */
#include "nhl95.h"

/* setupice (5D7F7) - set up the rink for a period (93G/94G setup94 setupice; the PC keeps only the game state
   part, no tile loading): out of pause mode (sfpz), camera at 0, defaultsprites2; when the teams have changed
   ends (gmode gmdir) flip pfgoal for the 12 players; no controlled player yet (st c1playernum / c2playernum:
   the 68k high byte, +1 on the PC). */
void setupice(void)
{
    Player *p;
    short i;

    sflags &= ~sfpz;                            /* bclr #sfpz,sflags */
    camy = camx = 0;
    defaultsprites2();
    if (gmode & gmdir) {                        /* gmdir: flip pfgoal for the 12 players */
        for (p = SortCords, i = 0; i < 12; i++, p++)
            p->pflags ^= pfgoal;                /* bchg #pfgoal,pflags(a3) */
    }
    HIBYTE(c1playernum[0]) = -1;                /* no controlled player yet */
    HIBYTE(c2playernum[0]) = -1;
}
