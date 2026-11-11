/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * Per-game season hooks. A team flagged for export at New League (+18h == 2) is a
 * remote player: the host keeps Boston (local) and guests Pick "Los Angeles" by
 * name. New League asks "remote team for a player on another device?"; Yes
 * auto-exports (no insert-disk). Next League Game shows every team; a client can
 * only take the team it already picked, and that pick imports that team only.
 * Overlay Season: a guest's HELLO names only that claimed team, so leftover
 * remotes stay open and the host's controller is never that guest's.
 * Virtual A: is the other human's mirror when the calendar needs it.
 * C vs D: the same File > Export / Import Databases / Merge & Update path as
 * 1994, run in the background whenever the copies need it. Export one team's
 * DBs, import them onto the other machine, merge that copy in, so both teams
 * live on that PC, then play here (local). The season host is not in that game.
 * The player never has to click Export, Import, or Merge & Update. Overlay pack
 * is the same when someone is away.
 */
#include "season.h"

#include "host.h"
#include "overbar_client.h"
#include "overbar/files.h"
#include "overbar/net.h"
#include "overbar/overbar.h"
#include "overbar/room.h"
#include "overbar/season.h"
#include "overbar/vdrive.h"
#include "season_floppy.h"
#include "sides.h"

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#ifdef _WIN32
#include <direct.h>
#include <io.h>
#define MKDIR(p) _mkdir(p)
#define UNLINK(p) _unlink(p)
#define SYM(s) "_" s
#else
#include <unistd.h>
#define MKDIR(p) mkdir(p, 0777)
#define UNLINK(p) unlink(p)
#define SYM(s) s
#endif

extern unsigned char curleague;
extern int gamemode, lgplayteam, dword_DDD34, dword_DDD3C, lgstate[];
extern short lggameidx, HomeTeam, VisTeam;
extern char WaitLeagueFloppy[], FindLeagueFloppy[], PlayLeagueGame[];
extern char CheckLeagueDiskSync[], CopyHumanTeamDBs[], LeagueTeamSelect[];
extern char AddHumanTeam[], MergeLeagueFiles[];
extern unsigned char exportmsg[], leagueflags;
extern signed char byte_DE268;
extern volatile int quit_requested;

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
static int g_ready, g_play_on, g_installed_team = -1, g_hold_a, g_in_league, g_join_sync, g_hooks;
static struct { int team; unsigned ver; int have; } g_mail[OB_NET_MAX_MACHINES];
static char g_seen_league[16];
static int g_seen_master = -1, g_seen_nteam = -1;
void *port_plg_cont, *port_cls_cont, *port_chd_cont, *port_lts_cont;
void *port_aht_cont, *port_mlf_cont;

static const char *game_root(void)
{
    const char *r = getenv("NHL95_ROOT");
    return r && r[0] ? r : ".";
}

static int exists_path(const char *p)
{
    struct stat st;
    return p && p[0] && stat(p, &st) == 0;
}

/* the open league's team table: PINFO.DB +20h (26 x 30 bytes, as WriteLeagueInfo writes it). At the desk the
   exhibition state is loaded and leagueteams may be another league's, so read the league's own file, at most
   every half second (and at once when the league changes). Falls back to leagueteams while it is being made. */
static int g_teams_gen, g_teams_seen_gen;

static void teams_invalidate(void)
{
    g_teams_gen++;
}

static const unsigned char *teams_tab(void)
{
    static unsigned char tab[0x30C];
    static char seen[32];
    static int age, have;
    const char *name = open_league();
    if (!name[0]) return leagueteams;
    if (g_teams_gen != g_teams_seen_gen) {
        age = 999;
        g_teams_seen_gen = g_teams_gen;
    }
    if (strcmp(seen, name) || ++age >= 30) {
        char path[600];
        FILE *f;
        age = 0;
        snprintf(seen, sizeof seen, "%s", name);
        snprintf(path, sizeof path, "%s/%s/PINFO.DB", g_root[0] ? g_root : game_root(), name);
        have = 0;
        f = fopen(path, "rb");
        if (f) {
            if (fseek(f, 0x20, SEEK_SET) == 0 && fread(tab, 1, sizeof tab, f) == sizeof tab) have = 1;
            fclose(f);
        }
    }
    return have ? tab : leagueteams;
}

static int team_human(int team)
{
    return team >= 0 && team < 26 && teams_tab()[team * 30 + 0x17] == 1;
}

static int team_remote(int team)
{
    return team_human(team) && teams_tab()[team * 30 + 0x18] == 2;
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

/* HD copy that still has a local human. leaguemaster is a team index (0 is valid), not a boolean.
 * In a room only the net host is master: a guest's installed PINFO still lists the host's local
 * teams, which must not make the guest look like the owner. */
static int is_master_copy(void)
{
    int i;
    if (g_net) return ob_net_is_host(g_net);
    for (i = 0; i < 26; i++)
        if (team_local(i)) return 1;
    return 0;
}

/* the team this guest already picked (overlay claim or the installed copy). -1 none. */
static int guest_mine(void)
{
    if (g_season.claim >= OB_SEASON_TEAMS) return g_season.claim - OB_SEASON_TEAMS;
    if (g_installed_team >= 0 && g_installed_team < 26) return g_installed_team;
    return -1;
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

/* the floppy Import Databases > Player reads (PLAYER.ID, GAME.SET, both .DB and .NN). */
static int copy_team_files(const char *from, const char *to, int team)
{
    const char *league = open_league();
    if (team < 0 || team >= 26 || !league[0]) return -1;
    return season_pack_floppy(from, to, team, league, 1);
}

static void open_as_league(const char *name, int team)
{
    if (!name || !name[0]) return;
    snprintf((char *)&curleague, 16, "%s", name);
    snprintf((char *)lgstate + 4, 16, "%s", name);
    g_installed_team = team;
}

static void take_pick_disk(const char *disk, int team)
{
    char name[16], dest[512];
    if (team < 0 || g_installed_team == team) return;
    if (season_install_floppy(disk, g_root[0] ? g_root : game_root(), name, (int)sizeof name)) return;
    snprintf(dest, sizeof dest, "%s/%s", g_root[0] ? g_root : game_root(), name);
    season_mark_imported(dest, team);
    season_write_player_id(dest, team, name);
    open_as_league(name, team);
}

static void host_clear_player_id(void)
{
    char dir[512], path[600];
    if (!is_master_copy() || league_host_dir(dir, (int)sizeof dir)) return;
    snprintf(path, sizeof path, "%s/PLAYER.ID", dir);
    UNLINK(path);
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

static int net_guest(void)
{
    return g_net && !ob_net_is_host(g_net);
}

static void mount_play(void)
{
    char dir[512], disk[512];
    int team;
    if (g_hold_a) return;               /* PlayLeagueGame is using A: as the other human's copy */
    host_clear_player_id();             /* master: GetLeagueId -1 so A vs B stays on the HD */
    /* CreateNewLeague strcpy's curleague, then asks schedule/database (frames tick here),
       then mkdir. ob_vdrive_mount mkdir's, so mounting A: on that path first makes the
       game's mkdir fail → "Error while creating league!". A guest's picked disk is A:
       even if a league of the same name is already open (Import Databases reads A:). */
    team = ob_season_disk(&g_season, -1, disk, (int)sizeof disk);
    if (team >= 0) {
        take_pick_disk(disk, team);
        if (!g_play_on || strcmp(g_play_dir, disk)) mount_a(disk);
        return;
    }
    if (net_guest()) {
        if (!league_host_dir(dir, (int)sizeof dir) && exists_path(dir)) {
            if (!g_play_on || strcmp(g_play_dir, dir)) mount_a(dir);
            return;
        }
        unmount_play();
        return;
    }
    /* host owns the league on HD: do not point A: at a leftover floppy pack.
     * Merge / Add Team would read that as "an old copy of the league". */
    if (is_master_copy()) {
        unmount_play();
        return;
    }
    if (league_host_dir(dir, (int)sizeof dir) || !exists_path(dir) || !has_human()) {
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
    int dest[OB_SEASON_TEAMS], i, mine;
    const char *name = open_league();
    (void)ud;
    memset(l, 0, sizeof *l);
    if (!name[0]) return -1;
    snprintf(l->name, sizeof l->name, "%s", name);
    if (strchr(l->name, '.')) *strchr(l->name, '.') = 0;      /* "ABDUL", not the folder ABDUL.LP */
    snprintf(l->id, sizeof l->id, "%s", name);
    /* in a room only the net host is master (a guest's PINFO still lists the host's local team) */
    if (g_net) l->master = ob_net_is_host(g_net) ? 1 : 0;
    else l->master = is_master_copy() ? 1 : 0;
    /* guest HELLO: only the claimed team. Listing every human makes Overbar give
       leftover remotes (San Jose) and the host's controller (Rangers) to that client. */
    mine = l->master ? -1 : guest_mine();
    l->nteam = season_own_teams(teams_tab(), 26, l->master, mine, dest, OB_SEASON_TEAMS);
    for (i = 0; i < l->nteam; i++) l->team[i] = dest[i];
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

static int op_import(void *ud, int team, const char *dir)
{
    char name[16], dest[512];
    (void)ud;
    if (team < 0 || team >= 26 || !dir) return -1;
    if (season_install_floppy(dir, g_root[0] ? g_root : game_root(), name, (int)sizeof name)) return -1;
    snprintf(dest, sizeof dest, "%s/%s", g_root[0] ? g_root : game_root(), name);
    if (season_mark_imported(dest, team)) return -1;
    open_as_league(name, team);
    restore_play();
    return 0;
}

__attribute__((naked)) static int watcall3(void *fn, uint32_t a, uint32_t d, uint32_t b)
{
    __asm__ volatile(
        "pushl %ebp\n\tmovl %esp, %ebp\n\tpushl %ebx\n\t"
        "movl 12(%ebp), %eax\n\tmovl 16(%ebp), %edx\n\tmovl 20(%ebp), %ebx\n\t"
        "call *8(%ebp)\n\t"
        "popl %ebx\n\tpopl %ebp\n\tret");
}

/* eax, edx, ebx, ecx, then one stack arg; Watcom pops it */
__attribute__((naked)) static int watcall5(void *fn, uint32_t a, uint32_t d, uint32_t b, uint32_t c,
                                           uint32_t s0)
{
    __asm__ volatile(
        "pushl %ebp\n\tmovl %esp, %ebp\n\tpushl %ebx\n\tpushl %esi\n\tpushl %edi\n\t"
        "pushl 28(%ebp)\n\t"
        "movl 12(%ebp), %eax\n\tmovl 16(%ebp), %edx\n\tmovl 20(%ebp), %ebx\n\tmovl 24(%ebp), %ecx\n\t"
        "call *8(%ebp)\n\t"
        "popl %edi\n\tpopl %esi\n\tpopl %ebx\n\tpopl %ebp\n\tret");
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

/* eax, edx, ebx, ecx, then three stack args; Watcom pops them */
__attribute__((naked)) static int watcall7(void *fn, uint32_t a, uint32_t d, uint32_t b, uint32_t c,
                                           uint32_t s0, uint32_t s1, uint32_t s2)
{
    __asm__ volatile(
        "pushl %ebp\n\tmovl %esp, %ebp\n\tpushl %ebx\n\tpushl %esi\n\tpushl %edi\n\t"
        "pushl 36(%ebp)\n\tpushl 32(%ebp)\n\tpushl 28(%ebp)\n\t"
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

/* the 26 team names (21 bytes each at +5 of every 2E8h-byte record, as ReadTeamNames reads them) from the
   picked team's disk TEAMS.DB, else the open league, else the game folder. treeteamnames is only loaded
   inside league screens, so at the desk it would say "Team 5". ob_season_disk returns the team index. */
static const char *names_tab(void)
{
    static char tab[26 * 22];
    static int age = -1, have, seen_disk = -2;
    int disk_team;
    char disk[512];
    disk_team = ob_season_disk(&g_season, -1, disk, (int)sizeof disk);
    if (disk_team != seen_disk) { age = -1; seen_disk = disk_team; }
    if (age < 0 || ++age >= 120) {
        char dir[512], path[600];
        FILE *f = NULL;
        int i;
        age = 0;
        if (disk_team >= 0) {
            snprintf(path, sizeof path, "%s/TEAMS.DB", disk);
            f = fopen(path, "rb");
        }
        if (!f && !league_host_dir(dir, (int)sizeof dir)) {
            snprintf(path, sizeof path, "%s/TEAMS.DB", dir);
            f = fopen(path, "rb");
        }
        if (!f) {
            snprintf(path, sizeof path, "%s/TEAMS.DB", g_root[0] ? g_root : game_root());
            f = fopen(path, "rb");
        }
        have = 0;
        if (f) {
            have = 1;
            for (i = 0; i < 26 && have; i++) {
                char *n = tab + i * 22;
                memset(n, 0, 22);
                if (fseek(f, (long)i * 0x2E8 + 5, SEEK_SET) || fread(n, 1, 21, f) != 21) have = 0;
            }
            fclose(f);
        }
    }
    return have ? tab : NULL;
}

/* NULL for CPU so Pick a team only lists humans (host-local + exported remotes) */
static const char *team_name(void *ud, int team)
{
    const char *t;
    (void)ud;
    if (team < 0 || team >= 26) return NULL;
    if (open_league()[0] && !team_human(team)) return NULL;
    /* a team the host's list does not name is one the host's game cannot add a player to (95 sets players
       up at New League only), so it is not a team to pick */
    if (g_net && !ob_net_is_host(g_net) && g_season.roster_have && g_season.roster_kind[team] == OB_SEASON_FREE)
        return NULL;
    t = names_tab();
    if (t && t[team * 22]) return t + team * 22;
    return (const char *)(treeteamnames + team * 21);
}

/* the player the host set this team up for at New League (played on another computer) */
static const char *op_player(void *ud, int team)
{
    static char name[12];
    (void)ud;
    if (!team_remote(team)) return NULL;
    memcpy(name, teams_tab() + team * 30, 11);
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
    if (!g_net || ob_net_send(g_net, to, OB_NET_TYPE_SEASON, data, size)) g_season.send_failed++;
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
    static char last[400];
    char line[400];
    int nteam = 0;
    if (!lp || !lp[0]) return;
    memset(&l, 0, sizeof l);
    if (name[0] && op_league(NULL, &l) == 0) nteam = l.nteam;
    snprintf(line, sizeof line, "TEST season league=%s master=%d nteam=%d gamemode=%d net=%d host=%d state=%d asked=%u answered=%u "
             "notsent=%u roster=%d:%s why=%s\n",
             name && name[0] ? name : "-", is_master_copy() ? 1 : 0, nteam, (int)gamemode,
             g_net ? 1 : 0, g_net ? ob_net_is_host(g_net) : -1, g_net ? (int)ob_net_state(g_net) : -1,
             g_season.asked, g_season.answered, g_season.send_failed, g_season.roster_have,
             g_season.roster_league[0] ? g_season.roster_league : "-", g_season.why[0] ? g_season.why : "-");
    if (!strcmp(line, last)) return;
    snprintf(last, sizeof last, "%s", line);
    f = fopen(lp, "ab");
    if (!f) return;
    fputs(line, f);
    fclose(f);
    fputs(line, stderr);
}

static int team_of_rec(const char *rec)
{
    int i;
    const unsigned char *t = teams_tab();
    if (!rec) return -1;
    for (i = 0; i < 26; i++)
        if (memcmp(t + i * 30, rec, 11) == 0) return i;
    return -1;
}

static int machine_of_team(int team)
{
    int kind[OB_SEASON_TEAMS], k;
    char who[OB_SEASON_TEAMS][OB_NET_NAME + 1];
    if (!g_net || team < 0 || team >= 26) return -1;
    if (team_local(team)) return ob_net_me(g_net);
    if (g_season.claim == OB_SEASON_TEAMS + team) return ob_net_me(g_net);
    if (ob_net_is_host(g_net)) {
        if (ob_season_roster(&g_season, kind, who)) return -1;
        if (kind[team] == OB_SEASON_HOSTS) return 0;
        if (kind[team] != OB_SEASON_OWNED && kind[team] != OB_SEASON_WAITING) return -1;
        for (k = 0; k < OB_NET_MAX_MACHINES; k++)
            if ((ob_net_members(g_net) >> k & 1) && who[team][0] &&
                strcmp(ob_net_name_of(g_net, k), who[team]) == 0)
                return k;
        return -1;
    }
    if (!g_season.roster_have) return -1;
    if (g_season.roster_kind[team] == OB_SEASON_HOSTS) return 0;
    if (g_season.roster_kind[team] == OB_SEASON_OWNED && g_season.roster[team][0]) {
        for (k = 0; k < OB_NET_MAX_MACHINES; k++)
            if ((ob_net_members(g_net) >> k & 1) &&
                strcmp(ob_net_name_of(g_net, k), g_season.roster[team]) == 0)
                return k;
    }
    return -1;
}

static int mine_team(void)
{
    if (g_season.claim >= OB_SEASON_TEAMS) return g_season.claim - OB_SEASON_TEAMS;
    return lgplayteam;
}

static int team_on_hd(int team)
{
    return team >= 0 && team < 26 && (teams_tab()[team * 30 + 0x16] & 1);
}

/* File > Import Databases > Player, then Merge & Update, without the clicks.
 * Merge first (into this copy's .DB); only copy the incoming files over if merge
 * cannot run, so a merged schedule is not overwritten. */
static int import_from_dir(const char *dir)
{
    char dest[512];
    int team, mine;
    if (!dir || season_player_id(dir, &team, NULL) || league_host_dir(dest, (int)sizeof dest)) return -1;
    mine = mine_team();
    if (team == mine) return 0;
    if (!exists_path(dest)) return -1;
    if (op_merge(NULL, team, dir, NULL, 0) == 0)
        return season_mark_imported(dest, team);
    return season_import_team(dir, dest, team);
}

static int wait_mirror(int from, char *dir, int size)
{
    while (!quit_requested) {
        netplay_pump();
        if (ob_season_mirror(&g_season, from, dir, size)) return 0;
        plat_sleep_ms(2);
    }
    return -1;
}

static int find_floppy(char *file, char *name, char *dir)
{
    return watcall3((void *)FindLeagueFloppy, (uint32_t)(uintptr_t)file, (uint32_t)(uintptr_t)name,
                    (uint32_t)(uintptr_t)dir);
}

int port_wait_floppy(char *file, char *name, char *dir)
{
    char lg[512], pid[600], mdir[512];
    const char *lgname = open_league();
    int team = team_of_rec(name), other, me, mine, r;
    g_hold_a = 1;
    if (team < 0) return find_floppy(file, name, dir);
    me = g_net ? ob_net_me(g_net) : 0;
    other = machine_of_team(team);
    mine = mine_team();
    if (g_net && other >= 0 && other != me && !team_on_hd(team)) {
        unsigned others = ob_net_members(g_net) & ~(1u << me);
        if (!league_host_dir(lg, (int)sizeof lg) && lgname[0] && mine >= 0 && mine < 26)
            season_write_player_id(lg, mine, lgname);
        if (others) ob_season_mirror_send(&g_season, others);
        if (is_master_copy() && !league_host_dir(lg, (int)sizeof lg)) {
            snprintf(pid, sizeof pid, "%s/PLAYER.ID", lg);
            UNLINK(pid);
        }
        /* the other human's export, as Import Databases > Player reads a floppy: both
         * teams' DBs are on this machine for the game (C vs D with the host away). */
        if (wait_mirror(other, mdir, (int)sizeof mdir) == 0) {
            import_from_dir(mdir);
            mount_a(mdir);
            return find_floppy(file, name, dir);
        }
    }
    if (!league_host_dir(lg, (int)sizeof lg) && exists_path(lg) && lgname[0]) {
        season_write_player_id(lg, team, lgname);
        mount_a(lg);
        r = find_floppy(file, name, dir);
        if (is_master_copy()) {
            snprintf(pid, sizeof pid, "%s/PLAYER.ID", lg);
            UNLINK(pid);
        }
        return r;
    }
    return find_floppy(file, name, dir);
}

__attribute__((naked)) static void wait_floppy_entry(void)
{
    __asm__ volatile(
        "pushal\n\tpushl %ebx\n\tpushl %edx\n\tpushl %eax\n\t"
        "call " SYM("port_wait_floppy") "\n\taddl $12, %esp\n\t"
        "movl %eax, 28(%esp)\n\tpopal\n\tret");
}

void port_playleague_enter(void) { g_in_league = 1; g_hold_a = 1; }

void port_playleague_exit(void)
{
    g_in_league = 0;
    port_season_after_game();
}

__attribute__((naked)) static void playleague_entry(void)
{
    __asm__ volatile(
        "pushal\n\tcall " SYM("port_playleague_enter") "\n\tpopal\n\t"
        "pushl $1f\n\tpushl $0xC4\n\tjmp *" SYM("port_plg_cont") "\n"
        "1:\n\tpushal\n\tcall " SYM("port_playleague_exit") "\n\tpopal\n\tret");
}

__attribute__((naked)) static int check_orig_tramp(void)
{
    __asm__ volatile("pushl $0xD8\n\tjmp *" SYM("port_cls_cont"));
}

__attribute__((naked)) static int copy_orig_tramp(void)
{
    __asm__ volatile("pushl $0xE4\n\tjmp *" SYM("port_chd_cont"));
}

__attribute__((naked)) static int lts_orig_tramp(void)
{
    __asm__ volatile("pushl $0x2B4\n\tjmp *" SYM("port_lts_cont"));
}

int port_check_disk(char *dir, char *teams, int team, int sync, int probe)
{
    char dest[512];
    unsigned char *rec = (teams && team >= 0 && team < 26) ? (unsigned char *)teams + team * 30 : NULL;
    if (!sync && rec && rec[0x17] == 1) {
        if (season_next_game_pick((unsigned char *)teams, team, net_guest(),
                                 net_guest() ? guest_mine() : -1))
            return 4;   /* not this machine's pick: no import box */
        if (!league_host_dir(dest, (int)sizeof dest))
            season_mark_imported(dest, team);
        else if (dir && dir[0])
            season_mark_imported(dir, team);
        teams_invalidate();
    }
    return watcall5((void *)check_orig_tramp, (uint32_t)(uintptr_t)dir, (uint32_t)(uintptr_t)teams,
                    (uint32_t)team, (uint32_t)sync, (uint32_t)probe);
}

__attribute__((naked)) static void check_entry(void)
{
    __asm__ volatile(
        "pushal\n\t"
        "pushl 36(%esp)\n\tpushl %ecx\n\tpushl %ebx\n\tpushl %edx\n\tpushl %eax\n\t"
        "call " SYM("port_check_disk") "\n\taddl $20, %esp\n\t"
        "movl %eax, 28(%esp)\n\tpopal\n\tret $4");
}

int port_copy_human(char *dir, unsigned char *teams, int which)
{
    unsigned char saved[26];
    char from[512], floppy[512], work[512];
    const char *lg = open_league();
    int t, r;
    if (!lg[0] && dir) lg = dir;
    snprintf(work, sizeof work, "%s", g_work[0] ? g_work : "overbar-season");
    MKDIR(work);
    if (dir && dir[0] && g_root[0] && !strchr(dir, '/') && !strchr(dir, '\\'))
        snprintf(from, sizeof from, "%s/%s", g_root, dir);
    else
        snprintf(from, sizeof from, "%s", dir ? dir : "");
    for (t = 0; t < 26; t++) {
        saved[t] = teams ? teams[t * 30 + 0x17] : 0;
        if (!teams || saved[t] != 1) continue;
        if (which >= 0 && which != t) continue;
        if (teams[t * 30 + 0x18] != 2 || (teams[t * 30 + 0x16] & 1)) continue;
        snprintf(floppy, sizeof floppy, "%s/export-%02d", work, t);
        MKDIR(floppy);
        season_pack_floppy(from[0] ? from : dir, floppy, t, lg, 1);
        teams[t * 30 + 0x17] = 0;    /* original skips insert-disk for remotes */
    }
    r = watcall3((void *)copy_orig_tramp, (uint32_t)(uintptr_t)dir, (uint32_t)(uintptr_t)teams,
                 (uint32_t)which);
    for (t = 0; t < 26; t++)
        if (teams) teams[t * 30 + 0x17] = saved[t];
    teams_invalidate();
    return r;
}

__attribute__((naked)) static void copy_entry(void)
{
    __asm__ volatile(
        "pushal\n\tpushl %ebx\n\tpushl %edx\n\tpushl %eax\n\t"
        "call " SYM("port_copy_human") "\n\taddl $12, %esp\n\t"
        "movl %eax, 28(%esp)\n\tpopal\n\tret");
}

void port_league_team_select(char *dir, int *humans, char *names, unsigned char *teams,
                             int mode, char *title, int *picks)
{
    unsigned char saved[26];
    int i, mine, hide = (mode == 8 && net_guest() && teams);
    mine = hide ? guest_mine() : -1;
    if (hide) {
        for (i = 0; i < 26; i++) {
            saved[i] = teams[i * 30 + 0x17];
            /* full 26-crest grid stays; only this machine's team keeps the name / click */
            if (saved[i] != 1) continue;
            if (mine >= 0) {
                if (i != mine) teams[i * 30 + 0x17] = 0;
            } else if (teams[i * 30 + 0x18] != 2)
                teams[i * 30 + 0x17] = 0;
        }
    }
    watcall7((void *)lts_orig_tramp, (uint32_t)(uintptr_t)dir, (uint32_t)(uintptr_t)humans,
             (uint32_t)(uintptr_t)names, (uint32_t)(uintptr_t)teams,
             (uint32_t)mode, (uint32_t)(uintptr_t)title, (uint32_t)(uintptr_t)picks);
    if (hide)
        for (i = 0; i < 26; i++) teams[i * 30 + 0x17] = saved[i];
}

__attribute__((naked)) static void lts_entry(void)
{
    __asm__ volatile(
        "pushal\n\t"
        "pushl 44(%esp)\n\tpushl 44(%esp)\n\tpushl 44(%esp)\n\t"
        "pushl %ecx\n\tpushl %ebx\n\tpushl %edx\n\tpushl %eax\n\t"
        "call " SYM("port_league_team_select") "\n\taddl $28, %esp\n\t"
        "popal\n\tret $12");
}

__attribute__((naked)) static int watcall0(void *fn)
{
    __asm__ volatile(
        "pushl %ebp\n\tmovl %esp, %ebp\n\t"
        "call *8(%ebp)\n\t"
        "popl %ebp\n\tret");
}

__attribute__((naked)) static int aht_orig_tramp(void)
{
    __asm__ volatile("pushl $0x74\n\tjmp *" SYM("port_aht_cont"));
}

__attribute__((naked)) static int mlf_orig_tramp(void)
{
    __asm__ volatile("pushl $0x8C\n\tjmp *" SYM("port_mlf_cont"));
}

static int pinfo_flags13(unsigned *val, int write)
{
    char dest[512], path[600];
    FILE *f;
    unsigned char b[2];
    if (!val || league_host_dir(dest, (int)sizeof dest)) return -1;
    snprintf(path, sizeof path, "%s/PINFO.DB", dest);
    f = fopen(path, write ? "r+b" : "rb");
    if (!f) return -1;
    if (fseek(f, 0x13, SEEK_SET) != 0) { fclose(f); return -1; }
    if (!write) {
        if (fread(b, 1, 2, f) != 2) { fclose(f); return -1; }
        *val = (unsigned)b[0] | (unsigned)b[1] << 8;
    } else {
        b[0] = (unsigned char)*val;
        b[1] = (unsigned char)(*val >> 8);
        if (fwrite(b, 1, 2, f) != 2) { fclose(f); return -1; }
    }
    fclose(f);
    return 0;
}

/* host owns the league: skip "master must be imported" / merge-from-floppy. */
void port_add_human_team(void)
{
    unsigned old = 0, merged = 4;
    int patched = 0;
    if (is_master_copy() && pinfo_flags13(&old, 0) == 0 && pinfo_flags13(&merged, 1) == 0)
        patched = 1;
    watcall0((void *)aht_orig_tramp);
    if (patched) {
        pinfo_flags13(&old, 1);
        leagueflags = (unsigned char)old;
        teams_invalidate();
    }
}

int port_merge_league(void)
{
    if (is_master_copy()) {
        byte_DE268 = 0;
        return 0;
    }
    return watcall0((void *)mlf_orig_tramp);
}

__attribute__((naked)) static void aht_entry(void)
{
    __asm__ volatile(
        "pushal\n\tcall " SYM("port_add_human_team") "\n\t"
        "popal\n\tret");
}

__attribute__((naked)) static void mlf_entry(void)
{
    __asm__ volatile(
        "pushal\n\tcall " SYM("port_merge_league") "\n\t"
        "movl %eax, 28(%esp)\n\tpopal\n\tret");
}

static void patch_export_question(void)
{
    static char q1[] = "Make this a remote team for";
    static char q2[] = "a player on another device?";
    *(char **)exportmsg = q1;
    *(char **)(exportmsg + 8) = q2;
}

static int entry_push(const char *fn, uint32_t n)
{
    const uint8_t *p = (const uint8_t *)fn;
    uint32_t v;
    memcpy(&v, p + 1, 4);
    return p[0] == 0x68 && v == n;
}

static void install_hooks(void)
{
    if (g_hooks) return;
    if (entry_push(WaitLeagueFloppy, 0x74)) patch_jmp(WaitLeagueFloppy, wait_floppy_entry);
    if (entry_push(PlayLeagueGame, 0xC4)) {
        port_plg_cont = PlayLeagueGame + 5;
        patch_jmp(PlayLeagueGame, playleague_entry);
    }
    if (entry_push(CheckLeagueDiskSync, 0xD8)) {
        port_cls_cont = CheckLeagueDiskSync + 5;
        patch_jmp(CheckLeagueDiskSync, check_entry);
    }
    if (entry_push(CopyHumanTeamDBs, 0xE4)) {
        port_chd_cont = CopyHumanTeamDBs + 5;
        patch_jmp(CopyHumanTeamDBs, copy_entry);
    }
    if (entry_push(LeagueTeamSelect, 0x2B4)) {
        port_lts_cont = LeagueTeamSelect + 5;
        patch_jmp(LeagueTeamSelect, lts_entry);
    }
    if (entry_push(AddHumanTeam, 0x74)) {
        port_aht_cont = AddHumanTeam + 5;
        patch_jmp(AddHumanTeam, aht_entry);
    }
    if (entry_push(MergeLeagueFiles, 0x8C)) {
        port_mlf_cont = MergeLeagueFiles + 5;
        patch_jmp(MergeLeagueFiles, mlf_entry);
    }
    patch_export_question();
    g_hooks = 1;
}

void port_season_install_hooks(void)
{
    install_hooks();
}

static void auto_sync(void)
{
    int st;
    if (!net_guest() || !open_league()[0] || ob_season_busy(&g_season)) return;
    st = g_season.state;
    if (st != OB_SEASON_IDLE && st != OB_SEASON_SYNCED && st != OB_SEASON_FAILED) return;
    /* guest export → host MergeTeamDbs / MergeScheduleDb → copy back. File > Merge & Update is this. */
    if (!g_join_sync || g_season.nplayed > 0) {
        if (ob_season_sync(&g_season, 0) == 0) g_join_sync = 1;
    }
}

/* File > Export / Import / Merge & Update, without the clicks: keep other guests' teams on this PC. */
static void mail_copies(void)
{
    static int age;
    int me, k, team, mine;
    unsigned others, ver;
    char mdir[512], dest[512];
    const char *lgname;
    if (!net_guest() || g_in_league || ob_season_busy(&g_season)) return;
    lgname = open_league();
    if (!lgname[0]) return;
    me = ob_net_me(g_net);
    others = ob_net_members(g_net) & ~(1u << me) & ~1u;
    if (!others) return;
    mine = mine_team();
    for (k = 1; k < OB_NET_MAX_MACHINES; k++) {
        if (k == me || !(ob_net_members(g_net) >> k & 1)) continue;
        if (!ob_season_mirror(&g_season, k, mdir, (int)sizeof mdir)) continue;
        ver = 0;
        if (season_player_id(mdir, &team, &ver)) continue;
        if (team == mine) continue;
        if (g_mail[k].have && g_mail[k].team == team && g_mail[k].ver == ver) continue;
        if (import_from_dir(mdir) == 0) {
            g_mail[k].team = team;
            g_mail[k].ver = ver;
            g_mail[k].have = 1;
        }
    }
    if (ob_files_busy(&g_files, -1)) return;
    if (++age < 120) return;
    age = 0;
    if (!league_host_dir(dest, (int)sizeof dest) && mine >= 0 && mine < 26)
        season_write_player_id(dest, mine, lgname);
    ob_season_mirror_send(&g_season, others);
}

int port_season_want_online(void)
{
    int opp, me;
    if (!g_net || gamemode != 2) return 0;
    if (!dword_DDD3C) return 0;
    me = ob_net_me(g_net);
    opp = machine_of_team(dword_DDD34);
    if (opp < 0 || opp == me) return 0;
    /* C vs D: both guests. Export one copy, import on this machine, play here. */
    if (me != 0 && opp != 0) return 0;
    return 1;
}

void port_season_after_game(void)
{
    char dest[512];
    int mine, k;
    if (g_in_league) return;            /* PlayLeagueGame still posting into savleague1/2 */
    if (gamemode == 2 && lggameidx >= 0) ob_season_played(&g_season, (uint32_t)(uint16_t)lggameidx);
    /* export this copy so the other guest can import the result (the return mail) */
    if (net_guest() && g_net) {
        unsigned others = ob_net_members(g_net) & ~(1u << ob_net_me(g_net)) & ~1u;
        mine = mine_team();
        if (!league_host_dir(dest, (int)sizeof dest) && open_league()[0] && mine >= 0 && mine < 26)
            season_write_player_id(dest, mine, open_league());
        if (others) ob_season_mirror_send(&g_season, others);
        for (k = 1; k < OB_NET_MAX_MACHINES; k++) {
            char mdir[512];
            if (ob_season_mirror(&g_season, k, mdir, (int)sizeof mdir)) import_from_dir(mdir);
        }
        if (!ob_season_busy(&g_season)) ob_season_sync(&g_season, 0);
    }
    ob_season_mirror_drop(&g_season);
    memset(g_mail, 0, sizeof g_mail);
    g_hold_a = 0;
    restore_play();
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
    ops.give_as_disk = 0;           /* pick installs the copy; the calendar opens it */
    me = h->online.name[0] ? h->online.name : "player";
    ob_files_init(&g_files, files_send, NULL);
    ob_season_init(&g_season, &ops, g_work, me, &g_files, season_send, NULL);
    ob_season_set(h, &g_season, 0, NULL);
    ob_season_set_names(h, team_name, NULL);
    ob_season_set_hint(h, NULL);
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
    memset(g_mail, 0, sizeof g_mail);
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
    {   /* OVERBAR_TEST_LOG: a guest asks for the league list every ~2 s with no page open (headless checks) */
        static int t;
        const char *lp = getenv("OVERBAR_TEST_LOG");
        if (lp && lp[0] && g_net && !ob_net_is_host(g_net) && ++t >= 120) { t = 0; ob_season_teams(&g_season, 0); }
    }
    auto_sync();
    mail_copies();
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
