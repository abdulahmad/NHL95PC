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
extern signed char PenBuf[], PenBuf_pl[], penmintab[];
extern short ovltimer, ovlseq, refsignal;
extern unsigned char textline1[0x3C], textline2[0x3C], textline3[0x3C], hmroster[], hmrosterjersey[];
extern char DrawFrameSprite[], changeplayer[];
extern uint32_t gameopts;
extern int16_t gsp, xc1, yc1;
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
#define P_PNUM 0x47
#define P_SCNUM 0x6A
#define PLAYER(i) (SortCords + (i) * 0x80)

#define PEN_ROUGHING 9                  /* Roughing: its minutes are made 5 while a fight's is waiting (93's Fighting) */
#define ASS_NOTHING 0                   /* asstab 0: rtss */
#define ASS_PUCKNOTHING 26

static fight ft;
static uint8_t *who[2];
static int checks[12], chkcnt, last_gsp = -1;
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
static uint8_t *spr[2][NFR];            /* built frames per fighter, 93 frame number */
static uint8_t lut[2][64];
#define FR_93 0x7000
static int saved_frame[2], drawing, replay_frame[2], post[2], post_timer;
void *fight_dfs_cont, *fight_cp_cont;
int fight_on_now;
static uint8_t *build(int k, int n);
static int watcher[12], nwatch, pen_wait, hold_lines;
static void free_sprites(void);
static void show_names(void);
static void make_lut(int k);
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
    fight_on_now = 1;
    if (have_rom) {
        free_sprites();
        make_lut(0);
        make_lut(1);
    }
    xc1 = (int16_t)ft.xc1;
    yc1 = (int16_t)ft.yc1;
    sflags |= 0x40;                     /* 93's sfslock: the camera stays on xc1 / yc1 */
    for (k = 0; k < 2; k++) {
        P_B(who[k], P_PFLAGS2) |= 1 | 4;        /* fighting, unavailable */
        ass_insert(who[k], ASS_NOTHING);
    }
    /* everyone else watches (93's afwatch): no assignment and, with pflags2 bit 0, no skating from the joystick */
    nwatch = 0;
    for (k = 0; k < 12; k++) {
        uint8_t *p = PLAYER(k);
        if (p == a || p == b || P_W(p, P_POSITION) <= 0 || (P_B(p, P_PFLAGS2) & 1)) continue;
        P_B(p, P_PFLAGS2) |= 1;
        ass_insert(p, ASS_NOTHING);
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
static void release(void)
{
    int k;
    for (k = 0; k < 2; k++) {
        P_B(who[k], P_PFLAGS2) &= (uint8_t)~(1 | 4);
        ass_done(who[k]);
    }
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

static void end_fight(void)
{
    int k;
    release();
    penmintab[PEN_ROUGHING] = 5;        /* 93's Fighting: 5 minutes, put back once both are called */
    pen_wait = 1;
    for (k = 0; k < 2; k++) add_penalty2(who[k], PEN_ROUGHING);
    post[0] = post[1] = 1;
    post_timer = 1200;            /* 10 s (counted once per fighter a frame) */
    /* the whistle now (93 stopped play for the fight's penalties at once), not when the puck is next touched:
     * the first of the fight's penalties in PenBuf stops play (Stop4Pen, as checkfornewpen would) */
    if (!(gmode & 1)) {
        int i;
        for (i = 0; i < 0x20 && PenBuf[i * 2]; i++) {
            int pl = PenBuf_pl[i * 2] & 0x7F;
            if (PenBuf[i * 2] == PEN_ROUGHING && (PLAYER(pl) == who[0] || PLAYER(pl) == who[1])) {
                int a = i;
                refsignal = 0x28;
                __asm__ volatile("call " SYM("Stop4Pen") : "+a"(a) : : "ecx", "edx", "memory", "cc");
                break;
            }
        }
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

/* 93's banner with the two names, in 95 PC's scoreboard box: "#12 Neely / vs. / #7 Probert" */
static void name_line(unsigned char *out, const uint8_t *p)
{
    int side = (P_B(p, P_PFLAGS) & 0x40) != 0, pn = P_B(p, P_PNUM) & 0x7F;
    const unsigned char *r = hmroster + side * 0x444 + pn * 0x27;
    snprintf((char *)out, 0x3C, "#%d %.20s", hmrosterjersey[side * 0x444 + pn * 0x27], (const char *)r + 0x17);
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

void fight_frame(void)
{
    int k;
    undraw();
    check_pen_wait();
    /* the scoreboard box only runs while play is stopped (chkprogress): during the fight it is moved on here */
    if (hold_lines && !(gmode & 1) && ovltimer >= 0 && ovltimer < 0x100) ovltimer++;
    if (!ft.on) return;
    if (gmode & 1) {                    /* play stopped some other way (a goal, the period): no penalty */
        release();
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

/* after updateplayers: the fighters show their 93 frame */
void fight_after(void)
{
    int k;
    drawing = 0;
    if (!have_rom || no_draw) return;
    for (k = 0; k < 2; k++) {
        int n = ft.f[k].frame;
        if (!ft.on && !post[k]) continue;
        if (!ft.on) {
            /* after the fight he keeps his last pose until he is sent off (the penalty box assignment, 0Ch), skates
             * away, or 10 s have gone */
            const uint8_t *p = who[k];
            int ass = ((const int8_t *)p)[0x1E + (P_W(p, P_ASSNUM) & 7)], vx = P_W(p, P_XVEL), vy = P_W(p, P_YVEL);
            if (ass == 0xC || vx > 0x300 || vx < -0x300 || vy > 0x300 || vy < -0x300 || --post_timer < 0 || P_W(p, P_POSITION) < 0) {
                post[k] = 0;
                continue;
            }
        }
        if (n <= 0 || n >= NFR) continue;
        if (!spr[k][n] && !(spr[k][n] = build(k, n))) continue;
        saved_frame[k] = P_W(who[k], P_FRAME);
        P_W(who[k], P_FRAME) = (int16_t)(FR_93 + k * 0x400 + n);
        if (ft.f[k].flip) P_B(who[k], P_ATTRIBUTE) |= 8;
        else P_B(who[k], P_ATTRIBUTE) &= (uint8_t)~8;
        drawing |= 1 << k;
    }
}

/* before updateplayers: their own frames back, so updateanim carries on as it was */
static void undraw(void)
{
    int k;
    for (k = 0; k < 2; k++)
        if (drawing & 1 << k) P_W(who[k], P_FRAME) = (int16_t)saved_frame[k];
    drawing = 0;
}

/* DrawFrameSprite's frame FR_93 + k x 400h + n: fighter k's 93 frame n. In a replay (sflags bit 7) a punch frame
 * coming up plays the punch, as the live fight did. */
void *fight_sprite(int code)
{
    int k = (code - FR_93) >> 10 & 1, n = code & 0x3FF;
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
        "cmpw $0x7000, %ax\n\tjl 1f\n\tcmpw $0x7800, %ax\n\tjge 1f\n\t"
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
    {
        static const uint8_t push10[5] = { 0x68, 0x10, 0, 0, 0 }, push28[5] = { 0x68, 0x28, 0, 0, 0 };
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
    }
}
