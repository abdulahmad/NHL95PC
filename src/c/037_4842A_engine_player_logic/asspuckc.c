/* Engine player logic: puck carrier (93G asspuckc). */
#include "nhl95.h"

/* asspuckc (4C6F3) - 93G asspuckc: the puck carrier. Leave (assexit) without the puck or with pflags bit 3; not
   while flag 20h; in a stoppage StopIfFree. A new assignment (bit 1) clears +4Ch, temp1, temp2 = 8, picks a
   random lane temp3 (0-3) and clears threat. Every aioff frames (countdown in byte +27h, reload byte +59h):
   check the opposition (checkob); on a shot on goal within y 70h hand over to assignment 2Eh; else try a line
   change, a shot and a pass (chk4lc / chk4shot / chk4pass), stopping at the first that acts. Then skate to the
   lane point (word_CCA6E / word_CCA70 pair temp3 + 6, or position - 1 with gmode2 bit 7; mirrored by end), picking
   a new random lane when within 12 of it, with asspuckc_chkdir as the evade routine. */
void asspuckc(Player *p)
{
    int d;

    if (*puckc != p->SCnum) {
        assexit(p);
        return;
    }
    if (p->pflags & 0x20) return;
    if (gmode & 1) {
        StopIfFree(p);
        return;
    }
    if (p->pflags & 8) {
        assexit(p);
        return;
    }
    if (p->pflags & 2) {
        p->pflags &= 0xFD;
        *(short *)((char *)p + 0x4C) = 0;
        p->temp1 = 0;
        p->temp2 = 8;
        p->temp3 = randomd0(4);
        threat = 0;
    }
    if (--((signed char *)p)[0x27] < 0) {
        ((signed char *)p)[0x27] = ((signed char *)p)[0x59];
        checkob(p);
        if (shotongoal && (HIWORD(p->Ypos) < 0 ? -(p->Ypos >> 16) : p->Ypos >> 16) < 0x70) {
            assreplace(p, 0x2E);
            return;
        }
        if (chk4lc(p)) return;
        if (chk4shot(p)) return;
        if (chk4pass(p)) return;
    }
    if (gmode2 & 0x80) regd0.w = p->position - 1;
    else regd0.w = p->temp3 + 6;
    regd0.w = regd0.w + regd0.w;
    regd1.w = word_CCA70[regd0.w];
    regd0.w = word_CCA6E[regd0.w];
    if (!(p->pflags & 0x80)) {
        regd0.w = -regd0.w;
        regd1.w = -regd1.w;
    }
    d = p->Xpos >> 16;
    d -= regd0.w;
    if (d < 0) d = -d;
    if (d <= 12) {
        d = p->Ypos >> 16;
        d -= regd1.w;
        if (d < 0) d = -d;
        if (d <= 12) p->temp3 = randomd0(4);
    }
    skateto(p, (void (*)(Player *))asspuckc_chkdir);
}
