/* Engine player logic: goalie to the puck. */
#include "nhl95.h"

/* assgoalietopuck (4B5C2) - goalie leaves the net for the puck (93G assignment role): count down the word at +4Ah;
   set flags 2 and 4 of byte +48h, clearing 4 when inside the crease box (x -40..40, |y| C5h..E3h) and 2 when within
   x -48..48 behind y C5h. Leave (assexit) with pflags bit 3 or in a stoppage; nothing while heading to the bench
   (check4bench). A new assignment (bit 1) resets temp1. Every aidef / 4 frames (countdown in byte +27h) re-check:
   leave when the puck is held, when it moves away from p's goal faster than 800h, or when the other team's
   +3Eh dword is under 96h. Else skate to the puck. */
void assgoalietopuck(Player *p)
{
    int x;
    int y;
    int ay;
    short r;
    short vy;

    if (*(short *)((char *)p + 0x4A) > 0) (*(short *)((char *)p + 0x4A))--;
    ((unsigned char *)p)[0x48] |= 6;
    x = p->Xpos >> 16;
    y = p->Ypos >> 16;
    ay = y < 0 ? -y : y;
    y = ay;
    if (x >= -40 && x < 41 && ay >= 0xC5 && ay < 0xE4) ((unsigned char *)p)[0x48] &= 0xFB;
    if (x >= -48 && x < 49 && y >= 0xC5) ((unsigned char *)p)[0x48] &= 0xFD;
    if (p->pflags & 8 || gmode & 1) {
        assexit(p);
        return;
    }
    r = check4bench(p);
    if (r) return;
    if (p->pflags & 2) {
        p->pflags &= 0xFD;
        p->temp1 = r;
    }
    if (--((signed char *)p)[0x27] < 0) {
        ((signed char *)p)[0x27] = p->aidef >> 2;
        if (*puckc >= 0) goto leave;
        if (((p->pflags & 0x80) != 0) ^ (*puckvy < 0)) {
            vy = *puckvy;
            if ((vy < 0 ? -vy : vy) > 0x800) goto leave;
        }
        if (*(int *)((char *)p->optmptr + 0x3E) < 0x96) goto leave;
    }
    skatetopuck(p);
    return;
leave:
    assexit(p);
}
