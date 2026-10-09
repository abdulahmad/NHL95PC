/* Engine player logic: penalty box entry (93G assboxenter). */
#include "nhl95.h"

/* assboxenter (499D8) - 93G assboxenter: the penalized player skates into the box. Pencntdwn 300; not while flag
   20h. A new assignment (bit 1): temp2 = 8, the box spot temp3 / temp4 = -91h / 6, temp1 = temp5 = 0. Seated
   (temp1 100): once the door (sortobj15) is waiting for him (word_DFFC2 == 100) close it (SPA EA9h, DFFC2 = C8h),
   clear attribute bit 3, frame 165h, facing 2, byte +46h 0, flag 20h with SPA E83h, his energy (tmpde) full, leave
   the assignment and set the box door for his side. Else every 8 frames (temp1): at the spot (y within 4, x gap
   <= 4) snap onto it, stop, SPA 289h, pflags bit 2 and turn a step towards facing 6 (seated at 6); off the spot
   and not seated skate there (SkateToSpot). */
void assboxenter(Player *p)
{
    Pencntdwn = 0x12C;
    if (p->pflags & 0x20) return;
    if (p->pflags & 2) {
        p->pflags &= 0xFD;
        p->temp2 = 8;
        p->temp4 = 6;
        p->temp3 = -0x91;
        p->temp1 = 0;
        p->temp5 = 0;
    }
    if (p->temp1 == 100) {
        if (p->temp1 != word_DFFC2) return;
        word_DFFC2 = 0xC8;
        byte_DFFE2 = 0;
        byte_DFFE0 |= 0x20;
        SetSPA((Player *)sortobj15, 0xEA9);
        p->attribute &= 0xF7;
        p->frame = 0x165;
        p->facedir = 2;
        ((unsigned char *)p)[0x46] = 0;
        p->pflags |= 0x20;
        SetSPA(p, 0xE83);
        p->tmptr->tmpde[p->pnum] = 0x800;
        assexit(p);
        SetBoxDoorObject((p->pflags & 0x40) != 0);
        return;
    }
    if (--p->temp1 < 0) {
        p->temp1 += 8;
        regd1.w = HIWORD(p->Ypos) - p->temp4;
        regd0.w = HIWORD(p->Xpos) - p->temp3;
        if (ABS(regd1.w) <= 4 && regd0.w <= 4) {
            HIWORD(p->Ypos) = p->temp4;
            HIWORD(p->Xpos) = p->temp3;
            p->Yvel = 0;
            p->Xvel = 0;
            SetSPA(p, 0x289);
            p->pflags |= 4;
            if (p->facedir != 6) p->facedir = ((p->facedir < 7 && p->facedir > 2 ? 1 : -1) + p->facedir) & 7;
            if (p->facedir == 6) p->temp1 = 100;
            return;
        }
    }
    if (p->pflags & 4) return;
    regd0.w = p->temp3;
    regd1.w = p->temp4;
    SkateToSpot(p, 0);
}
