/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * The game side of NHLPA 93's fights (port/fight/hooks.h, HOOKS.md). Stage 1: a fight starts where 93's checkfight
 * did (after checkcheck in checkcx), port/fight/rules.c runs it once a frame before updateplayers, and it ends with
 * a penalty for both. The fighters keep 95 PC's own sprites for now (the 93 frames come in stage 2), and a human
 * fighter is played by the computer.
 *
 * 95 PC kept 93's pf2fight (pflags2 bit 0): a player with it gets no joystick skating and no collisions or falls,
 * and the puck's bit makes the others face xc1 / yc1. Faceoffs clear the bit.
 */
#include "hooks.h"
#include "rules.h"
#include "rom93.h"
#include "punch.h"

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "../host.h"
#include "../feel.h"

#ifdef _WIN32
#define SYM(s) "_" s
#else
#define SYM(s) s
#endif

extern char checkcx[], checkcheck[], DoGameFrame[], updateplayers[];
extern uint8_t SortCords[], puckstruct[];
extern uint8_t gmode, sflags, puckpflags2;
extern uint32_t gameopts;
extern int16_t gsp, xc1, yc1;
extern uint8_t *photoptrs[0x46E];
extern uint8_t byte_DC9D8[256], byte_DC8D8[256];       /* the sprite colour remaps: home, visitors */

#define P_W(p, o) (*(int16_t *)((p) + (o)))
#define P_B(p, o) (*(uint8_t *)((p) + (o)))
#define P_XPOS_HI 0x02
#define P_YPOS_HI 0x06
#define P_XVEL 0x0C
#define P_YVEL 0x0E
#define P_IMPACT 0x18
#define P_POSITION 0x1A
#define P_ASSNUM 0x1C
#define P_FRAME 0x12
#define P_FACEDIR 0x36
#define P_ATTRIBUTE 0x55
#define P_PFLAGS 0x44
#define P_PFLAGS2 0x45
#define P_AGGRESS 0x62
#define P_CHECKING 0x64
#define P_SCNUM 0x6A
#define PLAYER(i) (SortCords + (i) * 0x80)

#define PEN_ROUGHING 0x0B               /* stage 1's stand-in for Fighting (2 minutes; 93 gave 5) */
#define ASS_NOTHING 0                   /* asstab 0: rtss */
#define ASS_PUCKNOTHING 26

static fight ft;
static uint8_t *who[2];
static int checks[12], chkcnt, last_gsp = -1;
static rom93 rom;
static int have_rom, punch_on;
static int ok_check, ok_frame;

/* ---- drawing: the 93 frames as 95 PC sprites (stage 2) ----
 * 95 PC's sprite: a flag byte (non-zero: the run-length blitter), w and h at +4 / +6, the hot spot at +8 / +0Ah, then
 * from +10h: a count byte c > 0 and a colour (FFh: c transparent pixels) or c < 0 and -c literal colours, 0 ends;
 * rows follow on from each other. After updateplayers a fighter's frame is a free photoptrs slot holding his
 * current 93 frame, so DrawRinkOverlays draws it in his place, in depth order; his own frame is put back before
 * the next updateplayers. The colours are found once per fight: the 95 PC sprite index whose remapped palette
 * entry is nearest to each 93 colour (team colours among 95 PC's own team-colour indexes, 90h-BFh). */
#define NFR 1024
static uint8_t *spr[2][NFR];            /* built frames per fighter, 93 frame number */
static uint8_t lut[2][64];
static int slot[2] = { -1, -1 }, saved_frame[2], drawing;
static void free_sprites(void);
static void make_lut(int k);
static void find_slots(void);
static void undraw(void);

/* ---- the game's routines (Watcom: eax, edx) ---- */
static int game_random(void *ctx, int range)
{
    int r;
    (void)ctx;
    __asm__ volatile("call " SYM("randomd0") : "=a"(r) : "a"(range) : "ecx", "edx", "memory", "cc");
    return (int16_t)r;
}

static void add_penalty2(uint8_t *p, int pen)
{
    int a = (int)(uintptr_t)p, d = pen;
    __asm__ volatile("call " SYM("AddPenalty2") : "+a"(a), "+d"(d) : : "ecx", "memory", "cc");
}

static void ass_insert(uint8_t *p, int slot)
{
    int a = (int)(uintptr_t)p, d = slot;
    __asm__ volatile("call " SYM("assinsert") : "+a"(a), "+d"(d) : : "ecx", "memory", "cc");
}

/* back to the assignment under the one assinsert pushed */
static void ass_done(uint8_t *p) { P_W(p, P_ASSNUM) = (int16_t)((P_W(p, P_ASSNUM) + 1) & 7); }

/* ---- start (93's checkfight) ---- */
static void to_fighter(fighter *f, const uint8_t *p, int away)
{
    f->x = P_W(p, P_XPOS_HI);
    f->y = P_W(p, P_YPOS_HI);
    f->xvel = P_W(p, P_XVEL);
    f->yvel = P_W(p, P_YVEL);
    f->facedir = P_W(p, P_FACEDIR) & 7;
    f->human = 0;                       /* stage 1: the computer fights for everyone */
    f->fighting = P_B(p, P_AGGRESS) & 0xE;      /* 93's fighting rating is the nibble with bit 0 clear */
    f->checking = P_B(p, P_CHECKING) & 0xF;
    f->energy = 0x1000;
    f->away = away;
}

static int can_fight(const uint8_t *p)
{
    int sc = P_W(p, P_SCNUM);
    return sc >= 0 && sc < 12 && P_W(p, P_POSITION) > 0 && P_W(p, P_IMPACT) >= 10 && !(P_B(p, P_PFLAGS2) & 0x11);
}

void fight_check(uint8_t *a, uint8_t *b)
{
    int inst, k;
    if (ft.on || !feel_fights()) return;
    if (gsp != last_gsp) { last_gsp = gsp; chkcnt = 0; memset(checks, 0, sizeof checks); }
    if (P_W(a, P_SCNUM) < 12 && P_W(b, P_SCNUM) < 12 && P_W(a, P_IMPACT) >= 10 && P_W(b, P_IMPACT) >= 10) {
        chkcnt++;
        checks[P_W(a, P_SCNUM)]++;
        checks[P_W(b, P_SCNUM)]++;
    }
    if (!can_fight(a) || !can_fight(b)) return;
    if ((gmode & 1) || (sflags & 0x80) || (puckpflags2 & 1)) return;
    if (((P_B(a, P_PFLAGS) ^ P_B(b, P_PFLAGS)) & 0x40) == 0) return;   /* teammates */
    memset(&ft, 0, sizeof ft);
    to_fighter(&ft.f[0], a, !(P_B(a, P_PFLAGS) & 0x40));
    to_fighter(&ft.f[1], b, !(P_B(b, P_PFLAGS) & 0x40));
    ft.random = game_random;
    /* the Game page's debug row, or NHL95_FIGHT_TEST=1: every hit that may start a fight does */
    if (feel_fight_next() || getenv("NHL95_FIGHT_TEST")) { inst = -1; feel_fight_next_done(); }
    else if (!fight_wants(&ft.f[0], &ft.f[1], chkcnt, checks[P_W(a, P_SCNUM)], checks[P_W(b, P_SCNUM)], gameopts & 1, game_random,
                          NULL, &inst))
        return;
    chkcnt = 0;
    memset(checks, 0, sizeof checks);
    who[0] = a;
    who[1] = b;
    fight_begin(&ft);
    if (have_rom) {
        free_sprites();
        make_lut(0);
        make_lut(1);
        if (slot[1] < 0) find_slots();
    }
    xc1 = (int16_t)ft.xc1;
    yc1 = (int16_t)ft.yc1;
    for (k = 0; k < 2; k++) {
        P_B(who[k], P_PFLAGS2) |= 1;
        ass_insert(who[k], ASS_NOTHING);
    }
    puckpflags2 |= 1;
    ass_insert(puckstruct, ASS_PUCKNOTHING);
    if (getenv("NHL95_FIGHT_LOG"))
        fprintf(stderr, "fight: %d against %d (fighting %d / %d), instigator %d\n", P_W(a, P_SCNUM), P_W(b, P_SCNUM), ft.f[0].fighting,
                ft.f[1].fighting, inst);
}

/* ---- each frame ---- */
static void end_fight(void)
{
    int k;
    for (k = 0; k < 2; k++) {
        P_B(who[k], P_PFLAGS2) &= (uint8_t)~1;
        ass_done(who[k]);
    }
    puckpflags2 &= (uint8_t)~1;
    ass_done(puckstruct);
    for (k = 0; k < 2; k++) add_penalty2(who[k], PEN_ROUGHING);
    ft.on = 0;
}

void fight_frame(void)
{
    int k;
    undraw();
    if (!ft.on) return;
    if (gmode & 1) {                    /* play stopped some other way (a goal, the period): no penalty */
        for (k = 0; k < 2; k++) { P_B(who[k], P_PFLAGS2) &= (uint8_t)~1; ass_done(who[k]); }
        puckpflags2 &= (uint8_t)~1;
        ass_done(puckstruct);
        ft.on = 0;
        return;
    }
    for (k = 0; k < 2; k++) {
        fighter *f = &ft.f[k];
        f->x = P_W(who[k], P_XPOS_HI);
        f->y = P_W(who[k], P_YPOS_HI);
        f->xvel = P_W(who[k], P_XVEL);
        f->yvel = P_W(who[k], P_YVEL);
    }
    fight_pass(&ft, 1, NULL, NULL);
    for (k = 0; k < 2; k++) {
        fighter *f = &ft.f[k];
        P_W(who[k], P_XVEL) = (int16_t)f->xvel;
        P_W(who[k], P_YVEL) = (int16_t)f->yvel;
        P_W(who[k], P_FACEDIR) = (int16_t)f->facedir;
    }
    if ((ft.events & (FE_PUNCH_HIGH | FE_PUNCH_LOW)) && have_rom) {
        if (!punch_on) { punch_init(&rom); punch_on = 1; }
        punch_play(!(ft.events & FE_PUNCH_HIGH));
    }
    if (ft.events & FE_OVER) {
        if (getenv("NHL95_FIGHT_LOG")) fprintf(stderr, "fight: over, winner %d\n", ft.winner);
        end_fight();
    }
}

static void free_sprites(void)
{
    int k, n;
    for (k = 0; k < 2; k++)
        for (n = 0; n < NFR; n++) { free(spr[k][n]); spr[k][n] = NULL; }
}

static int dist(uint32_t a, uint32_t b)
{
    int dr = (int)(a >> 16 & 255) - (int)(b >> 16 & 255), dg = (int)(a >> 8 & 255) - (int)(b >> 8 & 255), db = (int)(a & 255) - (int)(b & 255);
    return dr * dr * 3 + dg * dg * 4 + db * db * 2;
}

static void make_lut(int k)
{
    uint32_t dac[256], pal[64];
    const uint8_t *remap = P_W(who[k], P_SCNUM) < 6 ? byte_DC9D8 : byte_DC8D8;
    int v, sidx;
    video_dac_rgb(dac);
    f93_palette(&rom, 0, 1, pal);
    f93_pc95_colours(pal);
    for (v = 1; v < 64; v++) {
        int team = v >= 32 && (v & 15) != 1 && (v & 15) != 6 && (v & 15) != 7 && (v & 15) != 14 && (v & 15) != 15;
        int lo = team ? 0x90 : 0, hi = team ? 0xC0 : 0xC0, best = -1, bd = 1 << 30;
        for (sidx = lo; sidx < hi; sidx++) {
            int d = dist(dac[remap[sidx]], pal[v]);
            if (d < bd) { bd = d; best = sidx; }
        }
        lut[k][v] = (uint8_t)best;
    }
}

static uint8_t *build(int k, int n)
{
    f93_frame f;
    uint8_t *b, *o;
    int x, y, i;
    if (f93_decode(&rom, n, &f) || !f.pix) return NULL;
    f93_pc95_frame(&f);
    b = (uint8_t *)calloc(16 + (size_t)f.w * f.h * 2 + 16, 1);
    if (!b) { f93_frame_free(&f); return NULL; }
    b[0] = 1;
    *(int16_t *)(b + 4) = (int16_t)f.w;
    *(int16_t *)(b + 6) = (int16_t)f.h;
    *(int16_t *)(b + 8) = (int16_t)-f.x0;
    *(int16_t *)(b + 10) = (int16_t)-f.y0;
    o = b + 16;
    for (y = 0; y < f.h; y++) {
        const uint8_t *row = f.pix + y * f.w;
        for (x = 0; x < f.w; ) {
            if (!row[x]) {
                for (i = 0; x + i < f.w && !row[x + i] && i < 127; i++) {}
                *o++ = (uint8_t)i; *o++ = 0xFF;
            } else {
                for (i = 0; x + i < f.w && row[x + i] && i < 127; i++) {}
                *o++ = (uint8_t)(int8_t)-i;
                { int j; for (j = 0; j < i; j++) *o++ = lut[k][row[x + j] & 63]; }
            }
            x += i;
        }
    }
    *o = 0;
    f93_frame_free(&f);
    return b;
}

static void find_slots(void)
{
    int n, k = 0;
    for (n = 0x46D; n > 0 && k < 2; n--)
        if (!photoptrs[n]) slot[k++] = n;
    if (k < 2) slot[0] = slot[1] = -1;
}

/* after updateplayers: the fighters show their 93 frame */
void fight_after(void)
{
    int k;
    drawing = 0;
    if (!ft.on || !have_rom || slot[1] < 0) return;
    for (k = 0; k < 2; k++) {
        int n = ft.f[k].frame;
        if (n <= 0 || n >= NFR) return;
        if (!spr[k][n] && !(spr[k][n] = build(k, n))) return;
    }
    for (k = 0; k < 2; k++) {
        photoptrs[slot[k]] = spr[k][ft.f[k].frame];
        saved_frame[k] = P_W(who[k], P_FRAME);
        P_W(who[k], P_FRAME) = (int16_t)slot[k];
        if (ft.f[k].flip) P_B(who[k], P_ATTRIBUTE) |= 8;
        else P_B(who[k], P_ATTRIBUTE) &= (uint8_t)~8;
    }
    drawing = 1;
}

/* before updateplayers: their own frames back, so updateanim carries on as it was */
static void undraw(void)
{
    int k;
    if (!drawing) return;
    for (k = 0; k < 2; k++) P_W(who[k], P_FRAME) = (int16_t)saved_frame[k];
    drawing = 0;
}

/* ---- the thunks ---- */
__attribute__((naked)) static void checkcheck_thunk(void)
{
    __asm__ volatile("call " SYM("checkcheck") "\n\tpushal\n\tpush %ecx\n\tpush %esi\n\tcall " SYM("fight_check")
                     "\n\tadd $8, %esp\n\tpopal\n\tret");
}

__attribute__((naked)) static void updateplayers_thunk(void)
{
    __asm__ volatile("pushal\n\tcall " SYM("fight_frame") "\n\tpopal\n\tcall " SYM("updateplayers")
                     "\n\tpushal\n\tcall " SYM("fight_after") "\n\tpopal\n\tret");
}

/* the call rel32 to `target` within n bytes of `from`, moved to `to` */
static int redirect_call(char *from, size_t n, const void *target, const void *to)
{
    size_t i;
    for (i = 0; i + 5 <= n; i++) {
        uint8_t *c = (uint8_t *)from + i;
        int32_t rel;
        if (c[0] != 0xE8) continue;
        memcpy(&rel, c + 1, 4);
        if ((uintptr_t)c + 5 + (uintptr_t)(intptr_t)rel != (uintptr_t)target) continue;
        rel = (int32_t)((uintptr_t)to - ((uintptr_t)c + 5));
        {
            uint8_t code[5];
            code[0] = 0xE8;
            memcpy(code + 1, &rel, 4);
            patch_bytes(c, code, 5);
        }
        return 1;
    }
    return 0;
}

void fight_install(void)
{
    const char *dirs[3] = { ".", getenv("NHL93_ROM_DIR"), NULL };
    if (!dirs[1]) dirs[1] = "";
    have_rom = !rom93_find(dirs, &rom, NULL, 0);
    /* the frame hook first: a fight is never started that would not run */
    ok_frame = redirect_call(DoGameFrame, 0x40, updateplayers, (const void *)updateplayers_thunk);
    ok_check = ok_frame && redirect_call(checkcx, 0x1000, checkcheck, (const void *)checkcheck_thunk);
    if (!ok_check) fprintf(stderr, "Fights: the hook points are not the expected code, fights are off\n");
}
