/* The window, its events and the menu bar come from Overbar's SDL2 platform layer (overbar/plat.h): this file is 95 PC's side of it, the hooks.
 * The layer makes the window (OpenGL when asked), the native bar (Windows), the overlay's keys and the live redraw while Windows sizes the
 * window; 95 PC keeps its own present (video.c / video_gl.c), the game's keys and mouse, and the DOS game port's controllers (input.c). */
#include "host.h"
#include "audio.h"
#include "overbar_client.h"
#include "bindings.h"
#include <SDL.h>
#include <string.h>
#include <overbar/plat.h>

volatile int menu_resync;
volatile int quit_requested;

/* hold: the bar's menu loop ran in the main thread, so the game clock did not run. The ticks it would have caught up are dropped, as when the
 * overlay is open (host.c raises IRQ0 only while it is closed). */
static void shell_hold(int paused)
{
    if (paused) menu_resync = 1;
}

static void shell_picture(const ob_host *h) { (void)h; overbar_client_apply(); }
static void shell_redraw(void) {}
static void shell_draw_now(void) { video_present(); }
static int shell_vsync(int v) { (void)v; return video_command_checked(CMD_VSYNC); }
static int shell_stats(int v) { (void)v; return video_command_checked(CMD_STATS); }
static void shell_quit(void) { quit_requested = 1; }
#ifdef _WIN32
static void shell_controllers(void) { bindings_dialog_open(NULL); }      /* the bar's Input > Controllers: the bindings dialog, at once */
#else
#define shell_controllers NULL
#endif

static const ob_shell shell = {
    shell_picture, NULL, shell_hold, shell_redraw, shell_draw_now, shell_vsync, shell_stats, shell_quit, shell_controllers
};

/* While a menu is open, or the window is dragged or sized, Windows runs its own loop in the main thread: the game stops, and the sound
 * would repeat what it last had. It is muted for as long. */
static void hook_modal(int on) { audio_muted = on; }

static int hook_action(int id)
{
#ifdef _WIN32
    if (id == OB_ID_CONTROLLERS) { bindings_dialog_open(NULL); return 1; }
#else
    (void)id;
#endif
    return 0;
}

/* the keys the port takes before the layer: Alt+Enter goes through video_toggle_fullscreen (it keeps the pointer and the bar), Ctrl+F11 records */
static int hook_event(const SDL_Event *e)
{
    if (e->type != SDL_KEYDOWN) return 0;
    if (e->key.keysym.scancode == SDL_SCANCODE_F9) {            /* F9: the on-screen keyboard (for names; a pad or the arrow keys move it) */
        if (!e->key.repeat) { if (ob_plat_osk_is_open()) ob_plat_osk_close(); else ob_plat_osk_open(); }
        return 1;
    }
    if (e->key.keysym.scancode == SDL_SCANCODE_RETURN && (e->key.keysym.mod & KMOD_ALT)) {
        if (!e->key.repeat) video_toggle_fullscreen();
        return 1;
    }
    if (audio_debug() && e->key.keysym.scancode == SDL_SCANCODE_F11 && (e->key.keysym.mod & KMOD_CTRL)) {
        if (!e->key.repeat) audio_capture_toggle();
        return 1;
    }
    return 0;
}

SDL_Window *shell_open(const char *title, int w, int h, int gl)
{
    ob_plat_hooks hk;
    memset(&hk, 0, sizeof hk);
    hk.title = title;
    hk.win_w = w;
    hk.win_h = h;
    hk.window_only = 1;
    hk.gl = gl;
    hk.no_pads = 1;
    hk.present = video_present;
    hk.changed = overbar_client_apply;
    hk.action = hook_action;
    hk.event = hook_event;
    hk.unused = input_event;
    hk.modal = hook_modal;
    hk.key = input_osk_key;
    hk.quit_flag = &quit_requested;
    ob_shell_set(&shell);
    if (!ob_plat_open(&hk, overbar_client_host())) return NULL;
    return ob_plat_window();
}

void shell_close(void) { ob_plat_close(); }

/* the marks follow the settings */
void menu_sync(void) { ob_filemenu_after_change(0); }

/* the bar is shown in a window and hidden in fullscreen */
void menu_show(int on) { ob_filemenu_show(on); }

/* The size of the window's client area as the bar has it now (SDL's own idea is not always up to date after the bar is shown or hidden). */
int menu_client_size(int *w, int *h) { return ob_filemenu_client_size(w, h); }
