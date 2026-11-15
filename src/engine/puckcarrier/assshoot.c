/* Engine player logic: shoot assignment. */
#define assshoot assshootDecl
#include "nhl95.h"
#undef assshoot

/* assshoot: asstab slot 18. While pfalock, leave. A new assignment (pfna) clears that bit and
 SetShotMode. Otherwise, unless sflags bit 3, assexit. Then count temp2 down (regd2 bit 5 when it
 passes 0) and the word at player+4Ch (held at 0). Inside the y band 54h..9Dh, with the other
 team's dword at +3Eh under 24h and that word 0, a 1-in-14h roll sets the word to 12Ch and regd1
 bit 4; any miss clears regd1 bits 4 and 6 (mask AFh). Then ShotMode. */
void assshoot(Player *p)
{
    int y;

    if (p->pflags & pfalock) return;
    if (p->pflags & pfna) {
        p->pflags &= (signed char)~pfna;
        SetShotMode(p);
        return;
    }
    if (!(sflags & 8)) {
        assexit(p);
        return;
    }
    regd2.w = 0;
    if (--p->temp2 < 0) *(unsigned char *)&regd2 |= 0x20;
    if (--*(short *)((char *)p + 0x4C) < 0) *(short *)((char *)p + 0x4C) = 0;
    if (HIWORD(p->Ypos) < 0) y = -(p->Ypos >> 16);
    else y = p->Ypos >> 16;
    if (y < 0x9E && (y = HIWORD(p->Ypos) < 0 ? -(p->Ypos >> 16) : p->Ypos >> 16) > 0x53
        && *(int *)((char *)p->optmptr + 0x3E) < 0x24
        && *(short *)((char *)p + 0x4C) == 0 && randomd0(0x14) == 0) {
        *(short *)((char *)p + 0x4C) = 0x12C;
        *(unsigned char *)&regd1 |= 0x10;
    } else *(unsigned char *)&regd1 &= 0xAF;
    ShotMode(p);
}

/* assfaceoff (4D4F0; 93G logic93 assfaceoff): the faceoff assignment of player p: unless p is out of the play
   (pflags bit 20h) or the game is in its faceoff wait (gmode2 bit 0), finish it (assexit). No result. */
void assfaceoff(Player *p)
{
    if (!(p->pflags & 0x20) && !(gmode2 & 1)) assexit(p);
}

/* assexit (4D509; 93G logic93 assexit): finish the current assignment of player p. Steps to the next entry of the
 player's 8-deep assignment stack (assnum + 1, wrapped to 0-7) and sets pflags bit 1 ('new
 assignment') so the assignment dispatcher starts it on the next pass. p: the player. No result. */
void assexit(Player *p)
{
    p->assnum = (p->assnum + 1) & 7;    /* add 1 to the assignment index, keep the first 3 bits */
    p->pflags |= 2;                     /* pfna: signal next assignment */
}
