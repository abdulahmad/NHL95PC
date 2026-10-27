/* VGA / VESA emulation. The game draws into the 64 KB window at 0xA0000 and switches banks with int 10h function 4F05h,
 * like it did on a banked SVGA card. The host keeps the whole frame buffer in vram[], saves and loads the window when the bank
 * changes, and the main thread turns vram[] into an SDL texture a few dozen times a second. */
#include "host.h"
#include <ctype.h>
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
void vgl_set_look(int pre, float sigma, float gain, float center, int period, int style);
void vgl_set_target(int w, int h);
void vgl_mister_tables(const float horiz[64][4], const float vert[2][256][4], const float gamma[256]);
void vgl_mister_mask(const float *rgb, int w, int h);
void vgl_set_custom(float dark, float gamma, float mask, float sharp);
void vgl_set_bright(float b, float maskscale);
void vgl_osd_set(const char *l1, const char *l2, const char *l3);
#else                                           /* the Linux build has no OpenGL path yet: SDL's renderer only */
static int vgl_init(SDL_Window *win) { (void)win; return 0; }
static void vgl_draw(SDL_Window *win, const uint32_t *argb, int w, int h, int vx, int vy, int vw, int vh)
{ (void)win; (void)argb; (void)w; (void)h; (void)vx; (void)vy; (void)vw; (void)vh; }
static void vgl_quit(void) {}
static void vgl_set_vsync(int on) { (void)on; }
static void vgl_set_look(int pre, float sigma, float gain, float center, int period, int style) { (void)pre; (void)sigma; (void)gain; (void)center; (void)period; (void)style; }
static void vgl_set_target(int w, int h) { (void)w; (void)h; }
static void vgl_mister_tables(const float horiz[64][4], const float vert[2][256][4], const float gamma[256]) { (void)horiz; (void)vert; (void)gamma; }
static void vgl_mister_mask(const float *rgb, int w, int h) { (void)rgb; (void)w; (void)h; }
static void vgl_set_custom(float dark, float gamma, float mask, float sharp) { (void)dark; (void)gamma; (void)mask; (void)sharp; }
static void vgl_set_bright(float b, float maskscale) { (void)b; (void)maskscale; }
static void vgl_osd_set(const char *l1, const char *l2, const char *l3) { (void)l1; (void)l2; (void)l3; }
#endif
static uint32_t argb[1280 * 1024];

/* ---- the settings: how often the window is drawn, vsync, the numbers on the picture, and how the picture is scaled ----
 * They are kept in hockey-win32.ini (hockey-linux.ini) next to the program and changed from the window's menu or the keys 1-6. */
static int present_hz = 60, vsync_on = 0, osd_on, vrr_on = 1;      /* by default: draw each new image, vsync off */
static void title_refresh(void);
static int hires_mode, lores_mode, vscale_hi, vscale_lo;              /* the scaling of the 640x480 screens and of the 320x200 screens: see the tables */
#define NHIRES NHIRES_ITEMS
#define NLORES NLORES_ITEMS
static const char *hires_names[NHIRES] = { "1x", "2x", "3x", "4x", "crt-light", "crt-medium", "crt-strong", "crt-soft", "crt-soft-grille", "mister", "custom" };
static const char *lores_names[NLORES] = { "3x", "5x", "7x", "11x", "crt-light", "crt-medium", "crt-strong", "crt-soft", "crt-soft-grille", "mister", "custom" };
static const float scan_strength[3] = { 0.80f, 0.60f, 0.45f };   /* the sigma of the scanline profile: the smaller, the darker the gaps */
static const char *ptr_names[3] = { "auto", "show", "hide" };
static int ptr_mode;
static const char *vscale_names[4] = { "fit", "integer", "overscan", "auto-crop" };

/* ---- the MiSTer look ----
 * It uses the scaler's own files, as on the MiSTer: a horizontal filter (64 phases of 4 taps), an adaptive vertical (scanline) filter (256 phases of
 * 4 taps, for dark and for bright pixels), a gamma curve (256 values) and a shadow mask (cells of 3 hex digits: colour, intensity on, intensity off,
 * with a pattern for each output resolution). The paths are in the ini, relative to the program's folder (the files come from the MiSTer's
 * filters, gamma and Shadow_Masks folders). A file that is missing is replaced by a plain stand-in. */
#define DEF_HORIZ "mister/Filters/Upscaling - Recommended/GS_Sharpness_060.txt"
#define DEF_VERT "mister/Filters/Scanlines - Adaptive/SLA_Dk_030_Br_070.txt"
#define DEF_GAMMA "mister/Gamma/Pure_Gamma/gamma_113.txt"
#define DEF_MASK "mister/Shadow_Masks/Simple (Monochrome)/JVC 001 (Generic).txt"
/* the MiSTer look has its own files for the menus (class 0, 640x480) and for the game (class 1, 320x200) */
static struct { char horiz[260], vert[260], gamma[260], mask[260]; int mask_scale; float bright; } mcfg[2];
static int lores_khz31;                          /* the game screens: 0 single scan (15 kHz, TV), 1 double scan (31 kHz, VGA) for every CRT look */
static float c_dark = 0.30f, c_gamma = 1.13f, c_mask = 0.12f, c_sharp = 0.60f;   /* the custom look: in the ini */
static float m_horiz[2][64][4], m_vert[2][2][256][4], m_gamma[2][256];
static struct { int res, w, h; float rgb[16 * 16 * 3]; } m_masks[2][8];
static int m_nmasks[2], m_dirty[2] = { 1, 1 }, m_mask_for = -1, m_class_up = -1;

static void mister_defaults(int c)
{
    snprintf(mcfg[c].horiz, sizeof mcfg[c].horiz, "%s", DEF_HORIZ); snprintf(mcfg[c].vert, sizeof mcfg[c].vert, "%s", DEF_VERT);
    snprintf(mcfg[c].gamma, sizeof mcfg[c].gamma, "%s", DEF_GAMMA); snprintf(mcfg[c].mask, sizeof mcfg[c].mask, "%s", DEF_MASK);
    mcfg[c].mask_scale = 1; mcfg[c].bright = 1.0f;
    m_dirty[c] = 1;
}

static FILE *open_rel(const char *path)
{
    char full[1100];
    FILE *f;
    char *base = SDL_GetBasePath();
    if (path[0] == '/' || (path[0] && path[1] == ':')) snprintf(full, sizeof full, "%s", path);
    else snprintf(full, sizeof full, "%s%s", base ? base : "", path);
    SDL_free(base);
    f = fopen(full, "r");
    if (!f) f = fopen(path, "r");
    return f;
}

/* the numbers of a coefficient file (lines starting with # are comments; the words 10bit and adaptive set flags) */
static int read_numbers(const char *path, float *vals, int max, int *adaptive, int *tenbit)
{
    char line[512];
    int n = 0;
    FILE *f = open_rel(path);
    if (!f) return 0;
    *adaptive = *tenbit = 0;
    while (fgets(line, sizeof line, f)) {
        char *q = line;
        while (*q == ' ' || *q == '\t') q++;
        if (*q == '#' || *q == '\n' || *q == '\r' || !*q) continue;
        if (!strncmp(q, "10bit", 5)) { *tenbit = 1; continue; }       /* (it starts with a digit: not a number) */
        if (isalpha((unsigned char)*q)) { if (!strncmp(q, "adaptive", 8)) *adaptive = 1; if (!strncmp(q, "10bit", 5)) *tenbit = 1; continue; }
        while (*q) {
            char *e;
            long v;
            while (*q && *q != '-' && !isdigit((unsigned char)*q)) q++;
            if (!*q) break;
            v = strtol(q, &e, 10);
            if (e == q) break;
            if (n < max) vals[n++] = (float)v;
            q = e;
        }
    }
    fclose(f);
    return n;
}

static void load_mask(const char *path, int cls)
{
    char line[512];
    int res = 0, w = 0, h = 0, y = 0, want = 0;
    FILE *f = open_rel(path);
    m_nmasks[cls] = 0;
    if (f) {
        while (fgets(line, sizeof line, f) && m_nmasks[cls] < 8) {
            char *q = line;
            while (*q == ' ' || *q == '\t') q++;
            if (*q == '#' || *q == '\n' || *q == '\r' || !*q) continue;
            if (!strncmp(q, "Resolution=", 11)) { res = atoi(q + 11); want = 0; continue; }
            if (!strncmp(q, "v2", 2)) { want = 1; continue; }
            if (want == 1) {                     /* the size of the pattern */
                if (sscanf(q, "%d,%d", &w, &h) != 2 || w < 1 || h < 1 || w > 16 || h > 16) { want = 0; continue; }
                m_masks[cls][m_nmasks[cls]].res = res; m_masks[cls][m_nmasks[cls]].w = w; m_masks[cls][m_nmasks[cls]].h = h;
                y = 0; want = 2;
                continue;
            }
            if (want == 2) {                     /* a row of cells: colour (0-7: bit 1 blue, 2 green, 4 red), intensity on, intensity off */
                int x;
                for (x = 0; x < w; x++) {
                    unsigned c = 0, on = 0, off = 0;
                    int ch;
                    if (sscanf(q, "%1x%1x%1x", &c, &on, &off) != 3) break;
                    for (ch = 0; ch < 3; ch++) {
                        int bit = ch == 0 ? 4 : ch == 1 ? 2 : 1;
                        m_masks[cls][m_nmasks[cls]].rgb[(y * w + x) * 3 + ch] = (c & bit) ? 1.0f + on / 16.0f : off / 16.0f;
                    }
                    q = strchr(q, ',');
                    if (!q) { x++; break; }
                    q++;
                }
                if (++y == h) { m_nmasks[cls]++; want = 0; }
            }
        }
        fclose(f);
    }
    if (!m_nmasks[cls]) {                             /* no mask file: none */
        m_masks[cls][0].res = 0; m_masks[cls][0].w = m_masks[cls][0].h = 1;
        m_masks[cls][0].rgb[0] = m_masks[cls][0].rgb[1] = m_masks[cls][0].rgb[2] = 1.0f;
        m_nmasks[cls] = 1;
    }
}

static void mister_load(int cls)
{
    float v[2 * 256 * 4 + 16];
    int n, ad, tb, i, p, k;
    m_dirty[cls] = 0; m_class_up = -1;
    n = read_numbers(mcfg[cls].horiz, v, 2 * 256 * 4, &ad, &tb);
    if (n == 64 * 4 || n == 256 * 4 || n == 2 * 256 * 4) {      /* 64 or 256 phases (the first set of an adaptive file) */
        int phases = n == 64 * 4 ? 64 : 256;
        for (p = 0; p < 64; p++) {
            const float *r = v + (size_t)(p * phases / 64) * 4;
            float sum = r[0] + r[1] + r[2] + r[3];
            for (k = 0; k < 4; k++) m_horiz[cls][p][k] = sum > 0 ? r[k] / sum : 0;
        }
    } else {                                     /* a Gaussian, sigma 0.42 pixels: what GS_Sharpness_060 is */
        for (p = 0; p < 64; p++) {
            float sum = 0;
            for (k = 0; k < 4; k++) { float d = (k - 1) - p / 64.0f; m_horiz[cls][p][k] = expf(-d * d / (2 * 0.42f * 0.42f)); sum += m_horiz[cls][p][k]; }
            for (k = 0; k < 4; k++) m_horiz[cls][p][k] /= sum;
        }
    }
    n = read_numbers(mcfg[cls].vert, v, 2 * 256 * 4, &ad, &tb);
    if (n == 2 * 256 * 4 || n == 256 * 4 || n == 64 * 4) {      /* adaptive (dark and bright sets), one set of 256 phases, or one of 64 */
        float div = tb ? 256.0f : 128.0f;
        int phases = n == 64 * 4 ? 64 : 256;
        for (i = 0; i < 2; i++)
            for (p = 0; p < 256; p++)
                for (k = 0; k < 4; k++) m_vert[cls][i][p][k] = v[(((n == 2 * 256 * 4 ? i : 0) * 256) + p * phases / 256) * 4 + k] / div;
    } else {                                     /* stand-ins: a beam over the two nearest lines, deeper gaps for dark pixels */
        for (i = 0; i < 2; i++)
            for (p = 0; p < 256; p++) {
                float f = p / 256.0f, s = i ? 0.457f : 0.337f, a = i ? 0.97f : 1.1f;
                m_vert[cls][i][p][0] = m_vert[cls][i][p][3] = 0;
                m_vert[cls][i][p][1] = a * expf(-powf(f / s, 1.5f));
                m_vert[cls][i][p][2] = a * expf(-powf((1 - f) / s, 1.5f));
            }
    }
    n = read_numbers(mcfg[cls].gamma, v, 256, &ad, &tb);
    if (n == 256) for (i = 0; i < 256; i++) m_gamma[cls][i] = v[i] / 255.0f;
    else for (i = 0; i < 256; i++) m_gamma[cls][i] = mcfg[cls].gamma[0] ? powf(i / 255.0f, 2.5f / 2.2f) : i / 255.0f;       /* no file: none (or the gamma of gamma_113 if the file is missing) */
    load_mask(mcfg[cls].mask, cls);
}

/* the mask pattern for this output height: the largest resolution that is not above it */
static void mister_mask_for(int height, int cls)
{
    int i, best = 0;
    if (height == m_mask_for && cls == m_class_up) return;
    m_mask_for = height;
    for (i = 0; i < m_nmasks[cls]; i++) if (m_masks[cls][i].res <= height && m_masks[cls][i].res >= m_masks[cls][best].res) best = i;
    vgl_mister_mask(m_masks[cls][best].rgb, m_masks[cls][best].w, m_masks[cls][best].h);
}

/* the tables of this class are on the GPU, and the mask pattern for this output height */
static void mister_upload(int cls, int height)
{
    if (m_class_up != cls) {
        vgl_mister_tables((const float (*)[4])m_horiz[cls], (const float (*)[256][4])m_vert[cls], m_gamma[cls]);
        m_class_up = cls;
        m_mask_for = -1;
    }
    mister_mask_for(height, cls);
}

/* a preset of the MiSTer scaler (an .ini: hfilter, vfilter, sfilter, gamma, mask, maskmode), paths relative to its Filters, Gamma and Shadow_Masks folders */
static void apply_preset(int cls, const char *rel)
{
    char line[512], hf[260] = "", vf[260] = "same", gm[260] = "off", mk[260] = "", mm[32] = "off";
    FILE *f = open_rel(rel);
    if (!f) return;
    while (fgets(line, sizeof line, f)) {
        char *k = line, *v = strchr(line, '='), *e;
        if (!v || line[0] == '#') continue;
        *v++ = 0;
        for (e = v + strlen(v); e > v && (e[-1] == '\n' || e[-1] == '\r' || e[-1] == ' '); ) *--e = 0;
        if (!strcmp(k, "hfilter")) snprintf(hf, sizeof hf, "%s", v);
        else if (!strcmp(k, "vfilter")) snprintf(vf, sizeof vf, "%s", v);
        else if (!strcmp(k, "gamma")) snprintf(gm, sizeof gm, "%s", v);
        else if (!strcmp(k, "mask")) snprintf(mk, sizeof mk, "%s", v);
        else if (!strcmp(k, "maskmode")) snprintf(mm, sizeof mm, "%s", v);
    }
    fclose(f);
    snprintf(mcfg[cls].horiz, sizeof mcfg[cls].horiz, "mister/Filters/%s", hf);
    if (!strcmp(vf, "same")) snprintf(mcfg[cls].vert, sizeof mcfg[cls].vert, "%s", mcfg[cls].horiz);
    else snprintf(mcfg[cls].vert, sizeof mcfg[cls].vert, "mister/Filters/%s", vf);
    if (!strcmp(gm, "off") || !gm[0]) mcfg[cls].gamma[0] = 0; else snprintf(mcfg[cls].gamma, sizeof mcfg[cls].gamma, "mister/Gamma/%s", gm);
    if (!strcmp(mm, "off") || !mk[0]) mcfg[cls].mask[0] = 0; else snprintf(mcfg[cls].mask, sizeof mcfg[cls].mask, "mister/Shadow_Masks/%s", mk);
    mcfg[cls].mask_scale = mm[0] >= '1' && mm[0] <= '4' ? mm[0] - '0' : 1;
}



/* The integer scale taken before the window's bicubic scaling, the width of the scanlines (0: none), how many scanlines there are per source line,
 * and the look: 0 the plain scaling or the scanline filter above, 1 a soft CRT (a Gaussian beam over the neighbouring lines and pixels, blended
 * in linear light, after Timothy Lottes' CRT shader), 2 the same with an aperture grille mask. */
static void look(int w, int *pre, float *scan, int *period, int *style)
{
    static const int lo_pre[4] = { 3, 5, 7, 11 };
    *scan = 0; *period = 1; *style = 0;
    if (w == 320) {
        int m = lores_mode;
        *pre = m < 4 ? lo_pre[m] : 3;
        if (m >= 4) *period = lores_khz31 ? 2 : 1;      /* the CRT looks (not the plain scales): 31 kHz is every line twice, a 320x400 picture */
        if (m >= 4 && m < 7) *scan = scan_strength[m - 4];
        if (m == 7 || m == 8) { *style = m - 6; *pre = 1; }
        if (m == 9) { *style = 3; *pre = 1; }
        if (m == 10) { *style = 4; *pre = 3; }
    } else {
        int m = hires_mode;
        *pre = m < 4 ? m + 1 : 1;
        if (m >= 4 && m < 7) *scan = scan_strength[m - 4];
        if (m >= 7 && m < 9) *style = 1 + (m - 7);
        if (m == 9) *style = 3;
        if (m == 10) *style = 4;
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
    mister_defaults(0); mister_defaults(1);
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
        else if (!strcmp(k, "lores_scaling")) {
            char nm[48];
            if (!strncmp(v, "tv-", 3)) snprintf(nm, sizeof nm, "crt-%s", v + 3);                                  /* the earlier names */
            else if (!strncmp(v, "monitor-", 8)) { snprintf(nm, sizeof nm, "crt-%s", v + 8); lores_khz31 = 1; }
            else snprintf(nm, sizeof nm, "%s", v);
            lores_mode = name_index(nm, lores_names, NLORES, 0);
        }
        else if (!strcmp(k, "lores_scan")) lores_khz31 = atoi(v) == 31;
        else if (!strncmp(k, "hires_mister_", 13) || !strncmp(k, "lores_mister_", 13)) {
            int c = k[0] == 'l';
            const char *key = k + 13;
            if (!strcmp(key, "horizontal_filter")) snprintf(mcfg[c].horiz, sizeof mcfg[c].horiz, "%s", v);
            else if (!strcmp(key, "vertical_filter")) snprintf(mcfg[c].vert, sizeof mcfg[c].vert, "%s", v);
            else if (!strcmp(key, "gamma")) snprintf(mcfg[c].gamma, sizeof mcfg[c].gamma, "%s", v);
            else if (!strcmp(key, "shadow_mask")) snprintf(mcfg[c].mask, sizeof mcfg[c].mask, "%s", v);
            else if (!strcmp(key, "scan")) lores_khz31 = atoi(v) == 31;       /* an earlier name */
            else if (!strcmp(key, "mask_scale")) mcfg[c].mask_scale = atoi(v) < 1 ? 1 : atoi(v) > 4 ? 4 : atoi(v);
            else if (!strcmp(key, "brightness")) mcfg[c].bright = (float)atof(v);
        }
        else if (!strcmp(k, "custom_scanline_darkness")) c_dark = (float)atof(v);
        else if (!strcmp(k, "custom_gamma")) c_gamma = (float)atof(v);
        else if (!strcmp(k, "custom_mask_strength")) c_mask = (float)atof(v);
        else if (!strcmp(k, "custom_sharpness")) c_sharp = (float)atof(v);
        else if (!strcmp(k, "windows_pointer")) ptr_mode = name_index(v, ptr_names, 3, 0);
        else if (!strcmp(k, "hires_picture_height")) vscale_hi = name_index(v, vscale_names, 4, 0);
        else if (!strcmp(k, "lores_picture_height")) vscale_lo = name_index(v, vscale_names, 4, 0);
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
    fprintf(f, "; hires_scaling (the 640x480 menus): 1x, 2x, 3x, 4x, crt-light, crt-medium, crt-strong, crt-soft, crt-soft-grille\nhires_scaling=%s\n", hires_names[hires_mode]);
    fprintf(f, "; lores_scaling (the 320x200 game): 3x, 5x, 7x, 11x, tv-light, tv-medium, tv-strong, monitor-light, monitor-medium, monitor-strong, tv-soft, tv-soft-grille, monitor-soft, monitor-soft-grille\nlores_scaling=%s\n", lores_names[lores_mode]);
    fprintf(f, "; hires_picture_height and lores_picture_height: fit (the window), integer (the biggest whole multiple of the source lines that fits: even scanlines),\n; overscan (the next multiple up, a little cut off) or auto-crop (the next multiple up when 10 (menus) or 6 (game) window rows or fewer are cut off, else integer)\nhires_picture_height=%s\nlores_picture_height=%s\n", vscale_names[vscale_hi], vscale_names[vscale_lo]);
    fprintf(f, "; the MiSTer look uses the MiSTer scaler's own files (from the filters, gamma and Shadow_Masks folders of its SD card), as paths relative to this folder.\n");
    fprintf(f, "; the MiSTer look has its own files for the menus (hires_) and the game (lores_): paths relative to this folder, starting with the folder of the MiSTer SD card they come from\n");
    fprintf(f, "; (Filters, Gamma, Shadow_Masks; empty gamma or shadow mask: none), the mask scale (1-4) and the brightness (1.0 is the files' own)\n");
    { int c; for (c = 0; c < 2; c++) {
        const char *pre = c ? "lores" : "hires";
        fprintf(f, "%s_mister_horizontal_filter=%s\n%s_mister_vertical_filter=%s\n%s_mister_gamma=%s\n%s_mister_shadow_mask=%s\n%s_mister_mask_scale=%d\n%s_mister_brightness=%.2f\n",
                pre, mcfg[c].horiz, pre, mcfg[c].vert, pre, mcfg[c].gamma, pre, mcfg[c].mask, pre, mcfg[c].mask_scale, pre, mcfg[c].bright);
    } }
    fprintf(f, "; lores_scan: 15 (single scan, the standard of a TV) or 31 (double scan, the standard of a VGA monitor: the 320x200 picture is doubled to 320x400) for the CRT looks of the game screens\nlores_scan=%d\n", lores_khz31 ? 31 : 15);
    fprintf(f, "; the custom look: scanline gap darkness (0-1), gamma, RGB mask strength (0-0.3), horizontal sharpness (0 bilinear, 1 bicubic)\n");
    fprintf(f, "custom_scanline_darkness=%.2f\ncustom_gamma=%.2f\ncustom_mask_strength=%.2f\ncustom_sharpness=%.2f\n", c_dark, c_gamma, c_mask, c_sharp);
    fprintf(f, "; windows_pointer: auto (hidden over the picture only where the game draws a pointer of its own), show or hide\nwindows_pointer=%s\n", ptr_names[ptr_mode]);
    fclose(f);
}

int64_t video_present_ns(void) { return 1000000000LL / present_hz; }
int video_vrr(void) { return vrr_on; }
int video_pointer_mode(void) { return ptr_mode; }

/* does the current setting of this kind of screen equal what the preset sets? (the menu marks the presets that do) */
int video_mister_preset_active(int cls, const char *rel)
{
    char save[sizeof mcfg[0]];
    int same;
    memcpy(save, &mcfg[cls], sizeof save);
    apply_preset(cls, rel);
    same = !strcmp(mcfg[cls].horiz, ((typeof(mcfg[0]) *)save)->horiz) && !strcmp(mcfg[cls].vert, ((typeof(mcfg[0]) *)save)->vert) &&
           !strcmp(mcfg[cls].gamma, ((typeof(mcfg[0]) *)save)->gamma) && !strcmp(mcfg[cls].mask, ((typeof(mcfg[0]) *)save)->mask) &&
           mcfg[cls].mask_scale == ((typeof(mcfg[0]) *)save)->mask_scale;
    memcpy(&mcfg[cls], save, sizeof save);
    return same;
}

/* any change to the MiSTer filters turns the MiSTer look on for that kind of screen (with auto crop, as for any look with scanlines) */
static void mister_on(int cls)
{
    if (cls == 0 && hires_mode != 9) { hires_mode = 9; vscale_hi = 3; }
    if (cls == 1 && lores_mode != 9) { lores_mode = 9; vscale_lo = 3; }
}

const char *video_mister_path(int cls, int kind) { return kind == 0 ? mcfg[cls].horiz : kind == 1 ? mcfg[cls].vert : kind == 2 ? mcfg[cls].gamma : mcfg[cls].mask; }

/* a file of the MiSTer look chosen from the menu; it is loaded when the picture is next drawn */
void video_mister_pick(int cls, int kind, const char *rel)
{
    if (kind == 4) apply_preset(cls, rel);
    else snprintf(kind == 0 ? mcfg[cls].horiz : kind == 1 ? mcfg[cls].vert : kind == 2 ? mcfg[cls].gamma : mcfg[cls].mask, 260, "%s", rel);
    m_dirty[cls] = 1;
    mister_on(cls);
    settings_save();
    menu_sync();
}

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
    else if (id >= CMD_HIRES && id < CMD_HIRES + NHIRES) { hires_mode = id - CMD_HIRES; vscale_hi = hires_mode >= 4 ? 3 : 0; }     /* a look with scanlines: auto crop; a plain scale (1X-11X): fit the window */
    else if (id >= CMD_LORES && id < CMD_LORES + NLORES) { lores_mode = id - CMD_LORES; vscale_lo = lores_mode >= 4 ? 3 : 0; }
    else if (id >= CMD_POINTER && id < CMD_POINTER + 3) ptr_mode = id - CMD_POINTER;
    else if (id >= CMD_MBRIGHT_HI && id < CMD_MBRIGHT_HI + 9) { mcfg[0].bright = 0.7f + 0.1f * (id - CMD_MBRIGHT_HI); mister_on(0); }
    else if (id >= CMD_MBRIGHT_LO && id < CMD_MBRIGHT_LO + 9) { mcfg[1].bright = 0.7f + 0.1f * (id - CMD_MBRIGHT_LO); mister_on(1); }
    else if (id >= CMD_MSCALE_HI && id < CMD_MSCALE_HI + 4) { mcfg[0].mask_scale = id - CMD_MSCALE_HI + 1; mister_on(0); }
    else if (id >= CMD_MSCALE_LO && id < CMD_MSCALE_LO + 4) { mcfg[1].mask_scale = id - CMD_MSCALE_LO + 1; mister_on(1); }
    else if (id == CMD_MKHZ || id == CMD_MKHZ + 1) lores_khz31 = id - CMD_MKHZ;
    else if (id == CMD_MRESET_HI) { mister_defaults(0); mister_on(0); }
    else if (id == CMD_MRESET_LO) { mister_defaults(1); mister_on(1); }
    else if (id >= CMD_VSCALE_HI && id < CMD_VSCALE_HI + 4) vscale_hi = id - CMD_VSCALE_HI;
    else if (id >= CMD_VSCALE_LO && id < CMD_VSCALE_LO + 4) vscale_lo = id - CMD_VSCALE_LO;
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
    if (id >= CMD_POINTER && id < CMD_POINTER + 3) return id - CMD_POINTER == ptr_mode;
    if (id == CMD_MKHZ || id == CMD_MKHZ + 1) return lores_khz31 == id - CMD_MKHZ;
    if (id >= CMD_MBRIGHT_HI && id < CMD_MBRIGHT_HI + 9) return fabsf(mcfg[0].bright - (0.7f + 0.1f * (id - CMD_MBRIGHT_HI))) < 0.01f;
    if (id >= CMD_MBRIGHT_LO && id < CMD_MBRIGHT_LO + 9) return fabsf(mcfg[1].bright - (0.7f + 0.1f * (id - CMD_MBRIGHT_LO))) < 0.01f;
    if (id >= CMD_MSCALE_HI && id < CMD_MSCALE_HI + 4) return id - CMD_MSCALE_HI + 1 == mcfg[0].mask_scale;
    if (id >= CMD_MSCALE_LO && id < CMD_MSCALE_LO + 4) return id - CMD_MSCALE_LO + 1 == mcfg[1].mask_scale;
    if (id >= CMD_VSCALE_HI && id < CMD_VSCALE_HI + 4) return id - CMD_VSCALE_HI == vscale_hi;
    if (id >= CMD_VSCALE_LO && id < CMD_VSCALE_LO + 4) return id - CMD_VSCALE_LO == vscale_lo;
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
    if (win) SDL_SetWindowTitle(win, base_title);
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
extern volatile int intro_skip;

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
        return (((intro_skip ? plat_now_ns() * 40 : plat_now_ns()) % 14285714) < 1200000) ? 9 : 0;        /* skipping the splash screens: the fades run fast too */
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
/* the window's client area: Windows' own figure when there is one (SDL's can be stale after the menu bar changes or the window is maximized) */
static void client_size(int *w, int *h)
{
    if (!menu_client_size(w, h) && win) SDL_GetWindowSize(win, w, h);
}

void video_view(int *vx, int *vy, int *vw, int *vh)
{
    int ww = 640, wh = 480, w, h, vs = mode_w == 320 ? vscale_lo : vscale_hi;
    if (win) client_size(&ww, &wh);
    w = ww; h = ww * 3 / 4;
    if (h > wh) { h = wh; w = wh * 4 / 3; }
    if (vs) {                                   /* a whole number of window rows for each source line (or scanline), so that the lines are even */
        int pre, period, style, unit, kf, kc, k;
        float scan;
        look(mode_w, &pre, &scan, &period, &style);
        unit = mode_h * (period == 2 ? 2 : 1);
        kf = wh / unit;
        if (kf < 1) kf = 1;
        while (kf > 1 && kf * unit * 4 / 3 > ww) kf--;
        kc = (wh + unit - 1) / unit;
        if (kc < kf) kc = kf;
        if (vs == 1) k = kf;
        else if (vs == 2) k = kc;
        else k = (kc * unit - wh <= (mode_w == 320 ? 6 : 10)) ? kc : kf;       /* auto crop */
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
    if (!fullscreen) menu_show(1);              /* the menu bar goes back before the window does, so that the window is sized with it */
    SDL_SetWindowFullscreen(win, fullscreen ? SDL_WINDOW_FULLSCREEN_DESKTOP : 0);
    if (fullscreen) menu_show(0);
}

int video_is_fullscreen(void) { return fullscreen; }

/* ---- the main thread: window and presentation ---- */
void video_init(void)
{
    lock = SDL_CreateMutex();
    settings_load();
    if (getenv("NHL95_PRESET")) { const char *t = getenv("NHL95_PRESET"); apply_preset(t[0] == 'l', t + 2); settings_save(); }      /* a test aid: h:path or l:path of a preset */
    SDL_SetHint(SDL_HINT_RENDER_SCALE_QUALITY, "nearest");
    if (!getenv("NHL95_NOGL") && SDL_strcmp(SDL_GetCurrentVideoDriver(), "dummy")) {        /* the OpenGL path: shader scaling */
        win = SDL_CreateWindow("NHL Hockey 95", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, getenv("NHL95_WINDOW_W") ? atoi(getenv("NHL95_WINDOW_W")) : 960, getenv("NHL95_WINDOW_H") ? atoi(getenv("NHL95_WINDOW_H")) : 720, SDL_WINDOW_RESIZABLE | SDL_WINDOW_OPENGL);
        if (win && vgl_init(win)) { use_gl = 1; vgl_set_vsync(vsync_on); menu_init(win); title_refresh(); if (getenv("NHL95_MAXIMIZE")) SDL_MaximizeWindow(win); return; }
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
            client_size(&ww, &wh);
            dw = ww; dh = wh;
            if (getenv("NHL95_SIZES")) { static int n; if (++n % 60 == 0) { int a, b, c, d; SDL_GetWindowSize(win, &a, &b); SDL_GL_GetDrawableSize(win, &c, &d); fprintf(stderr, "sizes: client %dx%d, SDL window %dx%d, GL drawable %dx%d\n", ww, wh, a, b, c, d); } }
            {
                int pre, period, style, unit, rows;
                float scan, center, gain;
                look(w, &pre, &scan, &period, &style);
                unit = h * (period == 2 ? 2 : 1);
                rows = (vh * dh / wh + unit / 2) / unit;
                scan_rows(scan, rows, &center, &gain);
                vgl_set_target(dw, dh);
                vgl_set_look(pre, scan, gain, center, period, style);
                if (style == 3) { int c = w == 320; if (m_dirty[c]) mister_load(c); mister_upload(c, wh); }
                vgl_set_custom(c_dark, c_gamma, c_mask, c_sharp);
                vgl_set_bright(mcfg[w == 320].bright, (float)mcfg[w == 320].mask_scale);
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
