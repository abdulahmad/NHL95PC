/* Engine physics AI: pass to a player. */
/* DRAFT (10.0 GA): 48 score differing, 692 vs 708 bytes. The explicit word frame, doubled dot
   product and ternary root calculation give the EXE's frame size and player register.
   The ay / speed registers, velocity sign extensions and some arithmetic temporaries remain. */
#define sub_93470 sub_93470_decl
#include "nhl95.h"
#undef sub_93470

int __cdecl sub_93470(int v);  /* sroot: integer square root */

/* passtoa0 (551CF, 94G passtoa0): pass the puck to p. Count the pass for p's team (not in highlight mode),
   make p the pass target (passplayer) and give p the pass receive assignment (13h). From p's hot spot (GetHot)
   minus the puck, p's velocity in pixels per quarter second and the pass speed (passspeed / 4), solve for the
   time t (in 1/8 s, 1..18h) at which a pass meets p: the square root (sroot) of j * j - 4ak, tried with
   both signs. The puck's height step (puckvz byte 1) is t up to 12, over 6 halved plus a random half; p's
   temp1 high byte is 8t - 10 and pucknopuck that minus 6; regd0 / regd1 and p's temp3 / temp4 get the meeting
   point, and the puck's velocity (puckvx / puckvy) the distance to it over 120t. p: the receiver. No result. */
void passtoa0(Player *p)
{
    struct {
        short vx; short pad_vx;
        short t; short pad_t;
        short j; short pad_j;
        short vy; short pad_vy;
        short dy; short pad_dy;
        short dx; short pad_dx;
        short k; short pad_k;
    } s;
    short ax;
    short ay;
    int sp;
    short n;
    int r;

    if (!(gmode & gmhl)) p->tmptr->tmpass++;
    passplayer = p->SCnum;
    assinsert(p, 0x13);
    GetHot(p);
    s.dx = regd0.w + HIWORD(p->Xpos) - *puckx;
    ax = s.dx >> 2;
    s.dy = regd1.w + HIWORD(p->Ypos) - *pucky;
    ay = s.dy >> 2;
    s.vx = p->Xvel * 0xF0 >> 16;
    s.vy = p->Yvel * 0xF0 >> 16;
    s.j = ((s.vy * ay + s.vx * ax) + (s.vy * ay + s.vx * ax));
    sp = passspeed >> 2;
    s.k = s.vx * s.vx + s.vy * s.vy - sp * sp;
    r = s.j * s.j - (s.k * (ay * ay + ax * ax) << 2);
    r = r > 0 ? sub_93470(r) : r ^ r;
    s.k = s.k >> 2;
    if (!s.k) s.k = 1;
    for (n = 0; n < 2; n++) {
        s.t = r;
        r = -r;
        s.t = (s.t - s.j) / s.k;
        if (s.t >= 0) break;
    }
    if (s.t <= 0) s.t = 1;
    if (s.t > 0x18) s.t = 0x18;
    n = (signed char)(s.t < 0xC ? s.t : 0xC);
    if (n > 6) n = (n + 1) / 2 + randomd0(n / 2);
    ((char *)puckvz)[1] = n;
    ((char *)&p->temp1)[1] = (s.t << 3) - 0xA;
    pucknopuck = ((signed char *)&p->temp1)[1] - 6;
    regd0.l = (s.vx * s.t >> 1) + s.dx;
    p->temp3 = *puckx + regd0.w;
    regd1.l = (s.vy * s.t >> 1) + s.dy;
    p->temp4 = *pucky + regd1.w;
    s.t *= 0x78;
    *puckvx = ToFixed(regd0.l) / s.t;
    *puckvy = ToFixed(regd1.l) / s.t;
}
