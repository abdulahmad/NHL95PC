/* Engine assignment faceoff: penalty box exit, penalty shot setup and the take-position assignment that ends in
   the box exit's pops (PenShotStart keeps them far enough apart for the near jumps). */
#include "nhl95.h"

/* TakePlayerFromBox: sort object p takes the first roster player of its team (pflags bit 6:
 away; 444h bytes of 39-byte records per team) whose status is 7 (penalty over): the player leaves the box
 (facedir 4, SPA 7BFh, pflags bit 5, temp1 5Ah, temp5 = the roster index), roster status 3 (bench), tmpdst -2. */
void TakePlayerFromBox(Player *p)
{
    short i;
    short side;
    int r;

    side = (p->pflags & 0x40) != 0;
    for (i = 0; i < 25; i++) {
        r = side * 0x444 + i * 39;
        if (hmroster[r] == 7) {
            p->facedir = 4;
            SetSPA(p, 0x7BF);
            p->pflags |= 0x20;
            p->temp1 = 0x5A;
            p->temp5 = i;
            hmroster[r] = 3;
            *(short *)((char *)hmtmpdst + side * 256 + i * 2) = -2;
            return;
        }
    }
}


/* PenShotStart (511B4, PC only): penalty shot setup for team side's 6 objects. At the start (penshotstart) an
   object on assignment 2Dh gets 29h (temp5 0); otherwise an on-ice object without a pending change (newpos and
   newpnum -1, temp5 not -100) not already on assignment 27h gets it inserted. Nothing in penalty-shot mode.
   side: the team. No result. */
void PenShotStart(short side)
{
    Player *p;
    int i;

    if (penshotmode) return;
    p = &SortCords[side * 6];
    for (i = 0; i < 6; i++, p++) {
        if (penshotstart && p->asslist[p->assnum] == 0x2D) {
            p->temp5 = 0;
            assreplace(p, 0x29);
        } else if (p->position >= 0 && p->newpos == -1 && p->newpnum == -1 && p->temp5 != -100
                   && p->asslist[p->assnum] != 0x27) {
            assinsert(p, 0x27);
        }
    }
}

/* asstakeposition (52720, PC only; ends in TakePlayerFromBox_ret5): asstab 27h, skate to the faceoff spot. A
   player with a negative position gets the penalty-box assignment (0Dh), temp5 -100 and pflags2 bit 2. Nothing
   while pflags bit 5 is set or at the bench (check4bench). Done (temp5 -100): leave the assignment, and the next
   one too when it is 7 or 28h. A new assignment (pflags bit 1): temp2 8, temp1 0 and the spot from apl by
   position and the team's strength (tmap, one more step without a goalie), mirrored by side (pflags bit 7):
   around the faceoff dot (fox / foy; the first slots shifted by the dot), for the goalie (position 0) moved
   along x by fox * |foy -+ 27h| * 3 / 4096 when the dot is beyond 27h at the other end, and for the penalty
   shooter 10 from centre; kept in temp3 / temp4 with pflags2 bit 5 and SPA 99h (goalie) or 289h. Then, within 8
   of the spot and slower than 10h: snap onto it, and every 8 frames turn a step toward the dot (the goalie to
   1 / 3 or 7 / 5 instead of 2 / 6) until facing it, then stop and set temp5 -100. Otherwise skate there (skateto
   from 20 away, else SkateToSpot). p: the player. No result. */
void asstakeposition(Player *p)
{
    int dx;
    int dy;
    int d;
    short c;

    if (p->position < 0) {
        assreplace(p, 0xD);
        p->temp5 = -100;
        p->pflags2 |= 4;
    }
    if (p->pflags & 0x20) return;
    if (check4bench(p)) return;
    if (p->temp5 == -100) {
        assexit(p);
        if (p->asslist[p->assnum] == 7 || p->asslist[p->assnum] == 0x28) assexit(p);
        return;
    }
    if (p->pflags & 2) {
        p->pflags &= 0xFD;
        p->temp2 = 8;
        p->temp1 = 0;
        regd1.w = p->position;
        regd4.w = -p->tmptr->tmap;
        if (regd4.w > -6 && p->tmptr->tmgoalie < 0) regd4.w--;
        regd4.w = (regd4.w + 6) << 3;
        regd4.w = apl[regd4.w + regd1.w];
        regd4.w += regd4.w;
        regd0.w = word_CBE8C[regd4.w];
        regd1.w = word_CBE8E[regd4.w];
        if (!(p->pflags & 0x80)) {
            regd0.w = -regd0.w;
            regd1.w = -regd1.w;
        }
        if (p->position != 0) {
            if (regd4.w <= 4) {
                if ((fox ^ regd0.w) < 0) regd1.w -= foy >> 3;
                regd0.w -= fox >> 2;
            }
            regd0.w += fox;
            regd1.w += foy;
        } else if (ABS(foy) > 0x27 && ((p->pflags & 0x80) == 0 ^ foy < 0)) {
            c = foy - (!(p->pflags & 0x80) ? 0x27 : -0x27);
            c = ABS(c);
            regd0.w += (short)(fox * c * 3 / 4096);
        }
        if (penshotmode && p->SCnum == penshotplayer) {
            regd0.w = 0;
            regd1.w = (p->pflags & 0x80) ? -10 : 10;
        }
        p->temp3 = regd0.w;
        p->temp4 = regd1.w;
        p->pflags2 |= 0x20;
        p->Wallcos = 0;
        p->Wallsin = 0;
        SetSPA(p, p->position == 0 ? 0x99 : 0x289);
    }
    dx = HIWORD(p->Xpos) - p->temp3;
    dy = HIWORD(p->Ypos) - p->temp4;
    d = dx * dx + dy * dy;
    if (d < 0x40 && ABS(p->Xvel) < 0x10 && ABS(p->Yvel) < 0x10) {
        HIWORD(p->Xpos) = p->temp3;
        HIWORD(p->Ypos) = p->temp4;
        if (--p->temp1 >= 0) return;
        p->temp1 += 8;
        SetSPA(p, p->position == 0 ? 0x99 : 0x289);
        regd2.l = vtoa((short)(fox - HIWORD(p->Xpos)), (short)(foy - HIWORD(p->Ypos)));
        if (p->position == 0) {
            if (regd2.w == 2) regd2.w = (p->pflags & 0x80) ? 1 : 3;
            else if (regd2.w == 6) regd2.w = (p->pflags & 0x80) ? 7 : 5;
        }
        if (regd2.w != p->facedir) {
            regd2.w = (regd2.w - p->facedir) & 7;
            p->facedir = ((regd2.w < 5 ? 1 : -1) + p->facedir) & 7;
            return;
        }
        p->Xvel = p->Yvel = 0;
        p->temp5 = -100;
        return;
    }
    regd0.w = p->temp3;
    regd1.w = p->temp4;
    if (d >= 0x190) skateto(p, 0);
    else SkateToSpot(p, 0);
}
