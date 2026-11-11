/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors */
#include "season_floppy.h"

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#ifdef _WIN32
#include <direct.h>
#include <io.h>
#define MKDIR(p) _mkdir(p)
#else
#include <dirent.h>
#include <unistd.h>
#define MKDIR(p) mkdir(p, 0777)
#endif

static const char *const k_db[7] = {
    "KEY", "CAREER", "ATT", "CARTEAMS", "TEAMS", "SEASON", "SCHEDULE"
};

static int exists_path(const char *p)
{
    struct stat st;
    return p && p[0] && stat(p, &st) == 0;
}

static void join2(char *out, int size, const char *dir, const char *name)
{
    snprintf(out, (size_t)size, "%s/%s", dir, name);
}

static int copy_file(const char *from, const char *to)
{
    FILE *in, *out;
    char buf[4096];
    size_t n;
    in = fopen(from, "rb");
    if (!in) return -1;
    out = fopen(to, "wb");
    if (!out) { fclose(in); return -1; }
    while ((n = fread(buf, 1, sizeof buf, in)) > 0) {
        if (fwrite(buf, 1, n, out) != n) { fclose(in); fclose(out); return -1; }
    }
    fclose(in);
    fclose(out);
    return 0;
}

static int pinfo_entry(const char *path, int team, unsigned char *entry, int write, int zero_13, int zero_saved)
{
    FILE *f = fopen(path, write || zero_saved ? "r+b" : "rb");
    int ok;
    if (!f) return -1;
    ok = fseek(f, 0x20 + team * 30, SEEK_SET) == 0;
    if (ok) ok = write ? fwrite(entry, 1, 30, f) == 30 : fread(entry, 1, 30, f) == 30;
    if (ok && zero_13) {
        static const unsigned char z[2] = { 0, 0 };
        ok = fseek(f, 0x13, SEEK_SET) == 0 && fwrite(z, 1, 2, f) == 2;
    }
    if (ok && zero_saved) {
        static const unsigned char z[2] = { 0, 0 };
        ok = fseek(f, 4, SEEK_SET) == 0 && fwrite(z, 1, 2, f) == 2;
    }
    fclose(f);
    return ok ? 0 : -1;
}

static int write_game_set(const char *dir, const char *league)
{
    char path[512], buf[0x75];
    FILE *f;
    join2(path, (int)sizeof path, dir, "GAME.SET");
    memset(buf, 0, sizeof buf);
    buf[0] = 2;                             /* gamemode: regular season */
    snprintf(buf + 4, 13, "%s", league ? league : "");
    f = fopen(path, "wb");
    if (!f) return -1;
    if (fwrite(buf, 1, sizeof buf, f) != sizeof buf) { fclose(f); return -1; }
    return fclose(f) ? -1 : 0;
}

static int copy_db_pair(const char *from, const char *to, const char *stem, const char *nn)
{
    char src_nn[512], src_db[512], dst_nn[512], dst_db[512], leaf[32];
    const char *src;
    snprintf(leaf, sizeof leaf, "%s%s", stem, nn);
    join2(src_nn, (int)sizeof src_nn, from, leaf);
    join2(dst_nn, (int)sizeof dst_nn, to, leaf);
    snprintf(leaf, sizeof leaf, "%s.DB", stem);
    join2(src_db, (int)sizeof src_db, from, leaf);
    join2(dst_db, (int)sizeof dst_db, to, leaf);
    src = exists_path(src_nn) ? src_nn : (exists_path(src_db) ? src_db : NULL);
    if (!src) return -1;
    if (copy_file(src, dst_nn)) return -1;
    if (copy_file(src, dst_db)) return -1;  /* CopyLeagueFiles needs both .NN and .DB */
    return 0;
}

int season_pack_floppy(const char *from, const char *to, int team, const char *league, int touch_src)
{
    char nn[8], a[512], b[512], pid[512];
    unsigned char entry[30], tb = (unsigned char)team, dir13[13];
    FILE *f;
    int i;
    if (!from || !to || !league || !league[0] || team < 0 || team >= 26) return -1;
    snprintf(nn, sizeof nn, ".%02d", team);
    MKDIR(to);
    for (i = 0; i < 7; i++)
        if (copy_db_pair(from, to, k_db[i], nn)) return -1;
    join2(a, (int)sizeof a, from, "PINFO.DB");
    if (pinfo_entry(a, team, entry, 0, 0, 0)) return -1;
    if (entry[0x16] != 2) {
        uint32_t n = (uint32_t)entry[0x1A] | (uint32_t)entry[0x1B] << 8 | (uint32_t)entry[0x1C] << 16 |
                     (uint32_t)entry[0x1D] << 24;
        n++;
        entry[0x1A] = (unsigned char)n; entry[0x1B] = (unsigned char)(n >> 8);
        entry[0x1C] = (unsigned char)(n >> 16); entry[0x1D] = (unsigned char)(n >> 24);
    }
    entry[0x16] = 2;
    entry[0x18] |= 2;
    join2(b, (int)sizeof b, to, "PINFO.DB");
    if (copy_file(a, b) || pinfo_entry(b, team, entry, 1, 1, 1)) return -1;
    if (touch_src && pinfo_entry(a, team, entry, 1, 0, 0)) return -1;
    join2(a, (int)sizeof a, from, "GAME.SET");
    join2(b, (int)sizeof b, to, "GAME.SET");
    if (exists_path(a)) {
        if (copy_file(a, b)) return -1;
    } else if (write_game_set(to, league)) return -1; /* New League often never wrote one in the league folder */
    memset(dir13, 0, sizeof dir13);
    memcpy(dir13, league, strlen(league) < 12 ? strlen(league) : 12);
    join2(pid, (int)sizeof pid, to, "PLAYER.ID");
    f = fopen(pid, "wb");
    if (!f) return -1;
    i = fwrite(&tb, 1, 1, f) == 1 && fwrite(entry, 1, 11, f) == 11 && fwrite(dir13, 1, 13, f) == 13 &&
        fwrite(entry + 0x1A, 1, 4, f) == 4;
    if (fclose(f) || !i) return -1;
    return 0;
}

int season_floppy_ready(const char *dir, int team, const char *league)
{
    char path[512], nn[8], name[12], lg[16];
    unsigned char entry[30], tb = 0, saved[2];
    FILE *f;
    int i;
    if (!dir || !league || team < 0 || team >= 26) return 0;
    join2(path, (int)sizeof path, dir, "PLAYER.ID");
    f = fopen(path, "rb");
    if (!f) return 0;
    memset(name, 0, sizeof name);
    memset(lg, 0, sizeof lg);
    i = fread(&tb, 1, 1, f) == 1 && fread(name, 1, 11, f) == 11 && fread(lg, 1, 13, f) == 13;
    fclose(f);
    if (!i || tb != (unsigned char)team) return 0;
    if (strncmp(lg, league, strlen(league))) return 0;
    join2(path, (int)sizeof path, dir, "PINFO.DB");
    f = fopen(path, "rb");
    if (!f) return 0;
    i = fseek(f, 4, SEEK_SET) == 0 && fread(saved, 1, 2, f) == 2;
    if (i) i = fseek(f, 0x20 + team * 30, SEEK_SET) == 0 && fread(entry, 1, 30, f) == 30;
    fclose(f);
    if (!i || saved[0] || saved[1] || entry[0x16] != 2) return 0;
    join2(path, (int)sizeof path, dir, "GAME.SET");
    if (!exists_path(path)) return 0;
    snprintf(nn, sizeof nn, ".%02d", team);
    for (i = 0; i < 7; i++) {
        char leaf[32];
        snprintf(leaf, sizeof leaf, "%s%s", k_db[i], nn);
        join2(path, (int)sizeof path, dir, leaf);
        if (!exists_path(path)) return 0;
        snprintf(leaf, sizeof leaf, "%s.DB", k_db[i]);
        join2(path, (int)sizeof path, dir, leaf);
        if (!exists_path(path)) return 0;
    }
    return 1;
}

int season_install_floppy(const char *floppy, const char *root, char *league_out, int league_size)
{
    char path[512], dest[512], lg[16], leaf[256];
    unsigned char team = 0;
    FILE *f;
#ifdef _WIN32
    struct _finddata_t fi;
    intptr_t h;
    char spec[512];
#else
    DIR *d;
    struct dirent *e;
#endif
    if (!floppy || !root || !league_out || league_size < 16) return -1;
    join2(path, (int)sizeof path, floppy, "PLAYER.ID");
    f = fopen(path, "rb");
    if (!f) return -1;
    memset(lg, 0, sizeof lg);
    if (fread(&team, 1, 1, f) != 1 || fseek(f, 0xC, SEEK_SET) || fread(lg, 1, 13, f) != 13) { fclose(f); return -1; }
    fclose(f);
    if (!lg[0] || team > 25) return -1;
    snprintf(league_out, (size_t)league_size, "%s", lg);
    snprintf(dest, sizeof dest, "%s/%s", root, lg);
    MKDIR(dest);
#ifdef _WIN32
    snprintf(spec, sizeof spec, "%s/*", floppy);
    h = _findfirst(spec, &fi);
    if (h == -1) return -1;
    do {
        if (fi.name[0] == '.') continue;
        if (fi.attrib & _A_SUBDIR) continue;
        join2(path, (int)sizeof path, floppy, fi.name);
        join2(leaf, (int)sizeof leaf, dest, fi.name);
        if (copy_file(path, leaf)) { _findclose(h); return -1; }
    } while (_findnext(h, &fi) == 0);
    _findclose(h);
#else
    d = opendir(floppy);
    if (!d) return -1;
    while ((e = readdir(d))) {
        if (e->d_name[0] == '.') continue;
        join2(path, (int)sizeof path, floppy, e->d_name);
        join2(leaf, (int)sizeof leaf, dest, e->d_name);
        {
            struct stat st;
            if (stat(path, &st) == 0 && S_ISDIR(st.st_mode)) continue;
        }
        if (copy_file(path, leaf)) { closedir(d); return -1; }
    }
    closedir(d);
#endif
    /* leave PINFO +16h = 2 so File > Import Databases > Player still sees an export */
    return 0;
}

int season_mark_imported(const char *dir, int team)
{
    char path[512];
    unsigned char entry[30];
    if (!dir || team < 0 || team >= 26) return -1;
    join2(path, (int)sizeof path, dir, "PINFO.DB");
    if (pinfo_entry(path, team, entry, 0, 0, 0)) return -1;
    entry[0x16] = 1;
    return pinfo_entry(path, team, entry, 1, 0, 0);
}

int season_import_team(const char *from, const char *to, int team)
{
    char nn[8], a[512], b[512];
    unsigned char entry[30];
    int i;
    if (!from || !to || team < 0 || team >= 26) return -1;
    snprintf(nn, sizeof nn, ".%02d", team);
    for (i = 0; i < 7; i++)
        if (copy_db_pair(from, to, k_db[i], nn)) return -1;
    join2(a, (int)sizeof a, from, "PINFO.DB");
    join2(b, (int)sizeof b, to, "PINFO.DB");
    if (pinfo_entry(a, team, entry, 0, 0, 0)) return -1;
    if (pinfo_entry(b, team, entry, 1, 0, 0)) return -1;
    return season_mark_imported(to, team);
}

int season_player_id(const char *dir, int *team, unsigned *version)
{
    char path[512];
    unsigned char buf[29];
    FILE *f;
    if (!dir) return -1;
    join2(path, (int)sizeof path, dir, "PLAYER.ID");
    f = fopen(path, "rb");
    if (!f) return -1;
    if (fread(buf, 1, 29, f) != 29) { fclose(f); return -1; }
    fclose(f);
    if (buf[0] > 25) return -1;
    if (team) *team = buf[0];
    if (version)
        *version = (unsigned)buf[25] | (unsigned)buf[26] << 8 | (unsigned)buf[27] << 16 |
                   (unsigned)buf[28] << 24;
    return 0;
}

int season_next_game_pick(unsigned char *teams, int team, int guest, int mine)
{
    unsigned char *rec;
    if (!teams || team < 0 || team >= 26) return -1;
    rec = teams + team * 30;
    if (rec[0x17] != 1) return -1;
    if (guest) {
        if (mine >= 0 && mine < 26) {
            if (team != mine) return -1;
        } else if (rec[0x18] != 2)
            return -1;
    }
    rec[0x16] = 1;
    return 0;
}

int season_write_player_id(const char *dir, int team, const char *league)
{
    char path[512], pid[512];
    unsigned char entry[30], tb = (unsigned char)team, dir13[13];
    FILE *f;
    int ok;
    if (!dir || !league || !league[0] || team < 0 || team >= 26) return -1;
    join2(path, (int)sizeof path, dir, "PINFO.DB");
    if (pinfo_entry(path, team, entry, 0, 0, 0)) return -1;
    memset(dir13, 0, sizeof dir13);
    memcpy(dir13, league, strlen(league) < 12 ? strlen(league) : 12);
    join2(pid, (int)sizeof pid, dir, "PLAYER.ID");
    f = fopen(pid, "wb");
    if (!f) return -1;
    ok = fwrite(&tb, 1, 1, f) == 1 && fwrite(entry, 1, 11, f) == 11 && fwrite(dir13, 1, 13, f) == 13 &&
         fwrite(entry + 0x1A, 1, 4, f) == 4;
    if (fclose(f) || !ok) return -1;
    return 0;
}
