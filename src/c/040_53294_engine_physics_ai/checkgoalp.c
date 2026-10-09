/* Engine physics / AI: goal post collision (93G checkgoalp). */
#include "nhl95.h"

#define W(v) (*(int *)((char *)&(v) - 2) >> 16)  /* a word, read as the top half of a dword */

/* checkgoalp (53CE5) - 93G checkgoalp: for a skater (SCnum up to 11) or SCnum 16 at x, y against goal g: the offset
   from the goal (dy = y - g y, dx = x - g x) must be on the near side of the net (net 12: dy + wcradiusy >= -34,
   else dy - wcradiusy < 34) and |dx| - wcradiusx < 64; regd0 = -dy, regd1 = dx. Inside the post ellipse (dx^2 / 4
   and dx^2 / 4 + 2 dy^2 up to 256) and not bumping it (CheckBump, skipped for 16): regd0 / regd1 become the unit
   vector * 256 (vecdist + 1, clamped to -255..255) and the player bounces off it (wallcoll, dword_CCC2C = 1). */
void checkgoalp(Player *p, Player *g, short x, short y)
{
    int d;
    unsigned short len;

    if (p->SCnum > 11 && p->SCnum != 16) return;
    y -= HIWORD(g->Ypos);
    x -= HIWORD(g->Xpos);
    if (g->SCnum == 12) {
        if (y + W(wcradiusy) < -34) return;
    } else {
        if (y - W(wcradiusy) >= 34) return;
    }
    if ((x < 0 ? -x : x) - W(wcradiusx) >= 64) return;
    regd0.w = -y;
    regd1.w = x;
    d = (x * x) >> 2;
    if (d > 256) return;
    if (y * y * 2 + d > 256) return;
    if (p->SCnum != 16 && CheckBump(p, g)) return;
    len = vecdist(x, y) + 1;
    regd0.w = (W(regd0) << 8) / len;
    if (regd0.w > 255) regd0.w = 255;
    if (W(regd0) < -255) regd0.w = -255;
    regd1.w = (W(regd1) << 8) / len;
    if (regd1.w > 255) regd1.w = 255;
    if (W(regd1) < -255) regd1.w = -255;
    dword_CCC2C = 1;
    wallcoll(p);
}
