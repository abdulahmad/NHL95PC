/* Engine player logic: bench scene. */
#include "nhl95.h"

/* assbenchside (49BC2) - the bench-side close-up player: on a new assignment (pflags bit 1, after puckshadow, no speech
   running; overlay timer 100h -> 600) once the camera is at the bench (camx <= -20h, |camy| <= 20) place him at
   (-BEh, 3) at rest, frame 362h, SPA E97h. Then (temp1 < 100) when the SPA ends set temp1 100, during SPA frames
   4+ (count <= 11) step him to x -AFh; at temp1 200 standing (frame 365h, no SPA) a 1 in 40 chance of SPA EB5h. */
void assbenchside(Player *p)
{
    short t;
    int y;

    if (p->pflags & 2) {
        puckshadow(p);
        if (PaSpeechBusy()) return;
        if (ovltimer == 0x100) ovltimer = 600;
        if (camx > -0x20) return;
        if (camy < 0) y = -camy;
        else y = camy;
        if (y > 0x14) return;
        p->pflags &= 0xFD;
        HIWORD(p->Xpos) = -0xBE;
        HIWORD(p->Ypos) = 3;
        p->temp1 = 0;
        p->Xvel = p->Yvel = 0;
        ((unsigned char *)p)[0x46] = 0;
        p->frame = 0x362;
        SetSPA(p, 0xE97);
    }
    t = p->temp1;
    if (t < 100) {
        if (!p->SPA) {
            p->temp1 = 100;
            return;
        }
        if (p->SPAnum >= 4 && p->SPAcnt <= 0xB) HIWORD(p->Xpos) = -0xAF;
        return;
    }
    if (t == 200 && p->frame == 0x365 && !p->SPA && !randomd0(0x28)) SetSPA(p, 0xEB5);
}
