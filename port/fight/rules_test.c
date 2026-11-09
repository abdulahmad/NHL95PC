/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * port/fight/rules.c: 93's fight odds worked out by hand from hockey93.asm, then whole CPU fights (with a simple stand-in
 * for the game's skating) that must drop the gloves, trade punches and end with a winner, the same way every time for
 * the same random numbers. sh port/fight_test.sh runs it.
 */
#include "rules.h"
#include "rom93.h"

#include <stdio.h>
#include <string.h>

static int fails;
#define CHECK(c, ...) do { if (!(c)) { fails++; fprintf(stderr, "FAIL %s:%d: ", __FILE__, __LINE__); fprintf(stderr, __VA_ARGS__); fputc('\n', stderr); } } while (0)

static uint32_t seed;
static int rnd(void *ctx, int range) { (void)ctx; seed = seed * 0x41C64E6Du + 12345u; return (int)((seed >> 16) % (uint32_t)range); }
static int zero(void *ctx, int range) { (void)ctx; (void)range; return 0; }

static fighter player(int x, int y, int fighting, int checking, int away)
{
    fighter p;
    memset(&p, 0, sizeof p);
    p.x = x; p.y = y; p.fighting = fighting; p.checking = checking; p.energy = 0x1000; p.away = away;
    return p;
}

/* the game's part between passes: velocity moves the players (x 17 / 65536 a frame), friction v >> 6 */
static void skate(fight *ft, int32_t frac[2][2])
{
    int i;
    for (i = 0; i < 2; i++) {
        fighter *p = &ft->f[i];
        frac[i][0] += p->xvel * 17; frac[i][1] += p->yvel * 17;
        p->x += frac[i][0] >> 16; frac[i][0] &= 0xFFFF;
        p->y += frac[i][1] >> 16; frac[i][1] &= 0xFFFF;
        p->xvel -= p->xvel >> 6; p->yvel -= p->yvel >> 6;
    }
}

typedef struct { int frames, punches, gloves, winner, injury, banner, over; unsigned long long trace; } result;

static result run(uint32_t s, int fa, int fb, int ca, int cb)
{
    fight ft;
    int32_t frac[2][2] = { { 0, 0 }, { 0, 0 } };
    result r;
    memset(&r, 0, sizeof r);
    r.winner = -1;
    r.trace = 0xCBF29CE484222325ull;
    seed = s;
    memset(&ft, 0, sizeof ft);
    ft.f[0] = player(-6, 40, fa, ca, 0);
    ft.f[1] = player(6, 42, fb, cb, 1);
    ft.random = rnd;
    fight_begin(&ft);
    CHECK(ft.f[0].facedir == 2 && ft.f[1].facedir == 5, "facing %d %d", ft.f[0].facedir, ft.f[1].facedir);
    CHECK(ft.f[0].xvel == -0x400 && ft.f[1].xvel == 0x400, "not pushed apart");
    while (ft.on && r.frames < 5000) {
        fight_pass(&ft, 1, NULL, NULL);
        skate(&ft, frac);
        r.frames++;
        if (ft.events & (FE_PUNCH_HIGH | FE_PUNCH_LOW)) r.punches++;
        if (ft.events & FE_GLOVES) r.gloves++;
        if (ft.events & FE_BANNER) r.banner++;
        if (ft.events & FE_WINNER) r.winner = ft.winner;
        if (ft.events & FE_INJURY) r.injury++;
        if (ft.events & FE_OVER) r.over++;
        r.trace = (r.trace ^ (unsigned)(ft.f[0].frame * 7 + ft.f[1].frame * 131 + ft.f[0].x)) * 0x100000001B3ull;
    }
    return r;
}

int main(void)
{
    fighter a = player(0, 0, 14, 8, 0), b = player(10, 0, 14, 8, 1);
    int inst, n, wins[2] = { 0, 0 }, injuries = 0, total = 0, draws = 0;
    long frames = 0;

    /* checkfight / SetInst: rating needed 10 + max(0, 40 - checks this period) / 4 */
    CHECK(!fight_wants(&a, &b, 0, 0, 0, 1, zero, NULL, &inst), "a fight with no checks yet (needs 20)");
    CHECK(!fight_wants(&a, &b, 24, 0, 0, 1, zero, NULL, &inst), "no checks of his own: the other needs 16, more than 14");
    CHECK(fight_wants(&a, &b, 24, 1, 1, 1, zero, NULL, &inst) && inst == 0, "24 checks: 14 is enough, instigator 0 (%d)", inst);
    a.fighting = 12; b.fighting = 12;
    CHECK(!fight_wants(&a, &b, 24, 1, 1, 1, zero, NULL, &inst), "12 against a need of 14");
    CHECK(fight_wants(&a, &b, 40, 2, 2, 0, zero, NULL, &inst) && inst == -1, "40 checks: 10 needed; no penalties, no instigator");
    b.fighting = 1;
    CHECK(!fight_wants(&a, &b, 40, 0, 0, 1, zero, NULL, &inst), "the other must have at least 2");
    b.fighting = 6;
    CHECK(!fight_wants(&a, &b, 40, 0, 0, 1, zero, NULL, &inst), "6 < 16 - 2 x 0 checks, and 6 < 10 the other way");
    CHECK(fight_wants(&a, &b, 40, 0, 5, 1, zero, NULL, &inst) && inst == 0, "6 >= 16 - 2 x 5 checks");
    b.fighting = 10; a.fighting = 4;
    CHECK(fight_wants(&a, &b, 40, 10, 0, 1, zero, NULL, &inst) && inst == 1, "b starts it: b's team's instigator (%d)", inst);

    /* the animations */
    {
        int d;
        CHECK(fight_anim_frame(FA_HIGH, 2, 1, &d) == F93_FIGHT + 6 && d == 16, "high punch contact facing 2");
        CHECK(fight_anim_frame(FA_HIGH, 5, 1, &d) == F93_FIGHT + 11, "high punch contact facing 5");
        CHECK(fight_anim_frame(FA_INJURY, 2, 3, &d) == F93_FINJURY, "the injury goes to the bloody frames");
    }

    /* whole fights */
    for (n = 0; n < 400; n++) {
        result r = run(1000 + n, 14, 14, 15, 15), again = run(1000 + n, 14, 14, 15, 15);
        CHECK(r.over == 1, "fight %d did not end (%d frames)", n, r.frames);
        CHECK(r.gloves == 1, "fight %d: gloves %d (both drop them in the same frame)", n, r.gloves);
        CHECK(r.banner == 1, "fight %d: banner %d", n, r.banner);
        CHECK(r.winner < 0 || r.punches >= 15, "fight %d: %d punches landed before a strength-14 fighter fell", n, r.punches);
        if (r.winner < 0) draws++;              /* the stoppage ran out first (21 s), as it can in 93 */
        CHECK(r.trace == again.trace && r.frames == again.frames, "fight %d differs on a replay", n);
        if (r.winner >= 0) wins[r.winner]++;
        injuries += r.injury;
        frames += r.frames;
        total++;
    }
    CHECK(draws < total / 20, "%d fights without a winner", draws);
    printf("rules: %d fights, wins %d / %d (%d ran out of time), %d injuries (93: 16 in 60 at checking 15), %.1f s on average\n", total, wins[0], wins[1], draws,
           injuries, frames / 60.0 / total);
    CHECK(wins[0] > 100 && wins[1] > 100, "one side always wins");
    CHECK(injuries > total / 8 && injuries < total / 2, "injuries %d of %d", injuries, total);
    printf("rules %s\n", fails ? "FAILED" : "OK");
    return fails ? 1 : 0;
}
