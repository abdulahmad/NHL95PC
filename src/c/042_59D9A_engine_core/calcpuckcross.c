/* Engine core: calcpuckcross and the functions that end in its pop/ret tail (multi-block file, see cc.py). */
#include "nhl95.h"

/* calcpuckcross (5A341) - find puck crossing lines: when (if at all) the puck will cross each goal line
   (94G checks94 findpc). For the goal lines y = +E8h and -E8h: puckcross[0] = x where the puck crosses (bounced
   off the side boards at +-A0h), puckcross[1] = frames until it crosses (dy * 1000h / puckvy); [1] = -1 when it
   will not cross (no y velocity, moving away, or out of range). */
void calcpuckcross(void)
{
    short *pc;
    int goaly;
    short side;
    int t;
    int dy;
    short i;
    short x;

    pc = puckcross;
    goaly = 0xE8;                               /* goal line */
    side = 0xA0;                                /* side boards */
    for (i = 0; i < 2; goaly = -goaly, i++, pc += 2) {
        dy = (short)(goaly - *pucky);
        if (*puckvy != 0) {
            t = (dy << 12) / *puckvy;
            if (t >= 0 && t < 0x10000) {
                pc[1] = t;                      /* time until crossing in frames */
                t = *puckvx * dy / *puckvy;
                if (t < 0x10000) {
                    x = t + *puckx;
                    if (x >= 0xA0) x = side * 2 - x;     /* bounce off the side boards */
                    side = -side;
                    if (x <= side) x = side * 2 - x;
                    side = -side;
                    pc[0] = x;
                    continue;
                }
            }
        }
        pc[1] = -1;                             /* no cross */
    }
}

/* GetHot (5A425) - sprite hot spot (stick blade) of player p (94G checks94 GetHot). regd0/regd1 = the x/y bytes
   of the hot spot table (byte_CC148/byte_CC149, 2 bytes per frame) for the player's frame (word 12h, 94G frame;
   PC remaps frames 378h+ by -F4h and 2DAh+ by -46h, frames outside 0-283h/293h give 0,0); x is negated when the
   sprite is X-flipped (attribute bit 3). Draft: also gives the distance that makes reenergizeteam's exit a near
   jump into calcpuckcross's tail, as in the EXE. */
void GetHot(Player *p)
{
    short f;
    short x;

    regd0.w = regd1.w = 0;
    f = p->frame;
    if (f < 0 || f >= 0x468) return;
    if (f >= 0x378) f -= 0xF4;
    else if (f > 0x283) return;
    if (f >= 0x2DA) f -= 0x46;
    else if (f > 0x293) return;
    f += f;
    x = byte_CC148[f];
    regd0.w = x;
    regd1.w = byte_CC149[f];
    if (p->attribute & 8)                       /* X flip */
        regd0.w = -regd0.w;
}

/* reenergizeteam (5B826) - refill the energy of team t's whole roster (93G/94G reenergizeteam, penalty94):
   tmpde = 1000h for every player; a player marked -3 in tmpdst goes to the bench (tmpdst -2, roster status
   byte 3). The 94G skip of players at -4 is not in the PC code. */
void reenergizeteam(Team *t)
{
    short i;
    short *de;

    de = t->tmpde;
    for (i = 0; i < 28; i++) {
        *de++ = ENERGYMAX;                      /* full energy */
        if (t->tmpdst[i] == -3) {
            t->tmpdst[i] = PDbench;             /* on bench */
            t->tmroster[i * 0x27] = 3;          /* roster status: bench */
        }
    }
}

/* setpersonel (5BEF4) - set the personnel of team t (93G setpersonel, 94G collide94 SetPersonel): clear newpos /
   newpnum of the team's 6 sort objects, build PlList (SetPlList: pnum per wanted player, -1 none, the new
   positions at PlList+6 = byte_E038A). Pass 1: a wanted player already on the ice keeps his sort object (newpos
   from the list, newpnum = pnum). Pass 2: each remaining wanted player takes the last free sort object (newpnum
   < 0), stopping at the first one with a position; a sort object without a position (off the ice) first gets
   assignment assbenchwait and position 5. Used entries of PlList are set to -1. */
void setpersonel(Team *t)
{
    Player *p;
    Player *q;
    short i;
    short k;
    short pn;

    i = 6;
    p = t->tmsort;
    do {
        p->newpos = -1;                         /* st newpos(a3) */
        p->newpnum = -1;
        p++;
    } while (--i != 0);
    SetPlList(t);
    i = 5;
    do {                                        /* pass 1: players already on the ice */
        pn = PlList[i];
        if (pn >= 0) {
            p = t->tmsort;
            for (k = 0, p--; k < 6; k++) {
                p++;
                if (p->pnum == pn) {            /* find player pn */
                    p->newpos = byte_E038A[i];
                    p->newpnum = pn;
                    PlList[i] = -1;
                    break;
                }
            }
        }
    } while (--i != (short)-1);
    i = 5;
    do {                                        /* pass 2: the rest take free sort objects */
        pn = PlList[i];
        if (pn >= 0) {
            p = t->tmsort;
            for (k = 0, p--; k < 6; k++) {
                p++;
                if (p->newpnum < 0) {
                    q = p;
                    if (p->position >= 0) break;
                }
            }
            if (q->position < 0) {
                assreplace(q, ASSbenchwait);
                q->position = 5;
            }
            q->newpos = byte_E038A[i];
            q->newpnum = pn;
            PlList[i] = -1;
        }
    } while (--i != (short)-1);
}

/* StartPer (5C010) - start a period (93G hockey93_01 / 94G hockey94 StartPer). PC order: no line change
   request, InitCoachModes, setupice, ResetClock; the controlled player of pad 1 (cont1team 1 home: 2, 2 away:
   8) and pad 2 (the one before pad 1's on the same team); no banner / overlay, no penalty shot, faceoff at
   centre ice (fox = foy = 0, puck assignment puckfaceoff); crowd quiet unless in the regular season (gsp 0);
   gmode2 bit 2, sflags bits 4 (sfwrap) and 6 cleared, replay recording restarts; two DoGameFrame before the
   loop; CwdExciteLvl 10h; sflags3 bit 7 before the playoffs (gsp < 2); puck uncontrolled, camera at 0, fade
   in, rink scroll positions + 3E8h. */
void StartPer(void)
{
    short t1;
    short t2;

    lcrequest[1] = lcrequest[0] = 0;            /* no line change request */
    InitCoachModes();
    dword_E9A9E = 0;
    setupice();
    ResetClock();
    t1 = cont1team;
    if (t1 == 1) c1playernum[0] = 2;            /* home: player 2 */
    else if (t1 == 2) c1playernum[0] = 8;       /* away: player 8 */
    t2 = cont2team;
    if (t2 != 0) {
        if (t2 == cont1team) c2playernum[0] = c1playernum[0] - 1;
        else if (t2 == 1) c2playernum[0] = 2;
        else if (t2 == 2) c2playernum[0] = 8;
    }
    byte_E9AD3 = 0xFF;
    bannermsg = -1;
    bannertimer = 0;
    ovltimer = -1;
    penshotmode = 0;
    penshotlive = 0;
    penshotstart = 0;
    shotontarget = 0;
    shotongoal = 0;
    penshotplayer = -1;
    fox = 0;                                    /* face off at center ice */
    foy = 0;
    assreplace((Player *)puckstruct, ASSpuckfaceoff);
    if (gsp != 0) crowdlevel = 0;
    gmode2 |= 4;
    sflags &= ~0x50;                            /* sfwrap: reset replay stuff */
    recbpr = replaystart;
    ReplayRecordReset();
    lastsfx = -1;
    DoGameFrame();                              /* run two frames before the loop */
    DoGameFrame();
    CwdExciteLvl = 0x10;
    if (gsp < 2) sflags3 |= 0x80;
    *puckc = -1;
    camy = camx = yleader = yc1 = xc1 = 0;
    fadeinpending = 1;
    rinkscrollx += 1000;
    rinkscrolly += 1000;
}
