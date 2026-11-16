/* Engine display: stepping the replay. */
#define ReplayStep ReplayStep_decl
#define replayplay replayplay_decl
#define Crowd_Noise CrowdNoiseUpdate_decl
#define JoyButtonMap sub_B340B_decl
#include "nhl95.h"
#undef JoyButtonMap
#undef ReplayStep
#undef replayplay
#undef Crowd_Noise

extern unsigned char *replayplay;  /* E03A4: the replay frame being played */
void Crowd_Noise(short step);
int __cdecl JoyButtonMap(int fl);  /* the edge arrow for the side bits */

#define RB(r) (*(unsigned char *)&(r))
#define RSB(r) (*(signed char *)&(r))

/* DRAFT: same size (1,228 bytes); the frame advance and the backward loop take other registers, see
   docs/UNSURE.md (the short fx gives the EXE's sound loads). Owner of the ReplayStep_popx tail
   (DrawRinkSideObjects). Functional fix: the camera stores are `camx = rpl_camx = ...` and `camy = rpl_camy = ...`
   (the EXE stores rpl_camx / rpl_camy first); byte score unchanged (cdiff --all 153 lines). */
/* ReplayStep (67900, PC only): move the replay n frames (80h bytes each) forward or back, wrapping in the
   9600h-byte buffer when it has wrapped (sflags sfwrap) and stopping at its ends (n becomes -1); going forward
   with sound, play each passed frame's two sound effects (bytes 58h / 59h, FFh none). Then unpack the frame:
   17 players' x / y (10 bits, sign-extended) and frame (11 bits, 7FFh none) plus a flag bit, 12 bytes, six
   pairs of nibbles (Fh none), the puck words and nibbles, the camera, the crowd level, ten nibble pairs and
   twenty bytes (FFh none). Update the crowd noise (off at the end or without sound), step back to the frame
   and sort the 17 players by y (SortIndices into rpl_ysort). Result: n, or -1 at an end. */
short ReplayStep(short n, short sound)
{
    int keys[0x11];
    short fx;
    short n0;
    unsigned char *last;
    unsigned char *start;
    short i;

    n0 = n;
    if (n >= 0) {
        last = replayplay;
        while (n >= 1) {
            n--;
            replayplay += 0x80;
            if (replaystart + 0x9600 == replayplay) {
                if (!(sflags & sfwrap)) {
                    n = -1;
                    replayplay -= 0x80;
                    break;
                }
                replayplay = replaystart;
            }
            if (replayplay == recbpr) {
                n = -1;
                replayplay -= 0x80;
                break;
            }
            if (sound && last != replayplay) {
                fx = replayplay[0x58];
                if (fx != 0xFF) sfx(fx);
                fx = replayplay[0x59];
                if (fx != 0xFF) sfx(fx);
            }
        }
    } else {
        last = recbpr;
        start = replaystart;
        while (n < 0) {
            n++;
            if (start == replayplay) {
                if (!(sflags & sfwrap)) {
                    n = -1;
                    break;
                }
                replayplay = start + 0x9600;
            }
            if (replayplay == last) {
                n = -1;
                break;
            }
            replayplay -= 0x80;
        }
    }
    for (i = 0; i < 0x11; i++) {
        regd0.l = *(long *)replayplay;
        regd1.w = regd0.w & 0x3FF;
        replayplay += 4;
        if (HIBYTE(regd1.w) & 2) HIBYTE(regd1.w) |= 0xFC;
        rpl_x[i] = regd1.w;
        regd0.l >>= 10;
        regd1.w = regd0.w & 0x3FF;
        if (HIBYTE(regd1.w) & 2) HIBYTE(regd1.w) |= 0xFC;
        rpl_y[i] = regd1.w;
        regd0.l >>= 10;
        regd1.w = regd0.w & 0x7FF;
        if (regd1.w == 0x7FF) regd1.w = -1;
        rpl_frame[i] = regd1.w;
        rpl_flip[i] = (HIBYTE(regd0.w) & 8) ? 1 : 0;
    }
    for (i = 0; i < 0xC; i++) rpl_jersey[i] = *replayplay++;
    for (i = 0; i < 6; i++) {
        RB(regd0) = *replayplay++;
        RB(regd1) = RB(regd0) & 0xF;
        rpl_pos[i * 2] = RB(regd1) == 0xF ? -1 : RSB(regd1);
        RB(regd1) = (RSB(regd0) >> 4) & 0xF;
        rpl_pos_b1[i * 2] = RB(regd1) == 0xF ? -1 : RSB(regd1);
    }
    rpl_puckz = *(signed char *)replayplay++;
    word_E9FA9 = *(signed char *)replayplay++;
    replayplay += 2;
    RB(regd0) = *replayplay++;
    RB(regd1) = RB(regd0) & 0xF;
    rpl_c1player = RB(regd1) == 0xF ? -1 : RSB(regd1);
    RB(regd1) = (RSB(regd0) >> 4) & 0xF;
    rpl_c2player = RB(regd1) == 0xF ? -1 : RSB(regd1);
    rpl_puckc = *replayplay++;
    RB(regd0) = *replayplay++;
    rpl_pbnum = RB(regd0) & 0xF;
    rpl_pbnum_b1 = (RSB(regd0) >> 4) & 0xF;
    camx = rpl_camx = *(signed char *)replayplay++;
    camy = rpl_camy = *(short *)replayplay;
    replayplay += 2;
    crowdlevel = *(short *)replayplay;
    replayplay += 2;
    for (i = 0; i < 0xA; i++) {
        RB(regd0) = *replayplay++;
        rpl_objstep[i * 2] = RB(regd0) >> 4;
        rpl_objstep_b1[i * 2] = RB(regd0) & 0xF;
    }
    for (i = 0; i < 0x14; i++) {
        regd0.w = *replayplay++;
        if (regd0.w == 0xFF) regd0.w = -1;
        rpl_objframe[i] = regd0.w;
    }
    if (sound && replayplay != recbpr) Crowd_Noise(n0 * 2);
    else CrowdNoiseOff();
    replayplay -= 0x80;
    for (i = 0; i < 0x11; i++) {
        keys[i] = rpl_y[i];
        rpl_ysort[i] = i;
    }
    SortIndices(0x11, keys, rpl_ysort);
    return n;
}

/* the overlay frames (shorts read the -5r way): the markers from CC0B2 (controller 1, 2, the puck carrier) and the
   edge arrows from CC0B8 (one row of eight per controller; d is the direction 1-8, the byte offset summed after
   the call as in the EXE) */
#define MARKFRAME(j) (((short *)((char *)Pencntdwn2 + 2))[j])
#define ARROWFRAME(j, d) (*(short *)((char *)Pencntdwn2 + 6 + (d) * 2 + ((j) << 4)))

/* DrawRinkSideObjects (67DCC, PC only; ends in ReplayStep_popx): DrawRinkOverlays for the replay, from the unpacked
   replay frame (x rpl_x, y rpl_y, frame rpl_frame, flip rpl_flip, jersey rpl_jersey and position
   rpl_pos per object; puck z rpl_puckz; the controlled players rpl_c1player / AC, the carrier rpl_puckc and the
   penalty box counts rpl_pbnum / AF) at the view vx, vy: the penalty box markers, the 18 rink objects
   (rpl_objframe into the photo table, step rpl_objstep) and the two goal-end ones with their backdrops and the door,
   the markers of the controlled players and the carrier in y order with edge arrows, the door, the puck shadow,
   the 17 objects in the y order of the frame (rpl_ysort) with jersey numbers, and the end boards. No result. */
void DrawRinkSideObjects(short vx, short vy)
{
    int ys[3];
    int ord[3];
    short f;
    short x;
    short y;
    short y1;
    short i;
    short k;

    if (camx > -0x10) {
        if (camy < 0x50 && camy > -0x94) {
            for (i = 0; i < rpl_pbnum && i < 3; i++) DrawFrameSprite(0x17E, 0xB3, (i + 3) * -0xB, 0, 0);
        }
        if (camy > -0x4B && camy < 0xB1) {
            i = rpl_pbnum_b1 - 1 < 2 ? rpl_pbnum_b1 - 1 : 2;
            for (; i >= 0; i--) DrawFrameSprite(0x17E, 0xB3, (i + 3) * 0xB, 0, 1);
        }
    }
    for (i = 0; i < 0x12; i++) {
        k = rpl_objframe[i];
        if (k >= 0) {
            k *= 3;
            x = rinkobjdefs[k];
            y = rinkobjdefs[++k];
            f = rinkobjanim[rinkobjdefs[++k] + (signed char)rpl_objstep[i]];
            DrawSprite(photoptrsf[f], x, y, (short)(x > 0xC0), -1, 0);
        }
    }
    for (i = 0x13; i >= 0x12; i--) {
        k = rpl_objframe[i];
        if (k < 0) {
            f = -1;
        } else {
            k *= 3;
            x = rinkobjdefs[k];
            y = rinkobjdefs[++k];
            f = rinkobjanim[rinkobjdefs[++k] + (signed char)rpl_objstep[i]];
        }
        if (f > 0x64 || k < 0) DrawSprite(dword_E0220, 4, (short)(i == 0x12 ? 0x1A5 : 0x12D), 0, (short)(i == 0x13), 0);
        if (f >= 0) DrawSprite(photoptrsf[f], x, y, 0, (short)(i == 0x13), 0);
        if (i == 0x12) {
            DrawSprite(dword_E0230, 4, (short)(i == 0x12 ? 0x1A5 : 0x12D), 0, -1, 0);
        } else {
            f = rpl_frame_e15;
            if (f >= 0x362) DrawFrameSprite(f, rpl_x_e15, rpl_y_e15, 0, 0);
        }
    }
    if (camy < -0xB0) {
        y1 = cliprect_y1;
        SetClipWindow(DrawClipLeft, DrawClipRight, cliprect_y0, 0x244);
    }
    for (i = 0; i < 3; i++) {
        ys[i] = 0;
        ord[i] = i;
    }
    if (rpl_puckc != -1) ys[2] = rpl_y[rpl_puckc];
    if (rpl_c1player >= 0) ys[0] = rpl_y[rpl_c1player];
    if (rpl_c2player >= 0) ys[1] = rpl_y[rpl_c2player];
    SortIndices(3, ys, ord);
    for (k = 0; k < 3; k++) {
        i = ord[k];
        if (i == 2) {
            if (rpl_puckc == -1) continue;
            DrawFrameSprite(MARKFRAME(2), rpl_x[rpl_puckc], rpl_y[rpl_puckc], 0, 0);
            continue;
        }
        f = i ? rpl_c2player : rpl_c1player;
        if (f < 0) continue;
        if (rpl_frame[f] == -1) continue;
        x = rpl_x[f];
        y = rpl_y[f];
        f = 0;
        if (y < 0x140 - (vy + 0xA8)) {
            y = 0x140 - (vy + 0xA8);
            f = 1;
        } else if (y >= 0x140 - vy) {
            y = 0x140 - vy + 1;
            f = 2;
        }
        if (f) {
            if (x >= 0x140 - (0xC0 - vx) - 0xC) {
                x = 0x140 - (0xC0 - vx) - 0xD;
                f |= 8;
            } else if (x < vx - 0xB4) {
                x = vx - 0xB4;
                f |= 4;
            }
        } else {
            if (x >= 0x140 - (0xC0 - vx)) {
                x = 0x140 - (0xC0 - vx) - 1;
                f = 8;
            } else if (x < vx - 0xC0) {
                x = vx - 0xC0;
                f = 4;
            }
        }
        if (f) DrawFrameSprite(ARROWFRAME(i, JoyButtonMap(f)), x, y, f & 8, 0);
        else DrawFrameSprite(MARKFRAME(i), x, y, 0, 0);
    }
    i = 0xF;
    f = rpl_frame_e15;
    if (f >= 0x284 && f <= 0x288) {
        DrawFrameSprite(f, rpl_x[i], rpl_y[i], rpl_x_e15 < 0, 0);
    } else if (f == 0x189 && rpl_puckz > -0x100 && rpl_puckc != 0x10
        || rpl_y[i] >= 0 && f >= 0x22A && f <= 0x237) {
        DrawFrameSprite(f, rpl_x[i], rpl_y[i], 0, 0);
    }
    if (rpl_puckc != 0x10 && rpl_puckz >= 0)
        DrawFrameSprite(rpl_frame_e14, rpl_x_e14, rpl_puckz * 3 / 2 + rpl_y_e14, 0, 0);
    for (k = 0; k < 0x11; k++) {
        i = *(short *)&rpl_ysort[k];
        if (i == 0xF) continue;
        if (i == 0xE) {
            if (rpl_puckc != -1 || rpl_puckz <= 0 || rpl_y[i] >= 0xE8) continue;
            if (rpl_y[i] <= -0xE8 && rpl_y[i] >= -0xF0 && ABS(rpl_x[i]) <= 0x14 && rpl_puckz < 0xD)
                continue;
            DrawFrameSprite(rpl_frame[i], rpl_x[i], rpl_puckz * 3 / 2 + rpl_y[i], 0, 0);
            continue;
        }
        if (i < 0xC && (signed char)rpl_pos[i] < 0) continue;
        if (rpl_frame[i] != -1 && i < 0xC) {
            if (rpl_puckc != -1 && i == rpl_puckc || i == rpl_c1player || i == rpl_c2player || i == dword_ED74C
                || i == replayfollowpl)
                DrawSpriteNumber(rpl_x[i], rpl_y[i], (signed char)rpl_jersey[i], (signed char)rpl_pos[i]);
            else if (shownumbers)
                DrawSpriteNumber(rpl_x[i], rpl_y[i], (signed char)rpl_jersey[i], -1);
        }
        DrawFrameSprite(rpl_frame[i], rpl_x[i], rpl_y[i], (signed char)rpl_flip[i], i > 5);
        if (i == 0xC && rpl_puckc != 0x10) {
            if (ABS(rpl_x_e14) == 6 && rpl_y_e14 == 0xF0
                || rpl_y_e14 >= rpl_y[i] && rpl_puckz >= 0xD && ABS(rpl_x_e14 - rpl_x[i]) < 0x15)
                DrawFrameSprite(rpl_frame_e14, rpl_x_e14, rpl_puckz * 3 / 2 + rpl_y_e14, 0, 0);
        }
    }
    if (rpl_y_e14 <= -0xE8 && rpl_y_e14 >= -0xEC && ABS(rpl_x_e14) <= 0x14 && rpl_puckz >= 0xD)
        DrawFrameSprite(rpl_frame_e14, rpl_x_e14, rpl_puckz * 3 / 2 + rpl_y_e14, 0, 0);
    if (camy < -0xB0) SetClipWindow(DrawClipLeft, DrawClipRight, cliprect_y0, y1);
    if (camy < -0x90) DrawRinkEndArt();
    if (rpl_y_e15 < 0 && rpl_frame_e15 >= 0x22A && rpl_frame_e15 <= 0x237)
        DrawFrameSprite(rpl_frame_e15, rpl_x_e15, rpl_y_e15, 0, 0);
    if (rpl_y_e14 < -0x108 && rpl_puckc == -1 && rpl_puckz >= 0)
        DrawFrameSprite(rpl_frame_e14, rpl_x_e14, rpl_puckz * 3 / 2 + rpl_y_e14, 0, 0);
}
