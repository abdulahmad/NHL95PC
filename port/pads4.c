/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * Four players on 95 PC (pads 3 and 4), the way 94 Genesis added four-way play to this same engine
 * (logic94 updateplayers .tp2, ResetAndSelectPlayers): the engine keeps knowing two controllers, and
 * pad 3 or 4 is swapped into the game's pad 1 or 2 (the one on its team) while its player's input runs.
 *
 *   - updateplayers: a player who is not pad 1's or pad 2's goes here; pad 3's or 4's runs doinput (through
 *     whatever the call site calls now, so the manual goalie's hook still sees it) with that pad swapped in:
 *     c1playernum / c2playernum, cont1team / cont2team, lj1 / lj2 and the goalie's B-hold timer.
 *     Under the swap, the other slot's player is the teammate's, so changeplayer never picks him.
 *   - each pad keeps a player of its own: none of pads 1-4 has him, he is on the ice for its team; else it
 *     takes the free skater nearest the puck (changeplayer's rule). Not during a penalty shot.
 *   - GiveControl (a pickup gives the carrier to the team's pad) leaves pad 3's and 4's players alone.
 *   - DrawRinkOverlays: pads 3 and 4 get the star of the game pad they swap into.
 * The pad's byte per record: offline the device's (input.c, read on the game thread with the record),
 * online the step record's (netplay.c), the pretend controllers' none. The game's own code is not changed.
 */
#include "pads4.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static const uint8_t dirtab[16] = { 8, 0, 4, 8, 2, 1, 3, 2, 6, 7, 5, 6, 8, 0, 4, 8 };   /* the game's keydirtab */

uint8_t pads4_byte(int mask, int pass, int shoot)
{
    uint8_t b = dirtab[mask & 15];
    if (pass && shoot) return (uint8_t)(b | 0x40);
    if (pass) return (uint8_t)(b | 0x10);
    if (shoot) return (uint8_t)(b | 0x20);
    return b;
}

int pads4_keep(int sc, int team, int position, int pflags2, const int16_t *others, int nothers)
{
    int i;
    if (team != 1 && team != 2) return 0;
    if (sc < 0 || sc > 11) return 0;
    if ((sc >= 6) != (team == 2)) return 0;
    if (position < 0 || (pflags2 & 4)) return 0;
    for (i = 0; i < nothers; i++) if (others[i] == sc) return 0;
    return 1;
}

void pads4_map_seats(int n, const int *team, const int *kb, int *out)
{
    int i, first = -1, second = -1, next = 2;
    for (i = 0; i < n; i++) out[i] = -1;
    if (n <= 2) {
        for (i = 0; i < n; i++) out[i] = i;
        return;
    }
    /* slot 0: a keyboard seat if any (the game reads the keyboard pad itself), else the first seat */
    for (i = 0; i < n; i++) if (kb[i]) { first = i; break; }
    if (first < 0) first = 0;
    /* slot 1: the first seat of the other team, else the next seat */
    for (i = 0; i < n; i++) if (i != first && team[i] != team[first]) { second = i; break; }
    if (second < 0) for (i = 0; i < n; i++) if (i != first) { second = i; break; }
    /* a second keyboard seat cannot be: there is one keyboard. One on the other team takes slot 1 */
    for (i = 0; i < n; i++) if (kb[i] && i != first && team[i] != team[first]) second = i;
    out[first] = 0;
    if (second >= 0) out[second] = 1;
    for (i = 0; i < n && next < 4; i++) if (out[i] < 0 && !kb[i]) out[i] = next++;
}

#ifndef PADS4_TEST

#include "goalie.h"
#include "host.h"

#ifdef _WIN32
#define SYM(s) "_" s
#else
#define SYM(s) s
#endif

#define P_XHI 0x02
#define P_YHI 0x06
#define P_FRAME 0x12
#define P_POSITION 0x1A
#define P_PFLAGS 0x44
#define P_PFLAGS2 0x45
#define P_SCNUM 0x6A
#define PFNA 0x02
#define PFJOY 0x08
#define PFALOCK 0x20
#define P_W(p, o) (*(int16_t *)((p) + (o)))
#define P_B(p, o) (*(uint8_t *)((p) + (o)))

extern char updateplayers[], GiveControl[], DrawRinkOverlays[], DrawRinkObjects[], DrawFrameSprite[];
extern uint8_t SortCords[];
extern int16_t c1playernum[], c2playernum[], cont1team, cont2team, lj1, lj2;
extern int32_t regd0, regd1, regd2, regd3;
extern int16_t *puckx, *pucky, *puckvx, *puckvy;
extern signed char *puckc;
extern uint8_t gmode, gmode2;
extern int penshotmode, penshotlive, dword_CCC9C;
extern int16_t word_CC0B0[];
extern int demomode;
extern int32_t ctl1team, ctl2team;
extern uint32_t ctl1side, ctl2side;

int input_pad_byte(int pad);                    /* input.c: an SDL pad's byte now (8: none) */
int netplay_pad34(int k, uint8_t *out);         /* netplay.c: pad 3 / 4 of the record being played (1 in a session) */
uint8_t *goalie_bhold_timer(int i);             /* goalie.c: pad 1's (0) or pad 2's (1) */
int feel_fake_pads(void);                       /* feel.c: the Game page's pretend controllers */

pads4_state pads4 = { { 0, 0 }, { -1, -1 }, { 0, 0 }, { 0, 0 }, { PADS4_NONE, PADS4_NONE } };

void *pads4_c2_cont;            /* updateplayers' pad 2 path (call ReadJoy2) */
void *pads4_after;              /* updateplayers .38: after the pad input */
static uint8_t *doinput_call;   /* updateplayers' call doinput (the goalie hook may have moved it) */
void *pads4_gc_cont;            /* GiveControl + 5 */
static int ok_up, ok_gc, ok_draw;
static int logon = -1;

static int log_on(void)
{
    if (logon < 0) logon = getenv("NHL95_PADS4_LOG") != NULL;
    return logon;
}

void pads4_clear(void)
{
    int k;
    for (k = 0; k < 2; k++) {
        int sc = pads4.player[k];
        if (sc >= 0 && sc <= 11 && sc != c1playernum[0] && sc != c2playernum[0]) P_B(SortCords + sc * 0x80, P_PFLAGS) &= (uint8_t)~PFJOY;
        pads4.team[k] = 0;
        pads4.player[k] = -1;
        pads4.lj[k] = 0;
        pads4.bhold[k] = 0;
        pads4.src[k] = PADS4_NONE;
    }
}

void pads4_set(int k, int team, int src)
{
    if (k < 0 || k > 1) return;
    pads4.team[k] = (int16_t)(team == 1 || team == 2 ? team : 0);
    pads4.player[k] = -1;
    pads4.lj[k] = 0;
    pads4.bhold[k] = 0;
    pads4.src[k] = (int8_t)src;
    if (log_on()) fprintf(stderr, "pads4: pad %d plays %s from %d\n", k + 3, team == 1 ? "home" : team == 2 ? "away" : "nobody", src);
}

void pads4_fake_fill(void)
{
    int k = 0, t1, t2;
    if (!feel_fake_pads()) return;
    t1 = ctl1team < 0 ? 0 : ctl1side == 0 ? 1 : 2;        /* as the game's SetupControllers makes cont1team */
    t2 = ctl2team < 0 ? 0 : ctl2side == 0 ? 1 : 2;
    /* one pretend pad beside each of the game's pads, so a 1 v 1 becomes 2 v 2 (both teams when only pad 1 plays) */
    if (t1) pads4_set(k++, t1, PADS4_FAKE);
    if (t2 && t2 != t1) pads4_set(k++, t2, PADS4_FAKE);
    else if (t1 && k < 2) pads4_set(k++, t1 == 1 ? 2 : 1, PADS4_FAKE);
}

static uint8_t pad_byte(int k)
{
    uint8_t b;
    if (netplay_pad34(k, &b)) return b;
    if (pads4.src[k] >= 0) return (uint8_t)input_pad_byte(pads4.src[k]);
    return 8;
}

uint8_t pads4_local_byte(int k)
{
    if (k < 0 || k > 1 || !pads4.team[k] || pads4.src[k] < 0) return 8;
    return (uint8_t)input_pad_byte(pads4.src[k]);
}

void pads4_drop_remote(void)
{
    int k;
    for (k = 0; k < 2; k++) if (pads4.src[k] == PADS4_REMOTE) pads4.src[k] = PADS4_NONE;     /* his player stands: no input */
}

static int16_t call_restore(int nw, int old)
{
    extern char restorepl[];
    int16_t r;
    __asm__ volatile("call *%[fn]" : "=a"(r), "+d"(old) : "a"(nw), [fn] "r"(restorepl) : "ecx", "memory", "cc");
    return r;
}

static void others_of(int k, int16_t *o)
{
    o[0] = c1playernum[0];
    o[1] = c2playernum[0];
    o[2] = pads4.team[!k] ? pads4.player[!k] : -1;
}

/* pad k keeps a player of its own: else the free skater of its team nearest the puck's next spot */
static void keep_player(int k)
{
    int16_t o[3];
    int team = pads4.team[k], sc = pads4.player[k], i, best = -1;
    long px, py;
    unsigned long bd = 0xFFFFFFFFul;
    uint8_t *p;
    if (!team) return;
    others_of(k, o);
    if (penshotmode || penshotlive) {                   /* the game's own pads leave the ice for a penalty shot too */
        if (sc >= 0 && sc <= 11 && sc != o[0] && sc != o[1]) P_B(SortCords + sc * 0x80, P_PFLAGS) &= (uint8_t)~PFJOY;
        pads4.player[k] = -1;
        return;
    }
    if (sc >= 0 && sc <= 11) {
        p = SortCords + sc * 0x80;
        if (pads4_keep(sc, team, P_W(p, P_POSITION), P_B(p, P_PFLAGS2), o, 3)) {
            P_B(p, P_PFLAGS) |= PFJOY;                  /* (a faceoff or a whistle may have cleared it) */
            return;
        }
    }
    px = (*puckvx >> 8) + *puckx;
    py = *pucky + (*puckvy >> 8);
    for (i = team == 1 ? 0 : 6; i < (team == 1 ? 6 : 12); i++) {
        long dx, dy;
        unsigned long d;
        p = SortCords + i * 0x80;
        if (P_W(p, P_POSITION) <= 0 || (P_B(p, P_PFLAGS) & PFALOCK)) continue;    /* skaters, as changeplayer */
        if (!pads4_keep(i, team, P_W(p, P_POSITION), P_B(p, P_PFLAGS2), o, 3)) continue;
        dx = px - P_W(p, P_XHI);
        dy = py - P_W(p, P_YHI);
        d = (unsigned long)(dx * dx + dy * dy);
        if (d <= bd) { bd = d; best = i; }
    }
    if (best < 0) return;                               /* nobody free now: try again next frame */
    if (sc >= 0 && sc <= 11 && sc != o[0] && sc != o[1] && sc != o[2]) call_restore(best, sc);
    else SortCords[best * 0x80 + P_PFLAGS] |= PFJOY;
    if (log_on()) fprintf(stderr, "pads4: pad %d takes player %d (was %d)\n", k + 3, best, sc);
    pads4.player[k] = (int16_t)best;
}

/* ReadJoy1 for pad k's byte */
static void read_pad(int k, uint8_t b)
{
    int16_t d0 = b, d1 = b & 0x70, d2 = pads4.lj[k];
    pads4.lj[k] = d1;
    d2 ^= d1;
    *(int16_t *)&regd0 = d0;
    *(int16_t *)&regd3 = d1;
    *(int16_t *)&regd2 = d2;
    *(int16_t *)&regd1 = (int16_t)(d1 & d2);
}

static void call_doinput(uint8_t *p, int ctl)
{
    int32_t rel;
    void *fn;
    memcpy(&rel, doinput_call + 1, 4);
    fn = doinput_call + 5 + rel;
    __asm__ volatile("call *%[fn]" : "+a"(p), "+d"(ctl) : [fn] "r"(fn) : "ecx", "memory", "cc");
}

/* pad k's player in updateplayers: its input with the pad swapped into the game pad of its team */
static void run_pad(int k, uint8_t *p)
{
    int slot = pads4.team[k] == cont1team ? 0 : pads4.team[k] == cont2team ? 1 : 0;
    int16_t *mine = slot ? c2playernum : c1playernum, *other = slot ? c1playernum : c2playernum;
    int16_t *cont = slot ? &cont2team : &cont1team, *lj = slot ? &lj2 : &lj1;
    int16_t s_mine = *mine, s_other = *other, s_cont = *cont, s_lj = *lj, old = pads4.player[k], now, o[3];
    uint8_t *bh = goalie_bhold_timer(slot), s_bh = bh ? *bh : 0;
    uint8_t b = pad_byte(k);
    read_pad(k, b);
    if ((gmode2 & 1) || penshotmode || penshotlive) return;    /* faceoffs and penalty shots: the game's two pads */
    *mine = old;
    *cont = pads4.team[k];
    *lj = pads4.lj[k];
    if (s_cont == pads4.team[k]) *other = s_mine;           /* the teammate: changeplayer never takes his player */
    if (bh) *bh = pads4.bhold[k];
    call_doinput(p, slot ? 2 : 0);
    now = *mine;
    if (bh) { pads4.bhold[k] = *bh; *bh = s_bh; }
    *mine = s_mine;
    *other = s_other;
    *cont = s_cont;
    *lj = s_lj;
    others_of(k, o);
    if (now != old && (now == o[0] || now == o[1] || now == o[2])) {  /* he is another pad's: stay */
        if (old >= 0 && old <= 11) P_B(SortCords + old * 0x80, P_PFLAGS) |= PFJOY;
        now = old;
    }
    if (now != old && log_on()) fprintf(stderr, "pads4: pad %d %d -> %d\n", k + 3, old, now);
    pads4.player[k] = now;
}

/* updateplayers, for a player who is not pad 1's or pad 2's (esi) */
void pads4_other(uint8_t *p)
{
    int k, sc = P_W(p, P_SCNUM);
    if (demomode) return;                               /* the attract demo plays its own records */
    for (k = 0; k < 2; k++) keep_player(k);
    for (k = 0; k < 2; k++)
        if (pads4.team[k] && pads4.player[k] == sc) { run_pad(k, p); return; }
}

/* at updateplayers .36: cmp ax, [c2playernum] / jne .38 (9 bytes), ax the player's SCnum, esi the player */
__attribute__((naked)) static void up_thunk(void)
{
    __asm__ volatile(
        "cmpw " SYM("c2playernum") ", %ax\n\t"
        "jne 1f\n\t"
        "jmp *" SYM("pads4_c2_cont") "\n"
        "1:\n\tpushal\n\tpush %esi\n\tcall " SYM("pads4_other") "\n\tadd $4, %esp\n\tpopal\n\t"
        "jmp *" SYM("pads4_after"));
}

int pads4_gc_skip(int sc)
{
    sc = (int16_t)sc;
    return (pads4.team[0] && sc == pads4.player[0]) || (pads4.team[1] && sc == pads4.player[1]);
}

/* GiveControl(ax = player): not pad 3's or 4's (push dword 14h is the 5 bytes moved) */
__attribute__((naked)) static void gc_thunk(void)
{
    __asm__ volatile(
        "pushal\n\tpush %eax\n\tcall " SYM("pads4_gc_skip") "\n\tadd $4, %esp\n\ttest %eax, %eax\n\tpopal\n\t"
        "jnz 1f\n\tpush $0x14\n\tjmp *" SYM("pads4_gc_cont") "\n"
        "1:\n\tret");
}

static void draw_sprite(int frame, int x, int y)
{
    __asm__ volatile("push $0\n\tcall *%[fn]"
                     : "+a"(frame), "+d"(x), "+b"(y)
                     : "c"(0), [fn] "r"(DrawFrameSprite)
                     : "memory", "cc");
}

/* DrawRinkOverlays' DrawRinkObjects: then the stars of pads 3 and 4 (the original draws pads 1 and 2's next) */
void pads4_draw(void)
{
    int k;
    if (dword_CCC9C) return;
    for (k = 0; k < 2; k++) {
        int sc = pads4.player[k], slot;
        uint8_t *p;
        if (!pads4.team[k] || sc < 0 || sc > 11) continue;
        p = SortCords + sc * 0x80;
        if (P_W(p, P_FRAME) == -1) continue;
        slot = pads4.team[k] == cont1team ? 0 : pads4.team[k] == cont2team ? 1 : 0;
        draw_sprite(word_CC0B0[1 + slot], P_W(p, P_XHI), P_W(p, P_YHI));
    }
}

__attribute__((naked)) static void dro_thunk(void)
{
    __asm__ volatile(
        "call " SYM("DrawRinkObjects") "\n\t"
        "pushal\n\tcall " SYM("pads4_draw") "\n\tpopal\n\tret");
}

static int redirect_call(char *from, size_t n, const void *target, const void *to)
{
    size_t i;
    for (i = 0; i + 5 <= n; i++) {
        uint8_t *c = (uint8_t *)from + i, code[5];
        int32_t rel;
        if (c[0] != 0xE8) continue;
        memcpy(&rel, c + 1, 4);
        if ((uintptr_t)c + 5 + (uintptr_t)(intptr_t)rel != (uintptr_t)target) continue;
        rel = (int32_t)((uintptr_t)to - ((uintptr_t)c + 5));
        code[0] = 0xE8;
        memcpy(code + 1, &rel, 4);
        patch_bytes(c, code, 5);
        return 1;
    }
    return 0;
}

/* updateplayers .36: 66 3B 05 <c2playernum> 75 xx, E8 <ReadJoy2>, BA 02 00 00 00, 89 F0, E8 <doinput> */
static int patch_up(void)
{
    uint8_t *base = (uint8_t *)updateplayers;
    size_t i;
    for (i = 0; i + 24 <= 1760; i++) {
        uint8_t *p = base + i, code[9];
        uint32_t a;
        int32_t rel;
        if (p[0] != 0x66 || p[1] != 0x3B || p[2] != 0x05) continue;
        memcpy(&a, p + 3, 4);
        if (a != (uint32_t)(uintptr_t)c2playernum) continue;
        if (p[7] != 0x75 || p[9] != 0xE8 || p[14] != 0xBA || p[15] != 2 || p[19] != 0x89 || p[20] != 0xF0 || p[21] != 0xE8) continue;
        pads4_after = p + 9 + (int8_t)p[8];
        pads4_c2_cont = p + 9;
        doinput_call = p + 21;
        rel = (int32_t)((uintptr_t)up_thunk - ((uintptr_t)p + 5));
        code[0] = 0xE9;
        memcpy(code + 1, &rel, 4);
        memset(code + 5, 0x90, 4);
        patch_bytes(p, code, 9);
        return 1;
    }
    return 0;
}

void pads4_install(void)
{
    static const uint8_t push14[5] = { 0x68, 0x14, 0, 0, 0 };
    ok_up = patch_up();
    if (!ok_up) { fprintf(stderr, "Four players: updateplayers is not the expected code, pads 3 and 4 do not play\n"); return; }
    ok_gc = !memcmp(GiveControl, push14, 5);
    if (ok_gc) {
        pads4_gc_cont = GiveControl + 5;
        patch_jmp(GiveControl, (void *)gc_thunk);
    } else {
        fprintf(stderr, "Four players: GiveControl is not the expected code, a pickup may give pad 3's player to pad 1\n");
    }
    ok_draw = redirect_call(DrawRinkOverlays, 400, DrawRinkObjects, (const void *)dro_thunk);
    if (!ok_draw) fprintf(stderr, "Four players: DrawRinkOverlays is not the expected code, pads 3 and 4 have no star\n");
}

#endif /* !PADS4_TEST */
