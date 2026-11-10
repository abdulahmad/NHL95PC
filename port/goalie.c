/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * Manual goalie on 95 PC (the Game page's Manual goalie row).
 *
 * On-off and pad from 96 PC (sequel of this DOS engine; 96 Genesis input96 / 94G C-port doinput
 * name the same buttons): B held ~15 frames takes that team's goalie (SCnum 5 / 0xB); a short B
 * is changeplayer; on the goalie, A+direction dives (SPAgdive), C a 94G save stance, d-pad moves.
 * Save, movement and animations from 94 Genesis (logic94 goalieacc / goaliesave / assgoaliectrl):
 * a human in his crease faces the puck and stops when idle; C uses 95 PC's dword_CCA5A (the same
 * save SPAs assgoalie already plays). 95 PC's SPAgready / SPAgskate / SPAgdive are those 94G
 * anims under 95 PC's SPA numbers. MATCH src stays.
 */
#include "goalie.h"

#include <stdint.h>
#include <stdio.h>
#include <string.h>

#ifndef GOALIE_TEST
#include "feel.h"
#include "host.h"
#endif

#ifdef _WIN32
#define SYM(s) "_" s
#else
#define SYM(s) s
#endif

#define BUT_B 0x10
#define BUT_C 0x20
#define BUT_A 0x40
#define BHOLD 0x0F              /* 96 Genesis bholdtimer; 94G C-port uses 0x11 */

#define P_W(p, o) (*(int16_t *)((p) + (o)))
#define P_B(p, o) (*(uint8_t *)((p) + (o)))
#define P_XHI 0x02
#define P_YHI 0x06
#define P_XVEL 0x0C
#define P_YVEL 0x0E
#define P_POSITION 0x1A
#define P_FACEDIR 0x36
#define P_NOPUCK 0x3E
#define P_PFLAGS 0x44
#define P_PFLAGS2 0x45
#define P_ATTR 0x55
#define P_SCNUM 0x6A
#define PFJOY 0x08
#define PFALOCK 0x20
#define PFGOAL 0x80
#define PF2AIP 0x02
#define SPAGDIVE 0x181
#define SPAGREADY 0x001
#define SPAGSKATE 0x1F1

int goalie_slot(int sc)
{
    return sc <= 5 ? 5 : 0xB;
}

int goalie_in_crease(int x, int y)
{
    if (x > 0x30 || x < -0x30) return 0;
    if (y > -0xC0) return y >= 0xC0 && y <= 0x106;
    return y >= -0x106;
}

int goalie_bhold(int manual, int on_goalie, int b_new, int b_held, int b_rel, uint8_t *timer)
{
    if (!manual) return GB_PASS;
    if (on_goalie) return GB_PASS;      /* B leaves the goalie through changeplayer */
    if (b_held && *timer) {
        (*timer)--;
        if (*timer == 0) return GB_TAKE;
        return GB_WAIT;
    }
    if (b_new) {
        *timer = BHOLD;
        return GB_WAIT;
    }
    if (b_rel) {
        uint8_t t = *timer;
        *timer = BHOLD;
        if (t) return GB_CHANGE;
        return GB_WAIT;
    }
    return GB_PASS;
}

#ifndef GOALIE_TEST

extern char doinput[], updateplayers[], goalieacc[], assgoalie[], changeplayer[];
extern short restorepl(void);
extern short vtoa(void);
extern void SetSPA(void);
extern void playeracc(void);
extern void stopna(void);
extern uint8_t SortCords[];
extern int16_t c1playernum[], c2playernum[];
extern int16_t *puckx, *pucky;
extern int puckz, puckvz;           /* addresses of the puck's z words (globals.h) */
extern signed char *puckc;
extern int32_t regd0, regd1, regd2, regd3;
extern int16_t crowdlevel;
extern short dword_CCA5A[];

void *goalie_gacc_cont;
void *goalie_agc_cont;
static uint8_t bhold[2];
static int ok_di, ok_pos, ok_gacc, ok_agc;

static int16_t call_vtoa(int dx, int dy)
{
    int16_t r;
    /* operands by name: "%2" would be dy (EDX), not the routine */
    __asm__ volatile("call *%[fn]" : "=a"(r), "+d"(dy) : "a"(dx), [fn] "r"(vtoa) : "ecx", "memory", "cc");
    return r;
}

static void call_ad(void *fn, void *a, int d)
{
    /* eax/edx are Watcom args and the callee overwrites them: "+a/+d", not an edx clobber
     * (GCC: "asm operand has impossible constraints" if "d"(d) is also in the clobber list). */
    __asm__ volatile("call *%[fn]"
                     : [a] "+a"(a), [d] "+d"(d)
                     : [fn] "r"(fn)
                     : "ecx", "memory", "cc");
}

static int16_t call_restore(int nw, int old)
{
    int16_t r;
    __asm__ volatile("call *%[fn]" : "=a"(r), "+d"(old) : "a"(nw), [fn] "r"(restorepl) : "ecx", "memory", "cc");
    return r;
}

static void face_step(uint8_t *p, int dir)
{
    int d, face = P_W(p, P_FACEDIR);
    d = (int16_t)(dir - face);
    if (!d) return;
    d = (((-d) & 4) >> 1) - 1;
    P_W(p, P_FACEDIR) = (int16_t)((face + d) & 7);
}

int goalie_take(uint8_t *p, int ctl)
{
    int gk, i = ctl ? 1 : 0;
    uint8_t *g;
    if (!p) return 0;
    gk = goalie_slot(P_W(p, P_SCNUM));
    g = SortCords + gk * 0x80;
    if (P_W(g, P_POSITION) != 0) return 0;
    if (P_B(g, P_PFLAGS) & PFJOY) return 0;
    if (i) {
        if (gk == c2playernum[0]) return 0;
        c2playernum[0] = call_restore(gk, c2playernum[0]);
    } else {
        if (gk == c1playernum[0]) return 0;
        c1playernum[0] = call_restore(gk, c1playernum[0]);
    }
    return 1;
}

void goalie_dive(uint8_t *p, int dir)
{
    P_W(p, P_FACEDIR) = (int16_t)(dir & 7);
    P_W(p, P_NOPUCK) = 8;
    call_ad(SetSPA, p, SPAGDIVE);
    P_B(p, P_PFLAGS2) |= PF2AIP;
    P_B(p, P_PFLAGS) |= PFALOCK;
    crowdlevel = (int16_t)(crowdlevel + 0x96);
}

void goalie_save(uint8_t *p)
{
    int dx = *puckx - P_W(p, P_XHI), dy = *pucky - P_W(p, P_YHI);
    int a = call_vtoa(dx, dy), i;
    P_W(p, P_FACEDIR) = (int16_t)(a & 7);
    i = 1;
    if (*(int16_t *)puckz > 8 || *(int16_t *)puckvz > 0x800) i = 7;  /* 94G high save */
    else i = 5;
    if (P_B(p, P_ATTR) & 8) i ^= 1;
    call_ad(SetSPA, p, dword_CCA5A[i]);
    P_B(p, P_PFLAGS2) |= PF2AIP;
    crowdlevel = (int16_t)(crowdlevel + 0x96);
}

/* 94G goalieacc for a pad-controlled goalie. Returns 1 if it ran (skip the 95 PC body). */
int goalie_acc(uint8_t *p, int dir)
{
    int x, y, d0 = dir & 0xF;
    if (!feel_manual_goalie() || !p || !(P_B(p, P_PFLAGS) & PFJOY)) return 0;
    x = P_W(p, P_XHI);
    y = P_W(p, P_YHI);
    if (*puckc != P_W(p, P_SCNUM) && goalie_in_crease(x, y)) {
        int px = *puckx - x, py = *pucky - y, face;
        if (px <= 0x10 && px >= -0x10 && py <= 0x10 && py >= -0x10) face = P_W(p, P_FACEDIR);
        else face = call_vtoa(px, py);
        face_step(p, face);
        if (P_B(p, P_PFLAGS2) & PF2AIP) return 1;
        call_ad(SetSPA, p, SPAGREADY);
        if (d0 == 8) call_ad(stopna, p, 0);
        else call_ad(playeracc, p, d0 > 7 ? 8 : d0);
        return 1;
    }
    if (d0 > 7) {
        if (d0 == 9 && (P_W(p, P_XVEL) | P_W(p, P_YVEL))) call_ad(stopna, p, 0);
        else if (!(P_B(p, P_PFLAGS2) & PF2AIP)) call_ad(SetSPA, p, SPAGREADY);
        return 1;
    }
    face_step(p, d0);
    call_ad(SetSPA, p, SPAGSKATE);
    call_ad(playeracc, p, P_W(p, P_FACEDIR));
    return 1;
}

void goalie_pad(uint8_t *p)
{
    int dir = (int16_t)regd0 & 0xF, nw = (int16_t)regd1, held = (int16_t)regd3;
    if (P_B(p, P_PFLAGS) & PFALOCK) return;
    if ((nw & BUT_A) && dir != 8) {
        goalie_dive(p, dir);
        return;
    }
    if (nw & BUT_C) {
        goalie_save(p);
        return;
    }
    if ((held & BUT_C) && (P_B(p, P_PFLAGS2) & 0x80)) return;   /* 96 PC: hold the save pose */
    goalie_acc(p, dir);
}

int goalie_pos0(uint8_t *p)
{
    if (!p || P_W(p, P_POSITION) != 0) return 0;
    if (feel_manual_goalie()) goalie_pad(p);
    return 1;
}

int goalie_skip_cpu(uint8_t *p)
{
    return feel_manual_goalie() && p && (P_B(p, P_PFLAGS) & PFJOY);
}

int goalie_before_doinput(uint8_t *p, int ctl)
{
    int i, on, b_new, b_held, b_rel, act;
    if (!feel_manual_goalie() || !p) return 0;
    i = ctl ? 1 : 0;
    on = P_W(p, P_POSITION) == 0;
    b_new = ((int16_t)regd1 & BUT_B) != 0;
    b_held = ((int16_t)regd3 & BUT_B) != 0;
    b_rel = ((int16_t)regd2 & BUT_B) != 0 && !b_held;
    act = goalie_bhold(1, on, b_new, b_held, b_rel, &bhold[i]);
    if (act == GB_TAKE) return goalie_take(p, ctl);
    if (act == GB_CHANGE) {
        call_ad(changeplayer, p, ctl);
        return 1;
    }
    if (act == GB_WAIT && b_new)
        *(int16_t *)&regd1 &= (int16_t)~BUT_B;  /* swallow B so doinput does not changeplayer */
    return 0;
}

__attribute__((naked)) static void di_thunk(void)
{
    __asm__ volatile(
        "pushal\n\tpush %edx\n\tpush %eax\n\tcall " SYM("goalie_before_doinput")
        "\n\tadd $8, %esp\n\ttest %eax, %eax\n\tpopal\n\t"
        "jnz 1f\n\tjmp " SYM("doinput") "\n"
        "1:\n\tret");
}

__attribute__((naked)) static void pos0_thunk(void)
{
    __asm__ volatile(
        "push %eax\n\tpush %ecx\n\tpush %edx\n\t"
        "push %ebx\n\tcall " SYM("goalie_pos0") "\n\tadd $4, %esp\n\t"
        "test %eax, %eax\n\t"           /* the jnz after the patched call: 1 = the goalie's return */
        "pop %edx\n\tpop %ecx\n\tpop %eax\n\t"
        "ret");
}

__attribute__((naked)) static void gacc_thunk(void)
{
    __asm__ volatile(
        "pushal\n\tpush %edx\n\tpush %eax\n\tcall " SYM("goalie_acc")
        "\n\tadd $8, %esp\n\ttest %eax, %eax\n\tpopal\n\t"
        "jnz 1f\n\tpush $0x0C\n\tjmp *" SYM("goalie_gacc_cont") "\n"
        "1:\n\tret");
}

__attribute__((naked)) static void agc_thunk(void)
{
    __asm__ volatile(
        "pushal\n\tpush %eax\n\tcall " SYM("goalie_skip_cpu")
        "\n\tadd $4, %esp\n\ttest %eax, %eax\n\tpopal\n\t"
        "jnz 1f\n\tpush $0x24\n\tjmp *" SYM("goalie_agc_cont") "\n"
        "1:\n\tret");
}

static int patch_pos0(void)
{
    uint8_t *base = (uint8_t *)doinput;
    size_t i, n = 1070;
    int found = 0;
    for (i = 0; i + 11 <= n; i++) {
        uint8_t *p = base + i;
        int32_t rel, jrel;
        uint8_t *tgt, code[11];
        if (p[0] != 0x66 || p[1] != 0x83 || p[2] != 0x7B || p[3] != 0x1A || p[4] != 0x00) continue;
        if (p[5] != 0x0F || p[6] != 0x84) continue;
        memcpy(&jrel, p + 7, 4);
        tgt = p + 11 + jrel;
        if (tgt < base || tgt > base + n) continue;
        rel = (int32_t)((uintptr_t)pos0_thunk - ((uintptr_t)p + 5));
        code[0] = 0xE8;
        memcpy(code + 1, &rel, 4);
        code[5] = 0x0F;
        code[6] = 0x85;                 /* jnz: trampoline 1 = skip the rest of doinput */
        memcpy(code + 7, p + 7, 4);
        patch_bytes(p, code, 11);
        found++;
    }
    return found >= 2;
}

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

void goalie_install(void)
{
    static const uint8_t push0c[5] = { 0x68, 0x0C, 0, 0, 0 };
    static const uint8_t push24[5] = { 0x68, 0x24, 0, 0, 0 };
    ok_di = redirect_call(updateplayers, 1760, doinput, (const void *)di_thunk);
    if (!ok_di) fprintf(stderr, "Manual goalie: updateplayers' doinput is not the expected call, B does not take the goalie\n");
    ok_pos = patch_pos0();
    if (!ok_pos) fprintf(stderr, "Manual goalie: doinput's goalie returns are not the expected code, the pad does not play him\n");
    ok_gacc = !memcmp(goalieacc, push0c, 5);
    if (ok_gacc) {
        goalie_gacc_cont = goalieacc + 5;
        patch_jmp(goalieacc, (void *)gacc_thunk);
    } else {
        fprintf(stderr, "Manual goalie: goalieacc is not the expected code, movement stays 95 PC's\n");
    }
    ok_agc = !memcmp(assgoalie, push24, 5);
    if (ok_agc) {
        goalie_agc_cont = assgoalie + 5;
        patch_jmp(assgoalie, (void *)agc_thunk);
    } else {
        fprintf(stderr, "Manual goalie: assgoalie is not the expected code, the computer still plays a pad goalie\n");
    }
}

#endif /* !GOALIE_TEST */
