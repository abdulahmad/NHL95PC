/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * Overlay shell: PulseMan mdrt_menu pages filled from the shared model.
 * Always available (windowed, fullscreen, handheld). ` and F11 toggle it;
 * F12 toggles stats. Changes apply immediately (live preview).
 */
#include "overbar/overbar.h"

#include <stdio.h>
#include <string.h>

static const char *page_title(int page)
{
    switch (page) {
    case OB_PAGE_VIDEO: return "Video";
    case OB_PAGE_SOUND: return "Sound";
    case OB_PAGE_INPUT: return "Input";
    case OB_PAGE_CAPTURE: return "Capture";
    case OB_PAGE_ONLINE: return "Online Play";
    case OB_PAGE_KEYS: return "Keys";
    default: return "Overbar";
    }
}

void ob_overlay_build(ob_host *h)
{
    ob_item items[OB_ITEMS_MAX];
    int n = ob_page_items(h, h->overlay_page, items, OB_ITEMS_MAX);
    int i, sel = h->overlay.sel;
    mdrt_menu *m = &h->overlay;
    mdrt_menu_page(m, page_title(h->overlay_page));
    if (h->overlay_page == OB_PAGE_VIDEO) {
        if (h->fallback_note)
            snprintf(m->subtitle, sizeof m->subtitle, "%s", h->fallback_note);
        else
            snprintf(m->subtitle, sizeof m->subtitle, "Only this Scale Mode's options. Changes live-preview.");
    }
    else if (h->overlay_page == OB_PAGE_MAIN)
        snprintf(m->subtitle, sizeof m->subtitle, "` / F11 overlay   F12 stats");
    for (i = 0; i < n; i++) {
        const ob_item *it = &items[i];
        mdrt_menu_item *add;
        if (it->kind == MDRT_ITEM_CHOICE)
            add = mdrt_menu_add_choice(m, it->id, it->label, it->choices, it->nchoices, it->value);
        else if (it->kind == MDRT_ITEM_NUMBER)
            add = mdrt_menu_add_number(m, it->id, it->label, it->value, 0, it->nchoices ? it->nchoices : 100, 5, "%");
        else
            add = mdrt_menu_add(m, it->id, it->kind, it->label);
        if (add && it->detail[0]) snprintf(add->detail, sizeof add->detail, "%s", it->detail);
    }
    if (sel >= 0 && sel < m->count) m->sel = sel;
    else mdrt_menu_select(m, m->count ? m->items[0].id : 0);
}

void ob_overlay_open(ob_host *h)
{
    h->overlay_open = 1;
    h->overlay_page = OB_PAGE_MAIN;
    ob_overlay_build(h);
}

void ob_overlay_close(ob_host *h)
{
    h->overlay_open = 0;
}

static void go_page(ob_host *h, int page)
{
    h->overlay_page = page;
    h->overlay.sel = 0;
    ob_overlay_build(h);
}

int ob_overlay_input(ob_host *h, int mdrt_input)
{
    int id;
    if (!h->overlay_open) return 0;
    id = mdrt_menu_input(&h->overlay, mdrt_input);
    if (id == MDRT_MENU_CLOSE) {
        if (h->overlay_page == OB_PAGE_MAIN) ob_overlay_close(h);
        else go_page(h, OB_PAGE_MAIN);
        return h->overlay_open;
    }
    if (id == MDRT_MENU_NOTHING) return 1;
    switch (id) {
    case OB_ID_RESUME: ob_overlay_close(h); return 0;
    case OB_ID_QUIT: h->request_quit = 1; ob_overlay_close(h); return 0;
    case OB_ID_VIDEO: go_page(h, OB_PAGE_VIDEO); return 1;
    case OB_ID_SOUND: go_page(h, OB_PAGE_SOUND); return 1;
    case OB_ID_INPUT: go_page(h, OB_PAGE_INPUT); return 1;
    case OB_ID_CAPTURE: go_page(h, OB_PAGE_CAPTURE); return 1;
    case OB_ID_ONLINE: go_page(h, OB_PAGE_ONLINE); return 1;
    case OB_ID_KEYS: go_page(h, OB_PAGE_KEYS); return 1;
    case OB_ID_BACK: go_page(h, OB_PAGE_MAIN); return 1;
    default: {
        int i;
        mdrt_menu_item *it = mdrt_menu_find(&h->overlay, id);
        int value = it ? it->value : 0;
        for (i = 0; i < h->naddons; i++) {
            if (h->addons[i].id == id && h->addons[i].open) {
                h->addons[i].open(h->addon_ctx);
                ob_overlay_build(h);
                mdrt_menu_select(&h->overlay, id);
                return 1;
            }
        }
        if (id == OB_ID_CONTROLLERS) {
            /* client opens its pad setup; overlay stays */
            return id;
        }
        ob_host_apply(h, h->video_class, id, value);
        /* Rebuild so Scale Mode sub-options match the new choice (live preview). */
        ob_overlay_build(h);
        if (it) mdrt_menu_select(&h->overlay, id);
        return 1;
    }
    }
}

void ob_overlay_draw(ob_host *h, uint32_t *px, int w, int hgt, int pitch)
{
    if (h->overlay_open) mdrt_menu_draw(&h->overlay, px, w, hgt, pitch);
}

int ob_overlay_toggle_key(ob_host *h, int sdl_scancode)
{
    if (ob_map_key(sdl_scancode) != OB_HOSTKEY_OVERLAY) return 0;
    if (h->overlay_open) ob_overlay_close(h);
    else ob_overlay_open(h);
    return 1;
}

int ob_stats_toggle_key(ob_host *h, int sdl_scancode)
{
    if (ob_map_key(sdl_scancode) != OB_HOSTKEY_STATS) return 0;
    h->stats = !h->stats;
    h->live_preview = 1;
    if (h->ini_path[0]) ob_host_save_ini(h);
    return 1;
}
