/* Engine physics AI: a player falls after a hit. */
#include "nhl95.h"
#define TW(t, o) (*(short *)((char *)(t) + (o)))  /* team word at offset o (24h: checks) */
#define PW(p, o) (*(short *)((char *)(p) + (o)))  /* player word at offset o (40h: stumble timer) */

/* FallDown (562DB, 93G FallDown): player p falls after a hit by h (or by the puck, object 0Eh). Only players and
   object 10h, not while fighting or already in a fall anim (A0Bh 8D3h 681h 6D9h 993h 13C5h 141Dh). Object 10h
   (the door) only swings (B13h, crowd up, check sound 1, sfx 7Dh). A good stickhandler (byte 60h at least 0Ch)
   stumbles (8D3h, timer word 40h = 3Ch) unless randomd0(10h) + 10h is at most his impact. Else the hitter's team
   counts a check (team word 24h, not for a goalie, nor in a highlight or with the clock stopped), p gets nopuck
   78h, d = the direction from p to h. Hit by an opponent skater: near the nets (|x| >= 60h, |y| >= CAh) NetCollide
   may pick the fall; at the side boards (|x| >= 80h) or behind the goal lines (|y| >= EEh or <= -F2h) a hit toward
   the boards pins him there (x or y from the word_CCBCC.. tables by facedir, mirrored with attribute bit 3) with a
   board fall (F0Fh F55h F9Bh FE1h 1027h 1055h); NetCollide again in the corners. Without one: a hit from the front
   falls back (6D9h); a puck hit from the side (directions 3, 7) outside its 450h-467h frames may injure him (injuries
   on, no penalty shot, facedir 0 or 4, not pflags2 bit 4, randomd0(C8h or A0h with pflags bit 3) up to 14h and
   CanRemovePlayer: A0Bh, setInjuryType, AddPenalty2 0Ah on h, done); a hit from behind by a good checker (64h at
   least 0Ah) with facedir 0 or 4 flips him (993h, the box door for h's side), else he falls forward (681h). A board
   fall raises the crowd 64h and, unless p had the puck or the referee waves it off (checkagr over 3), a boarding
   AddPenalty on h (18h with impact over 23h, else 14h). Then the fall anim (pflags bit 5, SetSPA), out of
   assignment 12h, crowd up, excitement +0Fh; without the puck a check sound (2 for the board falls, else 1).
   With it the puck comes loose and a fall back may injure him (randomd0 up to his impact): A0Bh, setInjuryType and
   AddPenalty2 on h: 0Ah, or with penalties on, room in h's box and h removable, 17h (h facing him from behind) or 9,
   then Stop4Pen for the free penalty slots. Last sfx 7Dh (away player) or A0h. No result. */
void FallDown(Player *h, Player *p)
{
    short i;
    short s;
    short d;
    short d2;
    Team *t;

    if (p->SCnum > 0xB && p->SCnum != 0x10) return;
    if (p->pflags2 & 1) return;
    s = p->SPA;
    if (s == 0xA0B || s == 0x8D3 || s == 0x681 || s == 0x6D9 || s == 0x993 || s == 0x13C5 || s == 0x141D) return;
    if (p->SCnum == 0x10) {
        if (s == 0xB13) return;
        p->pflags |= 0x20;
        SetSPA(p, 0xB13);
        if (crowdlevel <= 0x3E8) {
            crowdlevel += 0x1F4;
            if (crowdlevel > 0x3E8) crowdlevel = 0x3E8;
        }
        CwdExciteLvl += 0xF;
        newcheck(1);
        sfx(0x7D);
        return;
    }
    if (p->stickhand >= 0xC && randomd0(0x10) + 0x10 > p->impact) {
        PW(p, 0x40) = 0x3C;
        s = 0x8D3;
        goto fall;
    }
    if (h->position != 0) {
        t = h->tmptr;
        if (!(gmode & 0x10) && !(gmode & 1)) TW(t, 0x24)++;
    }
    p->nopuck = 0x78;
    d = vtoa((short)(HIWORD(h->Xpos) - HIWORD(p->Xpos)), (short)(HIWORD(h->Ypos) - HIWORD(p->Ypos)));
    if (h->position == 0 || (h->SCnum < 6) == (p->SCnum < 6)) {
        s = p->SPA;
        goto pick;
    }
    if (ABS(HIWORD(p->Xpos)) >= 0x60 && ABS(HIWORD(p->Ypos)) >= 0xCA) {
        s = NetCollide(p, d);
        if (s != p->SPA) goto pick;
    }
    if (HIWORD(p->Xpos) >= 0x80) {
        if (HIWORD(p->Ypos) > 0xD0 || HIWORD(p->Ypos) < -0xD6) {
net:
            s = NetCollide(p, d);
        } else if (d >= 5) {
            p->Xvel = 0;
            if (p->attribute & 8) {
                s = 0xFE1;
                HIWORD(p->Xpos) = -word_CCBDC[(8 - p->facedir) & 7];
            } else {
                s = 0xF9B;
                HIWORD(p->Xpos) = word_CCBCC[p->facedir];
            }
        }
    } else if (HIWORD(p->Xpos) <= -0x80) {
        if (HIWORD(p->Ypos) > 0xD0 || HIWORD(p->Ypos) < -0xD6) goto net;
        if (d != 0 && d < 4) {
            p->Xvel = 0;
            if (HIWORD(p->Ypos) >= -0x54 && HIWORD(p->Ypos) < -0xA || HIWORD(p->Ypos) >= 0x27 && HIWORD(p->Ypos) < 0x75) {
                if (p->attribute & 8) {
                    s = 0x1027;
                    HIWORD(p->Xpos) = -word_CCC0C[(8 - p->facedir) & 7];
                } else {
                    s = 0x1055;
                    HIWORD(p->Xpos) = word_CCC1C[p->facedir];
                }
            } else {
                if (p->attribute & 8) {
                    s = 0xF9B;
                    HIWORD(p->Xpos) = -word_CCBCC[(8 - p->facedir) & 7];
                } else {
                    s = 0xFE1;
                    HIWORD(p->Xpos) = word_CCBDC[p->facedir];
                }
            }
        }
    } else if (HIWORD(p->Ypos) >= 0xEE) {
        if (HIWORD(p->Xpos) > 0x68 || HIWORD(p->Xpos) < -0x68) goto net;
        if (((d + 2) & 7) >= 5) {
            HIWORD(p->Ypos) = word_CCBEC[p->facedir];
            p->Yvel = 0;
            s = 0xF0F;
        }
    } else if (HIWORD(p->Ypos) <= -0xF2) {
        if (HIWORD(p->Xpos) > 0x68 || HIWORD(p->Xpos) < -0x68) goto net;
        if (((d + 1) & 7) < 3) {
            HIWORD(p->Ypos) = word_CCBFC[p->facedir];
            p->Yvel = 0;
            s = 0xF55;
        }
    }
pick:
    if (s == p->SPA) {
        d = (d - p->facedir + 1) & 7;
        if ((unsigned short)d <= 2) {
            s = 0x6D9;
            goto fall;
        }
        if (h->SCnum == 0xE && (d == 3 || d == 7)) {
            s = 0x6D9;
            if (h->frame > 0x44F || h->frame > 0x467) goto fall;
            if (penshotplayer >= 0 || (gmode & 1) || (gmode & 0x10) || !gameopts.optbit4 || (p->facedir & 3)
                || (p->pflags2 & 0x10)) goto fall;
            if (randomd0((p->pflags & 8) ? 0xC8 : 0xA0) > 0x14) goto fall;
            if (!CanRemovePlayer(p)) goto fall;
            if (crowdlevel <= 0x3E8) {
                crowdlevel += 0x1F4;
                if (crowdlevel > 0x3E8) crowdlevel = 0x3E8;
            }
            CwdExciteLvl += 0xF;
            p->pflags |= 0x20;
            SetSPA(p, 0xA0B);
            setInjuryType(p);
            AddPenalty2(h, 0xA);
            return;
        }
        if (!(p->facedir & 3) && h->checking >= 0xA && h->SCnum <= 0xB) {
            s = 0x993;
            SetBoxDoorObject((h->pflags & 0x40) != 0);
        } else {
            s = 0x681;
        }
    } else {
        crowdlevel += 0x64;
        if (*puckc != p->SCnum && checkagr(h) <= 3 && s >= 0xF0F && s <= 0xFE1)
            AddPenalty(h, p->impact > 0x23 ? 0x18 : 0x14);
    }
fall:
    p->pflags |= 0x20;
    SetSPA(p, s);
    if (p->asslist[p->assnum] == 0x12) assexit(p);
    if (crowdlevel <= 0x3E8) {
        crowdlevel += 0x1F4;
        if (crowdlevel > 0x3E8) crowdlevel = 0x3E8;
    }
    CwdExciteLvl += 0xF;
    if (*puckc < 0 || *puckc != p->SCnum) {
        if (s >= 0xF0F && s <= 0x1055) newcheck(2);
        else newcheck(1);
        return;
    }
    *puckc = -1;
    if (penshotplayer < 0 && !(gmode & 0x10) && gameopts.optbit4 && p->SPA == 0x6D9 && !(p->facedir & 3)
        && !(p->pflags2 & 0x10) && randomd0((p->pflags & 8) ? 0xC8 : 0xA0) <= p->impact && !(gmode & 1)
        && CanRemovePlayer(p)) {
        p->pflags |= 0x20;
        SetSPA(p, 0xA0B);
        setInjuryType(p);
        if (h->position == 0 || !gameopts.optbit0 || PBnum[(h->pflags & 0x40) != 0] >= 8 || !CanRemovePlayer(h)) {
            AddPenalty2(h, 0xA);
        } else {
            d2 = vtoa((short)(HIWORD(p->Xpos) - HIWORD(h->Xpos)), (short)(HIWORD(p->Ypos) - HIWORD(h->Ypos)));
            if (((d2 - h->facedir + 1) & 7) <= 2 && ((p->facedir - h->facedir + 1) & 7) <= 2) AddPenalty2(h, 0x17);
            else AddPenalty2(h, 9);
            for (i = 0; i < 0x20; i++) if (!PenBuf[i * 2]) Stop4Pen(i - 1);
        }
    }
    if (p->pflags & 0x40) sfx(0x7D);
    else sfx(0xA0);
}
