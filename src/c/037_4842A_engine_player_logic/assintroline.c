/* Engine player logic: intro line skate. */
/* DRAFT (10.0 GA): 685 vs 687, 15 score differing. The squared distance uses the wait loop's i;
   z = --p->temp1 keeps the countdown in edi as in the EXE. Left: copies before the distance squares,
   a redundant countdown-result copy and later turn temporaries; see the agent notes. */
#define assintroline assintroline_decl
#include "nhl95.h"
#undef assintroline

void assintroline(Player *p);

/* assintroline: the intro skate. Flag 20h does nothing. temp5 == -100 waits until every
 player on the line (12 slots at dword_DF848) is also waiting, then holds seqtimer at 10.
 Otherwise temp5 counts down; while it is still positive the player sometimes shifts and
 plays SPA 0DABh or 0DC3h. At zero, flag bit 1 sets the spot (temp3 -15), SPA 0A5Bh and
 the crowd. Close and slow: step temp1, turn toward the spot, then SPA 0C57h. Far: skateto
 above 90h, else SkateToSpot. */
void assintroline(Player *p)
{
    int i;
    int dx;
    int dy;
    int v;
    short z;

    if (p->pflags & 0x20) return;
    if (p->temp5 == -100) {
        if (seqtimer <= 10) return;
        i = 0;
        goto test;
    wait:
        if ((*(int *)((char *)dword_DF848 + (i << 7)) >> 16) != -100) return;
        i++;
    test:
        if (i < 12) goto wait;
        seqtimer = 10;
        return;
    }
    if (p->temp5 > 0) {
        p->temp5--;
        if (p->temp5 > 0) {
            if (randomd0(0x64) == 0)
                HIWORD(p->Xpos) = p->temp3 + randomd0(2);
            if (p->pflags2 & 2) return;
            if (randomd0(0x50) != 0) return;
            SetSPA(p, randomd0(2) ? 0xDAB : 0xDC3);
            p->pflags2 |= 2;
            return;
        }
    }
    if (p->pflags & 2) {
        p->pflags &= ~2;
        p->temp2 = 8;
        p->temp1 = 0;
        p->temp3 = -15;
        p->temp4 = 0;
        p->pflags2 |= 0x20;
        p->Wallcos = 0;
        p->Wallsin = 0;
        SetSPA(p, 0xA5B);
        z = 0;
        yc1 = z;
        RefStep[0] = 1;
        crowdlevel = 0x320;
    }
    dx = HIWORD(p->Xpos) - p->temp3;
    dy = HIWORD(p->Ypos) - p->temp4;
    i = dy * dy + dx * dx;
    if (i < 0x40) {
        if (p->Xvel < 0)
            v = -(*(int *)((char *)&p->Xvel - 2) >> 16);
        else
            v = *(int *)((char *)&p->Xvel - 2) >> 16;
        if (v < 0x10) {
            if (p->Yvel < 0)
                v = -(*(int *)((char *)&p->Yvel - 2) >> 16);
            else
                v = *(int *)((char *)&p->Yvel - 2) >> 16;
            if (v < 0x10) {
                HIWORD(p->Xpos) = p->temp3;
                HIWORD(p->Ypos) = p->temp4;
                z = --p->temp1;
                if (z >= 0) return;
                p->temp1 = z + 8;
                SetSPA(p, 0xA5B);
                regd2.l = (short)vtoa((short)-HIWORD(p->Xpos), (short)-HIWORD(p->Ypos));
                if (regd2.w != p->facedir) {
                    regd2.w = (regd2.w - p->facedir) & 7;
                    v = regd2.w < 5 ? 1 : -1;
                    v += *(int *)((char *)&p->facedir - 2) >> 16;
                    v &= 7;
                    p->facedir = v;
                    return;
                }
                p->Yvel = 0;
                p->Xvel = p->Yvel;
                p->temp5 = -100;
                SetSPA(p, 0xC57);
                return;
            }
        }
    }
    regd0.w = p->temp3;
    regd1.w = p->temp4;
    if (i > 0x90) skateto(p, 0);
    else SkateToSpot(p, 0);
}
