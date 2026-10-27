/* The Input bindings window (Windows): one tab for each way to control the game (Joystick One, Joystick Two, Keyboard, The Mouse) and a row for each
 * action. It is a window of its own (not modal: the game goes on), kept on top of the game window. OK keeps the changes and writes the ini file. */
#include "host.h"
#include "bindings.h"
#include <SDL.h>
#include <commctrl.h>

#define ID_TAB 100
#define ID_RESET 101
#define ID_ROW 1000

static HWND dlg, tab;
static HWND rowctl[64], rowlab[64];
static int nrows, rowact[64];
static struct bindings W;                       /* the changes, until OK */
static int cur;                                 /* 0 Joystick One, 1 Joystick Two, 2 Keyboard, 3 The Mouse */
static int listening = -1;                      /* the keyboard row that waits for a key */
static HFONT font;
static WNDPROC key_proc;

static const char *padnames[] = { "A", "B", "X", "Y", "Back", "Guide", "Start", "Left stick press", "Right stick press", "Left shoulder", "Right shoulder",
                                  "D-pad up", "D-pad down", "D-pad left", "D-pad right" };

static void key_text(int xt, char *out, size_t n)
{
    LONG lp = ((xt & 0xFF) << 16) | ((xt & 0x100) ? (1 << 24) : 0);
    if (!xt) { snprintf(out, n, "Not set"); return; }
    if (!GetKeyNameTextA(lp, out, (int)n) || !out[0]) snprintf(out, n, "Key 0x%X", xt);
}

static void set_font(HWND h) { SendMessage(h, WM_SETFONT, (WPARAM)font, TRUE); }

static void refresh_row(int r)
{
    if (rowact[r] < 0) return;
    if (cur == 2) {
        char t[64];
        if (listening == r) snprintf(t, sizeof t, "Press a key... (Backspace clears)");
        else key_text(W.kb[rowact[r]], t, sizeof t);
        SetWindowTextA(rowctl[r], t);
    }
}

/* the keyboard rows are buttons that take the next key pressed */
static LRESULT CALLBACK key_row_proc(HWND h, UINT m, WPARAM wp, LPARAM lp)
{
    int r = (int)GetWindowLongPtr(h, GWLP_ID) - ID_ROW;
    if (listening == r && r >= 0 && r < nrows) {
        if (m == WM_GETDLGCODE) return DLGC_WANTALLKEYS;
        if (m == WM_KEYDOWN || m == WM_SYSKEYDOWN) {
            int xt = (int)((lp >> 16) & 0xFF) | ((lp & (1 << 24)) ? 0x100 : 0);
            if (wp == VK_BACK) xt = 0;
            W.kb[rowact[r]] = xt;
            listening = -1;
            refresh_row(r);
            return 0;
        }
        if (m == WM_CHAR || m == WM_SYSCHAR || m == WM_KEYUP || m == WM_SYSKEYUP) return 0;
        if (m == WM_KILLFOCUS) { listening = -1; refresh_row(r); }
    }
    return CallWindowProc(key_proc, h, m, wp, lp);
}

static void clear_rows(void)
{
    int i;
    for (i = 0; i < nrows; i++) { DestroyWindow(rowctl[i]); DestroyWindow(rowlab[i]); }
    nrows = 0;
    listening = -1;
}

static HWND add_combo(int r, int y, const char **items, int n, int sel)
{
    HWND c = CreateWindowExA(0, "COMBOBOX", "", WS_CHILD | WS_VISIBLE | WS_VSCROLL | CBS_DROPDOWNLIST | WS_TABSTOP, 210, y, 260, 300, dlg, (HMENU)(INT_PTR)(ID_ROW + r), 0, 0);
    int i;
    set_font(c);
    for (i = 0; i < n; i++) SendMessageA(c, CB_ADDSTRING, 0, (LPARAM)items[i]);
    SendMessage(c, CB_SETCURSEL, sel, 0);
    return c;
}

static void build_rows(void)
{
    int a, y = 54;
    clear_rows();
    for (a = 0; a < NACT; a++) {
        HWND l, c;
        char t[64];
        int r = nrows;
        if (cur == 3 && (a < ACT_PASS || a > ACT_HOLD)) continue;                          /* the mouse: pass, shoot, hold */
        if (cur < 2 && a < ACT_PASS) continue;                                              /* the stick moves the player */
        if (cur < 2 && a >= ACT_HOME1 && a <= ACT_AWAY4 && a >= ACT_AWAY1) continue;      /* a controller has the lines of its own team */
        snprintf(t, sizeof t, "%s", act_label(a));
        if (cur < 2 && a >= ACT_HOME1 && a <= ACT_HOME4) snprintf(t, sizeof t, "Your team's line %d", a - ACT_HOME1 + 1);
        l = CreateWindowExA(0, "STATIC", t, WS_CHILD | WS_VISIBLE, 16, y + 4, 190, 20, dlg, 0, 0, 0);
        set_font(l);
        rowact[r] = a;
        if (cur == 2) {
            c = CreateWindowExA(0, "BUTTON", "", WS_CHILD | WS_VISIBLE | WS_TABSTOP | BS_PUSHBUTTON | BS_LEFT, 210, y, 260, 26, dlg, (HMENU)(INT_PTR)(ID_ROW + r), 0, 0);
            set_font(c);
            SetWindowLongPtr(c, GWLP_USERDATA, 0);
            if (!key_proc) key_proc = (WNDPROC)GetWindowLongPtr(c, GWLP_WNDPROC);
            SetWindowLongPtr(c, GWLP_WNDPROC, (LONG_PTR)key_row_proc);
        } else if (cur == 3) {
            static const char *mb[] = { "Not set", "Mouse 1 (left)", "Mouse 2 (right)", "Mouse 3 (middle)", "Mouse 4", "Mouse 5" };
            static const int sdl[] = { 0, SDL_BUTTON_LEFT, SDL_BUTTON_RIGHT, SDL_BUTTON_MIDDLE, SDL_BUTTON_X1, SDL_BUTTON_X2 };
            int sel = 0, i, v = W.ms[a - ACT_PASS];
            for (i = 0; i < 6; i++) if (sdl[i] == v) sel = i;
            c = add_combo(r, y, mb, 6, sel);
        } else {
            const char *items[24];
            int n = 0, i, sel = 0, v = W.joy[cur][a];
            items[n++] = a == ACT_PASS ? "Default (A or X)" : a == ACT_SHOOT ? "Default (B or Y)" : "Not set";
            for (i = 0; i < 15; i++) items[n++] = padnames[i];
            items[n++] = "Left trigger";
            items[n++] = "Right trigger";
            if (v >= 2) { int id = PAD_ID(v); sel = id <= 14 ? id + 1 : (id == 20 ? 16 : 17); }
            c = add_combo(r, y, items, n, sel);
        }
        rowctl[r] = c;
        rowlab[r] = l;
        nrows++;
        refresh_row(r);
        y += 30;
    }
}

static void joy_pick(int r, int sel)
{
    int a = rowact[r];
    int v = sel == 0 ? (a == ACT_PASS || a == ACT_SHOOT ? PAD_DEFAULT : PAD_NONE) : sel <= 15 ? PAD_VALUE(sel - 1) : PAD_VALUE(sel == 16 ? 20 : 21);
    W.joy[cur][a] = v;
}

static LRESULT CALLBACK dlg_proc(HWND h, UINT m, WPARAM wp, LPARAM lp)
{
    switch (m) {
    case WM_COMMAND: {
        int id = LOWORD(wp), code = HIWORD(wp);
        if (id == IDOK) { bind = W; settings_save_all(); DestroyWindow(h); return 0; }
        if (id == IDCANCEL) { DestroyWindow(h); return 0; }
        if (id == ID_RESET) {
            struct bindings d;
            bindings_defaults(&d);
            if (cur == 2) memcpy(W.kb, d.kb, sizeof W.kb);
            else if (cur == 3) memcpy(W.ms, d.ms, sizeof W.ms);
            else memcpy(W.joy[cur], d.joy[cur], sizeof W.joy[cur]);
            build_rows();
            return 0;
        }
        if (id >= ID_ROW && id < ID_ROW + 64) {
            int r = id - ID_ROW;
            if (cur == 2 && code == BN_CLICKED) {            /* wait for a key */
                int old = listening;
                listening = r;
                if (old >= 0) refresh_row(old);
                refresh_row(r);
                SetFocus(rowctl[r]);
            } else if (cur == 3 && code == CBN_SELCHANGE) {
                static const int sdl[] = { 0, SDL_BUTTON_LEFT, SDL_BUTTON_RIGHT, SDL_BUTTON_MIDDLE, SDL_BUTTON_X1, SDL_BUTTON_X2 };
                int sel = (int)SendMessage(rowctl[r], CB_GETCURSEL, 0, 0);
                W.ms[rowact[r] - ACT_PASS] = sdl[sel < 0 ? 0 : sel];
            } else if (cur < 2 && code == CBN_SELCHANGE) {
                joy_pick(r, (int)SendMessage(rowctl[r], CB_GETCURSEL, 0, 0));
            }
        }
        return 0;
    }
    case WM_NOTIFY:
        if (((NMHDR *)lp)->idFrom == ID_TAB && ((NMHDR *)lp)->code == TCN_SELCHANGE) { cur = TabCtrl_GetCurSel(tab); build_rows(); }
        return 0;
    case WM_CLOSE: DestroyWindow(h); return 0;
    case WM_DESTROY: if (getenv("NHL95_MENUTRACE")) fprintf(stderr, "bindings window destroyed\n"); dlg = 0; return 0;
    }
    return DefWindowProc(h, m, wp, lp);
}

void bindings_dialog_open(void *parent)
{
    static int registered;
    static const char *tabs[4] = { "Joystick One", "Joystick Two", "Keyboard", "The Mouse" };
    RECT pr;
    int i, x = 100, y = 100;
    HWND b;
    if (dlg) { SetForegroundWindow(dlg); return; }
    if (!registered) {
        WNDCLASSA wc;
        INITCOMMONCONTROLSEX ic = { sizeof ic, ICC_TAB_CLASSES };
        InitCommonControlsEx(&ic);
        memset(&wc, 0, sizeof wc);
        wc.lpfnWndProc = dlg_proc; wc.hInstance = GetModuleHandle(0); wc.hCursor = LoadCursor(0, IDC_ARROW);
        wc.hbrBackground = (HBRUSH)(COLOR_BTNFACE + 1); wc.lpszClassName = "NHL95Bindings";
        RegisterClassA(&wc);
        font = (HFONT)GetStockObject(DEFAULT_GUI_FONT);
        registered = 1;
    }
    W = bind;
    cur = 2;
    if (parent && GetWindowRect((HWND)parent, &pr)) { x = pr.left + 40; y = pr.top + 60; }
    if (SystemParametersInfo(SPI_GETWORKAREA, 0, &pr, 0)) {                                /* all of it on the screen */
        if (y + 720 > pr.bottom) y = pr.bottom - 720;
        if (x + 500 > pr.right) x = pr.right - 500;
        if (y < pr.top) y = pr.top;
        if (x < pr.left) x = pr.left;
    }
    dlg = CreateWindowExA(WS_EX_DLGMODALFRAME, "NHL95Bindings", "Input bindings", WS_POPUP | WS_CAPTION | WS_SYSMENU | WS_VISIBLE, x, y, 500, 720, (HWND)parent, 0, GetModuleHandle(0), 0);
    if (!dlg) { fprintf(stderr, "Input bindings window: error %lu\n", (unsigned long)GetLastError()); return; }
    tab = CreateWindowExA(0, WC_TABCONTROLA, "", WS_CHILD | WS_VISIBLE | WS_TABSTOP, 8, 8, 476, 36, dlg, (HMENU)ID_TAB, 0, 0);
    set_font(tab);
    for (i = 0; i < 4; i++) {
        TCITEMA it;
        memset(&it, 0, sizeof it);
        it.mask = TCIF_TEXT; it.pszText = (char *)tabs[i];
        SendMessageA(tab, TCM_INSERTITEMA, i, (LPARAM)&it);
    }
    TabCtrl_SetCurSel(tab, cur);
    b = CreateWindowExA(0, "BUTTON", "Reset this control", WS_CHILD | WS_VISIBLE | WS_TABSTOP, 16, 640, 150, 28, dlg, (HMENU)ID_RESET, 0, 0); set_font(b);
    b = CreateWindowExA(0, "BUTTON", "OK", WS_CHILD | WS_VISIBLE | WS_TABSTOP | BS_DEFPUSHBUTTON, 300, 640, 84, 28, dlg, (HMENU)IDOK, 0, 0); set_font(b);
    b = CreateWindowExA(0, "BUTTON", "Cancel", WS_CHILD | WS_VISIBLE | WS_TABSTOP, 392, 640, 84, 28, dlg, (HMENU)IDCANCEL, 0, 0); set_font(b);
    build_rows();
    if (getenv("NHL95_MENUTRACE")) fprintf(stderr, "bindings window %p, %d rows\n", (void *)dlg, nrows);
}
