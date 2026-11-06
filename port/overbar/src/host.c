/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * First-launch defaults (L15), ini, overlay keys (L13).
 */
#include "overbar/overbar.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static const char *mode_name[OB_MODE_COUNT] = {
    "sharp", "crt", "mister", "retroarch",
    "scale2x", "scale3x", "mmpx2x", "mmpx4x", "xbr2x", "xbr3x", "xbr4x"
};
static const char *mode_label[OB_MODE_COUNT] = {
    "Sharp", "CRT Monitor", "MiSTer", "RetroArch",
    "Scale2x", "Scale3x", "MMPX 2x", "MMPX 4x", "xBR 2x", "xBR 3x", "xBR 4x"
};
static const char *refresh_name[3] = { "60", "70", "vrr" };
static const char *height_name[4] = { "fit", "integer", "overscan", "auto-crop" };
static const char *height_label[4] = {
    "Fit", "Integer", "Integer+Overscan", "Auto Crop"
};

static int name_index(const char *v, const char **names, int n, int def)
{
    int i;
    for (i = 0; i < n; i++) if (v && !strcmp(v, names[i])) return i;
    return def;
}

static void caps_from_port(ob_host *h)
{
    h->has_hires = (h->port == OB_PORT_PC95 || h->port == OB_PORT_PC96);
    h->has_sound = 1;
    h->console_dar = (h->port == OB_PORT_GENESIS || h->port == OB_PORT_SNES
                      || h->port == OB_PORT_GENERIC);
    h->online_ready = (h->port == OB_PORT_GENESIS);
}

static void look_init(ob_look *l, int console, int lores)
{
    memset(l, 0, sizeof *l);
    l->mode = OB_MODE_SHARP;
    l->crt = OB_CRT_LIGHT;
    l->height = OB_HEIGHT_FIT;
    l->khz31 = 0;
    l->mask_scale = 1;
    l->bright = 100;
    if (console) l->sharp = OB_SHARP_1X;
    else if (lores) l->sharp = OB_SHARP_LO_3X;
    else l->sharp = OB_SHARP_1X;
}

void ob_defaults_apply(ob_host *h, ob_profile profile)
{
    int console = h->console_dar;
    h->profile = profile;
    look_init(&h->lores, console, 1);
    look_init(&h->hires, 0, 0);
    h->stats = 0;
    h->volume = 80;
    h->mute = 0;
    h->replay_secs_index = 2;   /* 20 s, PulseMan README default */
    h->gif_scale = 0;
    h->recording = 0;
    h->live_preview = 1;
    if (profile == OB_PROFILE_HANDHELD) {
        h->refresh = OB_REFRESH_60;
        h->vsync = 1;
    } else {
        h->refresh = OB_REFRESH_VRR;
        h->vsync = 0;
    }
}

void ob_host_init(ob_host *h, ob_port port, ob_profile profile)
{
    memset(h, 0, sizeof *h);
    h->port = port;
    caps_from_port(h);
    ob_defaults_apply(h, profile);
    mdrt_menu_init(&h->overlay);
}

void ob_host_free(ob_host *h)
{
    mdrt_menu_free(&h->overlay);
    memset(h, 0, sizeof *h);
}

ob_profile ob_profile_detect(const char *sdl_video_driver, int env_handheld)
{
    if (env_handheld) return OB_PROFILE_HANDHELD;
    if (sdl_video_driver) {
        if (!strcmp(sdl_video_driver, "KMSDRM") || !strcmp(sdl_video_driver, "kmsdrm"))
            return OB_PROFILE_HANDHELD;
        if (!strcmp(sdl_video_driver, "RPI") || !strcmp(sdl_video_driver, "rpi"))
            return OB_PROFILE_HANDHELD;
    }
    return OB_PROFILE_DESKTOP;
}

const char *ob_mode_label(ob_scale_mode m)
{
    return (m >= 0 && m < OB_MODE_COUNT) ? mode_label[m] : "Sharp";
}

const char *ob_refresh_label(ob_refresh r)
{
    static const char *lab[3] = { "60 Hz", "70 Hz", "VRR" };
    return (r >= 0 && r <= OB_REFRESH_VRR) ? lab[r] : lab[0];
}

const char *ob_height_label(ob_picture_height h)
{
    return (h >= 0 && h <= OB_HEIGHT_AUTO_CROP) ? height_label[h] : height_label[0];
}

int ob_has_hires(const ob_host *h) { return h->has_hires; }
int ob_snes_has_native(void) { return 0; }

int ob_mode_has_khz(ob_scale_mode m)
{
    return m == OB_MODE_CRT || m == OB_MODE_MISTER;
}

int ob_mode_is_pixel(ob_scale_mode m)
{
    return m >= OB_MODE_SCALE2X;
}

ob_hostkey ob_map_key(int sdl_scancode)
{
    if (sdl_scancode == OB_SCANCODE_GRAVE || sdl_scancode == OB_SCANCODE_F11)
        return OB_HOSTKEY_OVERLAY;
    if (sdl_scancode == OB_SCANCODE_F12) return OB_HOSTKEY_STATS;
    return OB_HOSTKEY_NONE;
}

ob_hostkey ob_map_pad_back(void) { return OB_HOSTKEY_OVERLAY; }

int ob_host_add_addon(ob_host *h, int id, const char *label, int (*open)(void *ctx))
{
    if (h->naddons >= OB_ADDONS_MAX) return 0;
    h->addons[h->naddons].id = id;
    h->addons[h->naddons].label = label;
    h->addons[h->naddons].open = open;
    h->naddons++;
    return 1;
}

static void strip(char *s)
{
    char *e;
    while (*s == ' ' || *s == '\t') s++;
    e = s + strlen(s);
    while (e > s && (e[-1] == ' ' || e[-1] == '\n' || e[-1] == '\r' || e[-1] == '\t')) *--e = 0;
}

static void apply_look_key(ob_look *l, const char *key, const char *v)
{
    if (!strcmp(key, "scale_mode")) l->mode = (ob_scale_mode)name_index(v, mode_name, OB_MODE_COUNT, 0);
    else if (!strcmp(key, "sharp")) {
        if (!strcmp(v, "1x") || !strcmp(v, "1X")) l->sharp = 0;
        else if (!strcmp(v, "2x") || !strcmp(v, "2X")) l->sharp = 1;
        else if (!strcmp(v, "3x") || !strcmp(v, "3X")) l->sharp = 2;
        else if (!strcmp(v, "4x") || !strcmp(v, "4X") || !strcmp(v, "5x")) l->sharp = 3;
        else if (!strcmp(v, "7x")) l->sharp = 2;
        else if (!strcmp(v, "11x")) l->sharp = 3;
        else l->sharp = atoi(v);
    } else if (!strcmp(key, "crt")) l->crt = (ob_crt_look)atoi(v);
    else if (!strcmp(key, "picture_height")) l->height = (ob_picture_height)name_index(v, height_name, 4, 0);
    else if (!strcmp(key, "khz")) l->khz31 = atoi(v) == 31;
    else if (!strcmp(key, "mask_scale")) l->mask_scale = atoi(v) < 1 ? 1 : atoi(v) > 4 ? 4 : atoi(v);
    else if (!strcmp(key, "bright")) l->bright = atoi(v);
}

static void write_look(FILE *f, const char *prefix, const ob_look *l, int console, int lores)
{
    static const char *sharp_hi[4] = { "1x", "2x", "3x", "4x" };
    static const char *sharp_lo[4] = { "3x", "5x", "7x", "11x" };
    const char *sh = (console || !lores) ? sharp_hi[l->sharp % 4] : sharp_lo[l->sharp % 4];
    fprintf(f, "%s_scale_mode=%s\n", prefix, mode_name[l->mode % OB_MODE_COUNT]);
    fprintf(f, "%s_sharp=%s\n", prefix, sh);
    fprintf(f, "%s_crt=%d\n", prefix, l->crt);
    fprintf(f, "%s_picture_height=%s\n", prefix, height_name[l->height % 4]);
    fprintf(f, "%s_khz=%d\n", prefix, l->khz31 ? 31 : 15);
    fprintf(f, "%s_mask_scale=%d\n", prefix, l->mask_scale);
    fprintf(f, "%s_bright=%d\n", prefix, l->bright);
}

int ob_host_save_ini(const ob_host *h)
{
    FILE *f;
    if (!h->ini_path[0]) return 0;
    f = fopen(h->ini_path, "w");
    if (!f) return 0;
    fprintf(f, "; Overbar host settings. Overlay and the file menu write the same file.\n[overbar]\n");
    fprintf(f, "refresh=%s\n", refresh_name[h->refresh % 3]);
    fprintf(f, "vsync=%s\n", h->vsync ? "on" : "off");
    fprintf(f, "stats=%s\n", h->stats ? "on" : "off");
    write_look(f, "lores", &h->lores, h->console_dar, 1);
    if (h->has_hires) write_look(f, "hires", &h->hires, 0, 0);
    fprintf(f, "volume=%d\n", h->volume);
    fprintf(f, "mute=%s\n", h->mute ? "on" : "off");
    fclose(f);
    return 1;
}

int ob_host_load_ini(ob_host *h, const char *path)
{
    FILE *f;
    char line[256];
    snprintf(h->ini_path, sizeof h->ini_path, "%s", path ? path : "");
    f = path ? fopen(path, "r") : NULL;
    if (!f) {
        ob_defaults_apply(h, h->profile);
        h->wrote_defaults = 1;
        if (path) ob_host_save_ini(h);
        return 0;
    }
    while (fgets(line, sizeof line, f)) {
        char *k = line, *v;
        if (line[0] == ';' || line[0] == '[' || line[0] == '#') continue;
        v = strchr(line, '=');
        if (!v) continue;
        *v++ = 0;
        strip(k); strip(v);
        if (!strcmp(k, "refresh")) h->refresh = (ob_refresh)name_index(v, refresh_name, 3, OB_REFRESH_VRR);
        else if (!strcmp(k, "vsync")) h->vsync = strcmp(v, "off") != 0;
        else if (!strcmp(k, "stats")) h->stats = !strcmp(v, "on");
        else if (!strcmp(k, "volume")) h->volume = atoi(v);
        else if (!strcmp(k, "mute")) h->mute = !strcmp(v, "on");
        else if (!strncmp(k, "lores_", 6)) apply_look_key(&h->lores, k + 6, v);
        else if (!strncmp(k, "hires_", 6)) apply_look_key(&h->hires, k + 6, v);
    }
    fclose(f);
    h->wrote_defaults = 0;
    return 1;
}

int ob_host_apply(ob_host *h, ob_class cls, int id, int value)
{
    ob_look *look = (cls == OB_CLASS_HIRES) ? &h->hires : &h->lores;
    switch (id) {
    case OB_ID_REFRESH:
        h->refresh = (ob_refresh)value;
        if (h->refresh == OB_REFRESH_VRR) h->vsync = 0;
        if (h->refresh == OB_REFRESH_60 && h->profile == OB_PROFILE_HANDHELD) h->vsync = 1;
        break;
    case OB_ID_VSYNC: h->vsync = value; break;
    case OB_ID_STATS: h->stats = value; break;
    case OB_ID_SCALE_MODE: look->mode = (ob_scale_mode)value; break;
    case OB_ID_VIDEO_CLASS: h->video_class = value ? OB_CLASS_HIRES : OB_CLASS_LORES; break;
    case OB_ID_SHARP_AMOUNT: look->sharp = value; break;
    case OB_ID_CRT_LOOK: look->crt = (ob_crt_look)value; break;
    case OB_ID_PICTURE_HEIGHT: look->height = (ob_picture_height)value; break;
    case OB_ID_MONITOR_KHZ: look->khz31 = value; break;
    case OB_ID_MISTER_MASK_SCALE: look->mask_scale = value + 1; break;
    case OB_ID_MISTER_BRIGHT: look->bright = 70 + 10 * value; break;
    case OB_ID_MISTER_RESET:
        look->mask_scale = 1;
        look->bright = 100;
        break;
    case OB_ID_VOLUME: h->volume = value; break;
    case OB_ID_MUTE: h->mute = value; break;
    case OB_ID_CAP_SECONDS: h->replay_secs_index = value; break;
    case OB_ID_CAP_GIFSCALE: h->gif_scale = value; break;
    case OB_ID_CAP_RECORD: h->recording = !h->recording; break;
    default: return 0;
    }
    h->live_preview = 1;
    if (h->ini_path[0]) ob_host_save_ini(h);
    return 1;
}
