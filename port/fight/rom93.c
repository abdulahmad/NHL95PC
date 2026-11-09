/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * The NHLPA 93 ROM's fight pieces (port/fight/rom93.h). Formats (NHLPA93Genesis docs/file-formats.md, src/video93.asm
 * addframe2):
 *   - Sprites.anim: $FFFFFFFF, a long offset to the frame offset table, then 4 bpp 8x8 tiles from +$A. The table has
 *     a word per frame, each the offset (from the table) of the frame's first 8-byte entry; Rev 0 and A start it with
 *     a 0 for frame 0, Rev B leaves frame 0 out. An entry: x, y (signed words), tile, then attribute bits 15-11
 *     (priority, palette line, vflip, hflip) and the VDP size code (bits 3-2 width - 1, bits 1-0 height - 1, in tiles;
 *     the tiles of a sprite run down each column first).
 *   - IceRink.map.jim: a long offset to 32 colours, palette lines 0 and 1.
 *   - A team record: a word at +2 with the offset of its 32 home and 32 visitor colours (setplayercolors).
 *   - Colours are Genesis CRAM words, 0000 BBB0 GGG0 RRR0.
 */
#include "rom93.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifdef _WIN32
#include <windows.h>
#else
#include <dirent.h>
#endif

#define ROM_SIZE 0x80000

static uint32_t be16(const uint8_t *p) { return (uint32_t)p[0] << 8 | p[1]; }
static uint32_t be32(const uint8_t *p) { return (uint32_t)p[0] << 24 | (uint32_t)p[1] << 16 | (uint32_t)p[2] << 8 | p[3]; }

/* the three releases: the header's checksum word, and where the pieces are */
static const struct {
    uint16_t checksum;
    uint32_t sprites, icerink, teamlist, punch;
} known[3] = {
    { 0x2799, 0x3A378, 0x33864, 0x314, 0x26F9C },       /* Rev 0 (v1.0, 1992.JUL) */
    { 0xFA57, 0x3A3A6, 0x33892, 0x314, 0x26FCA },       /* Rev A (v1.1, 1992.OCT): from $16E52 on, $2E higher */
    { 0x86DB, 0x3A502, 0x33A88, 0x30E, 0x26F90 },       /* Rev B (v1.2, 1993.FEB) */
};

static const uint8_t punch_start[8] = { 0x80, 0x9E, 0x95, 0xA0, 0x67, 0x80, 0x92, 0xE9 };

int rom93_identify(uint8_t *data, size_t size, rom93 *out)
{
    uint32_t sum = 0, i, k;
    char name[17];
    if (!data || size != ROM_SIZE || !out) return -1;
    memcpy(name, data + 0x150, 16);
    name[16] = 0;
    for (i = 0; i < 16; i++) if (name[i] >= 'a' && name[i] <= 'z') name[i] -= 32;
    if (strncmp(name, "NHLPA HOCKEY '93", 16)) return -1;
    for (i = 0x200; i < size; i += 2) sum += be16(data + i);
    if ((sum & 0xFFFF) != be16(data + 0x18E)) return -1;          /* a changed ROM: its addresses can't be trusted */
    for (k = 0; k < 3; k++) {
        if (known[k].checksum != be16(data + 0x18E)) continue;
        if (be32(data + known[k].sprites) != 0xFFFFFFFFu) return -1;
        if (memcmp(data + known[k].punch, punch_start, sizeof punch_start)) return -1;
        memset(out, 0, sizeof *out);
        out->data = data;
        out->size = size;
        out->rev = (int)k;
        out->sprites = known[k].sprites;
        out->icerink = known[k].icerink;
        out->teamlist = known[k].teamlist;
        out->punch = known[k].punch;
        return 0;
    }
    return -1;
}

void rom93_free(rom93 *r)
{
    if (!r) return;
    free(r->data);
    memset(r, 0, sizeof *r);
}

static int try_file(const char *path, rom93 *out)
{
    FILE *f = fopen(path, "rb");
    uint8_t *d;
    long n;
    if (!f) return -1;
    if (fseek(f, 0, SEEK_END) || (n = ftell(f)) != ROM_SIZE || fseek(f, 0, SEEK_SET)) { fclose(f); return -1; }
    d = (uint8_t *)malloc(ROM_SIZE);
    if (!d || fread(d, 1, ROM_SIZE, f) != ROM_SIZE) { free(d); fclose(f); return -1; }
    fclose(f);
    if (rom93_identify(d, ROM_SIZE, out)) { free(d); return -1; }
    return 0;
}

static int try_dir(const char *dir, rom93 *out, char *path, size_t pathsize)
{
    char p[1024];
#ifdef _WIN32
    WIN32_FIND_DATAA fd;
    HANDLE h;
    snprintf(p, sizeof p, "%s\\*", dir);
    h = FindFirstFileA(p, &fd);
    if (h == INVALID_HANDLE_VALUE) return -1;
    do {
        if (fd.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) continue;
        if (fd.nFileSizeHigh || fd.nFileSizeLow != ROM_SIZE) continue;
        snprintf(p, sizeof p, "%s\\%s", dir, fd.cFileName);
        if (!try_file(p, out)) { FindClose(h); if (path) snprintf(path, pathsize, "%s", p); return 0; }
    } while (FindNextFileA(h, &fd));
    FindClose(h);
#else
    DIR *d = opendir(dir);
    struct dirent *e;
    if (!d) return -1;
    while ((e = readdir(d)) != NULL) {
        if (e->d_name[0] == '.') continue;
        snprintf(p, sizeof p, "%s/%s", dir, e->d_name);
        if (!try_file(p, out)) { closedir(d); if (path) snprintf(path, pathsize, "%s", p); return 0; }
    }
    closedir(d);
#endif
    return -1;
}

int rom93_find(const char *const *dirs, rom93 *out, char *path, size_t pathsize)
{
    for (; dirs && *dirs; dirs++)
        if (**dirs && !try_dir(*dirs, out, path, pathsize)) return 0;
    return -1;
}

/* ---- frames ---- */
static const uint8_t *table(const rom93 *r, uint32_t *tsize, int *lead)
{
    const uint8_t *s = r->data + r->sprites;
    uint32_t off = be32(s + 4);
    const uint8_t *t;
    if (r->sprites + off + 4 > r->size) return NULL;
    t = s + off;
    *lead = be16(t) == 0;                       /* Rev 0 and A: an entry for frame 0 first */
    *tsize = *lead ? be16(t + 2) : be16(t);     /* the first real offset is the table's size */
    return t;
}

int rom93_nframes(const rom93 *r)
{
    uint32_t ts;
    int lead;
    if (!r || !r->data || !table(r, &ts, &lead)) return 0;
    return (int)(ts / 2) - (lead ? 1 : 0);      /* frames 1 up; the table ends with the end offset */
}

void f93_frame_free(f93_frame *f)
{
    if (!f) return;
    free(f->pix);
    memset(f, 0, sizeof *f);
}

int f93_decode(const rom93 *r, int n, f93_frame *out)
{
    uint32_t ts, a, b, e;
    int lead, minx = 1 << 20, miny = 1 << 20, maxx = -(1 << 20), maxy = -(1 << 20), pass;
    const uint8_t *t, *tiles;
    memset(out, 0, sizeof *out);
    if (!r || !r->data || (t = table(r, &ts, &lead)) == NULL) return -1;
    if (n < 1 || n >= rom93_nframes(r)) return -1;
    a = be16(t + 2 * (n - (lead ? 0 : 1)));
    b = be16(t + 2 * (n + 1 - (lead ? 0 : 1)));
    if (b < a || (b - a) % 8 || (size_t)(t - r->data) + b > r->size) return -1;
    tiles = r->data + r->sprites + 0xA;
    for (pass = 0; pass < 2; pass++) {
        for (e = b; e > a; e -= 8) {            /* the first entry is in front: draw from the last */
            const uint8_t *p = t + e - 8;
            int x = (int16_t)be16(p), y = (int16_t)be16(p + 2), tile = (int)be16(p + 4), at = (int)be16(p + 6);
            int w = ((at >> 2) & 3) + 1, h = (at & 3) + 1, line = (at >> 13) & 3, hf = at & 0x800, vf = at & 0x1000;
            int cx, cy, xx, yy;
            if (pass == 0) {
                if (x < minx) minx = x;
                if (y < miny) miny = y;
                if (x + w * 8 > maxx) maxx = x + w * 8;
                if (y + h * 8 > maxy) maxy = y + h * 8;
                continue;
            }
            if (r->sprites + 0xA + (uint32_t)(tile + w * h) * 32 > r->size) return f93_frame_free(out), -1;
            for (cx = 0; cx < w; cx++)
                for (cy = 0; cy < h; cy++) {
                    const uint8_t *tp = tiles + (size_t)(tile + cx * h + cy) * 32;
                    for (yy = 0; yy < 8; yy++)
                        for (xx = 0; xx < 8; xx++) {
                            int c = tp[yy * 4 + xx / 2], dx = cx * 8 + xx, dy = cy * 8 + yy;
                            c = xx & 1 ? c & 15 : c >> 4;
                            if (!c) continue;
                            if (hf) dx = w * 8 - 1 - dx;
                            if (vf) dy = h * 8 - 1 - dy;
                            out->pix[(y + dy - out->y0) * out->w + (x + dx - out->x0)] = (uint8_t)(line * 16 + c);
                        }
                }
        }
        if (pass == 0) {
            if (b == a) return 0;               /* an empty frame */
            out->x0 = minx; out->y0 = miny;
            out->w = maxx - minx; out->h = maxy - miny;
            out->pix = (uint8_t *)calloc((size_t)out->w * out->h, 1);
            if (!out->pix) return -1;
        }
    }
    return 0;
}

/* ---- colours ---- */
static uint32_t cram_rgb(uint32_t w)
{
    uint32_t r = (w >> 1) & 7, g = (w >> 5) & 7, b = (w >> 9) & 7;
    r = r * 255 / 7; g = g * 255 / 7; b = b * 255 / 7;
    return r << 16 | g << 8 | b;
}

void f93_palette(const rom93 *r, int team, int home, uint32_t rgb[64])
{
    const uint8_t *ice, *rec;
    uint32_t i, at;
    memset(rgb, 0, 64 * sizeof *rgb);
    if (!r || !r->data) return;
    ice = r->data + r->icerink;
    at = r->icerink + be32(ice);
    if (at + 64 <= r->size)
        for (i = 0; i < 32; i++) rgb[i] = cram_rgb(be16(r->data + at + 2 * i));
    if (team < 0 || team >= F93_NTEAMS) team = 0;
    at = be32(r->data + r->teamlist + 4 * (uint32_t)team);
    if (at + 4 > r->size) return;
    rec = r->data + at;
    at += be16(rec + 2) + (home ? 0 : 32);
    if (at + 32 > r->size) return;
    for (i = 0; i < 16; i++) rgb[32 + i] = rgb[48 + i] = cram_rgb(be16(r->data + at + 2 * i));
}

const char *f93_team_abbrev(int team)
{
    static const char *const names[F93_NTEAMS] = {
        "BOS", "BUF", "CGY", "CHI", "DET", "EDM", "HFD", "NYI", "LA", "MIN", "MTL", "NJ", "NYR",
        "OTT", "PHI", "PIT", "QUE", "SJ", "STL", "TB", "TOR", "VAN", "WSH", "WPG", "ASE", "ASW"
    };
    return team >= 0 && team < F93_NTEAMS ? names[team] : "";
}

void f93_pc95_colours(uint32_t rgb[64])
{
    int line;
    if (!rgb) return;
    rgb[F93_EYE] = 0x60381C;
    for (line = 2; line < 4; line++) {
        rgb[line * 16 + 1] = 0x004080;
        rgb[line * 16 + 6] = 0xDC9468;
        rgb[line * 16 + 7] = 0xC8845C;
        rgb[line * 16 + 14] = 0xA06060;
        rgb[line * 16 + 15] = 0x40A0E0;
    }
}

static int is_skin(int v) { return v >= 32 && ((v & 15) == 6 || (v & 15) == 7); }

void f93_pc95_frame(f93_frame *f)
{
    int x, y;
    if (!f || !f->pix) return;
    for (y = 0; y < f->h; y++)
        for (x = 1; x + 1 < f->w; x++) {
            uint8_t *p = f->pix + y * f->w + x;
            if (p[0] >= 32 && (p[0] & 15) == 13 && is_skin(p[-1]) && is_skin(p[1])) p[0] = F93_EYE;
        }
}

const uint8_t *rom93_punch(const rom93 *r, size_t *len)
{
    size_t n = 0;
    const uint8_t *p;
    if (!r || !r->data) { if (len) *len = 0; return NULL; }
    p = r->data + r->punch;
    while (r->punch + n < r->size && p[n]) n++;
    if (len) *len = n;
    return p;
}
