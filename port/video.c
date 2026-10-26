/* VGA / VESA emulation. The game draws into the 64 KB window at 0xA0000 and switches banks with int 10h function 4F05h,
 * like it did on a banked SVGA card. The host keeps the whole frame buffer in vram[], saves and loads the window when the bank
 * changes, and the main thread turns vram[] into an SDL texture a few dozen times a second. */
#include "host.h"
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
#else                                           /* the Linux build has no OpenGL path yet: SDL's renderer only */
static int vgl_init(SDL_Window *win) { (void)win; return 0; }
static void vgl_draw(SDL_Window *win, const uint32_t *argb, int w, int h, int vx, int vy, int vw, int vh)
{ (void)win; (void)argb; (void)w; (void)h; (void)vx; (void)vy; (void)vw; (void)vh; }
static void vgl_quit(void) {}
#endif
static uint32_t argb[1280 * 1024];

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

/* Alt+Enter: borderless fullscreen at the desktop's resolution and back */
static int fullscreen;
void video_toggle_fullscreen(void)
{
    if (!win) return;
    fullscreen = !fullscreen;
    SDL_SetWindowFullscreen(win, fullscreen ? SDL_WINDOW_FULLSCREEN_DESKTOP : 0);
}

int video_is_fullscreen(void) { return fullscreen; }

/* ---- the main thread: window and presentation ---- */
void video_init(void)
{
    lock = SDL_CreateMutex();
    SDL_SetHint(SDL_HINT_RENDER_SCALE_QUALITY, "nearest");
    if (!getenv("NHL95_NOGL") && SDL_strcmp(SDL_GetCurrentVideoDriver(), "dummy")) {        /* the OpenGL path: shader scaling */
        win = SDL_CreateWindow("NHL Hockey 95", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 960, 720, SDL_WINDOW_RESIZABLE | SDL_WINDOW_OPENGL);
        if (win && vgl_init(win)) { use_gl = 1; return; }
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
    if (stats_on) {                             /* NHL95_STATS: how many different images the game puts on the screen per second */
        static uint32_t last_hash;
        uint32_t hash = 0;
        int i;
        for (i = 0; i < w * h; i += 5) hash = hash * 31 + argb[i];
        stats_screen(hash != last_hash, w, h);
        last_hash = hash;
    }
    dump_frame(w, h);
    {
        int vx, vy, vw, vh;
        video_view(&vx, &vy, &vw, &vh);
        if (use_gl) {                           /* the view in drawable pixels, origin at the bottom left */
            int ww, wh, dw, dh;
            SDL_GetWindowSize(win, &ww, &wh);
            SDL_GL_GetDrawableSize(win, &dw, &dh);
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
    if (win) SDL_SetWindowTitle(win, title);
}
