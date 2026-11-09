/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * port/fight/rom93.c against real NHLPA 93 ROMs (none in git): sh port/fight_test.sh <folder with the ROMs>.
 * Each ROM found is identified, and the glove, fight and injury frames, the team colours and the punch sample must
 * come out the same from every release. NHL93_SHEET=file.ppm also writes the frames of the first ROM as a picture.
 */
#include "rom93.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int fails;
#define CHECK(c, ...) do { if (!(c)) { fails++; fprintf(stderr, "FAIL %s:%d: ", __FILE__, __LINE__); fprintf(stderr, __VA_ARGS__); fputc('\n', stderr); } } while (0)

static const int groups[][2] = { { F93_GLOVES, 1 }, { F93_FIGHT, 17 }, { F93_FINJURY, 6 }, { F93_INJURY1, 12 } };

static uint64_t hash(const void *p, size_t n, uint64_t h)
{
    const uint8_t *b = (const uint8_t *)p;
    while (n--) { h ^= *b++; h *= 0x100000001B3ull; }
    return h;
}

static uint64_t frames_hash(const rom93 *r, int *nf, int *blood)
{
    uint64_t h = 0xCBF29CE484222325ull;
    int g, k;
    *nf = 0; *blood = 0;
    for (g = 0; g < 4; g++)
        for (k = 0; k < groups[g][1]; k++) {
            f93_frame f;
            int n = groups[g][0] + k, i, lines[4] = { 0 };
            if (f93_decode(r, n, &f)) { CHECK(0, "frame %d does not decode", n); continue; }
            CHECK(f.w > 0 && f.h > 0 && f.w <= 128 && f.h <= 64, "frame %d is %dx%d", n, f.w, f.h);
            for (i = 0; i < f.w * f.h; i++) if (f.pix[i]) lines[f.pix[i] >> 4]++;
            CHECK(lines[2] > 0, "frame %d has no team colours", n);
            if (n >= F93_FINJURY && lines[0] + lines[1]) (*blood)++;
            h = hash(&f.x0, sizeof f.x0, h); h = hash(&f.y0, sizeof f.y0, h);
            h = hash(&f.w, sizeof f.w, h); h = hash(&f.h, sizeof f.h, h);
            h = hash(f.pix, (size_t)f.w * f.h, h);
            (*nf)++;
            f93_frame_free(&f);
        }
    return h;
}

static void sheet(const rom93 *r, const char *path)
{
    enum { C = 64, COLS = 9 };
    int g, k, i = 0, rows = (36 + COLS - 1) / COLS, x, y;
    uint32_t pal[64];
    uint8_t *img = (uint8_t *)calloc((size_t)COLS * C * rows * C * 3, 1);
    FILE *f;
    f93_palette(r, 0, 1, pal);                  /* Boston, home */
    if (getenv("NHL93_PC95")) f93_pc95_colours(pal);
    for (g = 0; g < 4; g++)
        for (k = 0; k < groups[g][1]; k++, i++) {
            f93_frame fr;
            int ox = (i % COLS) * C + C / 2, oy = (i / COLS) * C + C * 3 / 4;
            if (f93_decode(r, groups[g][0] + k, &fr)) continue;
            for (y = 0; y < fr.h; y++)
                for (x = 0; x < fr.w; x++) {
                    int v = fr.pix[y * fr.w + x], px = ox + fr.x0 + x, py = oy + fr.y0 + y;
                    uint8_t *o;
                    if (!v || px < (i % COLS) * C || px >= (i % COLS + 1) * C || py < (i / COLS) * C || py >= (i / COLS + 1) * C) continue;
                    o = img + ((size_t)py * COLS * C + px) * 3;
                    o[0] = (uint8_t)(pal[v] >> 16); o[1] = (uint8_t)(pal[v] >> 8); o[2] = (uint8_t)pal[v];
                }
            f93_frame_free(&fr);
        }
    f = fopen(path, "wb");
    if (f) { fprintf(f, "P6\n%d %d\n255\n", COLS * C, rows * C); fwrite(img, 3, (size_t)COLS * C * rows * C, f); fclose(f); }
    free(img);
}

int main(int argc, char **argv)
{
    const char *dirs[2] = { argc > 1 ? argv[1] : ".", NULL };
    static const char *const files[] = { "nhlpa93retail.bin", "nhlpa93retailRevA.bin", "nhlpa93retailRevB.bin" };
    uint64_t first = 0, pal_first = 0, punch_first = 0;
    int n, found = 0;
    char path[1024];
    rom93 r;
    /* rom93_find: any name in the folder */
    if (rom93_find(dirs, &r, path, sizeof path)) { printf("no NHLPA 93 ROM in %s: skipped\n", dirs[0]); return 0; }
    printf("found %s (Rev %c)\n", path, "0AB"[r.rev]);
    rom93_free(&r);
    /* not a ROM: refused */
    {
        uint8_t *junk = (uint8_t *)calloc(0x80000, 1);
        CHECK(rom93_identify(junk, 0x80000, &r) == -1, "a blank file is taken for a ROM");
        free(junk);
    }
    for (n = 0; n < 3; n++) {
        FILE *f;
        uint8_t *d;
        int nf, blood, t;
        uint64_t h, ph = 0xCBF29CE484222325ull;
        size_t len;
        const uint8_t *pcm;
        uint32_t pal[64];
        snprintf(path, sizeof path, "%s/%s", dirs[0], files[n]);
        if (!(f = fopen(path, "rb"))) continue;
        d = (uint8_t *)malloc(0x80000);
        if (fread(d, 1, 0x80000, f) != 0x80000) { fclose(f); free(d); continue; }
        fclose(f);
        if (rom93_identify(d, 0x80000, &r)) { CHECK(0, "%s is not identified", files[n]); free(d); continue; }
        CHECK(r.rev == n, "%s identified as Rev %d", files[n], r.rev);
        CHECK(rom93_nframes(&r) >= 650, "%s has %d frames", files[n], rom93_nframes(&r));
        h = frames_hash(&r, &nf, &blood);
        for (t = 0; t < F93_NTEAMS; t++) {
            f93_palette(&r, t, 1, pal); ph = hash(pal, sizeof pal, ph);
            f93_palette(&r, t, 0, pal); ph = hash(pal, sizeof pal, ph);
        }
        pcm = rom93_punch(&r, &len);
        CHECK(len == 1362, "%s: the punch is %u bytes", files[n], (unsigned)len);
        printf("Rev %c: %d frames (%d with blood), frames %016llx, colours %016llx, punch %u bytes\n", "0AB"[n], nf, blood,
               (unsigned long long)h, (unsigned long long)ph, (unsigned)len);
        CHECK(nf == 36, "%d frames", nf);
        CHECK(blood >= 12, "only %d injury frames with blood", blood);
        if (!found) { first = h; pal_first = ph; punch_first = hash(pcm, len, 0xCBF29CE484222325ull); if (getenv("NHL93_SHEET")) sheet(&r, getenv("NHL93_SHEET")); }
        else {
            CHECK(h == first, "Rev %c frames differ from the first ROM's", "0AB"[n]);
            CHECK(ph == pal_first, "Rev %c colours differ", "0AB"[n]);
            CHECK(hash(pcm, len, 0xCBF29CE484222325ull) == punch_first, "Rev %c punch differs", "0AB"[n]);
        }
        found++;
        rom93_free(&r);
    }
    printf("%d ROMs, %s\n", found, fails ? "FAILED" : "OK");
    return fails ? 1 : 0;
}
