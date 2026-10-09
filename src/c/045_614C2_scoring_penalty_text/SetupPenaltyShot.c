/* Scoring / penalties: penalty shot. */
#include "nhl95.h"

/* SetupPenaltyShot (63F72) - start a penalty shot: stop the puck at centre (position, velocity, height 0) and give it its
   assignment 18h; the shooter (penshotplayer) loses pflags2 bits 2/5 and pflags bit 2 and gets assignment 2Eh
   eight times; a human controller of the other side (penshotteam) gives up his player (restorepl); the shooter's
   team words +30h/+32h/+34h become -1; the shooter gets the puck, the crowd gets louder by 64h, and the penalty
   shot is live with a 3E8h timer; clear the penalty buffer. */
void SetupPenaltyShot(void)
{
    Player *p;
    short *t;

    *puckx = *pucky = *(short *)puckz = *puckvx = *puckvy = *(short *)puckvz = 0;
    assreplace((Player *)puckstruct, 0x18);
    p = &SortCords[penshotplayer];
    p->pflags2 &= 0xDB;
    p->pflags &= 0xFB;
    assinsert(p, 0x2E);
    assinsert(p, 0x2E);
    assinsert(p, 0x2E);
    assinsert(p, 0x2E);
    assinsert(p, 0x2E);
    assinsert(p, 0x2E);
    assinsert(p, 0x2E);
    assinsert(p, 0x2E);
    if ((*(int *)((char *)&cont1team - 2) >> 16) == (penshotteam == 0) + 1
        && (*(int *)((char *)c1playernum - 2) >> 16) != -1)
        c1playernum[0] = restorepl(-1, *(int *)((char *)c1playernum - 2) >> 16);
    if ((*(int *)((char *)&cont2team - 2) >> 16) == (penshotteam == 0) + 1
        && (*(int *)((char *)c2playernum - 2) >> 16) != -1)
        c2playernum[0] = restorepl(-1, *(int *)((char *)c2playernum - 2) >> 16);
    t = (short *)p->tmptr;
    t[0x18] = t[0x19] = t[0x1A] = -1;
    crowdlevel += 0x64;
    *puckc = penshotplayer;
    penshotlive = penshotstart = 1;
    penshottimer = 0x3E8;
    ClearPenaltyBuffer();
}
