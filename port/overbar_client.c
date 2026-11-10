/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * Thin Overbar client for nhl95pc. Dual-writes overlay choices onto video_command
 * via apply_host. Dest-rect is VGA (dar_h = src_h). Unimplemented Scale Modes stay
 * on the menu and fall back to Sharp in the existing scaler.
 */
#include "overbar_client.h"
#include "feel.h"
#include "season.h"
#include "sides.h"

#include <string.h>

static ob_host host;
static void (*apply_host)(ob_host *h);

void overbar_client_init(ob_profile profile, void (*apply)(ob_host *h))
{
    ob_host_init(&host, OB_PORT_PC95, profile);
    apply_host = apply;
    {
        char path[1024];
        settings_ini_path(path, sizeof path);
        feel_register(&host, path);     /* the Game page; before the menu bar is built */
    }
    netplay_online_setup(&host);        /* the Online page (netplay.c); before the menu bar, which greys it out otherwise */
    port_season_setup(&host);           /* Season: the game's league folder, after Online so the player's name is in */
    port_sides_init();                  /* Overbar's select-sides screen: every controller, the same module online */
}

void overbar_client_free(void)
{
    port_sides_unbind_net();
    port_season_free();
    ob_host_free(&host);
}

ob_host *overbar_client_host(void) { return &host; }

int overbar_client_open(void) { return host.overlay_open; }
void overbar_client_close(void) { if (host.overlay_open) ob_overlay_close(&host); }
void overbar_client_online_open(void) { ob_online_open(&host); }
int overbar_client_editing(void) { return host.overlay_open && ob_overlay_editing(&host); }
int overbar_client_text(const char *utf8) { return overbar_client_editing() && ob_overlay_text(&host, utf8); }
int overbar_client_quit(void) { return host.request_quit; }

int overbar_client_key(int scancode)
{
    if (ob_overlay_toggle_key(&host, scancode)) return 1;
    if (ob_stats_toggle_key(&host, scancode)) {
        if (apply_host) apply_host(&host);
        return 1;
    }
    return 0;
}

int overbar_client_pad_back(void)
{
    if (host.overlay_open) ob_overlay_close(&host);
    else ob_overlay_open(&host);
    return 1;
}

int overbar_client_input(int mdrt_input)
{
    int r = ob_overlay_input(&host, mdrt_input);
    if (apply_host) apply_host(&host);
    return r;
}

int overbar_client_pointer(int x, int y, int w, int h, int what)
{
    int r = ob_overlay_pointer(&host, x, y, w, h, what);
    if (what != 0 && apply_host) apply_host(&host);
    return r;
}

void overbar_client_draw(uint32_t *px, int w, int h, int pitch)
{
    ob_overlay_draw(&host, px, w, h, pitch);
}

void overbar_client_view(int src_w, int src_h, int win_w, int win_h,
                         int height, int line_double, int *x, int *y, int *w, int *h)
{
    ob_view_in in;
    ob_view_out out;
    memset(&in, 0, sizeof in);
    in.src_w = src_w;
    in.src_h = src_h;
    in.dar_h = src_h;           /* VGA: 4:3 of the real height, not 240 */
    in.window_w = win_w;
    in.window_h = win_h;
    in.height = (ob_picture_height)height;
    in.line_double = line_double;
    ob_view(&in, &out);
    *x = out.blit_x;
    *y = out.blit_y;
    *w = out.blit_w;
    *h = out.blit_h;
}

void overbar_client_set_class(int lores)
{
    host.video_class = lores ? OB_CLASS_LORES : OB_CLASS_HIRES;
}

void overbar_client_apply(void)
{
    if (apply_host) apply_host(&host);
}
