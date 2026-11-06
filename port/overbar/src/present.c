/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * Present backend pick and a software dest-rect blit. Handheld / PortMaster /
 * KMSDRM use SDL_Renderer (GLES2 if the driver offers it). Desktop OpenGL is
 * never required and is never chosen on a handheld.
 */
#ifndef _WIN32
#define _POSIX_C_SOURCE 200112L
#endif
#include "overbar/overbar.h"

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#if !defined(_WIN32) && !defined(__APPLE__)
static int setenv_if_unset(const char *k, const char *v)
{
    if (getenv(k) && getenv(k)[0]) return 0;
    return setenv(k, v, 0);
}
#endif

ob_present_backend ob_present_pick(ob_profile profile, int have_gles2, int have_desktop_gl)
{
    if (profile == OB_PROFILE_HANDHELD) {
        /* RG35XX / muOS: KMSDRM + Mali-G31 GLES. No X11, no desktop GL, no gl4es. */
        (void)have_desktop_gl;
        return have_gles2 ? OB_PRESENT_GLES2 : OB_PRESENT_SDL;
    }
    if (have_desktop_gl) return OB_PRESENT_GL;
    if (have_gles2) return OB_PRESENT_GLES2;
    return OB_PRESENT_SDL;
}

int ob_look_supported(ob_scale_mode mode, ob_present_backend backend)
{
    switch (mode) {
    case OB_MODE_CRT:
    case OB_MODE_MISTER:
    case OB_MODE_RETROARCH:
        return backend == OB_PRESENT_GLES2 || backend == OB_PRESENT_GL;
    default:
        return 1;
    }
}

const char *ob_look_fallback_note(ob_scale_mode mode, ob_present_backend backend)
{
    if (ob_look_supported(mode, backend)) return NULL;
    return "fell back to Sharp (needs GLES)";
}

void ob_present_apply_hints(ob_profile profile)
{
    if (profile != OB_PROFILE_HANDHELD) return;
#if defined(_WIN32) || defined(__APPLE__)
    /* KMSDRM / GLES2 hints are PortMaster/muOS. On Windows they make SDL
     * LoadLibrary a GLES2 DLL (wrong bitness → STATUS_INVALID_IMAGE_FORMAT). */
    return;
#else
    setenv_if_unset("OVERBAR_HANDHELD", "1");
    /* SDL_Renderer on GLES2. Do not set SDL_VIDEODRIVER: the CFW already picks kmsdrm. */
    setenv_if_unset("SDL_RENDER_DRIVER", "opengles2");
    setenv_if_unset("SDL_OPENGL_ES_DRIVER", "1");
#endif
}

void ob_present_soft(const uint32_t *src, int src_w, int src_h,
                     uint32_t *dst, int dst_w, int dst_h, int dst_pitch,
                     const ob_view_out *view)
{
    int y, x, vx, vy, vw, vh;
    if (!src || !dst || !view || src_w < 1 || src_h < 1 || dst_w < 1 || dst_h < 1) return;
    if (dst_pitch < dst_w) dst_pitch = dst_w;
    vx = view->blit_x;
    vy = view->blit_y;
    vw = view->blit_w;
    vh = view->blit_h;
    if (vw < 1 || vh < 1) return;
    for (y = 0; y < vh; y++) {
        int sy = y * src_h / vh;
        uint32_t *row;
        int dy = vy + y;
        if (dy < 0 || dy >= dst_h) continue;
        if (sy < 0) sy = 0;
        if (sy >= src_h) sy = src_h - 1;
        row = dst + dy * dst_pitch;
        for (x = 0; x < vw; x++) {
            int sx = x * src_w / vw;
            int dx = vx + x;
            if (dx < 0 || dx >= dst_w) continue;
            if (sx < 0) sx = 0;
            if (sx >= src_w) sx = src_w - 1;
            row[dx] = src[sy * src_w + sx];
        }
    }
}
