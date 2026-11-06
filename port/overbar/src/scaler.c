/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * Destination rectangle. Reuses the nhl95pc sdl2-port video_view approach
 * (largest 4:3 in the window; integer k of a line unit; columns never cut)
 * with one console change: unit comes from dar_h=240, source stays src_h=224.
 * The scaler does not blit 8+8 black rows into the texture.
 */
#include "overbar/overbar.h"

static int gcd_pos(int a, int b)
{
    if (a < 0) a = -a;
    if (b < 0) b = -b;
    while (b) { int t = a % b; a = b; b = t; }
    return a ? a : 1;
}

void ob_view(const ob_view_in *in, ob_view_out *out)
{
    int ww = in->window_w > 0 ? in->window_w : 1;
    int wh = in->window_h > 0 ? in->window_h : 1;
    int src_h = in->src_h > 0 ? in->src_h : 1;
    int dar_h = in->dar_h > 0 ? in->dar_h : src_h;
    int vs = in->height;
    int period = in->line_double ? 2 : 1;
    int unit = dar_h * period;
    int w, h;

    /* Fit: largest 4:3 rectangle in the window (95 video_view). */
    w = ww;
    h = ww * 3 / 4;
    if (h > wh) {
        h = wh;
        w = wh * 4 / 3;
    }
    if (vs != OB_HEIGHT_FIT) {
        /* Integer / overscan / auto-crop: a whole number of dest rows per
         * dar_h (240) line, not per 224 source line. Width stays 4:3 of that. */
        int kf = wh / unit;
        int kc, k, n;
        if (kf < 1) kf = 1;
        while (kf > 1 && kf * unit * 4 / 3 > ww) kf--;
        kc = (wh + unit - 1) / unit;
        if (kc * unit * 4 / 3 > ww) kc = kf;   /* columns never cut */
        if (kc < kf) kc = kf;
        if (vs == OB_HEIGHT_INTEGER) k = kf;
        else if (vs == OB_HEIGHT_OVERSCAN) k = kc;
        else {
            n = in->auto_crop_src_rows;
            if (n <= 0) n = (in->src_w == 320 || dar_h == 240) ? 6 : 10;
            k = (kc * unit - wh <= n * kc * (unit / dar_h)) ? kc : kf;
        }
        h = k * unit;
        w = h * 4 / 3;
    }
    out->canvas_w = w;
    out->canvas_h = h;
    out->canvas_x = (ww - w) / 2;
    out->canvas_y = (wh - h) / 2;
    out->src_w = in->src_w;
    out->src_h = src_h;
    /* 224 source rows map into 224/240 of dest height. Empty dest is window
     * letterbox, not texels. VGA (dar_h == src_h) fills the whole canvas. */
    out->blit_w = w;
    out->blit_h = h * src_h / dar_h;
    out->blit_x = out->canvas_x;
    out->blit_y = out->canvas_y + (h - out->blit_h) / 2;
}

void ob_view_par(const ob_view_out *v, int *num, int *den)
{
    /* (blit_w / src_w) / (blit_h / src_h) = blit_w * src_h : blit_h * src_w */
    int n = v->blit_w * v->src_h;
    int d = v->blit_h * v->src_w;
    int g;
    if (d == 0) { *num = 0; *den = 1; return; }
    g = gcd_pos(n, d);
    *num = n / g;
    *den = d / g;
}

void ob_view_from_host(const ob_host *h, ob_class cls, int src_w, int src_h,
                       int window_w, int window_h, ob_view_in *in)
{
    const ob_look *look = (cls == OB_CLASS_HIRES) ? &h->hires : &h->lores;
    in->src_w = src_w;
    in->src_h = src_h;
    in->dar_h = h->console_dar ? 240 : src_h;
    in->window_w = window_w;
    in->window_h = window_h;
    in->height = look->height;
    in->line_double = (cls == OB_CLASS_LORES && ob_mode_has_khz(look->mode) && look->khz31);
    in->auto_crop_src_rows = 0;
}
