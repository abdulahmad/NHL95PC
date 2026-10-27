/* The window's menu bar (Windows): the refresh rate, vsync, the stats display and the scaling of the menus (640x480) and of the game
 * (320x200). The choices live in video.c (video_command); this file only builds the menu, shows the marks and passes the clicks on.
 * While the menu is open Windows runs its own loop in the main thread, so the game is paused (no timer ticks) until it closes. */
#include "host.h"
#include <SDL.h>
#include <SDL_syswm.h>

static HWND hwnd;
static HMENU bar;

static void item(HMENU m, int id, const char *text) { AppendMenuA(m, MF_STRING, (UINT_PTR)id, text); }

static HMENU sub(HMENU parent, const char *text)
{
    HMENU m = CreatePopupMenu();
    AppendMenuA(parent, MF_POPUP, (UINT_PTR)m, text);
    return m;
}

void menu_init(void *sdl_window)
{
    SDL_SysWMinfo info;
    HMENU m;
    int i;
    static const char *hires[] = { "1X - Standard", "2X - 1080p Sharp", "3X - 1440p Sharp", "4X - 4K Sharp",
                                   "CRT Monitor - light scanlines", "CRT Monitor - medium scanlines", "CRT Monitor - strong scanlines" };
    static const char *lores[] = { "3X - Standard", "5X - 1080p Sharp", "7X - 1440p Sharp", "11X - 4K Sharp",
                                   "CRT TV - light scanlines", "CRT TV - medium scanlines", "CRT TV - strong scanlines",
                                   "CRT Monitor (line doubled) - light scanlines", "CRT Monitor (line doubled) - medium scanlines",
                                   "CRT Monitor (line doubled) - strong scanlines" };
    SDL_VERSION(&info.version);
    if (!SDL_GetWindowWMInfo((SDL_Window *)sdl_window, &info)) return;
    hwnd = info.info.win.window;
    bar = CreateMenu();
    m = sub(bar, "Display");
    item(m, CMD_REFRESH_60, "60 Hz");
    item(m, CMD_REFRESH_70, "70 Hz");
    item(m, CMD_REFRESH_VRR, "VRR (draw each new image)");
    AppendMenuA(m, MF_SEPARATOR, 0, NULL);
    item(m, CMD_VSYNC, "V-Sync");
    item(m, CMD_STATS, "Stats display");
    m = sub(bar, "Menus (hi-res)");
    for (i = 0; i < 7; i++) {
        if (i == 4) AppendMenuA(m, MF_SEPARATOR, 0, NULL);
        item(m, CMD_HIRES + i, hires[i]);
    }
    m = sub(bar, "Gameplay (lo-res)");
    for (i = 0; i < 10; i++) {
        if (i == 4) AppendMenuA(m, MF_SEPARATOR, 0, NULL);
        item(m, CMD_LORES + i, lores[i]);
    }
    SDL_EventState(SDL_SYSWMEVENT, SDL_ENABLE);
    SetMenu(hwnd, bar);
    menu_sync();
}

/* the marks follow the settings */
void menu_sync(void)
{
    int i;
    if (!bar) return;
    for (i = CMD_REFRESH_60; i <= CMD_REFRESH_VRR; i++)
        if (video_command_checked(i)) CheckMenuRadioItem(bar, CMD_REFRESH_60, CMD_REFRESH_VRR, i, MF_BYCOMMAND);
    CheckMenuItem(bar, CMD_VSYNC, MF_BYCOMMAND | (video_command_checked(CMD_VSYNC) ? MF_CHECKED : MF_UNCHECKED));
    CheckMenuItem(bar, CMD_STATS, MF_BYCOMMAND | (video_command_checked(CMD_STATS) ? MF_CHECKED : MF_UNCHECKED));
    for (i = 0; i < 7; i++)
        if (video_command_checked(CMD_HIRES + i)) CheckMenuRadioItem(bar, CMD_HIRES, CMD_HIRES + 6, CMD_HIRES + i, MF_BYCOMMAND);
    for (i = 0; i < 10; i++)
        if (video_command_checked(CMD_LORES + i)) CheckMenuRadioItem(bar, CMD_LORES, CMD_LORES + 9, CMD_LORES + i, MF_BYCOMMAND);
}

/* the bar is shown in a window and hidden in fullscreen */
void menu_show(int on)
{
    if (!hwnd) return;
    SetMenu(hwnd, on ? bar : NULL);
    DrawMenuBar(hwnd);
}

void menu_event(void *syswm_msg)
{
    SDL_SysWMmsg *m = (SDL_SysWMmsg *)syswm_msg;
    if (m->subsystem == SDL_SYSWM_WINDOWS && m->msg.win.msg == WM_COMMAND && HIWORD(m->msg.win.wParam) == 0) {
        int id = LOWORD(m->msg.win.wParam);
        if (id >= CMD_REFRESH_60) video_command(id);
    }
}
