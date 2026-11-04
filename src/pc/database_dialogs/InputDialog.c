/* Database dialogs: the message box with an input field. */
#define DrawDlgFrame DrawDlgFrame_decl
#define EditTextField EditTextField_decl
#define unknown_libname_4 unknown_libname_4_decl
#define InputDialog InputDialog_decl
#include "nhl95.h"
#undef DrawDlgFrame
#undef EditTextField
#undef unknown_libname_4
#undef InputDialog

void DrawDlgFrame(int x, int y, int x2, int y2, int edge);
int EditTextField(char *buf, int maxlen, int w, int x, int y, int (*cb)(void), int a, int b);
int unknown_libname_4(char *s);  /* Watcom CRT atoi */

typedef struct { char b[0x11]; } SprHdr;

/* InputDialog (71F0C, PC only): show the n text lines centred in a framed box above an input field at least
   fw wide, saving the screen under the box first (a DSBOX block with pointerspr's header). With numeric set,
   edit the field until it reads as a number from lo to hi (every character a digit, atoi); Esc gives up
   unless required, and with required set an empty field is never taken. Otherwise edit it once; with
   required set an empty field is asked again and Esc puts the old text back and asks again. Then wait for
   Enter and Esc to be released, restore the screen and trim the spaces off both ends of buf. lines: the text
   pointers; buf: the field, len characters. Result: the number, 1 for text, or -1 when given up. */
int InputDialog(int *lines, int n, char *buf, int len, int fw, int numeric, int lo, int hi, int required)
{
    struct {
        char save[0x34];
        int bw;
        int fill;
        int h;
        int w;
        int y0;
        int mem;
        int ax;
        int lh;
        int fieldw;
        int x;
        int y;
    } s;
    int r;
    int i;
    int e1;
    int done;
    int l;
    int t;
    int m;

    r = -1;
    s.w = 0;
    s.h = 0;
    s.lh = byte_D42C3 + 2;
    for (i = 0; i < n; i++) MeasureTextLine((char *)lines[i], &s.w, &s.h, s.lh);
    s.fieldw = fw + 8;
    if (s.fieldw > s.w) s.w = s.fieldw;
    s.w += 0x10;
    s.h += 0x1F;
    s.x = (0x280 - s.w) / 2;
    s.y = (0x1E0 - s.h) / 2;
    s.ax = s.x / 4 * 4;
    s.y0 = s.y;
    s.bw = (s.w + 6) / 4 * 4;
    l = s.bw * 4;
    l = (l + 4) * (s.h + 4) + 0x11;
    t = 0;  /* a named 0 finishes the size before the push; a literal 0 is pushed between the multiply and +11h */
    m = sub_8CCA8((char *)str_DSBOX, l, t);
    s.mem = m;
    *(SprHdr *)m = *(SprHdr *)pointerspr;
    *(short *)(m + 4) = s.bw + 1;
    *(short *)(m + 6) = s.h + 4;
    sub_91400(m, s.ax, s.y);
    DrawDlgFrame(s.x, s.y, s.x + s.w - 1, s.y + s.h - 1, 0);
    s.y += 8;
    for (i = 0; i < n; i++) {
        t = (s.w - fputchar((char *)lines[i])) / 2;
        PrintShadowText(t + s.x, s.y, (char *)lines[i]);
        s.y += s.lh;
    }
    s.x += (s.w - s.fieldw) / 2;
    s.fill = dlgfillcol;
    e1 = dlgedgecol1;
    i = dlgedgecol2;  /* i, not a new local: the second edge colour takes esi */
    dword_D42AC = dlgfillcol = 0;
    dlgedgecol1 = i;
    dlgedgecol2 = e1;
    DrawDlgFrame(s.x, s.y, s.x + s.fieldw - 1, s.y + 0x11, 0);
    dlgfillcol = s.fill;
    dlgedgecol1 = e1;
    dlgedgecol2 = i;
    done = 0;
    if (numeric) {
        do {
            if (EditTextField(buf, len, s.fieldw - 8, s.x + 2, s.y + 2, DlgReturnZero, 0, 0xC) != 0x1B) {
                r = -1;
                if (!required || *buf) {
                    for (i = 0; i < len; i++) {
                        if (!(byte_C4B6C[(unsigned char)(buf[i] + 1)] & 0x20)) break;
                        r = unknown_libname_4(buf);
                    }
                }
            } else if (!required) break;
        } while (r < lo || r > hi);
    } else {
        strcpy(s.save, buf);
        do {
            if (EditTextField(buf, len, s.fieldw - 8, s.x + 2, s.y + 2, DlgReturnZero, 0, 0x14) != 0x1B) {
                done = 1;
                if (required && !*buf) done = 0;
                else r = 1;
            } else if (required) {
                strcpy(buf, s.save);
            } else {
                done = 1;
            }
        } while (!done);
    }
    while (sub_B2CBE(1) || sub_B2CBE(0x1C));
    ClearInputQueue();
    sub_903F0(s.mem, s.ax, s.y0);
    FreeMemBlock(s.mem);
    for (l = strlen(buf); l > 0; l--) {
        if (buf[l - 1] != ' ') break;
        buf[l - 1] = 0;
    }
    while (*buf == ' ') {
        l = strlen(buf);
        for (i = 0; i < l; i++) buf[i] = buf[i + 1];
    }
    return r;
}
