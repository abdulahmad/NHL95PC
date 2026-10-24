/* Engine player logic: going to the bench. */
/* DRAFT (10.0 GA, 8 differing, 829 vs 827): no goto (the body before the seated part is one `if (temp1 != 64h)`
   block) and no masks: the y distance in its own short dy gives both swap tests the EXE widening `mov edx, eax /
   and edx, 0FFh`; the count as `d = --p->temp1` puts it in dx as in the EXE. Left: the count's copy for the
   `+= 8` is made before the `test dx, dx / jge` in eax (EXE after it, `mov esi, edx / add esi, 8`), so temp3 is
   loaded into si (EXE cx) and facedir into cx (EXE dx). See docs/UNSURE.md. */
#include "nhl95.h"

/* assbench (4B12C; 93G logic93 / 94G assign94 assbench "player a3 should go to bench", PC version): not while
   locked (pflags bit 5). Seated (temp1 64h): hide him (frame -1), mark him on the bench in the team's tmpdst and
   roster (when not in the box), take the new position (newpos, when newpnum and newpos agree on goalie / skater),
   set up his assignments (Setplass; during a stoppage insert 27h) and bring the new player newpnum on
   (setplayer). Otherwise, at the bench (check4bench) nothing; held (pflags2 bit 4, gmode2 bit 0) he just stops;
   during a stoppage a goalie whose team has no goalie in (tmgoalie FF0xh) and does not pull him late goes to
   assignment 27h. A new assignment (bit 1) picks the bench door (x -A8h, y 41h / -32h by team). When the player
   to come on is himself, he stays (Setplass, newpnum / newpos cleared). Else every 8 ticks (temp1) near the
   door (y within 28h, x within 20h) he turns toward facing 4 gliding in (SPA 289h, goalie 1; x speed -800h)
   and, inside (x within 10h) facing it, sits down: facing 2, SPA 7BFh (goalie D2Dh), locked, temp1 64h. Away from
   it he skates there (EvadePC, none for a goalie or during a stoppage). p: the player. No result. */
void assbench(Player *p)
{
    Team *tm;
    short dy;
    short d;

    if (p->pflags & 0x20) return;
    if (p->temp1 != 0x64) {
        if (check4bench(p)) return;
        if (p->pflags2 & 0x10) {
            StopIfFree(p);
            return;
        }
        if (gmode2 & 1) {
            StopIfFree(p);
            return;
        }
        if ((gmode & 1) && p->position == 0 && (p->tmptr->tmgoalie & 0xFFF0) == 0xFF00
            && !ChkPullGoalieLate((p->pflags & 0x40) != 0)) {
            p->newpnum = p->newpos = -1;
            assreplace(p, 0x27);
            return;
        }
        if (p->pflags & 2) {
            p->pflags &= 0xFD;
            p->temp2 = 8;
            p->temp4 = !(p->pflags & 0x40) ? -0x32 : 0x41;
            p->temp3 = -0xA8;
            p->temp1 = 0;
        }
        if (p->newpnum == p->pnum) {
            p->pflags2 &= 0xFB;
            if ((p->newpnum < 0x19) ^ (p->newpos == 0)) p->position = p->newpos;
            Setplass(p);
            p->newpnum = -1;
            p->newpos = -1;
            return;
        }
        if (p->position == 0) ((unsigned char *)p)[0x48] |= 3;
        d = --p->temp1;
        if (d < 0) {
            p->temp1 += 8;
            dy = HIWORD(p->Ypos) - p->temp4;
            regd0.w = HIWORD(p->Xpos) - p->temp3;
            if ((dy < 0 ? -dy : dy) <= 0x28 && regd0.w <= 0x20) {
                regd1.w = p->position == 0 ? 1 : 0x289;
                SetSPA(p, regd1.w);
                p->pflags |= 4;
                if (p->facedir != 4) p->facedir = (p->facedir < 4 ? 1 : -1) + (*(int *)((char *)&p->facedir - 2) >> 16) & 7;
                p->Yvel = 0;
                p->Xvel = -0x800;
                if (regd0.w > 0x10) return;
                p->Xvel = 0;
                if (p->facedir != 4) return;
                p->Xvel = -0x800;
                p->facedir = 2;
                SetSPA(p, p->position == 0 ? 0xD2D : 0x7BF);
                p->pflags |= 0x20;
                p->temp1 = 0x64;
                return;
            }
        }
        if (p->pflags & 4) return;
        regd0.w = p->temp3;
        regd1.w = p->temp4;
        skateto(p, (gmode & 1) || p->position == 0 ? 0 : (void (*)(Player *))EvadePC);
        return;
    }
    p->frame = -1;
    tm = p->tmptr;
    if (tm->tmpdst[p->pnum] <= 0 && tm->tmpdst[p->pnum] >= -2) {
        tm->tmpdst[p->pnum] = -2;
        tm->tmroster[p->pnum * 0x27] = 3;
    }
    if ((p->newpnum < 0x19) ^ (p->newpos == 0)) p->position = p->newpos;
    Setplass(p);
    if (gmode & 1) {
        p->temp5 = 0;
        assinsert(p, 0x27);
    }
    regd3.w = p->newpnum;
    p->newpnum = -1;
    p->newpos = -1;
    setplayer(p, regd3.w);
}
