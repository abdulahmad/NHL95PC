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

static const char *page_title(const ob_host *h, int page)
{
    switch (page) {
    case OB_PAGE_VIDEO: return "Video";
    case OB_PAGE_SOUND: return "Sound";
    case OB_PAGE_INPUT: return "Input";
    case OB_PAGE_CAPTURE: return "Capture";
    case OB_PAGE_ONLINE: return "Online Play";
    case OB_PAGE_KEYS: return "Keys";
    case OB_PAGE_SCALE_HI: return "Scaling (Hi-Res)";
    case OB_PAGE_SCALE_LO: return h->has_hires ? "Scaling (Lo-Res)" : "Scaling";
    case OB_PAGE_MODE_HI:
    case OB_PAGE_MODE_LO: return "Scale Mode";
    case OB_PAGE_OPTS_HI:
    case OB_PAGE_OPTS_LO: return "Scale Mode options";
    case OB_PAGE_MISTER: {
        const char *slash = strrchr(h->mister_dir, '/');
        if (slash && slash[1]) return slash + 1;
        if (h->mister_dir[0]) return h->mister_dir;
        return "MiSTer";
    }
    default: return "Overbar";
    }
}

void ob_overlay_build(ob_host *h)
{
    ob_item items[OB_ITEMS_MAX];
    int n = ob_page_items(h, h->overlay_page, items, OB_ITEMS_MAX);
    int i, sel = h->overlay.sel;
    mdrt_menu *m = &h->overlay;
    mdrt_menu_page(m, page_title(h, h->overlay_page));
    if (h->overlay_page == OB_PAGE_MISTER) memset(h->mister_row, 0, sizeof h->mister_row);
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
        if (it->kind == OB_ITEM_SEP) continue;   /* dividers are for the menu bar */
        if (it->id == OB_ID_MODE_MENU_HI || it->id == OB_ID_MODE_MENU_LO) {
            const ob_look *lk = it->id == OB_ID_MODE_MENU_HI ? &h->hires : &h->lores;
            int nc = 0;
            const char *const *choices = ob_mode_choice_list(&nc);
            /* The bar opens a submenu. The overlay flips the value on this row. */
            mdrt_menu_add_choice(m, OB_ID_SCALE_MODE, "Scale Mode", choices, nc,
                                 ob_mode_choice_index(lk->mode));
            continue;
        }
        if (it->kind == MDRT_ITEM_CHOICE) {
            static const char *const unused[] = { "not in use" };
            if (it->value < 0)
                add = mdrt_menu_add_choice(m, it->id, it->label, unused, 1, 0);
            else
                add = mdrt_menu_add_choice(m, it->id, it->label, it->choices, it->nchoices, it->value);
        }
        else if (it->kind == MDRT_ITEM_NUMBER)
            add = mdrt_menu_add_number(m, it->id, it->label, it->value, 0, it->nchoices ? it->nchoices : 100, 5, "%");
        else
            add = mdrt_menu_add(m, it->id, it->kind, it->label);
        if (add && it->kind == MDRT_ITEM_ACTION) add->value = it->value;
        if (it->id == OB_ID_MISTER_DIR || it->id == OB_ID_MISTER_FILE)
            snprintf(h->mister_row[i], sizeof h->mister_row[i], "%s", it->detail);
        else if (add && it->detail[0]) {
            size_t dn = strlen(it->detail);
            if (dn >= sizeof add->detail) dn = sizeof add->detail - 1;
            memcpy(add->detail, it->detail, dn);
            add->detail[dn] = 0;
        }
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

static int parent_page(const ob_host *h, int page)
{
    if (page == OB_PAGE_MISTER)
        return h->video_class == OB_CLASS_HIRES ? OB_PAGE_OPTS_HI : OB_PAGE_OPTS_LO;
    if (page == OB_PAGE_MODE_LO || page == OB_PAGE_OPTS_LO) return OB_PAGE_SCALE_LO;
    if (page == OB_PAGE_MODE_HI || page == OB_PAGE_OPTS_HI) return OB_PAGE_SCALE_HI;
    if (page == OB_PAGE_SCALE_HI || page == OB_PAGE_SCALE_LO) return OB_PAGE_VIDEO;
    return OB_PAGE_MAIN;
}

/* Back inside a MiSTer folder returns to the folder above it. */
static int mister_up(ob_host *h)
{
    char *slash;
    if (h->overlay_page != OB_PAGE_MISTER) return 0;
    slash = strrchr(h->mister_dir, '/');
    if (!slash) return 0;
    *slash = 0;
    return 1;
}

static void go_page(ob_host *h, int page)
{
    h->overlay_page = page;
    h->overlay.sel = 0;
    ob_overlay_build(h);
}

int ob_overlay_pointer(ob_host *h, int x, int y, int bw, int bh, int what)
{
    int i;
    if (!h || !h->overlay_open) return 0;
    i = mdrt_menu_at(&h->overlay, x, y, bw, bh);
    if (what == 0) {
        if (i >= 0 && i != h->overlay.sel) { h->overlay.sel = i; return 1; }
        return 0;
    }
    if (what == 2) return ob_overlay_input(h, MDRT_MENU_BACK);
    if (what == 3) return ob_overlay_input(h, MDRT_MENU_UP);
    if (what == 4) return ob_overlay_input(h, MDRT_MENU_DOWN);
    if (what == 1 && i >= 0) {
        h->overlay.sel = i;
        return ob_overlay_input(h, MDRT_MENU_OK);
    }
    return h->overlay_open;
}

int ob_overlay_input(ob_host *h, int mdrt_input)
{
    int id;
    if (!h->overlay_open) return 0;
    id = mdrt_menu_input(&h->overlay, mdrt_input);
    if (id == MDRT_MENU_CLOSE) {
        if (h->overlay_page == OB_PAGE_MAIN) ob_overlay_close(h);
        else if (mister_up(h)) ob_overlay_build(h);
        else go_page(h, parent_page(h, h->overlay_page));
        return h->overlay_open;
    }
    if (id == MDRT_MENU_NOTHING) return 1;
    switch (id) {
    case OB_ID_RESUME: ob_overlay_close(h); return 0;
    case OB_ID_QUIT: h->request_quit = 1; ob_overlay_close(h); return 0;
    case OB_ID_VIDEO: go_page(h, OB_PAGE_VIDEO); return 1;
    case OB_ID_SCALE_HI: h->video_class = OB_CLASS_HIRES; go_page(h, OB_PAGE_SCALE_HI); return 1;
    case OB_ID_SCALE_LO: h->video_class = OB_CLASS_LORES; go_page(h, OB_PAGE_SCALE_LO); return 1;
    case OB_ID_MODE_MENU_HI: h->video_class = OB_CLASS_HIRES; go_page(h, OB_PAGE_MODE_HI); return 1;
    case OB_ID_MODE_MENU_LO: h->video_class = OB_CLASS_LORES; go_page(h, OB_PAGE_MODE_LO); return 1;
    case OB_ID_OPTS_MENU_HI: h->video_class = OB_CLASS_HIRES; go_page(h, OB_PAGE_OPTS_HI); return 1;
    case OB_ID_OPTS_MENU_LO: h->video_class = OB_CLASS_LORES; go_page(h, OB_PAGE_OPTS_LO); return 1;
    case OB_ID_SOUND: go_page(h, OB_PAGE_SOUND); return 1;
    case OB_ID_INPUT: go_page(h, OB_PAGE_INPUT); return 1;
    case OB_ID_CAPTURE: go_page(h, OB_PAGE_CAPTURE); return 1;
    case OB_ID_ONLINE: go_page(h, OB_PAGE_ONLINE); return 1;
    case OB_ID_KEYS: go_page(h, OB_PAGE_KEYS); return 1;
    case OB_ID_BACK:
        if (mister_up(h)) { ob_overlay_build(h); return 1; }
        go_page(h, parent_page(h, h->overlay_page));
        return 1;
    case OB_ID_MISTER_PRESET:
    case OB_ID_MISTER_H:
    case OB_ID_MISTER_V:
    case OB_ID_MISTER_GAMMA:
    case OB_ID_MISTER_MASK: {
        const char *root = "Filters";
        h->mister_kind = id == OB_ID_MISTER_PRESET ? 4 : id == OB_ID_MISTER_V ? 1
            : id == OB_ID_MISTER_GAMMA ? 2 : id == OB_ID_MISTER_MASK ? 3 : 0;
        if (h->mister_kind == 4) root = "Presets";
        else if (h->mister_kind == 2) root = "Gamma";
        else if (h->mister_kind == 3) root = "Shadow_Masks";
        snprintf(h->mister_dir, sizeof h->mister_dir, "%s", root);
        go_page(h, OB_PAGE_MISTER);
        return 1;
    }
    case OB_ID_MISTER_DIR:
    case OB_ID_MISTER_FILE: {
        mdrt_menu_item *it = NULL;
        if (h->overlay.sel >= 0 && h->overlay.sel < h->overlay.count)
            it = &h->overlay.items[h->overlay.sel];
        if (id == OB_ID_MISTER_DIR && h->overlay.sel >= 0 && h->overlay.sel < OB_ITEMS_MAX
            && h->mister_row[h->overlay.sel][0]) {
            snprintf(h->mister_dir, sizeof h->mister_dir, "%s", h->mister_row[h->overlay.sel]);
            ob_overlay_build(h);
            return 1;
        }
        if (id == OB_ID_MISTER_FILE) {
            const char *rel = (h->overlay.sel >= 0 && h->overlay.sel < OB_ITEMS_MAX)
                ? h->mister_row[h->overlay.sel] : "";
            ob_mister_pick(h, h->video_class, it ? it->value : h->mister_kind, rel);
            ob_capture_apply(h, id);
            ob_filemenu_after_change(id);
            ob_overlay_build(h);
            return 1;
        }
        return 1;
    }
    default: {
        int i;
        mdrt_menu_item *it = NULL;
        int value;
        /* Several Scale Mode rows share one id. The highlighted row is the one chosen. */
        if (h->overlay.sel >= 0 && h->overlay.sel < h->overlay.count
            && h->overlay.items[h->overlay.sel].id == id)
            it = &h->overlay.items[h->overlay.sel];
        if (!it) it = mdrt_menu_find(&h->overlay, id);
        value = it ? it->value : 0;
        if (it && it->kind == MDRT_ITEM_CHOICE && id == OB_ID_SCALE_MODE)
            value = ob_mode_choice_value(value);
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
        ob_capture_apply(h, id);
        ob_filemenu_after_change(id);
        /* Rebuild so Scale Mode sub-options match the new choice (live preview). */
        ob_overlay_build(h);
        if (id == OB_ID_SCALE_MODE) {
            int idx = ob_mode_choice_index((ob_scale_mode)value);
            for (i = 0; i < h->overlay.count; i++)
                if (h->overlay.items[i].id == id
                    && (h->overlay.items[i].kind == MDRT_ITEM_CHOICE
                        ? h->overlay.items[i].value == idx
                        : h->overlay.items[i].value == value)) {
                    h->overlay.sel = i;
                    break;
                }
        } else if (it)
            mdrt_menu_select(&h->overlay, id);
        return 1;
    }
    }
}

void ob_overlay_draw(ob_host *h, uint32_t *px, int w, int hgt, int pitch)
{
    int y, x;
    if (!h->overlay_open) return;
    /* Caller fills the buffer with 0x00040404. The dim turns that into 0x010101,
     * which stays clear so the filtered picture shows through the text. */
    mdrt_menu_draw(&h->overlay, px, w, hgt, pitch);
    for (y = 0; y < hgt; y++)
        for (x = 0; x < w; x++) {
            uint32_t p = px[y * pitch + x];
            if ((p & 0xFFFFFFu) == 0x010101u) px[y * pitch + x] = 0;
            else px[y * pitch + x] = 0xFF000000u | (p & 0xFFFFFFu);
        }
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
