/* Faceoffs and the penalty shot: the referee's penalty-shot assignment. */
#define assrefpenshot assrefpenshot_decl
#include "nhl95.h"
#undef assrefpenshot

/* assrefpenshot: the referee (p) runs a penalty shot. An animation lock (pflags bit 5) does
 nothing. pflags bit 1 clears that bit, points him at the opposite of where he stands, stops
 the puck and starts the referee glide. With no shooter he switches to assignment 21h.
 temp5 == 64h is the end of the shot. temp5 == 1 hides the puck. While he is still far from
 the spot in temp3/temp4, or still moving, he skates there. Otherwise the byte at temp1 counts
 down and the glide replays every 8 steps, turning one facing step toward that spot. Once he
 is facing it, the first time sets the drop spot and clears the referee step; after that, when
 speech is idle, the overlay is down and everyone is in place, he sounds the whistle.
 DRAFT (10.0 GA): the puck stop at temp5 == 1 is one chain ending in the puckvz store, so the stored 0 is read
 back through the pointer as in the EXE. Left: the facing step loads facedir into cx once in the EXE (cmp /
 sub eax, ecx, then the byte zero-extend before & 7); see docs/UNSURE.md. */
void assrefpenshot(Player *p)
{
    short r;
    int px;

    if (p->pflags & pfalock) goto done;
    if (p->pflags & pfna) {
        p->pflags &= ~pfna;
        p->temp2 = 8;
        ((signed char *)p)[OFS_Player_temp1] = 0;
        ((signed char *)p)[OFS_Player_temp1 + 1] = vtoa((short)-HIWORD(p->Xpos),
                                                         (short)-HIWORD(p->Ypos));
        p->temp3 = 0;
        p->temp4 = 0;
        p->temp5 = 0;
        p->pflags2 |= pfalock;
        p->Wallcos = 0;
        p->Wallsin = 0;
        *puckc = 0x10;
        *puckvx = 0;
        *puckvy = 0;
        *(short *)puckvz = 0;
        *(short *)puckz = (short)0xFF9C;
        SetSPA(p, SPArefglide);
    }
    if (penshotplayer == -1) {
        assreplace(p, 0x21);
        return;
    }
    if (p->temp5 == 0x64) goto done;
    if (p->temp5 == 1) {
        *puckc = -1;
        *puckx = *pucky = *(short *)puckz = *puckvx = *puckvy = *(short *)puckvz = 0;
        p->temp5++;
    }
    {
        int dx;
        int dy;
        int v;

        px = p->Xpos >> 16;
        dx = px - (*(int *)((char *)&p->temp3 - 2) >> 16);
        dy = (p->Ypos >> 16) - (*(int *)((char *)&p->temp4 - 2) >> 16);
        dx *= dx;
        dy *= dy;
        if (dx + dy >= 0x40) goto skate;
        if (p->Xvel < 0)
            v = -(*(int *)((char *)&p->Xvel - 2) >> 16);
        else
            v = *(int *)((char *)&p->Xvel - 2) >> 16;
        if (v >= 0x10) goto skate;
        if (p->Yvel < 0)
            v = -(*(int *)((char *)&p->Yvel - 2) >> 16);
        else
            v = *(int *)((char *)&p->Yvel - 2) >> 16;
        if (v >= 0x10) goto skate;
    }
    if (p->temp5 != 0) {
        HIWORD(p->Xpos) = p->temp3;
        HIWORD(p->Ypos) = p->temp4;
        regd2.l = 6;
    } else
        regd2.l = ((signed char *)p)[OFS_Player_temp1 + 1];
    if (--((signed char *)p)[OFS_Player_temp1] >= 0) goto done;
    ((signed char *)p)[OFS_Player_temp1] += 8;
    SetSPA(p, SPArefglide);
    r = regd2.w;
    if (r != p->facedir) {
        int step;

        regd2.w = (unsigned char)(r - p->facedir) & 7;
        if (regd2.w < 5)
            step = 1;
        else
            step = -1;
        step += *(int *)((char *)&p->facedir - 2) >> 16;
        step &= 7;
        p->facedir = step;
        return;
    }
    p->Yvel = 0;
    p->Xvel = p->Yvel;
    if (p->temp5 == 0) {
        p->pflags |= pfalock;
        SetSPA(p, 0xC03);
        p->temp3 = 0x96;
        {
            int spot;

            if ((((gmode & gmdir) == 0) ^ penshotteam) != 0)
                spot = -10;
            else
                spot = 10;
            p->temp4 = spot;
        }
        p->temp5++;
        RefStep[0] = 0;
        sflags &= ~0x40;
        return;
    }
    if (PaSpeechBusy()) goto done;
    if ((*(int *)((char *)&ovlseq - 2) >> 16) != -1) goto done;
    if (!AllInPlace()) goto done;
    RefStep[0] = -1;
    sfx(0xA4);
    p->temp5 = 0x64;
    return;
skate:
    regd0.w = p->temp3;
    regd1.w = p->temp4;
    SkateToSpot(p, 0);
done:
    return;
}
