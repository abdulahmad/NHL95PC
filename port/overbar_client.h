/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * NHL 95 PC Overbar client: overlay ` / F11, stats F12, VGA dest-rect (dar_h = src_h).
 */
#ifndef OVERBAR_CLIENT_H
#define OVERBAR_CLIENT_H

#include <stdint.h>
#include "overbar/overbar.h"

void overbar_client_init(ob_profile profile, void (*apply_host)(ob_host *h));
void overbar_client_free(void);
void settings_ini_path(char *out, size_t n);      /* the port's ini (video.c) */
ob_host *overbar_client_host(void);
int overbar_client_open(void);
int overbar_client_quit(void);
int overbar_client_key(int scancode);           /* 1 if overlay/stats consumed it */
int overbar_client_pad_back(void);
int overbar_client_input(int mdrt_input);
int overbar_client_pointer(int x, int y, int w, int h, int what);
void overbar_client_draw(uint32_t *px, int w, int h, int pitch);
void overbar_client_view(int src_w, int src_h, int win_w, int win_h,
                         int height, int line_double, int *x, int *y, int *w, int *h);
void overbar_client_set_class(int lores);
void overbar_client_apply(void);
void overbar_client_close(void);
void overbar_client_online_open(void);           /* the overlay, on the Online page */
int overbar_client_editing(void);               /* a field of the Online page takes typed text (SDL text input on) */
int overbar_client_text(const char *utf8);      /* SDL_TEXTINPUT's text for it; 1 if used */

/* online play (netplay.c) */
void netplay_online_setup(ob_host *h);          /* the rest is in host.h */                 /* run apply_host on the ob_host: a change made outside the overlay (the menu bar) */

#endif
