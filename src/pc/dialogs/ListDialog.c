/* Misc dialogs: the list dialog. */
#define ListDialog ListDialog_decl
#define DrawScrollBar DrawScrollBar_decl
#define TrackScrollBars TrackScrollBars_decl
#include "nhl95.h"
#undef ListDialog
#undef DrawScrollBar
#undef TrackScrollBars

void DrawScrollBar(int *sb);
int TrackScrollBars(int *sb, int n, int x, int y, int bits);

typedef struct { char b[0x11]; } SprHdr;

/* DRAFT: 1527 vs 1513, 343 of 467 instructions; see docs/UNSURE.md. */
/* ListDialog (303FB, PC only): pick from the n items in a centred box under title, at most 20 rows shown (a
   scroll bar, listscroll, when there are more). With marks set, flags[] holds a mark per item (cleared first)
   and a click toggles it; a second click on the same item ends the dialog (with marks only when it is marked).
   The mouse pointer is drawn over the dialog (a POINTER block saves the screen under it). align: passed to
   DrawListItem(s). Result: the item picked (-1 with marks when none was clicked yet). */
int ListDialog(char **items, int n, char *title, unsigned align, int marks, char *flags)
{
    struct {
        int y;
        int x;
        int my;
        int mx;
        int i;
        int bg;
        char *title;
        int lh;
        int bh;
        int bw;
        int by;
        int bx;
        int scroll;
        unsigned align;
        int shown;
        int ly;
        int bg2;
        int lx;
        int maxw;
        int old;
        int top;
        int bits;
    } s;
    int cur;
    int tw;
    int sz;
    unsigned char *e;

    s.title = title;
    s.align = align;
    sub_B4BA8();
    s.top = s.scroll = 0;
    cur = 0;
    if (marks) cur = -1;
    s.shown = n;
    if (n > 0x14) s.shown = 0x14;
    s.maxw = fputchar(s.title);
    for (s.i = 0; n > s.i; s.i++) {
        if (marks) flags[s.i] = 0;
        tw = fputchar(items[s.i]);
        if (tw > s.maxw) s.maxw = tw;
    }
    s.maxw += 9;
    if (tw > s.maxw) s.maxw = tw;
    tw = fputchar(s.title);
    s.lh = (byte_D42C3 + 2) * s.shown + 4;
    s.bx = (0x280 - s.maxw - 0x10) / 2;
    s.by = (0x1E0 - s.lh - 0x20) / 2;
    s.bw = s.maxw + 0x10;
    s.bh = s.lh + 0x20;
    s.lx = s.bx + 8;
    s.ly = s.by + 0x18;
    if (n > s.shown) {
        s.scroll = -1;
        s.lx -= 0xA;
        s.bx -= 0xA;
        listscroll[0] = s.bx + s.bw;
        listscroll[1] = s.by;
        listscroll[2] = 0xA;
        listscroll[3] = s.bh;
        InitScrollBar(listscroll, s.shown, n);
        listscroll[8] = 0;
        listscroll[5] = (unsigned)((listscroll[3] - 4) * listscroll[8]) / (unsigned)listscroll[10];
        SaveDialogBg(s.bx, s.by, s.bw + 0xA, s.bh);
        DrawScrollBar(listscroll);
    } else {
        SaveDialogBg(s.bx, s.by, s.bw, s.bh);
    }
    DrawBevelRect(s.bx, s.by, s.bw, s.bh, boxfillcolor, boxlitecolor, boxshadecolor);
    SetTextColors(dlgtextfg, dlgtextbg);
    PrintShadowText((s.bw - tw) / 2 + s.bx, s.by + 6, s.title);
    DrawBevelRect(s.lx, s.ly, s.maxw, s.lh, dlgtextbg, boxshadecolor, boxlitecolor);
    DrawListItems(items, s.lx, s.ly, s.maxw, s.top, cur, s.shown, s.align, marks, flags);
    sz = ((((short *)pointerspr)[2] << 2) + 4) * (((short *)pointerspr)[3] + 1) + 0x11;
    s.bg2 = s.bg = sub_8CCA8((char *)str_Pointer6, sz, 0x20);
    *(SprHdr *)s.bg = *(SprHdr *)pointerspr;
    ((short *)s.bg)[2] = ((short *)pointerspr)[2] + 1;
    ((short *)s.bg)[3] = ((short *)pointerspr)[3] + 1;
    sub_B2DCA(&s.i, &s.mx, &s.my);
    s.x = s.mx;
    s.y = s.my;
    sub_91400(s.bg, s.mx, s.my);
    sub_91370(pointerspr, s.mx, s.my);
    ClearInputQueue();
    n = 0;
    do {
        s.bits = 0;
        do {
            e = GetInputEvent();
            if (e) s.bits = ((int (*)(unsigned char *, int *, int *))ptrupdatefn)(e, &s.x, &s.y);
        } while (e && !(s.bits & 2));
        if (s.bits == 0) {
            if (s.x == s.mx && s.y == s.my) continue;
            sub_903F0(s.bg2, s.mx, s.my);
            sub_91400(s.bg2, s.x, s.y);
            sub_91370(pointerspr, s.x, s.y);
            s.mx = s.x;
            s.my = s.y;
        } else {
            sub_903F0(s.bg2, s.mx, s.my);
            if (s.bits & 2) {
                if ((s.i = ListHitTest(s.x, s.y, s.lx, s.ly, s.maxw, s.shown)) >= 0) {
                    s.old = cur;
                    cur = s.top + s.i;
                    if (marks && (cur != s.old || !flags[cur])) flags[cur] = ~flags[cur];
                    if (s.old >= 0 && s.old >= s.top && s.top + s.shown > s.old)
                        DrawListItem(items[s.old], s.lx, s.ly, s.maxw, s.top, s.old, cur, s.align, marks, flags);
                    DrawListItem(items[cur], s.lx, s.ly, s.maxw, s.top, cur, cur, s.align, marks, flags);
                }
                if (cur == s.old && ((!marks || flags[cur]) ? 1 : 0)) n = 1;
            }
            if (s.scroll && TrackScrollBars(listscroll, 1, s.x, s.y, s.bits) >= 0 && s.top != listscroll[8]) {
                s.top = listscroll[8];
                DrawListItems(items, s.lx, s.ly, s.maxw, s.top, cur, s.shown, s.align, marks, flags);
            }
            sub_91400(s.bg2, s.x, s.y);
            sub_91370(pointerspr, s.x, s.y);
            s.mx = s.x;
            s.my = s.y;
        }
    } while (!n);
    sub_903F0(s.bg2, s.mx, s.my);
    FreeMemBlock(s.bg2);
    RestoreDialogBg();
    return cur;
}
