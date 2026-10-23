/* Engine core: functions that share changeplayer's epilogue (changeplayer_ret5), in address order:
 changeplayer, setplayer (5B2C5, jumps to changeplayer_ret5 at 5B821) and DrawRinkOverlays
 (5CE12, jumps at 5D7F2). Unmarked functions here are drafts; see tools/c_functions.csv. */
#define setplayer setplayer_decl
#define sub_B340B sub_B340B_decl
#include "nhl95.h"
#undef setplayer
#undef sub_B340B

void setplayer(Player *p, short n);
/* the team block fields setplayer reads: the skater ratings (20 bytes per skater), the goalie ratings (16 bytes per
   goalie, from roster 19h) and the team data (the power-play, penalty-kill and home / away ratings at +2DCh..+2DFh) */
#define TMSKRAT(t) (*(unsigned char **)((char *)(t) + 0xDE))
#define TMGLRAT(t) (*(unsigned char **)((char *)(t) + 0xE2))
#define TMDATA(t) (*(unsigned char **)((char *)(t) + 0xF2))
typedef union { long l; signed char b; } Reg8;  /* a 68k data register kept on the stack */

/* changeplayer: human control moves to the teammate of p nearest the
 puck's next position (puck + velocity/256). Controller cont (0 = 1, else 2) scans its team's six
 players: on the ice (position > 0), not pflags2 bit 2, not animation locked (pfalock), and not the other
 controller's player; the nearest by squared distance wins (default p->SCnum). If that is the
 controller's own player already, Sweepcheck(p); else restorepl hands the joystick over. */
void changeplayer(Player *p, short cont)
{
    short pick;
    short py;
    short px;
    unsigned long best;
    Player *q;
    short n;
    long dx;
    unsigned long d;

    px = (*puckvx >> 8) + *puckx;
    py = *pucky + (*puckvy >> 8);
    best = 0xFFFFFFFF;
    q = ((cont ? cont2team : cont1team) != 1) ? &SortCords[6] : SortCords;
    pick = p->SCnum;
    n = 6;
    do {
        if (q->position > 0 && !(q->pflags2 & 4) && !(q->pflags & pfalock)) {
            long dy;

            dx = px - HIWORD(q->Xpos);
            dy = py - HIWORD(q->Ypos);
            d = dx * dx + dy * dy;
            if (d <= best) {
                short s;

                s = q->SCnum;
                if (s != (cont ? c1playernum[0] : c2playernum[0])) {
                    best = d;
                    pick = s;
                }
            }
        }
        q++;
    } while (--n);
    if ((cont ? c2playernum[0] : c1playernum[0]) == pick) {
        Sweepcheck(p);
    } else if (!cont) {
        if (pick != c1playernum[0]) c1playernum[0] = restorepl(pick, c1playernum[0]);
    } else {
        if (pick != c2playernum[0]) c2playernum[0] = restorepl(pick, c2playernum[0]);
    }
}

/* setplayer (5B2C5, 93G setplayer; ends in changeplayer_ret5): bring roster player n of p's team onto the ice and
   set its ratings. A player coming from the penalty box (tmpdst >= 0) or the bench (-2) is given the enter
   assignment (0Ah / 9; assinsert) and unlocked; the slot becomes -1 (on the ice) and the roster status 4. Skaters
   get bonuses, 0-2 each: on a power play (gmode2 bit 20h) the team on the advantage side its power-play rating's
   bonus, the other side its penalty-kill rating's minus 2; the home team its home rating, the visitors their away
   rating minus 2; and 2 in the third period's second half or overtime when tied or trailing. The ratings come from
   the team's skater (20 bytes) or goalie (16 bytes) table; leg speed and strength lose up to 3, the bonused ones
   are clamped to 0-15 and the two AI delays become (15 - r + 15) / 2. */
void setplayer(Player *p, short n)
{
    struct { Reg8 u1; Reg8 u0; short n; short pad; Reg8 pk; Reg8 hm; Reg8 pp; Reg8 tp; } rg;
    Team *t;
    unsigned char *td;
    unsigned char *r;
    unsigned char *q;
    short v;
    int d;
    int as;

    rg.n = n;
    p->pflags2 &= 0xBF;
    t = p->SCnum >= 6 ? &awtmstruct : &hmtmstruct;
    p->pnum = rg.n;
    regd1.w = t->tmpdst[rg.n];
    if (regd1.w >= 0) {
        assinsert(p, 0xA);
        p->pflags &= 0xDF;
        p->SPA = 0;
    } else if (regd1.w == -2) {
        assinsert(p, 9);
        p->pflags &= 0xDF;
        p->SPA = 0;
    }
    t->tmpdst[rg.n] = -1;
    t->tmroster[rg.n * 0x27] = 4;
    td = TMDATA(t);
    rg.pp.b = rg.pk.b = rg.tp.b = rg.hm.b = 0;
    if (p->position) {
        if (gmode2 & 0x20) {
            if (((unsigned char)p->pflags & 0x40) ^ (*(short *)&gmode2 & 0x40)) {
                rg.u0.l = (td[0x2DC] > 6 ? 2 : td[0x2DC] >= 4) - 2;
                rg.pk.b = rg.u0.b;
            } else {
                if (td[0x2DD] > 6) rg.u1.l = 2;
                else rg.u1.l = td[0x2DD] >= 4;
                rg.pp.b = rg.u1.b;
            }
        }
        rg.hm.b = !(p->pflags & 0x40) ? (td[0x2DE] > 6 ? 2 : td[0x2DE] >= 4) : (td[0x2DF] > 6 ? 2 : td[0x2DF] >= 4) - 2;
        if (gsp > 2 || gsp == 2 && PerTimeTotal >> 1 > gameclock) {
            short df;

            df = hmscore[0] - awscore;
            if (!df || ((p->pflags & 0x40) == 0) ^ (df > 0)) rg.tp.b = 2;
        }
    }
    *(short *)((char *)p + 0x48) = 0;
    *(short *)((char *)p + 0x4C) = 0;
    *(short *)((char *)p + 0x4A) = 0;
    p->passlane = 0;
    if (rg.n < 0x19) {
        p->rostnum = t->tmroster[rg.n * 0x27 + 5];
        r = TMSKRAT(t) + rg.n * 20;
        p->handed = *r;
        p->attribute &= 0xF7;
        r++;
        if (!p->handed) p->attribute |= 8;
        p->legspd = *r++;
        p->legstr = *r++;
        q = &p->legspd;
        d = p->legspd < 3 ? p->legspd : 3;
        rg.u0.l = *q;
        rg.u0.l -= d;
        *q = rg.u0.b;
        q = &p->legstr;
        d = p->legstr < 3 ? p->legstr : 3;
        rg.u0.l = *q;
        rg.u0.l -= d;
        *q = rg.u0.b;
        p->weight = *r++;
        p->shotspd = *r++;
        v = *r++ + rg.tp.b;
        if (v < 0) v = 0;
        if (v > 15) v = 15;
        p->checking = v;
        v = *r++ + rg.pp.b + rg.pk.b + rg.hm.b;
        if (v < 0) v = 0;
        if (v > 15) v = 15;
        p->stickhand = v;
        v = *r++ + rg.pp.b + rg.pk.b + rg.hm.b;
        if (v < 0) v = 0;
        if (v > 15) v = 15;
        p->shotacc = v;
        r++;
        v = *r++ + rg.pp.b + rg.hm.b;
        if (v < 0) v = 0;
        if (v > 15) v = 15;
        p->passacc = v;
        v = *r++ + rg.pp.b + rg.pk.b + rg.hm.b + rg.tp.b;
        if (v < 0) v = 0;
        if (v > 15) v = 15;
        p->aioff = ((v ^ 0xF) + 0xF) >> 1;
        v = *r++ + rg.hm.b;
        if (v < 0) v = 0;
        if (v > 15) v = 15;
        p->aidef = ((v ^ 0xF) + 0xF) >> 1;
        p->aggress = *r++;
        p->endurance = *r++;
        v = *r + rg.tp.b + rg.tp.b;
        if (v < 0) v = 0;
        if (v > 15) v = 15;
        p->spodds = v;
    } else {
        p->rostnum = t->tmroster[rg.n * 0x27 + 5];
        r = &TMGLRAT(t)[(rg.n - 0x19) * 16];
        p->handed = *r;
        p->attribute &= 0xF7;
        r++;
        if (!p->handed) p->attribute |= 8;
        p->aggress = *r++;
        p->passacc = *r++;
        p->spodds = *r++;
        p->endurance = *r++;
        p->shotspd = *r++;
        p->legspd = *r++;
        p->legstr = *r++;
        q = &p->legspd;
        if (p->legspd < 3) d = p->legspd;
        else d = 3;
        rg.u0.l = *q;
        rg.u0.l -= d;
        *q = rg.u0.b;
        q = &p->legstr;
        d = p->legstr < 3 ? p->legstr : 3;
        rg.u0.l = *q;
        rg.u0.l -= d;
        *q = rg.u0.b;
        p->weight = *r;
        r += 2;
        v = *r++ + rg.pp.b + rg.pk.b + rg.hm.b + rg.tp.b;
        if (v < 0) v = 0;
        if (v > 15) v = 15;
        p->aioff = ((v ^ 0xF) + 0xF) >> 1;
        v = *r + rg.hm.b;
        if (v < 0) v = 0;
        if (v > 15) v = 15;
        p->aidef = ((v ^ 0xF) + 0xF) >> 1;
    }
}

/* the overlay frames (shorts read the -5r way): one marker per tracked object from CC0B2 (controller 1, 2, the
   puck carrier) and the edge arrows from CC0B8 (one row of eight per controller; d is the direction 1-8, the
   byte offset summed after the call as in the EXE) */
#define MARKFRAME(j) (((short *)((char *)word_CC0B0 + 2))[j])
#define ARROWFRAME(j, d) (*(short *)((char *)word_CC0B0 + 6 + (d) * 2 + ((j) << 4)))
#define OOBYTE(i) (*(int *)(OOlist + (i) - 3) >> 24)
int __cdecl sub_B340B(int fl);

/* DRAFT (10.0 GA, 73 differing, same size): the second penalty box clamp as an if / else gives the EXE's slots
   (c1 -14h, c2 -10h, k -0Ch, the clip temporary -8) but not its clamp code (the EXE's ternary result in eax);
   the ternary keeps the clamp and swaps the slots. See docs/UNSURE.md. */
/* DrawRinkOverlays (5CE12, PC only; ends in changeplayer_ret5): draw the rink layer above the objects for the
   view at vx, vy (viewscrollx / viewscrolly). With the penalty boxes in view, a marker per player in each box
   (up to three a side); then DrawRinkObjects. The markers of the two controlled players and the puck carrier,
   in y order (sub_93540): a player off the screen gets an edge arrow (sub_B340B picks it from the edge bits 1 / 2
   bottom / top, 4 / 8 right / left). The penalty box door (sortobj15) and the puck, then the 17 objects in
   OOlist order with their jersey numbers (always for the controlled players and the carrier, else when
   shownumbers is set) and the puck again where it passes in front of the goal; the end boards art (clipped to
   the top 244h lines when the camera is near the end), the text overlay, the call banner (bannertimer counts it
   down) and, for a mouse controller, the pointer arrow beside its player (vtoa of the pointer from the screen
   centre). No result. */
void DrawRinkOverlays(short vx, short vy)
{
    int ys[3];
    int ord[3];
    short y1;
    short k;
    short c2;
    short c1;
    short i;
    short s;
    short x;
    short y;
    short fl;
    Player *q;
    signed char c;
    short z;

    c1 = c1playernum[0];
    c2 = c2playernum[0];
    if (dword_CCC9C) c1 = c2 = -1;
    if (camx > -0x10) {
        if (camy < 0x50 && camy > -0x94) {
            for (i = 0; i < PBnum[0] && i < 3; i++) DrawFrameSprite(0x17E, 0xB3, (i + 3) * -0xB, 0, 0);
        }
        if (camy > -0x4B && camy < 0xB1) {
            if (PBnum[1] - 1 >= 2) i = 2;
            else i = PBnum[1] - 1;
            for (; i >= 0; i--) DrawFrameSprite(0x17E, 0xB3, (i + 3) * 0xB, 0, 1);
        }
    }
    DrawRinkObjects();
    if (camy < -0xB0) {
        y1 = cliprect_y1;
        sub_B4BC4(dword_D30BC, dword_D30C0, cliprect_y0, 0x244);
    }
    for (i = 0; i < 3; i++) {
        ys[i] = 0;
        ord[i] = i;
    }
    c = *puckc;
    if (c >= 0) ys[2] = HIWORD(SortCords[c].Ypos);
    if (c1 >= 0) ys[0] = HIWORD(SortCords[c1].Ypos);
    if (c2 >= 0) ys[1] = HIWORD(SortCords[c2].Ypos);
    sub_93540(3, ys, ord);
    for (k = 0; k < 3; k++) {
        i = ord[k];
        if (i == 2) {
            c = *puckc;
            if (c < 0) continue;
            q = &SortCords[c];
            DrawFrameSprite(MARKFRAME(2), HIWORD(q->Xpos), HIWORD(q->Ypos), 0, 0);
            continue;
        }
        if ((i ? c2 : c1) < 0) continue;
        q = &SortCords[i ? c2 : c1];
        if (q->frame == -1) continue;
        x = HIWORD(q->Xpos);
        y = HIWORD(q->Ypos);
        fl = 0;
        if (y < 0x140 - (vy + 0xA8)) {
            y = 0x140 - (vy + 0xA8);
            fl = 2;
        } else if (y >= 0x140 - vy) {
            y = 0x140 - vy + 1;
            fl = 1;
        }
        if (fl) {
            if (x >= 0x140 - (0xC0 - vx) - 0xC) {
                x = 0x140 - (0xC0 - vx) - 0xD;
                fl |= 4;
            } else if (x < vx - 0xB4) {
                x = vx - 0xB4;
                fl |= 8;
            }
        } else {
            if (x >= 0x140 - (0xC0 - vx)) {
                x = 0x140 - (0xC0 - vx) - 1;
                fl = 4;
            } else if (x < vx - 0xC0) {
                x = vx - 0xC0;
                fl = 8;
            }
        }
        if (fl) DrawFrameSprite(ARROWFRAME(i, sub_B340B(fl)), x, y, fl & 8, 0);
        else DrawFrameSprite(MARKFRAME(i), x, y, 0, 0);
    }
    q = (Player *)sortobj15;
    if (q->frame >= 0x284 && q->frame <= 0x288) {
        DrawFrameSprite(q->frame, HIWORD(q->Xpos), HIWORD(q->Ypos), HIWORD(q->Xpos) < 0, 0);
    } else if (q->frame == 0x189 && *(short *)puckz >= 0 && *puckc != 0x10
        || HIWORD(q->Ypos) >= 0 && q->frame >= 0x22A && q->frame <= 0x237) {
        DrawFrameSprite(q->frame, HIWORD(q->Xpos), HIWORD(q->Ypos), 0, 0);
    }
    if (*puckc != 0x10) {
        q--;
        if (HIWORD(q->Zpos) == 0) DrawFrameSprite(q->frame, HIWORD(q->Xpos), HIWORD(q->Ypos), 0, 0);
        else if (HIWORD(q->Zpos) > 0)
            DrawFrameSprite(q->frame, HIWORD(q->Xpos), HIWORD(q->Zpos) * 3 / 2 + HIWORD(q->Ypos), 0, 0);
    }
    for (i = 0x10; i >= 0; i--) {
        q = &SortCords[OOBYTE(i)];
        s = q->SCnum;
        if (s == 0xF) continue;
        if (s == 0xE) {
            if (*puckc >= 0 || *(short *)puckz <= 0) continue;
            y = *pucky;
            if (y >= 0xE8) continue;
            if (y <= -0xE8 && y >= -0xF0 && ABS(*puckx) <= 0x14 && *(short *)puckz < 0xD) continue;
            DrawFrameSprite(q->frame, HIWORD(q->Xpos), HIWORD(q->Zpos) * 3 / 2 + HIWORD(q->Ypos), 0, 0);
            continue;
        }
        if (q->position < 0 && s != 0x10) continue;
        if (q->frame != -1 && q->SCnum < 0xC) {
            if (*puckc == q->SCnum || q->SCnum == c1 || q->SCnum == c2)
                DrawSpriteNumber(HIWORD(q->Xpos), HIWORD(q->Ypos), q->rostnum, q->position);
            else if (shownumbers)
                DrawSpriteNumber(HIWORD(q->Xpos), HIWORD(q->Ypos), q->rostnum, -1);
        }
        if (q->SCnum < 6) DrawFrameSprite(q->frame, HIWORD(q->Xpos), HIWORD(q->Ypos), (q->attribute & 8) != 0, 0);
        else DrawFrameSprite(q->frame, HIWORD(q->Xpos), HIWORD(q->Ypos), (q->attribute & 8) != 0, 1);
        if (q->SCnum == 0xC && *puckc != 0x10) {
            if (ABS(*puckx) == 6 && *pucky == 0xF0
                || *pucky <= HIWORD(q->Ypos) + 6 && *(short *)puckz >= 0xD && ABS(*puckx - HIWORD(q->Xpos)) < 0x18)
                DrawFrameSprite(((Player *)puckstruct)->frame, *puckx, *pucky + *(short *)puckz * 3 / 2, 0, 0);
        }
    }
    if (*pucky <= -0xE8 && *pucky >= -0xEC && ABS(*puckx) <= 0x14 && (z = *(short *)puckz) >= 0xD)
        DrawFrameSprite(((Player *)puckstruct)->frame, *puckx, z * 3 / 2 + *pucky, 0, 0);
    if (camy < -0xB0) sub_B4BC4(dword_D30BC, dword_D30C0, cliprect_y0, y1);
    if (camy < -0x90) DrawRinkEndArt();
    q = (Player *)sortobj15;
    if (HIWORD(q->Ypos) < 0 && q->frame >= 0x22A && q->frame <= 0x237)
        DrawFrameSprite(q->frame, HIWORD(q->Xpos), HIWORD(q->Ypos), 0, 0);
    if (*pucky < -0x108 && *puckc < 0) {
        q = (Player *)puckstruct;
        if (HIWORD(q->Zpos) == 0) DrawFrameSprite(q->frame, HIWORD(q->Xpos), HIWORD(q->Ypos), 0, 0);
        else if (HIWORD(q->Zpos) > 0)
            DrawFrameSprite(q->frame, HIWORD(q->Xpos), HIWORD(q->Zpos) * 3 / 2 + HIWORD(q->Ypos), 0, 0);
    }
    if (ovltimer >= 0) DrawTextOverlay();
    if (bannermsg != -1) {
        DrawCallBanner();
        if (bannertimer > 0 && --bannertimer <= 0) {
            bannertimer = 0;
            bannermsg = -1;
        }
    }
    if ((pad1dev[0] == 1 || pad2dev == 1) && curperiod != -1 && !dword_CCC9C) {
        i = pad1dev[0] == 1 ? c1 : c2;
        if (i != -1) {
            if ((mousex - 0xA0) * (mousex - 0xA0) + (mousey - 0x64) * (mousey - 0x64) < 0x9C4) {
                x = y = 0;
                fl = 8;
            } else {
                fl = vtoa((short)(mousex - 0xA0), (short)(0x64 - mousey));
                x = mousex - 0xA0;
                x /= 4;
                y = (0x64 - mousey) / 4;
            }
            x += HIWORD(SortCords[i].Xpos);
            y += HIWORD(SortCords[i].Ypos);
            DrawFrameSprite(dword_CCD4F[fl] >> 16, x, y, fl > 4 && fl < 8 ? 1 : 0, 0);
        }
    }
}
