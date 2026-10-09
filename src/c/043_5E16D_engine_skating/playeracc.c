/* Skating: player acceleration (93G logic93_5 playeracc). */
#include "nhl95.h"

/* playeracc (5EDAD) - accelerate player p in direction dir (93G logic93_5 playeracc, d2 = direction of acc).
   The dirtab x/y step times (legstr+30h)/64 (PC); no push into a wall (Wallsin / Wallcos); accel factor
   32 - weight/8 + legstr (goalie: + legstr + 14h, 93G legstr + 8) into regd2; new velocity (regd0, regd1) =
   step * factor / 32 + old. Max speed check: speed squared (regd3) against MaxSpeed[legspd * energy >> 12]
   (referee: fixed index 0Fh, or 0Ch when the clock is stopped and he is 74h+ from centre; pflags2 bit 6 cuts it to
   1/8); the velocity is kept only under it. Then the energy drain when fatigue (line changes) is on and the
   clock runs (93G .sube, getpde / setpde inline): 1 in 128 calls the energy drops by 28h (93G $21);
   at C00h+ the endurance is added back, at most 1000h. */
void playeracc(Player *p, short dir)
{
    short yacc, xacc;

    dir += dir;
    xacc = dirtab[dir];                             /* x inc */
    yacc = dirtab_y[dir];                           /* y inc */
    xacc = xacc * (p->legstr + 0x30) / 64;
    yacc = yacc * (p->legstr + 0x30) / 64;
    if (p->Wallsin != 0 && (xacc ^ p->Wallsin) < 0) xacc = 0;     /* wallsin: don't push the wall */
    if (p->Wallcos != 0 && (yacc ^ p->Wallcos) >= 0) yacc = 0;
    regd2.w = 0x20 - (short)(p->weight >> 3) + p->legstr;
    if (p->position == 0) regd2.w += (unsigned short)p->legstr + 0x14;  /* goalie adds legstr again plus 14h (16-bit add) */
    regd0.l = xacc * regd2.w >> 5;
    regd1.l = regd2.w * yacc >> 5;
    regd0.w += p->Xvel;
    regd1.w += p->Yvel;
    regd3.l = regd0.w * regd0.w + regd1.w * regd1.w;
    if (p->SCnum == SCref) {                                    /* referee: fixed max speed index */
        if (!(gmode & gmclock) || ABS(HIWORD(p->Ypos)) < 0x74) regd2.l = 0x0F;
        else regd2.l = 0x0C;
    } else {
        regd2.l = (unsigned long)(p->tmptr->tmpde[p->pnum] * p->legspd) >> 12;   /* energy level (93G getpde) */
    }
    regd2.l = MaxSpeed[regd2.w];
    if (p->pflags2 & 0x40) regd2.l >>= 3;                       /* pflags2 bit 6 cuts max speed to 1/8 */
    if (regd3.ul <= regd2.ul) {                                 /* max speed check */
        p->Xvel = regd0.w;
        p->Yvel = regd1.w;
    }
    /* .sube */
    if (p->SCnum == SCref || !gameopts.linechanges || (gmode & gmclock) || p->position == 0) return;
    regd0.w = randomd0(0x80);                                   /* 1 in 128 ticks (93G HVcount & $7F) */
    if (regd0.w != 0) return;
    regd0.w = p->tmptr->tmpde[p->pnum] - 0x28;                  /* subi.w #$21 (PC 28h) */
    if (regd0.w < 0xC00) {
        p->tmptr->tmpde[p->pnum] = regd0.w < 0 ? 0 : regd0.w;
        return;
    }
    regd0.w += p->endurance;
    if (regd0.w > 0x1000) regd0.w = 0x1000;                     /* max 1000h */
    p->tmptr->tmpde[p->pnum] = regd0.w < 0 ? 0 : regd0.w;
}
