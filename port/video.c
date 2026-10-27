/* VGA / VESA emulation. The game draws into the 64 KB window at 0xA0000 and switches banks with int 10h function 4F05h,
 * like it did on a banked SVGA card. The host keeps the whole frame buffer in vram[], saves and loads the window when the bank
 * changes, and the main thread turns vram[] into an SDL texture a few dozen times a second. */
#include "host.h"
#include <math.h>
#include <SDL.h>

#define WINDOW ((uint8_t *)0xA0000)

#define BANK 0x10000
static uint8_t vram[0x800000];
static uint8_t dac[256][3];
static unsigned dac_wr, dac_rd, dac_comp, dac_rcomp;
static int cur_bank;
static int mode_w = 640, mode_h = 480, mode_num = 0x101;
static int disp_x, disp_y;
static SDL_mutex *lock;
static volatile int resize_pending = 1;
static volatile int shown_w, shown_h;

static SDL_Window *win;
static SDL_Renderer *ren;
static SDL_Texture *tex;
static int tex_w, tex_h;
static int use_gl;                              /* the OpenGL path (video_gl.c) instead of SDL's renderer */
#ifdef HAVE_GL
int vgl_init(SDL_Window *win);
void vgl_draw(SDL_Window *win, const uint32_t *argb, int w, int h, int vx, int vy, int vw, int vh);
void vgl_quit(void);
void vgl_set_vsync(int on);
void vgl_set_look(int pre, float sigma, float gain, float center, int period);
void vgl_osd_set(const char *l1, const char *l2, const char *l3);
#else                                           /* the Linux build has no OpenGL path yet: SDL's renderer only */
static int vgl_init(SDL_Window *win) { (void)win; return 0; }
static void vgl_draw(SDL_Window *win, const uint32_t *argb, int w, int h, int vx, int vy, int vw, int vh)
{ (void)win; (void)argb; (void)w; (void)h; (void)vx; (void)vy; (void)vw; (void)vh; }
static void vgl_quit(void) {}
static void vgl_set_vsync(int on) { (void)on; }
static void vgl_set_look(int pre, float sigma, float gain, float center, int period) { (void)pre; (void)sigma; (void)gain; (void)center; (void)period; }
static void vgl_osd_set(const char *l1, const char *l2, const char *l3) { (void)l1; (void)l2; (void)l3; }
#endif
static uint32_t argb[1280 * 1024];

/* ---- the settings: how often the window is drawn, vsync, the numbers on the picture, and how the picture is scaled ----
 * They are kept in hockey-win32.ini (hockey-linux.ini) next to the program and changed from the window's menu or the keys 1-6. */
static int present_hz = 60, vsync_on = 1, osd_on, vrr_on;
static void title_refresh(void);
static int hires_mode, lores_mode, vscale_mode, ptr_mode;              /* the scaling of the 640x480 screens and of the 320x200 screens: see the tables */
#define NHIRES 7
#define NLORES 10
static const char *hires_names[NHIRES] = { "1x", "2x", "3x", "4x", "crt-light", "crt-medium", "crt-strong" };
static const char *lores_names[NLORES] = { "3x", "5x", "7x", "11x", "tv-light", "tv-medium", "tv-strong", "monitor-light", "monitor-medium", "monitor-strong" };
static const float scan_strength[3] = { 0.80f, 0.60f, 0.45f };   /* the sigma of the scanline profile: the smaller, the darker the gaps */
static const char *vscale_names[3] = { "fit", "integer", "overscan" };
static const char *ptr_names[3] = { "auto", "show", "hide" };

/* the integer scale taken before the window's bicubic scaling, the strength of the scanlines and how many there are per source line */
static void look(int w, int *pre, float *scan, int *period)
{
    static const int lo_pre[4] = { 3, 5, 7, 11 };
    *scan = 0; *period = 1;
    if (w == 320) {
        int m = lores_mode;
        *pre = m < 4 ? lo_pre[m] : 3;
        if (m >= 4 && m < 7) *scan = scan_strength[m - 4];
        if (m >= 7) { *scan = scan_strength[m - 7]; *period = 2; }
    } else {
        int m = hires_mode;
        *pre = m < 4 ? m + 1 : 1;
        if (m >= 4) *scan = scan_strength[m - 4];
    }
}

#ifdef _WIN32
#define INI_NAME "hockey-win32.ini"
#else
#define INI_NAME "hockey-linux.ini"
#endif

static void ini_path(char *out, size_t n)
{
    char *base = SDL_GetBasePath();
    snprintf(out, n, "%s%s", base ? base : "", INI_NAME);
    SDL_free(base);
}

static int name_index(const char *v, const char **names, int n, int def)
{
    int i;
    for (i = 0; i < n; i++) if (!strcmp(v, names[i])) return i;
    return def;
}

static void settings_load(void)
{
    char path[1024], line[256];
    FILE *f;
    ini_path(path, sizeof path);
    f = fopen(path, "r");
    if (!f) return;
    while (fgets(line, sizeof line, f)) {
        char *k = line, *v = strchr(line, '='), *e;
        if (!v || line[0] == ';' || line[0] == '[') continue;
        *v++ = 0;
        while (*k == ' ') k++;
        for (e = k + strlen(k); e > k && e[-1] == ' '; ) *--e = 0;
        while (*v == ' ') v++;
        for (e = v + strlen(v); e > v && (e[-1] == ' ' || e[-1] == '\n' || e[-1] == '\r'); ) *--e = 0;
        if (!strcmp(k, "refresh")) { if (!strcmp(v, "70")) present_hz = 70, vrr_on = 0; else if (!strcmp(v, "vrr")) vrr_on = 1; else present_hz = 60, vrr_on = 0; }
        else if (!strcmp(k, "vsync")) vsync_on = strcmp(v, "off") != 0;
        else if (!strcmp(k, "stats")) osd_on = !strcmp(v, "on");
        else if (!strcmp(k, "hires_scaling")) hires_mode = name_index(v, hires_names, NHIRES, 0);
        else if (!strcmp(k, "lores_scaling")) lores_mode = name_index(v, lores_names, NLORES, 0);
        else if (!strcmp(k, "picture_height")) vscale_mode = name_index(v, vscale_names, 3, 0);
        else if (!strcmp(k, "windows_pointer")) ptr_mode = name_index(v, ptr_names, 3, 0);
    }
    fclose(f);
}

static void settings_save(void)
{
    char path[1024];
    FILE *f;
    ini_path(path, sizeof path);
    f = fopen(path, "w");
    if (!f) return;
    fprintf(f, "; NHL Hockey 95 (SDL2 port) settings. Changed from the window menu; edit them here too.\n[video]\n");
    fprintf(f, "; refresh: 60, 70 or vrr (draw whenever the game's picture changes, for variable refresh rate monitors)\nrefresh=%s\n", vrr_on ? "vrr" : present_hz == 70 ? "70" : "60");
    fprintf(f, "; vsync: on or off\nvsync=%s\n", vsync_on ? "on" : "off");
    fprintf(f, "; stats: on or off (frames per second, CPU and GPU use, in the top right corner)\nstats=%s\n", osd_on ? "on" : "off");
    fprintf(f, "; hires_scaling (the 640x480 menus): 1x, 2x, 3x, 4x, crt-light, crt-medium, crt-strong\nhires_scaling=%s\n", hires_names[hires_mode]);
    fprintf(f, "; lores_scaling (the 320x200 game): 3x, 5x, 7x, 11x, tv-light, tv-medium, tv-strong, monitor-light, monitor-medium, monitor-strong\nlores_scaling=%s\n", lores_names[lores_mode]);
    fprintf(f, "; picture_height: fit (the window), integer (the biggest whole multiple of the source lines that fits: even scanlines) or overscan (the next multiple up, a little cut off)\npicture_height=%s\n", vscale_names[vscale_mode]);
    fprintf(f, "; windows_pointer: auto (hidden only where the game draws a pointer), show or hide\nwindows_pointer=%s\n", ptr_names[ptr_mode]);
    fclose(f);
}

int64_t video_present_ns(void) { return 1000000000LL / present_hz; }
int video_vrr(void) { return vrr_on; }
int video_pointer_mode(void) { return ptr_mode; }

/* A scanline is drawn over `rows` window rows. Its brightest row is the middle one (the one above the middle when there is an even number),
 * and the gain keeps the average brightness. center is the brightest position within the source line (0..1). */
static void scan_rows(float sigma, int rows, float *center, float *gain)
{
    float sum = 0;
    int r;
    if (rows < 1) rows = 1;
    *center = ((rows - 1) / 2 + 0.5f) / rows;
    *gain = 1;
    if (sigma <= 0) return;
    for (r = 0; r < rows; r++) { float d = ((r + 0.5f) / rows - *center) / sigma; sum += expf(-d * d); }
    *gain = rows / sum;
}

/* the menu commands (host.h) and the keys 1-6 */
void video_command(int id)
{
    if (id == CMD_REFRESH_60) { present_hz = 60; vrr_on = 0; }
    else if (id == CMD_REFRESH_70) { present_hz = 70; vrr_on = 0; }
    else if (id == CMD_REFRESH_VRR) { vrr_on = 1; vsync_on = 0; }
    else if (id == CMD_VSYNC) vsync_on = !vsync_on;
    else if (id == CMD_STATS) osd_on = !osd_on;
    else if (id >= CMD_HIRES && id < CMD_HIRES + NHIRES) hires_mode = id - CMD_HIRES;
    else if (id >= CMD_LORES && id < CMD_LORES + NLORES) lores_mode = id - CMD_LORES;
    else if (id >= CMD_VSCALE && id < CMD_VSCALE + 3) vscale_mode = id - CMD_VSCALE;
    else if (id >= CMD_POINTER && id < CMD_POINTER + 3) ptr_mode = id - CMD_POINTER;
    else return;
    if (use_gl) vgl_set_vsync(vsync_on);
    settings_save();
    menu_sync();
    title_refresh();
}

int video_command_checked(int id)
{
    if (id == CMD_REFRESH_60) return !vrr_on && present_hz == 60;
    if (id == CMD_REFRESH_70) return !vrr_on && present_hz == 70;
    if (id == CMD_REFRESH_VRR) return vrr_on;
    if (id == CMD_VSYNC) return vsync_on;
    if (id == CMD_STATS) return osd_on;
    if (id >= CMD_HIRES && id < CMD_HIRES + NHIRES) return id - CMD_HIRES == hires_mode;
    if (id >= CMD_LORES && id < CMD_LORES + NLORES) return id - CMD_LORES == lores_mode;
    if (id >= CMD_VSCALE && id < CMD_VSCALE + 3) return id - CMD_VSCALE == vscale_mode;
    if (id >= CMD_POINTER && id < CMD_POINTER + 3) return id - CMD_POINTER == ptr_mode;
    return 0;
}

static char base_title[96] = "NHL Hockey 95";
static int shown, changed, cpu_pct = -1, gpu_pct = -1;
static int64_t title_at;

/* the window is drawn when the game's screen has changed, not on a timer (key 6): a variable refresh rate monitor then shows each new
 * image as it comes. Looks at every third pixel and at the palette, every 2 ms (after saving the VGA window, where a mode 13h picture is). */
static void window_save(void);

int video_changed(void)
{
    static uint32_t last;
    static int64_t at;
    uint32_t hash = 0;
    size_t i, n = (size_t)mode_w * mode_h;
    int64_t now = plat_now_ns();
    if (now - at < 2000000) return 0;           /* the game is writing this memory: look at it sparingly */
    at = now;
    SDL_LockMutex(lock);
    window_save();                              /* a mode 13h screen lives in the window until it is saved to vram */
    for (i = (size_t)disp_y * mode_w + disp_x; i < (size_t)disp_y * mode_w + disp_x + n; i += 3) hash = hash * 31 + vram[i];
    for (i = 0; i < 256 * 3; i += 7) hash = hash * 31 + dac[i / 3][i % 3];
    SDL_UnlockMutex(lock);
    if (hash == last) return 0;
    last = hash;
    return 1;
}

static void title_refresh(void)
{
    char t[256], hzbuf[24];
    if (vrr_on) snprintf(hzbuf, sizeof hzbuf, "on each new image"); else snprintf(hzbuf, sizeof hzbuf, "%d Hz", present_hz);
    snprintf(t, sizeof t, "%s | drawing %s, vsync %s | %d drawn/s, %d new images/s  [keys 1: 60 Hz + vsync, 2: 60 Hz, 3: 70 Hz, 4: vsync on/off, 5: on-screen display, 6: VRR]", base_title, hzbuf,
             vsync_on ? "on" : "off", shown, changed);
    if (getenv("NHL95_TITLELOG")) fprintf(stderr, "title: %s\n", t);
    if (win) SDL_SetWindowTitle(win, t);
    if (use_gl) {                               /* key 5: the same numbers on the picture */
        char l1[32], l2[32], l3[32];
        snprintf(l1, sizeof l1, "FPS %d  NEW %d", shown, changed);
        if (vrr_on) snprintf(l2, sizeof l2, "VRR VSYNC %s", vsync_on ? "ON" : "OFF");
        else snprintf(l2, sizeof l2, "%dHZ VSYNC %s", present_hz, vsync_on ? "ON" : "OFF");
        if (cpu_pct < 0) snprintf(l3, sizeof l3, "CPU --"); else snprintf(l3, sizeof l3, "CPU %d%%", cpu_pct);
        if (gpu_pct >= 0) snprintf(l3 + strlen(l3), sizeof l3 - strlen(l3), " GPU %d%%", gpu_pct); else snprintf(l3 + strlen(l3), sizeof l3 - strlen(l3), " GPU --");
        vgl_osd_set(osd_on ? l1 : NULL, l2, l3);
    }
}

void video_pacing_key(int n)
{
    static const int ids[7] = { 0, CMD_REFRESH_60, CMD_REFRESH_60, CMD_REFRESH_70, CMD_VSYNC, CMD_STATS, CMD_REFRESH_VRR };
    if (n == 1 && !vsync_on) video_command(CMD_VSYNC);
    if (n >= 1 && n <= 6) video_command(ids[n]);
}

static struct { int mode, w, h; } modes[] = {
    { 0x100, 640, 400 }, { 0x101, 640, 480 }, { 0x103, 800, 600 }, { 0x105, 1024, 768 }, { 0x107, 1280, 1024 }, { 0x13, 320, 200 }
};

static void window_save(void) { memcpy(vram + (size_t)cur_bank * BANK, WINDOW, BANK); }
static void window_load(void) { memcpy(WINDOW, vram + (size_t)cur_bank * BANK, BANK); }

static void set_bank(int bank)
{
    SDL_LockMutex(lock);
    window_save();
    cur_bank = bank & 0x7F;
    window_load();
    SDL_UnlockMutex(lock);
}

static void set_mode(int mode, int clear)
{
    size_t i;
    SDL_LockMutex(lock);
    for (i = 0; i < sizeof modes / sizeof *modes; i++)
        if (modes[i].mode == (mode & 0x1FF)) { mode_w = modes[i].w; mode_h = modes[i].h; mode_num = modes[i].mode; }
    if (clear) { memset(vram, 0, sizeof vram); memset(WINDOW, 0, BANK); }
    else window_save();
    cur_bank = 0;
    window_load();
    disp_x = disp_y = 0;
    resize_pending = 1;
    SDL_UnlockMutex(lock);
    TRACE("video mode %x: %dx%d\n", mode_num, mode_w, mode_h);
}

/* ---- ports ---- */
uint32_t video_port_in(unsigned port)
{
    switch (port) {
    case 0x3C7: return 3;
    case 0x3C9: {
        uint32_t v = dac[dac_rd & 255][dac_rcomp];
        if (++dac_rcomp == 3) { dac_rcomp = 0; dac_rd++; }
        return v;
    }
    case 0x3DA:                                 /* input status 1: vertical retrace for the first part of each 70 Hz frame */
        return ((plat_now_ns() % 14285714) < 1200000) ? 9 : 0;
    }
    return 0xFF;
}

int video_port_out(unsigned port, uint32_t val)
{
    switch (port) {
    case 0x3C7: dac_rd = val; dac_rcomp = 0; return 1;
    case 0x3C8: dac_wr = val; dac_comp = 0; return 1;
    case 0x3C9:
        dac[dac_wr & 255][dac_comp] = val & 63;
        if (++dac_comp == 3) { dac_comp = 0; dac_wr++; }
        return 1;
    }
    return 0;
}

/* ---- int 10h ---- */
int video_int10(ctx_t *c)
{
    unsigned ax = R(c, EAX) & 0xFFFF;
    if ((ax >> 8) == 0x4F) {
        R(c, EAX) = (R(c, EAX) & ~0xFFFFu) | 0x004F;
        switch (ax & 0xFF) {
        case 0x00: {                            /* controller information */
            uint8_t *b = (uint8_t *)R(c, EDI);
            memset(b, 0, 256);
            memcpy(b, "VESA", 4);
            *(uint16_t *)(b + 4) = 0x0102;
            *(uint16_t *)(b + 0x12) = 64;       /* 4 MB */
            return 1;
        }
        case 0x01: {                            /* mode information */
            uint8_t *b = (uint8_t *)R(c, EDI);
            unsigned m = R(c, ECX) & 0x1FF;
            size_t i;
            memset(b, 0, 256);
            for (i = 0; i < sizeof modes / sizeof *modes; i++) if (modes[i].mode == (int)m) break;
            if (i == sizeof modes / sizeof *modes) { R(c, EAX) = (R(c, EAX) & ~0xFFFFu) | 0x014F; return 1; }
            *(uint16_t *)b = 0x1B;              /* supported, colour, graphics, banked */
            b[2] = 7; b[3] = 0;
            *(uint16_t *)(b + 4) = 64; *(uint16_t *)(b + 6) = 64;
            *(uint16_t *)(b + 8) = 0xA000;
            *(uint16_t *)(b + 0x10) = modes[i].w;
            *(uint16_t *)(b + 0x12) = modes[i].w; *(uint16_t *)(b + 0x14) = modes[i].h;
            b[0x16] = 8; b[0x17] = 16; b[0x18] = 1; b[0x19] = 8; b[0x1A] = 1; b[0x1B] = 4;
            return 1;
        }
        case 0x02: set_mode(R(c, EBX), !(R(c, EBX) & 0x8000)); return 1;
        case 0x03: R(c, EBX) = (R(c, EBX) & ~0xFFFFu) | mode_num; return 1;
        case 0x05:
            if ((R(c, EBX) >> 8 & 0xFF) == 0) set_bank(R(c, EDX) & 0xFFFF);
            else R(c, EDX) = (R(c, EDX) & ~0xFFFFu) | cur_bank;
            return 1;
        case 0x06: R(c, ECX) = (R(c, ECX) & ~0xFFFFu) | mode_w; R(c, EBX) = (R(c, EBX) & ~0xFFFFu) | mode_w; R(c, EDX) = (R(c, EDX) & ~0xFFFFu) | mode_h; return 1;
        case 0x07:
            if ((R(c, EBX) & 0xFF) == 0) { disp_x = R(c, ECX) & 0xFFFF; disp_y = R(c, EDX) & 0xFFFF; }
            else { R(c, ECX) = (R(c, ECX) & ~0xFFFFu) | disp_x; R(c, EDX) = (R(c, EDX) & ~0xFFFFu) | disp_y; }
            return 1;
        }
        R(c, EAX) = (R(c, EAX) & ~0xFFFFu) | 0x014F;
        return 1;
    }
    switch (ax >> 8) {
    case 0x00: if ((ax & 0xFF) == 0x13) set_mode(0x13, 1); return 1;
    case 0x0B: return 1;
    case 0x0F: R(c, EAX) = (R(c, EAX) & ~0xFFFFu) | (mode_num == 0x13 ? 0x5013 : 0x5003); R(c, EBX) &= ~0xFF00u; return 1;
    case 0x11: case 0x12: return 1;
    }
    return 0;
}

/* ---- the game's VESA probe: what the external VESA detection program used to leave in a file ---- */
extern uint8_t unk_EDBB8[256], unk_EDAB8[256], byte_EDCC0[0x1B];
extern uint32_t dword_EDCB8;

void video_fill_vesa_tables(void)
{
    memset(unk_EDBB8, 0, 256);
    memcpy(unk_EDBB8, "VESA", 4);
    *(uint16_t *)(unk_EDBB8 + 4) = 0x0102;
    *(uint16_t *)(unk_EDBB8 + 0x12) = 64;
    memset(unk_EDAB8, 0, 256);
    *(uint16_t *)unk_EDAB8 = 0x1B;
    unk_EDAB8[2] = 7;                           /* window A: relocatable, readable, writable */
    *(uint16_t *)(unk_EDAB8 + 4) = 64;          /* granularity in KB */
    *(uint16_t *)(unk_EDAB8 + 6) = 64;
    *(uint16_t *)(unk_EDAB8 + 8) = 0xA000;
    memset(byte_EDCC0, 1, sizeof byte_EDCC0);   /* every mode 100h-107h is available */
    dword_EDCB8 = 1;
}

/* window position to game screen position (the window is scaled and letter-boxed) */
/* Where the picture sits in the window, in window coordinates: the largest 4:3 rectangle, centred (both the 640x480 screens and the
 * 320x200 ones, whose pixels were not square, fill a 4:3 screen). */
void video_view(int *vx, int *vy, int *vw, int *vh)
{
    int ww = 640, wh = 480, w, h;
    if (win) SDL_GetWindowSize(win, &ww, &wh);
    w = ww; h = ww * 3 / 4;
    if (h > wh) { h = wh; w = wh * 4 / 3; }
    if (vscale_mode) {                          /* a whole number of window rows for each source line (or scanline), so that the lines are even */
        int pre, period, unit, k;
        float scan;
        look(mode_w, &pre, &scan, &period);
        unit = mode_h * (period == 2 ? 2 : 1);
        k = vscale_mode == 2 ? (wh + unit - 1) / unit : wh / unit;
        if (vscale_mode == 1) while (k > 1 && k * unit * 4 / 3 > ww) k--;
        if (k < 1) k = 1;
        h = k * unit; w = h * 4 / 3;
    }
    *vw = w; *vh = h; *vx = (ww - w) / 2; *vy = (wh - h) / 2;
}

void video_window_to_game(int wx, int wy, int *gx, int *gy)
{
    int vx, vy, vw, vh;
    video_view(&vx, &vy, &vw, &vh);
    *gx = vw > 0 ? (wx - vx) * mode_w / vw : 0;
    *gy = vh > 0 ? (wy - vy) * mode_h / vh : 0;
    if (*gx < 0) *gx = 0;
    if (*gy < 0) *gy = 0;
    if (*gx >= mode_w) *gx = mode_w - 1;
    if (*gy >= mode_h) *gy = mode_h - 1;
}

void video_mode_size(int *w, int *h) { *w = mode_w; *h = mode_h; }

/* a game screen position in window coordinates (the inverse of video_window_to_game) */
void video_game_to_window(int gx, int gy, int *wx, int *wy)
{
    int vx, vy, vw, vh;
    video_view(&vx, &vy, &vw, &vh);
    *wx = vx + gx * vw / mode_w;
    *wy = vy + gy * vh / mode_h;
}

/* fullscreen: keep the host's pointer on the 4:3 picture (and let it go again in a window) */
void video_confine_mouse(int on)
{
    static int was, px, py, pw, ph;
    int vx, vy, vw, vh;
    if (!win) return;
    video_view(&vx, &vy, &vw, &vh);
    if (on == was && (!on || (vx == px && vy == py && vw == pw && vh == ph))) return;
    was = on; px = vx; py = vy; pw = vw; ph = vh;
    if (on) { SDL_Rect r = { vx, vy, vw, vh }; SDL_SetWindowMouseRect(win, &r); }
    else SDL_SetWindowMouseRect(win, NULL);
}

/* Alt+Enter: borderless fullscreen at the desktop's resolution and back */
static int fullscreen;
void video_toggle_fullscreen(void)
{
    if (!win) return;
    fullscreen = !fullscreen;
    SDL_SetWindowFullscreen(win, fullscreen ? SDL_WINDOW_FULLSCREEN_DESKTOP : 0);
    menu_show(!fullscreen);
}

int video_is_fullscreen(void) { return fullscreen; }

/* ---- the main thread: window and presentation ---- */
void video_init(void)
{
    lock = SDL_CreateMutex();
    settings_load();
    SDL_SetHint(SDL_HINT_RENDER_SCALE_QUALITY, "nearest");
    if (!getenv("NHL95_NOGL") && SDL_strcmp(SDL_GetCurrentVideoDriver(), "dummy")) {        /* the OpenGL path: shader scaling */
        win = SDL_CreateWindow("NHL Hockey 95", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, getenv("NHL95_WINDOW_W") ? atoi(getenv("NHL95_WINDOW_W")) : 960, getenv("NHL95_WINDOW_H") ? atoi(getenv("NHL95_WINDOW_H")) : 720, SDL_WINDOW_RESIZABLE | SDL_WINDOW_OPENGL);
        if (win && vgl_init(win)) { use_gl = 1; vgl_set_vsync(vsync_on); menu_init(win); title_refresh(); return; }
        fprintf(stderr, "OpenGL scaling is not available, using SDL's renderer\n");
        vgl_quit();
        if (win) SDL_DestroyWindow(win);
        win = 0;
    }
    win = SDL_CreateWindow("NHL Hockey 95", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 960, 720, SDL_WINDOW_RESIZABLE);
    if (!win) { fprintf(stderr, "SDL window: %s\n", SDL_GetError()); exit(1); }
    ren = SDL_CreateRenderer(win, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC);
    if (!ren) ren = SDL_CreateRenderer(win, -1, SDL_RENDERER_SOFTWARE);
    if (!ren) { fprintf(stderr, "SDL renderer: %s\n", SDL_GetError()); exit(1); }
}

/* NHL95_DUMP=dir writes a PPM of the screen about twice a second (for testing without a display) */
static void dump_frame(int w, int h)
{
    static int frame, written;
    static uint32_t last_hash;
    const char *dir = getenv("NHL95_DUMP");
    char name[512];
    FILE *f;
    uint32_t hash = 0;
    int i;
    if (!dir || ++frame % 30) return;
    for (i = 0; i < w * h; i += 7) hash = hash * 31 + argb[i];
    if (hash == last_hash) return;
    last_hash = hash;
    snprintf(name, sizeof name, "%s/frame_%05d_%07dms.ppm", dir, written++, (int)(SDL_GetTicks()));
    f = fopen(name, "wb");
    if (!f) return;
    fprintf(f, "P6\n%d %d\n255\n", w, h);
    for (i = 0; i < w * h; i++) { uint8_t px[3] = { argb[i] >> 16, argb[i] >> 8, argb[i] }; fwrite(px, 1, 3, f); }
    fclose(f);
}

void video_present(void)
{
    int64_t t0 = stats_on ? plat_now_ns() : 0;
    int w, h, x, y;
    uint32_t pal[256];
    if (!ren && !use_gl) return;
    SDL_LockMutex(lock);
    window_save();
    w = mode_w; h = mode_h;
    for (x = 0; x < 256; x++) {
        unsigned r = dac[x][0] << 2 | dac[x][0] >> 4, g = dac[x][1] << 2 | dac[x][1] >> 4, b = dac[x][2] << 2 | dac[x][2] >> 4;
        pal[x] = 0xFF000000u | r << 16 | g << 8 | b;
    }
    for (y = 0; y < h; y++) {
        const uint8_t *src = vram + (size_t)(y + disp_y) * w + disp_x;
        uint32_t *dst = argb + y * w;
        for (x = 0; x < w; x++) dst[x] = pal[src[x]];
    }
    resize_pending = resize_pending && (w != tex_w || h != tex_h);
    SDL_UnlockMutex(lock);
    if (!use_gl && (w != tex_w || h != tex_h)) {
        if (tex) SDL_DestroyTexture(tex);
        tex = SDL_CreateTexture(ren, SDL_PIXELFORMAT_ARGB8888, SDL_TEXTUREACCESS_STREAMING, w, h);
        tex_w = w; tex_h = h;
    }
    {                                           /* how many different images the game puts on the screen per second (NHL95_STATS and the title) */
        static uint32_t last_hash;
        static int n_shown, n_changed;
        uint32_t hash = 0;
        int i;
        int64_t now = plat_now_ns();
        for (i = 0; i < w * h; i += 5) hash = hash * 31 + argb[i];
        if (stats_on) stats_screen(hash != last_hash, w, h);
        n_shown++; if (hash != last_hash) n_changed++;
        last_hash = hash;
        if (now - title_at >= 1000000000LL) {
            shown = (int)(n_shown * 1000000000LL / (now - title_at)); changed = (int)(n_changed * 1000000000LL / (now - title_at));
            n_shown = n_changed = 0; title_at = now;
            cpu_pct = plat_cpu_percent(); gpu_pct = plat_gpu_percent();
            title_refresh();
        }
    }
    dump_frame(w, h);
    {
        int vx, vy, vw, vh;
        video_view(&vx, &vy, &vw, &vh);
        if (use_gl) {                           /* the view in drawable pixels, origin at the bottom left */
            int ww, wh, dw, dh;
            SDL_GetWindowSize(win, &ww, &wh);
            SDL_GL_GetDrawableSize(win, &dw, &dh);
            {
                int pre, period, unit = h * 1, rows;
                float scan, center, gain;
                look(w, &pre, &scan, &period);
                unit = h * (period == 2 ? 2 : 1);
                rows = (vh * dh / wh + unit / 2) / unit;
                scan_rows(scan, rows, &center, &gain);
                vgl_set_look(pre, scan, gain, center, period);
            }
            vgl_draw(win, argb, w, h, vx * dw / ww, (wh - vy - vh) * dh / wh, vw * dw / ww, vh * dh / wh);
        } else {
            SDL_Rect dst = { vx, vy, vw, vh };
            SDL_UpdateTexture(tex, 0, argb, w * 4);
            SDL_RenderClear(ren);
            SDL_RenderCopy(ren, tex, 0, &dst);
            SDL_RenderPresent(ren);
        }
    }
    if (stats_on) stats_present_ns(plat_now_ns() - t0);
}

void video_set_title(const char *title)
{
    snprintf(base_title, sizeof base_title, "%s", title);
    title_refresh();
}
