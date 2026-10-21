/* Engine display: stepping the replay. */
#define ReplayStep ReplayStep_decl
#define replayplay replayplay_decl
#define CrowdNoiseUpdate CrowdNoiseUpdate_decl
#define sub_B340B sub_B340B_decl
#include "nhl95.h"
#undef sub_B340B
#undef ReplayStep
#undef replayplay
#undef CrowdNoiseUpdate

extern unsigned char *replayplay;  /* E03A4: the replay frame being played */
void CrowdNoiseUpdate(short step);
int __cdecl sub_B340B(int fl);  /* the edge arrow for the side bits */

#define RB(r) (*(unsigned char *)&(r))
#define RSB(r) (*(signed char *)&(r))

/* DRAFT: 1217 vs 1230, 274 of 308 instructions; see docs/UNSURE.md. Owner of the ReplayStep_popx tail
   (DrawRinkSideObjects). */
/* ReplayStep (67900, PC only): move the replay n frames (80h bytes each) forward or back, wrapping in the
   9600h-byte buffer when it has wrapped (sflags sfwrap) and stopping at its ends (n becomes -1); going forward
   with sound, play each passed frame's two sound effects (bytes 58h / 59h, FFh none). Then unpack the frame:
   17 players' x / y (10 bits, sign-extended) and frame (11 bits, 7FFh none) plus a flag bit, 12 bytes, six
   pairs of nibbles (Fh none), the puck words and nibbles, the camera, the crowd level, ten nibble pairs and
   twenty bytes (FFh none). Update the crowd noise (off at the end or without sound), step back to the frame
   and sort the 17 players by y (sub_93540 into dword_E9FF0). Result: n, or -1 at an end. */
short ReplayStep(short n, short sound)
{
    int keys[0x11];
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
                if (replayplay[0x58] != 0xFF) sfx(replayplay[0x58]);
                if (replayplay[0x59] != 0xFF) sfx(replayplay[0x59]);
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
        word_E9F18[i] = regd1.w;
        regd0.l >>= 10;
        regd1.w = regd0.w & 0x3FF;
        if (HIBYTE(regd1.w) & 2) HIBYTE(regd1.w) |= 0xFC;
        word_E9F3A[i] = regd1.w;
        regd0.l >>= 10;
        regd1.w = regd0.w & 0x7FF;
        if (regd1.w == 0x7FF) regd1.w = -1;
        word_E9F5C[i] = regd1.w;
        byte_E9F7E[i] = (HIBYTE(regd0.w) & 8) != 0;
    }
    for (i = 0; i < 0xC; i++) byte_E9F8F[i] = *replayplay++;
    for (i = 0; i < 6; i++) {
        RB(regd0) = *replayplay++;
        RB(regd1) = RB(regd0) & 0xF;
        byte_E9F9B[i * 2] = RB(regd1) == 0xF ? -1 : RSB(regd1);
        RB(regd1) = (RSB(regd0) >> 4) & 0xF;
        byte_E9F9C[i * 2] = RB(regd1) == 0xF ? -1 : RSB(regd1);
    }
    word_E9FA7 = *(signed char *)replayplay++;
    word_E9FA9 = *(signed char *)replayplay++;
    replayplay += 2;
    RB(regd0) = *replayplay++;
    RB(regd1) = RB(regd0) & 0xF;
    byte_E9FAB = RB(regd1) == 0xF ? -1 : RSB(regd1);
    RB(regd1) = (RSB(regd0) >> 4) & 0xF;
    byte_E9FAC = RB(regd1) == 0xF ? -1 : RSB(regd1);
    byte_E9FAD = *replayplay++;
    RB(regd0) = *replayplay++;
    byte_E9FAE = RB(regd0) & 0xF;
    byte_E9FAF = (RSB(regd0) >> 4) & 0xF;
    word_E9FB0 = camx = *(signed char *)replayplay++;
    word_E9FB2 = camy = *(short *)replayplay;
    replayplay += 2;
    crowdlevel = *(short *)replayplay;
    replayplay += 2;
    for (i = 0; i < 0xA; i++) {
        RB(regd0) = *replayplay++;
        byte_E9FDC[i * 2] = RB(regd0) >> 4;
        byte_E9FDD[i * 2] = RB(regd0) & 0xF;
    }
    for (i = 0; i < 0x14; i++) {
        regd0.w = *replayplay++;
        if (regd0.w == 0xFF) regd0.w = -1;
        word_E9FB4[i] = regd0.w;
    }
    if (sound && replayplay != recbpr) CrowdNoiseUpdate(n0 * 2);
    else CrowdNoiseOff();
    replayplay -= 0x80;
    for (i = 0; i < 0x11; i++) {
        keys[i] = word_E9F3A[i];
        dword_E9FF0[i] = i;
    }
    sub_93540(0x11, keys, dword_E9FF0);
    return n;
}

/* the overlay frames (shorts read the -5r way): the markers from CC0B2 (controller 1, 2, the puck carrier) and the
   edge arrows from CC0B8 (one row of eight per controller) */
#define MARKFRAME(j) (((short *)((char *)word_CC0B0 + 2))[j])
#define ARROWFRAME(j, d) (((short (*)[8])((char *)word_CC0B0 + 8))[j][d])

/* DrawRinkSideObjects (67DCC, PC only; ends in ReplayStep_popx): DrawRinkOverlays for the replay, from the unpacked
   replay frame (x word_E9F18, y word_E9F3A, frame word_E9F5C, flip byte_E9F7E, jersey byte_E9F8F and position
   byte_E9F9B per object; puck z word_E9FA7; the controlled players byte_E9FAB / AC, the carrier byte_E9FAD and the
   penalty box counts byte_E9FAE / AF) at the view vx, vy: the penalty box markers, the 18 rink objects
   (word_E9FB4 into the photo table, step byte_E9FDC) and the two goal-end ones with their backdrops and the door,
   the markers of the controlled players and the carrier in y order with edge arrows, the door, the puck shadow,
   the 17 objects in the y order of the frame (dword_E9FF0) with jersey numbers, and the end boards. No result. */
void DrawRinkSideObjects(short vx, short vy)
{
    int ys[3];
    int ord[3];
    short f;
    short x;
    short y1;
    short y;
    short i;
    short k;

    if (camx > -0x10) {
        if (camy < 0x50 && camy > -0x94) {
            for (i = 0; i < byte_E9FAE && i < 3; i++) DrawFrameSprite(0x17E, 0xB3, (i + 3) * -0xB, 0, 0);
        }
        if (camy > -0x4B && camy < 0xB1) {
            i = byte_E9FAF - 1 < 2 ? byte_E9FAF - 1 : 2;
            for (; i >= 0; i--) DrawFrameSprite(0x17E, 0xB3, (i + 3) * 0xB, 0, 1);
        }
    }
    for (i = 0; i < 0x12; i++) {
        k = word_E9FB4[i];
        if (k >= 0) {
            k *= 3;
            x = word_CCEF8[k];
            y = word_CCEF8[++k];
            f = byte_CCE00[word_CCEF8[++k] + (signed char)byte_E9FDC[i]];
            DrawSprite(photoptrsf[f], x, y, (short)(x > 0xC0), -1, 0);
        }
    }
    for (i = 0x13; i >= 0x12; i--) {
        k = word_E9FB4[i];
        if (k < 0) {
            f = -1;
        } else {
            k *= 3;
            x = word_CCEF8[k];
            y = word_CCEF8[++k];
            f = byte_CCE00[word_CCEF8[++k] + (signed char)byte_E9FDC[i]];
        }
        if (f > 0x64 || k < 0) DrawSprite(dword_E0220, 4, (short)(i == 0x12 ? 0x1A5 : 0x12D), 0, (short)(i == 0x13), 0);
        if (f >= 0) DrawSprite(photoptrsf[f], x, y, 0, (short)(i == 0x13), 0);
        if (i == 0x12) {
            DrawSprite(dword_E0230, 4, (short)(i == 0x12 ? 0x1A5 : 0x12D), 0, -1, 0);
        } else {
            f = word_E9F7A;
            if (f >= 0x362) DrawFrameSprite(f, word_E9F36, word_E9F58, 0, 0);
        }
    }
    if (camy < -0xB0) {
        y1 = cliprect_y1;
        sub_B4BC4(dword_D30BC, dword_D30C0, cliprect_y0, 0x244);
    }
    for (i = 0; i < 3; i++) {
        ys[i] = 0;
        ord[i] = i;
    }
    if (byte_E9FAD != -1) ys[2] = word_E9F3A[byte_E9FAD];
    if (byte_E9FAB >= 0) ys[0] = word_E9F3A[byte_E9FAB];
    if (byte_E9FAC >= 0) ys[1] = word_E9F3A[byte_E9FAC];
    sub_93540(3, ys, ord);
    for (k = 0; k < 3; k++) {
        i = ord[k];
        if (i == 2) {
            if (byte_E9FAD == -1) continue;
            DrawFrameSprite(MARKFRAME(2), word_E9F18[byte_E9FAD], word_E9F3A[byte_E9FAD], 0, 0);
            continue;
        }
        f = i ? byte_E9FAC : byte_E9FAB;
        if (f < 0) continue;
        if (word_E9F5C[f] == -1) continue;
        x = word_E9F18[f];
        y = word_E9F3A[f];
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
        if (f) DrawFrameSprite(ARROWFRAME(i, sub_B340B(f) - 1), x, y, f & 8, 0);
        else DrawFrameSprite(MARKFRAME(i), x, y, 0, 0);
    }
    i = 0xF;
    f = word_E9F7A;
    if (f >= 0x284 && f <= 0x288) {
        DrawFrameSprite(f, word_E9F18[i], word_E9F3A[i], word_E9F36 < 0, 0);
    } else if (f == 0x189 && word_E9FA7 > -0x100 && byte_E9FAD != 0x10
        || word_E9F3A[i] >= 0 && f >= 0x22A && f <= 0x237) {
        DrawFrameSprite(f, word_E9F18[i], word_E9F3A[i], 0, 0);
    }
    if (byte_E9FAD != 0x10 && word_E9FA7 >= 0)
        DrawFrameSprite(dword_E9F78, dword_E9F34, word_E9FA7 * 3 / 2 + dword_E9F56, 0, 0);
    for (k = 0; k < 0x11; k++) {
        i = *(short *)&dword_E9FF0[k];
        if (i == 0xF) continue;
        if (i == 0xE) {
            if (byte_E9FAD != -1 || word_E9FA7 <= 0 || word_E9F3A[i] >= 0xE8) continue;
            if (word_E9F3A[i] <= -0xE8 && word_E9F3A[i] >= -0xF0 && ABS(word_E9F18[i]) <= 0x14 && word_E9FA7 < 0xD)
                continue;
            DrawFrameSprite(word_E9F5C[i], word_E9F18[i], word_E9FA7 * 3 / 2 + word_E9F3A[i], 0, 0);
            continue;
        }
        if (i < 0xC && (signed char)byte_E9F9B[i] < 0) continue;
        if (word_E9F5C[i] != -1 && i < 0xC) {
            if (byte_E9FAD != -1 && i == byte_E9FAD || i == byte_E9FAB || i == byte_E9FAC || i == dword_ED74C
                || i == word_CD4FC)
                DrawSpriteNumber(word_E9F18[i], word_E9F3A[i], (signed char)byte_E9F8F[i], (signed char)byte_E9F9B[i]);
            else if (shownumbers)
                DrawSpriteNumber(word_E9F18[i], word_E9F3A[i], (signed char)byte_E9F8F[i], -1);
        }
        DrawFrameSprite(word_E9F5C[i], word_E9F18[i], word_E9F3A[i], (signed char)byte_E9F7E[i], i > 5);
        if (i == 0xC && byte_E9FAD != 0x10) {
            if (ABS(dword_E9F34) == 6 && dword_E9F56 == 0xF0
                || dword_E9F56 >= word_E9F3A[i] && word_E9FA7 >= 0xD && ABS(dword_E9F34 - word_E9F18[i]) < 0x15)
                DrawFrameSprite(dword_E9F78, dword_E9F34, word_E9FA7 * 3 / 2 + dword_E9F56, 0, 0);
        }
    }
    if (dword_E9F56 <= -0xE8 && dword_E9F56 >= -0xEC && ABS(dword_E9F34) <= 0x14 && word_E9FA7 >= 0xD)
        DrawFrameSprite(dword_E9F78, dword_E9F34, word_E9FA7 * 3 / 2 + dword_E9F56, 0, 0);
    if (camy < -0xB0) sub_B4BC4(dword_D30BC, dword_D30C0, cliprect_y0, y1);
    if (camy < -0x90) DrawRinkEndArt();
    if (word_E9F58 < 0 && word_E9F7A >= 0x22A && word_E9F7A <= 0x237)
        DrawFrameSprite(word_E9F7A, word_E9F36, word_E9F58, 0, 0);
    if (dword_E9F56 < -0x108 && byte_E9FAD == -1 && word_E9FA7 >= 0)
        DrawFrameSprite(dword_E9F78, dword_E9F34, word_E9FA7 * 3 / 2 + dword_E9F56, 0, 0);
}
