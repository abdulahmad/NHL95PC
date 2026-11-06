/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * One menu model for overlay and file menus. Scale Mode is a single choice;
 * only that mode's sub-options are listed. There is no SNES Native 1:1 item.
 */
#include "overbar/overbar.h"

#include <stdio.h>
#include <string.h>

static const char *const refresh_choices[] = { "60 Hz", "70 Hz", "VRR" };
static const char *const off_on[] = { "Off", "On" };
static const char *const height_choices[] = {
    "Fit", "Integer", "Integer+Overscan", "Auto Crop"
};
static const char *const mode_choices[] = {
    "Sharp", "CRT Monitor", "MiSTer", "RetroArch",
    "Scale2x", "Scale3x", "MMPX 2x", "MMPX 4x", "xBR 2x", "xBR 3x", "xBR 4x"
};
static const char *const sharp_hi[] = { "1X", "2X", "3X", "4X" };
static const char *const sharp_lo_pc[] = { "3X", "5X", "7X", "11X" };
static const char *const crt_choices[] = {
    "Light scanlines", "Medium scanlines", "Strong scanlines",
    "Soft (Lottes)", "Soft + aperture", "Custom"
};
static const char *const khz_choices[] = { "15 kHz", "31 kHz" };
static const char *const mask_scale_choices[] = { "1x", "2x", "3x", "4x" };
static const char *const bright_choices[] = {
    "70%", "80%", "90%", "100%", "110%", "120%", "130%", "140%", "150%"
};
static const char *const replay_choices[] = { "Off", "10 s", "20 s", "30 s", "60 s" };
static const char *const gif_choices[] = { "1x", "2x", "3x" };
static const char *const later[] = { "default (later)" };

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

static void add_action(ob_item *out, int *n, int cap, int id, const char *label, const char *detail)
{
    ob_item *it = add(out, n, cap, id, MDRT_ITEM_ACTION, label);
    if (!it) return;
    if (detail) snprintf(it->detail, sizeof it->detail, "%s", detail);
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
    add_action(out, &n, cap, OB_ID_KEYS, "Keys", NULL);
    add_action(out, &n, cap, OB_ID_QUIT, "Quit", NULL);
    return n;
}

int ob_video_items(const ob_host *h, ob_class cls, ob_item *out, int cap)
{
    const ob_look *look = (cls == OB_CLASS_HIRES) ? &h->hires : &h->lores;
    ob_scale_mode m = look->mode;
    int n = 0;
    int console_sharp = h->console_dar;
    int lores = (cls == OB_CLASS_LORES);
    static const char *const class_choices[] = { "Gameplay (lo-res)", "Menus (hi-res)" };

    add_choice(out, &n, cap, OB_ID_REFRESH, "Refresh", refresh_choices, 3, h->refresh);
    add_choice(out, &n, cap, OB_ID_VSYNC, "Vsync", off_on, 2, h->vsync);
    add_choice(out, &n, cap, OB_ID_STATS, "Stats", off_on, 2, h->stats);
    if (h->has_hires)
        add_choice(out, &n, cap, OB_ID_VIDEO_CLASS, "Screen", class_choices, 2, cls == OB_CLASS_HIRES);
    add_choice(out, &n, cap, OB_ID_SCALE_MODE, "Scale Mode", mode_choices, OB_MODE_COUNT, m);
    {
        const char *note = h->fallback_note ? h->fallback_note : ob_look_fallback_note(m, h->present);
        if (note) add_text(out, &n, cap, OB_ID_PRESENT_NOTE, "This look", note);
    }

    /* Only the selected mode's sub-options (L9). No SNES Native. */
    if (m == OB_MODE_SHARP) {
        if (console_sharp || !lores)
            add_choice(out, &n, cap, OB_ID_SHARP_AMOUNT, "Sharp", sharp_hi, 4, look->sharp % 4);
        else
            add_choice(out, &n, cap, OB_ID_SHARP_AMOUNT, "Sharp", sharp_lo_pc, 4, look->sharp % 4);
    } else if (m == OB_MODE_CRT) {
        add_choice(out, &n, cap, OB_ID_CRT_LOOK, "CRT look", crt_choices, OB_CRT_COUNT, look->crt);
        if (lores) add_choice(out, &n, cap, OB_ID_MONITOR_KHZ, "Monitor", khz_choices, 2, look->khz31);
    } else if (m == OB_MODE_MISTER) {
        add_choice(out, &n, cap, OB_ID_MISTER_PRESET, "Presets", later, 1, 0);
        add_choice(out, &n, cap, OB_ID_MISTER_H, "H filter", later, 1, 0);
        add_choice(out, &n, cap, OB_ID_MISTER_V, "V filter", later, 1, 0);
        add_choice(out, &n, cap, OB_ID_MISTER_GAMMA, "Gamma", later, 1, 0);
        add_choice(out, &n, cap, OB_ID_MISTER_MASK, "Shadow mask", later, 1, 0);
        add_choice(out, &n, cap, OB_ID_MISTER_MASK_SCALE, "Mask scale", mask_scale_choices, 4,
                   look->mask_scale < 1 ? 0 : look->mask_scale - 1);
        add_choice(out, &n, cap, OB_ID_MISTER_BRIGHT, "Brightness", bright_choices, 9,
                   (look->bright - 70) / 10);
        add_action(out, &n, cap, OB_ID_MISTER_RESET, "Reset the MiSTer filters", NULL);
        if (lores) add_choice(out, &n, cap, OB_ID_MONITOR_KHZ, "Monitor", khz_choices, 2, look->khz31);
    } else if (m == OB_MODE_RETROARCH) {
        add_choice(out, &n, cap, OB_ID_RETROARCH_SHADER, "Shader", later, 1, 0);
        add_text(out, &n, cap, OB_ID_RETROARCH_SHADER, "User shaders/", "shaders/");
    }
    /* Pixel-art mag (Scale2x / 3x / MMPX / xBR): picture height only. */
    add_choice(out, &n, cap, OB_ID_PICTURE_HEIGHT, "Picture height", height_choices, 4, look->height);
    add_action(out, &n, cap, OB_ID_BACK, "Back", NULL);
    return n;
}

int ob_page_items(const ob_host *h, int page, ob_item *out, int cap)
{
    int n = 0;
    switch (page) {
    case OB_PAGE_MAIN: return ob_main_items(h, out, cap);
    case OB_PAGE_VIDEO: return ob_video_items(h, h->video_class, out, cap);
    case OB_PAGE_SOUND:
        add(out, &n, cap, OB_ID_VOLUME, MDRT_ITEM_NUMBER, "Volume");
        if (n) { out[n - 1].value = h->volume; out[n - 1].nchoices = 100; }
        add_choice(out, &n, cap, OB_ID_MUTE, "Mute", off_on, 2, h->mute);
        add_action(out, &n, cap, OB_ID_BACK, "Back", NULL);
        return n;
    case OB_PAGE_INPUT:
        add_action(out, &n, cap, OB_ID_CONTROLLERS, "Controllers", NULL);
        add_action(out, &n, cap, OB_ID_BACK, "Back", NULL);
        return n;
    case OB_PAGE_CAPTURE:
        add_action(out, &n, cap, OB_ID_CAP_REPLAY, "Save replay", "F10");
        add_action(out, &n, cap, OB_ID_CAP_RECORD, h->recording ? "Stop recording" : "Start recording", NULL);
        add_choice(out, &n, cap, OB_ID_CAP_SECONDS, "Replay length", replay_choices, 5, h->replay_secs_index);
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
