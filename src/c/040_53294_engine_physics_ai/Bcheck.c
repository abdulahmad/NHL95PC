/* Engine physics / AI: body checks. */
#include "nhl95.h"

/* Bcheck (56A54) - body check by a on b (a not flag 20h, not the puck (SCnum 10h), a skater, not pflags2 bit 0): with
   option bit 0 off a b holding the puck (pflags bit 3) stands it 12 times in randomd0(checking + 16 - legstr);
   a hit from b's front (vtoa(a - b) within one step of b's facing + 1) knocks b down (FallDown). If a was taking a
   quick shot it is a penalty shot for a (penshotplayer, penshotctl by controller), else checkagr may call a
   penalty on b (10h). Sets collflag. */
void Bcheck(Player *a, Player *b)
{
    int f;

    if (a->pflags & 0x20) return;
    if (a->SCnum == 0x10) return;
    if (!a->position) return;
    if (a->pflags2 & 1) return;
    if (!gameopts.optbit0 && (b->pflags & 8)) {
        if (randomd0(b->checking + 0x10 - a->legstr) < 12) return;
    }
    f = b->facedir;
    if (((vtoa((short)(HIWORD(a->Xpos) - HIWORD(b->Xpos)), (short)(HIWORD(a->Ypos) - HIWORD(b->Ypos))) - f + 1) & 7) > 2) return;
    FallDown(b, a);
    if (QuickShotChk(a)) {
        if (penshotplayer < 0) {
            penshotplayer = a->SCnum;
            if (c1playernum[0] == penshotplayer) penshotctl = 1;
            else if (c1playernum[0] == penshotplayer) penshotctl = 2;  /* sic: the asm tests controller 1 again */
            else penshotctl = -1;
            AddPenalty(b, 0x1A);
        }
    } else if (checkagr(b) <= 4) {
        AddPenalty(b, 0x10);
    }
    collflag = 0xFF;
}
