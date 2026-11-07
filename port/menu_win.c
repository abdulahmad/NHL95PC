/* The window's menu bar (Windows): Overbar's own bar (ob_filemenu), built from the same items as the overlay's main page without Resume and
 * Quit. A pick on the bar goes through ob_host_apply and then the shell's picture hook below, which is the client's apply_host: the same
 * path as the overlay, ending in video_command. This file keeps what is 95 PC's own: the sound muted and the picture drawn while the window
 * is in Windows' menu / sizing loop, the bar shown only in a window, and the client size. */
#include "host.h"
#include "audio.h"
#include "overbar_client.h"
#include "bindings.h"
#include <SDL.h>
#include <SDL_syswm.h>

static HWND hwnd;
static WNDPROC old_proc;
volatile int menu_resync;

/* While a menu is open, or the window is being dragged or sized, Windows runs its own loop in the main thread: the game stops, and the sound
 * would repeat what it last had. It is muted for as long. */
/* Sizing the window also runs that loop, so the main loop does not draw until the mouse button is let go. Each size change while it runs is
 * drawn here instead, so the picture follows the scaling rules (picture height, auto crop) as the window is sized, not only at the end. */
static int sizing, drawing;
static LRESULT CALLBACK menu_proc(HWND h, UINT msg, WPARAM wp, LPARAM lp)
{
    LRESULT r;
    if (msg == WM_ENTERMENULOOP || msg == WM_ENTERSIZEMOVE) audio_muted = 1;
    else if (msg == WM_EXITMENULOOP || msg == WM_EXITSIZEMOVE) audio_muted = 0;
    if (msg == WM_ENTERSIZEMOVE) sizing = 1;
    else if (msg == WM_EXITSIZEMOVE) sizing = 0;
    r = CallWindowProcW(old_proc, h, msg, wp, lp);
    if (sizing && !drawing && (msg == WM_SIZE || msg == WM_PAINT)) { drawing = 1; video_present(); drawing = 0; }
    return r;
}

/* Overbar's shell hooks. picture: a pick on the bar was applied to the ob_host; hand it to video_command like an overlay change. */
static void shell_picture(const ob_host *h)
{
    (void)h;
    overbar_client_apply();
}

/* hold: the bar's menu loop ran in the main thread, so the game clock did not run. The ticks it would have caught up are dropped, as when the
 * overlay is open (host.c raises IRQ0 only while it is closed). The events reach us after the loop has ended, so this is a request to drop
 * the backlog, not a state to clear. */
static void shell_hold(int paused)
{
    if (paused) menu_resync = 1;
}

static void shell_draw_now(void) { if (!drawing) { drawing = 1; video_present(); drawing = 0; } }
static void shell_redraw(void) {}
static int shell_vsync(int v) { (void)v; return video_command_checked(CMD_VSYNC); }
static int shell_stats(int v) { (void)v; return video_command_checked(CMD_STATS); }
static void shell_quit(void)
{
    SDL_Event q;
    SDL_zero(q);
    q.type = SDL_QUIT;
    SDL_PushEvent(&q);
}

/* the bar's Input > Controllers: the bindings dialog, at once */
static void shell_controllers(void) { bindings_dialog_open(NULL); }

static const ob_shell shell = {
    shell_picture, NULL, shell_hold, shell_redraw, shell_draw_now, shell_vsync, shell_stats, shell_quit, shell_controllers
};

void menu_init(void *sdl_window)
{
    SDL_SysWMinfo info;
    SDL_VERSION(&info.version);
    if (!SDL_GetWindowWMInfo((SDL_Window *)sdl_window, &info)) return;
    hwnd = info.info.win.window;
    ob_shell_set(&shell);
    ob_filemenu_init(hwnd);
    old_proc = (WNDPROC)SetWindowLongPtrW(hwnd, GWLP_WNDPROC, (LONG_PTR)menu_proc);
    SDL_EventState(SDL_SYSWMEVENT, SDL_ENABLE);
    ob_filemenu_show(1);
    ob_filemenu_sync(overbar_client_host());
}

/* the marks follow the settings */
void menu_sync(void)
{
    if (!hwnd) return;
    ob_filemenu_after_change(0);
}

/* the bar is shown in a window and hidden in fullscreen */
void menu_show(int on)
{
    if (!hwnd) return;
    ob_filemenu_show(on);
}

/* The size of the window's client area as Windows has it now. SDL's own idea of the window size is not always up to date after the menu
 * bar is shown or hidden or the window is maximized, which moved the picture down. */
int menu_client_size(int *w, int *h)
{
    return hwnd ? ob_filemenu_client_size(w, h) : 0;
}

void menu_event(void *syswm_msg)
{
    SDL_SysWMmsg *m = (SDL_SysWMmsg *)syswm_msg;
    ob_wm wm;
    if (!hwnd || m->subsystem != SDL_SYSWM_WINDOWS) return;
    wm.msg = m->msg.win.msg;
    wm.wparam = (uintptr_t)m->msg.win.wParam;
    ob_filemenu_event(&wm);
}
