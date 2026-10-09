/* Engine assignment / faceoff: penalty box exit. */
#include "nhl95.h"

/* TakePlayerFromBox (51115) - PC-new: sort object p takes the first roster player of its team (pflags bit 6:
   away; 444h bytes of 39-byte records per team) whose status is 7 (penalty over): he leaves the box (facedir 4,
   SPA 7BFh, pflags bit 5, temp1 5Ah, temp5 = his number), roster status 3 (bench), tmpdst -2. */
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
