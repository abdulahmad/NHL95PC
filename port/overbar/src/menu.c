/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * One menu model for overlay and file menus. Scale Mode is a single choice;
 * only that mode's sub-options are listed. There is no SNES Native 1:1 item.
 */
#include "overbar/overbar.h"

#ifdef OB_SDL_BASE
#include <SDL.h>
#endif
#include <ctype.h>
#include <dirent.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>

static const char *const refresh_choices[] = { "60 Hz", "70 Hz", "VRR" };
static const char *const off_on[] = { "Off", "On" };
static const char *const height_choices[] = {
    "Fit", "Integer", "Integer+Overscan", "Auto Crop"
};
/* RetroArch is not offered. The enum value stays so an old ini name still parses. */
static const char *const mode_choices[] = {
    "Sharp", "CRT Monitor", "MiSTer",
    "Scale2x", "Scale3x", "MMPX 2x", "MMPX 4x", "xBR 2x", "xBR 3x", "xBR 4x"
};
static const ob_scale_mode mode_values[] = {
    OB_MODE_SHARP, OB_MODE_CRT, OB_MODE_MISTER,
    OB_MODE_SCALE2X, OB_MODE_SCALE3X, OB_MODE_MMPX2X, OB_MODE_MMPX4X,
    OB_MODE_XBR2X, OB_MODE_XBR3X, OB_MODE_XBR4X
};
static const char *const sharp_steps[] = {
    "2x (480p)", "3x (720p)", "4x (1080p)", "5x (1200p)", "6x (1440p)", "9x (4k)"
};
static const char *const crt_choices[] = {
    "Light scanlines", "Medium scanlines", "Dark scanlines",
    "Soft (Lottes)", "Soft + aperture", "Custom"
};
static const char *const blend_choices[] = { "Off", "Dither", "Soft" };
static const char *const pointer_choices[] = { "automatic", "always show", "always hide" };
static const char *const fm_core_choices[] = { "Nuked-OPN2", "ymfm" };
static const char *const fm_chip_choices[] = { "YM2612", "YM3438" };
static const char *const khz_choices[] = { "15 kHz", "31 kHz" };
static const char *const mask_scale_choices[] = { "1x", "2x", "3x", "4x" };
static const char *const bright_choices[] = {
    "70%", "80%", "90%", "100%", "110%", "120%", "130%", "140%", "150%"
};
static const char *const replay_choices[] = { "Off", "10 s", "20 s", "30 s", "60 s" };
static const char *const gif_choices[] = { "1x", "2x", "3x" };

static ob_item *add(ob_item *out, int *n, int cap, int id, int kind, const char *label)
{
    ob_item *it;
    if (*n >= cap) return NULL;
    it = &out[(*n)++];
    memset(it, 0, sizeof *it);
    it->id = id;
    it->kind = kind;
    it->label = label;
    return it;
}

static void add_choice(ob_item *out, int *n, int cap, int id, const char *label,
                       const char *const *choices, int count, int value)
{
    ob_item *it = add(out, n, cap, id, MDRT_ITEM_CHOICE, label);
    if (!it) return;
    it->choices = choices;
    it->nchoices = count;
    it->value = value < 0 || value >= count ? 0 : value;
}

static ob_item *add_action(ob_item *out, int *n, int cap, int id, const char *label, const char *detail)
{
    ob_item *it = add(out, n, cap, id, MDRT_ITEM_ACTION, label);
    if (!it) return NULL;
    if (detail) snprintf(it->detail, sizeof it->detail, "%s", detail);
    return it;
}

/* A divider before a group that is not the first thing on the page. */
static void begin_group(ob_item *out, int *n, int cap)
{
    if (*n > 0) add(out, n, cap, 0, OB_ITEM_SEP, NULL);
}

static void add_text(ob_item *out, int *n, int cap, int id, const char *label, const char *detail)
{
    ob_item *it = add(out, n, cap, id, MDRT_ITEM_TEXT, label);
    if (!it) return;
    if (detail) snprintf(it->detail, sizeof it->detail, "%s", detail);
}

int ob_items_contain(const ob_item *items, int n, int id)
{
    int i;
    for (i = 0; i < n; i++) if (items[i].id == id) return 1;
    return 0;
}

int ob_items_contain_label(const ob_item *items, int n, const char *label)
{
    int i;
    for (i = 0; i < n; i++) if (items[i].label && !strcmp(items[i].label, label)) return 1;
    return 0;
}

static int ends_ci(const char *s, const char *suf)
{
    size_t n = strlen(s), m = strlen(suf), i;
    if (n < m) return 0;
    for (i = 0; i < m; i++) {
        char a = s[n - m + i], b = suf[i];
        if (a >= 'A' && a <= 'Z') a = (char)(a + 32);
        if (b >= 'A' && b <= 'Z') b = (char)(b + 32);
        if (a != b) return 0;
    }
    return 1;
}

/* mister/ sits next to the exe, the same place the 95PC bar reads.
 * OB_SDL_BASE is the client build (this port). The Overbar library test
 * looks beside the working directory only. */
static void mister_root(char *out, size_t n)
{
    DIR *d;
#ifdef OB_SDL_BASE
    char *base = SDL_GetBasePath();
    if (base) {
        snprintf(out, n, "%smister", base);
        SDL_free(base);
        d = opendir(out);
        if (d) { closedir(d); return; }
    }
#endif
    d = opendir("mister");
    if (d) { closedir(d); snprintf(out, n, "mister"); return; }
    d = opendir("../mister");
    if (d) { closedir(d); snprintf(out, n, "../mister"); return; }
    out[0] = 0;
}

/* One level of the MiSTer tree, the same shape as the 95 PC bar: folders first,
 * then files. gamma and mask offer None at the top of their own folder. */
static void own_label(ob_item *it, const char *name, int mark)
{
    if (!it) return;
    snprintf(it->text, sizeof it->text, "%s%s", name ? name : "", mark ? " *" : "");
    it->label = it->text;
}

int ob_mister_entries(const char *dir_rel, int kind, int at_root, const char *selected,
                      ob_item *out, int cap)
{
    char root[1024], path[1200];
    DIR *d;
    struct dirent *e;
    struct { char name[96]; char rel[192]; int dir; } ents[OB_ITEMS_MAX];
    int nent = 0, i, n = 0, pass;
    const char *suf = kind == 4 ? ".ini" : ".txt";
    mister_root(root, sizeof root);
    if (!dir_rel) dir_rel = "";
    if (root[0]) {
        if (dir_rel[0]) snprintf(path, sizeof path, "%s/%s", root, dir_rel);
        else snprintf(path, sizeof path, "%s", root);
    } else
        path[0] = 0;
    if (at_root && (kind == 2 || kind == 3)) {
        ob_item *none = add_action(out, &n, cap, OB_ID_MISTER_FILE, "None", NULL);
        if (none) {
            none->value = kind;
            own_label(none, "None", !selected || !selected[0]);
        }
    }
    if (path[0] && (d = opendir(path)) != NULL) {
        while ((e = readdir(d)) != NULL && nent < OB_ITEMS_MAX) {
            char full[1600], rel[192];
            struct stat st;
            int nw, isdir, dlen;
            if (e->d_name[0] == '.') continue;
            dlen = (int)strlen(e->d_name);
            if (dlen <= 0 || dlen >= (int)sizeof ents[nent].name) continue;
            if (dlen >= (int)sizeof full - (int)strlen(path) - 2) continue;
            nw = dir_rel[0] ? snprintf(rel, sizeof rel, "%s/%s", dir_rel, e->d_name)
                            : snprintf(rel, sizeof rel, "%s", e->d_name);
            if (nw < 0 || nw >= (int)sizeof rel) continue;
            snprintf(full, sizeof full, "%s/%s", path, e->d_name);
            if (stat(full, &st) != 0) continue;
            isdir = S_ISDIR(st.st_mode);
            if (!isdir && !ends_ci(e->d_name, suf)) continue;
            memcpy(ents[nent].name, e->d_name, (size_t)dlen + 1);
            if (!isdir) {
                size_t ln = strlen(ents[nent].name);
                size_t sl = strlen(suf);
                if (ln > sl) ents[nent].name[ln - sl] = 0;
            }
            snprintf(ents[nent].rel, sizeof ents[nent].rel, "%s", rel);
            ents[nent].dir = isdir;
            nent++;
        }
        closedir(d);
    }
    for (pass = 1; pass >= 0; pass--) {
        for (i = 0; i < nent; i++) {
            ob_item *it;
            if (ents[i].dir != pass) continue;
            if (ents[i].dir)
                it = add_action(out, &n, cap, OB_ID_MISTER_DIR, ents[i].name, ents[i].rel);
            else
                it = add_action(out, &n, cap, OB_ID_MISTER_FILE, ents[i].name, ents[i].rel);
            if (it) {
                int mark = 0;
                if (selected && selected[0]) {
                    if (ents[i].dir) {
                        size_t ln = strlen(ents[i].rel);
                        mark = !strncmp(selected, ents[i].rel, ln)
                            && (selected[ln] == '/' || selected[ln] == 0);
                    } else
                        mark = !strcmp(selected, ents[i].rel);
                }
                it->value = kind;
                own_label(it, ents[i].name, mark);
            }
        }
    }
    if (n == 0) add_text(out, &n, cap, OB_ID_PRESENT_NOTE, "MiSTer", "no files here");
    return n;
}

int ob_main_items(const ob_host *h, ob_item *out, int cap)
{
    int n = 0, i;
    add_action(out, &n, cap, OB_ID_RESUME, "Resume", NULL);
    add_action(out, &n, cap, OB_ID_VIDEO, "Video", NULL);
    if (h->has_sound) add_action(out, &n, cap, OB_ID_SOUND, "Sound", NULL);
    add_action(out, &n, cap, OB_ID_INPUT, "Input", NULL);
    add_action(out, &n, cap, OB_ID_CAPTURE, "Capture", NULL);
    add_action(out, &n, cap, OB_ID_ONLINE, "Online Play",
               h->online_ready ? NULL : "not in this build");
    for (i = 0; i < h->naddons; i++)
        add_action(out, &n, cap, h->addons[i].id, h->addons[i].label, NULL);
    add_action(out, &n, cap, OB_ID_QUIT, "Quit", NULL);
    return n;
}

int ob_video_items(const ob_host *h, ob_class cls, ob_item *out, int cap)
{
    int n = 0;
    (void)cls;
    add_choice(out, &n, cap, OB_ID_REFRESH, "Refresh", refresh_choices, 3, h->refresh);
    begin_group(out, &n, cap);
    add_choice(out, &n, cap, OB_ID_VSYNC, "Vsync", off_on, 2, h->vsync);
    begin_group(out, &n, cap);
    add_choice(out, &n, cap, OB_ID_STATS, "Stats", off_on, 2, h->stats);
    begin_group(out, &n, cap);
    add_choice(out, &n, cap, OB_ID_BLEND, "Blend", blend_choices, 3, h->blend % 3);
    begin_group(out, &n, cap);
    /* Same three as the 95 PC Display menu. Auto is each game's own rule for when its pointer is drawn. */
    add_choice(out, &n, cap, OB_ID_POINTER, "Windows pointer", pointer_choices, 3, h->pointer % 3);
    begin_group(out, &n, cap);
    if (h->has_hires) add_action(out, &n, cap, OB_ID_SCALE_HI, "Scaling (Hi-Res)", NULL);
    add_action(out, &n, cap, OB_ID_SCALE_LO, h->has_hires ? "Scaling (Lo-Res)" : "Scaling", NULL);
    add_action(out, &n, cap, OB_ID_BACK, "Back", NULL);
    return n;
}

/* Scaling page: Scale Mode and that mode's knobs each open a submenu.
 * Picture height and Monitor sit here, one group each. */
static int ob_scale_items(const ob_host *h, ob_class cls, ob_item *out, int cap)
{
    const ob_look *look = (cls == OB_CLASS_HIRES) ? &h->hires : &h->lores;
    int n = 0;
    int mode_id = cls == OB_CLASS_HIRES ? OB_ID_MODE_MENU_HI : OB_ID_MODE_MENU_LO;
    int opts_id = cls == OB_CLASS_HIRES ? OB_ID_OPTS_MENU_HI : OB_ID_OPTS_MENU_LO;
    add_action(out, &n, cap, mode_id, "Scale Mode", ob_mode_label(look->mode));
    begin_group(out, &n, cap);
    add_action(out, &n, cap, opts_id, "Scale Mode options", NULL);
    begin_group(out, &n, cap);
    add_choice(out, &n, cap, OB_ID_PICTURE_HEIGHT, "Picture height", height_choices, 4, look->height);
    if (cls == OB_CLASS_LORES) {
        begin_group(out, &n, cap);
        add_choice(out, &n, cap, OB_ID_MONITOR_KHZ, "Monitor", khz_choices, 2, look->khz31);
    }
    add_action(out, &n, cap, OB_ID_BACK, "Back", NULL);
    return n;
}

static int ob_mode_items(const ob_host *h, ob_class cls, ob_item *out, int cap)
{
    const ob_look *look = (cls == OB_CLASS_HIRES) ? &h->hires : &h->lores;
    int n = 0, i;
    int count = (int)(sizeof mode_values / sizeof mode_values[0]);
    for (i = 0; i < count; i++) {
        ob_item *it = add_action(out, &n, cap, OB_ID_SCALE_MODE, mode_choices[i],
                                 mode_values[i] == look->mode ? "in use" : NULL);
        if (it) it->value = mode_values[i];
    }
    add_action(out, &n, cap, OB_ID_BACK, "Back", NULL);
    (void)h;
    return n;
}

/* Knobs that belong to the selected scale mode. Picture height and Monitor
 * stay on the Scaling page. */
static int ob_opts_items(const ob_host *h, ob_class cls, ob_item *out, int cap)
{
    const ob_look *look = (cls == OB_CLASS_HIRES) ? &h->hires : &h->lores;
    ob_scale_mode m = look->mode;
    int n = 0;
    if (m == OB_MODE_RETROARCH) m = OB_MODE_SHARP;
    if (m == OB_MODE_MISTER) {
        const char *note = h->fallback_note ? h->fallback_note : ob_look_fallback_note(m, h->present);
        if (note) add_text(out, &n, cap, OB_ID_PRESENT_NOTE, "This look", note);
    }
    if (m == OB_MODE_SHARP)
        add_choice(out, &n, cap, OB_ID_SHARP_AMOUNT, "Sharp", sharp_steps, OB_SHARP_COUNT,
                   look->sharp >= 0 && look->sharp < OB_SHARP_COUNT ? look->sharp : OB_SHARP_3X);
    else if (m == OB_MODE_CRT)
        add_choice(out, &n, cap, OB_ID_CRT_LOOK, "CRT Monitor", crt_choices, OB_CRT_COUNT, look->crt);
    else if (m == OB_MODE_MISTER) {
        /* Same depth as the 95 PC bar: each list is a folder tree, not one flat choice. */
        if (n > 0) begin_group(out, &n, cap);
        add_action(out, &n, cap, OB_ID_MISTER_PRESET, "Presets", NULL);
        begin_group(out, &n, cap);
        add_action(out, &n, cap, OB_ID_MISTER_H, "Horizontal filter", NULL);
        begin_group(out, &n, cap);
        add_action(out, &n, cap, OB_ID_MISTER_V, "Vertical filter (scanlines)", NULL);
        begin_group(out, &n, cap);
        add_action(out, &n, cap, OB_ID_MISTER_GAMMA, "Gamma", NULL);
        begin_group(out, &n, cap);
        add_action(out, &n, cap, OB_ID_MISTER_MASK, "Shadow mask", NULL);
        begin_group(out, &n, cap);
        add_choice(out, &n, cap, OB_ID_MISTER_MASK_SCALE, "Shadow mask scale", mask_scale_choices, 4,
                   look->mask_scale < 1 ? 0 : look->mask_scale - 1);
        begin_group(out, &n, cap);
        add_choice(out, &n, cap, OB_ID_MISTER_BRIGHT, "Brightness", bright_choices, 9,
                   (look->bright - 70) / 10);
        begin_group(out, &n, cap);
        add_action(out, &n, cap, OB_ID_MISTER_RESET, "Reset the MiSTer filters", NULL);
    } else if (n == 0)
        add_text(out, &n, cap, OB_ID_PRESENT_NOTE, "Scale Mode options", "none for this mode");
    add_action(out, &n, cap, OB_ID_BACK, "Back", NULL);
    return n;
}

int ob_page_items(const ob_host *h, int page, ob_item *out, int cap)
{
    int n = 0;
    switch (page) {
    case OB_PAGE_MAIN: return ob_main_items(h, out, cap);
    case OB_PAGE_VIDEO: return ob_video_items(h, h->video_class, out, cap);
    case OB_PAGE_SCALE_HI: return ob_scale_items(h, OB_CLASS_HIRES, out, cap);
    case OB_PAGE_SCALE_LO: return ob_scale_items(h, OB_CLASS_LORES, out, cap);
    case OB_PAGE_MODE_HI: return ob_mode_items(h, OB_CLASS_HIRES, out, cap);
    case OB_PAGE_MODE_LO: return ob_mode_items(h, OB_CLASS_LORES, out, cap);
    case OB_PAGE_OPTS_HI: return ob_opts_items(h, OB_CLASS_HIRES, out, cap);
    case OB_PAGE_OPTS_LO: return ob_opts_items(h, OB_CLASS_LORES, out, cap);
    case OB_PAGE_MISTER: {
        const char *sel = ob_mister_selected(h, h->video_class, h->mister_kind);
        int at = !(h->mister_dir[0] && strchr(h->mister_dir, '/'));
        n = ob_mister_entries(h->mister_dir, h->mister_kind, at, sel, out, cap);
        add_action(out, &n, cap, OB_ID_BACK, "Back", NULL);
        return n;
    }
    case OB_PAGE_SOUND:
        add_choice(out, &n, cap, OB_ID_FM_CORE, "FM core", fm_core_choices, 2, h->fm_core % 2);
        begin_group(out, &n, cap);
        add_choice(out, &n, cap, OB_ID_FM_CHIP, "FM chip", fm_chip_choices, 2, h->fm_chip % 2);
        add_action(out, &n, cap, OB_ID_BACK, "Back", NULL);
        return n;
    case OB_PAGE_INPUT:
        add_action(out, &n, cap, OB_ID_CONTROLLERS, "Controllers", NULL);
        add_action(out, &n, cap, OB_ID_BACK, "Back", NULL);
        return n;
    case OB_PAGE_CAPTURE:
        add_action(out, &n, cap, OB_ID_CAP_REPLAY, "Save replay", NULL);
        begin_group(out, &n, cap);
        add_action(out, &n, cap, OB_ID_CAP_RECORD, h->recording ? "Stop recording" : "Start recording", NULL);
        begin_group(out, &n, cap);
        add_choice(out, &n, cap, OB_ID_CAP_SECONDS, "Replay length", replay_choices, 5, h->replay_secs_index);
        begin_group(out, &n, cap);
        add_choice(out, &n, cap, OB_ID_CAP_GIFSCALE, "GIF size", gif_choices, 3, h->gif_scale);
        add_action(out, &n, cap, OB_ID_BACK, "Back", NULL);
        return n;
    case OB_PAGE_ONLINE:
        if (h->online_ready) add_text(out, &n, cap, OB_ID_ONLINE_NOTE, "PulseMan netplay", "host / join");
        else add_text(out, &n, cap, OB_ID_ONLINE_NOTE, "Online Play", "not in this build");
        add_action(out, &n, cap, OB_ID_BACK, "Back", NULL);
        return n;
    case OB_PAGE_KEYS:
        add_text(out, &n, cap, OB_ID_KEYS, "Overlay", "` and F11");
        add_text(out, &n, cap, OB_ID_STATS, "Stats", "F12");
        add_text(out, &n, cap, OB_ID_QUIT, "Esc", "game (not overlay)");
        add_action(out, &n, cap, OB_ID_BACK, "Back", NULL);
        return n;
    default:
        return 0;
    }
}

const char *const *ob_mode_choice_list(int *n)
{
    if (n) *n = (int)(sizeof mode_choices / sizeof mode_choices[0]);
    return mode_choices;
}

int ob_mode_choice_value(int index)
{
    int n = (int)(sizeof mode_values / sizeof mode_values[0]);
    if (index < 0 || index >= n) return OB_MODE_SHARP;
    return mode_values[index];
}

int ob_mode_choice_index(ob_scale_mode m)
{
    int i, n = (int)(sizeof mode_values / sizeof mode_values[0]);
    for (i = 0; i < n; i++) if (mode_values[i] == m) return i;
    return 0;
}

/* MiSTer coefficient files, applied as a 3x prescale. The window then scales
 * that image into the aspect rect (224 lines keep the 240-line 4:3 pixel shape). */
static float m_htap[64][4];
static float m_vtap[2][256][4];
static float m_gamma[256];
static char m_sig[8][192];
static int m_ready;
static uint32_t m_out[320 * 3 * 240 * 3];

static float m_exp_neg(float x)
{
    float t = 1.f, s = 1.f;
    int i;
    if (x < 0) x = -x;
    for (i = 1; i < 12; i++) { t *= x / (float)i; s += t; }
    return 1.f / s;
}

static int m_read_numbers(const char *path, float *vals, int max, int *adaptive, int *tenbit)
{
    char line[512];
    FILE *f;
    int n = 0;
    *adaptive = *tenbit = 0;
    f = fopen(path, "r");
    if (!f) return 0;
    while (fgets(line, sizeof line, f)) {
        char *q = line;
        while (*q == ' ' || *q == '\t') q++;
        if (*q == '#' || *q == '\n' || *q == '\r' || !*q) continue;
        if (!strncmp(q, "10bit", 5)) { *tenbit = 1; continue; }
        if (isalpha((unsigned char)*q)) {
            if (!strncmp(q, "adaptive", 8)) *adaptive = 1;
            continue;
        }
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

static void m_join(char *out, int n, const char *root, const char *rel)
{
    if (!rel || !rel[0]) { out[0] = 0; return; }
    if (rel[0] == '/' || (rel[0] && rel[1] == ':')) snprintf(out, n, "%s", rel);
    else if (root && root[0]) snprintf(out, n, "%s/%s", root, rel);
    else snprintf(out, n, "%s", rel);
}

static void m_fallback(void)
{
    int p, k, i;
    for (p = 0; p < 64; p++) {
        float sum = 0;
        for (k = 0; k < 4; k++) {
            float d = (k - 1) - p / 64.f;
            m_htap[p][k] = m_exp_neg(d * d / (2.f * 0.42f * 0.42f));
            sum += m_htap[p][k];
        }
        for (k = 0; k < 4; k++) m_htap[p][k] /= sum;
    }
    for (i = 0; i < 2; i++)
        for (p = 0; p < 256; p++) {
            float f = p / 256.f, s = i ? 0.457f : 0.337f, a = i ? 0.97f : 1.1f;
            m_vtap[i][p][0] = m_vtap[i][p][3] = 0;
            m_vtap[i][p][1] = a * m_exp_neg(f / s);
            m_vtap[i][p][2] = a * m_exp_neg((1.f - f) / s);
        }
    for (i = 0; i < 256; i++) m_gamma[i] = i / 255.f;
}

static void m_load(const ob_look *look)
{
    static const char *def[4] = {
        "Filters/Upscaling - Recommended/GS_Sharpness_060.txt",
        "Filters/Scanlines - Adaptive/SLA_Dk_030_Br_070.txt",
        "Gamma/Pure_Gamma/gamma_113.txt",
        ""
    };
    char root[1024], path[1200], sig[4][192];
    float v[2 * 256 * 4];
    int k, n, ad, tb, p, i;
    mister_root(root, sizeof root);
    for (k = 0; k < 4; k++) {
        const char *rel = look->mister_path[k][0] ? look->mister_path[k] : def[k];
        m_join(path, sizeof path, root, rel);
        {
            size_t ln = strlen(path);
            if (ln >= sizeof sig[k]) ln = sizeof sig[k] - 1;
            memcpy(sig[k], path, ln);
            sig[k][ln] = 0;
        }
    }
    if (m_ready && !strcmp(sig[0], m_sig[0]) && !strcmp(sig[1], m_sig[1])
        && !strcmp(sig[2], m_sig[2]) && !strcmp(sig[3], m_sig[3]))
        return;
    m_fallback();
    n = m_read_numbers(sig[0], v, 2 * 256 * 4, &ad, &tb);
    if (n == 64 * 4 || n == 256 * 4 || n == 2 * 256 * 4) {
        int phases = n == 64 * 4 ? 64 : 256;
        for (p = 0; p < 64; p++) {
            const float *r = v + (size_t)(p * phases / 64) * 4;
            float sum = r[0] + r[1] + r[2] + r[3];
            for (k = 0; k < 4; k++) m_htap[p][k] = sum > 0 ? r[k] / sum : 0;
        }
    }
    n = m_read_numbers(sig[1], v, 2 * 256 * 4, &ad, &tb);
    if (n == 2 * 256 * 4 || n == 256 * 4 || n == 64 * 4) {
        float div = tb ? 256.f : 128.f;
        int phases = n == 64 * 4 ? 64 : 256;
        for (i = 0; i < 2; i++)
            for (p = 0; p < 256; p++)
                for (k = 0; k < 4; k++)
                    m_vtap[i][p][k] = v[(((n == 2 * 256 * 4 ? i : 0) * 256) + p * phases / 256) * 4 + k] / div;
    }
    n = m_read_numbers(sig[2], v, 256, &ad, &tb);
    if (n == 256) for (i = 0; i < 256; i++) m_gamma[i] = v[i] / 255.f;
    for (k = 0; k < 4; k++) {
        size_t ln = strlen(sig[k]);
        if (ln >= sizeof m_sig[k]) ln = sizeof m_sig[k] - 1;
        memcpy(m_sig[k], sig[k], ln);
        m_sig[k][ln] = 0;
    }
    m_ready = 1;
}

static void m_sample(const uint32_t *src, int sw, int sh, int sp, int x, int y, float c[3])
{
    uint32_t p;
    if (x < 0) x = 0;
    if (y < 0) y = 0;
    if (x >= sw) x = sw - 1;
    if (y >= sh) y = sh - 1;
    p = src[y * sp + x];
    c[0] = ((p >> 16) & 255) * (1.f / 255.f);
    c[1] = ((p >> 8) & 255) * (1.f / 255.f);
    c[2] = (p & 255) * (1.f / 255.f);
}

static void m_hrow(const uint32_t *src, int sw, int sh, int sp, int ix, int ph, int y, float c[3])
{
    int k, t;
    const float *w = m_htap[ph & 63];
    c[0] = c[1] = c[2] = 0;
    for (k = 0; k < 4; k++) {
        float s[3];
        m_sample(src, sw, sh, sp, ix - 1 + k, y, s);
        for (t = 0; t < 3; t++) c[t] += s[t] * w[k];
    }
}

int ob_mister_prescale(const ob_look *look, const uint32_t *src, int sw, int sh, int spitch,
                       uint32_t **dst, int *dw, int *dh)
{
    const int f = 3;
    int period, ox, oy, ow, oh;
    float bright;
    if (!look || look->mode != OB_MODE_MISTER || !src || sw < 1 || sh < 1 || sw > 320 || sh > 240)
        return 0;
    if (spitch < sw) spitch = sw;
    m_load(look);
    period = look->khz31 ? 2 : 1;
    bright = look->bright > 0 ? look->bright / 100.f : 1.f;
    ow = sw * f;
    oh = sh * f;
    for (oy = 0; oy < oh; oy++) {
        float py = (oy + 0.5f) / (float)f * (float)period - 0.5f;
        int iy = (int)py;
        float fy = py - (float)iy;
        int phv, row;
        float wd[4], wb[4], w[4];
        if (py < 0 && fy != 0) { iy -= 1; fy += 1.f; }
        phv = (int)(fy * 256.f);
        if (phv < 0) phv = 0;
        if (phv > 255) phv = 255;
        for (row = 0; row < 4; row++) {
            wd[row] = m_vtap[0][phv][row];
            wb[row] = m_vtap[1][phv][row];
        }
        for (ox = 0; ox < ow; ox++) {
            float fx = (ox + 0.5f) / (float)f - 0.5f;
            int ix = (int)fx;
            float fxf = fx - (float)ix;
            int ph, k, t;
            float rows[4][3], lum, mixv;
            uint32_t outp;
            int ch[3];
            if (fx < 0 && fxf != 0) { ix -= 1; fxf += 1.f; }
            ph = (int)(fxf * 64.f);
            if (ph < 0) ph = 0;
            if (ph > 63) ph = 63;
            for (k = 0; k < 4; k++) {
                int sy = iy - 1 + k;
                if (period > 1) sy /= period;
                m_hrow(src, sw, sh, spitch, ix, ph, sy, rows[k]);
            }
            lum = 0;
            mixv = fy < 0 ? 0 : fy > 1 ? 1 : fy;
            lum = (rows[1][0] * (1.f - mixv) + rows[2][0] * mixv) * 0.299f
                + (rows[1][1] * (1.f - mixv) + rows[2][1] * mixv) * 0.587f
                + (rows[1][2] * (1.f - mixv) + rows[2][2] * mixv) * 0.114f;
            if (lum < 0) lum = 0;
            if (lum > 1) lum = 1;
            for (k = 0; k < 4; k++) w[k] = wd[k] * (1.f - lum) + wb[k] * lum;
            for (t = 0; t < 3; t++) {
                float c = rows[0][t] * w[0] + rows[1][t] * w[1] + rows[2][t] * w[2] + rows[3][t] * w[3];
                int gi;
                if (c < 0) c = 0;
                if (c > 1) c = 1;
                gi = (int)(c * 255.f);
                if (gi > 255) gi = 255;
                c = m_gamma[gi] * bright;
                if (c < 0) c = 0;
                if (c > 1) c = 1;
                ch[t] = (int)(c * 255.f + 0.5f);
                if (ch[t] > 255) ch[t] = 255;
            }
            outp = 0xFF000000u | ((uint32_t)ch[0] << 16) | ((uint32_t)ch[1] << 8) | (uint32_t)ch[2];
            m_out[oy * ow + ox] = outp;
        }
    }
    *dst = m_out;
    *dw = ow;
    *dh = oh;
    return 1;
}
