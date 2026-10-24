/* Engine physics AI: is the pass lane to a team-mate open; NetCollide and puckstick (matched) end in its pops. */
/* DRAFT (PassLaneChk, 10.0 GA, 12 differing, same size): the direction is kept in oy (dead by then), the x gap in
 its own dx; the wrap goes through y (`y = oy + 1`, the EXE's lea eax,[esi+1]). With dx the two ABS temporaries of
 ABS(y) <= ABS(oy) get the EXE's edi / ebp; left: dx in eax (EXE esi, where the y gap dy was: the x gap through dy
 gives esi but swaps the ABS pair, 17), and the y - 4Eh lea comes after the sum's sub 4Eh (EXE before it). The
 tie-breaker p's y through an int py (ruled 2026-10-24, docs/ESCALATIONS.md) is not kept; see docs/UNSURE.md. */
#define PassLaneChk PassLaneChk_decl
#define checkpuckcoll checkpuckcoll_decl
#define imul32 imul32_decl
#include "nhl95.h"
#undef PassLaneChk
#undef checkpuckcoll
void checkpuckcoll(Player *pk, short n);  /* 5428A: n compared as a short */
#undef imul32
int __cdecl imul32(int a, int b);  /* 933F0: the library multiply, arguments on the stack */

#define W(v) (*(int *)((char *)&(v) - 2) >> 16)

/* ShotLaneOpen saves edx and ecx. The header declares it void, so this alias is what
 lets the caller test eax and keep edx. */
int LaneOpen(void);
#pragma aux LaneOpen "ShotLaneOpen" value [eax] modify [eax];

/* DRAFT (checkpuckcoll, 10.0 GA): 73 score differing, same 1,570-byte size. Reusing the dead height
   local for the body frame fixes the height temporaries. The EXE keeps reach / half size / box size in edi
   and speed / |dy| / box limit in esi; this draft still reverses those registers. */
/* checkpuckcoll (5428A, 93G checkpuckcoll .ccx; ends in PassLaneChk_ret5): check the puck pk against sort object
   n (from the OOlist walk). Not the carrier, players 0-0Bh and object 10h only, not with pflags bit 2 (no
   collisions) or nopuck. A goalie's stick (available, position 0): reach s from SkillForAnim (s * 800h - FA0h over
   the puck speed |vx| + |vy|, 0-4) on the GetHotOrStick offsets: regd2 = |dx| + s, regd4 = |dx| * 4 / 3,
   regd3 = |dy| * 4 / 3; with the GetHot spot within regd2 in x and y, the puck height between the stick's low
   and high ends and the distance within regd2 (a quarter of the square while the puck has nopuck), the
   delayed offside check and puckstick. Another available skater's stick (not object 10h; puck z up to 5 and vz
   up to 200h): the GetHot spot within 0Eh, the distance squared within C4h (31h while nopuck), and within 24h
   during frames 430h-44Fh: puckstick, done. Then the body: a goalie within 0Ah, distance squared up to 64h:
   delayed offside check and puckgoalie. A skater in an odd frame 431h-44Fh with the puck below z 8 first tries
   the GetHotStick spot (half the offsets, within their size); else within 8 (10h from frame 450h on) and the
   distance squared up to 40h (100h): puckbody. No result. */
void checkpuckcoll(Player *pk, short n)
{
    Player *p;
    short s;
    short v;
    short h;

    if (n == *puckc) return;
    if (n > 0xB && n != 0x10) return;
    p = &SortCords[n];
    if (p->pflags & 4) return;
    if (p->nopuck) return;
    if (!(p->pflags2 & 4) && p->position == 0) {
        s = SkillForAnim(p);
        v = ABS(*puckvx) + ABS(*puckvy);
        if (v == 0) v = 1;
        s = ((s << 11) - 0xFA0) / v;
        if (s < 0) s ^= s;
        if (s > 4) s = 4;
        GetHotOrStick(p);
        regd2.w = ABS(regd0.w);
        regd4.w = (regd2.w << 2) / 3;
        v = ABS(regd1.w);
        regd3.w = (v << 2) / 3;
        regd2.w += s;
        GetHot(p);
        regd0.w += HIWORD(p->Xpos) - *puckx;
        regd0.w = ABS(regd0.w);
        if (regd0.w >= regd2.w) goto body;
        regd1.w += HIWORD(p->Ypos) - *pucky;
        regd1.w = ABS(regd1.w);
        if (regd1.w >= regd2.w) goto body;
        h = regd4.w + v;
        h = (h > 5 ? h : 5);
        h += s;
        if (h < *(short *)puckz) goto body;
        v -= regd4.w;
        h = v - s;
        if (h >= 0 && h >= *(short *)puckz) goto body;
        regd0.l = regd0.w * regd0.w + regd1.w * regd1.w;
        regd1.l = regd2.w * regd2.w;
        if (pk->nopuck > 0) regd1.l >>= 2;
        if (regd1.w < regd0.w) goto body;
        ChkDelayedOffside(p);
        puckstick(pk, p);
    } else if (!(p->pflags2 & 4) && p->position >= 0 && n != 0x10 && HIWORD(pk->Zpos) <= 5 && pk->Zvel <= 0x200) {
        GetHot(p);
        regd0.w += HIWORD(p->Xpos) - HIWORD(pk->Xpos);
        if (ABS(regd0.w) > 0xE) goto body;
        regd1.w += HIWORD(p->Ypos) - HIWORD(pk->Ypos);
        if (ABS(regd1.w) > 0xE) goto body;
        regd0.l = regd0.w * regd0.w + regd1.w * regd1.w;
        regd1.l = 0xC4;
        if (pk->nopuck > 0) regd1.w >>= 2;
        if (regd0.ul > regd1.ul) goto body;
        if (p->frame >= 0x430 && p->frame <= 0x44F && regd0.ul > 0x24) goto body;
        puckstick(pk, p);
        return;
    }
body:
    if (p->position == 0) {
        regd0.w = HIWORD(p->Xpos) - HIWORD(pk->Xpos);
        if (ABS(regd0.w) > 0xA) return;
        regd1.w = HIWORD(p->Ypos) - HIWORD(pk->Ypos);
        if (ABS(regd1.w) > 0xA) return;
        if ((unsigned)(regd0.w * regd0.w + regd1.w * regd1.w) > 0x64) return;
        ChkDelayedOffside(p);
        puckgoalie(pk, p);
        return;
    }
    h = p->frame;
    if (h >= 0x431 && h <= 0x44F && (h & 1) && *(short *)puckz < 8) {
        GetHotStick(p);
        regd0.w >>= 1;
        regd1.w >>= 1;
        s = ABS(regd0.w);
        regd0.w += HIWORD(p->Xpos) - HIWORD(pk->Xpos);
        if (ABS(regd0.w) <= s) {
            regd1.w += HIWORD(p->Ypos) - HIWORD(pk->Ypos);
            if (ABS(regd1.w) <= s) {
                regd0.l = regd0.w * regd0.w + regd1.w * regd1.w;
                if ((unsigned)(s * s) >= regd0.ul) goto hit;
            }
        }
    }
    s = 8;
    v = 0x40;
    if (h > 0x44F) {
        s = 0x10;
        v = 0x100;
    }
    regd0.w = HIWORD(p->Xpos) - HIWORD(pk->Xpos);
    if (ABS(regd0.w) > s) return;
    regd1.w = HIWORD(p->Ypos) - HIWORD(pk->Ypos);
    if (ABS(regd1.w) > s) return;
    regd0.l = regd0.w * regd0.w + regd1.w * regd1.w;
    if ((unsigned)v < regd0.ul) return;
hit:
    puckbody(pk, p);
}

/* PassLaneChk: 1 when team-mate o is ahead of p toward p's goal. p's position must be set and
 ShotLaneOpen must report the lane clear. o is deeper than p, inside the 4Eh line, within 3Ch in
 y and 28h in x, both skate toward that goal, and the pass direction is within a step of the way
 o is travelling (or the way it faces, when that direction is 8). */
int PassLaneChk(Player *p, Player *o)
{
    int limit;
    int side;
    int y;
    int oy;
    int dy;
    int dx;

    side = (p->pflags & pfgoal) != 0;
    if (p->position == 0) return 0;
    if (LaneOpen()) return 0;
    oy = o->Ypos >> 16;
    y = p->Ypos >> 16;
    if (side) limit = 0x4E;
    else limit = -0x4E;
    if ((y > limit) ^ side) return 0;
    if (ABS(y) <= ABS(oy)) return 0;
    if (ABS(y) > 0x76) return 0;
    if (side) {
        if (o->Yvel < 0) return 0;
        if (p->Yvel < 0) return 0;
    }
    if (!side) {
        if (o->Yvel > 0) return 0;
        if (p->Yvel > 0) return 0;
    }
    if (((y - 0x4E) ^ (HIBYTE(o->Yvel) + oy - 0x4E)) < 0) return 0;
    dy = oy - y;
    if (dy < 0) dy = -dy;
    if (dy > 0x3C) return 0;
    dx = (p->Xpos >> 16) - (o->Xpos >> 16);
    if (dx < 0) dx = -dx;
    if (dx > 0x28) return 0;
    oy = vtoa(W(o->Xvel), W(o->Yvel));
    if (oy == 8) oy = W(o->facedir);
    oy -= vtoa((short)(HIWORD(p->Xpos) - HIWORD(o->Xpos)), (short)(HIWORD(p->Ypos) - HIWORD(o->Ypos)));
    y = oy + 1;
    if ((y & 7) >= 3) return 0;
    return 1;
}

/* NetCollide (5601D, PC only; ends in PassLaneChk_ret5): player p near a net (60h, CAh from centre on his side):
   unless he is at least 18h from the net centre nothing happens; else his unit offset (x4) picks the side he
   hits: front or back (facing within the range for that side, dir + 2 / + 1 & 7) or the posts (dir 5+ / 1-3);
   he is snapped to the net edge for his facing (offset tables word_CCBEC, word_CCBFC, word_CCBCC, word_CCBDC;
   mirrored by the x-flip attribute bit 3), stopped, and the bump SPA for that side is returned (F0Fh, F55h,
   F9Bh / FE1h). p: the player; dir: his direction. Result: the new SPA, or his SPA when nothing changes.
   DRAFT (10.0 GA): 22 score differing, same size: only the two ABS temporaries of the side test (ecx / edx
   swapped); ux declared before gy gives the EXE's gx / dy slots (permute.py movedecl). The result is an int (FallDown keeps it in a short): the EXE's widened
   SPA read. No goto: the cases nest under dist >= 18h and fall through to the kept SPA, and the two post
   blocks share one `return 0xFE1` (the EXE keeps the second block's FE1 and the first block's F9B). The first
   x-flip comparison is materialized by a doubled comparison, as in the EXE (the C_MATCHING materialized-bool
   pattern). The direction tests read dir + 2 & 7 / dir + 1 & 7 / dir - 1 without storing them back (dir ebp, gy
   edi as in the EXE). The single-use copy `scaled_y = dy << 8; uy = scaled_y / dist >> 2;` of the old draft is
   out (a tie-breaker; it gave the same slots). */
int NetCollide(Player *p, int dir)
{
    int gx;
    int dy;
    int dx;
    int ux;
    int gy;
    int dist;
    int uy;

    gx = HIWORD(p->Xpos) >= 0 ? 0x60 : -0x60;
    dx = (p->Xpos >> 16) - gx;
    gy = HIWORD(p->Ypos) >= 0 ? 0xCA : -0xCA;
    dy = (p->Ypos >> 16) - gy;
    dist = vecdist(dx, dy);
    if (dist >= 0x18) {
        ux = (dx << 8) / dist >> 2;
        uy = (dy << 8) / dist >> 2;
        if ((uy < 0 ? -uy : uy) >= (ux < 0 ? -ux : ux)) {
            if (gy >= 0) {
                if ((dir + 2 & 7) >= 5) {
                    HIWORD(p->Xpos) = gx + ux;
                    if (gx < 0 && ((p->attribute & 8) == 0) != 0) HIWORD(p->Xpos) += 6;
                    if (gx > 0 && (p->attribute & 8)) HIWORD(p->Xpos) -= 6;
                    HIWORD(p->Ypos) = uy + gy - 8;
                    p->Xvel = 0;
                    p->Yvel = 0;
                    HIWORD(p->Ypos) += word_CCBEC[p->facedir] - 0x108;
                    return 0xF0F;
                }
            } else if ((dir + 1 & 7) < 3) {
                HIWORD(p->Xpos) = gx + ux;
                HIWORD(p->Ypos) = uy + gy;
                p->Xvel = 0;
                p->Yvel = 0;
                HIWORD(p->Ypos) += word_CCBFC[p->facedir] + 0x108;
                return 0xF55;
            }
        } else {
            if (gx >= 0) {
                if (dir < 5) return p->SPA;
                ux -= 6;
                HIWORD(p->Xpos) = gx + ux;
                HIWORD(p->Ypos) = uy + gy + (gy > 0 ? -10 : 0);
                p->Xvel = 0;
                p->Yvel = 0;
                if (p->attribute & 8) HIWORD(p->Xpos) -= word_CCBDC[8 - p->facedir & 7] + 0x9A;
                else HIWORD(p->Xpos) += word_CCBCC[p->facedir] - 0x9A;
                if (!(p->attribute & 8)) return 0xF9B;
            } else {
                if (dir == 0 || dir - 1 >= 3) return p->SPA;
                ux += 6;
                HIWORD(p->Xpos) = gx + ux;
                HIWORD(p->Ypos) = uy + gy + (gy > 0 ? -10 : 0);
                p->Xvel = 0;
                p->Yvel = 0;
                if (p->attribute & 8) HIWORD(p->Xpos) -= word_CCBCC[8 - p->facedir & 7] - 0x9A;
                else HIWORD(p->Xpos) += word_CCBDC[p->facedir] + 0x9A;
                if (p->attribute & 8) return 0xF9B;
            }
            return 0xFE1;
        }
    }
    return p->SPA;
}

/* puckstick (57483, 93G puckstick; ends in PassLaneChk_ret5a): the puck touches player p's stick (regd0 = the
   squared distance from checkpuckcoll). A goalie does nothing during a highlight (gmode bit 4); otherwise his
   save flag (byte 63h) is cleared and set again when the puck comes from a shot of the other team's shotplayer
   from beyond 58h, from the far side (by pflags bit 7) and fast (|vy| over 2EE0h, or over 1770h with SPA
   119Dh-121Dh), then ChkShotStat. Then pflags bit 0 is cleared. With a carrier (puckc) on the other team, in range
   (regd0 up to 24h) and p not in SPA 13C5h-14ADh: a skater steals only from a skater and on randomd0(carrier pde
   + 20h - p's pde, an eighth more against a carrier with pflags bit 3 and p without) up to 2, a goalie always;
   both get nopuck pde + 14h, lastplayer = the carrier, sflags bits 2-3 cleared, and the stick deflect. Without a
   carrier (a goalie only within 40h): regd0 = puck speed squared, regd1 = (13000 + 700 * stickhand, no stickhand
   bonus with gmode2 bit 4) squared; outside SPA 13C5h-14ADh p catches the puck when it is slow enough, or as the
   pass receiver (passplayer) on randomd0(2): vz cleared, puckglue, and a goalie keeps it below z 8 with vx vy
   quartered and his save flag set. Else nopuck 8 and the stick deflect: sfx 99h, a2touchpuck, deflect(puck). */
void puckstick(Player *puck, Player *p)
{
    Player *q;
    int pde;
    int flag;

    flag = 0;
    if (p->position == 0) {
        if (gmode & 0x10) return;
        ((unsigned char *)p)[0x63] = 0;
        if (!dword_E9A9E && !(p->pflags & 0x40) && (gmode2 & 0x10)
            && ((p->SCnum < 6) ^ (shotplayer < 6))
            && ABS(HIWORD(SortCords[shotplayer].Ypos)) > 0x58
            && ((HIWORD(SortCords[shotplayer].Ypos) > 0) ^ ((p->pflags & 0x80) != 0))) {
            if (ABS(*puckvy) > 0x2EE0) flag = 1;
            else if (ABS(*puckvy) > 0x1770 && p->SPA >= 0x119D && p->SPA <= 0x121D) flag = 1;
        }
        ChkShotStat();
    }
    p->pflags &= ~1;
    if (*puckc >= 0) {
        if (p->SPA >= 0x13C5 && p->SPA <= 0x14AD) return;
        q = &SortCords[*puckc];
        if (!(((unsigned char)p->pflags ^ (unsigned char)q->pflags) & 0x40)) return;
        if (regd0.ul > 0x24) return;
        if (p->position != 0) {
            if (q->position == 0) return;
            pde = (short)(imul32(q->tmptr->tmpde[q->pnum], q->stickhand) >> 12);
            regd0.w = pde + 0x20 - (short)(imul32(p->tmptr->tmpde[p->pnum], p->stickhand) >> 12);
            if ((q->pflags & 8) && !(p->pflags & 8)) regd0.w += regd0.w / 8;
            if (randomd0(regd0.w) > 2) return;
        }
        q->nopuck = (short)(imul32(q->tmptr->tmpde[q->pnum], q->stickhand) >> 12) + 0x14;
        p->nopuck = (short)(imul32(p->tmptr->tmpde[p->pnum], p->stickhand) >> 12) + 0x14;
        lastplayer = q->SCnum;
        sflags &= 0xF3;
    } else {
        if (p->position == 0 && regd0.ul > 0x40) return;
        regd0.w = *puckvx;
        regd1.w = *puckvy;
        regd0.l = regd0.w * regd0.w + regd1.w * regd1.w;
        regd1.w = 0;
        if (!(gmode2 & 0x10)) regd1.w = p->stickhand * 0x2BC;
        regd1.w += 0x32C8;
        regd1.l = regd1.w * regd1.w;
        if ((p->SPA < 0x13C5 || p->SPA > 0x14AD)
            && (regd0.ul <= regd1.ul || p->SCnum == passplayer && randomd0(2))) {
            *(short *)puckvz = 0;
            puckglue(p);
            if (p->position != 0) return;
            if (*(short *)puckz > 8) *(short *)puckz = 8;
            *puckvx >>= 2;
            *puckvy >>= 2;
            ((unsigned char *)p)[0x63] = flag;
            return;
        }
        p->nopuck = 8;
    }
    sfx(0x99);
    a2touchpuck(p);
    deflect(puck);
}
