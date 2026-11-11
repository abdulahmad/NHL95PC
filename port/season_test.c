/* Headless: the floppy Import Databases > Player reads, and installing it as the guest league. */
#include "season_floppy.h"

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#ifdef _WIN32
#include <direct.h>
#define MKDIR(p) _mkdir(p)
#else
#include <sys/stat.h>
#define MKDIR(p) mkdir(p, 0777)
#endif

static int fails;
#define CHECK(c) do { if (!(c)) { printf("FAIL %s:%d %s\n", __FILE__, __LINE__, #c); fails++; } } while (0)

static void write_bytes(const char *path, const void *data, size_t n)
{
    FILE *f = fopen(path, "wb");
    CHECK(f && fwrite(data, 1, n, f) == n);
    if (f) fclose(f);
}

static int file_size(const char *path)
{
    FILE *f = fopen(path, "rb");
    long n;
    if (!f) return -1;
    fseek(f, 0, SEEK_END);
    n = ftell(f);
    fclose(f);
    return (int)n;
}

int main(void)
{
    char root[] = "build/season_test_root";
    char league[512], floppy[512], srcdb[512], pinfo[512], dest[512];
    unsigned char tab[0x20 + 26 * 30], entry[30], saved[2], pid[29];
    FILE *f;
    int i;

    MKDIR("build");
    MKDIR(root);
    snprintf(league, sizeof league, "%s/FOO.LP", root);
    snprintf(floppy, sizeof floppy, "%s/disk", root);
    MKDIR(league);
    MKDIR(floppy);

    for (i = 0; i < 7; i++) {
        static const char *n[] = { "KEY", "CAREER", "ATT", "CARTEAMS", "TEAMS", "SEASON", "SCHEDULE" };
        char rec[0x2E8];
        memset(rec, 0, sizeof rec);
        memcpy(rec + 5, "Edmonton", 9);
        snprintf(srcdb, sizeof srcdb, "%s/%s.DB", league, n[i]);
        write_bytes(srcdb, rec, sizeof rec);
    }
    memset(tab, 0, sizeof tab);
    memcpy(tab + 0x20 + 5 * 30, "OILERS", 6);
    tab[0x20 + 5 * 30 + 0x17] = 1;
    tab[0x20 + 5 * 30 + 0x18] = 2;
    snprintf(pinfo, sizeof pinfo, "%s/PINFO.DB", league);
    write_bytes(pinfo, tab, sizeof tab);

    CHECK(season_pack_floppy(league, floppy, 5, "FOO.LP", 1) == 0);
    CHECK(season_floppy_ready(floppy, 5, "FOO.LP"));
    CHECK(!season_floppy_ready(floppy, 12, "FOO.LP"));
    snprintf(srcdb, sizeof srcdb, "%s/GAME.SET", floppy);
    CHECK(file_size(srcdb) == 0x75);
    snprintf(srcdb, sizeof srcdb, "%s/PLAYER.ID", floppy);
    CHECK(file_size(srcdb) == 29);
    snprintf(srcdb, sizeof srcdb, "%s/KEY.DB", floppy);
    snprintf(pinfo, sizeof pinfo, "%s/KEY.05", floppy);
    CHECK(file_size(srcdb) > 0 && file_size(pinfo) > 0);
    snprintf(srcdb, sizeof srcdb, "%s/TEAMS.DB", floppy);
    snprintf(pinfo, sizeof pinfo, "%s/TEAMS.05", floppy);
    CHECK(file_size(srcdb) > 0 && file_size(pinfo) > 0);

    snprintf(srcdb, sizeof srcdb, "%s/PLAYER.ID", floppy);
    f = fopen(srcdb, "rb");
    CHECK(f && fread(pid, 1, 29, f) == 29);
    if (f) fclose(f);
    CHECK(pid[0] == 5);
    CHECK(!memcmp(pid + 1, "OILERS", 6));
    CHECK(!memcmp(pid + 12, "FOO.LP", 6));

    snprintf(srcdb, sizeof srcdb, "%s/PINFO.DB", floppy);
    f = fopen(srcdb, "rb");
    CHECK(f && fseek(f, 4, SEEK_SET) == 0 && fread(saved, 1, 2, f) == 2);
    CHECK(saved[0] == 0 && saved[1] == 0);
    CHECK(f && fseek(f, 0x20 + 5 * 30, SEEK_SET) == 0 && fread(entry, 1, 30, f) == 30);
    if (f) fclose(f);
    CHECK(entry[0x16] == 2 && (entry[0x18] & 2));

    {
        char join_root[512], got[32];
        snprintf(join_root, sizeof join_root, "%s/join", root);
        MKDIR(join_root);
        CHECK(season_install_floppy(floppy, join_root, got, (int)sizeof got) == 0);
        CHECK(!strcmp(got, "FOO.LP"));
        snprintf(dest, sizeof dest, "%s/FOO.LP", join_root);
        snprintf(srcdb, sizeof srcdb, "%s/PLAYER.ID", dest);
        CHECK(file_size(srcdb) == 29);
        snprintf(srcdb, sizeof srcdb, "%s/GAME.SET", dest);
        CHECK(file_size(srcdb) == 0x75);
        snprintf(srcdb, sizeof srcdb, "%s/KEY.DB", dest);
        CHECK(file_size(srcdb) > 0);
        snprintf(srcdb, sizeof srcdb, "%s/PINFO.DB", dest);
        f = fopen(srcdb, "rb");
        CHECK(f && fseek(f, 0x20 + 5 * 30, SEEK_SET) == 0 && fread(entry, 1, 30, f) == 30);
        if (f) fclose(f);
        CHECK(entry[0x16] == 2); /* still an export, so Import Databases > Player takes it */
        CHECK(season_floppy_ready(dest, 5, "FOO.LP"));
        CHECK(season_mark_imported(dest, 5) == 0);
        snprintf(srcdb, sizeof srcdb, "%s/PINFO.DB", dest);
        f = fopen(srcdb, "rb");
        CHECK(f && fseek(f, 0x20 + 5 * 30, SEEK_SET) == 0 && fread(entry, 1, 30, f) == 30);
        if (f) fclose(f);
        CHECK(entry[0x16] == 1); /* calendar: this machine has imported it */
        CHECK(!season_floppy_ready(dest, 5, "FOO.LP"));
        CHECK(season_write_player_id(dest, 5, "FOO.LP") == 0);
        snprintf(srcdb, sizeof srcdb, "%s/PLAYER.ID", dest);
        f = fopen(srcdb, "rb");
        CHECK(f && fread(pid, 1, 29, f) == 29);
        if (f) fclose(f);
        CHECK(pid[0] == 5);
        CHECK(!memcmp(pid + 1, "OILERS", 6));
        CHECK(!memcmp(pid + 12, "FOO.LP", 6));
        CHECK(season_player_id(dest, &i, NULL) == 0 && i == 5);
    }

    /* Import Databases > Player onto another copy (C's team onto D's league) */
    {
        char d_league[512], c_disk[512];
        unsigned char dtab[0x20 + 26 * 30];
        snprintf(d_league, sizeof d_league, "%s/dee", root);
        snprintf(c_disk, sizeof c_disk, "%s/cdisk", root);
        MKDIR(d_league);
        MKDIR(c_disk);
        memcpy(dtab, tab, sizeof dtab);
        memcpy(dtab + 0x20 + 12 * 30, "RANGERS", 7);
        dtab[0x20 + 12 * 30 + 0x17] = 1;
        dtab[0x20 + 12 * 30 + 0x18] = 2;
        snprintf(pinfo, sizeof pinfo, "%s/PINFO.DB", d_league);
        write_bytes(pinfo, dtab, sizeof dtab);
        for (i = 0; i < 7; i++) {
            static const char *n[] = { "KEY", "CAREER", "ATT", "CARTEAMS", "TEAMS", "SEASON", "SCHEDULE" };
            snprintf(srcdb, sizeof srcdb, "%s/%s.DB", d_league, n[i]);
            write_bytes(srcdb, "dee", 3);
        }
        CHECK(season_pack_floppy(league, c_disk, 5, "FOO.LP", 0) == 0);
        CHECK(season_player_id(c_disk, &i, NULL) == 0 && i == 5);
        CHECK(season_import_team(c_disk, d_league, 5) == 0);
        snprintf(srcdb, sizeof srcdb, "%s/KEY.05", d_league);
        CHECK(file_size(srcdb) > 0);
        snprintf(srcdb, sizeof srcdb, "%s/PINFO.DB", d_league);
        f = fopen(srcdb, "rb");
        CHECK(f && fseek(f, 0x20 + 5 * 30, SEEK_SET) == 0 && fread(entry, 1, 30, f) == 30);
        if (f) fclose(f);
        CHECK(entry[0x16] == 1);
    }

    /* league folder has no GAME.SET (New League writes it in the game folder while gamemode is 0) */
    {
        char nsrc[512], ndisk[512];
        snprintf(nsrc, sizeof nsrc, "%s/NOSET.LP", root);
        snprintf(ndisk, sizeof ndisk, "%s/disk2", root);
        MKDIR(nsrc);
        MKDIR(ndisk);
        for (i = 0; i < 7; i++) {
            static const char *n[] = { "KEY", "CAREER", "ATT", "CARTEAMS", "TEAMS", "SEASON", "SCHEDULE" };
            snprintf(srcdb, sizeof srcdb, "%s/%s.DB", nsrc, n[i]);
            write_bytes(srcdb, "x", 1);
        }
        snprintf(pinfo, sizeof pinfo, "%s/PINFO.DB", nsrc);
        write_bytes(pinfo, tab, sizeof tab);
        CHECK(season_pack_floppy(nsrc, ndisk, 5, "NOSET.LP", 0) == 0);
        CHECK(season_floppy_ready(ndisk, 5, "NOSET.LP"));
        snprintf(srcdb, sizeof srcdb, "%s/GAME.SET", ndisk);
        CHECK(file_size(srcdb) == 0x75);
        f = fopen(srcdb, "rb");
        CHECK(f && fgetc(f) == 2);
        if (f) fclose(f);
    }

    /* Next League Game: three humans all marked remote (Yes to export) used to
     * say "must be imported" on host and client. Auto-import the pick; a client
     * cannot take a host-local team. After overlay pick, only that team imports. */
    {
        unsigned char t[26 * 30];
        memset(t, 0, sizeof t);
        t[5 * 30 + 0x17] = 1;
        t[5 * 30 + 0x18] = 1;
        t[5 * 30 + 0x16] = 1;   /* host-local */
        t[12 * 30 + 0x17] = 1;
        t[12 * 30 + 0x18] = 2;
        t[12 * 30 + 0x16] = 2;  /* remote (bob) */
        t[18 * 30 + 0x17] = 1;
        t[18 * 30 + 0x18] = 2;
        t[18 * 30 + 0x16] = 2;  /* remote (rad) */
        CHECK(season_next_game_pick(t, 12, 0, -1) == 0);
        CHECK(t[12 * 30 + 0x16] == 1 && t[12 * 30 + 0x18] == 2);
        CHECK(season_next_game_pick(t, 5, 1, -1) == -1);
        CHECK(t[5 * 30 + 0x16] == 1 && t[5 * 30 + 0x18] == 1);
        CHECK(season_next_game_pick(t, 18, 1, -1) == 0);
        CHECK(t[18 * 30 + 0x16] == 1 && t[18 * 30 + 0x18] == 2);
        CHECK(season_next_game_pick(t, 5, 0, -1) == 0);
        CHECK(season_next_game_pick(t, 0, 0, -1) == -1);
        CHECK(season_next_game_pick(t, 0, 1, -1) == -1);
        CHECK(season_next_game_pick(NULL, 12, 0, -1) == -1);
        CHECK(season_next_game_pick(t, -1, 0, -1) == -1);
        CHECK(season_next_game_pick(t, 26, 0, -1) == -1);
        /* client picked bob (12): rad (18) stays remote and not his */
        t[12 * 30 + 0x16] = 2;
        t[18 * 30 + 0x16] = 2;
        CHECK(season_next_game_pick(t, 18, 1, 12) == -1);
        CHECK(t[18 * 30 + 0x16] == 2 && t[18 * 30 + 0x18] == 2);
        CHECK(season_next_game_pick(t, 5, 1, 12) == -1);
        CHECK(season_next_game_pick(t, 12, 1, 12) == 0);
        CHECK(t[12 * 30 + 0x16] == 1 && t[12 * 30 + 0x18] == 2);
        /* host may still pick any human */
        memset(t, 0, sizeof t);
        t[1 * 30 + 0x17] = t[2 * 30 + 0x17] = t[3 * 30 + 0x17] = 1;
        t[1 * 30 + 0x18] = t[2 * 30 + 0x18] = t[3 * 30 + 0x18] = 2;
        t[1 * 30 + 0x16] = t[2 * 30 + 0x16] = t[3 * 30 + 0x16] = 2;
        CHECK(season_next_game_pick(t, 1, 0, -1) == 0 && t[1 * 30 + 0x16] == 1);
        CHECK(season_next_game_pick(t, 2, 1, -1) == 0 && t[2 * 30 + 0x16] == 1);
        CHECK(season_next_game_pick(t, 3, 0, -1) == 0 && t[3 * 30 + 0x16] == 1);
    }

    printf(fails ? "season_test: %d failed\n" : "season_test: all passed\n", fails);
    return fails != 0;
}
