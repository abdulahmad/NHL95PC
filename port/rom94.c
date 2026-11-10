/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * The NHL Hockey '94 Genesis ROM's stars, arrows and team colours (port/rom94.h).
 */
#include "rom94.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifdef _WIN32
#include <windows.h>
#else
#include <dirent.h>
#endif

#define ROM94_SIZE 0x100000
#define ROM94_CHECKSUM 0x5512
#define ROM94_SPRITES 0x5DE7A
#define ROM94_ICERINK 0x5605A
#define ROM94_TEAMLIST 0x30E

static rom93 g94;
static int g94_state;           /* 0 not looked for, 1 loaded, -1 none */

static uint32_t be16(const uint8_t *p) { return (uint32_t)p[0] << 8 | p[1]; }
static uint32_t be32(const uint8_t *p) { return (uint32_t)p[0] << 24 | (uint32_t)p[1] << 16 | (uint32_t)p[2] << 8 | p[3]; }
static uint32_t cram(uint32_t c)
{
    uint32_t r = (c >> 1 & 7) * 36, g = (c >> 5 & 7) * 36, b = (c >> 9 & 7) * 36;
    return r << 16 | g << 8 | b;
}

static int identify(uint8_t *d)
{
    char name[15];
    uint32_t sum = 0, i;
    memcpy(name, d + 0x150, 14);
    name[14] = 0;
    for (i = 0; i < 14; i++) if (name[i] >= 'a' && name[i] <= 'z') name[i] -= 32;
    if (strcmp(name, "NHL HOCKEY '94")) return -1;
    if (be16(d + 0x18E) != ROM94_CHECKSUM) return -1;
    for (i = 0x200; i < ROM94_SIZE; i += 2) sum += be16(d + i);
    if ((sum & 0xFFFF) != ROM94_CHECKSUM) return -1;              /* a changed ROM: its addresses can't be trusted */
    if (ROM94_SPRITES + be32(d + ROM94_SPRITES + 4) + 4 > ROM94_SIZE) return -1;
    return 0;
}

static int try_file(const char *path)
{
    FILE *f = fopen(path, "rb");
    uint8_t *d;
    long n;
    if (!f) return -1;
    if (fseek(f, 0, SEEK_END) || (n = ftell(f)) != ROM94_SIZE || fseek(f, 0, SEEK_SET)) { fclose(f); return -1; }
    d = (uint8_t *)malloc(ROM94_SIZE);
    if (!d || fread(d, 1, ROM94_SIZE, f) != ROM94_SIZE || identify(d)) { free(d); fclose(f); return -1; }
    fclose(f);
    memset(&g94, 0, sizeof g94);
    g94.data = d;
    g94.size = ROM94_SIZE;
    g94.sprites = ROM94_SPRITES;
    g94.icerink = ROM94_ICERINK;
    g94.teamlist = ROM94_TEAMLIST;
    fprintf(stderr, "NHL 94 ROM: %s (stars, arrows, fight colours)\n", path);
    return 0;
}

static int try_dir(const char *dir)
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
        if (fd.nFileSizeHigh || fd.nFileSizeLow != ROM94_SIZE) continue;
        snprintf(p, sizeof p, "%s\\%s", dir, fd.cFileName);
        if (!try_file(p)) { FindClose(h); return 0; }
    } while (FindNextFileA(h, &fd));
    FindClose(h);
#else
    DIR *d = opendir(dir);
    struct dirent *e;
    if (!d) return -1;
    while ((e = readdir(d)) != NULL) {
        if (e->d_name[0] == '.') continue;
        snprintf(p, sizeof p, "%s/%s", dir, e->d_name);
        if (!try_file(p)) { closedir(d); return 0; }
    }
    closedir(d);
#endif
    return -1;
}

int rom94_load(void)
{
    const char *env;
    if (g94_state) return g94_state > 0 ? 0 : -1;
    env = getenv("NHL94_ROM_DIR");
    g94_state = (env && *env && !try_dir(env)) || !try_dir(".") ? 1 : -1;
    if (g94_state < 0) fprintf(stderr, "NHL 94 ROM: none found (95 PC's own stars; fights in 93's colours)\n");
    return g94_state > 0 ? 0 : -1;
}

const rom93 *rom94_sprites(void)
{
    return rom94_load() ? NULL : &g94;
}

void rom94_rink_palette(uint32_t rgb[32])
{
    uint32_t at, i;
    memset(rgb, 0, 32 * sizeof *rgb);
    if (rom94_load()) return;
    at = ROM94_ICERINK + be32(g94.data + ROM94_ICERINK);
    if (at + 64 > g94.size) return;
    for (i = 0; i < 32; i++) rgb[i] = cram(be16(g94.data + at + 2 * i));
}

int rom94_team_colours(const char *abbrev, int home, uint32_t rgb[16])
{
    /* 95 PC's letters that 94 spells another way */
    static const char *const alias[][2] = { { "ana", "ANH" }, { "ott", "OTW" }, { "min", "DAL" }, { "dal", "DAL" } };
    char want[8];
    int t, i;
    if (rom94_load() || !abbrev) return -1;
    snprintf(want, sizeof want, "%s", abbrev);
    for (i = 0; i < (int)(sizeof alias / sizeof alias[0]); i++)
        if (!strcmp(abbrev, alias[i][0])) snprintf(want, sizeof want, "%s", alias[i][1]);
    for (i = 0; want[i]; i++) if (want[i] >= 'a' && want[i] <= 'z') want[i] -= 32;
    for (t = 0; t < F94_NTEAMS; t++) {
        uint32_t rec = be32(g94.data + ROM94_TEAMLIST + 4 * (uint32_t)t), name, pal, len;
        const uint8_t *s;
        if (rec + 8 > g94.size) continue;
        /* Teamname: the city (a word length, the letters, even), then the abbreviation the same way */
        name = rec + be16(g94.data + rec + 4);
        if (name + 2 > g94.size) continue;
        len = be16(g94.data + name);
        name += len;
        if (name + 2 > g94.size) continue;
        len = be16(g94.data + name);
        if (len < 3 || name + len > g94.size) continue;
        s = g94.data + name + 2;
        if (strlen(want) != strnlen((const char *)s, len - 2) || memcmp(s, want, strlen(want))) continue;
        pal = rec + be16(g94.data + rec + 2) + (home ? 0 : 32);
        if (pal + 32 > g94.size) return -1;
        for (i = 0; i < 16; i++) rgb[i] = cram(be16(g94.data + pal + 2 * i));
        return 0;
    }
    return -1;
}
