/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * The game side of NHLPA 93's fights (port/fight/hooks.h, HOOKS.md). Stage 1: a fight starts where 93's checkfight
 * did (after checkcheck in checkcx), port/fight/rules.c runs it once a frame before updateplayers, and it ends with
 * a penalty for both. A fighter on a team with a controller is given to it (93's setd0player) and is played from
 * the pad (doinput, patched); the others are played by the computer.
 *
 * 95 PC kept 93's pf2fight (pflags2 bit 0): a player with it gets no joystick skating and no collisions or falls,
 * and the puck's bit makes the others face xc1 / yc1. Faceoffs clear the bit.
 */
#include "hooks.h"
#include "rules.h"
#include "rom93.h"
#include "../rom94.h"
#include "punch.h"

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#include "../host.h"
#include "../feel.h"
#include "../sides.h"
#include "../pads4.h"

#ifdef _WIN32
#define SYM(s) "_" s
#else
#define SYM(s) s
#endif

extern char checkcx[], checkcheck[], DoGameFrame[], updateplayers[], FallDown[];
extern uint8_t SortCords[], puckstruct[];
extern uint8_t gmode, sflags, puckpflags2;
extern signed char PenBuf[], PenBuf_pl[], penmintab[];
extern short ovltimer, ovlseq, refsignal, Pencntdwn;
extern unsigned char textline1[0x3C], textline2[0x3C], textline3[0x3C], hmroster[], hmrosterjersey[];
extern char DrawFrameSprite[], changeplayer[], doinput[], ClockTick[], DrawRinkOverlays[], DrawTextOverlay[], assrefgoalpa[];
extern short scrollx, scrolly;
extern int hudhundaccum;
extern uint8_t gmode2;
extern int32_t introskipped;     /* the post-play was skipped: the screen fades to the next faceoff */
extern int32_t regd0, regd1;
extern short c1playernum[], c2playernum[], cont1team, cont2team, lastplayer;
extern uint32_t gameopts;
extern int16_t gsp, xc1, yc1;
extern short HomeTeam, VisTeam, crowdlevel, CwdExciteLvl;
extern uint8_t byte_DC9D8[256], byte_DC8D8[256];       /* the sprite colour remaps: home, visitors */
extern char *penaltynames[], *off_CD354[];      /* by event type (penalty - 9): the name shown, the announcer's file */
extern char BuildEventLines[], GameSummaryScreen[], PostPenaltyEvent[];
extern short word_CC0B0[];                      /* the box-time count of a call (chkprogress) */

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
#define P_PNUM 0x47
#define P_SCNUM 0x6A
#define PLAYER(i) (SortCords + (i) * 0x80)

#define PEN_ROUGHING 9                  /* Roughing: its minutes are made 5 while a fight's is waiting (93's Fighting) */
#define PEN_INST 0xD                    /* the other Roughing (2 minutes): 93's Instigator */
/* event types (penalty - 9) past 95 PC's 18 (penaltynames / off_CD354 are copied to longer tables): the fight's
 * penalties are called as Roughing and posted under these */
#define EV_ROUGHING 0
#define EV_ROUGHING2 4
#define EV_FIGHTING 18
#define EV_FIGHTING_W 19                /* the winner: 93's "Fighting *" */
#define EV_INSTIGATOR 20
#define NEV 21
#define P_SPA 0x38
#define P_TMPTR 0x6C
#define T_TMPDST 0x7E
#define ASS_NOTHING 0                   /* asstab 0: rtss */
#define ASS_PUCKNOTHING 26
#define ASS_PENBOX 0xC
#define CAM_DX 0x30
#define CAM_DY 0x30

static fight ft;
static uint8_t *who[2];
static int checks[12], chkcnt, last_gsp = -1;
static uint8_t *fall_h;
static int fall_checks = -1;
void *fight_fd_cont;
/* checkcheck runs for a pair every frame they touch and impact stays up for frames after a hit: 93's checkfight
 * ran once per hit (chkhit). A pair counts again only after HIT_GAP frames without contact. */
#define HIT_GAP 30
static uint32_t frame_no, pair_seen[12][12];
static rom93 rom;
static int have_rom, punch_on;
static int ok_check, ok_frame, no_draw;

/* ---- drawing: the 93 frames as 95 PC sprites (stage 2) ----
 * 95 PC's sprite: a flag byte (non-zero: the run-length blitter), w and h at +4 / +6, the hot spot at +8 / +0Ah, then
 * from +10h: a count byte c > 0 and a colour (FFh: c transparent pixels) or c < 0 and -c literal colours, 0 ends;
 * rows follow on from each other. After updateplayers a fighter's frame is FR_93 + fighter x 400h + his 93 frame,
 * which DrawFrameSprite (patched) draws from here, so DrawRinkOverlays draws it in his place, in depth order, and
 * replays (which keep the frame numbers) show it too; his own frame is put back before the next updateplayers. The colours are found once per fight: the 95 PC sprite index whose remapped palette
 * entry is nearest to each 93 colour (team colours among 95 PC's own team-colour indexes, 90h-BFh). */
#define NFR 1024
static uint8_t *spr[4][NFR];            /* built frames per slot (fighters 0 / 1, check injuries 2 home / 3 away), 93 frame */
static uint8_t lut[4][64];
#define FR_93 0x7000
static int saved_frame[2], drawing, replay_frame[2], post[2], post_timer;
void *fight_dfs_cont, *fight_cp_cont, *fight_di_cont, *fight_ck_cont, *fight_ro_cont, *fight_dto_cont, *fight_rg_cont, *fight_pp_cont;
/* 93's glovecords: the dropped gloves on the ice. 93's sprite is one pile with both sticks and glove pairs; it is drawn
 * as two halves (PILE_L, PILE_R: a stick and its gloves each) so the referee can pick them up one at a time. */
static int gloves, glove_x, glove_y;
static int pile_on[2], pile_k[2], pile_side[2];  /* per half: still on the ice, whose colours (fighter), home/visitors */
static int whistled;                            /* play was stopped for this fight's penalties (Stop4Pen) */
static struct { int team, pnum, from, to; } evmap[4];  /* a penalty to post under another event type */
static int nevmap, ev_ok;
static uint8_t *coin[2];                        /* fighters whose major does not take a man off (93's coincidental) */
static int cue = -1, cue_seen, cue_time;        /* the crowd's music cue after a fight, waiting for the penalties */
static int ref_time;                            /* the referee: frames spent collecting */
#define PILE_L 1000
#define PILE_R 1001
/* The replay keeps 11 bits of a frame (updatereplay: 7FFh is none), so FR_93 codes do not survive it. The frames a
 * fighter or a check injury shows are put in the free numbers above 95 PC's last frame (46Dh) instead: FR_RP + slot x
 * 60h + their place in this list; the replay plays them back the same. */
#define FR_RP 0x480
#define FR_RP_END (FR_RP + 4 * 0x60)
static int fr_idx(int n)
{
    if (n >= 354 && n <= 376) return n - 354;           /* F93_FIGHT .. F93_FINJURY + 5 */
    if (n >= 633 && n <= 644) return 23 + n - 633;      /* the bloody check injury frames */
    if (n == PILE_L || n == PILE_R) return 35 + n - PILE_L;
    return -1;
}
static int fr_n(int i) { return i < 23 ? 354 + i : i < 35 ? 633 + i - 23 : PILE_L + i - 35; }
static int fr_code(int k, int n)
{
    int i = fr_idx(n);
    return i >= 0 ? FR_RP + k * 0x60 + i : 0x7000 + k * 0x400 + n;
}
#define PILE_SPLIT 50                           /* the column of 93's glove frame between the two halves */
static int pad_dir[2] = { 8, 8 }, pad_new[2];
int fight_on_now;
static uint8_t *build(int k, int n);
static int watcher[12], watch_t[12], watch_x[12], watch_y[12], nwatch, pen_wait, hold_lines;
static void free_sprites(void);
static void show_names(void);
static void make_lut(int k);
#define NTEAM95 28
static int8_t fpal_set[NTEAM95][2];             /* a section for this jersey (team, 0 home / 1 away) */
static int16_t fpal[NTEAM95 + 1][2][48];        /* [NTEAM95]: lines before any section, for every jersey */
static int team93(int t95);
static void undraw(void);
static void start_penalties(int inst);
static void give_control(uint8_t *p);

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

static int restore_pl(int newpl, int oldpl)
{
    int a = newpl, d = oldpl;
    __asm__ volatile("call " SYM("restorepl") : "+a"(a), "+d"(d) : : "ecx", "memory", "cc");
    return (int16_t)a;
}

/* 93's setd0player: a fighter whose team has a controller is given to it (controller 2 first if it had the last
 * player). The one he had gets pfna, which his own assignment takes up after the fight. */
static void give_control(uint8_t *p)
{
    int sc = P_W(p, P_SCNUM), team = sc < 6 ? 1 : 2;
    if (c1playernum[0] == sc || c2playernum[0] == sc || pads4_owner(sc) >= 0) return;   /* pad 3 or 4 keeps his own */
    if (lastplayer == c2playernum[0] && cont2team == team) c2playernum[0] = (short)restore_pl(sc, c2playernum[0]);
    else if (cont1team == team) c1playernum[0] = (short)restore_pl(sc, c1playernum[0]);
    else if (cont2team == team) c2playernum[0] = (short)restore_pl(sc, c2playernum[0]);
}

/* a fighter someone plays: a game pad has him (pflags bit 3), and it is not the Game page's pretend controller, which
 * has no input (that fighter fights as the computer's would) */
static int fighter_human(const uint8_t *p)
{
    int sc = P_W(p, P_SCNUM);
    if (!(P_B(p, P_PFLAGS) & 8)) return 0;
    if (sc == c1playernum[0] && port_sides_slot_fake(0)) return 0;
    if (sc == c2playernum[0] && port_sides_slot_fake(1)) return 0;
    if (pads4_owner(sc) >= 0 && pads4_fake(pads4_owner(sc))) return 0;
    return 1;
}

/* doinput (patched): during a fight a fighter's pad goes to the fight (93's fightinput) and nobody else skates,
 * changes player or shoots from the pad; after it the fighters stay put until they are sent off. 1: skip doinput. */
int fight_doinput(uint8_t *p)
{
    int k;
    for (k = 0; k < 2; k++) {
        if (p != who[k]) continue;
        if (ft.on) {
            int d = regd0 & 0xF, b = regd1 & 0xFFFF;
            pad_dir[k] = d > 7 ? 8 : d;
            pad_new[k] |= (b & 0x40 ? FP_A : 0) | (b & 0x10 ? FP_B : 0) | (b & 0x20 ? FP_C : 0);
            return 1;
        }
        if (post[k]) return 1;
    }
    return ft.on;
}

/* ---- start (93's checkfight) ---- */
static int fighting_of(const uint8_t *p);

static void to_fighter(fighter *f, const uint8_t *p, int away)
{
    f->x = P_W(p, P_XPOS_HI);
    f->y = P_W(p, P_YPOS_HI);
    f->xvel = P_W(p, P_XVEL);
    f->yvel = P_W(p, P_YVEL);
    f->facedir = P_W(p, P_FACEDIR) & 7;
    f->human = 0;                       /* set once the controllers are given out (fight_check) */
    f->fighting = fighting_of(p);               /* 93's fighting nibble, not 95 PC's aggression */
    f->checking = P_B(p, P_CHECKING) & 0xF;
    f->energy = 0x1000;
    f->away = away;
}

/* 93 setplayer copies pldcheck & $E into fighting. 95 PC's setplayer never reads that byte: it is attribute
 * record +8 (between shot accuracy and passing), the hole the create-player screen does not fill. Aggression
 * (0x62) is a different rating and is high on star players, so it is not used. */
static int fighting_of(const uint8_t *p)
{
    uint8_t *t, *r;
    int n;
    if (!p) return 0;
    n = (int8_t)P_B(p, P_PNUM);
    t = *(uint8_t **)(p + 0x6C);                /* tmptr */
    if (!t || n < 0 || n >= 25) return 0;
    r = *(uint8_t **)(t + 0xDE);                /* skater ratings, 20 bytes each (setplayer's TMSKRAT) */
    if (!r) return 0;
    return fight_rating_byte(r[n * 20 + 8]);
}

static int can_fight(const uint8_t *p)
{
    int sc = P_W(p, P_SCNUM);
    /* 93 checkfight: not a goalie, impact 10, not already fighting, not the one who drew the penalty,
     * and not animation-locked (pfalock, pflags bit 5) */
    return sc >= 0 && sc < 12 && P_W(p, P_POSITION) > 0 && P_W(p, P_IMPACT) >= 10
        && !(P_B(p, P_PFLAGS2) & 0x11) && !(P_B(p, P_PFLAGS) & 0x20);
}

/* FallDown counted a team check (word +24h of the hitter's team) only for a real knockdown, with the clock
 * running and not in a highlight. 93's ChkCnt moves there, and once more by 2 when his fighting rating is 0. */
void fight_fall_before(uint8_t *h)
{
    uint8_t *t;
    fall_h = h;
    fall_checks = -1;
    if (gsp != last_gsp) { last_gsp = gsp; chkcnt = 0; memset(checks, 0, sizeof checks); }
    if (!h) return;
    t = *(uint8_t **)(h + 0x6C);
    if (!t) return;
    fall_checks = *(int16_t *)(t + 0x24);
}

void fight_fall_after(void)
{
    uint8_t *h = fall_h, *t;
    int now, sc;
    if (!h || fall_checks < 0) return;
    t = *(uint8_t **)(h + 0x6C);
    if (!t) return;
    now = *(int16_t *)(t + 0x24);
    if (now == fall_checks) return;
    sc = P_W(h, P_SCNUM);
    if (sc >= 0 && sc < 12) checks[sc]++;
    chkcnt += fight_check_weight(fighting_of(h));
}

void fight_check(uint8_t *a, uint8_t *b)
{
    int inst, k;
    if (ft.on || post[0] || post[1] || !feel_fights()) return;
    if (gsp != last_gsp) { last_gsp = gsp; chkcnt = 0; memset(checks, 0, sizeof checks); } /* a new period: 93 clears ChkCnt */
    {
        int sa = P_W(a, P_SCNUM), sb = P_W(b, P_SCNUM);
        uint32_t *seen, was;
        if (sa < 0 || sa >= 12 || sb < 0 || sb >= 12 || P_W(a, P_IMPACT) < 10 || P_W(b, P_IMPACT) < 10) return;   /* not a hit */
        seen = &pair_seen[sa < sb ? sa : sb][sa < sb ? sb : sa];
        was = *seen;
        *seen = frame_no ? frame_no : 1;
        if (was && frame_no - was < HIT_GAP) return;                 /* the same hit, still in contact */
    }
    if (!can_fight(a) || !can_fight(b)) return;
    if ((gmode & 0x11) || (sflags & 0x80) || (puckpflags2 & 1)) return;   /* clock stopped, or a highlight */
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
    fight_on_now = 1;
    start_penalties(inst);
    crowdlevel = (short)(crowdlevel + ft.crowd);        /* the crowd gets up for a fight */
    CwdExciteLvl = (short)(CwdExciteLvl + ft.excite);
    if (have_rom) {
        free_sprites();
        make_lut(0);
        make_lut(1);
    }
    /* the camera centre is up and to the left of the fight, so the fighters are not under the scoreboard box
     * (top left of the screen) */
    xc1 = (int16_t)(ft.xc1 - CAM_DX);
    yc1 = (int16_t)(ft.yc1 + CAM_DY);
    sflags |= 0x40;                     /* 93's sfslock: the camera stays on xc1 / yc1 */
    for (k = 0; k < 2; k++) {
        P_B(who[k], P_PFLAGS2) |= 1 | 4;        /* fighting, unavailable */
        ass_insert(who[k], ASS_NOTHING);
        give_control(who[k]);
        ft.f[k].human = fighter_human(who[k]);
        pad_dir[k] = 8;
        pad_new[k] = 0;
    }
    /* everyone else watches (93's afwatch): no assignment and, with pflags2 bit 0, no skating from the joystick */
    nwatch = 0;
    for (k = 0; k < 12; k++) {
        uint8_t *p = PLAYER(k);
        if (p == a || p == b || P_W(p, P_POSITION) <= 0 || (P_B(p, P_PFLAGS2) & 1)) continue;
        P_B(p, P_PFLAGS2) |= 1;
        ass_insert(p, ASS_NOTHING);
        watch_t[nwatch] = 0;
        watcher[nwatch++] = k;
    }
    puckpflags2 |= 1;
    ass_insert(puckstruct, ASS_PUCKNOTHING);
    show_names();
    if (getenv("NHL95_FIGHT_LOG"))
        fprintf(stderr, "fight: %d against %d (fighting %d / %d), instigator %d\n", P_W(a, P_SCNUM), P_W(b, P_SCNUM), ft.f[0].fighting,
                ft.f[1].fighting, inst);
}

/* ---- each frame ---- */
/* the fighter's own assignment and flags back; held: he keeps them (no skating) until fight_after lets him go */
static void let_go(uint8_t *p)
{
    P_B(p, P_PFLAGS2) &= (uint8_t)~(P_B(p, P_PFLAGS2) & 0x40 ? 1 : 1 | 4);   /* hurt: stays unavailable */
    if (((const int8_t *)p)[0x1E + (P_W(p, P_ASSNUM) & 7)] == ASS_NOTHING) ass_done(p);
}

static void release(int hold)
{
    int k;
    if (!hold)
        for (k = 0; k < 2; k++) let_go(who[k]);
    for (k = 0; k < nwatch; k++) {
        uint8_t *p = PLAYER(watcher[k]);
        P_B(p, P_PFLAGS2) &= (uint8_t)~1;
        ass_done(p);
    }
    nwatch = 0;
    puckpflags2 &= (uint8_t)~1;
    ass_done(puckstruct);
    sflags &= (uint8_t)~0x40;
    if (hold_lines && ovltimer >= 0 && ovltimer <= 0x100) ovltimer = 0x258;      /* the names slide out */
    hold_lines = 0;
    ft.on = 0;
    fight_on_now = 0;
}

static void map_event(const uint8_t *p, int from, int to)
{
    int i, team = (P_B(p, P_PFLAGS) & 0x40) != 0, pn = P_B(p, P_PNUM) & 0x7F;
    if (!ev_ok) return;
    for (i = 0; i < nevmap; i++)
        if (evmap[i].team == team && evmap[i].pnum == pn && evmap[i].from == from) { evmap[i].to = to; return; }
    if (nevmap < 4) { evmap[nevmap].team = team; evmap[nevmap].pnum = pn; evmap[nevmap].from = from; evmap[nevmap].to = to; nevmap++; }
}

/* PostPenaltyEvent (eax team, edx player, ebx type): a fight's penalty is posted under its own name */
int fight_pen_type(int team, int player, int type)
{
    int i;
    for (i = 0; i < nevmap; i++)
        if (evmap[i].team == team && evmap[i].pnum == (player & 0x7F) && evmap[i].from == type) {
            type = evmap[i].to;
            evmap[i] = evmap[--nevmap];
            break;
        }
    return type;
}

/* 93's checkfight .sf and SetInst: both fighters get Fighting (5 minutes) when the fight starts, and 1 time in 4 with
 * penalties on (fight_wants' instigator) the first free skater of the instigator's team, not the fighter himself,
 * gets Instigator (2 minutes). 93 made a fighter the puck owner first, so the call is never delayed: the whistle
 * blows now (Stop4Pen) and the stoppage waits for the fight (fight_frame holds its count-down). */
static void start_penalties(int inst)
{
    int k, i;
    nevmap = 0;
    penmintab[PEN_ROUGHING] = 5;
    pen_wait = 1;
    for (k = 0; k < 2; k++) {
        add_penalty2(who[k], PEN_ROUGHING);
        map_event(who[k], EV_ROUGHING, EV_FIGHTING);
        coin[k] = who[k];
    }
    if (inst == 0 || inst == 1) {
        uint8_t *f = who[inst];
        int base = P_W(f, P_SCNUM) < 6 ? 0 : 6;
        for (i = base; i < base + 6; i++) {
            uint8_t *q = PLAYER(i);
            if (q == f || P_W(q, P_POSITION) <= 0 || (P_B(q, P_PFLAGS2) & (0x10 | 4))) continue;
            add_penalty2(q, PEN_INST);
            map_event(q, EV_ROUGHING2, EV_INSTIGATOR);
            break;
        }
    }
    whistled = 0;
    if (!(gmode & 1)) {
        for (i = 0; i < 0x20 && PenBuf[i * 2]; i++) {
            int pl = PenBuf_pl[i * 2] & 0x7F;
            if (PenBuf[i * 2] == PEN_ROUGHING && (PLAYER(pl) == who[0] || PLAYER(pl) == who[1])) {
                int a = i;
                refsignal = 0x28;
                __asm__ volatile("call " SYM("Stop4Pen") : "+a"(a) : : "ecx", "edx", "memory", "cc");
                whistled = 1;
                break;
            }
        }
    }
}

/* the fight is over (93: its penalty count-down ran out, a knockout cut it to 60 / 180 frames): the penalty
 * sequence starts at once, no second whistle */
static void end_fight(void)
{
    release(1);
    if (ft.winner >= 0) map_event(who[ft.winner], EV_ROUGHING, EV_FIGHTING_W);
    post[0] = post[1] = 1;
    post_timer = 1200;            /* 10 s (counted once per fighter a frame) */
    if (whistled && Pencntdwn > 0) Pencntdwn = 0;
    whistled = 0;
}

/* each frame of a fight: the stoppage's count-downs are held until it is over */
static void hold_stoppage(void)
{
    if (!whistled) return;
    if (Pencntdwn < 2) Pencntdwn = 2;
    if (word_CC0B0[0] >= 0 && word_CC0B0[0] < 2) word_CC0B0[0] = 2;
}

/* a fighter in the box for his major does not leave his team a man short (tmpdst bit 12, as 93's coincidental
 * majors): set once InProgress has put him there */
static void mark_coincidental(void)
{
    int k;
    for (k = 0; k < 2; k++) {
        uint8_t *p = coin[k], *t;
        int16_t *dst;
        if (!p) continue;
        t = *(uint8_t **)(p + P_TMPTR);
        if (!t) { coin[k] = NULL; continue; }
        dst = (int16_t *)(t + T_TMPDST) + (P_B(p, P_PNUM) & 0x7F);
        if (*dst > 0) { *dst = (int16_t)(*dst | 0x1000); coin[k] = NULL; }
        else if (gmode2 & 1) coin[k] = NULL;    /* the faceoff came and he is not in the box */
    }
}

/* Roughing goes back to 2 minutes once the fight's two are out of PenBuf (called, or dropped) */
static void check_pen_wait(void)
{
    int i, left = 0;
    if (!pen_wait) return;
    for (i = 0; i < 0x20; i++) {
        int pl = PenBuf_pl[i * 2] & 0x7F;
        if (PenBuf[i * 2] == PEN_ROUGHING && (PLAYER(pl) == who[0] || PLAYER(pl) == who[1])) left++;
    }
    if (!left) { penmintab[PEN_ROUGHING] = 2; pen_wait = 0; }
}

/* 93's banner with the two names, in 95 PC's scoreboard box: "#8 Cam Neely / vs. / #24 Bob Probert" */
static void name_line(unsigned char *out, const uint8_t *p)
{
    int side = (P_B(p, P_PFLAGS) & 0x40) != 0, pn = P_B(p, P_PNUM) & 0x7F;
    const unsigned char *r = hmroster + side * 0x444 + pn * 0x27;
    /* first name at +7, last at +17h (BuildEventLines' FormatPlayerName arguments). The box holds about 20 of the
     * scoreboard font's characters: a longer full name becomes "F. Last", then the last name alone. */
    int num = hmrosterjersey[side * 0x444 + pn * 0x27];
    const char *first = (const char *)r + 7, *last = (const char *)r + 0x17;
    snprintf((char *)out, 0x3C, "#%d %.15s %.20s", num, first, last);
    if (!first[0] || strlen((char *)out) > 20) snprintf((char *)out, 0x3C, "#%d %c. %.20s", num, first[0], last);
    if (!first[0] || strlen((char *)out) > 20) snprintf((char *)out, 0x3C, "#%d %.20s", num, last);
}

static void show_names(void)
{
    if (ovltimer >= 0) return;          /* the box is busy (a goal, a penalty): no names */
    name_line(textline3, who[0]);
    snprintf((char *)textline1, 0x3C, "vs.");
    name_line(textline2, who[1]);
    ovlseq = -1;
    ovltimer = 0;
    hold_lines = 1;
}

/* a human fighter skates from the pad (93's fightinput calls playeracc) */
static void fight_accel(void *ctx, int k, int dir)
{
    fighter *f = &ft.f[k];
    (void)ctx;
    P_W(who[k], P_XVEL) = (int16_t)f->xvel;
    P_W(who[k], P_YVEL) = (int16_t)f->yvel;
    feel_playeracc(who[k], dir);
    f->xvel = P_W(who[k], P_XVEL);
    f->yvel = P_W(who[k], P_YVEL);
}

/* 93's assfwatch: each watcher skates to a spot 80 from the fight on the line to him, picked again every second, and
 * skateto turns him to face the fight once he is there (the puck's pflags2 bit 0) */
static void watch(void)
{
    int k;
    for (k = 0; k < nwatch; k++) {
        uint8_t *p = PLAYER(watcher[k]);
        if (--watch_t[k] < 0) {
            int dx = P_W(p, P_XPOS_HI) - ft.xc1, dy = P_W(p, P_YPOS_HI) - ft.yc1, d = (int)sqrt((double)dx * dx + (double)dy * dy), x;
            if (!d) d = 1;
            watch_t[k] = 60;
            x = ft.xc1 + dx * 0x50 / d;
            if (x > 0x7E) x = 0x7E;
            if (x < -0x7E) x = -0x7E;
            watch_x[k] = x;
            watch_y[k] = ft.yc1 + dy * 0x50 / d;
        }
        regd0 = (regd0 & ~0xFFFF) | (watch_x[k] & 0xFFFF);
        regd1 = (regd1 & ~0xFFFF) | (watch_y[k] & 0xFFFF);
        {
            int a = (int)(uintptr_t)p, d = 0;
            __asm__ volatile("call " SYM("skateto") : "+a"(a), "+d"(d) : : "memory", "cc");
        }
    }
}

int fight_holds(int sc)
{
    int k;
    for (k = 0; k < 2; k++)
        if ((ft.on || post[k]) && who[k] && P_W(who[k], P_SCNUM) == sc) return 1;
    return 0;
}

void fight_frame(void)
{
    int k;
    pads4_tick();
    undraw();
    frame_no++;
    if (gmode2 & 1) gloves = 0;         /* a faceoff clears them (93's puckfaceoff2) */
    if ((gmode2 & 1) && !ft.on && !post[0] && !post[1]) nevmap = 0;   /* the fight's calls are posted by now */
    check_pen_wait();
    mark_coincidental();
    if (cue >= 0) {                     /* the music starts once the penalty sequence is over, not during it */
        if (PenBuf[0]) cue_seen = 1;
        if ((gmode2 & 1) || introskipped) cue = -1;                          /* the faceoff came first: no cue */
        else if ((cue_seen && !PenBuf[0]) || ++cue_time > 1200) {
            int n = cue;
            cue = -1;
            __asm__ volatile("call " SYM("PlayCrowdSample") : "+a"(n) : : "ecx", "edx", "memory", "cc");
        }
    }
    /* the scoreboard box only runs while play is stopped (chkprogress): during the fight it is moved on here */
    if (hold_lines && !(gmode & 1) && ovltimer >= 0 && ovltimer < 0x100) ovltimer++;
    if (!ft.on) return;
    if ((gmode & 1) && !whistled) {     /* play stopped some other way (a goal, the period): no penalty */
        release(0);
        return;
    }
    hold_stoppage();
    for (k = 0; k < 2; k++) {
        fighter *f = &ft.f[k];
        f->x = P_W(who[k], P_XPOS_HI);
        f->y = P_W(who[k], P_YPOS_HI);
        f->xvel = P_W(who[k], P_XVEL);
        f->yvel = P_W(who[k], P_YVEL);
    }
    {
        int pad[2];
        for (k = 0; k < 2; k++) {
            ft.f[k].human = fighter_human(who[k]);
            pad[k] = pad_dir[k] | pad_new[k] << 4;
            pad_new[k] = 0;
        }
        fight_pass(&ft, 1, pad, fight_accel);
        crowdlevel = (short)(crowdlevel + ft.crowd);    /* 93's Crowdlevel / CwdExciteLvl: each punch, the end */
        CwdExciteLvl = (short)(CwdExciteLvl + ft.excite);
    }
    watch();
    for (k = 0; k < 2; k++) {
        fighter *f = &ft.f[k];
        P_W(who[k], P_XVEL) = (int16_t)f->xvel;
        P_W(who[k], P_YVEL) = (int16_t)f->yvel;
        P_W(who[k], P_FACEDIR) = (int16_t)f->facedir;
    }
    if (ft.events & (FE_PUNCH_HIGH | FE_PUNCH_LOW)) {
        if (have_rom) {
            if (!punch_on) { punch_init(&rom); punch_on = 1; }
            punch_play(!(ft.events & FE_PUNCH_HIGH));
        }
    }
    if (ft.events & FE_GLOVES) {        /* the gloves stay on the ice until the next faceoff */
        int l = P_W(who[0], P_XPOS_HI) > P_W(who[1], P_XPOS_HI);       /* the fighter on the left */
        gloves = 1;
        glove_x = ft.glove_x * 4;
        glove_y = ft.glove_y * 4;
        pile_k[0] = l; pile_k[1] = !l;
        for (k = 0; k < 2; k++) { pile_on[k] = 1; pile_side[k] = P_W(who[pile_k[k]], P_SCNUM) >= 6; }
        ref_time = 0;
    }
    if (ft.events & FE_INJURY) {
        /* 93: the loser is hurt (pf2inj, pflags2 bit 6: 95 PC still skates him at 1/8 speed with its stumble, SPA
         * 8D3h). 93 ran setInjuryType and then wrote his box time over its result (tmpdst $112C): he is out for his
         * 5 minute major, not for the period or the game. So only its crowd and sound here; the major puts him in
         * the box. */
        uint8_t *p = who[ft.loser];
        int a = 0xA1;
        P_B(p, P_PFLAGS2) |= 0x40 | 4;
        if (crowdlevel <= 1000) { crowdlevel = (short)(crowdlevel + 300); if (crowdlevel > 1000) crowdlevel = 1000; }
        CwdExciteLvl = (short)(CwdExciteLvl + 30);
        __asm__ volatile("call " SYM("sfx") : "+a"(a) : : "ecx", "edx", "memory", "cc");
    }
    if (ft.events & (FE_CHEER | FE_BOO | FE_INJURY)) {
        int n = ft.events & FE_CHEER ? 1 : ft.events & FE_BOO ? 4 : -1;     /* 93: cheer if the visitors lost, boo if home */
        /* PlayCrowdSample below 6 is the home team's rock cue (music): held until the penalties are called */
        if (n >= 0) { cue = n; cue_seen = 0; cue_time = 0; }
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

static const char *team95_abbrev(int t95);
static void make_lut_for(int k, const uint8_t *p);
static void make_lut(int k) { make_lut_for(k, who[k]); }
static void make_lut_for(int k, const uint8_t *p)
{
    uint32_t dac[256], pal[64];
    int home = P_W(p, P_SCNUM) < 6, t95 = home ? HomeTeam : VisTeam, t93;
    const uint8_t *remap = home ? byte_DC9D8 : byte_DC8D8;
    int v, sidx;
    if (t95 < 0 || t95 >= NTEAM95) t95 = 0;
    t93 = team93(t95);
    video_dac_rgb(dac);
    /* the default: the fighter's own 93 jersey (Boston's, kept to his 95 PC team colours, for a team 93 did not have);
     * with the 94 ROM (port/rom94.c), 94's colours of his team: every 95 PC team is there, the layout is 93's */
    f93_palette(&rom, t93 < 0 ? 0 : t93, home, pal);
    {
        uint32_t c94[16];
        int i;
        if (!rom94_team_colours(team95_abbrev(t95), home, c94)) {
            for (i = 0; i < 16; i++) pal[32 + i] = pal[48 + i] = c94[i];
            t93 = 0;                                /* (his jersey's colours: no 95 PC team colours kept) */
        }
    }
    f93_pc95_colours(pal);
    for (v = 1; v < 64; v++) {
        int team = t93 < 0 && v >= 32 && (v & 15) != 1 && (v & 15) != 6 && (v & 15) != 7 && (v & 15) != 14 && (v & 15) != 15;
        int c = v >= 48 ? v - 16 : v, set = fpal_set[t95][!home] ? fpal[t95][!home][c] : -1;
        int lo = team ? 0x90 : 0, hi = team ? 0xC0 : 0xC0, best = -1, bd = 1 << 30;
        for (sidx = lo; sidx < hi; sidx++) {
            int d = dist(dac[remap[sidx]], pal[v]);
            if (d < bd) { bd = d; best = sidx; }
        }
        if (set < 0) set = fpal[NTEAM95][0][c];
        lut[k][v] = (uint8_t)(set >= 0 ? set : best);
    }
}

/* 95 PC's teams in HOMEPALS.BIN order (HomeTeam / VisTeam), matched to 93's TeamList by their letters */
static const char *const teams95[NTEAM95] = {
    "bos", "buf", "cgy", "chi", "det", "edm", "hfd", "la", "min", "mtl", "nj", "nyi", "nyr", "ott",
    "phi", "pit", "que", "stl", "sj", "tb", "tor", "van", "wsh", "wpg", "ana", "fla", "asw", "ase"
};
static const char *team95_abbrev(int t95) { return t95 >= 0 && t95 < NTEAM95 ? teams95[t95] : ""; }

static int team93(int t95)
{
    int t;
    if (t95 < 0 || t95 >= NTEAM95) return -1;
    for (t = 0; t < F93_NTEAMS; t++) {
        const char *a = f93_team_abbrev(t), *b = teams95[t95];
        while (*a && *b && (*a | 32) == *b) a++, b++;
        if (!*a && !*b) return t;
    }
    return -1;
}

/* FIGHTPAL.TXT in the game folder (NHL9X Studio's Fight colours tab): a "[code home]" / "[code away]" section per
 * jersey, each with "v = s" lines: 93 colour v (line x 16 + colour, 1-47; line 3 follows line 2) drawn with 95 PC
 * sprite colour s (0-254). Lines before any section are for every jersey. The rest: the fighter's 93 jersey, nearest. */
static void load_fightpal(void)
{
    FILE *f = fopen("FIGHTPAL.TXT", "r");
    char line[128];
    int t, sd, v, n = 0, nj = 0;
    int16_t *cur;
    memset(fpal_set, 0, sizeof fpal_set);
    for (t = 0; t <= NTEAM95; t++) for (sd = 0; sd < 2; sd++) for (v = 0; v < 48; v++) fpal[t][sd][v] = -1;
    cur = fpal[NTEAM95][0];
    if (!f) f = fopen("fightpal.txt", "r");
    if (!f) return;
    while (fgets(line, sizeof line, f)) {
        int a, b;
        char code[16], side[16], *c = strpbrk(line, ";#");
        if (c) *c = 0;
        if (sscanf(line, " [ %15[a-zA-Z] %15[a-zA-Z] ]", code, side) == 2) {
            cur = NULL;
            for (c = code; *c; c++) *c = (char)(*c | 32);
            for (t = 0; t < NTEAM95; t++)
                if (!strcmp(code, teams95[t])) {
                    sd = (side[0] | 32) == 'a';
                    cur = fpal[t][sd];
                    fpal_set[t][sd] = 1;
                    nj++;
                }
            continue;
        }
        if (cur && sscanf(line, "%d = %d", &a, &b) == 2 && a >= 1 && a < 48 && b >= 0 && b < 255) { cur[a] = (int16_t)b; n++; }
    }
    fclose(f);
    fprintf(stderr, "Fights: FIGHTPAL.TXT, %d jerseys, %d colours\n", nj, n);
}

static uint8_t *build(int k, int n)
{
    f93_frame f;
    uint8_t *b, *o;
    int x, y, i;
    int half = n == PILE_L ? 1 : n == PILE_R ? 2 : 0;
    if (f93_decode(&rom, half ? F93_GLOVES : n, &f) || !f.pix) return NULL;
    f93_pc95_frame(&f);
    if (half)
        for (y = 0; y < f.h; y++)
            for (x = 0; x < f.w; x++)
                if ((x < PILE_SPLIT) != (half == 1)) f.pix[y * f.w + x] = 0;
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

/* 95 PC's check injury (SPA A0Bh) lies on the ice in frames 632-643, 93's (SPAinjury1) in 633-644: the same poses,
 * 93's with blood. Half the injuries (picked when he goes down) show 93's, in his jersey's colours. */
#define SPA_INJURY 0xA0B
static int inj_state[12], inj_saved[12], inj_drawing, inj_lut[2] = { -1, -1 };
static uint32_t inj_rng = 0x9E3779B9u;
static void bloody_injuries(void)
{
    int i;
    inj_drawing = 0;
    if (!have_rom || no_draw || !feel_fights()) return;
    for (i = 0; i < 12; i++) {
        uint8_t *p = PLAYER(i);
        int f = P_W(p, P_FRAME), side, k;
        if (P_W(p, P_SPA) != SPA_INJURY || (P_B(p, P_PFLAGS2) & 1)) { inj_state[i] = 0; continue; }
        if (!inj_state[i]) { inj_rng = inj_rng * 1664525u + 1013904223u; inj_state[i] = (inj_rng >> 16 & 1) ? 1 : 2; }
        if (inj_state[i] != 1 || f < 632 || f > 643) continue;
        side = P_W(p, P_SCNUM) >= 6;
        k = 2 + side;
        if (inj_lut[side] != (side ? VisTeam : HomeTeam)) {      /* the colours once per team */
            int n;
            for (n = 0; n < NFR; n++) { free(spr[k][n]); spr[k][n] = NULL; }
            make_lut_for(k, p);
            inj_lut[side] = side ? VisTeam : HomeTeam;
        }
        if (!spr[k][f + 1] && !(spr[k][f + 1] = build(k, f + 1))) continue;
        inj_saved[i] = f;
        P_W(p, P_FRAME) = (int16_t)fr_code(k, f + 1);
        inj_drawing |= 1 << i;
    }
}

/* after updateplayers: the fighters show their 93 frame */
void fight_after(void)
{
    int k;
    drawing = 0;
    for (k = 0; k < 2; k++) {
        int n = ft.f[k].frame;
        if (!ft.on && !post[k]) continue;
        if (!ft.on) {
            /* after the fight both stand still in their last pose (no skating, from the pad or the computer) until
             * he is sent off (the penalty box assignment), or 10 s have gone */
            uint8_t *p = who[k];
            int ass = ((const int8_t *)p)[0x1E + (P_W(p, P_ASSNUM) & 7)];
            if (ass == ASS_PENBOX || --post_timer < 0 || P_W(p, P_POSITION) < 0) {
                post[k] = 0;
                let_go(p);
                continue;
            }
            P_W(p, P_XVEL) = (int16_t)(P_W(p, P_XVEL) * 7 / 8);       /* glide to a stop */
            P_W(p, P_YVEL) = (int16_t)(P_W(p, P_YVEL) * 7 / 8);
        }
        if (!have_rom || no_draw || n <= 0 || n >= NFR) continue;
        if (!spr[k][n] && !(spr[k][n] = build(k, n))) continue;
        saved_frame[k] = P_W(who[k], P_FRAME);
        P_W(who[k], P_FRAME) = (int16_t)fr_code(k, n);
        if (ft.f[k].flip) P_B(who[k], P_ATTRIBUTE) |= 8;
        else P_B(who[k], P_ATTRIBUTE) &= (uint8_t)~8;
        drawing |= 1 << k;
    }
    bloody_injuries();
}

/* before updateplayers: their own frames back, so updateanim carries on as it was */
static void undraw(void)
{
    int k;
    for (k = 0; k < 2; k++)
        if (drawing & 1 << k) P_W(who[k], P_FRAME) = (int16_t)saved_frame[k];
    drawing = 0;
    for (k = 0; k < 12; k++)
        if (inj_drawing & 1 << k) P_W(PLAYER(k), P_FRAME) = (int16_t)inj_saved[k];
    inj_drawing = 0;
}

/* DrawFrameSprite's frame FR_93 + k x 400h + n: fighter k's 93 frame n. In a replay (sflags bit 7) a punch frame
 * coming up plays the punch, as the live fight did. */
void *pads4_mark_sprite(int code);            /* port/pads4.c: 94's stars and arrows, codes 7F00h up */

void *fight_sprite(int code)
{
    int k = (code - FR_93) >> 10 & 3, n = code & 0x3FF;
    if (code >= 0x7F00) return pads4_mark_sprite(code);
    if (code >= FR_RP && code < FR_RP_END) { k = (code - FR_RP) / 0x60; n = (code - FR_RP) % 0x60; if (n > 36) return NULL; n = fr_n(n); }
    if (!have_rom) return NULL;
    if (sflags & 0x80) {
        if (n != replay_frame[k]) {
            int c = n - F93_FIGHT;
            replay_frame[k] = n;
            if (c == 6 || c == 11 || c == 7 || c == 12) {
                if (!punch_on) { punch_init(&rom); punch_on = 1; }
                punch_play(c == 7 || c == 12);
            }
        }
    } else replay_frame[k] = 0;
    if (!spr[k][n] && !lut[k][1]) return NULL;
    if (!spr[k][n]) spr[k][n] = build(k, n);
    return spr[k][n];
}

/* ---- the thunks ---- */
/* DrawFrameSprite (Watcom: n eax, x edx, y ebx, flip ecx, colours on the stack, ret 4): FR_93 frames are ours, the
 * rest go on to the game's code after its first instruction (push 10h, moved here) */
__attribute__((naked)) static void drawframe_thunk(void)
{
    __asm__ volatile(
        "cmpw $0x7000, %ax\n\tjge 3f\n\tcmpw $0x480, %ax\n\tjl 1f\n\tcmpw $0x600, %ax\n\tjge 1f\n"
        "3:\n\t"
        "push %esi\n\tpush %edx\n\tpush %ebx\n\tpush %ecx\n\t"
        "movswl %ax, %eax\n\tpush %eax\n\tcall " SYM("fight_sprite") "\n\tadd $4, %esp\n\t"
        "pop %ecx\n\tpop %ebx\n\tpop %edx\n\t"
        "test %eax, %eax\n\tjz 2f\n\t"
        "mov %edx, %esi\n\tadd $0xC0, %esi\n\tmov $0x140, %edx\n\tsub %ebx, %edx\n\tmov %edx, %ebx\n\t"
        "push $1\n\tmov 0xA(%esp), %edx\n\tsar $16, %edx\n\tpush %edx\n\t"
        "movswl %cx, %ecx\n\tmovswl %bx, %ebx\n\tmovswl %si, %edx\n\t"
        "call " SYM("DrawSprite") "\n"
        "2:\n\tpop %esi\n\tret $4\n"
        "1:\n\tpush $0x10\n\tjmp *" SYM("fight_dfs_cont"));
}

/* changeplayer (eax player, edx controller): no change of player during a fight */
__attribute__((naked)) static void changeplayer_thunk(void)
{
    __asm__ volatile("cmpl $0, " SYM("fight_on_now") "\n\tje 1f\n\tret\n"
                     "1:\n\tpush $0x28\n\tjmp *" SYM("fight_cp_cont"));
}

/* DrawRinkOverlays (eax, edx: the view): the gloves first, so the players are drawn over them */
void fight_overlays(void)
{
    int code, x, y, side;
    int h;
    if (gmode2 & 1 || introskipped) gloves = 0;    /* gone before the fade back in, not a frame after */
    if (!gloves || !have_rom || no_draw) return;
    for (h = 0; h < 2; h++) {
        if (!pile_on[h]) continue;
        side = pile_side[h];
        code = fr_code(pile_k[h], h ? PILE_R : PILE_L);    /* each half in its fighter's colours */
        x = glove_x; y = glove_y;
        __asm__ volatile("push %4\n\tcall " SYM("DrawFrameSprite")
                         : "+a"(code), "+d"(x), "+b"(y) : "c"(0), "r"(side) : "memory", "cc");
    }
}

/* PostPenaltyEvent (eax team, edx player, ebx event type, ecx minutes, then the stack): the type may change */
__attribute__((naked)) static void postpen_thunk(void)
{
    __asm__ volatile("pushal\n\tpush %ebx\n\tpush %edx\n\tpush %eax\n\tcall " SYM("fight_pen_type") "\n\t"
                     "add $12, %esp\n\tmov %eax, 16(%esp)\n\tpopal\n\t"
                     "push $0x2C\n\tjmp *" SYM("fight_pp_cont"));
}

/* the event names and the announcer's words with the fight's three added: the game's tables are copied to longer
 * ones and the routines that index them are pointed at the copies (their 4-byte address in the code) */
static char *pen_names[NEV], *pen_speech[NEV];
static int retarget(char *fn, size_t n, const void *from, const void *to)
{
    size_t i;
    int hits = 0;
    uint32_t f = (uint32_t)(uintptr_t)from, t = (uint32_t)(uintptr_t)to;
    for (i = 0; i + 4 <= n; i++)
        if (!memcmp(fn + i, &f, 4)) { patch_bytes(fn + i, &t, 4); hits++; i += 3; }
    return hits;
}

static void install_pen_names(void)
{
    static const uint8_t push2c[5] = { 0x68, 0x2C, 0, 0, 0 };
    int i;
    if (memcmp(PostPenaltyEvent, push2c, 5)) return;
    for (i = 0; i < 18; i++) { pen_names[i] = penaltynames[i]; pen_speech[i] = off_CD354[i]; }
    pen_names[EV_FIGHTING] = "Fighting";
    pen_names[EV_FIGHTING_W] = "Fighting *";
    pen_names[EV_INSTIGATOR] = "Instigator";
    for (i = 18; i < NEV; i++) pen_speech[i] = off_CD354[EV_ROUGHING];   /* 95 PC has no word for these: "roughing" */
    if (retarget(BuildEventLines, 0x600, penaltynames, pen_names) < 1) return;
    if (retarget(PostPenaltyEvent, 0x400, off_CD354, pen_speech) < 1) {
        retarget(BuildEventLines, 0x600, pen_names, penaltynames);
        return;
    }
    retarget(GameSummaryScreen, 0x2000, penaltynames, pen_names);
    fight_pp_cont = PostPenaltyEvent + 5;
    patch_jmp(PostPenaltyEvent, (void *)postpen_thunk);
    ev_ok = 1;
}

/* where the referee stands to pick up half h: its middle, from the glove frame's origin (rink y is up) */
static void pile_spot(int h, int *x, int *y)
{
    *x = glove_x + (h ? 33 : -27);
    *y = glove_y - (h ? 4 : 1);
}

/* assrefgoalpa (eax: the referee), each frame after a call: with the penalties called (PenBuf empty) he goes to the
 * puck and picks it up. With sticks and gloves still on the ice he first skates to each half and picks it up with
 * the same move (SPA C03h, locked while it plays): the half goes with him. 1: done here, 0: the game's code. */
int fight_ref(uint8_t *p)
{
    int h, best = -1, bd = 0, x, y, dx, dy;
    if (!gloves || (gmode2 & 1) || introskipped) return 0;
    if (P_B(p, P_PFLAGS) & 0x22) return 0;      /* locked, or a new assignment: the game sets it up first */
    if (ovlseq != 2 && ovlseq != 0 && ovltimer >= 0 && ovltimer < 0x100) return 0;      /* a goal */
    if (PenBuf[0]) return 0;
    if (++ref_time > 900) { gloves = 0; return 0; }     /* 15 s: never stuck; they go at the faceoff anyway */
    for (h = 0; h < 2; h++) {
        if (!pile_on[h]) continue;
        pile_spot(h, &x, &y);
        dx = x - P_W(p, P_XPOS_HI); dy = y - P_W(p, P_YPOS_HI);
        if (best < 0 || dx * dx + dy * dy < bd) { best = h; bd = dx * dx + dy * dy; }
    }
    if (best < 0) { gloves = 0; return 0; }
    pile_spot(best, &x, &y);
    dx = x - P_W(p, P_XPOS_HI); dy = y - P_W(p, P_YPOS_HI);
    if (dx < -0xC || dx > 0xC || dy < -0xC || dy > 0xC) {
        int a = (int)(uintptr_t)p, d = 0;
        regd0 = (regd0 & ~0xFFFF) | (x & 0xFFFF);
        regd1 = (regd1 & ~0xFFFF) | (y & 0xFFFF);
        __asm__ volatile("call " SYM("SkateToSpot") : "+a"(a), "+d"(d) : : "ebx", "ecx", "memory", "cc");
        return 1;
    }
    {
        int a = dx, d = dy, s = 0xC03;
        __asm__ volatile("call " SYM("vtoa") : "+a"(a), "+d"(d) : : "ebx", "ecx", "memory", "cc");
        if ((a & 0xFFFF) < 8) P_W(p, P_FACEDIR) = (int16_t)a;
        P_W(p, P_XVEL) = 0; P_W(p, P_YVEL) = 0;
        a = (int)(uintptr_t)p;
        __asm__ volatile("call " SYM("SetSPA") : "+a"(a), "+d"(s) : : "ebx", "ecx", "memory", "cc");
    }
    P_B(p, P_PFLAGS) |= 0x20;                   /* locked while the move plays, as for the puck */
    pile_on[best] = 0;
    if (!pile_on[0] && !pile_on[1]) gloves = 0;
    return 1;
}

__attribute__((naked)) static void refgoalpa_thunk(void)
{
    __asm__ volatile("pushal\n\tpush %eax\n\tcall " SYM("fight_ref") "\n\tadd $4, %esp\n\t"
                     "test %eax, %eax\n\tpopal\n\tjz 1f\n\tret\n"
                     "1:\n\tpush $0x28\n\tjmp *" SYM("fight_rg_cont"));
}

__attribute__((naked)) static void rinkoverlays_thunk(void)
{
    __asm__ volatile("pushal\n\tcall " SYM("fight_overlays") "\n\tpopal\n\t"
                     "push $0x6C\n\tjmp *" SYM("fight_ro_cont"));
}

/* ClockTick: the clock stops for a fight (93 counted no time while the players fought). RunGameFrames has just added
 * 100 to hudhundaccum, which runs the scoreboard's clock: that is taken back too. */
__attribute__((naked)) static void clocktick_thunk(void)
{
    __asm__ volatile("cmpl $0, " SYM("fight_on_now") "\n\tje 1f\n\t"
                     "subl $100, " SYM("hudhundaccum") "\n\tret\n"
                     "1:\n\tpush $0x14\n\tjmp *" SYM("fight_ck_cont"));
}

/* DrawTextOverlay: the names box (top left of the view, 7Bh x 4Bh from 0Ch, 0Ch; the shootout's place is 0ACh to
 * the right) over a fighter moves to the top right (the Game page's row, 0) or is not drawn (1) */
__attribute__((naked, used)) void dto_orig(void)
{
    __asm__ volatile("push $0x60\n\tjmp *" SYM("fight_dto_cont"));
}

static int box_covers(int dx)
{
    int k, x0 = scrollx + 0xC - 4 + dx, x1 = scrollx + 0x87 + 4 + dx, y0 = scrolly + 0xC - 4, y1 = scrolly + 0x57 + 4;
    for (k = 0; k < 2; k++) {
        int x = P_W(who[k], P_XPOS_HI) + 0xC0, y = 0x140 - P_W(who[k], P_YPOS_HI);    /* DrawFrameSprite's place: his feet */
        if (x >= x0 - 14 && x <= x1 + 14 && y >= y0 && y <= y1 + 34) return 1;
    }
    return 0;
}

void fight_dto(void)
{
    int mode = 0;               /* 0 as it is, 1 at the top right, 2 not drawn */
    if (hold_lines && who[0] && who[1] && box_covers(0)) mode = feel_fight_box() == 0 && !box_covers(0xAC) ? 1 : 2;
    if (mode == 2) return;
    if (mode == 1) {
        short g = gsp;
        gsp = 4;
        __asm__ volatile("call " SYM("dto_orig") : : : "eax", "ecx", "edx", "memory", "cc");
        gsp = g;
        return;
    }
    __asm__ volatile("call " SYM("dto_orig") : : : "eax", "ecx", "edx", "memory", "cc");
}

__attribute__((naked)) static void dto_thunk(void)
{
    __asm__ volatile("pushal\n\tcall " SYM("fight_dto") "\n\tpopal\n\tret");
}

/* FallDown (eax hitter, edx the player who falls): count the knockdown, then return to the caller */
__attribute__((naked)) void fight_fall_back(void)
{
    __asm__ volatile("pushal\n\tcall " SYM("fight_fall_after") "\n\tpopal\n\tret");
}

__attribute__((naked)) static void fall_thunk(void)
{
    __asm__ volatile(
        "pushal\n\tpush %eax\n\tcall " SYM("fight_fall_before") "\n\tadd $4, %esp\n\tpopal\n\t"
        "pushl $" SYM("fight_fall_back") "\n\t"
        "pushl $0x14\n\t"
        "jmp *" SYM("fight_fd_cont"));
}

/* doinput (eax player, edx controller): fight_doinput first */
__attribute__((naked)) static void doinput_thunk(void)
{
    __asm__ volatile("pushal\n\tpush %eax\n\tcall " SYM("fight_doinput") "\n\tadd $4, %esp\n\ttest %eax, %eax\n\tpopal\n\t"
                     "jz 1f\n\tret\n1:\n\tpush $0x14\n\tjmp *" SYM("fight_di_cont"));
}

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
    load_fightpal();
    /* the frame hook first: a fight is never started that would not run */
    ok_frame = redirect_call(DoGameFrame, 0x40, updateplayers, (const void *)updateplayers_thunk);
    ok_check = ok_frame && redirect_call(checkcx, 0x1000, checkcheck, (const void *)checkcheck_thunk);
    if (!ok_check) fprintf(stderr, "Fights: the hook points are not the expected code, fights are off\n");
    {
        static const uint8_t push10[5] = { 0x68, 0x10, 0, 0, 0 }, push28[5] = { 0x68, 0x28, 0, 0, 0 },
                             push14[5] = { 0x68, 0x14, 0, 0, 0 };
        if (ok_check && !memcmp(DrawFrameSprite, push10, 5)) {
            fight_dfs_cont = DrawFrameSprite + 5;
            patch_jmp(DrawFrameSprite, (void *)drawframe_thunk);
        } else if (have_rom) {
            fprintf(stderr, "Fights: DrawFrameSprite is not the expected code, fighters keep 95 PC's sprites\n");
            no_draw = 1;
        }
        if (ok_check && !memcmp(changeplayer, push28, 5)) {
            fight_cp_cont = changeplayer + 5;
            patch_jmp(changeplayer, (void *)changeplayer_thunk);
        }
        static const uint8_t push6c[5] = { 0x68, 0x6C, 0, 0, 0 };
        if (ok_check && have_rom && !no_draw && !memcmp(DrawRinkOverlays, push6c, 5)) {
            fight_ro_cont = DrawRinkOverlays + 5;
            patch_jmp(DrawRinkOverlays, (void *)rinkoverlays_thunk);
        }
        if (ok_check) install_pen_names();
        if (ok_check && have_rom && !no_draw && !memcmp(assrefgoalpa, push28, 5)) {
            fight_rg_cont = assrefgoalpa + 5;
            patch_jmp(assrefgoalpa, (void *)refgoalpa_thunk);
        }
        static const uint8_t push60[5] = { 0x68, 0x60, 0, 0, 0 };
        if (ok_check && !memcmp(DrawTextOverlay, push60, 5)) {
            fight_dto_cont = DrawTextOverlay + 5;
            patch_jmp(DrawTextOverlay, (void *)dto_thunk);
        }
        if (ok_check && !memcmp(ClockTick, push14, 5)) {
            fight_ck_cont = ClockTick + 5;
            patch_jmp(ClockTick, (void *)clocktick_thunk);
        } else if (ok_check) fprintf(stderr, "Fights: ClockTick is not the expected code, the clock runs during fights\n");
        if (ok_check && !memcmp(doinput, push14, 5)) {
            fight_di_cont = doinput + 5;
            patch_jmp(doinput, (void *)doinput_thunk);
        } else if (ok_check) fprintf(stderr, "Fights: doinput is not the expected code, the computer plays both fighters\n");
        if (ok_check && !memcmp(FallDown, push14, 5)) {
            fight_fd_cont = FallDown + 5;
            patch_jmp(FallDown, (void *)fall_thunk);
        } else if (ok_check) fprintf(stderr, "Fights: FallDown is not the expected code, a check is counted on every hit\n");
    }
}
