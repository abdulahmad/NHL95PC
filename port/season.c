/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * Per-game season hooks. A team flagged for export at New League (+18h == 2) is a
 * remote player: the host keeps Boston (local) and guests Pick "Los Angeles" by
 * name ("Edmonton - Bob": the player's name the host typed at New League), and the
 * copy waits as the guest's A: disk for File > Import Databases. No file names. It copies that team's seven DBs + PINFO + PLAYER.ID, not the whole
 * league tree. Virtual A: stays mounted on the copy used in play.
 */
#include "season.h"

#include "overbar_client.h"
#include "overbar/files.h"
#include "overbar/net.h"
#include "overbar/overbar.h"
#include "overbar/room.h"
#include "overbar/season.h"
#include "overbar/vdrive.h"
#include "sides.h"

#include <stdint.h>
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
extern int gamemode;
extern int lgstate[];                   /* the league's saved mode state: its folder name at +4 */

static int real_league(const char *n)    /* "HIHI.LP", not "" nor the exhibition's "." */
{
    return n && n[0] && n[0] != '.';
}

/* the league open in the game: curleague while the league state is loaded (gamemode 2), else the one the
   desk keeps in lgstate (File > Open on a league, New League). The exhibition state carries "." or a stale
   name in curleague, so it never counts. "" none */
static const char *open_league(void)
{
    const char *c = (const char *)&curleague, *l = (const char *)lgstate + 4;
    if (gamemode == 2 && real_league(c)) return c;
    return real_league(l) ? l : "";
}
extern unsigned char leagueteams[];
extern unsigned char treeteamnames[];
extern unsigned char str_floppydrv;

extern int MergeTeamDbs();
extern int MergeScheduleDb();

static ob_season g_season;
static ob_files g_files;
static ob_vdrive g_vdrive;
static ob_room g_room;
static ob_net *g_net;
static ob_host *g_host;
static char g_work[260], g_root[260], g_play_dir[260];
static int g_ready, g_play_on;
static char g_seen_league[16];
static int g_seen_master = -1, g_seen_nteam = -1;

/* the seven league databases ExportTeamToFloppy / CopyHumanTeamDBs copy (not NHL names) */
static const char *const k_db[7] = {
    "KEY", "CAREER", "ATT", "CARTEAMS", "TEAMS", "SEASON", "SCHEDULE"
};

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

static int exists_path(const char *p)
{
    struct stat st;
    return p && p[0] && stat(p, &st) == 0;
}

static void join2(char *out, int size, const char *dir, const char *name)
{
    snprintf(out, (size_t)size, "%s/%s", dir, name);
}

static int copy_named(const char *from, const char *to, const char *stem, const char *ext)
{
    char a[512], b[512], leaf[64];
    snprintf(leaf, sizeof leaf, "%s%s", stem, ext);
    join2(a, (int)sizeof a, from, leaf);
    join2(b, (int)sizeof b, to, leaf);
    if (!exists_path(a)) return 1;          /* optional */
    return copy_file(a, b);
}

static int stricmp_ascii(const char *a, const char *b)
{
    for (; *a && *b; a++, b++) {
        int x = (unsigned char)*a, y = (unsigned char)*b;
        if (x >= 'a' && x <= 'z') x -= 32;
        if (y >= 'a' && y <= 'z') y -= 32;
        if (x != y) return x - y;
    }
    return (unsigned char)*a - (unsigned char)*b;
}

static int team_human(int team)
{
    return team >= 0 && team < 26 && leagueteams[team * 30 + 0x17] == 1;
}

static int team_remote(int team)
{
    return team_human(team) && leagueteams[team * 30 + 0x18] == 2;
}

static int team_local(int team)
{
    return team_human(team) && !team_remote(team);
}

static int has_human(void)
{
    int i;
    for (i = 0; i < 26; i++)
        if (team_human(i)) return 1;
    return 0;
}

/* HD copy that still has a local human. leaguemaster is a team index (0 is valid), not a boolean. */
static int is_master_copy(void)
{
    int i;
    for (i = 0; i < 26; i++)
        if (team_local(i)) return 1;
    return 0;
}

/* CopyHumanTeamDBs still writes a floppy for +18h==2 with +16h bit 0 clear. */
static int needs_floppy(void)
{
    int i;
    for (i = 0; i < 26; i++)
        if (team_remote(i) && !(leagueteams[i * 30 + 0x16] & 1))
            return 1;
    return 0;
}

static int league_host_dir(char *dir, int size)
{
    const char *name = open_league();
    if (!name[0]) return -1;
    snprintf(dir, (size_t)size, "%s/%s", g_root[0] ? g_root : game_root(), name);
    return 0;
}

static void team_ext(char *ext, int size, int team)
{
    snprintf(ext, (size_t)size, ".%02d", team);
}

/* one team's floppy set: the seven DBs as .DB and as .NN, PINFO.DB, PLAYER.ID, GAME.SET */
static int copy_team_files(const char *from, const char *to, int team)
{
    char nn[8];
    int i, need = 0;
    team_ext(nn, (int)sizeof nn, team);
    MKDIR(to);
    for (i = 0; i < 7; i++) {
        int a = copy_named(from, to, k_db[i], ".DB");
        int b = copy_named(from, to, k_db[i], nn);
        if (a < 0 || b < 0) return -1;
        if (a == 0) need = 1;
    }
    if (copy_named(from, to, "PINFO", ".DB") < 0) return -1;
    if (copy_named(from, to, "PLAYER", ".ID") < 0) return -1;
    if (copy_named(from, to, "GAME", ".SET") < 0) return -1;
    return need ? 0 : -1;
}

static void unmount_play(void)
{
    if (g_play_on) ob_vdrive_unmount(&g_vdrive, 'A');
    g_play_on = 0;
    g_play_dir[0] = 0;
}

static void mount_a(const char *dir)
{
    ob_vdrive_mount(&g_vdrive, 'A', dir);
    snprintf(g_play_dir, sizeof g_play_dir, "%s", dir);
    g_play_on = 1;
    if (str_floppydrv == '?' || str_floppydrv == 0) str_floppydrv = 'A';
}

/* a team picked in the room whose league is not the one loaded yet: its disk (0 none) */
static int disk_pending(char *disk, int size)
{
    char cur[16];
    const char *name = open_league();
    if (ob_season_disk(&g_season, -1, disk, size) < 0) return 0;
    snprintf(cur, sizeof cur, "%s", name);
    if (strchr(cur, '.')) *strchr(cur, '.') = 0;
    return !g_season.roster_league[0] || stricmp_ascii(cur, g_season.roster_league) != 0;
}

static void mount_play(void)
{
    char dir[512];
    /* CreateNewLeague strcpy's curleague, then asks schedule/database (frames tick here),
       then mkdir. ob_vdrive_mount mkdir's, so mounting A: on that path first makes the
       game's mkdir fail → "Error while creating league!". Only a guest copy (humans, none
       local) should own A: as the league folder, and only once that folder is already there.
       A remote team at New League still goes through CopyHumanTeamDBs's floppy write: give
       it a scratch A: so that does not land in NHL95_ROOT. */
    if (is_master_copy() && needs_floppy()) {
        char floppy[512];
        snprintf(floppy, sizeof floppy, "%s/floppy", g_work[0] ? g_work : "overbar-season");
        MKDIR(floppy);
        mount_a(floppy);
        return;
    }
    {
        char disk[512];
        /* a team picked in the room and not loaded yet: its disk is the floppy in A: for Import Databases */
        if (!is_master_copy() && disk_pending(disk, (int)sizeof disk)) {
            if (!g_play_on || strcmp(g_play_dir, disk)) mount_a(disk);
            return;
        }
    }
    if (league_host_dir(dir, (int)sizeof dir) || !exists_path(dir) || !has_human() || is_master_copy()) {
        unmount_play();
        return;
    }
    mount_a(dir);
}

static void restore_play(void)
{
    mount_play();
}

static int with_pack_drive(int team, const char *dir, int (*fn)(const char *from, const char *to, int team))
{
    char from[512];
    if (league_host_dir(from, (int)sizeof from)) return -1;
    MKDIR(dir);
    ob_vdrive_mount(&g_vdrive, 'A', dir);
    if (fn(from, dir, team)) { restore_play(); return -1; }
    restore_play();
    return 0;
}

static int op_league(void *ud, ob_season_league *l)
{
    int i;
    const char *name = open_league();
    (void)ud;
    memset(l, 0, sizeof *l);
    if (!name[0]) return -1;
    snprintf(l->name, sizeof l->name, "%s", name);
    if (strchr(l->name, '.')) *strchr(l->name, '.') = 0;      /* "ABDUL", not the folder ABDUL.LP */
    snprintf(l->id, sizeof l->id, "%s", name);
    /* the room's host: any league open here is the master (players join it); else a copy has none local */
    l->master = (is_master_copy() || (g_net && ob_net_is_host(g_net))) ? 1 : 0;
    for (i = 0; i < 26 && l->nteam < OB_SEASON_TEAMS; i++) {
        /* host: local humans only (Boston). remote exports (LA) are pickable, not "the host's". */
        if (l->master) {
            if (!team_local(i)) continue;
        } else if (!team_human(i))
            continue;
        l->team[l->nteam++] = i;
    }
    return 0;
}

static int op_export(void *ud, int team, const char *dir)
{
    (void)ud;
    return with_pack_drive(team, dir, copy_team_files);
}

static int op_copy(void *ud, int team, const char *dir)
{
    (void)ud;
    return with_pack_drive(team, dir, copy_team_files);
}

static int import_into_league(const char *from, const char *to, int team)
{
    return copy_team_files(from, to, team);
}

static int op_import(void *ud, int team, const char *dir)
{
    char to[512];
    (void)ud;
    if (league_host_dir(to, (int)sizeof to)) return -1;
    ob_vdrive_mount(&g_vdrive, 'A', dir);
    if (import_into_league(dir, to, team)) { restore_play(); return -1; }
    restore_play();
    return 0;
}

/* eax, edx, ebx, ecx, then two stack args; Watcom pops the stack extras */
__attribute__((naked)) static int watcall6(void *fn, uint32_t a, uint32_t d, uint32_t b, uint32_t c,
                                           uint32_t s0, uint32_t s1)
{
    __asm__ volatile(
        "pushl %ebp\n\tmovl %esp, %ebp\n\tpushl %ebx\n\tpushl %esi\n\tpushl %edi\n\t"
        "pushl 32(%ebp)\n\tpushl 28(%ebp)\n\t"
        "movl 12(%ebp), %eax\n\tmovl 16(%ebp), %edx\n\tmovl 20(%ebp), %ebx\n\tmovl 24(%ebp), %ecx\n\t"
        "call *8(%ebp)\n\t"
        "popl %edi\n\tpopl %esi\n\tpopl %ebx\n\tpopl %ebp\n\tret");
}

static int op_merge(void *ud, int team, const char *dir, const uint32_t *played, int nplayed)
{
    char floppy[] = "A:";
    char nn[8], db[] = ".DB";
    const char *league = open_league();
    const char *ext = nn;
    int ngames = 0, r;
    (void)ud;
    (void)played;
    (void)nplayed;
    if (!league[0] || team < 0 || team >= 26) return -1;
    team_ext(nn, (int)sizeof nn, team);
    ob_vdrive_mount(&g_vdrive, 'A', dir);
    /* Overbar already hands each (game, team) once via played[] */
    r = watcall6((void *)MergeTeamDbs, (uint32_t)(uintptr_t)league, (uint32_t)(uintptr_t)floppy,
                 (uint32_t)(uintptr_t)league, (uint32_t)(uintptr_t)ext,
                 (uint32_t)(uintptr_t)db, (uint32_t)team);
    if (r) {
        ext = db;
        r = watcall6((void *)MergeTeamDbs, (uint32_t)(uintptr_t)league, (uint32_t)(uintptr_t)floppy,
                     (uint32_t)(uintptr_t)league, (uint32_t)(uintptr_t)ext,
                     (uint32_t)(uintptr_t)db, (uint32_t)team);
    }
    if (!r)
        r = watcall6((void *)MergeScheduleDb, (uint32_t)(uintptr_t)floppy, (uint32_t)(uintptr_t)league,
                     (uint32_t)(uintptr_t)ext, (uint32_t)(uintptr_t)db,
                     (uint32_t)team, (uint32_t)(uintptr_t)&ngames);
    restore_play();
    return r ? -1 : 0;
}

static int op_dir(void *ud, char *dir, int size)
{
    (void)ud;
    return league_host_dir(dir, size);
}

/* NULL for CPU so Pick a team only lists humans (host-local + exported remotes) */
static const char *team_name(void *ud, int team)
{
    (void)ud;
    if (!team_human(team)) return NULL;
    return (const char *)(treeteamnames + team * 21);
}

/* the player the host set this team up for at New League (played on another computer) */
static const char *op_player(void *ud, int team)
{
    static char name[12];
    (void)ud;
    if (!team_remote(team)) return NULL;
    memcpy(name, leagueteams + team * 30, 11);
    name[11] = 0;
    return name[0] ? name : "a player";
}

static int op_add_human(void *ud, int team, const char *name)
{
    (void)ud;
    (void)name;
    /* New League already marked remote humans. Do not open Add Team dialogs. */
    if (!team_remote(team)) return -1;
    return 0;
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

static void rebuild_bar_if_league(void)
{
    ob_season_league l;
    const char *name = open_league();
    int master = is_master_copy() ? 1 : 0, nteam = 0;
    memset(&l, 0, sizeof l);
    if (name[0] && op_league(NULL, &l) == 0) nteam = l.nteam;
    if (g_seen_master == master && g_seen_nteam == nteam && strcmp(g_seen_league, name ? name : "") == 0)
        return;
    g_seen_master = master;
    g_seen_nteam = nteam;
    snprintf(g_seen_league, sizeof g_seen_league, "%s", name ? name : "");
    if (g_host) ob_filemenu_sync(g_host);
}

static void diag_log(void)
{
    const char *lp = getenv("OVERBAR_TEST_LOG");
    ob_season_league l;
    FILE *f;
    const char *name = open_league();
    static char last[256];
    char line[256];
    int nteam = 0;
    if (!lp || !lp[0]) return;
    memset(&l, 0, sizeof l);
    if (name[0] && op_league(NULL, &l) == 0) nteam = l.nteam;
    snprintf(line, sizeof line, "TEST season league=%s master=%d nteam=%d gamemode=%d net=%d why=%s\n",
             name && name[0] ? name : "-", is_master_copy() ? 1 : 0, nteam, (int)gamemode,
             g_net ? 1 : 0, g_season.why[0] ? g_season.why : "-");
    if (!strcmp(line, last)) return;
    snprintf(last, sizeof last, "%s", line);
    f = fopen(lp, "ab");
    if (!f) return;
    fputs(line, f);
    fclose(f);
    fputs(line, stderr);
}

void port_season_setup(ob_host *h)
{
    ob_season_ops ops;
    const char *me;
    if (!h || g_ready) return;
    g_host = h;
    snprintf(g_root, sizeof g_root, "%s", game_root());
    snprintf(g_work, sizeof g_work, "%s/overbar-season", g_root);
    MKDIR(g_work);
    ob_vdrive_init(&g_vdrive);
    memset(&ops, 0, sizeof ops);
    ops.league = op_league;
    ops.export_team = op_export;
    ops.merge_team = op_merge;
    ops.copy_team = op_copy;
    ops.import_team = op_import;
    ops.league_dir = op_dir;
    ops.add_human = op_add_human;
    ops.player = op_player;
    ops.give_as_disk = 1;           /* the picked team is this player's floppy in A: */
    me = h->online.name[0] ? h->online.name : "player";
    ob_files_init(&g_files, files_send, NULL);
    ob_season_init(&g_season, &ops, g_work, me, &g_files, season_send, NULL);
    ob_season_set(h, &g_season, 0, NULL);
    ob_season_set_names(h, team_name, NULL);
    ob_season_set_hint(h, "yours: in the game, File > Import Databases (the disk is in drive A:)");
    g_ready = 1;
}

void port_season_free(void)
{
    if (!g_ready) return;
    ob_season_free(&g_season);
    ob_files_free(&g_files);
    g_net = NULL;
    g_host = NULL;
    g_ready = 0;
}

void port_season_bind_net(ob_net *n)
{
    g_net = n;
    if (!n) return;
    port_sides_bind_net(n);
    ob_room_init(&g_room, n, port_sides_ob(), NULL);
    ob_room_modules(&g_room, &g_files, &g_season);
}

void port_season_unbind_net(void)
{
    port_sides_unbind_net();
    g_net = NULL;
    memset(&g_room, 0, sizeof g_room);
}

void port_season_poll(void)
{
    if (g_net) ob_room_poll(&g_room, NULL, NULL);
}

void port_season_tick(void)
{
    if (!g_ready) return;
    rebuild_bar_if_league();
    if (g_host) ob_season_tick(g_host);
    mount_play();
    diag_log();
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
