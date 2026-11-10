/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * Per-game season hooks: copy the current league folder (the original's floppy)
 * without the game's disk prompts. Overbar carries .obt files and the room.
 */
#include "season.h"

#include "overbar_client.h"
#include "overbar/files.h"
#include "overbar/net.h"
#include "overbar/room.h"
#include "overbar/season.h"
#include "overbar/vdrive.h"

#include <dirent.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#ifdef _WIN32
#include <direct.h>
#define MKDIR(p) _mkdir(p)
#else
#include <unistd.h>
#define MKDIR(p) mkdir(p, 0777)
#endif

extern unsigned char curleague;
extern int leaguemaster;
extern unsigned char leagueteams[];
extern unsigned char treeteamnames[];

static ob_season g_season;
static ob_files g_files;
static ob_vdrive g_vdrive;
static ob_room g_room;
static ob_net *g_net;
static char g_work[260], g_teams[260], g_root[260];
static int g_ready;

static const char *game_root(void)
{
    const char *r = getenv("NHL95_ROOT");
    return r && r[0] ? r : ".";
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

static int copy_tree(const char *from, const char *to)
{
    DIR *d;
    struct dirent *e;
    MKDIR(to);
    d = opendir(from);
    if (!d) return -1;
    while ((e = readdir(d))) {
        char a[512], b[512];
        struct stat st;
        if (e->d_name[0] == '.') continue;
        snprintf(a, sizeof a, "%s/%s", from, e->d_name);
        snprintf(b, sizeof b, "%s/%s", to, e->d_name);
        if (stat(a, &st)) continue;
        if (S_ISDIR(st.st_mode)) {
            if (copy_tree(a, b)) { closedir(d); return -1; }
        } else if (copy_file(a, b)) { closedir(d); return -1; }
    }
    closedir(d);
    return 0;
}

static int league_host_dir(char *dir, int size)
{
    const char *name = (const char *)&curleague;
    if (!name[0]) return -1;
    snprintf(dir, (size_t)size, "%s/%s", g_root[0] ? g_root : game_root(), name);
    return 0;
}

static int op_league(void *ud, ob_season_league *l)
{
    int i;
    const char *name = (const char *)&curleague;
    (void)ud;
    memset(l, 0, sizeof *l);
    if (!name[0]) return -1;
    snprintf(l->name, sizeof l->name, "%s", name);
    snprintf(l->id, sizeof l->id, "%s", name);
    l->master = leaguemaster ? 1 : 0;
    for (i = 0; i < 26 && l->nteam < OB_SEASON_TEAMS; i++) {
        if (leagueteams[i * 30 + 0x17] != 1) continue;
        l->team[l->nteam++] = i;
    }
    return 0;
}

static int with_drive(int team, const char *dir, int (*fn)(const char *from, const char *to))
{
    char from[512];
    (void)team;
    if (league_host_dir(from, (int)sizeof from)) return -1;
    MKDIR(dir);
    ob_vdrive_mount(&g_vdrive, 'A', dir);
    if (fn(from, dir)) { ob_vdrive_unmount(&g_vdrive, 'A'); return -1; }
    ob_vdrive_unmount(&g_vdrive, 'A');
    return 0;
}

static int op_export(void *ud, int team, const char *dir)
{
    (void)ud;
    return with_drive(team, dir, copy_tree);
}

static int op_copy(void *ud, int team, const char *dir)
{
    (void)ud;
    return with_drive(team, dir, copy_tree);
}

static int op_import(void *ud, int team, const char *dir)
{
    char to[512];
    (void)ud;
    (void)team;
    if (league_host_dir(to, (int)sizeof to)) return -1;
    ob_vdrive_mount(&g_vdrive, 'A', dir);
    if (copy_tree(dir, to)) { ob_vdrive_unmount(&g_vdrive, 'A'); return -1; }
    ob_vdrive_unmount(&g_vdrive, 'A');
    return 0;
}

static int op_merge(void *ud, int team, const char *dir, const uint32_t *played, int nplayed)
{
    (void)played;
    (void)nplayed;
    return op_import(ud, team, dir);
}

static int op_dir(void *ud, char *dir, int size)
{
    (void)ud;
    return league_host_dir(dir, size);
}

static const char *team_name(void *ud, int team)
{
    (void)ud;
    if (team < 0 || team >= 26) return NULL;
    return (const char *)(treeteamnames + team * 21);
}

static void files_send(void *ud, int to, const void *data, size_t size)
{
    (void)ud;
    if (g_net) ob_net_send(g_net, to, OB_NET_TYPE_FILES, data, size);
}

static void season_send(void *ud, int to, const void *data, size_t size)
{
    (void)ud;
    if (g_net) ob_net_send(g_net, to, OB_NET_TYPE_SEASON, data, size);
}

static int first_team(void)
{
    ob_season_league l;
    memset(&l, 0, sizeof l);
    if (op_league(NULL, &l) || l.nteam <= 0) return 0;
    return l.team[0];
}

#ifndef OB_PAGE_SEASON
static int addon_sync(void *ctx)
{
    (void)ctx;
    ob_season_sync(&g_season, 0);
    return 1;
}
static int addon_export(void *ctx)
{
    char path[300];
    (void)ctx;
    MKDIR(g_teams);
    snprintf(path, sizeof path, "%s/team.obt", g_teams);
    ob_season_pack(&g_season, first_team(), path);
    return 1;
}
static int addon_import(void *ctx)
{
    char path[300];
    (void)ctx;
    snprintf(path, sizeof path, "%s/team.obt", g_teams);
    ob_season_import_pack(&g_season, path);
    return 1;
}
static int addon_take(void *ctx)
{
    char path[300], back[300];
    (void)ctx;
    snprintf(path, sizeof path, "%s/team.obt", g_teams);
    snprintf(back, sizeof back, "%s/team-back.obt", g_teams);
    ob_season_take_pack(&g_season, path, back);
    return 1;
}
static int addon_copy(void *ctx)
{
    ob_host *h = overbar_client_host();
    const char *who;
    char path[300];
    (void)ctx;
    who = h && h->online.name[0] ? h->online.name : "player";
    MKDIR(g_teams);
    snprintf(path, sizeof path, "%s/team.obt", g_teams);
    ob_season_pack_copy(&g_season, who, first_team(), path);
    return 1;
}
#endif

void port_season_setup(ob_host *h)
{
    ob_season_ops ops;
    const char *me;
    if (!h || g_ready) return;
    snprintf(g_root, sizeof g_root, "%s", game_root());
    snprintf(g_work, sizeof g_work, "%s/overbar-season", g_root);
    snprintf(g_teams, sizeof g_teams, "%s/teams", g_root);
    MKDIR(g_work);
    MKDIR(g_teams);
    ob_vdrive_init(&g_vdrive);
    memset(&ops, 0, sizeof ops);
    ops.league = op_league;
    ops.export_team = op_export;
    ops.merge_team = op_merge;
    ops.copy_team = op_copy;
    ops.import_team = op_import;
    ops.league_dir = op_dir;
    me = h->online.name[0] ? h->online.name : "player";
    ob_files_init(&g_files, files_send, NULL);
    ob_season_init(&g_season, &ops, g_work, me, &g_files, season_send, NULL);
#ifdef OB_PAGE_SEASON
    ob_season_set(h, &g_season, 0, g_teams);
    ob_season_set_names(h, team_name, NULL);
#else
    (void)team_name;
    ob_host_add_addon(h, OB_ID_ADDON + 0, "Season: Sync league", addon_sync);
    ob_host_add_addon(h, OB_ID_ADDON + 1, "Season: Export team as a file", addon_export);
    ob_host_add_addon(h, OB_ID_ADDON + 2, "Season: Import a team file", addon_import);
    ob_host_add_addon(h, OB_ID_ADDON + 3, "Season: Take a team file", addon_take);
    ob_host_add_addon(h, OB_ID_ADDON + 4, "Season: Write a first copy", addon_copy);
#endif
    g_ready = 1;
}

void port_season_free(void)
{
    if (!g_ready) return;
    ob_season_free(&g_season);
    ob_files_free(&g_files);
    g_net = NULL;
    g_ready = 0;
}

void port_season_bind_net(ob_net *n)
{
    g_net = n;
    if (!n) return;
    ob_room_init(&g_room, n, NULL, NULL);
    ob_room_modules(&g_room, &g_files, &g_season);
}

void port_season_unbind_net(void)
{
    g_net = NULL;
    memset(&g_room, 0, sizeof g_room);
}

void port_season_poll(void)
{
    if (g_net) ob_room_poll(&g_room, NULL, NULL);
}

int port_season_map_dos(const char *dos, char *out, int size)
{
    return ob_vdrive_path(&g_vdrive, dos, out, size);
}

int port_season_diskfree(int letter, unsigned *total_clusters, unsigned *free_clusters,
                         unsigned *sectors_per_cluster, unsigned *bytes_per_sector)
{
    return ob_vdrive_diskfree(&g_vdrive, letter, total_clusters, free_clusters,
                              sectors_per_cluster, bytes_per_sector);
}
