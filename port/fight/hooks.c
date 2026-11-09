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

#define P_W(p, o) (*(int16_t *)((p) + (o)))
#define P_B(p, o) (*(uint8_t *)((p) + (o)))
#define P_XPOS_HI 0x02
#define P_YPOS_HI 0x06
#define P_XVEL 0x0C
#define P_YVEL 0x0E
#define P_IMPACT 0x18
#define P_POSITION 0x1A
#define P_ASSNUM 0x1C
#define P_FACEDIR 0x36
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
    if (!fight_wants(&ft.f[0], &ft.f[1], chkcnt, checks[P_W(a, P_SCNUM)], checks[P_W(b, P_SCNUM)], gameopts & 1, game_random,
                     NULL, &inst))
        return;
    chkcnt = 0;
    memset(checks, 0, sizeof checks);
    who[0] = a;
    who[1] = b;
    fight_begin(&ft);
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
    if (ft.events & FE_OVER) end_fight();
}

/* ---- the thunks ---- */
__attribute__((naked)) static void checkcheck_thunk(void)
{
    __asm__ volatile("call " SYM("checkcheck") "\n\tpushal\n\tpush %ecx\n\tpush %esi\n\tcall " SYM("fight_check")
                     "\n\tadd $8, %esp\n\tpopal\n\tret");
}

__attribute__((naked)) static void updateplayers_thunk(void)
{
    __asm__ volatile("pushal\n\tcall " SYM("fight_frame") "\n\tpopal\n\tjmp " SYM("updateplayers"));
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
