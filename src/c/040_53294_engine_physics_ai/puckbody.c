/* Engine physics / AI: the puck hits a player's body (93G puckbody). */
#include "nhl95.h"

/* puckbody (56D06) - 93G puckbody: the puck pk hits player p (regd0 = distance^2 from checkpuckcoll). A low
   puck (Zpos <= 8) only counts when regd0 & 0Fh is 0 (radius^2 from center), outside the frames 430h-467h;
   inside them, frames up to 44Fh with bit 0 set let a high puck through. Otherwise: p touches the puck
   (unless he is SCnum 10h), the puck's Zvel is cleared, p's nopuck = 8, the puck bounces off along the
   distance (GetHot when the y difference is 0) and puckflip. A high puck (Zpos > 8) plays sfx A3h, or A2h and
   FallDown when its old speed^2 > 895440h (93 keeps the old speed) and Zpos > 0Ch; a player not yet in a
   locked anim (pflags bit 5, 93G pfalock) gets SPA 84Bh. A low puck plays sfx A3h (not during SPA 84Bh). */
void puckbody(Player *pk, Player *p)
{
    short xvel;                     /* the frame first, then the old Xvel (one register in the original) */
    short yvel;
    short snd;

    xvel = pk->frame;               /* first the frame */
    if (xvel >= 0x430 && xvel <= 0x467) {
        if (xvel <= 0x44F && (*(unsigned char *)&pk->frame & 1) && HIWORD(pk->Zpos) > 8) return;
    } else if (HIWORD(pk->Zpos) <= 8) {
        regd1.w = regd0.w & 0xF;    /* andi.w #$F,d1: radius^2 from center */
        if (regd1.w != 0) return;
    }
    if (p->SCnum != 0x10) a2touchpuck(p);
    pk->Zvel = 0;
    p->nopuck = 8;
    regd0.w = HIWORD(pk->Xpos) - HIWORD(p->Xpos);
    if ((regd1.w = HIWORD(pk->Ypos) - HIWORD(p->Ypos)) == 0) GetHot(p);
    xvel = pk->Xvel;                /* old Xvel */
    yvel = pk->Yvel;                /* old Yvel */
    HIBYTE(pk->Xvel) = *(signed char *)&regd0;
    HIBYTE(pk->Yvel) = *(signed char *)&regd1;
    puckflip(pk);
    if (HIWORD(pk->Zpos) <= 8) {    /* puck low: no effect on p */
        if (p->SPA != 0x84B) sfx(0xA3);
        return;
    }
    snd = 0xA3;
    if ((int)xvel * xvel + (int)yvel * yvel > 0x895440 && HIWORD(pk->Zpos) > 0xC) {
        snd = 0xA2;
        FallDown(pk, p);
    }
    if (p->SPA != 0x84B) sfx(snd);
    if ((p->pflags & 0x20) == 0 && p->SCnum != 0x10) {
        p->pflags |= 0x20;          /* bset #pfalock */
        SetSPA(p, 0x84B);
    }
}
