/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * The feel options' C copies of playeracc and stopna (port/feel.c) against the game's own (the asm objects of the
 * build): with every option on 95 PC they must leave the same player, team energy, 68k registers and generator.
 * Then the 94 Genesis options: they run, keep speeds in range, and leave goalies and the referee alone.
 * sh port/feel_test.sh
 */
#include "feel.h"

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern char playeracc[], stopna[];
extern int32_t regd0, regd1, regd2, regd3;
extern uint8_t gmode;
extern uint32_t gameopts;
extern uint32_t seed;

/* what feel.c wants from the host */
void patch_jmp(void *from, void *to) { (void)from; (void)to; }
void patch_bytes(void *at, const void *bytes, size_t n) { memcpy(at, bytes, n); }
void settings_save_all(void) {}
int ob_host_save_ini(const ob_host *h) { (void)h; return 0; }

/* the game's routines: eax = player, edx = direction (Watcom); they keep every register but eax */
static void call_game(void *fn, void *p, int dir)
{
    __asm__ volatile("pushal\n\tcall *%0\n\tpopal" : : "r"(fn), "a"(p), "d"(dir) : "memory", "cc");
}

static uint32_t rng = 12345;
static uint32_t rnd(void) { rng = rng * 1103515245u + 12345u; return rng >> 8; }

typedef struct { uint8_t p[0x80]; uint8_t team[0x80]; int32_t r[4]; uint32_t seed; } state;

static void take(state *s, uint8_t *p, uint8_t *team)
{
    memcpy(s->p, p, sizeof s->p); memcpy(s->team, team, sizeof s->team);
    s->r[0] = regd0; s->r[1] = regd1; s->r[2] = regd2; s->r[3] = regd3; s->seed = seed;
}

static void put(const state *s, uint8_t *p, uint8_t *team)
{
    memcpy(p, s->p, sizeof s->p); memcpy(team, s->team, sizeof s->team);
    regd0 = s->r[0]; regd1 = s->r[1]; regd2 = s->r[2]; regd3 = s->r[3]; seed = s->seed;
}

static void make_player(uint8_t *p, uint8_t *team, int kind)
{
    int i;
    for (i = 0; i < 0x80; i++) p[i] = (uint8_t)rnd();
    for (i = 0; i < 0x80; i++) team[i] = (uint8_t)rnd();
    *(int16_t *)(p + 0x0C) = (int16_t)(rnd() % 6000 - 3000);       /* Xvel */
    *(int16_t *)(p + 0x0E) = (int16_t)(rnd() % 6000 - 3000);       /* Yvel */
    if (rnd() % 4 == 0) *(int16_t *)(p + 0x0C) = (int16_t)(rnd() % 400 - 200);
    *(int16_t *)(p + 0x06) = (int16_t)(rnd() % 600 - 300);         /* Ypos */
    *(int16_t *)(p + 0x1A) = kind == 1 ? 0 : (int16_t)(1 + rnd() % 5);     /* position: 0 the goalie */
    *(int16_t *)(p + 0x6A) = kind == 2 ? 0x10 : (int16_t)(rnd() % 0x10);   /* SCnum: 10h the referee */
    *(int16_t *)(p + 0x30) = rnd() % 3 ? 0 : (int16_t)(rnd() % 0x8000 - 0x4000);   /* wallcos */
    *(int16_t *)(p + 0x32) = rnd() % 3 ? 0 : (int16_t)(rnd() % 0x8000 - 0x4000);   /* wallsin */
    p[0x45] = (uint8_t)(rnd() % 8 == 0 ? 0x40 : 0);                 /* pflags2: injured */
    p[0x47] = (uint8_t)(rnd() % 26);                                /* pnum */
    p[0x56] = (uint8_t)(rnd() % 16);                                /* weight */
    p[0x57] = (uint8_t)(rnd() % 16);                                /* legstr */
    p[0x58] = (uint8_t)(rnd() % 16);                                /* legspd */
    p[0x61] = (uint8_t)(rnd() % 16);                                /* endurance */
    *(uint8_t **)(p + 0x6C) = team;
    for (i = 0; i < 26; i++) *(int16_t *)(team + 0x46 + 2 * i) = (int16_t)(rnd() % 0x1001);
    *(int16_t *)(team + 0x46 + 2 * (int8_t)p[0x47]) = (int16_t)(rnd() % 8 == 0 ? 0xC00 + rnd() % 0x50 : rnd() % 0x1001);
}

int main(void)
{
    static uint8_t p[0x80], team[0x80 + 0x80];
    state before, game, ours;
    feel_profile f;
    int n, bad = 0, runs = 200000;
    memset(&f, 0, sizeof f);
    feel_set_profile(&f);
    for (n = 0; n < runs; n++) {
        int which = n & 1, dir = (int)(rnd() % 8), kind = (int)(rnd() % 6);
        make_player(p, team, kind > 2 ? 0 : kind);
        gmode = (uint8_t)(rnd() % 4);
        gameopts = rnd() % 2 ? 4 : 0;
        seed = rnd() ^ (rnd() << 16);
        regd0 = (int32_t)rnd(); regd1 = (int32_t)rnd(); regd2 = (int32_t)rnd(); regd3 = (int32_t)rnd();
        take(&before, p, team);
        call_game(which ? (void *)stopna : (void *)playeracc, p, dir);
        take(&game, p, team);
        put(&before, p, team);
        if (which) feel_stopna(p); else feel_playeracc(p, dir);
        take(&ours, p, team);
        if (memcmp(&game, &ours, sizeof game)) {
            if (bad++ < 10) {
                int i;
                fprintf(stderr, "%s differs (run %d, dir %d):", which ? "stopna" : "playeracc", n, dir);
                for (i = 0; i < 0x80; i++) if (game.p[i] != ours.p[i]) fprintf(stderr, " p+%02X %02X/%02X", i, game.p[i], ours.p[i]);
                for (i = 0; i < 0x80; i++) if (game.team[i] != ours.team[i]) fprintf(stderr, " team+%02X %02X/%02X", i, game.team[i], ours.team[i]);
                for (i = 0; i < 4; i++) if (game.r[i] != ours.r[i]) fprintf(stderr, " d%d %08X/%08X", i, (unsigned)game.r[i], (unsigned)ours.r[i]);
                if (game.seed != ours.seed) fprintf(stderr, " seed %08X/%08X", game.seed, ours.seed);
                fprintf(stderr, "\n");
            }
        }
    }
    printf("95 PC: %d of %d runs the same as the game's playeracc and stopna\n", runs - bad, runs);

    /* the 94 Genesis presets: goalies and the referee keep the game's numbers; a skater from rest reaches a top
     * speed and stops */
    {
        static const feel_profile g[3] = { { 1, 1, 1, 1, 1, 1 }, { 1, 1, 1, 1, 1, 0 }, { 2, 2, 2, 1, 1, 1 } };
        static const char *const gn[3] = { "94 Genesis, cartridge", "94 Genesis, smooth", "94 Genesis, scaled to rink" };
        int k, gbad = 0;
        for (k = 0; k < 3; k++) {
            int t, top = 0, t90 = -1, stop_t = -1, sp;
            for (n = 0; n < 20000; n++) {
                int dir = (int)(rnd() % 8), kind = 1 + (int)(rnd() % 2);
                make_player(p, team, kind);
                gmode = (uint8_t)(rnd() % 4); gameopts = 0; seed = rnd();
                memset(&f, 0, sizeof f); feel_set_profile(&f);
                take(&before, p, team);
                if (n & 1) feel_stopna(p); else feel_playeracc(p, dir);
                take(&game, p, team);
                put(&before, p, team);
                feel_set_profile(&g[k]);
                if (n & 1) feel_stopna(p); else feel_playeracc(p, dir);
                take(&ours, p, team);
                if (memcmp(&game, &ours, sizeof game)) gbad++;
            }
            /* an average skater (ratings 7, full energy) from rest, straight up the ice; 95 PC's friction at the
             * profile's glide: v -= v >> (6 + half) every frame */
            feel_set_profile(&g[k]);
            make_player(p, team, 0);
            p[0x45] = 0; p[0x56] = 7; p[0x57] = 7; p[0x58] = 7;
            *(int16_t *)(p + 0x30) = 0; *(int16_t *)(p + 0x32) = 0;
            *(int16_t *)(p + 0x0C) = 0; *(int16_t *)(p + 0x0E) = 0;
            *(int16_t *)(team + 0x46 + 2 * (int8_t)p[0x47]) = 0x1000;
            for (t = 0; t < 600; t++) {
                int16_t *vy = (int16_t *)(p + 0x0E);
                feel_playeracc(p, 0);
                *vy = (int16_t)(*vy - (*vy >> (g[k].glide && g[k].cartridge ? 7 : 6)));
                sp = *vy < 0 ? -*vy : *vy;
                if (sp > top) top = sp;
            }
            make_player(p, team, 0);
            p[0x45] = 0; p[0x56] = 7; p[0x57] = 7; p[0x58] = 7;
            *(int16_t *)(p + 0x0C) = 0; *(int16_t *)(p + 0x0E) = 0;
            *(int16_t *)(p + 0x30) = 0; *(int16_t *)(p + 0x32) = 0;
            *(int16_t *)(team + 0x46 + 2 * (int8_t)p[0x47]) = 0x1000;
            for (t = 0; t < 600 && t90 < 0; t++) {
                int16_t *vy = (int16_t *)(p + 0x0E);
                feel_playeracc(p, 0);
                *vy = (int16_t)(*vy - (*vy >> (g[k].glide && g[k].cartridge ? 7 : 6)));
                sp = *vy < 0 ? -*vy : *vy;
                if (sp * 10 >= top * 9) t90 = t + 1;
            }
            for (t = 0; t < 600 && stop_t < 0; t++) {
                feel_stopna(p);
                if (*(int16_t *)(p + 0x0C) == 0 && *(int16_t *)(p + 0x0E) == 0) stop_t = t + 1;
            }
            printf("%s: goalies and the referee the game's in %d of 20000; an average skater: top %d, 90%% in %d frames, stopped in %d\n",
                   gn[k], 20000 - gbad, top, t90, stop_t);
            if (gbad || top <= 0 || t90 < 0 || stop_t < 0) bad++;
        }
        /* and 95 PC's, to compare */
        memset(&f, 0, sizeof f); feel_set_profile(&f);
        {
            int t, top = 0, t90 = -1, stop_t = -1, sp, pass;
            for (pass = 0; pass < 2; pass++) {
                make_player(p, team, 0);
                p[0x45] = 0; p[0x56] = 7; p[0x57] = 7; p[0x58] = 7;
                *(int16_t *)(p + 0x0C) = 0; *(int16_t *)(p + 0x0E) = 0;
                *(int16_t *)(p + 0x30) = 0; *(int16_t *)(p + 0x32) = 0;
                *(int16_t *)(team + 0x46 + 2 * (int8_t)p[0x47]) = 0x1000;
                for (t = 0; t < 600 && (pass == 0 || t90 < 0); t++) {
                    int16_t *vy = (int16_t *)(p + 0x0E);
                    feel_playeracc(p, 0);
                    *vy = (int16_t)(*vy - (*vy >> 6));
                    sp = *vy < 0 ? -*vy : *vy;
                    if (pass == 0 && sp > top) top = sp;
                    if (pass == 1 && sp * 10 >= top * 9) t90 = t + 1;
                }
            }
            for (t = 0; t < 600 && stop_t < 0; t++) {
                feel_stopna(p);
                if (*(int16_t *)(p + 0x0C) == 0 && *(int16_t *)(p + 0x0E) == 0) stop_t = t + 1;
            }
            printf("95 PC: an average skater: top %d, 90%% in %d frames, stopped in %d\n", top, t90, stop_t);
        }
    }
    return bad ? 1 : 0;
}
