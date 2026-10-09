/* Engine player logic: defence in the offensive zone (93G assdefo). */
#include "nhl95.h"

/* assdefo (49CDD) - 93G assdefo: a defenceman with his team on the attack. Not while flag 20h or heading to the
   bench (check4bench); in a stoppage StopIfFree. Ignored with pflags bit 3. A new assignment (bit 1) resets temp1
   and temp2 = 8. Every aidef frames (countdown in byte +27h) re-check: back to defence (assignment 2) when the team
   is in tmflags bit 4, when the puck is back past y 53h (p's direction) or held by the other team. Else hold the
   blue line: y 58h (mirrored by end), x 100 to the right for position 2 else to the left, moved to the puck's x
   when on the same side, else halfway; skate there with EvadePC. */
void assdefo(Player *p)
{
    short r;
    int px;
    int x;

    if (p->pflags & 0x20) return;
    r = check4bench(p);
    if (r) return;
    if (gmode & 1) {
        StopIfFree(p);
        return;
    }
    if (p->pflags & 8) return;
    if (p->pflags & 2) {
        p->pflags &= 0xFD;
        p->temp1 = r;
        p->temp2 = 8;
    }
    if (--((signed char *)p)[0x27] < 0) {
        ((signed char *)p)[0x27] = p->aidef;
        if (p->tmptr->tmflags & 0x10) {
            assreplace(p, 2);
            return;
        }
        regd1.w = *pucky;
        if (!(p->pflags & 0x80)) regd1.w = -regd1.w;
        if (regd1.w < 0x53) {
            assreplace(p, 2);
            return;
        }
        if (*puckc >= 0 && (unsigned char)(p->SCnum < 6) ^ (*puckc < 6)) {
            assreplace(p, 2);
            return;
        }
    }
    regd0.w = p->position == 2 ? 100 : -100;
    regd1.w = 0x58;
    if (!(p->pflags & 0x80)) {
        regd0.w = -regd0.w;
        regd1.w = -0x58;
    }
    px = *puckx;
    x = regd0.w;
    if ((px ^ x) >= 0) regd0.w = *puckx;
    else regd0.w = (px >> 1) + x;
    skateto(p, (void (*)(Player *))EvadePC);
}
