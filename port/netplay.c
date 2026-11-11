/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * Online play: two machines run the same game in lockstep with Overbar's netplay core (overbar/net.h). Nothing is saved or
 * loaded: the game's simulation reads its pads only through the input records of joyqueue (3 bytes: pad 1, pad 2, hot key),
 * one record per 3 game frames, so the same records give the same game on both machines.
 *
 *   - SampleInputTick (the timer callback that pushes a record every 5 ticks) is taken over during a session: this machine's own
 *     pad and hot key are its buttons for the next step (ob_net_step); once the step has every machine's buttons, the merged
 *     record (host's pad as pad 1, guest's as pad 2, the hot keys that are safe online) goes into a queue of this file.
 *   - joyq_peek / joyq_pop / joyq_flush read that queue instead of the game's. A missing record stalls the game as it always
 *     did (RunGameFrames only draws). joyq_flush does nothing: the records are the same on both machines, but how many of them
 *     are waiting at a given moment is not.
 *   - RunGameFrames runs at most to the end of the record it is on, and says (in edx) how many frames it really ran, so the
 *     code that runs between calls (the pre-game intro's timer and its "press a button to skip" test) sees the same game.
 *
 * Host / Connect opens a room at once (port_season_bind_net), so overlay Pick / Sync have the socket before a
 * game. PlayGame of a new exhibition, season, or playoff (handle < 0, gamemode 0/1/2) shows Overbar's select-sides
 * screen (every connected controller; the same module online) and then begins a match in that room. A loaded game
 * stays local. A season game vs the computer or two humans on this machine stays local even if the room is up.
 * Two humans on different machines (C vs D) play in the room: each controls their team; a watching host
 * only forwards. The match ends with PlayGame; the season room lasts until Leave.
 *
 * In a session (docs/SDL2_PORT.md, "Online play"):
 *   - the engine's random seed (randomd0's `seed`) and the C library's are the host's; Crowd_Noise, which draws from `seed`
 *     between game frames, gives back what it drew; DOS get-time (int 21h/2Ch) counts from the host's time by the records run;
 *   - PaSpeechBusy and SpeechBusy say 0 (the play does not wait for the announcer, whose speed is the sound card's);
 *   - hot keys online: F1-F8 (line changes), F9 / F10 (goalie), Tab (numbers); F1-F10 of a team this machine has no
 *     seat on are dropped (ob_sides_hotkeys_filter). Esc (the desk), R (replay), S and M (sound) are
 *     dropped: they open local menus or change local settings;
 *   - the pre-game intro and the three stars end at their first record; the intermission between periods is skipped.
 * The game thread runs the hooks; SampleInputTick runs inside the game's timer interrupt, so it never waits for the lock.
 * The main thread polls the socket (netplay_main_poll) so it keeps going while the game waits. */
#include "host.h"
#include "snap.h"
#include "overbar_client.h"
#include "feel.h"
#include "season.h"
#include "sides.h"
#include "pads4.h"
#include "overbar/sides.h"
#include <SDL.h>
#include <time.h>

#define NH_PADS 4                       /* a seat a pad: the game's pads 1 and 2, then pads 3 and 4 (pads4.c) */
extern int joyrec;

#ifdef _WIN32
#define SYM(s) "_" s
#else
#define SYM(s) s
#endif
#ifndef NHL95_BUILD
#define NHL95_BUILD "unknown"
#endif
#define GAME_ADDR(orig) ((uint8_t *)sub_10000 + ((orig) - 0x10000))

/* ---- the game's data and code ---- */
extern uint32_t joysampling, inputticks, inputframes, joyrawbits, gamemode, gameopts, samesideflag, sounddev;
extern uint32_t ctl1side, ctl2side, ctl1dev, ctl2dev, seed;
extern int32_t ctl1team, ctl2team, curperiod;
extern int16_t HomeTeam, VisTeam, cont1team, cont2team, gameover;
extern uint16_t PerTimeTab[];
extern uint8_t pad1dev, pad2dev, musicon;
extern uint8_t SortCords[], hmtmstruct[], hmlinetab[], awlinetab[];
extern uint16_t gameclock, clockticks, gsp, lj1, lj2, crowdlevel;
extern char SampleInputTick[], joyq_peek[], joyq_pop[], joyq_flush[], RunGameFrames[], PlayGame[], PaSpeechBusy[], SpeechBusy[];
extern char Crowd_Noise[], IntermissionPC[], ThreeStarsLoop[], ReadJoy1[], ReadJoy2[], ReadControllerPad[], ReadHotKeys[], sub_B3464[];
extern char InitGameSummary[];

#define RJ1_SITE 0x48205u           /* PreGameIntro_frameloop: call ReadJoy1 (a button skips the intro / the three stars) */
#define RJ2_SITE 0x4822Fu           /* call ReadJoy2 */
#define RJ_SKIP 0x4821Au            /* .4: introskipped = 1, fadeinpending = 1, to PreGameIntro_end */
#define RJ_NONE 0x48244u            /* call WaitTickDeadline: no button */

/* ---- the state ----
 * nh_sim: a session's records drive the game (the hooks are on); set and cleared by the game thread only.
 * nh_take: this machine's input goes to the session (cleared when the session ends; the game then plays on locally). */
volatile int nh_sim, nh_take;
volatile const char *nh_where = "";     /* what the game thread does under nh_lock (for the log when the main thread cannot get it) */
volatile int nh_rb, nh_quiet;           /* rollback is on in this session; a replay is running (nothing is shown) */
static volatile int nh_due;             /* rollback: records the timer says are due, not yet made */
void *nh_peek_cont, *nh_pop_cont, *nh_flush_cont, *nh_rgf_cont, *nh_pg_cont, *nh_pab_cont, *nh_spb_cont, *nh_crowd_cont,
     *nh_inter_cont, *nh_tsl_cont, *nh_sit_cont, *nh_readjoy1, *nh_readjoy2;

static SDL_mutex *nh_lock;
static ob_net *nh_net;                  /* the hockey match (same object as the season room) */
static ob_net *nh_room;                 /* Host / Connect season room */
static int nh_ok;                       /* the hooks are in */
static volatile int nh_armed;           /* Host / Connect: the room is up; the next new game is a match */
static ob_online nh_cfg;
static char nh_why[128];                /* why the last session ended or did not start */
static volatile int nh_dead, nh_me;     /* the session has ended mid-game; this machine's pad (0 host, 1 guest) */
static volatile int nh_want_page, nh_close_page, nh_opened_page;
static volatile int nh_finish;          /* the game is over and its three stars have ended: the rest (the post-game desk) is local */

#define ST_DATA_LO 0xC0000u
#define RING 64
#define QMAX 50                         /* as joyqueue */
static uint8_t nh_ring[RING][5];      /* pad 1, pad 2, hot key (the game's record), pads 3 and 4 (pads4.c) */
static volatile uint32_t nh_head, nh_tail;      /* records taken by the game / made; head written by the game, tail by the timer */
static volatile uint32_t nh_consumed;           /* records the game has finished in this session */
static int nh_cadence, nh_pending;
static uint16_t nh_local[OB_NET_MAX_PADS];
static uint32_t nh_loop_mark, nh_rgf_pops0, nh_rgf_f0, nh_rgf_asked;
static int nh_rgf_carry, nh_rgf_total;
static uint32_t nh_clock;               /* the host's time of day when the session began, in seconds */

/* the machine's own game set-up, put back when the session's game is over */
static struct {
    int16_t home, vis;
    uint32_t gamemode, gameopts, ctl1side, ctl2side, ctl1dev, ctl2dev;
    int32_t ctl1team, ctl2team;
    uint16_t pertime;
} nh_saved;

/* the host's settings, sent to the guest before the first step */
typedef struct nh_settings {
    uint32_t magic, version;
    int32_t home, vis;
    uint32_t gamemode, gameopts;
    int32_t ctl1team, ctl2team;
    uint32_t ctl1side, ctl2side;
    uint32_t seed, randseed;
    uint32_t pertime, clock;
    char game[512];                     /* the Game page's online options (ob_game_pack): the host's feel */
} nh_settings;
#define NH_MAGIC 0x4F353948u            /* "H95O" */
#define NH_VERSION 2                    /* 2: the Game page's options */

static uint32_t *randseed_ptr(void)       /* sub_8EB21: mov eax, randseed (the C library's rand state) */
{
    const uint8_t *p = GAME_ADDR(0x8EB21u);
    uint32_t a;
    if (p[0] != 0xB8) return NULL;
    memcpy(&a, p + 1, 4);
    return (uint32_t *)(uintptr_t)a;
}

/* a game routine with the Watcom register convention: eax and edx in, eax out */
__attribute__((naked)) static uint32_t game_call(void *fn, uint32_t a, uint32_t d)
{
    __asm__ volatile(
        "pushl %ebp\n\tmovl %esp, %ebp\n\tpushl %ebx\n\tpushl %esi\n\tpushl %edi\n\t"
        "movl 12(%ebp), %eax\n\tmovl 16(%ebp), %edx\n\tcall *8(%ebp)\n\t"
        "popl %edi\n\tpopl %esi\n\tpopl %ebx\n\tpopl %ebp\n\tret");
}

/* SetupControllers, for the values the play reads: which team each controller plays and its device (pad1dev: 1 mouse,
 * 2 stick A, 4 stick B, 8 keyboard, 0 none) */
static uint8_t pad_dev(uint32_t ctl) { return ctl == 1 || ctl == 2 || ctl == 4 || ctl == 8 ? (uint8_t)ctl : 0; }
static void setup_controllers(void)
{
    cont1team = ctl1team < 0 ? 0 : ctl1side == 0 ? 1 : 2;
    cont2team = ctl2team < 0 ? 0 : ctl2side == 0 ? 1 : 2;
    samesideflag = ctl1side == ctl2side;
    pad1dev = pad_dev(ctl1dev);
    pad2dev = pad_dev(ctl2dev);
}

/* ---- the queue of merged records ---- */
static int hot_ok(unsigned h)           /* hot keys that change only the game, the same way on both machines */
{
    if (!(h & 0x80)) return 0;
    h &= 0x7F;
    return h == 0x0F || (h >= 0x3B && h <= 0x44);   /* Tab: numbers; F1-F8: lines; F9, F10: goalie */
}

static void push_merged(const uint16_t *all)
{
    uint8_t *r = nh_ring[nh_tail % RING];
    static const int at[4] = { 0, 1, 3, 4 };        /* game slot -> byte of the record */
    int p;
    r[0] = r[1] = r[3] = r[4] = 8;
    r[2] = 0;
    for (p = 0; p < NH_PADS; p++) {
        int slot = port_sides_slot_of_seat(p);
        unsigned h = all[p] >> 8;
        if (slot < 0 || slot > 3) continue;
        r[at[slot]] = (uint8_t)((all[p] & 0xFF) ^ 8);   /* sent as pad ^ 8: the steps before the first ones given (all 0) are "no direction" (8) */
        if (!r[2] && hot_ok(h)) r[2] = (uint8_t)h;
    }
    nh_tail++;
}

/* this machine's pad and hot key, as ReadControllerPad and ReadHotKeys give them (0 while the overlay is open) */
static uint16_t read_pad(int p)                 /* p: the seat; its game slot reads the device */
{
    uint8_t pad = 8, hot = 0;
    static int autopad = -1;
    if (autopad < 0) autopad = getenv("NHL95_AUTOPAD") != NULL;
    if (autopad) return (uint16_t)(((((uint32_t)nh_tail / 6 + (uint32_t)p * 3) * 2654435761u) >> 20) & 7);       /* (a test aid: a direction held for six records) */
    if (overbar_client_open() || port_sides_is_open()) return 0;
    p = port_sides_slot_of_seat(p);
    if (p >= 2) return (uint16_t)(pads4_local_byte(p - 2) ^ 8);   /* pads 3 and 4: a controller of this machine; no hot keys */
    if (p < 0) return 0;
    if ((p ? pad2dev : pad1dev) & 6) joyrawbits = game_call(sub_B3464, 0, 0);
    game_call(ReadControllerPad, (uint32_t)p, (uint32_t)(uintptr_t)&pad);
    game_call(ReadHotKeys, (uint32_t)(uintptr_t)&hot, 0);
    if (hot) {
        unsigned sc = port_sides_filter_hot((unsigned)hot & 0x7Fu, nh_net ? ob_net_me(nh_net) : 0);
        hot = sc ? (uint8_t)(sc | 0x80u) : 0;
    }
    return (uint16_t)((pad ^ 8) | (hot << 8));
}

static void fill_local(void)
{
    unsigned mine = nh_net ? ob_net_my_pads(nh_net) : 1u;
    int i = 0, p;
    memset(nh_local, 0, sizeof nh_local);
    for (p = 0; p < OB_NET_MAX_PADS && i < OB_NET_MAX_PADS; p++) {
        if (!(mine & (1u << p))) continue;
        nh_local[i++] = read_pad(p);
    }
}

/* ---- NHL95_SNAPTEST: a round trip of a state of the game, with no network (docs/SDL2_PORT.md "Rollback") ----
 * An exhibition game started with NHL95_SNAPTEST set plays on records made here (a function of the record's number), as a
 * session would. At record ST_SAVE a state is taken; at record ST_BACK the game goes back to it and plays the same records
 * again; at ST_BACK again the game's data (and the record queue) must hash as they did the first time. */
#define ST_SAVE 40u
#define ST_BACK 100u
static int nh_selftest, st_phase;
static void *st_jb[5];
static snap st_snap;
static uint64_t st_sim, st_all;
static int st_vif;
static uint8_t *st_copy;                         /* the game's data as it was at the second record, the first time */
#define ST_DATA_HI 0xFAB90u
static snap_region st_extra[16];
static int st_nextra;
extern volatile int vif;
static uint64_t sim_hash(void);

static void st_regions(void)
{
    int n = 0;
#define X(v) do { st_extra[n].p = (void *)&(v); st_extra[n].n = sizeof (v); n++; } while (0)
    X(nh_ring); X(pads4); X(nh_head); X(nh_tail); X(nh_consumed); X(nh_cadence); X(nh_pending); X(nh_local); X(nh_loop_mark);
    X(nh_rgf_pops0); X(nh_rgf_f0); X(nh_rgf_asked); X(nh_rgf_carry); X(nh_rgf_total); X(nh_finish);
#undef X
    st_extra[n].p = sub_10000; st_extra[n].n = ST_DATA_LO - 0x10000; n++;        /* the game's code too: it patches itself */
    st_nextra = n;
}

static void st_record(uint16_t *all)           /* the record with this number: a direction held for six records, no fire */
{
    uint32_t i = nh_tail;
    if (st_phase == 3) { all[0] = nh_local[0]; all[1] = 0; return; }       /* the test is over: the player's own pad plays on */
    all[0] = (uint16_t)(((i / 6) * 2654435761u >> 20) & 7);
    all[1] = (uint16_t)(((i / 9 + 3) * 2246822519u >> 20) & 7);
}

static uint64_t st_fingerprint(void) { return snap_hash(st_extra, st_nextra); }

static snap_region st_regs[SNAP_MAX_REGIONS];
static int st_nregs;
static void st_copy_all(void)                   /* every region as it is now, for st_diff_all */
{
    size_t total = 0, at = 0;
    int i;
    st_nregs = snap_regions(st_regs, SNAP_MAX_REGIONS - st_nextra);
    for (i = 0; i < st_nextra && st_nregs >= 0; i++) st_regs[st_nregs + i] = st_extra[i];
    if (st_nregs < 0) return;
    st_nregs += st_nextra;
    for (i = 0; i < st_nregs; i++) total += st_regs[i].n;
    st_copy = malloc(total);
    if (!st_copy) return;
    for (i = 0; i < st_nregs; i++) { memcpy(st_copy + at, st_regs[i].p, st_regs[i].n); at += st_regs[i].n; }
}

static void st_diff_all(void)                   /* which bytes differ now from st_copy_all's: runs, by region and address */
{
    size_t at = 0;
    uint32_t runs = 0, bytes = 0;
    int r;
    if (!st_copy) return;
    for (r = 0; r < st_nregs; r++) {
        const uint8_t *now = st_regs[r].p;
        size_t i, n = st_regs[r].n;
        for (i = 0; i < n; i++) {
            size_t j = i;
            if (now[i] == st_copy[at + i]) continue;
            while (j + 1 < n && j - i < 64 && now[j + 1] != st_copy[at + j + 1]) j++;
            bytes += (uint32_t)(j - i + 1);
            if (runs++ < 120) {
                uintptr_t a = (uintptr_t)now + i, base = (uintptr_t)sub_10000;
                fprintf(stderr, "snaptest: differs region %d (%p, %zu bytes) +%zx %u bytes (game addr %05X): first %02x now %02x\n", r, st_regs[r].p,
                        n, i, (unsigned)(j - i + 1), (unsigned)(a - base + 0x10000), st_copy[at + i], now[i]);
            }
            i = j;
        }
        at += n;
    }
    fprintf(stderr, "snaptest: %u runs, %u bytes differ in %d regions\n", runs, bytes, st_nregs);
    free(st_copy);
    st_copy = NULL;
}

/* the first time, each record's fingerprints (the sim's, the game's data object, DOS memory); the second time they are compared, so the first
 * record at which the replay goes its own way is known */
static uint64_t st_rec[ST_BACK + 2][3];
static int st_first_bad;
static uint64_t st_fnv(const void *p, size_t n)
{
    const uint8_t *q = p;
    uint64_t h = 1469598103934665603ULL;
    size_t i;
    for (i = 0; i < n; i++) { h ^= q[i]; h *= 1099511628211ULL; }
    return h;
}
static void st_track(uint32_t c)
{
    uint64_t v[3];
    if (c <= ST_SAVE || c > ST_BACK || (st_phase != 1 && st_phase != 2)) return;
    v[0] = sim_hash();
    v[1] = st_fnv(st_regs[0].p, st_regs[0].n) ^ st_fnv(st_regs[1].p, st_regs[1].n);
    v[2] = st_fnv((void *)0x20000, 0x68000);
    if (st_phase == 1) { memcpy(st_rec[c], v, sizeof v); return; }
    if (!st_first_bad && memcmp(st_rec[c], v, sizeof v)) {
        st_first_bad = (int)c;
        fprintf(stderr, "snaptest: the replay first differs at record %u: sim %s, data %s, DOS memory %s (queue %u..%u)\n", (unsigned)c,
                st_rec[c][0] != v[0] ? "DIFFERENT" : "same", st_rec[c][1] != v[1] ? "DIFFERENT" : "same", st_rec[c][2] != v[2] ? "DIFFERENT" : "same",
                (unsigned)nh_head, (unsigned)nh_tail);
    }
}

/* the parts of sim_hash apart, and where each lives (which of the state's regions holds it, if any) */
#define ST_PARTS 8
static uint64_t st_part[2][ST_PARTS];
static void st_parts(uint64_t *o, int show)
{
    int k;
    struct { const char *name; const void *p; size_t n; } t[ST_PARTS] = {
        { "SortCords", SortCords, 17 * 0x80 }, { "hmtmstruct", hmtmstruct, 0x1D4 }, { "hmlinetab", hmlinetab, 0x30 }, { "awlinetab", awlinetab, 0x30 },
        { "seed", &seed, 4 }, { "gameclock", &gameclock, 2 }, { "clockticks", &clockticks, 2 }, { "gsp", &gsp, 2 } };
    for (k = 0; k < ST_PARTS; k++) {
        int r, in = -1;
        o[k] = st_fnv(t[k].p, t[k].n);
        if (!show) continue;
        for (r = 0; r < st_nregs; r++)
            if ((const uint8_t *)t[k].p >= (const uint8_t *)st_regs[r].p && (const uint8_t *)t[k].p < (const uint8_t *)st_regs[r].p + st_regs[r].n) in = r;
        fprintf(stderr, "snaptest: %s at %p (game addr %05X) is %s%d\n", t[k].name, t[k].p, (unsigned)((const uint8_t *)t[k].p - (const uint8_t *)sub_10000 + 0x10000),
                in < 0 ? "in no region" : "in region ", in < 0 ? 0 : in);
    }
}

static void selftest_step(void)
{
    uint32_t c = nh_consumed;
    st_track(c);
    if (st_phase == 0 && c == ST_SAVE) {
        st_phase = 1;
        st_regions();
        st_vif = vif;
        if (__builtin_setjmp(st_jb)) {              /* back from snap_jump: the state of record ST_SAVE */
            vif = st_vif;
            fprintf(stderr, "snaptest: back at record %u (queue %u..%u)\n", (unsigned)nh_consumed, (unsigned)nh_head, (unsigned)nh_tail);
            return;
        }
        if (snap_save(&st_snap, st_jb, snap_sp(), st_extra, st_nextra)) { fprintf(stderr, "snaptest: FAIL cannot take a state\n"); st_phase = 3; return; }
        fprintf(stderr, "snaptest: state taken at record %u: %zu bytes (%zu pages differ from the base) in %d regions (stack %zu)\n", (unsigned)c, st_snap.size, st_snap.ndiff, st_snap.nregs, st_snap.stack);
        return;
    }
    if (st_phase == 1 && c == ST_BACK) {
        st_sim = sim_hash();
        st_all = st_fingerprint();
        st_copy_all();
        st_parts(st_part[0], 1);
        st_phase = 2;
        if (snap_fits(&st_snap, st_extra, st_nextra)) { fprintf(stderr, "snaptest: FAIL the memory blocks changed between the two records\n"); st_phase = 3; return; }
        fprintf(stderr, "snaptest: record %u first time: sim %016llx all %016llx; going back\n", (unsigned)c, (unsigned long long)st_sim, (unsigned long long)st_all);
        vif = 0;                                    /* no interrupt comes in while the memory is put back */
        snap_restore_memory(&st_snap);
        snap_jump(&st_snap);
    }
    if (st_phase == 2 && c == ST_BACK) {
        uint64_t a = sim_hash(), b = st_fingerprint();
        fprintf(stderr, "snaptest: record %u again: sim %016llx all %016llx: %s\n", (unsigned)c, (unsigned long long)a, (unsigned long long)b,
                a == st_sim && b == st_all ? "SAME" : a == st_sim ? "sim same, other game data differ" : "DIFFERENT");
        st_diff_all();
        {
            int k;
            st_parts(st_part[1], 0);
            for (k = 0; k < ST_PARTS; k++)
                if (st_part[0][k] != st_part[1][k]) fprintf(stderr, "snaptest: part %d of the sim's hash differs\n", k);
        }
        st_phase = 3;
    }
}

static void try_step(void)
{
    uint16_t all[OB_NET_MAX_PADS];
    int r;
    if (nh_selftest) {                              /* (records of its own, no network) */
        if (!nh_pending) return;
        st_record(all);
        nh_pending = 0;
        push_merged(all);
        return;
    }
    if (SDL_TryLockMutex(nh_lock) != 0) return;     /* the main thread is in the core: the next tick tries again */
    r = nh_net ? ob_net_step(nh_net, nh_local, all) : -1;
    SDL_UnlockMutex(nh_lock);
    if (r == 0) return;
    nh_pending = 0;
    if (r > 0) push_merged(all);
    else { nh_take = 0; nh_dead = 1; }
}

/* SampleInputTick in a session: the game thread, inside the timer interrupt. Never waits. */
void nh_sample_tick(void)
{
    if (!joysampling) return;
    if (inputticks < 1000) inputticks++;
    if (nh_rb) {                                    /* rollback: the timer only says a record is due, with this machine's buttons for it */
        if (--nh_cadence >= 0) return;
        nh_cadence = 4;
        if (nh_due < 2) { fill_local(); nh_due++; }
        return;
    }
    if (!nh_pending) {
        if (--nh_cadence >= 0) return;              /* a record every 5 ticks, as joyqtick */
        nh_cadence = 4;
        if (nh_tail - nh_head >= QMAX) return;
        fill_local();
        nh_pending = 1;
    }
    try_step();                                     /* not yet: the next tick asks again (the core keeps the first local) */
}

/* the session has ended mid-game: the game plays on here alone, the other machine's team by the computer */
static void go_local(void)
{
    nh_sim = 0;
    if (nh_me == 0) { cont2team = 0; pad2dev = 0; }
    else { cont1team = 0; pad1dev = 0; }
    pads4_drop_remote();
}

/* ---- rollback (the default in a session; NHL95_LOCKSTEP=1 is the old lockstep) ----
 * The game asks for its next record (nh_peek) outside any interrupt, with the queue empty: that is the resumable point. The timer
 * only counts the records that are due (every 5 ticks) and reads this machine's pad for them. rb_make asks the core for the step: it
 * runs at once when the others' buttons are late (guessing them), or again after a wrong guess, when a state is loaded and the game
 * comes back here (snap_jump) with the queue and counters as they were. A state is the game's data and DOS memory as a difference
 * to a base (snap.c), the queue's variables and the game thread's stack. */
#define RB_SLOTS 32
static uint32_t nh_hi;                          /* the most steps made so far: below it the steps are replays, which need no timer */
static snap rb_snap[RB_SLOTS];
static uint32_t rb_gen[RB_SLOTS], rb_genc, rb_next, rb_target;
static int rb_slot_vif[RB_SLOTS];
static void *rb_jb[5];
static char *rb_low;
static snap_region rb_extra[16];
static int rb_nextra;
static uint32_t rb_timing_n;
static int64_t rb_timing_ns;

static void rb_regions(void)
{
    int n = 0;
#define X(v) do { rb_extra[n].p = (void *)&(v); rb_extra[n].n = sizeof (v); n++; } while (0)
    X(nh_ring); X(pads4); X(nh_head); X(nh_tail); X(nh_consumed); X(nh_loop_mark);
    X(nh_rgf_pops0); X(nh_rgf_f0); X(nh_rgf_asked); X(nh_rgf_carry); X(nh_rgf_total); X(nh_finish);
#undef X
    rb_extra[n].p = sub_10000; rb_extra[n].n = ST_DATA_LO - 0x10000; n++;        /* the game's code too: it patches itself */
    rb_nextra = n;
}

typedef struct { uint32_t slot, gen; } rb_blob;

static size_t rb_save(void *user, void *out, size_t cap)
{
    rb_blob b;
    uint32_t slot = rb_next % RB_SLOTS;
    int64_t t0 = plat_now_ns();
    (void)user;
    if (cap < sizeof b) return sizeof b;
    { int v0 = vif, bad;
      vif = 0;                                      /* no interrupt changes the game while its state is taken */
      bad = snap_save(&rb_snap[slot], rb_jb, rb_low, rb_extra, rb_nextra);
      vif = v0;
      if (bad) return 0; }
    rb_next++;
    rb_gen[slot] = ++rb_genc;
    rb_slot_vif[slot] = vif;
    b.slot = slot; b.gen = rb_gen[slot];
    memcpy(out, &b, sizeof b);
    rb_timing_ns += plat_now_ns() - t0;
    rb_timing_n++;
    return sizeof b;
}

static int rb_load(void *user, const void *in, size_t size)
{
    rb_blob b;
    (void)user;
    if (size != sizeof b) return -1;
    memcpy(&b, in, sizeof b);
    if (b.slot >= RB_SLOTS || rb_gen[b.slot] != b.gen || !rb_snap[b.slot].valid) return -1;
    vif = 0;                                        /* no interrupt comes in while the memory is put back */
    if (snap_restore_memory(&rb_snap[b.slot])) return -1;
    rb_target = b.slot;
    return 0;
}

static const ob_net_states rb_states = { NULL, rb_save, rb_load };

static void rb_make(void)
{
    static uint16_t all[OB_NET_MAX_PADS];
    static int r;
    static uint32_t cnt;
    if (!nh_net) return;
    SDL_LockMutex(nh_lock);
    cnt = nh_net ? ob_net_step_count(nh_net) : 0;
    SDL_UnlockMutex(nh_lock);
    if (cnt >= nh_hi && !nh_due) return;            /* a new step waits for the timer; a replay does not */
    if (__builtin_setjmp(rb_jb)) vif = rb_slot_vif[rb_target];        /* back from snap_jump: the queue and the game as they were */
    rb_low = snap_sp();
    SDL_LockMutex(nh_lock);
    nh_where = "rb_make: ob_net_frame";
    r = nh_net ? ob_net_frame(nh_net, 1, nh_local, all) : -1;
    nh_where = "";
    SDL_UnlockMutex(nh_lock);
    if (r == OB_NET_RESTART) snap_jump(&rb_snap[rb_target]);
    if (r == OB_NET_RUN) {
        SDL_LockMutex(nh_lock);
        nh_quiet = ob_net_replaying(nh_net);
        cnt = ob_net_step_count(nh_net);
        SDL_UnlockMutex(nh_lock);
        if (!nh_quiet && nh_due > 0) nh_due--;
        if (cnt > nh_hi) nh_hi = cnt;
        push_merged(all);
        if (cnt % 200 == 0 && getenv("NHL95_ONLINE")) {
            char line[200] = "";
            SDL_LockMutex(nh_lock);
            if (nh_net) ob_net_status(nh_net, line, sizeof line);
            SDL_UnlockMutex(nh_lock);
            fprintf(stderr, "rollback: at %.1f s, step %u, %u states, %.1f ms each, last one %zu pages %zu bytes; %s; %s\n", plat_now_ns() / 1e9, (unsigned)cnt, (unsigned)rb_timing_n, rb_timing_n ? rb_timing_ns / 1e6 / rb_timing_n : 0.0, rb_snap[(rb_next + RB_SLOTS - 1) % RB_SLOTS].ndiff, rb_snap[(rb_next + RB_SLOTS - 1) % RB_SLOTS].size, line, snap_stats());
        }
    } else if (r < 0) { nh_take = 0; nh_dead = 1; nh_quiet = 0; }
}

/* joyq_peek: the record of the next 3 frames, 0 for none yet; 1: not a session any more (the game's own) */
uintptr_t nh_peek(void)
{
    if (nh_finish) { nh_sim = 0; return 1; }
    if (nh_head == nh_tail && nh_rb && !nh_dead) rb_make();
    if (nh_head == nh_tail) {
        if (nh_dead) { go_local(); return 1; }
        return 0;
    }
    return (uintptr_t)nh_ring[nh_head % RING];
}

/* pads 3 and 4 of the record the game is playing (joyrec), in a session */
int netplay_pad34(int k, uint8_t *out)
{
    uintptr_t r = (uintptr_t)(uint32_t)joyrec;
    if (!nh_sim || r < (uintptr_t)nh_ring || r >= (uintptr_t)nh_ring + sizeof nh_ring) return 0;
    *out = ((const uint8_t *)r)[3 + (k ? 1 : 0)];
    return 1;
}

/* the game state the desync check compares: what SaveGameState keeps of the players, the teams, the lines, the clock */
static uint64_t sim_hash(void)
{
    uint64_t h = 1469598103934665603ULL;
    int i;
#define MIX(p, n) do { const uint8_t *q_ = (const uint8_t *)(p); size_t k_; for (k_ = 0; k_ < (size_t)(n); k_++) { h ^= q_[k_]; h *= 1099511628211ULL; } } while (0)
    for (i = 0; i < 17; i++) MIX(SortCords + i * 0x80, 0x66);
    MIX(hmtmstruct, 0xD4);
    MIX(hmtmstruct + 0x100, 0xD4);
    MIX(hmlinetab, 0x30);
    MIX(awlinetab, 0x30);
    MIX(&seed, 4); MIX(&gameclock, 2); MIX(&clockticks, 2); MIX(&gsp, 2); MIX(&curperiod, 4);
    MIX(&lj1, 2); MIX(&lj2, 2); MIX(&crowdlevel, 2);
#undef MIX
    return h;
}

void nh_pop(void)
{
    if (nh_head == nh_tail) return;
    nh_head++;
    nh_consumed++;
    if (nh_selftest) { selftest_step(); return; }
    if (!gameover && (nh_consumed == 1 || nh_consumed % 60 == 0)) {     /* the game thread, outside the interrupt: may wait */
        uint64_t h = sim_hash();
        SDL_LockMutex(nh_lock);
        nh_where = "nh_pop: ob_net_check";
        if (nh_net) ob_net_check(nh_net, nh_consumed - 1, h);
        nh_where = "";
        SDL_UnlockMutex(nh_lock);
    }
}

/* RunGameFrames(n): at most to the end of the record it is on; the frames it could not run this time come with the next call
 * (unless it stopped for want of a record, as the game always did) */
uint32_t nh_rgf_before(int32_t n)
{
    int lim;
    nh_rgf_pops0 = nh_consumed;
    nh_rgf_f0 = inputframes;
    if (n <= 0) { nh_rgf_asked = 0; nh_rgf_total = 0; return (uint32_t)n; }
    nh_rgf_total = n + nh_rgf_carry;
    nh_rgf_carry = 0;
    lim = nh_rgf_f0 > 0 ? (int)nh_rgf_f0 : 3;
    nh_rgf_asked = (uint32_t)(nh_rgf_total < lim ? nh_rgf_total : lim);
    return nh_rgf_asked;
}

uint32_t nh_rgf_after(void)                         /* frames run: goes back in edx */
{
    uint32_t f1 = inputframes, pops = nh_consumed - nh_rgf_pops0;
    int started = (int)pops + (f1 > 0) - (nh_rgf_f0 > 0);
    int ran = (int)nh_rgf_f0 - (int)f1 + 3 * started;
    if (ran < 0) ran = 0;
    if ((uint32_t)ran == nh_rgf_asked && nh_rgf_total > ran) nh_rgf_carry = nh_rgf_total - ran > 12 ? 12 : nh_rgf_total - ran;
    return (uint32_t)ran;
}

/* the intro / three stars loop: "a button" once a record has ended in it, at the end of a record (both machines alike) */
void nh_loop_start(void) { nh_loop_mark = nh_consumed; }
static int loop_press(void)
{
    if (inputframes != 0 || nh_consumed <= nh_loop_mark) return 0;
    if (gameover) { nh_finish = 1; nh_take = 0; }   /* the three stars: every record the other machine needs to get here is made */
    return 1;
}
uint32_t nh_rj1_ret(void) { return (uint32_t)(uintptr_t)GAME_ADDR(loop_press() ? RJ_SKIP : RJ2_SITE); }
uint32_t nh_rj2_ret(void) { return (uint32_t)(uintptr_t)GAME_ADDR(loop_press() ? RJ_SKIP : RJ_NONE); }

/* ---- the start and end of the session's game ---- */
static void save_local(void)
{
    nh_saved.home = HomeTeam; nh_saved.vis = VisTeam;
    nh_saved.gamemode = gamemode; nh_saved.gameopts = gameopts;
    nh_saved.ctl1team = ctl1team; nh_saved.ctl2team = ctl2team;
    nh_saved.ctl1side = ctl1side; nh_saved.ctl2side = ctl2side;
    nh_saved.ctl1dev = ctl1dev; nh_saved.ctl2dev = ctl2dev;
    nh_saved.pertime = PerTimeTab[0];
}

static void restore_local(void)
{
    HomeTeam = nh_saved.home; VisTeam = nh_saved.vis;
    gamemode = nh_saved.gamemode; gameopts = nh_saved.gameopts;
    ctl1team = nh_saved.ctl1team; ctl2team = nh_saved.ctl2team;
    ctl1side = nh_saved.ctl1side; ctl2side = nh_saved.ctl2side;
    ctl1dev = nh_saved.ctl1dev; ctl2dev = nh_saved.ctl2dev;
    PerTimeTab[0] = nh_saved.pertime;
    setup_controllers();
    feel_session_end();
}

static void make_settings(nh_settings *s)
{
    uint32_t *rs = randseed_ptr();
    time_t t = time(0);
    struct tm *tm = localtime(&t);
    memset(s, 0, sizeof *s);
    s->magic = NH_MAGIC; s->version = NH_VERSION;
    s->home = HomeTeam; s->vis = VisTeam;
    s->gamemode = gamemode; s->gameopts = gameopts;
    s->ctl1team = ctl1team < 0 ? 0 : ctl1team;
    s->ctl1side = ctl1side;
    if (ctl2team < 0) { s->ctl2team = 0; s->ctl2side = ctl1side ? 0 : 1; }    /* the host plays alone here: the guest takes the other team */
    else { s->ctl2team = ctl2team; s->ctl2side = ctl2side; }
    s->seed = seed;
    s->randseed = rs ? *rs : 0;
    s->pertime = PerTimeTab[0];
    s->clock = tm ? (uint32_t)(tm->tm_hour * 3600 + tm->tm_min * 60 + tm->tm_sec) : 0;
    ob_game_pack(overbar_client_host(), s->game, sizeof s->game);
}

static void apply_settings(const nh_settings *s, uint32_t my_dev)
{
    uint32_t *rs = randseed_ptr();
    HomeTeam = (int16_t)s->home; VisTeam = (int16_t)s->vis;
    gamemode = s->gamemode; gameopts = s->gameopts;
    ctl1team = s->ctl1team; ctl2team = s->ctl2team;
    ctl1side = s->ctl1side; ctl2side = s->ctl2side;
    /* each machine reads its own device; the other's pad comes over the network ("none" here, so no mouse rules apply to it).
     * select-sides already wrote ctl*dev for this machine's seats. */
    if (!(port_sides_ob() && port_sides_ob()->done)) {
        ctl1dev = nh_me == 0 ? my_dev : 0x10;
        ctl2dev = nh_me == 1 ? my_dev : 0x10;
    }
    PerTimeTab[0] = (uint16_t)s->pertime;
    setup_controllers();
    seed = s->seed;
    if (rs) *rs = s->randseed;
    nh_clock = s->clock;
    feel_session_begin(s->game, strnlen(s->game, sizeof s->game));
}

static void close_room(const char *why)
{
    if (getenv("NHL95_ONLINE")) fprintf(stderr, "online: room ends: %s\n", nh_room && ob_net_why(nh_room)[0] ? ob_net_why(nh_room) : why ? why : "");
    SDL_LockMutex(nh_lock);
    if (nh_net && nh_net != nh_room) {
        ob_net_free(nh_net);
        nh_net = NULL;
    }
    if (nh_room) {
        if (ob_net_state(nh_room) == OB_NET_ENDED && ob_net_why(nh_room)[0]) snprintf(nh_why, sizeof nh_why, "%s", ob_net_why(nh_room));
        else if (why) snprintf(nh_why, sizeof nh_why, "%s", why);
        port_season_unbind_net();
        ob_net_free(nh_room);
        nh_room = NULL;
    } else if (why) snprintf(nh_why, sizeof nh_why, "%s", why);
    nh_net = NULL;
    SDL_UnlockMutex(nh_lock);
}

static void end_match(const char *why)
{
    SDL_LockMutex(nh_lock);
    if (nh_net && ob_net_state(nh_net) == OB_NET_GO) ob_net_match_end(nh_net);
    if (nh_net && nh_net != nh_room) {
        ob_net_free(nh_net);
        nh_net = nh_room;
    }
    if (why) snprintf(nh_why, sizeof nh_why, "%s", why);
    SDL_UnlockMutex(nh_lock);
}

static int poll_nets_locked(void)
{
    int st = OB_NET_ENDED;
    if (nh_room) st = ob_net_poll(nh_room);
    if (nh_net && nh_net != nh_room) st = ob_net_poll(nh_net);
    port_season_poll();
    return nh_net ? ob_net_state(nh_net) : st;
}

static void fill_game(ob_net_game *g, char *identity, size_t idsz)
{
    nh_rb = getenv("NHL95_LOCKSTEP") == NULL;
    snprintf(identity, idsz, "nhl95pc %s %s sound %02x/%u", NHL95_BUILD, nh_rb ? "rollback2" : "lockstep2",
             (unsigned)(sounddev & 0xFF), (unsigned)musicon);
    memset(g, 0, sizeof *g);
    g->identity = identity;
    g->pads = NH_PADS;
    g->room = 1;
    g->states = nh_rb ? &rb_states : NULL;
}

static int room_open(char *err, int err_size)
{
    char identity[200];
    ob_net_game g;
    if (nh_room) return 0;
    fill_game(&g, identity, sizeof identity);
    SDL_LockMutex(nh_lock);
    nh_net = ob_net_new(&nh_cfg, &g, err, err_size);
    nh_room = nh_net;
    if (nh_net) port_season_bind_net(nh_net);
    SDL_UnlockMutex(nh_lock);
    return nh_net ? 0 : -1;
}

/* PlayGame(&saved game handle): the game thread, before the game is loaded */
void nh_playgame_enter(int32_t *handle)
{
    char err[160];
    nh_settings mine;
    const nh_settings *theirs;
    size_t size = 0;
    uint32_t my_dev = ctl1dev;
    int st;
    if (nh_ok && !nh_armed && !nh_selftest && !st_phase && getenv("NHL95_SNAPTEST") && *handle < 0 && gamemode == 0) {
        fprintf(stderr, "snaptest: a game with records of its own; state at record %u, back at %u\n", ST_SAVE, ST_BACK);
        save_local();
        nh_selftest = 1;
        nh_me = 0;
        nh_head = nh_tail = nh_consumed = 0;
        nh_cadence = 0; nh_pending = 0; nh_rgf_carry = 0; nh_loop_mark = 0;
        nh_dead = 0; nh_finish = 0;
        nh_take = 1;
        nh_sim = 1;
        return;
    }
    if (!nh_ok) return;
    if (*handle >= 0) {
        if (nh_armed || nh_net) snprintf(nh_why, sizeof nh_why, "online play starts with a new game");
        return;                                     /* loaded games stay local; the room stays */
    }
    if (!nh_armed && !nh_room) {
        port_sides_wait();                          /* local: Overbar's select-sides, every connected controller */
        return;
    }
    if (gamemode != 0 && gamemode != 1 && gamemode != 2) {
        snprintf(nh_why, sizeof nh_why, "online play starts with a new exhibition, season, or playoff game");
        return;
    }
    /* a room does not make A vs CPU / A vs B an online game */
    if (gamemode == 2 && nh_room && !port_season_want_online()) {
        port_sides_wait();
        return;
    }
    if (my_dev != 2 && my_dev != 4 && my_dev != 8) {
        snprintf(nh_why, sizeof nh_why, "pick the keyboard or a joystick for player 1 (the mouse can't play online)");
        return;
    }
    if (!nh_room) {
        if (room_open(err, (int)sizeof err)) { snprintf(nh_why, sizeof nh_why, "%s", err); return; }
        fprintf(stderr, "online: room listening (Windows may prompt for the firewall)\n");
    }
    nh_rb = getenv("NHL95_LOCKSTEP") == NULL;
    make_settings(&mine);
    if (getenv("NHL95_NETSIM")) {
        int d = 0, j = 0, l = 0;
        sscanf(getenv("NHL95_NETSIM"), "%d,%d,%d", &d, &j, &l);
        ob_net_simulate(nh_net, d, j, l, 0);
        fprintf(stderr, "online: simulating %d ms delay, %d ms jitter, %d%% loss\n", d, j, l);
    }
    nh_why[0] = 0;
    if (port_season_h2h_active()) {
        port_season_h2h_playing();              /* room host begins pad0=home, pad1=away */
        nh_close_page = 1;
    } else {
        nh_want_page = 1;                       /* the Online page shows what it waits for */
        for (;;) {
            SDL_LockMutex(nh_lock);
            st = poll_nets_locked();
            SDL_UnlockMutex(nh_lock);
            if (st != OB_NET_CONNECTING) break;
            plat_sleep_ms(2);
        }
        nh_close_page = 1;                       /* sides takes the keys; the overlay would swallow them */
        while (overbar_client_open() && !quit_requested) plat_sleep_ms(2);
        if (st == OB_NET_LOBBY)
            port_sides_wait();                  /* same Overbar screen as local; the host's model is the one */
        if (st == OB_NET_LOBBY && nh_net && ob_net_is_host(nh_net)) {
            ob_net_match m;
            memset(&m, 0, sizeof m);
            {
                int p;
                for (p = 0; p < OB_NET_MAX_PADS; p++) m.owner[p] = -1;
            }
            if (port_sides_ob() && port_sides_ob()->done)
                ob_sides_owners(port_sides_ob(), m.owner, NH_PADS, 1);
            else {
                m.owner[0] = 0;
                m.owner[1] = 1;
            }
            make_settings(&mine);               /* after sides: ctl* are the seat table */
            m.delay = -1;
            m.settings = &mine;
            m.settings_size = sizeof mine;
            if (ob_net_match_begin(nh_net, &m, err, (int)sizeof err)) {
                nh_close_page = 1;
                snprintf(nh_why, sizeof nh_why, "%s", err);
                return;
            }
        }
    }
    for (;;) {
        SDL_LockMutex(nh_lock);
        st = poll_nets_locked();
        SDL_UnlockMutex(nh_lock);
        if (st == OB_NET_GO || st == OB_NET_ENDED) break;
        plat_sleep_ms(2);
    }
    nh_close_page = 1;
    if (st != OB_NET_GO) { end_match("the session did not start"); return; }
    SDL_LockMutex(nh_lock);
    theirs = (const nh_settings *)ob_net_settings(nh_net, &size);
    nh_me = (ob_net_my_pads(nh_net) & 1) ? 0 : 1;
    SDL_UnlockMutex(nh_lock);
    if (!theirs || size != sizeof *theirs || theirs->magic != NH_MAGIC || theirs->version != NH_VERSION) {
        end_match("the host's settings are not this version's");
        return;
    }
    save_local();
    apply_settings(theirs, my_dev);
    /* host's teams and options: exhibition did this in MenuNewExhibition; a league game already ran its
     * pre-game path, then PlayGame, and this applies the host's blob so both copies match */
    game_call(InitGameSummary, 0, 0);
    nh_head = nh_tail = nh_consumed = 0;
    nh_cadence = 0; nh_pending = 0; nh_rgf_carry = 0; nh_loop_mark = 0;
    nh_dead = 0; nh_finish = 0;
    nh_due = 0; nh_hi = 0; nh_quiet = 0; rb_next = 0;
    if (nh_rb) rb_regions();
    nh_take = 1;
    nh_sim = 1;
}

/* PlayGame has returned: the session's game is over */
void nh_playgame_exit(void)
{
    if (nh_dead && port_season_h2h_active()) port_season_h2h_abort();
    if (!nh_sim && !nh_take && !nh_dead && !nh_finish) {
        port_season_after_game();
        return;
    }
    if (!nh_net && !nh_sim && !nh_dead && !nh_finish) return;
    if (nh_selftest) { nh_selftest = 0; snap_free(&st_snap); fprintf(stderr, "snaptest: the game is over (phase %d)\n", st_phase); }
    nh_take = 0;
    nh_sim = 0;
    nh_dead = 0; nh_finish = 0;
    if (nh_rb) { int k; for (k = 0; k < RB_SLOTS; k++) snap_free(&rb_snap[k]); memset(rb_gen, 0, sizeof rb_gen); }
    nh_quiet = 0;
    end_match("the game is over");
    restore_local();
    port_season_after_game();
}

void netplay_pump(void)
{
    if (!nh_lock) return;
    SDL_LockMutex(nh_lock);
    poll_nets_locked();
    SDL_UnlockMutex(nh_lock);
}

int netplay_h2h_begin(int home_machine, int vis_machine, const void *settings, size_t settings_size)
{
    ob_net_match m;
    char err[160];
    int p, r;
    if (!nh_lock || !nh_net || !ob_net_is_host(nh_net)) return -1;
    if (home_machine < 0 || vis_machine < 0 || home_machine == vis_machine) return -1;
    if (!settings || !settings_size) return -1;
    memset(&m, 0, sizeof m);
    for (p = 0; p < OB_NET_MAX_PADS; p++) m.owner[p] = -1;
    m.owner[0] = (int8_t)home_machine;
    m.owner[1] = (int8_t)vis_machine;
    m.delay = -1;
    m.settings = settings;
    m.settings_size = settings_size;
    SDL_LockMutex(nh_lock);
    if (ob_net_state(nh_net) != OB_NET_LOBBY) {
        SDL_UnlockMutex(nh_lock);
        return -1;
    }
    r = ob_net_match_begin(nh_net, &m, err, (int)sizeof err);
    SDL_UnlockMutex(nh_lock);
    if (r) {
        snprintf(nh_why, sizeof nh_why, "%s", err);
        return -1;
    }
    return 0;
}

void netplay_h2h_end(void)
{
    if (!nh_lock || !nh_net || !ob_net_is_host(nh_net)) return;
    if (nh_sim || nh_take) return;
    SDL_LockMutex(nh_lock);
    if (ob_net_state(nh_net) == OB_NET_GO) ob_net_match_end(nh_net);
    SDL_UnlockMutex(nh_lock);
}

size_t netplay_settings_copy(void *buf, size_t cap)
{
    nh_settings s;
    if (!buf || cap < sizeof s) return 0;
    make_settings(&s);
    s.home = HomeTeam;
    s.vis = VisTeam;
    if (HomeTeam >= 0) { s.ctl1team = HomeTeam; s.ctl1side = 0; }
    if (VisTeam >= 0) { s.ctl2team = VisTeam; s.ctl2side = 1; }
    memcpy(buf, &s, sizeof s);
    return sizeof s;
}

/* ---- int 21h / 2Ch in a session: the host's time when it began, on by the records run (20 a second) ---- */
int netplay_dos_time(int *h, int *m, int *s, int *cs)
{
    uint32_t t;
    if (!nh_sim) return 0;
    t = nh_clock + nh_consumed / 20;
    *h = (int)(t / 3600 % 24); *m = (int)(t / 60 % 60); *s = (int)(t % 60); *cs = (int)(nh_consumed % 20 * 5);
    return 1;
}

int netplay_running(void) { return nh_take; }
int netplay_session(void) { return nh_armed || nh_room != NULL; }

/* ---- the stubs at the game routines' entries (each starts with push dword N, 5 bytes, or as noted) ---- */
__attribute__((naked)) static void peek_entry(void)
{
    __asm__ volatile(
        "cmpl $0, " SYM("nh_sim") "\n\tje 1f\n\t"
        "pushal\n\tcall " SYM("nh_peek") "\n\tcmpl $1, %eax\n\tje 2f\n\t"
        "movl %eax, 28(%esp)\n\tpopal\n\tret\n"
        "2:\n\tpopal\n"
        "1:\n\tpushl $8\n\tjmp *" SYM("nh_peek_cont"));
}

__attribute__((naked)) static void pop_entry(void)
{
    __asm__ volatile(
        "cmpl $0, " SYM("nh_sim") "\n\tje 1f\n\t"
        "pushal\n\tcall " SYM("nh_pop") "\n\tpopal\n\tret\n"
        "1:\n\tpushl $0x14\n\tjmp *" SYM("nh_pop_cont"));
}

__attribute__((naked)) static void flush_entry(void)
{
    __asm__ volatile(
        "cmpl $0, " SYM("nh_sim") "\n\tje 1f\n\tret\n"
        "1:\n\tpushl $8\n\tjmp *" SYM("nh_flush_cont"));
}

__attribute__((naked)) static void rgf_entry(void)       /* RunGameFrames(eax frames); in a session edx comes back as the frames run */
{
    __asm__ volatile(
        "cmpl $0, " SYM("nh_sim") "\n\tje 1f\n\t"
        "pushal\n\tpushl %eax\n\tcall " SYM("nh_rgf_before") "\n\taddl $4, %esp\n\tmovl %eax, 28(%esp)\n\tpopal\n\t"
        "pushl $2f\n\tpushl $0x0C\n\tjmp *" SYM("nh_rgf_cont") "\n"
        "2:\n\tpushal\n\tcall " SYM("nh_rgf_after") "\n\tmovl %eax, 20(%esp)\n\tpopal\n\tret\n"
        "1:\n\tpushl $0x0C\n\tjmp *" SYM("nh_rgf_cont"));
}

__attribute__((naked)) static void pg_entry(void)        /* PlayGame(eax): around the whole game */
{
    __asm__ volatile(
        "pushal\n\tpushl %eax\n\tcall " SYM("nh_playgame_enter") "\n\taddl $4, %esp\n\tpopal\n\t"
        "pushl $2f\n\tpushl $0x64\n\tjmp *" SYM("nh_pg_cont") "\n"
        "2:\n\tpushal\n\tcall " SYM("nh_playgame_exit") "\n\tpopal\n\tret");
}

__attribute__((naked)) static void pab_entry(void)       /* PaSpeechBusy */
{
    __asm__ volatile(
        "cmpl $0, " SYM("nh_sim") "\n\tje 1f\n\txorl %eax, %eax\n\tret\n"
        "1:\n\tpushl $4\n\tjmp *" SYM("nh_pab_cont"));
}

__attribute__((naked)) static void spb_entry(void)       /* SpeechBusy */
{
    __asm__ volatile(
        "cmpl $0, " SYM("nh_sim") "\n\tje 1f\n\txorl %eax, %eax\n\tret\n"
        "1:\n\tpushl $4\n\tjmp *" SYM("nh_spb_cont"));
}

__attribute__((naked)) static void crowd_entry(void)     /* Crowd_Noise: in a session `seed` is as it was before */
{
    __asm__ volatile(
        "cmpl $0, " SYM("nh_sim") "\n\tje 1f\n\t"
        "pushl " SYM("seed") "\n\tpushl $2f\n\tpushl $0x14\n\tjmp *" SYM("nh_crowd_cont") "\n"
        "2:\n\tpopl " SYM("seed") "\n\tret\n"
        "1:\n\tpushl $0x14\n\tjmp *" SYM("nh_crowd_cont"));
}

__attribute__((naked)) static void inter_entry(void)     /* IntermissionPC: in a session only its curperiod + 1 */
{
    __asm__ volatile(
        "cmpl $0, " SYM("nh_sim") "\n\tje 1f\n\tincl " SYM("curperiod") "\n\tret\n"
        "1:\n\tpushl $0x1C\n\tjmp *" SYM("nh_inter_cont"));
}

__attribute__((naked)) static void tsl_entry(void)       /* ThreeStarsLoop (the intro's too) */
{
    __asm__ volatile(
        "cmpl $0, " SYM("nh_sim") "\n\tje 1f\n\tpushal\n\tcall " SYM("nh_loop_start") "\n\tpopal\n"
        "1:\n\tpushl $0x28\n\tjmp *" SYM("nh_tsl_cont"));
}

__attribute__((naked)) static void sit_entry(void)       /* SampleInputTick: push ebx, ecx, edx, esi, cmp dword [joysampling], 0 (11 bytes) */
{
    __asm__ volatile(
        "cmpl $0, " SYM("nh_take") "\n\tjne 1f\n\t"
        "pushl %ebx\n\tpushl %ecx\n\tpushl %edx\n\tpushl %esi\n\tcmpl $0, " SYM("joysampling") "\n\tjmp *" SYM("nh_sit_cont") "\n"
        "1:\n\tpushal\n\tcall " SYM("nh_sample_tick") "\n\tpopal\n\tret");
}

__attribute__((naked)) static void rj1_stub(void)        /* the loop's call ReadJoy1: in a session, where to go on (no button read) */
{
    __asm__ volatile(
        "cmpl $0, " SYM("nh_sim") "\n\tje 1f\n\t"
        "pushal\n\tcall " SYM("nh_rj1_ret") "\n\tmovl %eax, 32(%esp)\n\tpopal\n\tret\n"
        "1:\n\tjmp *" SYM("nh_readjoy1"));
}

__attribute__((naked)) static void rj2_stub(void)
{
    __asm__ volatile(
        "cmpl $0, " SYM("nh_sim") "\n\tje 1f\n\t"
        "pushal\n\tcall " SYM("nh_rj2_ret") "\n\tmovl %eax, 32(%esp)\n\tpopal\n\tret\n"
        "1:\n\tjmp *" SYM("nh_readjoy2"));
}

static int entry_is(const char *fn, uint32_t n)
{
    const uint8_t *p = (const uint8_t *)fn;
    uint32_t v;
    memcpy(&v, p + 1, 4);
    return p[0] == 0x68 && v == n;
}

static int call_to(uint32_t site, const void *target)    /* call rel32 at site goes to target */
{
    const uint8_t *p = GAME_ADDR(site);
    int32_t rel;
    memcpy(&rel, p + 1, 4);
    return p[0] == 0xE8 && p + 5 + rel == (const uint8_t *)target;
}

static void set_call(uint32_t site, void *to)
{
    uint8_t *p = GAME_ADDR(site);
    int32_t rel = (int32_t)((uintptr_t)to - ((uintptr_t)p + 5));
    patch_bytes(p + 1, &rel, 4);
}

/* after install_overrides, before the game thread starts */
/* NHL95_ONLINE=host|join (a test aid): opens a loopback room as Host / Join would (UDP, Windows may prompt).
 * NHL95_NETSIM="delay,jitter,loss%" makes the link bad. Do not set NHL95_AUTOSKIP for a season (it starts an exhibition). */
static int watchdog(void *arg)
{
    (void)arg;
    for (;;) {
        SDL_Delay(5000);
        fprintf(stderr, "watch: consumed %u, queue %u..%u, due %d, hi %u, vif %d, quiet %d, dead %d, lock holder: %s, ticks %u\n", (unsigned)nh_consumed, (unsigned)nh_head,
                (unsigned)nh_tail, (int)nh_due, (unsigned)nh_hi, (int)vif, (int)nh_quiet, (int)nh_dead, nh_where, (unsigned)inputticks);
    }
    return 0;
}

static void online_env(void)
{
    const char *e = getenv("NHL95_ONLINE");
    if (!e) return;
    memset(&nh_cfg, 0, sizeof nh_cfg);
    snprintf(nh_cfg.name, sizeof nh_cfg.name, "%s", !strcmp(e, "host") ? "Host" : "Guest");
    nh_cfg.role = !strcmp(e, "host") ? 0 : 1;
    snprintf(nh_cfg.addr, sizeof nh_cfg.addr, "127.0.0.1");
    nh_cfg.port = getenv("NHL95_PORT") ? atoi(getenv("NHL95_PORT")) : 41950;
    nh_cfg.delay = 0;
    nh_cfg.here = 1;
    nh_cfg.all = 2;
    nh_armed = 1;
    SDL_CreateThread(watchdog, "nh-watch", NULL);
    {
        char err[160];
        err[0] = 0;
        if (room_open(err, (int)sizeof err)) fprintf(stderr, "online: room failed: %s\n", err);
        else fprintf(stderr, "online: armed as %s on port %d (Windows may prompt for the firewall)\n", e, nh_cfg.port);
    }
}

void netplay_install(void)
{
    static const uint8_t sit_head[6] = { 0x53, 0x51, 0x52, 0x56, 0x83, 0x3D };
    const uint8_t *s = (const uint8_t *)SampleInputTick, *q;
    uint32_t a;
    int ok = 1;
    if (!nh_lock) nh_lock = SDL_CreateMutex();
    memcpy(&a, s + 6, 4);
    if (memcmp(s, sit_head, 6) || a != (uint32_t)(uintptr_t)&joysampling || s[10] != 0) ok = 0;
    if (!entry_is(joyq_peek, 8) || !entry_is(joyq_pop, 0x14) || !entry_is(joyq_flush, 8) || !entry_is(RunGameFrames, 0x0C) ||
        !entry_is(PlayGame, 0x64) || !entry_is(PaSpeechBusy, 4) || !entry_is(SpeechBusy, 4) || !entry_is(Crowd_Noise, 0x14) ||
        !entry_is(IntermissionPC, 0x1C) || !entry_is(ThreeStarsLoop, 0x28) || !entry_is(InitGameSummary, 0x1C)) ok = 0;
    if (!call_to(RJ1_SITE, ReadJoy1) || !call_to(RJ2_SITE, ReadJoy2) || !randseed_ptr()) ok = 0;
    q = GAME_ADDR(RJ1_SITE + 5);                            /* mov ah, [regd1] / test ah, 10h / jne .4 / test ah, 20h / je .5 */
    if (q[0] != 0x8A || q[6] != 0xF6 || q[8] != 0x10 || q[9] != 0x75 || q[11] != 0xF6 || q[13] != 0x20 || q[14] != 0x74 ||
        q + 16 + (int8_t)q[15] != GAME_ADDR(RJ2_SITE) || q + 11 + (int8_t)q[10] != GAME_ADDR(RJ_SKIP)) ok = 0;
    q = GAME_ADDR(RJ2_SITE + 5);                            /* the same, then call WaitTickDeadline */
    if (q[0] != 0x8A || q[6] != 0xF6 || q[9] != 0x75 || q[11] != 0xF6 || q[14] != 0x75 || q + 16 != GAME_ADDR(RJ_NONE) ||
        GAME_ADDR(RJ_NONE)[0] != 0xE8) ok = 0;
    if (!ok || !nh_lock) { fprintf(stderr, "online play: the game's code is not as expected, not available\n"); return; }
    nh_peek_cont = joyq_peek + 5; nh_pop_cont = joyq_pop + 5; nh_flush_cont = joyq_flush + 5; nh_rgf_cont = RunGameFrames + 5;
    nh_pg_cont = PlayGame + 5; nh_pab_cont = PaSpeechBusy + 5; nh_spb_cont = SpeechBusy + 5; nh_crowd_cont = Crowd_Noise + 5;
    nh_inter_cont = IntermissionPC + 5; nh_tsl_cont = ThreeStarsLoop + 5; nh_sit_cont = SampleInputTick + 11;
    nh_readjoy1 = ReadJoy1; nh_readjoy2 = ReadJoy2;
    patch_jmp(joyq_peek, peek_entry);
    patch_jmp(joyq_pop, pop_entry);
    patch_jmp(joyq_flush, flush_entry);
    patch_jmp(RunGameFrames, rgf_entry);
    patch_jmp(PlayGame, pg_entry);
    patch_jmp(PaSpeechBusy, pab_entry);
    patch_jmp(SpeechBusy, spb_entry);
    patch_jmp(Crowd_Noise, crowd_entry);
    patch_jmp(IntermissionPC, inter_entry);
    patch_jmp(ThreeStarsLoop, tsl_entry);
    patch_jmp(SampleInputTick, sit_entry);
    set_call(RJ1_SITE, rj1_stub);
    set_call(RJ2_SITE, rj2_stub);
    nh_ok = 1;
    online_env();
}

/* ---- the main thread ---- */
void netplay_main_poll(void)
{
    if (nh_lock) {
        static int64_t since;
        if (SDL_TryLockMutex(nh_lock) == 0) {
            since = 0;
            poll_nets_locked();
            SDL_UnlockMutex(nh_lock);
        } else {
            int64_t now = plat_now_ns();
            static int64_t said;
            if (!since) since = now;
            if (now - since > 2000000000LL && now - said > 2000000000LL && getenv("NHL95_ONLINE")) { said = now; fprintf(stderr, "online: the main thread has waited %.1f s for the session lock; the game thread is in %s\n", (now - since) / 1e9, nh_where); }
        }
    }
    if (nh_want_page) {
        nh_want_page = 0;
        if (!overbar_client_open()) { overbar_client_online_open(); nh_opened_page = 1; }
    }
    if (nh_close_page) {
        nh_close_page = 0;
        if (nh_opened_page && overbar_client_open()) overbar_client_close();
        nh_opened_page = 0;
    }
}

/* ---- the Online page's hooks (main thread) and its settings file ---- */
static void ini_path(char *out, size_t n)
{
    char *base = SDL_GetBasePath();
    snprintf(out, n, "%shockey-online.ini", base ? base : "");
    SDL_free(base);
}

static void ini_save(const ob_online *o)
{
    char path[1024];
    FILE *f;
    ini_path(path, sizeof path);
    f = fopen(path, "w");
    if (!f) return;
    fprintf(f, "; NHL Hockey 95 (SDL2 port): the Online page's last settings. role: 0 host, 1 join, 2 both connect\n");
    fprintf(f, "name=%s\nrole=%d\naddress=%s\nport=%d\ndelay=%d\n", o->name, o->role, o->addr, o->port, o->delay);
    fclose(f);
}

static void ini_load(ob_online *o)
{
    char path[1024], line[256];
    FILE *f;
    ini_path(path, sizeof path);
    f = fopen(path, "r");
    if (!f) return;
    while (fgets(line, sizeof line, f)) {
        char *v = strchr(line, '='), *e;
        if (!v || line[0] == ';') continue;
        *v++ = 0;
        for (e = v + strlen(v); e > v && (e[-1] == '\n' || e[-1] == '\r' || e[-1] == ' '); ) *--e = 0;
        if (!strcmp(line, "name")) snprintf(o->name, sizeof o->name, "%s", v);
        else if (!strcmp(line, "role")) o->role = atoi(v) >= 0 && atoi(v) <= 2 ? atoi(v) : 0;
        else if (!strcmp(line, "address")) snprintf(o->addr, sizeof o->addr, "%s", v);
        else if (!strcmp(line, "port")) o->port = atoi(v) > 0 && atoi(v) < 65536 ? atoi(v) : OB_NET_PORT_DEFAULT;
        else if (!strcmp(line, "delay")) o->delay = atoi(v) < 0 ? 0 : atoi(v) > 10 ? 10 : atoi(v);
    }
    fclose(f);
}

static int online_start(const ob_online *o, char *msg, int msg_size)
{
    int busy;
    if (!nh_ok) { snprintf(msg, (size_t)msg_size, "the game's code is not as expected"); return -1; }
    SDL_LockMutex(nh_lock);
    busy = nh_room != NULL;
    SDL_UnlockMutex(nh_lock);
    if (busy || nh_sim) { snprintf(msg, (size_t)msg_size, "a session is on: Leave it first"); return -1; }
    nh_cfg = *o;
    nh_cfg.here = 1;
    nh_cfg.all = 2;
    ini_save(o);
    nh_why[0] = 0;
    nh_armed = 1;
    if (room_open(msg, msg_size)) { nh_armed = 0; return -1; }
    fprintf(stderr, "online: room listening (Windows may prompt for the firewall)\n");
    return 0;
}

static void online_leave(void)
{
    nh_armed = 0;
    close_room("you left");
}

static int online_status(char *line, int size)
{
    int on = 0;
    line[0] = 0;
    SDL_LockMutex(nh_lock);
    if (nh_net) {
        ob_net_status(nh_net, line, size);
        on = ob_net_state(nh_net) != OB_NET_ENDED;
    }
    SDL_UnlockMutex(nh_lock);
    if (!nh_net) {
        if (nh_armed) {
            snprintf(line, (size_t)size, "%s%sboth players: start the same game", nh_why[0] ? nh_why : "", nh_why[0] ? "; " : "");
            on = 1;
        } else snprintf(line, (size_t)size, "%s", nh_why);
    }
    return on;
}

static const char *online_lan(char *buf, int size)
{
    const char *a = ob_net_lan_address(buf, size);
    return a && a[0] ? a : NULL;
}

void netplay_online_setup(ob_host *h)
{
    ob_online_ops ops;
    if (!nh_lock) nh_lock = SDL_CreateMutex();
    memset(&ops, 0, sizeof ops);
    ops.max_pads = NH_PADS;
    ops.max_delay = 10;
    ops.roles = 3;
    ops.start = online_start;
    ops.leave = online_leave;
    ops.status = online_status;
    ops.lan_address = online_lan;
    ini_load(&h->online);
    h->online.here = 1;
    h->online.all = 2;
    ob_online_set_ops(h, &ops);
}
