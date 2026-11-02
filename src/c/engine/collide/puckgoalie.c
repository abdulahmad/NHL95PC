/* Engine physics AI: the puck hits a goalie. */
#include "nhl95.h"

/* puckgoalie (57096, Genesis puckgoalie): the puck pk hits goalie p (regd0 / regd1 = the gap from
 checkpuckcoll). Nothing during a stoppage (gmode bit 4) or while p's frame is 206h-215h with the puck at height
 5 or more. regd2 = the save side: 2 for a low puck (Zpos <= 8), plus 1 unless the direction of the hit relative
 to facedir has bit 2 (a random direction when it is a multiple of 4), doubled, flipped by 2 with attribute bit 3.
 A hard shot (|vx| + |vy| above 4268h, or above 1770h during SPA 119Dh-121Dh) from the other team's shooter
 (shotplayer) from more than 58h out at the right end, with gmode2 bit 4 and no pflags bit 6, is a big save
 (byte +63h). Then ChkShotStat, a2touchpuck and the save sounds (7Dh / A1h for a fast puck while the clock runs,
 9Dh or A3h). A loose puck slow enough for his shotspd (random below ((shotspd * 5 / 4 + 2) << 9) + 2000h) is
 caught (puck stopped and dropped to height 8, its velocity quartered, puckglue) unless pflags2 bit 2 is set;
 a carried puck is knocked loose (its carrier gets nopuck 14h, lastplayer, the pass / shot dir modes cleared).
 Otherwise the puck rebounds: height at most 0Ah, p's nopuck 0Ah and temp4 4, the velocity high bytes from half
 the gap (GetHot when the y gap is 0; the y gap at least 1 and against p's Yvel), puckflip. No result. */
void puckgoalie(Player *pk, Player *p)
{
    short save;
    short v;
    Player *o;
    signed char c;

    save = 0;
    if (gmode & 0x10) return;
    regd2.w = 0;
    if (HIWORD(pk->Zpos) <= 8) regd2.w = 2;
    regd0.w = (vtoa((short)-regd0.w, (short)-regd1.w) - p->facedir) & 7;
    if (!(regd0.w & 3)) regd0.w = randomd0(0x100);
    regd2.w += (short)(regd0.w & 4) >> 2 ^ 1;
    regd2.w *= 2;
    if (p->attribute & 8) regd2.w ^= 2;
    v = p->frame;
    if (v >= 0x206 && v < 0x216 && *(short *)puckz >= 5) return;
    p->pad_63[0] = 0;                               /* byte +63h: the big save flag */
    if (dword_E9A9E == 0 && !(p->pflags & 0x40) && (gmode2 & 0x10) && ((p->SCnum < 6) ^ (shotplayer < 6))
        && ABS(HIWORD(SortCords[shotplayer].Ypos)) > 0x58
        && ((HIWORD(SortCords[shotplayer].Ypos) > 0) ^ ((p->pflags & 0x80) != 0))) {
        v = ABS(*puckvy) + ABS(*puckvx);
        if (v > 0x4268 || (v > 0x1770 && p->SPA >= 0x119D && p->SPA <= 0x121D)) save = 1;
    }
    ChkShotStat();
    a2touchpuck(p);
    if (!(gmode & 1) && ABS(*puckvy) > 0xFA0) sfx(!(p->pflags & 0x40) ? 0x7D : 0xA1);
    sfx(ABS(*puckvy) > 0xBB8 ? 0x9D : 0xA3);
    c = *puckc;
    if (c < 0) {
        regd0.w = randomd0(((p->shotspd * 5) / 4 + 2) << 9) + 0x2000;
        if (ABS(*puckvx) <= regd0.w && ABS(*puckvy) <= regd0.w && !(p->pflags2 & 4)) {
            *(short *)puckvz = 0;
            if (*(short *)puckz > 8) *(short *)puckz = 8;
            *puckvx >>= 2;
            *puckvy >>= 2;
            puckglue(p);
            p->pad_63[0] = save;
            return;
        }
    } else {
        o = &SortCords[c];
        *puckc = -1;
        o->nopuck = 0x14;
        lastplayer = o->SCnum;
        sflags &= 0xF3;
    }
    *(short *)puckvz = 0;
    if (*(short *)puckz > 0xA) *(short *)puckz = 0xA;
    p->nopuck = 0xA;
    p->temp4 = 4;
    regd0.w = HIWORD(pk->Xpos) - HIWORD(p->Xpos);
    if ((regd1.w = HIWORD(pk->Ypos) - HIWORD(p->Ypos)) == 0) GetHot(p);
    if (regd1.w == 0) regd1.w++;
    if ((p->Yvel ^ regd1.w) >= 0) regd1.w = -regd1.w;
    HIBYTE(pk->Xvel) = *(signed char *)&regd0 >> 1;
    HIBYTE(pk->Yvel) = *(signed char *)&regd1 >> 1;
    puckflip(pk);
}
