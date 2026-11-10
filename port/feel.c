/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * 95 PC's feel options (port/feel.h). The numbers of 94 Genesis come from NHL94Genesis-C-Port (logic.c playeracc,
 * stopna, doplayeracc; hockey.c DoGameFrame), turned into 60 Hz frames:
 *
 *   - The cartridge runs most passes in one vblank and some in two (its slowdown, elapsed 2): about 51 a second in
 *     play (NHL94Genesis-C-Port docs/RULES.md: 83% of the waits in play had no lag). Its acceleration is times
 *     elapsed, so per second it is the same at either timing; the turn step and the stop step are per pass, so the
 *     cartridge's are 51/60 of them per frame (turn 14 of 16, stop 128 of 150); friction (velocity >> 6 a pass) stays
 *     >> 6 a frame, the nearest shift. Smooth (the C port's default) runs every vblank, and is the
 *     default here too: Cartridge times only the skating, while the puck, checks and the AI stay at 95 PC's 60 a
 *     second, and Abdul found it felt wrong in play (2026-11-09).
 *   - Positions move by velocity x 17 a vblank on the Genesis and x 16 a frame on 95 PC: 94G speeds are times 17/16
 *     here to move as many rink units a second ("per pixel"). "Scaled to rink" also takes them times 528/596, the
 *     length of 95 PC's rink (end boards 264) over 94G's (298), so a skater crosses it in the same time.
 *   - 94G ratings: speed and agility are rating x 5 (0-30, its ratings run 0-6), weight is rating x 8. 95 PC's run
 *     0-15 (shown as (r + 5) x 5) and setplayer keeps speed and agility less 3; here 94G's are 2 x (95 PC's + 3), at
 *     most 30, and weight x 8.
 *
 * Only skaters get 94G's numbers: goalies and the referee (object 10h) keep 95 PC's. Fatigue stays 95 PC's.
 */
#include "feel.h"

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifndef FEEL_TEST
#include "host.h"
#endif

#ifdef _WIN32
#define SYM(s) "_" s
#else
#define SYM(s) s
#endif

/* ---- the game's data ---- */
extern int16_t dirtab[], dirtab_y[];
extern int32_t MaxSpeed[];
extern uint8_t gmode;
extern uint32_t gameopts;
extern int32_t regd0, regd1, regd2, regd3;     /* the 68k registers of the Genesis code: .w is the low word */
extern int32_t doplayeracc_ftab[];
extern char updateplayers[], stopna[], playeracc[];

/* Player fields (src/include/structs.h) */
#define P_W(p, o) (*(int16_t *)((p) + (o)))
#define P_B(p, o) (*(uint8_t *)((p) + (o)))
#define P_SB(p, o) (*(int8_t *)((p) + (o)))
#define P_YPOS_HI(p) (*(int16_t *)((p) + 0x06))
#define P_XVEL 0x0C
#define P_YVEL 0x0E
#define P_POSITION 0x1A
#define P_WALLCOS 0x30
#define P_WALLSIN 0x32
#define P_PFLAGS2 0x45
#define P_PNUM 0x47
#define P_WEIGHT 0x56
#define P_LEGSTR 0x57
#define P_LEGSPD 0x58
#define P_ENDURANCE 0x61
#define P_SCNUM 0x6A
#define P_TMPTR 0x6C
#define T_TMPDE 0x46

#define W(r) (*(int16_t *)&(r))                    /* a register's word */

static int16_t *tmpde_of(uint8_t *p)
{
    uint8_t *t = *(uint8_t **)(p + P_TMPTR);
    return (int16_t *)(t + T_TMPDE) + P_SB(p, P_PNUM);
}

/* randomd0 (eax = range, ax = 0..range-1), the game's own generator: online play stays in step */
#ifdef FEEL_TEST
int feel_test_random(int range);
static int game_random(int range) { return feel_test_random(range); }
#else
static int game_random(int range)
{
    int r;
    __asm__ volatile("call " SYM("randomd0") : "=a"(r) : "a"(range) : "ecx", "edx", "memory", "cc");
    return (int16_t)r;
}
#endif

/* ---- the profile ---- */
static volatile feel_profile now;

const feel_profile *feel_now(void) { return (const feel_profile *)&now; }

static const int ms94[16] = {          /* 94G MaxSpeed: (20..35) x 275 (the table holds them squared) */
    5500, 5775, 6050, 6325, 6600, 6875, 7150, 7425, 7700, 7975, 8250, 8525, 8800, 9075, 9350, 9625
};

/* a 94G speed in 95 PC units, x 1/256 */
static int scale256(int src)
{
    return src == FEEL_94G_RINK ? 241 : 272;    /* 17/16 x 528/596, 17/16 */
}

static int r94(int v95, int add)
{
    int v = 2 * (v95 + add);
    return v > 30 ? 30 : v;
}

/* 94G's speed cap (squared) for a skater: the energy picks the step of the speed rating, an odd rating is half a
 * step up (logic.c playeracc) */
static uint32_t cap94(uint8_t *p, int src)
{
    int spd = r94(P_B(p, P_LEGSPD), 3);
    uint16_t e = (uint16_t)*tmpde_of(p);
    uint32_t prod = ((uint32_t)(spd >> 1) * e) << 4;
    unsigned idx4 = ((prod >> 16) << 2) & 0x3F;
    uint64_t cur = (uint64_t)ms94[idx4 / 4] * (uint64_t)ms94[idx4 / 4], cap = cur;
    int k = scale256(src);
    if (idx4 < 0x3C && (spd & 1)) {
        uint64_t nxt = (uint64_t)ms94[(idx4 + 4) / 4] * (uint64_t)ms94[(idx4 + 4) / 4];
        cap = ((nxt - cur) >> 1) + cur;
    }
    cap = cap * (uint64_t)(k * k) >> 16;
    return cap > 0xFFFFFFFFu ? 0xFFFFFFFFu : (uint32_t)cap;
}

static int is_skater(uint8_t *p)
{
    return P_W(p, P_POSITION) != 0 && P_W(p, P_SCNUM) != 0x10;
}

/* ---- playeracc (5EDAD): eax = player, edx = direction ---- */
static void playeracc_body(uint8_t *p, int dir);

#ifndef FEEL_TEST
/* NHL95_FEEL_LOG=file: every 5 seconds of skating, each skater's top speed in rink units a second (velocity x 16 a
 * frame, 16.16) and ratings, for comparing the presets on the laptop */
#include <math.h>
static FILE *feel_log;
static int log_checked;
static struct { uint8_t *p; int legspd, legstr, weight, energy; double top; } seen[32];
static int nseen, calls;

static void log_speed(uint8_t *p)
{
    int k;
    double v;
    if (!log_checked) {
        const char *path = getenv("NHL95_FEEL_LOG");
        log_checked = 1;
        if (path) feel_log = fopen(path, "a");
        if (feel_log) fprintf(feel_log, "feel log: speed %d accel %d stop %d glide %d turn %d cartridge %d\n",
                              now.speed, now.accel, now.stop, now.glide, now.turn, now.cartridge);
    }
    if (!feel_log || !is_skater(p)) return;
    for (k = 0; k < nseen && seen[k].p != p; k++) {}
    if (k == nseen) {
        if (nseen == 32) return;
        nseen++;
        seen[k].p = p;
        seen[k].top = 0;
    }
    v = sqrt((double)P_W(p, P_XVEL) * P_W(p, P_XVEL) + (double)P_W(p, P_YVEL) * P_W(p, P_YVEL)) * 16 * 60 / 65536;
    if (v > seen[k].top) seen[k].top = v;
    seen[k].legspd = P_B(p, P_LEGSPD); seen[k].legstr = P_B(p, P_LEGSTR); seen[k].weight = P_B(p, P_WEIGHT);
    seen[k].energy = *tmpde_of(p);
    if (++calls < 10 * 60 * 5) return;
    calls = 0;
    fprintf(feel_log, "profile speed %d accel %d stop %d glide %d turn %d cartridge %d\n", now.speed, now.accel, now.stop, now.glide,
            now.turn, now.cartridge);
    for (k = 0; k < nseen; k++) {
        fprintf(feel_log, "  skater %08x legspd %2d legstr %2d weight %2d energy %4x top %.1f\n", (unsigned)(uintptr_t)seen[k].p,
                seen[k].legspd, seen[k].legstr, seen[k].weight, seen[k].energy, seen[k].top);
        seen[k].top = 0;
    }
    fflush(feel_log);
}
#else
static void log_speed(uint8_t *p) { (void)p; }
#endif

void feel_playeracc(uint8_t *p, int dir)
{
    playeracc_body(p, dir);
    log_speed(p);
}

static void playeracc_body(uint8_t *p, int dir)
{
    int i = (int16_t)(dir * 2);
    int x, y, d2, legstr = P_B(p, P_LEGSTR), sk = is_skater(p);
    uint32_t cap;
    int16_t e;
    if (sk && now.accel != FEEL_95PC) {
        /* 94G: dirtab x (64 - weight/4 + agility) / 2 >> 5, the wall tests on it, then to 95 PC's units */
        int k = scale256(now.accel);
        x = dirtab[i];
        y = dirtab_y[i];
        if (P_W(p, P_WALLSIN) != 0 && (P_W(p, P_WALLSIN) ^ (int16_t)x) < 0) x = 0;
        if (P_W(p, P_WALLCOS) != 0 && (P_W(p, P_WALLCOS) ^ (int16_t)y) >= 0) y = 0;
        d2 = (64 - ((P_B(p, P_WEIGHT) * 8) >> 2) + r94(legstr, 3)) >> 1;
        x = (x * d2 >> 5) * k / 256;
        y = (y * d2 >> 5) * k / 256;
        W(regd2) = (int16_t)d2;
        regd0 = x;
        regd1 = y;
    } else {
        x = dirtab[i] * (legstr + 0x30) / 64;
        y = dirtab_y[i] * (legstr + 0x30) / 64;
        if (P_W(p, P_WALLSIN) != 0 && (P_W(p, P_WALLSIN) ^ (int16_t)x) < 0) x = 0;
        if (P_W(p, P_WALLCOS) != 0 && (P_W(p, P_WALLCOS) ^ (int16_t)y) >= 0) y = 0;
        W(regd2) = (int16_t)(0x20 - (P_B(p, P_WEIGHT) >> 3) + legstr);
        if (P_W(p, P_POSITION) == 0) W(regd2) = (int16_t)(W(regd2) + legstr + 0x14);
        regd0 = (int16_t)x * W(regd2) >> 5;
        regd1 = W(regd2) * (int16_t)y >> 5;
    }
    W(regd0) = (int16_t)(W(regd0) + P_W(p, P_XVEL));
    W(regd1) = (int16_t)(W(regd1) + P_W(p, P_YVEL));
    regd3 = W(regd0) * W(regd0) + W(regd1) * W(regd1);
    if (P_W(p, P_SCNUM) == 0x10) {
        int yy = P_YPOS_HI(p);
        if (yy < 0) yy = -yy;
        regd2 = (gmode & 1) && yy >= 0x74 ? 0xC : 0xF;
        cap = (uint32_t)MaxSpeed[W(regd2)];
    } else if (sk && now.speed != FEEL_95PC) {
        cap = cap94(p, now.speed);
    } else {
        regd2 = (int32_t)((uint32_t)(P_B(p, P_LEGSPD) * *tmpde_of(p)) >> 12);
        cap = (uint32_t)MaxSpeed[W(regd2)];
    }
    regd2 = (int32_t)cap;
    if (P_B(p, P_PFLAGS2) & 0x40) regd2 = (int32_t)cap >> 3;      /* injured: 1/8 */
    if (!((uint32_t)regd3 > (uint32_t)regd2)) {
        P_W(p, P_XVEL) = W(regd0);
        P_W(p, P_YVEL) = W(regd1);
    }
    /* fatigue (95 PC's): 1 time in 128, 28h less energy; from C00h up the endurance comes back, to 1000h */
    if (P_W(p, P_SCNUM) == 0x10 || !(gameopts & 4) || (gmode & 1) || P_W(p, P_POSITION) == 0) return;
    W(regd0) = (int16_t)game_random(0x80);
    if (W(regd0) != 0) return;
    e = (int16_t)(*tmpde_of(p) - 0x28);
    W(regd0) = e;
    if (e < 0xC00) {
        *tmpde_of(p) = e < 0 ? 0 : e;
        return;
    }
    W(regd0) = (int16_t)(e + P_B(p, P_ENDURANCE));
    if (W(regd0) > 0x1000) W(regd0) = 0x1000;
    *tmpde_of(p) = W(regd0) < 0 ? 0 : W(regd0);
}

/* ---- stopna (5F82A): eax = player. Velocity toward 0 by a step. ---- */
void feel_stopna(uint8_t *p)
{
    int step, v;
    if (is_skater(p) && now.stop != FEEL_95PC) {
        step = now.cartridge ? 128 : 150;                   /* 94G: 96h a pass; the cart's ~51 passes a second */
        step = step * scale256(now.stop) / 256;
    } else {
        step = 0xC8 + P_B(p, P_LEGSTR);
        if (P_W(p, P_POSITION) == 0) step += 2 * P_B(p, P_LEGSTR);
    }
    v = P_W(p, P_XVEL);
    if (v < 0) { v = (int16_t)(v + step); if (v > 0) v = 0; }
    else { v = (int16_t)(v - step); if (v < 0) v = 0; }
    P_W(p, P_XVEL) = (int16_t)v;
    v = P_W(p, P_YVEL);
    if (v < 0) { v = (int16_t)(v + step); if (v > 0) v = 0; }
    else { v = (int16_t)(v - step); if (v < 0) v = 0; }
    P_W(p, P_YVEL) = (int16_t)v;
}

#ifndef FEEL_TEST
/* ---- the constants written in place ---- */
/* updateplayers (5C40F): the friction shift, mov dword [regd2], 9 / 6 (falling / skating), at +29Bh and +2A7h */
#define FRICTION_FALL (0x5C6AA - 0x5C40F)
#define FRICTION_SKATE (0x5C6B6 - 0x5C40F)
static int friction_ok;
static int ftab_ok;

static int check_friction(void)
{
    const uint8_t *a = (const uint8_t *)updateplayers + FRICTION_FALL, *b = (const uint8_t *)updateplayers + FRICTION_SKATE;
    return a[0] == 0xC7 && a[1] == 0x05 && a[6] == 9 && b[0] == 0xC7 && b[1] == 0x05 && b[6] == 6;
}

static void apply_constants(void)
{
    if (friction_ok) {
        /* a skater down keeps 95 PC's slide: its checks and falls are still 95 PC's, made for that friction */
        int half = 0;   /* the cart's friction (>> 6 a pass at ~51 passes a second) is nearer 6 a frame than 7 */
        uint8_t fall = 9, skate = (uint8_t)(half ? 7 : 6);
        patch_bytes((uint8_t *)updateplayers + FRICTION_FALL + 6, &fall, 1);
        patch_bytes((uint8_t *)updateplayers + FRICTION_SKATE + 6, &skate, 1);
    }
    if (ftab_ok) {
        /* doplayeracc's turn steps: 0, 16, 16, 16, 0, -16, -16, -16, a step a game pass, the same code and table as
         * 94G's. The cartridge does not run 30 passes a second in play: most passes take one vblank and some two
         * (its slowdown; NHL94Genesis-C-Port docs/RULES.md, measured against Genesis Plus GX: 83% of the waits in
         * play had no lag), about 51 passes a second. So 94G turning with the Cartridge timing is 14 a frame (16 x
         * 51 / 60, rounded); Smooth (a pass every vblank) is 16, as 95 PC. Half (8) steered far too slowly (Abdul,
         * 2026-11-09). */
        int step = now.turn && now.cartridge ? 14 : 16, i;
        for (i = 0; i < 8; i++) {
            int32_t v = (i == 0 || i == 4) ? 0 : (i < 4 ? step : -step);
            patch_bytes(&doplayeracc_ftab[i], &v, 4);
        }
    }
}

__attribute__((naked)) static void playeracc_entry(void)
{
    __asm__ volatile("pushal\n\tpush %edx\n\tpush %eax\n\tcall " SYM("feel_playeracc") "\n\tadd $8, %esp\n\tpopal\n\tret");
}

__attribute__((naked)) static void stopna_entry(void)
{
    __asm__ volatile("pushal\n\tpush %eax\n\tcall " SYM("feel_stopna") "\n\tadd $4, %esp\n\tpopal\n\tret");
}

void feel_install(void)
{
    static const int32_t ftab[8] = { 0, 16, 16, 16, 0, -16, -16, -16 };
    friction_ok = check_friction();
    ftab_ok = !memcmp(doplayeracc_ftab, ftab, sizeof ftab);
    if (!friction_ok) fprintf(stderr, "Feel: updateplayers is not the expected code, the glide option is off\n");
    if (!ftab_ok) fprintf(stderr, "Feel: doplayeracc's turn table is not the expected one, the turn option is off\n");
    patch_jmp(playeracc, playeracc_entry);
    patch_jmp(stopna, stopna_entry);
    apply_constants();
}
#else
static void apply_constants(void) {}
#endif

void feel_set_profile(const feel_profile *f)
{
    now.speed = f->speed; now.accel = f->accel; now.stop = f->stop;
    now.glide = f->glide; now.turn = f->turn; now.cartridge = f->cartridge;
    apply_constants();
}

/* ---- the Game page ---- */
enum { O_PRESET, O_TIMING, O_SPEED, O_ACCEL, O_STOP, O_GLIDE, O_TURN, O_FIGHTS, O_FIGHT_BOX, O_FIGHT_NEXT, O_AUTOLINE, O_GOALIE, O_COUNT };
enum { PRESET_ORIGINAL, PRESET_94G, PRESET_94G_RINK, PRESET_CUSTOM };

static const char *const preset_names[] = { "Original (95 PC)", "94 Genesis", "94 Genesis, scaled to rink", "Custom" };
static const char *const timing_names[] = { "Cartridge (about 51 a second, skating only)", "Smooth (60 a second)" };
static const char *const src_names[] = { "95 PC", "94 Genesis", "94 Genesis, scaled to rink" };
static const char *const two_names[] = { "95 PC", "94 Genesis" };
static const char *const onoff_names[] = { "Off", "On" };
static const char *const fightbox_names[] = { "Moves to the top right", "Hides" };

static const ob_game_opt opts[O_COUNT] = {
    { "feel", "Feel", preset_names, 4, PRESET_ORIGINAL, 1, 0 },
    { "feel_timing", "94 Genesis timing", timing_names, 2, 1, 1, 0 },
    { "feel_top_speed", "Top speed", src_names, 3, 0, 1, 1 },
    { "feel_acceleration", "Acceleration", src_names, 3, 0, 1, 1 },
    { "feel_stopping", "Stopping", src_names, 3, 0, 1, 1 },
    { "feel_glide", "Glide", two_names, 2, 0, 1, 1 },
    { "feel_turning", "Turning", two_names, 2, 0, 1, 1 },
    { "fights", "Fights (NHLPA 93's)", onoff_names, 2, 1, 1, 2 },
    { "fight_box", "Names box over the fighters", fightbox_names, 2, 0, 1, 2 },
    { "fight_next_check", "Debug: fight on the next check", onoff_names, 2, 0, 0, 2 },
    { "auto_lines", "Auto line changes", onoff_names, 2, 0, 1, 3 },
    { "manual_goalie", "Manual goalie", onoff_names, 2, 0, 1, 3 },
};

/* what a preset sets: speed, accel, stop, glide, turn */
static const int preset_rows[3][5] = {
    { 0, 0, 0, 0, 0 },
    { 1, 1, 1, 1, 1 },
    { 2, 2, 2, 1, 1 },
};

static ob_host *g_host;
static int loading;

static void profile_from_rows(void)
{
    feel_profile f;
    f.cartridge = ob_game_get(g_host, O_TIMING) == 0;
    f.speed = ob_game_get(g_host, O_SPEED);
    f.accel = ob_game_get(g_host, O_ACCEL);
    f.stop = ob_game_get(g_host, O_STOP);
    f.glide = ob_game_get(g_host, O_GLIDE);
    f.turn = ob_game_get(g_host, O_TURN);
    feel_set_profile(&f);
}

static int matching_preset(void)
{
    int p, k;
    for (p = 0; p < 3; p++) {
        for (k = 0; k < 5; k++) if (ob_game_get(g_host, O_SPEED + k) != preset_rows[p][k]) break;
        if (k == 5) return p;
    }
    return PRESET_CUSTOM;
}

void settings_save_all(void);

static void changed(void *ctx, int index, int value)
{
    (void)ctx;
    if (index == O_PRESET && value != PRESET_CUSTOM) {
        int k;
        for (k = 0; k < 5; k++) ob_game_set(g_host, O_SPEED + k, preset_rows[value][k]);
    } else if (index >= O_SPEED && index <= O_TURN)
        ob_game_set(g_host, O_PRESET, matching_preset());
    if (index == O_AUTOLINE && value)
        gameopts |= 4;                  /* 96 PC Auto includes line changes on (gameopts bit 2) */
    profile_from_rows();
#ifndef FEEL_TEST
    if (!loading) settings_save_all();
#endif
}

void feel_register(ob_host *h, const char *ini_path)
{
    ob_game_ops ops;
    FILE *f;
    char line[256];
    g_host = h;
    memset(&ops, 0, sizeof ops);
    ops.title = "Game";
    ops.opts = opts;
    ops.nopts = O_COUNT;
    ops.changed = changed;
    loading = 1;
    ob_game_set_ops(h, &ops);
    f = ini_path ? fopen(ini_path, "r") : NULL;
    if (f) {
        while (fgets(line, sizeof line, f)) {
            char *v = strchr(line, '='), *e;
            if (!v || strncmp(line, "game_", 5)) continue;
            *v++ = 0;
            for (e = v + strlen(v); e > v && (e[-1] == '\n' || e[-1] == '\r' || e[-1] == ' '); ) *--e = 0;
            ob_game_read_ini(h, line, v);
        }
        fclose(f);
    }
    /* the preset row follows the feature rows the file gave */
    ob_game_set(h, O_PRESET, matching_preset());
    /* NHL95_FEEL=0-2 (a preset), NHL95_FEEL_TIMING=0 cartridge / 1 smooth: a test aid, not written to the ini */
    if (getenv("NHL95_FEEL_TIMING")) ob_game_set(h, O_TIMING, atoi(getenv("NHL95_FEEL_TIMING")) ? 1 : 0);
    if (getenv("NHL95_FEEL")) {
        int v = atoi(getenv("NHL95_FEEL")), k;
        if (v >= 0 && v < 3) {
            for (k = 0; k < 5; k++) ob_game_set(h, O_SPEED + k, preset_rows[v][k]);
            ob_game_set(h, O_PRESET, v);
        }
    }
    if (getenv("NHL95_AUTOLINE")) ob_game_set(h, O_AUTOLINE, atoi(getenv("NHL95_AUTOLINE")) ? 1 : 0);
    if (getenv("NHL95_GOALIE")) ob_game_set(h, O_GOALIE, atoi(getenv("NHL95_GOALIE")) ? 1 : 0);
    profile_from_rows();
    (void)feel_auto_lines();            /* Auto on keeps gameopts bit 2 set before the first faceoff */
    loading = 0;
}

int feel_fights(void)
{
    return g_host ? ob_game_get(g_host, O_FIGHTS) : 1;
}

int feel_fight_box(void)
{
    return g_host ? ob_game_get(g_host, O_FIGHT_BOX) : 0;
}

int feel_fight_next(void)
{
    return g_host ? ob_game_get(g_host, O_FIGHT_NEXT) : 0;
}

int feel_auto_lines(void)
{
    int on = g_host ? ob_game_get(g_host, O_AUTOLINE) : 0;
    if (on) gameopts |= 4;              /* 96 PC Auto includes line changes on (chk4lc tests this bit) */
    return on;
}

int feel_manual_goalie(void)
{
    return g_host ? ob_game_get(g_host, O_GOALIE) : 0;
}

void feel_fight_next_done(void)
{
    if (g_host) ob_game_set(g_host, O_FIGHT_NEXT, 0);
}

void feel_session_begin(const char *text, size_t size)
{
    if (!g_host) return;
    loading = 1;
    ob_game_session_begin(g_host, text, size);
    loading = 0;
}

void feel_session_end(void)
{
    if (!g_host) return;
    loading = 1;
    ob_game_session_end(g_host);
    loading = 0;
}

void feel_write_ini(FILE *f)
{
    if (!g_host || !f) return;
    fprintf(f, "; the Game page. feel: a preset; feel_timing: 94 Genesis's cartridge timing (about 51 game passes a second, its slowdown)\n"
               "; or Smooth (60); each feature: 95 PC, 94 Genesis (as many rink units a second), or 94 Genesis scaled to rink (95 PC's rink is shorter)\n"
               "; auto_lines: 96 PC Auto line changes (CompLine at faceoff for a human team, chk4lc on the fly)\n"
               "; manual_goalie: 96 PC Manual (B-hold takes the goalie, A dives, C a save); 94 Genesis move and save anims\n");
    ob_game_write_ini(g_host, f);
}
