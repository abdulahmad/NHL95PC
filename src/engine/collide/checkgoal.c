/* Engine physics AI: puck against the goal frame. */
#define checkgoal checkgoal_decl
#include "nhl95.h"
#undef checkgoal

#define OLDY(p)  (*(int *)((char *)(p) + 0x78))    /* 93G OldYpos (after OldXpos) */
#define OLDZ(p)  (*(short *)((char *)(p) + 0x7E))  /* integer word of the 93G OldZpos (+7Ch) */

/* checkgoal (584AA; 93G hockey93 checkgoal, "look for coll with goal/net"): object p against goal g at offset
   x, y (the 68k d2 / d3). Over the goal (z above 0Dh) nothing; a player goes to checkgoalp. For the puck inside
   the goal box (half width wcradiusx + 10h in regd4, half depth wcradiusy + 2 in word_E03B8): coming down from
   above the frame (old z 0Dh+) it is put back on top and its z velocity bounced; else the carrier loses it
   (nopuck 8, pfgoal from the side of the ice he was on) and the crossing point of the box edge is worked out
   (regd0 the side, regd1 / regd3 the y / x travel). Through the mouth below the bar (z not 0Dh, inside half
   width - 1) is a Goal; off a post (PC: the shot flag gmode2 bit 4 is cleared instead of ChkShotStat) the
   crowd goes up by 500 (PC: up to 1200 and only while the clock runs), sfx ACh, random deflection velocities,
   puckflip, the penalty shot ends (EndPenaltyShot) and the one-timer / shot-on-goal flags clear. A side or back
   entry bounces off as a wall (wallcoll, dword_CCC2C = 1). No result.
   No gotos: the side entry is the fall-through after the nested tests, and each wall exit is its own
   `dword_CCC2C = 1; wallcoll(p); return;` (Watcom cross-jumps them into the last one); that block order also
   gives the EXE's ecx / edx / edi zeros.
   DRAFT: 1 differing, 810 vs 809. The z bounce negates in edx and halves through bx without a
   sign-extension (here movsx edx, ax for the int z). See docs/UNSURE.md. */
void checkgoal(Player *p, Player *g, short x, short y)
{
    signed char c;
    Player *q;
    int z;

    if (HIWORD(p->Zpos) > 0xD) return;
    if (p->SCnum != 0xE) {
        checkgoalp(p, g, x, y);
        return;
    }
    x -= HIWORD(g->Xpos);
    regd4.w = wcradiusx + 0x10;
    if (x > regd4.w) return;
    regd4.w = -regd4.w;
    if (x < regd4.w) return;
    y -= HIWORD(g->Ypos);
    word_E03B8 = wcradiusy + 2;
    if (y > word_E03B8) return;
    word_E03B8 = -word_E03B8;
    if (y < word_E03B8) return;
    if (OLDZ(p) >= 0xD) {
        HIWORD(p->Zpos) = OLDZ(p);
        if ((y = p->Zvel) < 0) {
            z = -y;
            x = z;
            x >>= 1;
            p->Zvel = x;
        }
        return;
    }
    collflag = 0xFF;
    p->pflags &= ~pfgoal;
    c = *puckc;
    if (c >= 0) {
        q = &SortCords[c];
        *puckc = -1;
        q->nopuck = 8;
        regd1.w = *pucky;
        if (!(q->pflags & pfgoal)) regd1.w = -regd1.w;
        if (regd1.w < 0) p->pflags |= pfgoal;
    }
    regd0.w = 0xFF00;
    regd1.l = (p->Ypos - OLDY(p)) >> 8;
    if (regd1.l != 0) {
        if (regd1.l > 0) {
            regd0.w = 0x100;
            word_E03B8 = -word_E03B8;
        }
        word_E03B8 += y;
        regd3.l = (p->Xpos - p->OldXpos) >> 8;
        *(int *)&word_E03B8 = word_E03B8 * regd3.w / regd1.w;
        if (*(unsigned *)&word_E03B8 < 0x10000) {
            x -= word_E03B8;
            if (x >= regd4.w) {
                regd4.w = -regd4.w;
                if (x <= regd4.w) {
                    regd1.w = 0;
                    if ((regd3.w = HIWORD(p->Ypos) ^ regd0.w) < 0) {
                        dword_CCC2C = 1;
                        wallcoll(p);
                        return;
                    }
                    regd0.w = -regd0.w;
                    if (p->pflags & pfgoal) {
                        dword_CCC2C = 1;
                        wallcoll(p);
                        return;
                    }
                    if (HIWORD(p->Zpos) != 0xD) {
                        regd4.w--;
                        if (x <= regd4.w) {
                            regd4.w = -regd4.w;
                            if (x >= regd4.w) {
                                Goal(g);
                                return;
                            }
                        }
                    }
                    gmode2 &= ~0x10;
                    if (!(gmode & 1)) {
                        if (crowdlevel <= 1200) {
                            crowdlevel += 500;
                            if (crowdlevel > 1200) crowdlevel = 1200;
                        }
                        CwdExciteLvl += 40;
                    }
                    sfx(0xAC);
                    regd0.w = randomd0(0x1000);
                    if (HIWORD(p->Ypos) >= 0) regd0.w = -regd0.w;
                    p->Yvel = regd0.w;
                    p->Xvel = randomd0(0x2000) - 0x1000;
                    p->Zvel = randomd0(0x2000) - 0x1000;
                    puckflip(p);
                    EndPenaltyShot();
                    shotongoal = onetimerflag = 0;
                    return;
                }
            }
        }
    }
    regd0.w = 0;
    regd1.w = 0x100;
    x = HIWORD(p->Xpos) - HIWORD(p->OldXpos);
    if (x >= 0) regd1.w = 0xFF00;
    dword_CCC2C = 1;
    wallcoll(p);
}
