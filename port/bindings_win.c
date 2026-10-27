/* The Input bindings window (Windows), drawn the way the approved mock-up looks: a flat dark panel with a title bar to drag it by, one tab for each way to
 * control the game (Joystick One, Joystick Two, Keyboard, The Mouse), a row for each action, a picker of buttons for the controllers and the mouse, and the
 * choice of Hold / change line (both buttons together, as on the Genesis pad, or a button of its own). Everything is painted by hand into one window.
 * It is modal: it runs its own message loop, so the game stays paused (the main thread is here) and muted until Apply or Cancel. */
#include "host.h"
#include "audio.h"
#include "bindings.h"
#include <SDL.h>

#define DW 560                                  /* the width of the window */
#define TITLE_H 44
#define TABS_H 38
#define ROW_H 32

#define C_BG RGB(32, 33, 36)
#define C_BOX RGB(41, 42, 46)
#define C_LINE RGB(60, 64, 67)
#define C_BTN RGB(48, 50, 54)
#define C_BTNH RGB(64, 67, 72)
#define C_LISTEN RGB(30, 52, 80)
#define C_TEXT RGB(232, 234, 237)
#define C_SEC RGB(154, 160, 166)
#define C_ACCENT RGB(138, 180, 248)
#define C_WARN RGB(251, 188, 4)

enum { H_CLOSE, H_TAB, H_ROW, H_CHIP, H_MODE, H_RESET, H_CANCEL, H_APPLY };
typedef struct { RECT r; int kind, arg; } Hit;

static HWND dlg, owner;
static struct bindings W;                       /* the changes, until Apply */
static int cur;                                 /* 0 Joystick One, 1 Joystick Two, 2 Keyboard, 3 The Mouse */
static int own[4];                              /* Hold / change line has a button of its own (else Alt + Space together) */
static int listen = -1, pick = -1, hov = -1;    /* the keyboard row that waits for a key, the row that shows its buttons, the button under the pointer */
static HFONT fui, fsm, fbold, fmono;
static Hit hit[200];
static int nhit;
static HDC rdc;
static int rdraw;

static const char *tabname[4] = { "Joystick One", "Joystick Two", "Keyboard", "The Mouse" };
static const char *padnames[] = { "A", "B", "X", "Y", "Back", "Guide", "Start", "Left stick press", "Right stick press", "Left shoulder", "Right shoulder",
                                  "D-pad up", "D-pad down", "D-pad left", "D-pad right" };
static const char *mnames[6] = { "Not set", "Mouse 1 (left)", "Mouse 2 (right)", "Mouse 3 (middle)", "Mouse 4", "Mouse 5" };
static const int msv[6] = { 0, SDL_BUTTON_LEFT, SDL_BUTTON_RIGHT, SDL_BUTTON_MIDDLE, SDL_BUTTON_X1, SDL_BUTTON_X2 };

static int *slotp(struct bindings *b, int t, int a) { return t < 2 ? &b->joy[t][a] : t == 2 ? &b->kb[a] : &b->ms[a - ACT_PASS]; }
static int *slot(int t, int a) { return slotp(&W, t, a); }

/* the actions a tab has: the stick and the mouse have no lines for the other team, the mouse only has its buttons */
static int shown(int t, int a)
{
    if (t == 3) return a >= ACT_PASS && a <= ACT_HOLD;
    if (t < 2) return a >= ACT_PASS && !(a >= ACT_AWAY1 && a <= ACT_AWAY4);
    return 1;
}

static void rowlabel(int t, int a, char *o, size_t n)
{
    if (t < 2 && a >= ACT_HOME1 && a <= ACT_HOME4) snprintf(o, n, "Your team's line %d", a - ACT_HOME1 + 1);
    else snprintf(o, n, "%s", act_label(a));
}

static void key_text(int xt, char *out, size_t n)
{
    LONG lp = ((xt & 0xFF) << 16) | ((xt & 0x100) ? (1 << 24) : 0);
    if (!xt) { snprintf(out, n, "%s", "Not set"); return; }
    if (!GetKeyNameTextA(lp, out, (int)n) || !out[0]) snprintf(out, n, "Key 0x%X", xt);
}

static void valtext(int t, int a, int v, char *o, size_t n)
{
    int i;
    if (t == 2) { key_text(v, o, n); return; }
    if (t == 3) {
        snprintf(o, n, "%s", mnames[0]);
        for (i = 0; i < 6; i++) if (msv[i] == v) snprintf(o, n, "%s", mnames[i]);
        return;
    }
    if (v == PAD_NONE) snprintf(o, n, "%s", "Not set");
    else if (v == PAD_DEFAULT) snprintf(o, n, "%s", a == ACT_PASS ? "Default (A or X)" : "Default (B or Y)");
    else if (PAD_ID(v) <= 14) snprintf(o, n, "%s", padnames[PAD_ID(v)]);
    else snprintf(o, n, "%s", PAD_ID(v) == 20 ? "Left trigger" : "Right trigger");
}

static void chordtext(char *o, size_t n)
{
    char p[64], s[64];
    valtext(cur, ACT_PASS, *slot(cur, ACT_PASS), p, sizeof p);
    valtext(cur, ACT_SHOOT, *slot(cur, ACT_SHOOT), s, sizeof s);
    if (cur < 2) {
        if (*slot(cur, ACT_PASS) == PAD_DEFAULT) snprintf(p, sizeof p, "%s", "A or X");
        if (*slot(cur, ACT_SHOOT) == PAD_DEFAULT) snprintf(s, sizeof s, "%s", "B or Y");
    }
    snprintf(o, n, "%s + %s", p, s);
}

/* ---- painting ---- */

static void fillrr(RECT *r, COLORREF fill, COLORREF line, int rad)
{
    HBRUSH b = CreateSolidBrush(fill);
    HPEN p = CreatePen(PS_SOLID, 1, line);
    HGDIOBJ ob = SelectObject(rdc, b), op = SelectObject(rdc, p);
    RoundRect(rdc, r->left, r->top, r->right, r->bottom, rad, rad);
    SelectObject(rdc, ob); SelectObject(rdc, op);
    DeleteObject(b); DeleteObject(p);
}

static void hline(int x0, int x1, int y, COLORREF c)
{
    HPEN p = CreatePen(PS_SOLID, 1, c);
    HGDIOBJ o = SelectObject(rdc, p);
    MoveToEx(rdc, x0, y, NULL); LineTo(rdc, x1, y);
    SelectObject(rdc, o); DeleteObject(p);
}

static void text(HFONT f, COLORREF c, int x, int y, int w, int h, const char *s, UINT fl)
{
    RECT r = { x, y, x + w, y + h };
    SelectObject(rdc, f);
    SetTextColor(rdc, c);
    DrawTextA(rdc, s, -1, &r, fl | DT_SINGLELINE | DT_VCENTER | DT_NOPREFIX | DT_END_ELLIPSIS);
}

static int addhit(RECT *r, int kind, int arg)
{
    if (kind < 0 || nhit >= 200) return -1;
    hit[nhit].r = *r; hit[nhit].kind = kind; hit[nhit].arg = arg;
    return nhit++;
}

/* style: 0 plain, 1 waiting for the key (blue), 2 fixed (grey, no click), 3 the main button */
static void button(int x, int y, int w, int h, const char *s, int kind, int arg, int style, UINT align)
{
    RECT r = { x, y, x + w, y + h };
    int i = addhit(&r, style == 2 ? -1 : kind, arg);
    COLORREF fill, line, tc;
    if (!rdraw) return;
    fill = style == 1 ? C_LISTEN : style == 2 ? C_BG : (i >= 0 && i == hov) ? C_BTNH : C_BTN;
    line = (style == 1 || style == 3) ? C_ACCENT : C_LINE;
    tc = (style == 1 || style == 3) ? C_ACCENT : style == 2 ? C_SEC : C_TEXT;
    fillrr(&r, fill, line, 8);
    text(kind == H_ROW ? fmono : fui, tc, x + 10, y, w - 20, h, s, align);
}

static void radio(int x, int y, int on, const char *s, int arg)
{
    RECT r = { x - 8, y, DW - 28, y + 26 };
    addhit(&r, H_MODE, arg);
    if (rdraw) {
        HPEN p = CreatePen(PS_SOLID, 1, on ? C_ACCENT : C_SEC);
        HBRUSH nb = (HBRUSH)GetStockObject(NULL_BRUSH), ab = CreateSolidBrush(C_ACCENT);
        HGDIOBJ op = SelectObject(rdc, p), ob = SelectObject(rdc, nb);
        Ellipse(rdc, x, y + 5, x + 16, y + 21);
        if (on) { SelectObject(rdc, ab); Ellipse(rdc, x + 4, y + 9, x + 12, y + 17); }
        SelectObject(rdc, op); SelectObject(rdc, ob);
        DeleteObject(p); DeleteObject(ab);
        text(fui, C_TEXT, x + 26, y, DW - x - 60, 26, s, DT_LEFT);
    }
}

/* the buttons to choose from for a controller or mouse row */
static int chips(int y, int a)
{
    const char *names[24];
    int vals[24], n = 0, i, x = 16;
    if (cur == 3) {
        for (i = 0; i < 6; i++) { vals[n] = msv[i]; names[n++] = mnames[i]; }
    } else {
        if (a == ACT_PASS || a == ACT_SHOOT) { vals[n] = PAD_DEFAULT; names[n++] = a == ACT_PASS ? "Default (A or X)" : "Default (B or Y)"; }
        vals[n] = PAD_NONE; names[n++] = "Not set";
        for (i = 0; i < 15; i++) { vals[n] = PAD_VALUE(i); names[n++] = padnames[i]; }
        vals[n] = PAD_VALUE(20); names[n++] = "Left trigger";
        vals[n] = PAD_VALUE(21); names[n++] = "Right trigger";
    }
    y += 6;
    SelectObject(rdc, fui);
    for (i = 0; i < n; i++) {
        SIZE sz;
        int w;
        GetTextExtentPoint32A(rdc, names[i], (int)strlen(names[i]), &sz);
        w = sz.cx + 22;
        if (x + w > DW - 16) { x = 16; y += 30; }
        button(x, y, w, 24, names[i], H_CHIP, vals[i], *slot(cur, a) == vals[i] ? 1 : 0, DT_CENTER);
        x += w + 6;
    }
    return y + 34;
}

/* lays the window out (and paints it when draw is set); returns the height it needs */
static int render(HDC dc, int draw)
{
    char t[96], u[96];
    const char *hint;
    int y, x, a, b, i;
    rdc = dc; rdraw = draw; nhit = 0;
    SetBkMode(dc, TRANSPARENT);

    /* the title bar */
    if (draw) {
        HBRUSH gb = CreateSolidBrush(C_SEC);
        for (i = 0; i < 6; i++) { RECT d = { 14 + (i & 1) * 6, 14 + (i >> 1) * 6, 17 + (i & 1) * 6, 17 + (i >> 1) * 6 }; FillRect(dc, &d, gb); }
        DeleteObject(gb);
        text(fbold, C_TEXT, 34, 0, 300, TITLE_H, "Input bindings", DT_LEFT);
    }
    { RECT r = { DW - 44, 8, DW - 12, 36 }; int h = addhit(&r, H_CLOSE, 0);
      if (draw) {
          HPEN p = CreatePen(PS_SOLID, 2, C_SEC);
          HGDIOBJ op;
          if (h == hov) fillrr(&r, C_BTNH, C_BTNH, 8);
          op = SelectObject(dc, p);
          MoveToEx(dc, DW - 34, 16, NULL); LineTo(dc, DW - 22, 28);
          MoveToEx(dc, DW - 22, 16, NULL); LineTo(dc, DW - 34, 28);
          SelectObject(dc, op); DeleteObject(p);
      } }
    if (draw) hline(0, DW, TITLE_H, C_LINE);

    /* the tabs */
    SelectObject(dc, fui);
    x = 16;
    for (i = 0; i < 4; i++) {
        SIZE sz;
        int w;
        RECT r;
        GetTextExtentPoint32A(dc, tabname[i], (int)strlen(tabname[i]), &sz);
        w = sz.cx + 26;
        r.left = x; r.top = TITLE_H; r.right = x + w; r.bottom = TITLE_H + TABS_H;
        addhit(&r, H_TAB, i);
        if (draw) {
            text(fui, i == cur ? C_TEXT : C_SEC, x, TITLE_H, w, TABS_H - 2, tabname[i], DT_CENTER);
            if (i == cur) { RECT u2 = { x, TITLE_H + TABS_H - 2, x + w, TITLE_H + TABS_H }; HBRUSH ab = CreateSolidBrush(C_ACCENT); FillRect(dc, &u2, ab); DeleteObject(ab); }
        }
        x += w + 2;
    }
    y = TITLE_H + TABS_H;
    if (draw) hline(0, DW, y, C_LINE);

    hint = cur == 2 ? "Click a binding, then press the key. Backspace clears it."
         : cur == 3 ? "Click a binding, then pick the mouse button. Moving the mouse moves the pointer."
         : "Click a binding, then pick the button. The stick or the D-pad moves the player.";
    if (draw) text(fsm, C_SEC, 16, y + 6, DW - 32, 22, hint, DT_LEFT);
    y += 32;

    /* the rows */
    for (a = 0; a < NACT; a++) {
        int v, fixed;
        if (!shown(cur, a)) continue;
        v = *slot(cur, a);
        fixed = a == ACT_HOLD && !own[cur];
        rowlabel(cur, a, t, sizeof t);
        if (draw) text(fui, C_TEXT, 16, y, 170, ROW_H, t, DT_LEFT);
        if (fixed) {
            chordtext(u, sizeof u);
            button(190, y + 2, 210, ROW_H - 4, u, H_ROW, a, 2, DT_LEFT);
            if (draw) text(fsm, C_SEC, 408, y, DW - 424, ROW_H, "Both buttons", DT_LEFT);
        } else {
            if (listen == a) snprintf(u, sizeof u, "%s", "Press a key...");
            else valtext(cur, a, v, u, sizeof u);
            button(190, y + 2, 210, ROW_H - 4, u, H_ROW, a, (listen == a || pick == a) ? 1 : 0, DT_LEFT);
            if (draw) {
                for (b = 0; b < NACT; b++)
                    if (b != a && shown(cur, b) && (b != ACT_HOLD || own[cur]) && v && v != PAD_DEFAULT && *slot(cur, b) == v) break;
                if (b < NACT) {
                    rowlabel(cur, b, u, sizeof u);
                    snprintf(t, sizeof t, "Also used by %s", u);
                    text(fsm, C_WARN, 408, y, DW - 424, ROW_H, t, DT_LEFT);
                } else if (a == ACT_HOLD && !v) text(fsm, C_SEC, 408, y, DW - 424, ROW_H, "Required", DT_LEFT);
            }
        }
        y += ROW_H;
        if (draw) hline(16, DW - 16, y - 1, C_LINE);
        if (pick == a && cur != 2) y = chips(y, a);
    }

    /* Hold / change line */
    y += 10;
    chordtext(u, sizeof u);
    if (draw) {
        RECT r = { 16, y, DW - 16, y + 92 };
        fillrr(&r, C_BOX, C_LINE, 10);
        text(fbold, C_TEXT, 28, y + 4, 300, 24, "Hold / change line", DT_LEFT);
    }
    snprintf(t, sizeof t, "Press both together (%s, original)", u);
    radio(28, y + 30, !own[cur], t, 0);
    radio(28, y + 58, own[cur], "Its own button", 1);
    y += 92 + 12;

    /* the buttons */
    if (draw) hline(0, DW, y, C_LINE);
    y += 12;
    button(16, y, 170, 30, "Reset this control", H_RESET, 0, 0, DT_CENTER);
    button(DW - 16 - 90, y, 90, 30, "Apply", H_APPLY, 0, 3, DT_CENTER);
    button(DW - 16 - 90 - 8 - 90, y, 90, 30, "Cancel", H_CANCEL, 0, 0, DT_CENTER);
    return y + 30 + 12;
}

static void relayout(void)
{
    RECT r, wa;
    HDC dc = GetDC(dlg);
    int h = render(dc, 0);
    ReleaseDC(dlg, dc);
    GetWindowRect(dlg, &r);
    if (h != r.bottom - r.top) {
        int y = r.top;
        if (SystemParametersInfo(SPI_GETWORKAREA, 0, &wa, 0)) {                 /* all of it on the screen */
            if (y + h > wa.bottom) y = wa.bottom - h;
            if (y < wa.top) y = wa.top;
        }
        SetWindowPos(dlg, 0, r.left, y, DW, h, SWP_NOZORDER | SWP_NOACTIVATE);
        SetWindowRgn(dlg, CreateRoundRectRgn(0, 0, DW + 1, h + 1, 18, 18), TRUE);
    }
    InvalidateRect(dlg, NULL, FALSE);
}

static void paint(void)
{
    PAINTSTRUCT ps;
    HDC dc = BeginPaint(dlg, &ps), m = CreateCompatibleDC(dc);
    RECT c;
    HBITMAP bm;
    HGDIOBJ ob;
    HBRUSH bg = CreateSolidBrush(C_BG);
    GetClientRect(dlg, &c);
    bm = CreateCompatibleBitmap(dc, c.right, c.bottom);
    ob = SelectObject(m, bm);
    FillRect(m, &c, bg);
    render(m, 1);
    {   /* the outline */
        HPEN p = CreatePen(PS_SOLID, 1, C_LINE);
        HGDIOBJ op = SelectObject(m, p), obr = SelectObject(m, GetStockObject(NULL_BRUSH));
        RoundRect(m, 0, 0, c.right, c.bottom, 18, 18);
        SelectObject(m, op); SelectObject(m, obr); DeleteObject(p);
    }
    BitBlt(dc, 0, 0, c.right, c.bottom, m, 0, 0, SRCCOPY);
    SelectObject(m, ob);
    DeleteObject(bm); DeleteObject(bg); DeleteDC(m);
    EndPaint(dlg, &ps);
}

/* ---- behaviour ---- */

static int hit_at(int x, int y)
{
    int i;
    for (i = nhit - 1; i >= 0; i--)
        if (x >= hit[i].r.left && x < hit[i].r.right && y >= hit[i].r.top && y < hit[i].r.bottom) return i;
    return -1;
}

static void close_dlg(void)
{
    if (owner) EnableWindow(owner, TRUE);                                       /* before the window goes, so no other program is brought up */
    DestroyWindow(dlg);
}

static void apply(void)
{
    int t;
    for (t = 0; t < 4; t++) if (!own[t]) *slot(t, ACT_HOLD) = 0;
    bind = W;
    settings_save_all();
    close_dlg();
}

static void reset_tab(void)
{
    struct bindings D;
    int a;
    bindings_defaults(&D);
    for (a = 0; a < NACT; a++) if (shown(cur, a)) *slot(cur, a) = *slotp(&D, cur, a);
    own[cur] = 0;
}

static void click(int x, int y)
{
    int i = hit_at(x, y);
    if (i < 0) { listen = pick = -1; relayout(); return; }
    switch (hit[i].kind) {
    case H_CLOSE: case H_CANCEL: close_dlg(); return;
    case H_APPLY: apply(); return;
    case H_TAB: cur = hit[i].arg; listen = pick = -1; break;
    case H_ROW:
        if (cur == 2) { listen = listen == hit[i].arg ? -1 : hit[i].arg; pick = -1; }
        else { pick = pick == hit[i].arg ? -1 : hit[i].arg; listen = -1; }
        break;
    case H_CHIP: if (pick >= 0) *slot(cur, pick) = hit[i].arg; pick = -1; break;
    case H_MODE:
        own[cur] = hit[i].arg;
        if (!own[cur]) *slot(cur, ACT_HOLD) = 0;
        listen = pick = -1;
        break;
    case H_RESET: reset_tab(); listen = pick = -1; break;
    }
    relayout();
}

static LRESULT CALLBACK dlg_proc(HWND h, UINT m, WPARAM wp, LPARAM lp)
{
    switch (m) {
    case WM_PAINT: paint(); return 0;
    case WM_ERASEBKGND: return 1;
    case WM_NCHITTEST: {
        POINT p = { (short)LOWORD(lp), (short)HIWORD(lp) };
        ScreenToClient(h, &p);
        return (p.y >= 0 && p.y < TITLE_H && p.x < DW - 48) ? HTCAPTION : HTCLIENT;
    }
    case WM_MOUSEMOVE: {
        int i = hit_at((short)LOWORD(lp), (short)HIWORD(lp));
        if (i != hov) {
            TRACKMOUSEEVENT tme = { sizeof tme, TME_LEAVE, h, 0 };
            TrackMouseEvent(&tme);
            hov = i;
            InvalidateRect(h, NULL, FALSE);
        }
        return 0;
    }
    case WM_MOUSELEAVE: hov = -1; InvalidateRect(h, NULL, FALSE); return 0;
    case WM_LBUTTONDOWN: SetFocus(h); click((short)LOWORD(lp), (short)HIWORD(lp)); return 0;
    case WM_KEYDOWN: case WM_SYSKEYDOWN:
        if (listen >= 0) {                                                      /* every key, Alt and F10 included, is a binding here */
            int xt = (int)((lp >> 16) & 0xFF) | ((lp & (1 << 24)) ? 0x100 : 0);
            if (wp == VK_BACK) xt = 0;
            *slot(cur, listen) = xt;
            listen = -1;
            relayout();
            return 0;
        }
        if (wp == VK_ESCAPE) { close_dlg(); return 0; }
        if (wp == VK_RETURN) { apply(); return 0; }
        if (m == WM_SYSKEYDOWN) return 0;
        break;
    case WM_CHAR: case WM_SYSCHAR: case WM_KEYUP: case WM_SYSKEYUP: return 0;
    case WM_SYSCOMMAND: if ((wp & 0xFFF0) == SC_KEYMENU) return 0; break;
    case WM_KILLFOCUS: if (listen >= 0) { listen = -1; relayout(); } break;
    case WM_DESTROY: dlg = 0; return 0;
    }
    return DefWindowProc(h, m, wp, lp);
}

void bindings_dialog_open(void *parent)
{
    static int registered;
    RECT pr;
    MSG m;
    int x = 100, y = 60, r = 1;
    if (dlg) return;
    if (!registered) {
        WNDCLASSA wc;
        memset(&wc, 0, sizeof wc);
        wc.lpfnWndProc = dlg_proc; wc.hInstance = GetModuleHandle(0); wc.hCursor = LoadCursor(0, IDC_ARROW);
        wc.lpszClassName = "NHL95Bindings";
        RegisterClassA(&wc);
        fui = CreateFontA(-15, 0, 0, 0, FW_NORMAL, 0, 0, 0, DEFAULT_CHARSET, 0, 0, CLEARTYPE_QUALITY, 0, "Segoe UI");
        fsm = CreateFontA(-13, 0, 0, 0, FW_NORMAL, 0, 0, 0, DEFAULT_CHARSET, 0, 0, CLEARTYPE_QUALITY, 0, "Segoe UI");
        fbold = CreateFontA(-17, 0, 0, 0, FW_SEMIBOLD, 0, 0, 0, DEFAULT_CHARSET, 0, 0, CLEARTYPE_QUALITY, 0, "Segoe UI");
        fmono = CreateFontA(-14, 0, 0, 0, FW_NORMAL, 0, 0, 0, DEFAULT_CHARSET, 0, 0, CLEARTYPE_QUALITY, 0, "Consolas");
        registered = 1;
    }
    W = bind;
    cur = 2;
    listen = pick = hov = -1;
    own[0] = W.joy[0][ACT_HOLD] != 0; own[1] = W.joy[1][ACT_HOLD] != 0; own[2] = W.kb[ACT_HOLD] != 0; own[3] = W.ms[2] != 0;
    owner = (HWND)parent;
    if (owner && GetWindowRect(owner, &pr)) { x = pr.left + (pr.right - pr.left - DW) / 2; y = pr.top + 40; if (x < 0) x = 0; }
    dlg = CreateWindowExA(0, "NHL95Bindings", "Input bindings", WS_POPUP, x, y, DW, 600, owner, 0, GetModuleHandle(0), 0);
    if (!dlg) { fprintf(stderr, "Input bindings window: error %lu\n", (unsigned long)GetLastError()); return; }
    relayout();
    ShowWindow(dlg, SW_SHOW);
    SetForegroundWindow(dlg);
    SetFocus(dlg);
    audio_muted = 1;
    if (owner) EnableWindow(owner, FALSE);
    while (dlg && (r = GetMessage(&m, 0, 0, 0)) > 0) { TranslateMessage(&m); DispatchMessage(&m); }
    if (dlg) close_dlg();
    if (r == 0) PostQuitMessage((int)m.wParam);
    if (owner) { EnableWindow(owner, TRUE); SetForegroundWindow(owner); }
    owner = 0;
    audio_muted = 0;
}
