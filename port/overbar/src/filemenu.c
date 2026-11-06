/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * Native file-menu shell. v1: show policy + the same item list as the overlay
 * (so a later Win32/GTK/Cocoa unit can CreateMenu from it). Linux/macOS bars
 * are platform customizations in this repo, not per-game copies.
 *
 * L3: menu bar only in windowed desktop. Overlay always available.
 * Handheld / KMSDRM: overlay only. Opening the Win32 bar still pauses the
 * PC game (WM_ENTERMENULOOP) — that hook lands with the real CreateMenu.
 */
#include "overbar/overbar.h"

#include <string.h>

static void *g_hwnd;
static int g_shown;

int ob_filemenu_wanted(int windowed, int fullscreen, int handheld)
{
    return windowed && !fullscreen && !handheld;
}

int ob_filemenu_items(const ob_host *h, ob_item *out, int cap)
{
    /* Same ids as the overlay Video page (plus main actions a bar would list). */
    ob_item tmp[OB_ITEMS_MAX];
    int n = 0, i, v;
    ob_item *it;
    if (cap < 1) return 0;
    it = &out[n++];
    memset(it, 0, sizeof *it);
    it->id = OB_ID_RESUME;
    it->kind = MDRT_ITEM_ACTION;
    it->label = "Resume";
    v = ob_video_items(h, h->has_hires ? h->video_class : OB_CLASS_LORES, tmp, OB_ITEMS_MAX);
    for (i = 0; i < v && n < cap; i++) {
        if (tmp[i].id == OB_ID_BACK) continue;   /* a bar has no Back */
        out[n++] = tmp[i];
    }
    return n;
}

void ob_filemenu_init(void *sdl_window)
{
    g_hwnd = sdl_window;
    g_shown = 0;
    (void)sdl_window;
    /* Win32: later unit CreateMenu from ob_filemenu_items and subclass
     * WM_ENTERMENULOOP / WM_COMMAND. GTK and Cocoa bars are separate files. */
}

void ob_filemenu_sync(const ob_host *h)
{
    /* Marks follow the host; overlay and bar share ob_host_apply. */
    (void)h;
}

void ob_filemenu_show(int on)
{
    g_shown = on;
    (void)g_hwnd;
}

void ob_filemenu_event(void *syswm_msg)
{
    (void)syswm_msg;
}

int ob_filemenu_client_size(int *w, int *h)
{
    (void)w; (void)h;
    return 0;
}
