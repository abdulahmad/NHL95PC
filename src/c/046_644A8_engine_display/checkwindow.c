/* Engine display: the camera window and the overlay text that ends in its pops. */
#define LoadTeamPPV LoadTeamPPV_decl
#define UpdateTextOverlay UpdateTextOverlay_decl
#define DrawCallBanner DrawCallBanner_decl
#define sub_90354 sub_90354_decl
#define sub_90EC0 sub_90EC0_decl
#define sub_B500C sub_B500C_decl
#define sub_6AB7C sub_6AB7C_decl
#include "nhl95.h"
#undef LoadTeamPPV
#undef UpdateTextOverlay
#undef DrawCallBanner
#undef sub_90354
#undef sub_90EC0
#undef sub_B500C
#undef sub_6AB7C

int __cdecl sub_90354(int bank);
void __cdecl sub_90EC0(int x, int y, int w, int h, int c);  /* graphics library: save a rectangle */
void __cdecl sub_B500C(int art, int x, int y);              /* graphics library: draw art */
void sub_6AB7C(int n, int x0, int y0, int x1, int y1);      /* mark a dirty rectangle */

#define ABSW(v) ((v) < 0 ? -(v) : (v))

/* checkwindow owns the pop / ret tail (checkwindow_popebp / checkwindow_popx, which LoadTeamPPV,
   UpdateTextOverlay, DrawCallBanner and DrawTextOverlay use). The chained stores follow the EXE's store order
   (regd3 / regd2 after xc1 / yc1 in the highlight branch and at the faceoff dot, before them elsewhere); the
   catch-up is an if / else of two stores (the EXE then compares regd1 in memory), and the y shift is
   `fast ? 3 : 4` (an int count). */
/* checkwindow (65D01, 93G checkwindow): move the camera (camx / camy) toward the point it follows (xc1 / yc1,
   kept in regd3 / regd2). In highlight mode (gmode bit 7) that is a fixed point (-100, 15) with a slow pan. While
   the clock runs: during a penalty count-down or a referee step, follow the referee (object 10h) toward its
   target (temp3 / temp4) and lock onto the faceoff dot (fox / foy) when it is skating to it and close; otherwise
   follow the puck carrier (or the puck) plus the lead yleader, which grows by 2 toward the attacked end up to
   +-32h (the referee's carrier sets it from his Y speed), with a faster catch-up (fast) when the carrier skates
   hard. The camera moves when the point leaves a margin (0Ah / 28h, none at the faceoff), at most 20h per step
   (y only when gmode bit 0 is set), by an eighth or sixteenth of the gap (y, by the speed) or a sixteenth (x),
   at least 1. No arguments, no result. */
void checkwindow(void)
{
    short xm;
    short ym;
    short fast;
    Player *p;
    int dx;
    int dy;

    xm = 0x28;
    ym = 0xA;
    fast = 0;
    regd2.w = yc1;
    regd3.w = xc1;
    if (gmode & 0x80) {
        regd3.w = xc1 = -100;
        regd2.w = yc1 = 0xF;
        ym = 5;
        regd0.w = 0xF - camy;
        if (regd0.w < -5) regd1.w = 0x14;
        else if (regd0.w > ym) regd1.w = 0xA;
        if (ABSW(regd0.w) > ym) {
            regd1.w -= camy;
            if (ABSW(regd1.w) > 0x20) regd1.w = regd1.w < 0 ? -0x20 : 0x20;
            if (regd1.w) {
                regd1.w >>= 5;
                if (!regd1.w) regd1.w = 1;
                camy += regd1.w;
            }
        }
        regd0.w = regd3.w - camx;
        if (regd0.w < -xm) {
            regd1.w = regd3.w + xm;
            if (regd1.w < -0x20) regd1.w = -0x20;
        } else if (xm < regd0.w) {
            regd1.w = regd3.w - xm;
            if (regd1.w > 0x20) regd1.w = 0x20;
        } else return;
        regd1.w -= camx;
        if (ABSW(regd1.w) > 0x20) regd1.w = regd1.w < 0 ? -0x20 : 0x20;
        if (!regd1.w) return;
        regd1.w >>= 5;
        if (!regd1.w) regd1.w = 1;
        camx += regd1.w;
        return;
    }
    if (gameclock || clockticks[0]) {
        if ((gmode & 4) && Pencntdwn < 0 || RefStep[0] > 0) {
            p = &SortCords[0x10];
            xc1 = HIWORD(p->Xpos);
            yc1 = word_E0022;
            regd2.w = xc1 - camx;
            regd3.w = word_E0046 - camx;
            if ((regd2.w ^ regd3.w) < 0) xc1 = camx;
            else if (ABSW(regd2.w) > ABSW(regd3.w)) xc1 = p->temp3;
            regd2.w = yc1 - camy;
            regd3.w = p->temp4 - camy;
            if ((regd2.w ^ regd3.w) < 0) yc1 = regd2.w = camy;
            else if (ABSW(regd2.w) > ABSW(regd3.w)) yc1 = regd2.w = p->temp4;
            else regd2.w = yc1;
            regd3.w = xc1;
            dx = HIWORD(p->Xpos) - fox;
            dy = HIWORD(p->Ypos) - foy;
            if (p->asslist[p->assnum] == 0x22 || p->asslist[p->assnum] == 0x2C) {
                if (dx * dx + dy * dy < 0x640) {
                    regd2.w = yc1 = foy;
                    regd3.w = xc1 = fox;
                    xm = ym = 0;
                }
            }
        } else if (!(sflags & 0x40)) {
            if (*puckc >= 0) {
                p = &SortCords[*puckc];
                regd0.w = 2;
                if (p->SCnum == 0x10) {
                    yleader = -(p->Yvel >> 8);
                } else if (p->pflags & 0x80) {
                    fast = p->Yvel < -100;
                    yleader += regd0.w;
                    if (yleader >= 0x32) yleader = 0x32;
                } else {
                    fast = p->Yvel > 100;
                    yleader -= regd0.w;
                    if (yleader <= -0x32) yleader = -0x32;
                }
            } else {
                p = (Player *)puckstruct;
            }
            yc1 = regd2.w = HIWORD(p->Ypos) + (p->Yvel >> 8) + yleader;
            xc1 = regd3.w = HIWORD(p->Xpos);
        }
    }
    regd0.w = regd2.w - camy;
    if (regd0.w < -ym) {
        regd1.w = regd2.w + ym;
        if (regd1.w < -0xBC) regd1.w = -0xBC;
    } else if (ym < regd0.w) {
        if (fast) regd1.w = regd2.w;
        else regd1.w = regd2.w - ym;
        if (regd1.w > 0xEC) regd1.w = 0xEC;
    }
    if (ABSW(regd0.w) > ym) {
        regd1.w -= camy;
        if ((gmode & 1) && ABSW(regd1.w) > 0x20) regd1.w = regd1.w < 0 ? -0x20 : 0x20;
        if (regd1.w) {
            regd1.w >>= fast ? 3 : 4;
            if (!regd1.w) regd1.w = 1;
            camy += regd1.w;
        }
    }
    regd0.w = regd3.w - camx;
    if (regd0.w < -xm) {
        regd1.w = regd3.w + xm;
        if (regd1.w < -0x20) regd1.w = -0x20;
    } else if (xm < regd0.w) {
        regd1.w = regd3.w - xm;
        if (regd1.w > 0x20) regd1.w = 0x20;
    } else return;
    regd1.w -= camx;
    if (ABSW(regd1.w) > 0x20) regd1.w = regd1.w < 0 ? -0x20 : 0x20;
    if (!regd1.w) return;
    regd1.w >>= 4;
    if (!regd1.w) regd1.w = 1;
    camx += regd1.w;
}

/* LoadTeamPPV (66497, PC only; ends in checkwindow_popebp): start overlay sequence seq when enough memory is free
   (sub_8DAB8 against dword_CD4B0[seq]): with the joystick sampling off, load its PPV art bank (off_CBED0, from the
   CD when fileoncd says so) into dword_E0244 and its frames ("%04d") into dword_DEF8C, then set the overlay
   state: ovlseq, its script (off_CC01D), the first step's timer (word_CC054), step index 1 and the first step.
   seq: the overlay. No result. */
void LoadTeamPPV(short seq)
{
    char name[0x10];
    int i;

    if (sub_8DAB8() < dword_CD4B0[seq]) return;
    joysampling_save = joysampling;
    joysampling = 0;
    MakePath(name, fileoncd[dword_CC080[seq]] == 1 ? (char *)cddriveptr : 0, (char *)off_CBED0[seq], (char *)str_PPV);
    dword_E0244 = sub_8E8A0(name, 0x20);
    for (i = 0; i < sub_90354(dword_E0244); i++) {
        sprintf(name, (char *)str_04d2, i);
        dword_DEF8C[i] = sub_B30B4(dword_E0244, name);
    }
    joysampling = joysampling_save;
    ovlseq = seq;
    ovlscript = off_CC01D[seq];
    ovlsteptimer = ((int *)word_CC054)[seq];
    ovlstepidx = 1;
    ovlstep = ((signed char *)ovlscript)[1];
}

/* DrawTextOverlay (665AD, PC only; ends in checkwindow_popebp): draw the overlay box in the top left of the view
   (moved right during the shootout, gsp 4). ovltimer slides it: under 10h it grows from the corner (the clip
   window shrinks to the box, k = timer, 42h / 2Ah * k / 16) and from 258h it shrinks again. The banner is cut
   (bannermsg -1). The box is saved and dithered (sub_90EC0, DitherRect 9) while it slides or without an overlay
   script; once 3Eh wide it gets a black frame. With a script (ovlseq / ovlstep), the step art (dword_DEF8C) is
   drawn, for sequence 0Ah after step 10h over dword_DF004 and for sequence 8 steps 12h-14h below dword_DEFE0; at
   sequence 0 step 2 the crowd meter: up to three bars (30h, 27h, 60h) from crowdlevel over 2EEh, 3B6h and 47Eh.
   Without one, the text lines 3, 1, 2, 4, 5 centred, line spacing by how many there are, twice (scor3font in 25h,
   then scor2font in 27h). Then the box is marked for redraw (sub_6AB7C). No arguments, no result. */
void DrawTextOverlay(void)
{
    short w;
    short y0s;
    short x2;
    short x0s;
    short y;
    short y1s;
    short h;
    short x1s;
    short y2;
    short x;
    short d;

    if (ovltimer < 0x10) d = ovltimer - 0x10;
    else if (ovltimer <= 0x100) d = 0;
    else if (ovltimer >= 0x258) d = 0x258 - ovltimer;
    bannermsg = -1;
    bannertimer = 0;
    if (d < 0) {
        int k;

        k = d + 0x10;
        w = k * 0x42 / 16;
        h = k * 0x2A / 16;
        x0s = cliprect_x0;
        x1s = cliprect_x1;
        y0s = cliprect_y0;
        y1s = cliprect_y1;
        x = scrollx + 0x4A - w;
        if (gsp == 4) x += 0xAC;
        x2 = w + (w + x);
        y = scrolly + 0x32 - h;
        y2 = (y + h) + h;
        x += (short)((short)cliprect_x0 - scrollx);
        x2 += (short)((short)cliprect_x0 - scrollx);
        y += (short)((short)cliprect_y0 - scrolly);
        y2 += (short)((short)cliprect_y0 - scrolly);
        sub_B4BC4(x, x2, y, y2);
    }
    x = scrollx + 0xC;
    if (gsp == 4) x += 0xAC;
    y = scrolly + 0xC;
    x2 = x + 0x7B;
    y2 = scrolly + 0x57;
    x += (short)((short)cliprect_x0 - scrollx);
    x2 += (short)((short)cliprect_x0 - scrollx);
    y += (short)((short)cliprect_y0 - scrolly);
    y2 += (short)((short)cliprect_y0 - scrolly);
    if (d < 0 || ovlseq == -1 || ovlstep == -1) {
        sub_90EC0(x, y, x2 - x, y2 - y, 0x10);
        DitherRect(x, y, x2 - x, y2 - y, 9);
    }
    if (d == 0 || w >= 0x3E) {
        sub_90D20(x - 4, y - 4, 0x83, 4, 0);
        sub_90D20(x - 4, y, 4, 0x4B, 0);
        sub_90D20(x2, y, 4, 0x4B, 0);
        sub_90D20(x - 4, y2, 0x83, 4, 0);
    }
    if (d < 0) {
        sub_B4BC4(x0s, x1s, y0s, y1s);
    } else if (ovlseq != -1 && ovlstep != -1) {
        if (ovlseq == 0xA && ovlstep > 0x10) {
            sub_B500C(dword_DF004, x, y);
            sub_B500C(dword_DEF8C[ovlstep], x + 0x11, y + 0x1F);
        } else if (ovlseq == 8 && ovlstep >= 0x12 && ovlstep <= 0x14) {
            sub_B500C(dword_DEFE0, x, y);
            sub_B500C(dword_DEF8C[ovlstep], x, y + 0x3C);
        } else {
            sub_B500C(dword_DEF8C[ovlstep], x, y);
        }
        if (ovlseq == 0 && ovlstep == 2) {
            y += 0x23;
            if (crowdlevel > 0x2EE) {
                w = crowdlevel - 0x2EE < 0xC8 ? crowdlevel - 0x2EE : 0xC8;
                w /= 5;
                DitherRect(x, y, w, y2 - y, 0x30);
            }
            if (crowdlevel > 0x3B6) {
                x += 0x28;
                w = crowdlevel - 0x3B6 < 0xC8 ? crowdlevel - 0x3B6 : 0xC8;
                w /= 5;
                DitherRect(x, y, w, y2 - y, 0x27);
            }
            if (crowdlevel > 0x47E) {
                x += 0x28;
                w = crowdlevel - 0x47E < 0xD7 ? crowdlevel - 0x47E : 0xD7;
                w /= 5;
                DitherRect(x, y, w, y2 - y, 0x60);
            }
        }
    } else {
        if (textline5) {
            h = 0xD;
            y += 8;
        } else if (textline4) {
            h = 0xF;
            y += 0xB;
        } else {
            h = 0x12;
            y += 0xF;
        }
        x += 0x3E;
        sub_8EA18(scor3font);
        sub_8E9C0(0x25, 0xFF);
        d = y;
        if (textline3) sub_91964((char *)&textline3, x - fputchar((char *)&textline3) / 2, y);
        if (textline1) {
            d += h;
            sub_91964((char *)&textline1, x - fputchar((char *)&textline1) / 2, d);
        }
        if (textline2) {
            d += h;
            sub_91964((char *)&textline2, x - fputchar((char *)&textline2) / 2, d);
        }
        if (textline4) {
            d += h;
            sub_91964((char *)&textline4, x - fputchar((char *)&textline4) / 2, d);
        }
        if (textline5) {
            d += h;
            sub_91964((char *)&textline5, x - fputchar((char *)&textline5) / 2, d);
        }
        sub_8EA18(scor2font);
        sub_8E9C0(0x27, 0xFF);
        d = y;
        if (textline3) sub_91964((char *)&textline3, x - fputchar((char *)&textline3) / 2, y);
        if (textline1) {
            d += h;
            sub_91964((char *)&textline1, x - fputchar((char *)&textline1) / 2, d);
        }
        if (textline2) {
            d += h;
            sub_91964((char *)&textline2, x - fputchar((char *)&textline2) / 2, d);
        }
        if (textline4) {
            d += h;
            sub_91964((char *)&textline4, x - fputchar((char *)&textline4) / 2, d);
        }
        if (textline5) {
            d += h;
            sub_91964((char *)&textline5, x - fputchar((char *)&textline5) / 2, d);
        }
    }
    x = (short)cliprect_x0 + 8;
    if (gsp == 4) x += 0xAC;
    y = (short)cliprect_y0 + 8;
    sub_6AB7C(spritedrawcount++, x, y, x + 0x83, y + 0x53);
}

/* UpdateTextOverlay (66E06, PC only; ends in checkwindow_popx): run the overlay once per frame while ovltimer is
   running (not during a penalty shot's count-down 100h-140h before the game ends). Overlay 0 raises the crowd in
   its first steps. At timer 10h step through the script: when a step's timer runs out, the next step, or at the
   script's end free the art (and for some overlays show the text at 258h) and clear the overlay. Otherwise the
   timer counts up (not between 100h and 257h) and past 268h stops and clears the five text lines. No arguments,
   no result. */
void UpdateTextOverlay(void)
{
    signed char *s;

    if (ovltimer < 0) return;
    if (Pencntdwn >= 0x100 && Pencntdwn <= 0x140 && !(gmode & 0x40)) return;
    if (ovlseq == 0 && ovlstep < 5 && crowdlevel < 0x5DC) {
        if (ovlstepidx == 1 && crowdlevel < 0x280) crowdlevel = 0x280;
        if (ovlstepidx >= 1 && ovlstepidx < 5 || ovlstepidx > 7 && ovlstepidx < 0xD || ovlstepidx > 0x10)
            crowdlevel += 8;
    }
    if (ovltimer == 0x10 && ovlseq != -1 && ovlscript) {
        if (--ovlsteptimer >= 0) return;
        s = (signed char *)ovlscript;
        if (*s == ovlstepidx) {
            FreeMemBlock(dword_E0244);
            if (byte_CC049[ovlseq]) ovltimer = 0x258;
            ovlseq = ovlstep = -1;
            ovlscript = 0;
            return;
        }
        ovlstepidx++;
        ovlstep = s[ovlstepidx];
        ovlsteptimer = ((int *)word_CC054)[ovlseq];
        return;
    }
    if (ovltimer < 0x100 || ovltimer >= 0x258) ovltimer++;
    if (ovltimer > 0x268) {
        ovltimer = -1;
        textline3 = textline1 = textline2 = textline4 = textline5 = 0;
    }
}

/* DrawCallBanner (66FE2, PC only; ends in checkwindow_popebp): draw call banner n (bannerstrs[n], in the SCOR3
   font) near the bottom left of the view (scrollx + 0Ch, scrolly + 95h, moved into the clip window): a dark box
   (colour 10h, dithered with 9) as wide as the text plus 4 and 9 high with a black border of 4, the text in
   colour 25h, then again in the SCOR2 font in colour 27h, and record the box as a drawn sprite (sub_6AB7C,
   spritedrawcount). n: the banner. No result. */
void DrawCallBanner(short n)
{
    short y2;
    short x2;
    short y;
    short d;
    short x;
    short w;

    x = scrollx + 0xC;
    y = scrolly + 0x95;
    y2 = scrolly + 0x9E;
    sub_8EA18(scor3font);
    w = fputchar((char *)bannerstrs[n]) + 4;
    x2 = w + x;
    d = cliprect_x0 - scrollx;
    x += d;
    x2 += d;
    d = cliprect_y0 - scrolly;
    y += d;
    y2 += d;
    w += 8;
    sub_90D20(x, y, x2 - x, y2 - y, 0x10);
    DitherRect(x, y, x2 - x, y2 - y, 9);
    sub_90D20(x - 4, y - 4, w, 4, 0);
    sub_90D20(x - 4, y, 4, 9, 0);
    sub_90D20(x2, y, 4, 9, 0);
    sub_90D20(x - 4, y2, w, 4, 0);
    sub_8E9C0(0x25, 0xFF);
    x2 = x + 2;                     /* x2 is free now: the text x of both passes */
    y2 = y + 1;
    sub_91964((char *)bannerstrs[n], x2, y2);
    sub_8EA18(scor2font);
    sub_8E9C0(0x27, 0xFF);
    sub_91964((char *)bannerstrs[n], x2, y2);
    x -= 4;
    y -= 4;
    sub_6AB7C(spritedrawcount++, x, y, x + w, y + 0x11);
}
