/* The window's menu bar (Windows): the refresh rate, vsync, the stats display and, for the menus (640x480) and the game (320x200) each, the
 * scaling and the picture height. The choices live in video.c (video_command); this file only builds the menu, shows the marks and passes
 * the clicks on. While the menu is open Windows runs its own loop in the main thread, so the game is paused (no timer ticks) until it closes. */
#include "host.h"
#include "audio.h"
#include "bindings.h"
#include <SDL.h>
#include <SDL_syswm.h>

static HWND hwnd;
static HMENU bar;
static WNDPROC old_proc;

/* While a menu is open, or the window is being dragged or sized, Windows runs its own loop in the main thread: the game stops, and the sound
 * would repeat what it last had. It is muted for as long. */
static LRESULT CALLBACK menu_proc(HWND h, UINT msg, WPARAM wp, LPARAM lp)
{
    if (msg == WM_ENTERMENULOOP || msg == WM_ENTERSIZEMOVE) audio_muted = 1;
    else if (msg == WM_EXITMENULOOP || msg == WM_EXITSIZEMOVE) audio_muted = 0;
    return CallWindowProcW(old_proc, h, msg, wp, lp);
}

static void item(HMENU m, int id, const char *text) { AppendMenuA(m, MF_STRING, (UINT_PTR)id, text); }
static void line(HMENU m) { AppendMenuA(m, MF_SEPARATOR, 0, NULL); }

static HMENU sub(HMENU parent, const char *text)
{
    HMENU m = CreatePopupMenu();
    AppendMenuA(parent, MF_POPUP, (UINT_PTR)m, text);
    return m;
}

static const char *hires[NHIRES_ITEMS] = {
    "1X - Standard", "2X - 1080p Sharp", "3X - 1440p Sharp", "4X - 4K Sharp",
    "CRT Monitor - light scanlines", "CRT Monitor - medium scanlines", "CRT Monitor - strong scanlines",
    "CRT Monitor - soft (Lottes style)", "CRT Monitor - soft + aperture grille", "CRT Monitor - MiSTer filters (see the MiSTer submenu)", "CRT Monitor - custom (scanlines, gamma, mask)" };
static const char *lores[NLORES_ITEMS] = {
    "3X - Standard", "5X - 1080p Sharp", "7X - 1440p Sharp", "11X - 4K Sharp",
    "CRT - light scanlines", "CRT - medium scanlines", "CRT - strong scanlines",
    "CRT - soft (Lottes style)", "CRT - soft + aperture grille",
    "CRT - MiSTer filters (see the MiSTer submenu)", "CRT - custom (scanlines, gamma, mask)" };
/* The files of the MiSTer look, as menus of the folders found under mister\Filters, mister\Gamma and mister\Shadow_Masks (the folders of the
 * MiSTer SD card): every .txt file is an item, every folder a submenu. */
#define MAX_FILES 9000
static struct { int cls, kind, pop; char rel[300]; } mfile[MAX_FILES];
static int nmfile;

/* The submenus, so that the marks can be followed down from the top: a submenu is checked when the item chosen is somewhere inside it. flag 1
 * is the MiSTer filters submenu itself (checked when the MiSTer look is on) and 2 a submenu of choices that always has one. */
#define MAX_POPS 4000
static struct { HMENU parent; UINT pos; int up, flag, cls; } pops[MAX_POPS];
static int npops;

static void add_files(HMENU parent, const char *rel, int cls, int kind, int depth, int up)
{
    char dir[1100], pat[1200], *base = SDL_GetBasePath();
    WIN32_FIND_DATAA fd;
    HANDLE h;
    int pass;
    snprintf(dir, sizeof dir, "%s%s", base ? base : "", rel);
    SDL_free(base);
    for (pass = 0; pass < 2; pass++) {              /* folders first, then files */
        snprintf(pat, sizeof pat, "%s/*", dir);
        h = FindFirstFileA(pat, &fd);
        if (h == INVALID_HANDLE_VALUE) return;
        do {
            char child[400];
            size_t len = strlen(fd.cFileName);
            if (fd.cFileName[0] == '.') continue;
            snprintf(child, sizeof child, "%s/%s", rel, fd.cFileName);
            if (pass == 0 && (fd.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) && depth < 4) {
                HMENU sm = CreatePopupMenu();
                int idx = npops < MAX_POPS ? npops++ : -1;
                add_files(sm, child, cls, kind, depth + 1, idx);
                if (GetMenuItemCount(sm) > 0) {
                    if (idx >= 0) { pops[idx].parent = parent; pops[idx].pos = GetMenuItemCount(parent); pops[idx].up = up; pops[idx].flag = 0; pops[idx].cls = cls; }
                    AppendMenuA(parent, MF_POPUP, (UINT_PTR)sm, fd.cFileName);
                } else {
                    DestroyMenu(sm);
                    if (idx >= 0) npops = idx;
                }
            } else if (pass == 1 && !(fd.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) && len > 4 && !_stricmp(fd.cFileName + len - 4, kind == 4 ? ".ini" : ".txt") && nmfile < MAX_FILES) {
                char label[300];
                snprintf(label, sizeof label, "%.*s", (int)len - 4, fd.cFileName);
                mfile[nmfile].cls = cls; mfile[nmfile].kind = kind; mfile[nmfile].pop = up;
                snprintf(mfile[nmfile].rel, sizeof mfile[nmfile].rel, "%s", child);
                AppendMenuA(parent, MF_STRING, (UINT_PTR)(CMD_MFILE + nmfile), label);
                nmfile++;
            }
        } while (FindNextFileA(h, &fd));
        FindClose(h);
    }
}

/* a submenu of the MiSTer menu, known to the marks */
static HMENU pop_sub(HMENU parent, const char *text, int flag, int cls, int *idx)
{
    HMENU m = CreatePopupMenu();
    *idx = npops < MAX_POPS ? npops++ : -1;
    if (*idx >= 0) { pops[*idx].parent = parent; pops[*idx].pos = GetMenuItemCount(parent); pops[*idx].up = -1; pops[*idx].flag = flag; pops[*idx].cls = cls; }
    AppendMenuA(parent, MF_POPUP, (UINT_PTR)m, text);
    return m;
}

static void add_mister_menu(HMENU parent, int cls)
{
    static const char *names[5] = { "Horizontal filter", "Vertical filter (scanlines)", "Gamma", "Shadow mask", "Presets" };
    static const char *roots[5] = { "mister/Filters", "mister/Filters", "mister/Gamma", "mister/Shadow_Masks", "mister/Presets" };
    HMENU m, k;
    int i, mi, ki;
    m = pop_sub(parent, "MiSTer filters", 1, cls, &mi);
    k = pop_sub(m, names[4], 0, cls, &ki);
    add_files(k, roots[4], cls, 4, 0, ki);
    line(m);
    for (i = 0; i < 4; i++) {
        k = pop_sub(m, names[i], 0, cls, &ki);
        if (i == 3 || i == 2) {                     /* no mask, no gamma */
            mfile[nmfile].cls = cls; mfile[nmfile].kind = i; mfile[nmfile].pop = ki;
            mfile[nmfile].rel[0] = 0;
            AppendMenuA(k, MF_STRING, (UINT_PTR)(CMD_MFILE + nmfile), "None");
            nmfile++;
        }
        add_files(k, roots[i], cls, i, 0, ki);
    }
    k = pop_sub(m, "Shadow mask scale", 2, cls, &ki);
    for (i = 0; i < 4; i++) {
        char t[16];
        snprintf(t, sizeof t, "%dx", i + 1);
        item(k, (cls ? CMD_MSCALE_LO : CMD_MSCALE_HI) + i, t);
    }
    k = pop_sub(m, "Brightness", 2, cls, &ki);
    for (i = 0; i < 9; i++) {
        char t[16];
        snprintf(t, sizeof t, "%d%%", 70 + 10 * i);
        item(k, (cls ? CMD_MBRIGHT_LO : CMD_MBRIGHT_HI) + i, t);
    }
    line(m);
    item(m, cls ? CMD_MRESET_LO : CMD_MRESET_HI, "Reset the MiSTer filters");
}

static const char *heights[4] = { "Picture height: fit the window", "Picture height: integer (even lines)", "Picture height: integer +1x overscan",
                                  "Picture height: auto crop (+1x when little is cut off)" };

void menu_init(void *sdl_window)
{
    SDL_SysWMinfo info;
    HMENU m;
    int i;
    SDL_VERSION(&info.version);
    if (!SDL_GetWindowWMInfo((SDL_Window *)sdl_window, &info)) return;
    hwnd = info.info.win.window;
    bar = CreateMenu();
    m = sub(bar, "Display");
    item(m, CMD_REFRESH_60, "60 Hz");
    item(m, CMD_REFRESH_70, "70 Hz");
    item(m, CMD_REFRESH_VRR, "VRR (draw each new image)");
    line(m);
    item(m, CMD_VSYNC, "V-Sync");
    item(m, CMD_STATS, "Stats display\t`");
    line(m);
    item(m, CMD_POINTER, "Windows pointer: automatic");
    item(m, CMD_POINTER + 1, "Windows pointer: always show");
    item(m, CMD_POINTER + 2, "Windows pointer: always hide");
    line(m);
    item(m, CMD_INPUT, "Input bindings...");
    m = sub(bar, "Menus (hi-res)");
    for (i = 0; i < 4; i++) item(m, CMD_HIRES + i, hires[i]);
    line(m);
    for (i = 4; i < 7; i++) item(m, CMD_HIRES + i, hires[i]);
    line(m);
    item(m, CMD_HIRES + 7, hires[7]); item(m, CMD_HIRES + 8, hires[8]); item(m, CMD_HIRES + 10, hires[10]);       /* soft looks, then the custom look */
    line(m);
    item(m, CMD_HIRES + 9, hires[9]);                  /* the MiSTer look and its filters together */
    add_mister_menu(m, 0);
    line(m);
    for (i = 0; i < 4; i++) item(m, CMD_VSCALE_HI + i, heights[i]);
    m = sub(bar, "Gameplay (lo-res)");
    for (i = 0; i < 4; i++) item(m, CMD_LORES + i, lores[i]);
    line(m);
    for (i = 4; i < 7; i++) item(m, CMD_LORES + i, lores[i]);
    line(m);
    item(m, CMD_LORES + 7, lores[7]); item(m, CMD_LORES + 8, lores[8]); item(m, CMD_LORES + 10, lores[10]);
    line(m);
    item(m, CMD_LORES + 9, lores[9]);
    add_mister_menu(m, 1);
    line(m);
    item(m, CMD_MKHZ, "Monitor - 15kHz (single scan - TV standard)");           /* for every CRT look above, not the plain scales */
    item(m, CMD_MKHZ + 1, "Monitor - 31kHz (double scan - VGA standard)");
    line(m);
    for (i = 0; i < 4; i++) item(m, CMD_VSCALE_LO + i, heights[i]);
    old_proc = (WNDPROC)SetWindowLongPtrW(hwnd, GWLP_WNDPROC, (LONG_PTR)menu_proc);
    SDL_EventState(SDL_SYSWMEVENT, SDL_ENABLE);
    SetMenu(hwnd, bar);
    menu_sync();
}

static void radio(int first, int n)
{
    int i;
    for (i = 0; i < n; i++)
        if (video_command_checked(first + i)) CheckMenuRadioItem(bar, first, first + n - 1, first + i, MF_BYCOMMAND);
}

/* the marks follow the settings */
void menu_sync(void)
{
    int i;
    if (!bar) return;
    radio(CMD_REFRESH_60, 3);
    CheckMenuItem(bar, CMD_VSYNC, MF_BYCOMMAND | (video_command_checked(CMD_VSYNC) ? MF_CHECKED : MF_UNCHECKED));
    CheckMenuItem(bar, CMD_STATS, MF_BYCOMMAND | (video_command_checked(CMD_STATS) ? MF_CHECKED : MF_UNCHECKED));
    radio(CMD_POINTER, 3);
    radio(CMD_MKHZ, 2);
    radio(CMD_MBRIGHT_HI, 9);
    radio(CMD_MBRIGHT_LO, 9);
    radio(CMD_MSCALE_HI, 4);
    radio(CMD_MSCALE_LO, 4);
    {
        static unsigned char pc[MAX_POPS];
        memset(pc, 0, sizeof pc);
        for (i = 0; i < nmfile; i++)
            if (mfile[i].kind < 4 ? !strcmp(mfile[i].rel, video_mister_path(mfile[i].cls, mfile[i].kind)) : video_mister_preset_active(mfile[i].cls, mfile[i].rel)) {
                int p;
                for (p = mfile[i].pop; p >= 0; p = pops[p].up) pc[p] = 1;
            }
        for (i = 0; i < npops; i++) {
            if (pops[i].flag == 1) pc[i] = (unsigned char)video_command_checked(pops[i].cls ? CMD_LORES + 9 : CMD_HIRES + 9);
            if (pops[i].flag == 2) pc[i] = 1;
            if (pops[i].up < 0 && pops[i].flag != 1) pc[i] = 0;       /* the choices at the top of the MiSTer menu always have a mark inside: none shown */
            CheckMenuItem(pops[i].parent, pops[i].pos, MF_BYPOSITION | (pc[i] ? MF_CHECKED : MF_UNCHECKED));
        }
    }
    for (i = 0; i < nmfile; i++)
        CheckMenuItem(bar, CMD_MFILE + i, MF_BYCOMMAND | ((mfile[i].kind < 4 ? !strcmp(mfile[i].rel, video_mister_path(mfile[i].cls, mfile[i].kind)) : video_mister_preset_active(mfile[i].cls, mfile[i].rel)) ? MF_CHECKED : MF_UNCHECKED));
    radio(CMD_HIRES, NHIRES_ITEMS);
    radio(CMD_LORES, NLORES_ITEMS);
    radio(CMD_VSCALE_HI, 4);
    radio(CMD_VSCALE_LO, 4);
}

/* the bar is shown in a window and hidden in fullscreen */
void menu_show(int on)
{
    if (!hwnd) return;
    SetMenu(hwnd, on ? bar : NULL);
    DrawMenuBar(hwnd);
}

/* The size of the window's client area as Windows has it now. SDL's own idea of the window size is not always up to date after the menu
 * bar is shown or hidden or the window is maximized, which moved the picture down. */
int menu_client_size(int *w, int *h)
{
    RECT r;
    if (!hwnd || !GetClientRect(hwnd, &r) || r.right <= 0 || r.bottom <= 0) return 0;
    *w = r.right; *h = r.bottom;
    return 1;
}

void menu_event(void *syswm_msg)
{
    SDL_SysWMmsg *m = (SDL_SysWMmsg *)syswm_msg;
    if (m->subsystem == SDL_SYSWM_WINDOWS && m->msg.win.msg == WM_COMMAND && HIWORD(m->msg.win.wParam) == 0) {
        int id = LOWORD(m->msg.win.wParam);
        if (getenv("NHL95_MENUTRACE")) fprintf(stderr, "menu command %d\n", id);
        if (id == CMD_INPUT) bindings_dialog_open(hwnd);
        else if (id >= CMD_MFILE && id < CMD_MFILE + nmfile) video_mister_pick(mfile[id - CMD_MFILE].cls, mfile[id - CMD_MFILE].kind, mfile[id - CMD_MFILE].rel);
        else if (id >= CMD_REFRESH_60) video_command(id);
    }
}
