/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * Optional SDL_Renderer present. Built with OVERBAR_SDL. Handheld: fullscreen
 * KMSDRM, vsync, GLES2 renderer hint, never SDL_WINDOW_OPENGL.
 */
#include "overbar/overbar.h"

#ifdef OVERBAR_SDL
#include <SDL.h>
#include <string.h>

int ob_present_sdl_open(ob_present_sdl *p, const char *title, ob_host *h, int src_w, int src_h)
{
    Uint32 flags = SDL_WINDOW_RESIZABLE;
    Uint32 rflags = SDL_RENDERER_ACCELERATED;
    int ww = 960, wh = 720;
    SDL_RendererInfo info;
    int gles = 0;
    if (!p || !h || src_w < 1 || src_h < 1) return 0;
    memset(p, 0, sizeof *p);
    ob_present_apply_hints(h->profile);
    if (h->profile == OB_PROFILE_HANDHELD) {
        flags = SDL_WINDOW_FULLSCREEN_DESKTOP;
        ww = 640;
        wh = 480;
        if (h->vsync) rflags |= SDL_RENDERER_PRESENTVSYNC;
    }
    p->window = SDL_CreateWindow(title ? title : "Overbar",
                                 SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,
                                 ww, wh, flags);
    if (!p->window) return 0;
    p->renderer = SDL_CreateRenderer((SDL_Window *)p->window, -1, rflags);
    if (!p->renderer)
        p->renderer = SDL_CreateRenderer((SDL_Window *)p->window, -1, SDL_RENDERER_SOFTWARE);
    if (!p->renderer) {
        SDL_DestroyWindow((SDL_Window *)p->window);
        p->window = NULL;
        return 0;
    }
    if (SDL_GetRendererInfo((SDL_Renderer *)p->renderer, &info) == 0 && info.name)
        gles = strstr(info.name, "opengles") != NULL || strstr(info.name, "gles") != NULL;
    ob_host_set_present(h, gles, 0);
    p->texture = SDL_CreateTexture((SDL_Renderer *)p->renderer, SDL_PIXELFORMAT_ARGB8888,
                                   SDL_TEXTUREACCESS_STREAMING, src_w, src_h);
    if (!p->texture) {
        ob_present_sdl_close(p);
        return 0;
    }
    p->tex_w = src_w;
    p->tex_h = src_h;
    return 1;
}

void ob_present_sdl_frame(ob_present_sdl *p, ob_host *h, const uint32_t *px, int src_w, int src_h)
{
    SDL_Renderer *ren;
    int ww, wh, x, y, w, ht;
    ob_view_in in;
    ob_view_out out;
    SDL_Rect dst;
    if (!p || !p->renderer || !p->texture || !px || !h) return;
    ren = (SDL_Renderer *)p->renderer;
    if (src_w != p->tex_w || src_h != p->tex_h) {
        SDL_DestroyTexture((SDL_Texture *)p->texture);
        p->texture = SDL_CreateTexture(ren, SDL_PIXELFORMAT_ARGB8888,
                                       SDL_TEXTUREACCESS_STREAMING, src_w, src_h);
        p->tex_w = src_w;
        p->tex_h = src_h;
        if (!p->texture) return;
    }
    SDL_UpdateTexture((SDL_Texture *)p->texture, NULL, px, src_w * (int)sizeof(uint32_t));
    SDL_GetRendererOutputSize(ren, &ww, &wh);
    ob_view_from_host(h, h->has_hires ? h->video_class : OB_CLASS_LORES,
                      src_w, src_h, ww, wh, &in);
    ob_view(&in, &out);
    x = out.blit_x;
    y = out.blit_y;
    w = out.blit_w;
    ht = out.blit_h;
    dst.x = x;
    dst.y = y;
    dst.w = w;
    dst.h = ht;
    SDL_SetRenderDrawColor(ren, 0, 0, 0, 255);
    SDL_RenderClear(ren);
    SDL_RenderCopy(ren, (SDL_Texture *)p->texture, NULL, &dst);
    SDL_RenderPresent(ren);
}

void ob_present_sdl_close(ob_present_sdl *p)
{
    if (!p) return;
    if (p->texture) SDL_DestroyTexture((SDL_Texture *)p->texture);
    if (p->renderer) SDL_DestroyRenderer((SDL_Renderer *)p->renderer);
    if (p->window) SDL_DestroyWindow((SDL_Window *)p->window);
    memset(p, 0, sizeof *p);
}
#endif
