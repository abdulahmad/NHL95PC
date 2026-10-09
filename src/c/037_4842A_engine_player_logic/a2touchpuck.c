/* Engine player logic: a player touches the puck (93G a2touchpuck). */
#include "nhl95.h"

#define TW(t, o) (*(short *)((char *)(t) + (o)))  /* team word at offset o: +30h last toucher, +32h / +34h before */

/* a2touchpuck (4DE14) - 93G a2touchpuck: player p touched the puck. Unless a two-line pass (ChkTwoLinePass) or a
   stoppage: remember the touch place and player (ltx / lty / lasttouch). In p's team: a new toucher (pnum) shifts
   the last-toucher words (+30h -> +32h -> +34h; unless tmflags bit 3 was set, which is just cleared) and a repeat
   of +34h clears its top byte (-1); the same toucher clears pflags bit 3 of the team. A skater with a position
   clears gmode2 bit 4. Not offside but a two-line pass: penalty 1Dh on p. With iflags bits 2 and 0 set and a
   skater of the other side than iflags bit 1: penalty 6 on player byte_E9AC1. */
void a2touchpuck(Player *p)
{
    short two;
    Team *t;

    two = ChkTwoLinePass(p);
    if (!two && !(gmode & 1)) {
        ltx = HIWORD(p->Xpos);
        lty = HIWORD(p->Ypos);
        lasttouch = p->SCnum;
    }
    t = p->tmptr;
    if (p->pnum != TW(t, 0x30)) {
        if (t->tmflags & 8) {
            t->tmflags &= 0xF7;
        } else {
            TW(t, 0x34) = TW(t, 0x32);
            TW(t, 0x32) = TW(t, 0x30);
        }
        TW(t, 0x30) = p->pnum;
        if (TW(t, 0x30) == TW(t, 0x34)) t->tmast2 = -1;
    } else if (*((signed char *)t + 0x44) & 8) {
        *((signed char *)t + 0x44) &= 0xF7;
    }
    if (p->position) gmode2 &= 0xEF;
    if (!(short)a2offsides(p) && two) AddPenalty(p, 0x1D);
    if ((iflags & 4) && (iflags & 1) && p->position && ((p->pflags & 0x80) != 0) ^ ((iflags & 2) != 0))
        AddPenalty((Player *)((char *)&SortCords + (*(int *)((char *)&byte_E9AC1 - 3) >> 24) * 0x80), 6);
}
