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

#endif
