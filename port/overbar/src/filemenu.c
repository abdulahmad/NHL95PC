/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * Native file-menu shell. L3: menu bar only in windowed desktop. Overlay always
 * available. Handheld / KMSDRM: overlay only. Win32 CreateMenu from the same
 * item tree as the overlay; GTK/Cocoa bars are separate files.
 *
 * The bar does not link SDL or the game host. The client passes an HWND and
 * copies window messages into ob_wm. Picture, pause, and quit go through
 * ob_shell, which the library test leaves unset.
 *
 * Opening the Win32 bar runs Windows' own loop in the main thread, so the
 * client is asked to pause until the menu closes.
 */
#include "overbar/overbar.h"

#include <stdio.h>
#include <string.h>

#ifdef _WIN32
#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#endif

static ob_shell g_shell;
static int g_shown;
static ob_host *g_host;

void ob_shell_set(const ob_shell *hooks)
{
    if (hooks) g_shell = *hooks;
    else memset(&g_shell, 0, sizeof g_shell);
}

void ob_picture_apply(const ob_host *h)
{
    if (h && g_shell.picture) g_shell.picture(h);
}

void ob_capture_apply(const ob_host *h, int id)
{
    if (h && g_shell.capture) g_shell.capture(h, id);
}

#ifdef _WIN32
#define CMD0 0x1100
#define NCMDS 8192
#define MF0 0x4000
#define NMF 4096

static HWND g_hwnd;
static HMENU g_bar;
static struct { int id, value, cls; } cmds[NCMDS];
static int ncmds;
static int g_in_bar;
static int g_dirty;

static UINT add_cmd(int id, int value, int cls)
{
    UINT c;
    if (ncmds >= NCMDS) return 0;
    c = (UINT)(CMD0 + ncmds);
    cmds[ncmds].id = id;
    cmds[ncmds].value = value;
    cmds[ncmds].cls = cls;
    ncmds++;
    return c;
}

static int page_of(int id)
{
    switch (id) {
    case OB_ID_VIDEO: return OB_PAGE_VIDEO;
    case OB_ID_SOUND: return OB_PAGE_SOUND;
    case OB_ID_INPUT: return OB_PAGE_INPUT;
    case OB_ID_CAPTURE: return OB_PAGE_CAPTURE;
    case OB_ID_ONLINE: return OB_PAGE_ONLINE;
    case OB_ID_KEYS: return OB_PAGE_KEYS;
    case OB_ID_SCALE_HI: return OB_PAGE_SCALE_HI;
    case OB_ID_SCALE_LO: return OB_PAGE_SCALE_LO;
    case OB_ID_MODE_MENU_HI: return OB_PAGE_MODE_HI;
    case OB_ID_MODE_MENU_LO: return OB_PAGE_MODE_LO;
    case OB_ID_OPTS_MENU_HI: return OB_PAGE_OPTS_HI;
    case OB_ID_OPTS_MENU_LO: return OB_PAGE_OPTS_LO;
    default: return -1;
    }
}

static struct { int kind, cls; char rel[192]; } mfiles[NMF];
static int nmfiles;

static UINT add_mfile(int kind, int cls, const char *rel)
{
    UINT c;
    if (nmfiles >= NMF) return 0;
    c = (UINT)(MF0 + nmfiles);
    mfiles[nmfiles].kind = kind;
    mfiles[nmfiles].cls = cls;
    snprintf(mfiles[nmfiles].rel, sizeof mfiles[nmfiles].rel, "%s", rel ? rel : "");
    nmfiles++;
    return c;
}

static void fill_mister(HMENU menu, const char *rel, int kind, int cls, int at_root)
{
    ob_item items[OB_ITEMS_MAX];
    const char *sel = ob_mister_selected(g_host, cls ? OB_CLASS_HIRES : OB_CLASS_LORES, kind);
    int n = ob_mister_entries(rel, kind, at_root, sel, items, OB_ITEMS_MAX);
    int i;
    for (i = 0; i < n; i++) {
        if (items[i].id == OB_ID_MISTER_DIR) {
            HMENU sm = CreatePopupMenu();
            int pos;
            fill_mister(sm, items[i].detail, kind, cls, 0);
            pos = GetMenuItemCount(menu);
            AppendMenuA(menu, MF_POPUP, (UINT_PTR)sm, items[i].label ? items[i].label : "");
            if (sel && sel[0] && items[i].detail[0]
                && !strncmp(sel, items[i].detail, strlen(items[i].detail))
                && (sel[strlen(items[i].detail)] == '/' || sel[strlen(items[i].detail)] == 0))
                CheckMenuItem(menu, (UINT)pos, MF_BYPOSITION | MF_CHECKED);
        } else if (items[i].id == OB_ID_MISTER_FILE) {
            UINT cmd = add_mfile(kind, cls, items[i].detail);
            int on = sel && !strcmp(sel, items[i].detail);
            AppendMenuA(menu, MF_STRING | (on ? MF_CHECKED : 0), cmd, items[i].label ? items[i].label : "");
        } else if (items[i].kind == MDRT_ITEM_TEXT) {
            AppendMenuA(menu, MF_STRING | MF_GRAYED, 0, items[i].label ? items[i].label : "");
        }
    }
}

static void append_items(HMENU m, const ob_item *items, int n, int cls)
{
    int i;
    for (i = 0; i < n; i++) {
        const ob_item *it = &items[i];
        char buf[320];
        int subpage;
        if (it->id == OB_ID_BACK) continue;
        if (it->kind == OB_ITEM_SEP) {
            AppendMenuA(m, MF_SEPARATOR, 0, "");
            continue;
        }
        subpage = page_of(it->id);
        if (subpage >= 0 && subpage != OB_PAGE_VIDEO) {
            ob_item sub[OB_ITEMS_MAX];
            int ns = ob_page_items(g_host, subpage, sub, OB_ITEMS_MAX);
            HMENU sm = CreatePopupMenu();
            int subcls = (subpage == OB_PAGE_SCALE_HI || subpage == OB_PAGE_MODE_HI
                          || subpage == OB_PAGE_OPTS_HI) ? OB_CLASS_HIRES : OB_CLASS_LORES;
            append_items(sm, sub, ns, subcls);
            AppendMenuA(m, MF_POPUP, (UINT_PTR)sm, it->label ? it->label : "");
            continue;
        }
        if (it->id == OB_ID_MISTER_H || it->id == OB_ID_MISTER_V || it->id == OB_ID_MISTER_GAMMA
            || it->id == OB_ID_MISTER_MASK || it->id == OB_ID_MISTER_PRESET) {
            int kind = it->id == OB_ID_MISTER_PRESET ? 4 : it->id == OB_ID_MISTER_V ? 1
                : it->id == OB_ID_MISTER_GAMMA ? 2 : it->id == OB_ID_MISTER_MASK ? 3 : 0;
            const char *root = kind == 4 ? "Presets" : kind == 2 ? "Gamma" : kind == 3 ? "Shadow_Masks" : "Filters";
            HMENU sm = CreatePopupMenu();
            fill_mister(sm, root, kind, cls, 1);
            AppendMenuA(m, MF_POPUP, (UINT_PTR)sm, it->label ? it->label : "");
            continue;
        }
        if (it->kind == MDRT_ITEM_CHOICE && it->nchoices > 0 && it->choices
            && (it->id == OB_ID_MISTER_MASK_SCALE || it->id == OB_ID_MISTER_BRIGHT)) {
            int j;
            HMENU sm = CreatePopupMenu();
            for (j = 0; j < it->nchoices; j++) {
                const char *choice = it->choices[j] ? it->choices[j] : "";
                AppendMenuA(sm, MF_STRING, add_cmd(it->id, j, cls), choice);
            }
            AppendMenuA(m, MF_POPUP, (UINT_PTR)sm, it->label ? it->label : "");
            continue;
        }
        if (it->kind == MDRT_ITEM_CHOICE && it->nchoices > 0 && it->choices) {
            int j;
            /* "Vsync Off" / "Vsync On" sit on this menu, with a check on the one in use. */
            for (j = 0; j < it->nchoices; j++) {
                const char *choice = it->choices[j] ? it->choices[j] : "";
                snprintf(buf, sizeof buf, "%s %s", it->label ? it->label : "", choice);
                AppendMenuA(m, MF_STRING, add_cmd(it->id, j, cls), buf);
            }
        } else if (it->kind == MDRT_ITEM_TEXT) {
            snprintf(buf, sizeof buf, "%s%s%s", it->label ? it->label : "",
                     it->detail[0] ? " — " : "", it->detail);
            AppendMenuA(m, MF_STRING | MF_GRAYED, 0, buf);
        } else if (it->kind == MDRT_ITEM_NUMBER) {
            snprintf(buf, sizeof buf, "%s  %d", it->label ? it->label : "", it->value);
            AppendMenuA(m, MF_STRING | MF_GRAYED, 0, buf);
        } else {
            snprintf(buf, sizeof buf, "%s%s%s", it->label ? it->label : "",
                     it->detail[0] ? "\t" : "", it->detail);
            AppendMenuA(m, MF_STRING, add_cmd(it->id, it->value, cls), buf);
        }
    }
}

static int look_id(int id)
{
    switch (id) {
    case OB_ID_SCALE_MODE:
    case OB_ID_SHARP_AMOUNT:
    case OB_ID_CRT_LOOK:
    case OB_ID_PICTURE_HEIGHT:
    case OB_ID_MONITOR_KHZ:
    case OB_ID_MISTER_PRESET:
    case OB_ID_MISTER_H:
    case OB_ID_MISTER_V:
    case OB_ID_MISTER_GAMMA:
    case OB_ID_MISTER_MASK:
    case OB_ID_MISTER_MASK_SCALE:
    case OB_ID_MISTER_BRIGHT:
        return 1;
    default:
        return 0;
    }
}

static void apply_marks(void)
{
    static const int pages[] = {
        OB_PAGE_VIDEO, OB_PAGE_SCALE_HI, OB_PAGE_SCALE_LO, OB_PAGE_MODE_HI, OB_PAGE_MODE_LO,
        OB_PAGE_OPTS_HI, OB_PAGE_OPTS_LO, OB_PAGE_SOUND, OB_PAGE_INPUT,
        OB_PAGE_CAPTURE, OB_PAGE_ONLINE, OB_PAGE_KEYS
    };
    ob_item items[OB_ITEMS_MAX];
    int p, n, i, c;
    if (!g_bar || !g_host) return;
    for (c = 0; c < ncmds; c++) {
        int cur = -1, found = 0;
        int want = -1;
        if (cmds[c].id == OB_ID_SCALE_MODE && g_host) {
            const ob_look *look = cmds[c].cls ? &g_host->hires : &g_host->lores;
            CheckMenuItem(g_bar, (UINT)(CMD0 + c),
                          MF_BYCOMMAND | (cmds[c].value == (int)look->mode ? MF_CHECKED : MF_UNCHECKED));
            continue;
        }
        if (look_id(cmds[c].id)) {
            if (cmds[c].id == OB_ID_PICTURE_HEIGHT || cmds[c].id == OB_ID_MONITOR_KHZ)
                want = cmds[c].cls ? OB_PAGE_SCALE_HI : OB_PAGE_SCALE_LO;
            else
                want = cmds[c].cls ? OB_PAGE_OPTS_HI : OB_PAGE_OPTS_LO;
        }
        for (p = 0; p < (int)(sizeof pages / sizeof *pages); p++) {
            if (want >= 0 && pages[p] != want) continue;
            n = ob_page_items(g_host, pages[p], items, OB_ITEMS_MAX);
            for (i = 0; i < n; i++) {
                if (items[i].id == cmds[c].id && items[i].kind == MDRT_ITEM_CHOICE) {
                    cur = items[i].value;
                    found = 1;
                    break;
                }
            }
            if (found) break;
        }
        if (found)
            CheckMenuItem(g_bar, (UINT)(CMD0 + c),
                          MF_BYCOMMAND | (cmds[c].value == cur ? MF_CHECKED : MF_UNCHECKED));
    }
}

static void build_bar(void)
{
    ob_item main_items[OB_ITEMS_MAX];
    int n, i;
    if (!g_hwnd || !g_host) return;
    ncmds = 0;
    nmfiles = 0;
    if (g_bar) {
        SetMenu(g_hwnd, NULL);
        DestroyMenu(g_bar);
        g_bar = NULL;
    }
    g_bar = CreateMenu();
    n = ob_main_items(g_host, main_items, OB_ITEMS_MAX);
    for (i = 0; i < n; i++) {
        const ob_item *it = &main_items[i];
        int page;
        /* Resume and Quit are the overlay's. A bar has no game to resume. */
        if (it->id == OB_ID_RESUME || it->id == OB_ID_QUIT) continue;
        page = page_of(it->id);
        if (page >= 0) {
            ob_item sub[OB_ITEMS_MAX];
            int ns = ob_page_items(g_host, page, sub, OB_ITEMS_MAX);
            HMENU sm = CreatePopupMenu();
            append_items(sm, sub, ns, OB_CLASS_LORES);
            AppendMenuA(g_bar, MF_POPUP, (UINT_PTR)sm, it->label ? it->label : "");
        } else {
            AppendMenuA(g_bar, MF_STRING, add_cmd(it->id, 0, OB_CLASS_LORES), it->label ? it->label : "");
        }
    }
    apply_marks();
}

static void present_bar(void)
{
    if (!g_hwnd) return;
    SetMenu(g_hwnd, g_shown ? g_bar : NULL);
    DrawMenuBar(g_hwnd);
}

static void pull_shared(ob_host *h)
{
    int vsync = g_shell.vsync ? g_shell.vsync(-1) : -1;
    int fps = g_shell.stats ? g_shell.stats(-1) : -1;
    if (vsync >= 0) h->vsync = vsync;
    if (fps >= 0) h->stats = fps;
}

static void apply_cmd(int id, int value)
{
    int i;
    if (!g_host) return;
    if (id == OB_ID_RESUME) {
        ob_overlay_close(g_host);
        return;
    }
    if (id == OB_ID_QUIT) {
        g_host->request_quit = 1;
        ob_overlay_close(g_host);
        if (g_shell.quit) g_shell.quit();
        return;
    }
    if (id == OB_ID_CONTROLLERS) {
        if (!g_host->overlay_open) ob_overlay_open(g_host);
        g_host->overlay_page = OB_PAGE_INPUT;
        ob_overlay_build(g_host);
        return;
    }
    for (i = 0; i < g_host->naddons; i++) {
        if (g_host->addons[i].id == id && g_host->addons[i].open) {
            g_host->addons[i].open(g_host->addon_ctx);
            break;
        }
    }
    ob_host_apply(g_host, g_host->video_class, id, value);
    ob_picture_apply(g_host);
    ob_capture_apply(g_host, id);
    ob_filemenu_after_change(id);
}
#endif

int ob_filemenu_wanted(int windowed, int fullscreen, int handheld)
{
    return windowed && !fullscreen && !handheld;
}

int ob_filemenu_items(const ob_host *h, ob_item *out, int cap)
{
    /* Same ids as the overlay Video page. Resume and Quit stay on the overlay. */
    ob_item tmp[OB_ITEMS_MAX];
    int n = 0, i, v;
    if (cap < 1) return 0;
    v = ob_video_items(h, h->has_hires ? h->video_class : OB_CLASS_LORES, tmp, OB_ITEMS_MAX);
    for (i = 0; i < v && n < cap; i++) {
        if (tmp[i].id == OB_ID_BACK) continue;   /* a bar has no Back */
        out[n++] = tmp[i];
    }
    return n;
}

void ob_filemenu_init(void *native_window)
{
    g_shown = 0;
#ifdef _WIN32
    g_hwnd = (HWND)native_window;
    g_bar = NULL;
    ncmds = 0;
    g_in_bar = 0;
    g_dirty = 0;
#else
    (void)native_window;
#endif
}

void ob_filemenu_after_change(int id)
{
#ifdef _WIN32
    if (id == OB_ID_SCALE_MODE || id == OB_ID_CAP_RECORD)
        g_dirty = 1;
    if (g_in_bar) {
        if (g_bar) apply_marks();
        return;
    }
    if (g_dirty) {
        g_dirty = 0;
        build_bar();
        present_bar();
    } else if (g_bar)
        apply_marks();
#else
    (void)id;
#endif
}

void ob_filemenu_sync(const ob_host *h)
{
    g_host = (ob_host *)h;
#ifdef _WIN32
    if (g_host) pull_shared(g_host);
    if (!g_hwnd || !g_host) return;
    build_bar();
    SetMenu(g_hwnd, g_shown ? g_bar : NULL);
    DrawMenuBar(g_hwnd);
#endif
}

void ob_filemenu_show(int on)
{
    g_shown = on;
#ifdef _WIN32
    if (!g_hwnd) return;
    SetMenu(g_hwnd, on && g_bar ? g_bar : NULL);
    DrawMenuBar(g_hwnd);
#endif
}

void ob_filemenu_event(const ob_wm *wm)
{
#ifdef _WIN32
    WPARAM wp;
    if (!wm) return;
    wp = (WPARAM)wm->wparam;
    if (wm->msg == WM_EXITMENULOOP) {
        g_in_bar = 0;
        if (g_dirty) {
            g_dirty = 0;
            build_bar();
            present_bar();
        }
        return;
    }
    if (wm->msg == WM_INITMENU || wm->msg == WM_ENTERMENULOOP) {
        /* The bar's loop runs inside the window proc, so the game thread is
         * told to wait before that loop starts. The frame loop clears it. */
        g_in_bar = 1;
        if (g_shell.hold) g_shell.hold(1);
        if (wm->msg == WM_INITMENU && g_host) {
            pull_shared(g_host);
            if (g_dirty) {
                g_dirty = 0;
                build_bar();
                present_bar();
            } else
                apply_marks();
        }
        return;
    }
    if (wm->msg == WM_COMMAND && HIWORD(wp) == 0) {
        int mf = (int)LOWORD(wp) - MF0;
        int idx = (int)LOWORD(wp) - CMD0;
        if (mf >= 0 && mf < nmfiles && g_host) {
            ob_mister_pick(g_host, mfiles[mf].cls ? OB_CLASS_HIRES : OB_CLASS_LORES,
                           mfiles[mf].kind, mfiles[mf].rel);
            ob_picture_apply(g_host);
            if (g_host->overlay_open) {
                ob_overlay_build(g_host);
                if (g_shell.redraw) g_shell.redraw();
                if (g_shell.draw_now) g_shell.draw_now();
            }
            return;
        }
        if (idx >= 0 && idx < ncmds && g_host) {
            if (look_id(cmds[idx].id))
                g_host->video_class = cmds[idx].cls ? OB_CLASS_HIRES : OB_CLASS_LORES;
            apply_cmd(cmds[idx].id, cmds[idx].value);
            if (g_host->overlay_open) {
                ob_overlay_build(g_host);
                if (cmds[idx].id == OB_ID_SCALE_MODE) {
                    int k;
                    for (k = 0; k < g_host->overlay.count; k++)
                        if (g_host->overlay.items[k].id == OB_ID_SCALE_MODE
                            && g_host->overlay.items[k].value == cmds[idx].value) {
                            g_host->overlay.sel = k;
                            break;
                        }
                } else
                    mdrt_menu_select(&g_host->overlay, cmds[idx].id);
                if (g_shell.redraw) g_shell.redraw();
                if (g_shell.draw_now) g_shell.draw_now();
            }
        }
    }
#else
    (void)wm;
#endif
}

int ob_filemenu_client_size(int *w, int *h)
{
#ifdef _WIN32
    RECT r;
    if (!g_hwnd || !GetClientRect(g_hwnd, &r) || r.right <= 0 || r.bottom <= 0) return 0;
    if (w) *w = r.right;
    if (h) *h = r.bottom;
    return 1;
#else
    (void)w; (void)h;
    return 0;
#endif
}
