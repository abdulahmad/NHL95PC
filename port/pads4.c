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
 *     Under the swap, the other slot's player is the teammate's, so that call of changeplayer never picks him.
 *     Pad 1 and pad 2's own changeplayer is guarded the same way (pads4_guard_on).
 *   - each pad keeps a player of its own: none of pads 1-4 has him, he is on the ice for its team; else it
 *     takes the free skater nearest the puck (changeplayer's rule). Not during a penalty shot.
 *   - GiveControl (a pickup gives the carrier to the team's pad) leaves pad 3's and 4's players alone,
 *     and with those pads on it also leaves a goalie who is already controlled (94G setd0player).
 *   - changeplayer never takes a teammate another pad already has (94G chgplayer: joy, or the other
 *     pad's player). The pass button with the puck loose is that change, so a pass to a human teammate
 *     and another press of pass cannot switch into him. A CPU teammate still can be taken.
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

int pads4_may_take(int sc, int mine, int joy, const int16_t *humans, int nh)
{
    int i;
    if (sc == mine) return 1;                 /* his own: changeplayer sweep-checks him */
    if (joy) return 0;                        /* 94G: pflags bit 3, another pad already has him */
    if (!humans) return 1;
    for (i = 0; i < nh; i++) if (humans[i] == sc) return 0;   /* his number, even if joy is clear */
    return 1;
}

int pads4_switch_pick(int mine, const int16_t *humans, int nh, const pads4_cand *c, int n)
{
    unsigned best = 0xFFFFFFFFu;
    int pick = mine, i;
    if (!c) return mine;
    for (i = 0; i < n; i++) {
        unsigned d;
        if (c[i].pos <= 0 || c[i].unav || c[i].lock) continue;          /* goalie, leaving, or locked */
        if (!pads4_may_take(c[i].sc, mine, c[i].joy, humans, nh)) continue;
        d = c[i].dist2;
        if (d <= best) { best = d; pick = c[i].sc; }                     /* tie: the later skater */
    }
    return pick;
}

int pads4_pass_switches(int goalie, int joy, int receiver_joy)
{
    if (!goalie || !joy) return 0;            /* a skater's pass, or the computer's, does not switch */
    if (receiver_joy) return 0;               /* the receiver is already a pad's */
    return 1;
}

int pads4_give_skip(int owned, int pads_on, int position, int joy)
{
    if (owned) return 1;
    if (pads_on && position == 0 && joy) return 1;
    return 0;
}

#ifndef PADS4_TEST

#include "goalie.h"
#include "host.h"
#include "rom94.h"

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

extern char updateplayers[], GiveControl[], changeplayer[], DrawRinkOverlays[], DrawRinkObjects[], DrawFrameSprite[];
extern uint8_t SortCords[];
extern int16_t c1playernum[], c2playernum[], cont1team, cont2team, lj1, lj2;
extern int32_t regd0, regd1, regd2, regd3;
extern int16_t *puckx, *pucky, *puckvx, *puckvy;
extern signed char *puckc;
extern uint8_t gmode, gmode2;
extern int penshotmode, penshotlive, dword_CCC9C;
extern int16_t word_CC0B0[];
extern int demomode;
extern int puckstruct[];
extern uint8_t puckasslist[], byte_DC9D8[];
extern void *fight_dfs_cont;
extern int viewscrollx, viewscrolly;
extern int32_t ctl1team, ctl2team;
extern uint32_t ctl1side, ctl2side;

int input_pad_byte(int pad);                    /* input.c: an SDL pad's byte now (8: none) */
int netplay_pad34(int k, uint8_t *out);
int netplay_session(void);
int fight_holds(int sc);                        /* port/fight/hooks.c */                      /* netplay.c: an online session (the room is up) */         /* netplay.c: pad 3 / 4 of the record being played (1 in a session) */
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

static void mk_free(void);
static void rp_record(void);
static int8_t rp_pl[0x9600 / 0x80][2];         /* pads 3 and 4's players in each replay record (below) */
static int fake_done;           /* this game's pretend pads were given out */

void pads4_clear(void)
{
    int k;
    mk_free();
    fake_done = 0;
    memset(rp_pl, -1, sizeof rp_pl);
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

static void fake_fill(int t1, int t2)
{
    int k = 0;
    fake_done = 1;
    /* one pretend pad beside each of the game's pads, so a 1 v 1 becomes 2 v 2 (both teams when only pad 1 plays) */
    if (t1) pads4_set(k++, t1, PADS4_FAKE);
    if (t2 && t2 != t1) pads4_set(k++, t2, PADS4_FAKE);
    else if (t1 && k < 2) pads4_set(k++, t1 == 1 ? 2 : 1, PADS4_FAKE);
}

void pads4_fake_fill(void)
{
    if (!feel_fake_pads()) return;
    /* as the game's SetupControllers makes cont1team */
    fake_fill(ctl1team < 0 ? 0 : ctl1side == 0 ? 1 : 2, ctl2team < 0 ? 0 : ctl2side == 0 ? 1 : 2);
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

/* no pad 3 or 4 player while the game's own pads have none (between periods) or the pre-game intro and anthem run:
 * a player on assintrostand or assintroline (asstab 25h, 26h). (Not the puck's puckfaceoff2, 1Ch: every faceoff has it.) */
#define P_ASSNUM 0x1C
#define P_ASSLIST 0x1E
static int pads4_idle(void)
{
    int i;
    if (c1playernum[0] < 0 && c2playernum[0] < 0) return 1;
    for (i = 0; i < 12; i++) {
        const uint8_t *p = SortCords + i * 0x80;
        int a = p[P_ASSLIST + (P_W(p, P_ASSNUM) & 7)];
        if (a == 0x25 || a == 0x26) return 1;
    }
    return 0;
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
    if (pads4_idle()) {                                 /* the intro and anthem: the game's pads have nobody yet */
        if (sc >= 0 && sc <= 11 && sc != o[0] && sc != o[1]) P_B(SortCords + sc * 0x80, P_PFLAGS) &= (uint8_t)~PFJOY;
        pads4.player[k] = -1;
        return;
    }
    if (penshotmode || penshotlive) {                   /* the game's own pads leave the ice for a penalty shot too */
        if (sc >= 0 && sc <= 11 && sc != o[0] && sc != o[1]) P_B(SortCords + sc * 0x80, P_PFLAGS) &= (uint8_t)~PFJOY;
        pads4.player[k] = -1;
        return;
    }
    if (sc >= 0 && sc <= 11 && fight_holds(sc)) return;   /* his fight is his pad's (93: the fighter stays the player's) */
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
    for (k = 0; k < 2; k++)
        if (pads4.team[k] && pads4.player[k] == sc) { run_pad(k, p); return; }
}

/* each game frame: so pads 3 and 4 have players at faceoffs too, when updateplayers does not come to .36 */
void pads4_tick(void)
{
    int k;
    if (demomode) return;
    /* the Game page's pretend controllers when no set-up gave them out (a game started without the select-sides
     * step, or the option turned on during the game): beside the game's own pads, as they play now */
    if (!fake_done && !pads4.team[0] && !pads4.team[1] && !netplay_session() && feel_fake_pads() && (cont1team > 0 || cont2team > 0))
        fake_fill(cont1team > 0 ? cont1team : 0, cont2team > 0 ? cont2team : 0);
    for (k = 0; k < 2; k++) keep_player(k);
    rp_record();
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

int pads4_owner(int sc)
{
    int k;
    for (k = 0; k < 2; k++) if (pads4.team[k] && sc >= 0 && pads4.player[k] == sc) return k;
    return -1;
}

int pads4_fake(int k) { return k >= 0 && k < 2 && pads4.src[k] == PADS4_FAKE; }

int pads4_gc_skip(int sc)
{
    int owned, pos = 1, joy = 0;
    sc = (int16_t)sc;
    owned = (pads4.team[0] && sc == pads4.player[0]) || (pads4.team[1] && sc == pads4.player[1]);
    if (sc >= 0 && sc <= 11) {
        uint8_t *pl = SortCords + sc * 0x80;
        pos = P_W(pl, P_POSITION);
        joy = (P_B(pl, P_PFLAGS) & PFJOY) != 0;
    }
    return pads4_give_skip(owned, pads4.team[0] || pads4.team[1], pos, joy);
}

/* GiveControl(ax = player): not pad 3's or 4's (push dword 14h is the 5 bytes moved) */
__attribute__((naked)) static void gc_thunk(void)
{
    __asm__ volatile(
        "pushal\n\tpush %eax\n\tcall " SYM("pads4_gc_skip") "\n\tadd $4, %esp\n\ttest %eax, %eax\n\tpopal\n\t"
        "jnz 1f\n\tpush $0x14\n\tjmp *" SYM("pads4_gc_cont") "\n"
        "1:\n\tret");
}

static void draw_sprite(int frame, int x, int y, int flip)
{
    __asm__ volatile("push $0\n\tcall *%[fn]"
                     : "+a"(frame), "+d"(x), "+b"(y), "+c"(flip)
                     : [fn] "r"(DrawFrameSprite)
                     : "memory", "cc");
}

/* ---- the stars and arrows of 94 Genesis (its ROM, rom94.c), drawn through the fights' DrawFrameSprite hook ----
 * codes FR_MARK + pad x 8 + v: v 0 the star, 1 up, 2 up-right, 3 right (left by the game's flip), 4 down, 5 down-right;
 * FR_MARK + 32 the puck carrier's star. Without the ROM (or the hook) 95 PC's own frames. */
#define FR_MARK 0x7F00
#define MK_N 33
static uint8_t *mk[MK_N];
static uint8_t mk_lut[32];
static int mk_lut_ok;

static int marks94(void)
{
    return fight_dfs_cont && rom94_sprites() != NULL;
}

static void mk_make_lut(void)
{
    uint32_t dac[256], pal[32];
    int v, i;
    video_dac_rgb(dac);
    rom94_rink_palette(pal);
    for (v = 1; v < 32; v++) {
        int best = 0, bd = 1 << 30;
        for (i = 0; i < 0x90; i++) {                    /* not the team colours: a star keeps its colour on any team */
            uint32_t a = dac[byte_DC9D8[i]], b = pal[v];
            int dr = (int)(a >> 16 & 255) - (int)(b >> 16 & 255), dg = (int)(a >> 8 & 255) - (int)(b >> 8 & 255), db = (int)(a & 255) - (int)(b & 255);
            int d = dr * dr * 3 + dg * dg * 4 + db * db * 2;
            if (d < bd) { bd = d; best = i; }
        }
        mk_lut[v] = (uint8_t)best;
    }
    mk_lut_ok = 1;
}

/* as port/fight/hooks.c build(): 16 bytes of header (1, w, h, hot spot), then each row's runs */
static uint8_t *mk_build(int frame, int vflip)
{
    f93_frame f;
    uint8_t *b, *o;
    int x, y, i;
    if (f93_decode(rom94_sprites(), frame, &f) || !f.pix) return NULL;
    b = (uint8_t *)calloc(16 + (size_t)f.w * f.h * 2 + 16, 1);
    if (!b) { f93_frame_free(&f); return NULL; }
    b[0] = 1;
    *(int16_t *)(b + 4) = (int16_t)f.w;
    *(int16_t *)(b + 6) = (int16_t)f.h;
    *(int16_t *)(b + 8) = (int16_t)-f.x0;
    *(int16_t *)(b + 10) = (int16_t)(vflip ? f.y0 + f.h : -f.y0);   /* flipped about the frame's origin, as the VDP does */
    o = b + 16;
    for (y = 0; y < f.h; y++) {
        const uint8_t *row = f.pix + (vflip ? f.h - 1 - y : y) * f.w;
        for (x = 0; x < f.w; ) {
            if (!row[x]) {
                for (i = 0; x + i < f.w && !row[x + i] && i < 127; i++) {}
                *o++ = (uint8_t)i; *o++ = 0xFF;
            } else {
                for (i = 0; x + i < f.w && row[x + i] && i < 127; i++) {}
                *o++ = (uint8_t)(int8_t)-i;
                { int j; for (j = 0; j < i; j++) *o++ = mk_lut[row[x + j] & 31]; }
            }
            x += i;
        }
    }
    *o = 0;
    f93_frame_free(&f);
    return b;
}

/* port/fight/hooks.c fight_sprite: codes from FR_MARK are these */
void *pads4_mark_sprite(int code)
{
    static const int star[4] = { F94_STAR1, F94_STAR2, F94_STAR3, F94_STAR4 };
    static const int arrow[4] = { F94_ARROW1, F94_ARROW2, F94_ARROW3, F94_ARROW4 };
    int i = code - FR_MARK, pad = i / 8, v = i % 8;
    if (i < 0 || i >= MK_N || !marks94()) return NULL;
    if (!mk_lut_ok) mk_make_lut();
    if (!mk[i]) {
        if (i == 32) mk[i] = mk_build(F94_STARPUCK, 0);
        else if (v == 0) mk[i] = mk_build(star[pad], 0);
        else if (v <= 5) mk[i] = mk_build(arrow[pad] + (v == 1 || v == 4 ? 0 : v == 2 || v == 5 ? 1 : 2), v >= 4);
    }
    return mk[i];
}

static void mk_free(void)
{
    int i;
    for (i = 0; i < MK_N; i++) { free(mk[i]); mk[i] = NULL; }
    mk_lut_ok = 0;                                      /* colours again for the next game's palette */
}

/* 95 PC's own frames (word_CC0B0): pad 1's star 185h, pad 2's 186h, the puck carrier's 187h; the arrows of pad 1 and 2
 * (dword_CC0B4 by byte_D41B7's direction of the edge mask: 1 above the screen, 2 below, 4 right, 8 left):
 * up 17Fh / 182h, up-right 180h / 183h, right 181h / 184h, down-right 161h / 163h, down 160h / 162h */
int pads4_mark_code(int frame)
{
    static const int16_t a95[2][5] = { { 0x17F, 0x180, 0x181, 0x160, 0x161 }, { 0x182, 0x183, 0x184, 0x162, 0x163 } };
    int j, v;
    frame = (int16_t)frame;
    if (!marks94()) return frame;
    if (frame == 0x185) return FR_MARK;
    if (frame == 0x186) return FR_MARK + 8;
    if (frame == 0x187) return FR_MARK + 32;
    for (j = 0; j < 2; j++)
        for (v = 0; v < 5; v++)
            if (a95[j][v] == frame) return FR_MARK + j * 8 + 1 + v;
    return frame;
}

/* the replay's (DrawRinkSideObjects): the stars only (its edge flags are not the live ones') */
int pads4_mark_star(int frame)
{
    frame = (int16_t)frame;
    if (!marks94()) return frame;
    return frame == 0x185 ? FR_MARK : frame == 0x186 ? FR_MARK + 8 : frame == 0x187 ? FR_MARK + 32 : frame;
}

__attribute__((naked)) static void star_thunk(void)
{
    __asm__ volatile(
        "pushal\n\tpush %eax\n\tcall " SYM("pads4_mark_star") "\n\tadd $4, %esp\n\tmov %eax, 28(%esp)\n\tpopal\n\t"
        "jmp " SYM("DrawFrameSprite"));
}

/* DrawRinkOverlays' DrawFrameSprite: 95 PC's star and arrow frames become 94's (eax the frame) */
__attribute__((naked)) static void mark_thunk(void)
{
    __asm__ volatile(
        "pushal\n\tpush %eax\n\tcall " SYM("pads4_mark_code") "\n\tadd $4, %esp\n\tmov %eax, 28(%esp)\n\tpopal\n\t"
        "jmp " SYM("DrawFrameSprite"));
}

/* DrawRinkOverlays' DrawRinkObjects: then the stars (or edge arrows) of pads 3 and 4, as the game draws pads 1 and 2's
 * (DrawRinkOverlays: the view's edges from viewscrollx / viewscrolly) */
static void draw_mark(int k, int team, int x, int y)
{
    int slot, fl = 0, vx = (int16_t)viewscrollx, vy = (int16_t)viewscrolly, code;
    {
        slot = team == cont1team ? 0 : team == cont2team ? 1 : 0;
        if (y < 0x140 - (vy + 0xA8)) { y = 0x140 - (vy + 0xA8); fl = 2; }
        else if (y >= 0x140 - vy) { y = 0x140 - vy + 1; fl = 1; }
        if (fl) {
            if (x >= 0x140 - (0xC0 - vx) - 0xC) { x = 0x140 - (0xC0 - vx) - 0xD; fl |= 4; }
            else if (x < vx - 0xB4) { x = vx - 0xB4; fl |= 8; }
        } else {
            if (x >= 0x140 - (0xC0 - vx)) { x = 0x140 - (0xC0 - vx) - 1; fl = 4; }
            else if (x < vx - 0xC0) { x = vx - 0xC0; fl = 8; }
        }
        if (!marks94()) {                               /* 95 PC's: the star of the game pad it swaps into; no arrow */
            if (!fl) draw_sprite(word_CC0B0[1 + slot], x, y, 0);
            return;
        }
        if (!fl) code = FR_MARK + (k + 2) * 8;
        else {
            int up = fl & 1, down = fl & 2, side = fl & 12;     /* (the rink's y goes up the screen) */
            code = FR_MARK + (k + 2) * 8 + (up ? (side ? 2 : 1) : down ? (side ? 5 : 4) : 3);
        }
        draw_sprite(code, x, y, fl & 8);
    }
}

void pads4_draw(void)
{
    int k;
    if (dword_CCC9C || pads4_idle()) return;
    for (k = 0; k < 2; k++) {
        int sc = pads4.player[k];
        uint8_t *p;
        if (!pads4.team[k] || sc < 0 || sc > 11) continue;
        p = SortCords + sc * 0x80;
        if (P_W(p, P_FRAME) == -1) continue;
        draw_mark(k, pads4.team[k], P_W(p, P_XHI), P_W(p, P_YHI));
    }
}

/* ---- replays: the game's records keep pads 1 and 2's players (updatereplay), these keep pads 3 and 4's, one per
 * record (80h bytes from replaystart, 9600h in all); the replay's own positions (ReplayStep's arrays) ---- */
#define RP_N (0x9600 / 0x80)
extern uint8_t *replaystart, *recbpr, *replayplay;
extern uint8_t sflags;
extern int16_t word_E9F18[], word_E9F3A[], word_E9F5C[];
extern char DrawRinkSideObjects[], sub_93540[];
static int8_t rp_team[2];

static void rp_record(void)
{
    long slot;
    int k;
    if ((sflags & 0x80) || dword_CCC9C || !replaystart) return;
    slot = (long)(recbpr - replaystart) >> 7;
    if (slot < 0 || slot >= RP_N) return;
    for (k = 0; k < 2; k++) {
        rp_pl[slot][k] = (int8_t)(pads4.team[k] && !pads4_idle() ? pads4.player[k] : -1);
        rp_team[k] = (int8_t)pads4.team[k];
    }
}

void pads4_replay_draw(void)
{
    long slot;
    int k;
    if (!replaystart) return;
    slot = (long)(replayplay - replaystart) >> 7;
    if (slot < 0 || slot >= RP_N) return;
    for (k = 0; k < 2; k++) {
        int sc = rp_pl[slot][k];
        if (!rp_team[k] || sc < 0 || sc > 11 || word_E9F5C[sc] == -1) continue;
        draw_mark(k, rp_team[k], word_E9F18[sc], word_E9F3A[sc]);
    }
}

/* DrawRinkSideObjects' sub_93540 (the depth order of its three stars): then pads 3 and 4's */
__attribute__((naked)) static void rp_thunk(void)
{
    __asm__ volatile(
        "call " SYM("sub_93540") "\n\t"
        "pushal\n\tcall " SYM("pads4_replay_draw") "\n\tpopal\n\tret");
}

__attribute__((naked)) static void dro_thunk(void)
{
    __asm__ volatile(
        "call " SYM("DrawRinkObjects") "\n\t"
        "pushal\n\tcall " SYM("pads4_draw") "\n\tpopal\n\tret");
}

/* DrawRinkOverlays .27 / .28: the one DrawFrameSprite of the stars and arrows (mov eax, [eax*2 + word_CC0B0] /
 * sar eax, 10h / xor ecx, ecx / call DrawFrameSprite; the arrow and puck paths jump to the call) */
static int patch_marks(char *fn, size_t n, void (*thunk)(void))
{
    uint8_t *base = (uint8_t *)fn;
    size_t i;
    for (i = 12; i + 5 <= n; i++) {
        uint8_t *c = base + i, code[5];
        uint32_t a;
        int32_t rel;
        if (c[0] != 0xE8 || c[-2] != 0x31 || c[-1] != 0xC9 || c[-5] != 0xC1 || c[-4] != 0xF8 || c[-3] != 0x10) continue;
        if (c[-12] != 0x8B || c[-11] != 0x04 || c[-10] != 0x45) continue;
        memcpy(&a, c - 9, 4);
        if (a != (uint32_t)(uintptr_t)word_CC0B0) continue;
        memcpy(&rel, c + 1, 4);
        if ((uintptr_t)c + 5 + (uintptr_t)(intptr_t)rel != (uintptr_t)DrawFrameSprite) return 0;
        rel = (int32_t)((uintptr_t)thunk - ((uintptr_t)c + 5));
        code[0] = 0xE8;
        memcpy(code + 1, &rel, 4);
        patch_bytes(c, code, 5);
        return 1;
    }
    return 0;
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

/* changeplayer skips an animation-locked skater, and the matched body cannot grow a joy test.
 * For the call, that bit is set on teammates this pad must not take and cleared when it returns. */
static uint8_t guard_sc[6];
static int guard_n;
void *pads4_cp_cont;            /* the fights' thunk, or cp_push_stub when fights did not hook it */
void *pads4_cp_body;            /* changeplayer + 5 (call __CHK), for cp_push_stub */

void pads4_guard_on(uint8_t *p, int ctl)
{
    int16_t humans[4];
    int mine, home, base, i, nh = 0;
    guard_n = 0;
    ctl = (int16_t)ctl;
    mine = ctl ? c2playernum[0] : c1playernum[0];
    /* the six changeplayer scans: team 1 at 0, anything else at 6 */
    home = (ctl ? cont2team : cont1team) == 1;
    if (c1playernum[0] != mine && c1playernum[0] >= 0) humans[nh++] = c1playernum[0];
    if (c2playernum[0] != mine && c2playernum[0] >= 0) humans[nh++] = c2playernum[0];
    if (pads4.team[0] && pads4.player[0] != mine && pads4.player[0] >= 0) humans[nh++] = pads4.player[0];
    if (pads4.team[1] && pads4.player[1] != mine && pads4.player[1] >= 0) humans[nh++] = pads4.player[1];
    base = home ? 0 : 6;
    for (i = base; i < base + 6 && guard_n < 6; i++) {
        uint8_t *pl = SortCords + i * 0x80;
        int sc = P_W(pl, P_SCNUM), joy = (P_B(pl, P_PFLAGS) & PFJOY) != 0;
        if (p && pl == p) continue;                     /* the caller: a sweep check must still lock him */
        if (pads4_may_take(sc, mine, joy, humans, nh)) continue;
        if (P_B(pl, P_PFLAGS) & PFALOCK) continue;      /* the game already skips him */
        P_B(pl, P_PFLAGS) |= PFALOCK;
        guard_sc[guard_n++] = (uint8_t)i;
    }
    if (log_on() && guard_n) fprintf(stderr, "pads4: changeplayer leaves %d teammates\n", guard_n);
}

void pads4_guard_off(void)
{
    int i;
    for (i = 0; i < guard_n; i++) P_B(SortCords + guard_sc[i] * 0x80, P_PFLAGS) &= (uint8_t)~PFALOCK;
    guard_n = 0;
}

/* push 28h and enter changeplayer's body, as the fights' thunk does when it is the one installed */
__attribute__((naked)) static void cp_push_stub(void)
{
    __asm__ volatile("push $0x28\n\tjmp *" SYM("pads4_cp_body"));
}

/* changeplayer (eax player, edx controller). The fights' hook may already sit on the entry. */
__attribute__((naked)) static void cp_thunk(void)
{
    __asm__ volatile(
        "pushal\n\tpush %edx\n\tpush %eax\n\tcall " SYM("pads4_guard_on") "\n\tadd $8, %esp\n\tpopal\n\t"
        "call *" SYM("pads4_cp_cont") "\n\t"
        "pushal\n\tcall " SYM("pads4_guard_off") "\n\tpopal\n\tret");
}

static void hook_changeplayer(void)
{
    uint8_t *p = (uint8_t *)changeplayer;
    static const uint8_t push28[5] = { 0x68, 0x28, 0, 0, 0 };
    if (p[0] == 0xE9) {                         /* the fights' thunk: it pushes 28h and jumps to the body */
        int32_t rel;
        memcpy(&rel, p + 1, 4);
        pads4_cp_cont = p + 5 + rel;
    } else if (!memcmp(p, push28, 5)) {
        pads4_cp_body = p + 5;
        pads4_cp_cont = (void *)cp_push_stub;
    } else {
        fprintf(stderr, "Four players: changeplayer is not the expected code, a pass can switch onto a teammate\n");
        return;
    }
    patch_jmp(changeplayer, (void *)cp_thunk);
}

void pads4_install(void)
{
    static const uint8_t push14[5] = { 0x68, 0x14, 0, 0, 0 };
    rom94_load();                                       /* (at start-up: the folder is searched once) */
    hook_changeplayer();                                /* before the early return: pad 1 and 2 use it too */
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
    if (!redirect_call(DrawRinkSideObjects, 0x400, sub_93540, (const void *)rp_thunk))
        fprintf(stderr, "Four players: DrawRinkSideObjects is not the expected code, replays show no star for pads 3 and 4\n");
    if (!patch_marks(DrawRinkSideObjects, 0x700, star_thunk))
        fprintf(stderr, "Four players: the replay's star call is not the expected code, it keeps 95 PC's stars\n");
    if (!patch_marks(DrawRinkOverlays, 0x9E0, mark_thunk)) fprintf(stderr, "Four players: DrawRinkOverlays' star call is not the expected code, pads 1 and 2 keep 95 PC's stars\n");
}

#endif /* !PADS4_TEST */
