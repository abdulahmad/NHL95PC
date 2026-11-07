/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * Overbar: host harness around retro game ports. One menu model, one scaler,
 * two shells (overlay + native file menus). v1 is the standalone skeleton:
 * dest-rect, defaults, keys, overlay pages, Win32 file-menu stubs.
 */
#ifndef OVERBAR_H
#define OVERBAR_H

#include <stdint.h>
#include "mdrt/menu.h"

#ifdef __cplusplus
extern "C" {
#endif

/* ---- ports, profiles, scale ------------------------------------------- */

typedef enum {
    OB_PORT_GENERIC = 0,
    OB_PORT_GENESIS,    /* 94 Genesis C: one lo-res class, 224-in-240 DAR */
    OB_PORT_SNES,       /* 94 SNES C: lo-res only; no Native 1:1 */
    OB_PORT_PC94,       /* lo-res VGA 320x200 */
    OB_PORT_PC95,       /* hi-res 640x480 + lo-res 320x200 */
    OB_PORT_PC96
} ob_port;

typedef enum {
    OB_PROFILE_DESKTOP = 0,   /* windowed or fullscreen on a computer display */
    OB_PROFILE_HANDHELD       /* KMSDRM / RetroPie / PortMaster: overlay only, 60 Hz */
} ob_profile;

/* How the picture is shown. Handheld never picks desktop OpenGL (L6 / RG35XX). */
typedef enum {
    OB_PRESENT_SDL = 0,       /* SDL_Renderer: KMSDRM, GLES2, or software. No libGL */
    OB_PRESENT_GLES2,         /* EGL/GLES2 shaders (MiSTer / Lottes) */
    OB_PRESENT_GL             /* desktop OpenGL; never on handheld */
} ob_present_backend;

typedef enum {
    OB_CLASS_LORES = 0,
    OB_CLASS_HIRES,
    OB_CLASS_COUNT
} ob_class;

typedef enum {
    OB_REFRESH_60 = 0,
    OB_REFRESH_70,
    OB_REFRESH_VRR
} ob_refresh;

typedef enum {
    OB_MODE_SHARP = 0,
    OB_MODE_CRT,
    OB_MODE_MISTER,
    OB_MODE_RETROARCH,
    OB_MODE_SCALE2X,
    OB_MODE_SCALE3X,
    OB_MODE_MMPX2X,
    OB_MODE_MMPX4X,
    OB_MODE_XBR2X,
    OB_MODE_XBR3X,
    OB_MODE_XBR4X,
    OB_MODE_COUNT
} ob_scale_mode;

typedef enum {
    OB_HEIGHT_FIT = 0,
    OB_HEIGHT_INTEGER,
    OB_HEIGHT_OVERSCAN,
    OB_HEIGHT_AUTO_CROP
} ob_picture_height;

typedef enum {
    OB_CRT_LIGHT = 0,
    OB_CRT_MEDIUM,
    OB_CRT_STRONG,
    OB_CRT_SOFT,
    OB_CRT_SOFT_APERTURE,
    OB_CRT_CUSTOM,
    OB_CRT_COUNT
} ob_crt_look;

/* Integer prescale before the window fit. 3x (720p) is the default. */
typedef enum {
    OB_SHARP_2X = 0,
    OB_SHARP_3X,
    OB_SHARP_4X,
    OB_SHARP_5X,
    OB_SHARP_6X,
    OB_SHARP_9X,
    OB_SHARP_COUNT
} ob_sharp_amount;

enum {
    OB_PAGE_MAIN = 0,
    OB_PAGE_VIDEO,
    OB_PAGE_SOUND,
    OB_PAGE_INPUT,
    OB_PAGE_CAPTURE,
    OB_PAGE_ONLINE,
    OB_PAGE_KEYS,
    OB_PAGE_SCALE_HI,
    OB_PAGE_SCALE_LO,
    OB_PAGE_MODE_HI,
    OB_PAGE_MODE_LO,
    OB_PAGE_OPTS_HI,
    OB_PAGE_OPTS_LO,
    OB_PAGE_MISTER,             /* one directory of the MiSTer tree */
    OB_PAGE_COUNT
};

/* Shared tree ids. Addons start at OB_ID_ADDON. There is no Picture Native. */
enum {
    OB_ID_RESUME = 1,
    OB_ID_VIDEO,
    OB_ID_SOUND,
    OB_ID_INPUT,
    OB_ID_CAPTURE,
    OB_ID_ONLINE,
    OB_ID_KEYS,
    OB_ID_QUIT,
    OB_ID_BACK,
    OB_ID_REFRESH,
    OB_ID_VSYNC,
    OB_ID_STATS,
    OB_ID_SCALE_MODE,
    OB_ID_VIDEO_CLASS,          /* 95/96: Menus hi-res vs Gameplay lo-res */
    OB_ID_SHARP_AMOUNT,
    OB_ID_CRT_LOOK,
    OB_ID_PICTURE_HEIGHT,
    OB_ID_MONITOR_KHZ,          /* lo-res CRT / MiSTer */
    OB_ID_MISTER_PRESET,
    OB_ID_MISTER_H,
    OB_ID_MISTER_V,
    OB_ID_MISTER_GAMMA,
    OB_ID_MISTER_MASK,
    OB_ID_MISTER_MASK_SCALE,
    OB_ID_MISTER_BRIGHT,
    OB_ID_MISTER_RESET,
    OB_ID_RETROARCH_SHADER,
    OB_ID_BLEND,
    OB_ID_SCALE_HI,
    OB_ID_SCALE_LO,
    OB_ID_FM_CORE,
    OB_ID_FM_CHIP,
    OB_ID_POINTER,
    OB_ID_VOLUME,
    OB_ID_MUTE,
    OB_ID_CONTROLLERS,
    OB_ID_CAP_REPLAY,
    OB_ID_CAP_RECORD,
    OB_ID_CAP_SECONDS,
    OB_ID_CAP_GIFSCALE,
    OB_ID_ONLINE_NOTE,
    OB_ID_PRESENT_NOTE,
    OB_ID_MODE_MENU_HI,         /* Scaling: Scale Mode opens this */
    OB_ID_MODE_MENU_LO,
    OB_ID_OPTS_MENU_HI,         /* the selected mode's own knobs */
    OB_ID_OPTS_MENU_LO,
    OB_ID_MISTER_DIR,           /* a folder inside the MiSTer tree */
    OB_ID_MISTER_FILE,          /* a .txt or a preset .ini; value is the kind */
    OB_ID_ADDON = 1000
};

/* A horizontal divider between setting groups. Not a PulseMan item kind. */
#define OB_ITEM_SEP 64

/* SDL2 scancodes so a client can pass e.key.keysym.scancode through. */
enum {
    OB_SCANCODE_GRAVE = 53,
    OB_SCANCODE_F11 = 68,
    OB_SCANCODE_F12 = 69
};

typedef enum {
    OB_HOSTKEY_NONE = 0,
    OB_HOSTKEY_OVERLAY,         /* ` or F11; controller Back too */
    OB_HOSTKEY_STATS            /* F12 */
} ob_hostkey;

#define OB_ADDONS_MAX 16
#define OB_ITEMS_MAX 96          /* one MiSTer folder (the largest is under 70) */

typedef struct ob_addon {
    int id;
    const char *label;
    int (*open)(void *ctx);     /* 1 if the client handled it */
} ob_addon;

typedef struct ob_look {
    ob_scale_mode mode;
    int sharp;                  /* index into Sharp 1-4X or 3/5/7/11X */
    ob_crt_look crt;
    ob_picture_height height;
    int khz31;                  /* lo-res CRT/MiSTer: 0 = 15 kHz, 1 = 31 kHz */
    int mask_scale;             /* 1..4 */
    int bright;                 /* 70..150 step 10 */
    /* Paths under mister/, kind 0 H, 1 V, 2 gamma, 3 mask, 4 preset. Empty is none. */
    char mister_path[5][192];
} ob_look;

typedef struct ob_host {
    ob_port port;
    ob_profile profile;
    ob_refresh refresh;
    int vsync;
    int stats;
    ob_look lores, hires;
    int volume, mute;
    int blend;                  /* 0 off, 1 dither, 2 soft (PulseMan) */
    int pointer;                /* 0 auto, 1 show, 2 hide */
    int fm_core, fm_chip;
    int replay_secs_index;      /* 0 off, 1 10s, 2 20s, 3 30s, 4 60s */
    int gif_scale;              /* 0 1x, 1 2x, 2 3x */
    int recording;
    int online_ready;           /* Genesis PulseMan net; else "not in this build" */
    int has_sound;
    int has_hires;
    int console_dar;            /* 1: source 224, dest unit 240 */
    int overlay_open;
    int overlay_page;
    ob_class video_class;       /* which Scale Mode tree the Video page edits */
    int live_preview;           /* 1: a menu change is already in the host (always on) */
    int wrote_defaults;
    int request_quit;           /* overlay Quit: the client should exit */
    int mister_kind;            /* which MiSTer list the mister page is showing */
    char mister_dir[192];       /* that list's directory, under mister/ */
    char mister_row[OB_ITEMS_MAX][192]; /* path behind each row of the mister page */
    ob_present_backend present; /* SDL_Renderer on handheld; never GL there */
    const char *fallback_note;  /* Scale Mode that cannot run on this present */
    char ini_path[512];
    ob_addon addons[OB_ADDONS_MAX];
    int naddons;
    void *addon_ctx;
    mdrt_menu overlay;
} ob_host;

typedef struct ob_item {
    int id;
    int kind;                   /* MDRT_ITEM_* */
    const char *label;
    const char *const *choices;
    int nchoices;
    int value;
    char detail[192];
    char text[96];              /* owned label when it is not a literal */
} ob_item;

/* dest-rect: 4:3 of a dar_h canvas (240 for consoles); source stays src_h. */
typedef struct ob_view_in {
    int src_w, src_h;           /* texture; consoles keep 224 */
    int dar_h;                  /* 240 console, src_h VGA */
    int window_w, window_h;
    ob_picture_height height;
    int line_double;            /* 31 kHz: unit = dar_h * 2 */
    int auto_crop_src_rows;     /* 0: 6 at width 320 (and consoles), 10 otherwise */
} ob_view_in;

typedef struct ob_view_out {
    int canvas_x, canvas_y, canvas_w, canvas_h;   /* 4:3 dest of the dar_h canvas */
    int blit_x, blit_y, blit_w, blit_h;           /* where the source texture maps */
    int src_w, src_h;                             /* unchanged; no pad in the texture */
} ob_view_out;

/* ---- host ------------------------------------------------------------- */

void ob_host_init(ob_host *h, ob_port port, ob_profile profile);
void ob_host_free(ob_host *h);
int ob_handheld_env(void);                                /* CFW_NAME / PORTMASTER / OVERBAR_HANDHELD / RG35* */
ob_profile ob_profile_from_env(void);                     /* env + SDL_VIDEODRIVER; no SDL_Init needed */
ob_profile ob_profile_detect(const char *sdl_video_driver, int env_handheld);
void ob_defaults_apply(ob_host *h, ob_profile profile);   /* L15 first-launch values */
void ob_host_set_present(ob_host *h, int have_gles2, int have_desktop_gl);
int ob_host_load_ini(ob_host *h, const char *path);       /* 0 missing: apply defaults, save */
int ob_host_save_ini(const ob_host *h);

ob_hostkey ob_map_key(int sdl_scancode);
ob_hostkey ob_map_pad_back(void);                         /* controller Back → overlay */

int ob_has_hires(const ob_host *h);
int ob_snes_has_native(void);                             /* always 0: L12 */
int ob_mode_has_khz(ob_scale_mode m);
int ob_mode_is_pixel(ob_scale_mode m);                    /* Scale2x..xBR: picture height only */

const char *ob_mode_label(ob_scale_mode m);
int ob_sharp_mul(int index);                          /* 2, 3, 4, 5, 6 or 9 */
int ob_sharp_index(int mul);                          /* nearest step to a multiplier */
const char *const *ob_mode_choice_list(int *n);       /* overlay cycles these in place */
int ob_mode_choice_value(int index);                  /* choice index to ob_scale_mode */
int ob_mode_choice_index(ob_scale_mode m);
/* MiSTer taps as a prescale of the source (factor 3). *dst is owned here.
 * 1 when a frame was written. The caller then scales that image to the aspect rect. */
int ob_mister_prescale(const ob_look *look, const uint32_t *src, int sw, int sh, int spitch,
                       uint32_t **dst, int *dw, int *dh);
const char *ob_refresh_label(ob_refresh r);
const char *ob_height_label(ob_picture_height h);

/* Shared tree. Overlay and the file-menu stub both call these. */
int ob_main_items(const ob_host *h, ob_item *out, int cap);
int ob_video_items(const ob_host *h, ob_class cls, ob_item *out, int cap);
int ob_page_items(const ob_host *h, int page, ob_item *out, int cap);
/* One directory of the MiSTer tree (folders, then files). at_root adds None for gamma and mask. */
int ob_mister_entries(const char *dir_rel, int kind, int at_root, const char *selected,
                     ob_item *out, int cap);
void ob_mister_pick(ob_host *h, ob_class cls, int kind, const char *rel);
const char *ob_mister_selected(const ob_host *h, ob_class cls, int kind);
int ob_items_contain(const ob_item *items, int n, int id);
int ob_items_contain_label(const ob_item *items, int n, const char *label);

/* Apply a choice / action. Overlay does this on every change (live preview). */
int ob_host_apply(ob_host *h, ob_class cls, int id, int value);

/* The client paints and pauses. Overbar does not link SDL or the game host.
 * A NULL hook is a no-op, which is how the library test runs. */
typedef struct ob_shell {
    void (*picture)(const ob_host *h);
    void (*capture)(const ob_host *h, int id);
    void (*hold)(int paused);
    void (*redraw)(void);
    void (*draw_now)(void);
    int (*vsync)(int v);          /* -1 reads the running window */
    int (*stats)(int v);
    void (*quit)(void);
} ob_shell;

void ob_shell_set(const ob_shell *hooks);                 /* NULL clears */
void ob_picture_apply(const ob_host *h);                  /* calls shell.picture */
void ob_capture_apply(const ob_host *h, int id);          /* calls shell.capture */

int ob_host_add_addon(ob_host *h, int id, const char *label, int (*open)(void *ctx));

/* ---- scaler ----------------------------------------------------------- */

void ob_view(const ob_view_in *in, ob_view_out *out);
/* PAR of one source pixel: (blit_w/src_w) / (blit_h/src_h), as a reduced fraction. */
void ob_view_par(const ob_view_out *v, int *num, int *den);
/* Fill a view_in from the host for a console (dar_h=240) or VGA (dar_h=src_h) frame. */
void ob_view_from_host(const ob_host *h, ob_class cls, int src_w, int src_h,
                       int window_w, int window_h, ob_view_in *in);

/* ---- present (KMSDRM / SDL_Renderer; no desktop GL required) ---------- */

ob_present_backend ob_present_pick(ob_profile profile, int have_gles2, int have_desktop_gl);
int ob_look_supported(ob_scale_mode mode, ob_present_backend backend);
const char *ob_look_fallback_note(ob_scale_mode mode, ob_present_backend backend); /* NULL if ok */
void ob_present_apply_hints(ob_profile profile);          /* env for GLES2 renderer; no-op on desktop */
/* Nearest-neighbour blit of src into view->blit_* of dst (tests + SDL_Renderer upload). */
void ob_present_soft(const uint32_t *src, int src_w, int src_h,
                     uint32_t *dst, int dst_w, int dst_h, int dst_pitch,
                     const ob_view_out *view);

#ifdef OVERBAR_SDL
typedef struct ob_present_sdl {
    void *window;               /* SDL_Window * */
    void *renderer;             /* SDL_Renderer * */
    void *texture;              /* SDL_Texture * */
    int tex_w, tex_h;
} ob_present_sdl;
int ob_present_sdl_open(ob_present_sdl *p, const char *title, ob_host *h, int src_w, int src_h);
void ob_present_sdl_frame(ob_present_sdl *p, ob_host *h, const uint32_t *px, int src_w, int src_h);
void ob_present_sdl_close(ob_present_sdl *p);
#endif

/* ---- overlay ---------------------------------------------------------- */

void ob_overlay_open(ob_host *h);
void ob_overlay_close(ob_host *h);
void ob_overlay_build(ob_host *h);                        /* rebuild current page from the host */
int ob_overlay_input(ob_host *h, int mdrt_input);         /* applies + live-previews; 1 still open */
/* A mouse over the overlay buffer. what: 0 move, 1 left click, 2 right click, 3 wheel up, 4 wheel down. */
int ob_overlay_pointer(ob_host *h, int x, int y, int w, int hgt, int what);
void ob_overlay_draw(ob_host *h, uint32_t *px, int w, int hgt, int pitch);
int ob_overlay_toggle_key(ob_host *h, int sdl_scancode);  /* ` / F11; 1 if handled */
int ob_stats_toggle_key(ob_host *h, int sdl_scancode);    /* F12; 1 if handled */

/* ---- file-menu shell (Win32 CreateMenu; other OS bars later) */

/* A Win32 message, copied by the client out of its own window event.
 * Overbar does not include SDL. */
typedef struct ob_wm {
    unsigned msg;
    uintptr_t wparam;
} ob_wm;

int ob_filemenu_wanted(int windowed, int fullscreen, int handheld);
int ob_filemenu_items(const ob_host *h, ob_item *out, int cap);
void ob_filemenu_init(void *native_window);               /* Win32: HWND. Ignored elsewhere. */
void ob_filemenu_sync(const ob_host *h);
void ob_filemenu_after_change(int id);                    /* bar checkmarks track the overlay, and the reverse */
void ob_filemenu_show(int on);
void ob_filemenu_event(const ob_wm *wm);
int ob_filemenu_client_size(int *w, int *h);              /* 0 if unknown (non-Win32) */

#ifdef __cplusplus
}
#endif

#endif
