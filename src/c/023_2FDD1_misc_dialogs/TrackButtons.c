/* Misc dialogs: dialog buttons and scroll bars, TrackButtons to TrackScrollBars in address order as one source block
   (DrawScrollBar ends in DrawButton's exit, TrackScrollBars in TrackButtons_x). */
#define TrackScrollBars TrackScrollBars_decl
#include "nhl95.h"
#undef TrackScrollBars

/* TrackButtons: for the n buttons of list (7 dwords each: x, y, w, h, pressed,...) and the
 mouse at x, y with button bits: a button under the mouse is drawn pressed (-1) while bit 0 is down; on a
 release (bit 1) it is the result and is drawn released; buttons the mouse left are released and redrawn.
 Returns the released button or -1. */
int TrackButtons(int *list, int n, int x, int y, int buttons)
{
    int hit;
    int i;
    int *b;

    hit = -1;
    for (i = 0; i < n; i++) {
        b = list + i * 7;
        if (x >= b[0] && x < b[0] + b[2] && y >= b[1] && y < b[1] + b[3]) {
            if (b[4] == 0 && (buttons & 1)) {
                b[4] = -1;
                DrawButton((Button *)b);
            }
            if ((buttons & 2) == 0) continue;
            hit = i;
            b = list + i * 7;
        } else {
            b = list + i * 7;
            if (b[4] == 0) continue;
        }
        b[4] = 0;
        DrawButton((Button *)b);
    }
    return hit;
}

/* DrawButtons: draw the n buttons of array b, each in its normal (not pressed: +10h = 0) state. */
void DrawButtons(Button *b, int n)
{
    int i;

    for (i = 0; i < n; i++) {
        b[i].pressed = 0;
        DrawButton(&b[i]);
    }
}

/* DrawButton: draw button b (x, y, w, h at +0..+0Ch, pressed +10h, label +18h) as a bevelled box
 in the box colours (a pressed button swaps the light and shade colours, xor swap, for the draw), then its label
 centred in shadow text. */
void DrawButton(Button *b)
{
    int *r;
    char *s;
    int y;

    r = (int *)b;
    if (r[4] != 0) {
        boxlitecolor ^= boxshadecolor;
        boxshadecolor ^= boxlitecolor;
        boxlitecolor ^= boxshadecolor;
    }
    DrawBevelRect(r[0], r[1], r[2], r[3], boxfillcolor, boxlitecolor, boxshadecolor);
    if (r[4] != 0) {
        boxlitecolor ^= boxshadecolor;
        boxshadecolor ^= boxlitecolor;
        boxlitecolor ^= boxshadecolor;
    }
    if (r[6] != 0) {
        s = (char *)r[6];
        y = (r[3] - byte_D42C3) / 2 + r[1];
        PrintShadowText((r[2] - fputchar(s)) / 2 + r[0], y, s);
    }
}


/* InitScrollBar: set up scroll bar sb (ints: +8 width, +0Ch height) for total items with visible on screen:
 position 0, thumb width = width - 4, thumb length = (height - 4) * visible total. */
void InitScrollBar(int *sb, int visible, int total)
{
    sb[0x28 / 4] = total;
    sb[0x24 / 4] = visible;
    sb[0x20 / 4] = 0;
    sb[0x10 / 4] = 0;
    sb[0x14 / 4] = 0;
    sb[0x18 / 4] = sb[0x08 / 4] - 4;
    sb[0x1C / 4] = (sb[0x0C / 4] - 4) * sb[0x24 / 4] / sb[0x28 / 4];
}

/* DrawScrollBar: draw scroll bar sb: its bevelled frame (x, y, w, h at +0..+0Ch) in the box colours, then the
 thumb (offset +10h +14h plus 2, size +18h +1Ch), pressed (+2Ch) with light and shade swapped (xor swap). */
void DrawScrollBar(int *sb)
{
    int x;
    int y;

    x = sb[0];
    y = sb[1];
    DrawBevelRect(x, y, sb[2], sb[3], boxfillcolor, boxlitecolor, boxshadecolor);
    if (sb[0x2C / 4] != 0) {
        boxlitecolor ^= boxshadecolor;
        boxshadecolor ^= boxlitecolor;
        boxlitecolor ^= boxshadecolor;
    }
    x += sb[4] + 2;
    y += sb[5] + 2;
    DrawBevelRect(x, y, sb[6], sb[7], boxfillcolor, boxlitecolor, boxshadecolor);
    if (sb[0x2C / 4] != 0) {
        boxlitecolor ^= boxshadecolor;
        boxshadecolor ^= boxlitecolor;
        boxlitecolor ^= boxshadecolor;
    }
}

/* TrackScrollBars: the same hit test for scroll bars (12 ints each). A bar under the mouse is
 pressed while button bit 0 is down. Bit 1 releases it. The thumb follows the mouse, clamped
 inside the bar, and the item index is thumb * total / (height - 4). Returns the bar under the
 mouse, or -1. It ends in TrackButtons_x (the near jmp needs the functions between them in this file). */
int TrackScrollBars(int *list, int n, int x, int y, int buttons)
{
    int yy;
    int hit;
    int i;
    int old;
    volatile int t;

    yy = y;
    hit = -1;
    for (i = 0; i < n; i++) {
        if (x >= (list + i * 12)[0] && x < (list + i * 12)[0] + (list + i * 12)[2]
            && yy >= (list + i * 12)[1] && yy < (list + i * 12)[1] + (list + i * 12)[3]) {
            old = (list + i * 12)[5];
            if ((buttons & 1) && (list + i * 12)[11] == 0) {
                (list + i * 12)[11] = -1;
                old = -1;
            }
            if (buttons & 2) {
                (list + i * 12)[11] = 0;
                old = -1;
            }
            t = yy - (list + i * 12)[1];
            (list + i * 12)[5] = t - (list + i * 12)[7] / 2;
            if ((list + i * 12)[5] < 0)
                (list + i * 12)[5] = 0;
            else if ((list + i * 12)[3] - (list + i * 12)[7] - 4 < (list + i * 12)[5])
                (list + i * 12)[5] = (list + i * 12)[3] - (list + i * 12)[7] - 4;
            (list + i * 12)[8] = (list + i * 12)[5] * (list + i * 12)[10] / (t = (list + i * 12)[3] - 4);
            hit = i;
            if (old != (list + i * 12)[5]) DrawScrollBar(list + i * 12);
        } else {
            if ((list + i * 12)[11] == 0) continue;
            (list + i * 12)[11] = 0;
            DrawScrollBar(list + i * 12);
        }
    }
    return hit;
}
