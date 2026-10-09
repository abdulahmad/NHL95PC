/* Engine physics / AI: puck shadow (93G puckshadow). */
#include "nhl95.h"

/* puckshadow (56ECF) - place the puck shadow object p: on the puck (one pixel off along the view axis, sflags bit 7)
   when it shows the shadow frame 189h; for the goal-light object (frame set, SPA 7FDh) put it over the goal
   at the puck's end (y 122h, z 0Eh; mirrored with attribute 8000h at the other end). */
void puckshadow(Player *p)
{
    if (p->frame == 0x189) {
        HIWORD(p->Xpos) = *puckx;
        HIWORD(p->Ypos) = *pucky;
        HIWORD(p->Zpos) = 0;
        if (sflags & 0x80) HIWORD(p->Xpos)++;
        else HIWORD(p->Ypos)++;
        return;
    }
    if (p->frame == -1) return;
    if (p->SPA != 0x7FD) return;
    HIWORD(p->Xpos) = 0;
    HIWORD(p->Ypos) = 0x122;
    HIWORD(p->Zpos) = 0xE;
    if (*pucky < 0) {
        ATTRWORD(p) = 0x8000;
        HIWORD(p->Ypos) = -0x10A;
        HIWORD(p->Zpos)--;
    }
}
