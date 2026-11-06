/* Engine physics / AI: two players in contact. */
#define checkcheck checkcheck_decl
#define FacingBoards FacingBoards_decl
#include "nhl95.h"
#undef checkcheck
#undef FacingBoards

short FacingBoards(Player *p);

/* DRAFT (10.0 GA, 8 differing, 1212 vs 1209): the facing difference is subtracted and masked in
   separate statements, and the hit strength is selected with if / else. These natural forms give the
   EXE's position-gap and boarding register choices while keeping k and force in their EXE stack slots.
   Left: the chosen SPA is built in eax and sign-extended into edx (EXE directly in edx), and p->checking
   is loaded before randomd0(rel) rather than after it. */
/* checkcheck (5382C, Genesis checkcheck): players p and q are in contact (force: the impact); run it for p
   against q, then for q against p. A holding q (SPA 639h / 873h) goes to holdcheck, a B-check (589h) to Bcheck.
   A checking p (SPA 621h) marks the hit (impact 100h each in gmode bit 0), flags p (pflags 20h) and picks its
   animation: the hit SPA ED7h when a random number under 14h (q near the side boards or behind a net) or 1Eh is below
   p's aggression, q is in front (direction within one step, mirrored for attribute bit 3), within 14h both ways
   and slow or moving across p, else the facing's entry of the table at CCC50h. With a skater q and force from
   14h, the hit strength (A0h or 64h by p's pflags bit 3, 78h when q's differs; plus q's weight minus p's,
   halved, minus q's impact) can draw a penalty on p (0Bh / 0Ch, unless q is SortCords 10h, p is aggressive
   above 4 or gmode bit 4) when a random number beats p's checking, unless q has a quick shot (that is a
   penalty shot, 1Ah, the first time). Otherwise q falls (FallDown) after a possible penalty on p: every third
   hit on the referee (16h), boarding from behind (17h), or 13h / 0Eh, 19h, 15h / 0Dh by chance. */
void checkcheck(Player *p, Player *q, short force)
{
    signed char k;
    short dir;
    short odds;
    short rel;
    short v;
    Player *t;

    for (k = 0; k < 2; k++) {
        if (q->SPA == 0x639 || q->SPA == 0x873) {
            holdcheck(p, q);
        } else if (q->SPA == 0x589) {
            Bcheck(p, q);
        } else if (p->SPA == 0x621) {
            if (gmode & 1) {
                p->impact = 0x100;
                q->impact = 0x100;
            }
            dir = vtoa(rel = HIWORD(q->Xpos) - HIWORD(p->Xpos), (short)(HIWORD(q->Ypos) - HIWORD(p->Ypos)));
            rel = dir;
            rel -= p->facedir;
            rel &= 7;
            if (p->attribute & 8) rel = (8 - rel) & 7;
            p->pflags |= 0x20;
            odds = ABS(HIWORD(q->Xpos)) > 0x90
                || ((p->pflags & 0x80) != 0) ^ (HIWORD(p->Ypos) > 0) && ABS(HIWORD(q->Ypos)) - 0xE8 < 0x3C
                       && ABS(HIWORD(q->Xpos)) < 0x50 ? 0x14 : 0x1E;
            if (q->SCnum != 0x10 && randomd0(odds) < p->aggress && ((rel + 1) & 7) <= 2
                && ABS(HIWORD(p->Xpos) - HIWORD(q->Xpos)) < 0x14 && ABS(HIWORD(p->Ypos) - HIWORD(q->Ypos)) < 0x14
                && (ABS(q->Xvel) < 0x1F4 && ABS(q->Yvel) < 0x1F4 || (vtoa(q->Xvel, q->Yvel) - p->facedir + 2) & 3))
                v = 0xED7;
            else
                v = *(int *)((char *)dword_CCC4E + rel * 2) >> 16;
            SetSPA(p, v);
            if (q->position != 0 && force >= 0x14) {
                if (p->pflags & 8) rel = 0xA0;
                else rel = 0x64;
                if (((q->pflags & 8) != 0) ^ (rel == 0xA0)) rel = 0x78;
                rel = ((rel - p->weight + q->weight) >> 1) - q->impact;
                if (rel > 0 && ((gmode & 0x10) || !QuickShotChk(q) || penshotplayer >= 0) && randomd0(rel) > p->checking) {
                    if (q->SCnum != 0x10 && checkagr(p) <= 4 && !(gmode & 0x10)) AddPenalty(p, randomd0(2) != 0 ? 0xC : 0xB);
                } else {
                    if (q->SCnum == 0x10) {
                        if (p->pflags & 8) {
                            if (++word_CBEC2 >= 3) {
                                word_CBEC2 = 0;
                                AddPenalty(p, 0x16);
                            }
                            FallDown(p, q);
                        }
                    } else {
                        if (!(gmode & 0x10)) {
                        if (QuickShotChk(q)) {
                            if (penshotplayer < 0) {
                                penshotplayer = q->SCnum;
                                if (c1playernum[0] == penshotplayer) penshotctl = 1;
                                else if (c1playernum[0] == penshotplayer) penshotctl = 2;
                                else penshotctl = -1;
                                AddPenalty(p, 0x1A);
                            }
                        } else if (q->impact > 0x23 && ((dir - p->facedir + 1) & 7) <= 2 && ((q->facedir - p->facedir + 1) & 7) <= 2
                                   && FacingBoards(q) && checkagr(p) < 0x14) {
                            AddPenalty(p, 0x17);
                        } else if (checkagr(p) <= 3) {
                            if (p->SPA == 0xED7) AddPenalty(p, randomd0(10) > 8 ? 0x13 : 0xE);
                            else if (q->impact > 0x23 && randomd0(4) == 0) AddPenalty(p, 0x19);
                            else AddPenalty(p, randomd0(10) > 6 ? 0x15 : 0xD);
                        }
                        }
                        FallDown(p, q);
                    }
                }
            }
        }
        t = q;
        q = p;
        p = t;
    }
}
