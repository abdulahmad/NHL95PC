/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * NHL 96 PC auto line changes, hooked into 95 PC (the Game page's Auto line changes row).
 *
 * 96 PC (HOCKEY.EXE listing, 2026-11-10): gameopts byte 1 bits 4-5 are Off 00 / On 10h / Auto 20h.
 *   - Faceoff CompLine (sub_46A9D): Auto always; On only when that team has no human controller.
 *   - Computer chk4lc (sub_40189, from asspuckc): On or Auto (test 30h). 95 PC already does this.
 *   - Human chk4lc (sub_402AD, from the joystick puck-carrier path after checkob): Auto only, and
 *     pflags bit 3 (joystick). If it takes, that path returns.
 *   - SetLCmode / the faceoff line-change box: Auto does not open it (96 Genesis sflags7 bit 4; 96 PC
 *     only starts the box when the bits are 10h). F1-F8 still go through lcselect.
 *
 * 95 PC keeps Line Changes On/Off in the DOS settings (gameopts bit 2). Auto is the extra 96 PC state:
 * CompLine at faceoff for human teams, chk4lc for a joystick puck carrier, no line-change box.
 */
#include "lines.h"

#include <stdint.h>
#include <stdio.h>
#include <string.h>

#ifndef LINES_TEST
#include "feel.h"
#include "host.h"
#endif

#ifdef _WIN32
#define SYM(s) "_" s
#else
#define SYM(s) s
#endif

int lines_team_gets_compline(int auto_on, int team, int cont1, int cont2)
{
    if (auto_on) return 1;
    return team != cont1 && team != cont2;
}

#ifndef LINES_TEST

extern char SetLCmode[], puckfaceoff[], doinput[], checkob[];
extern short chk4lc(void);
extern int16_t cont1team, cont2team;
extern int32_t regd0;
extern uint32_t gameopts;

#define P_PFLAGS 0x44
#define PFJOY 0x08

void *lines_slc_cont;
static int ok_slc, ok_face, ok_checkob;

int lines_faceoff_computer(void)
{
    return lines_team_gets_compline(feel_auto_lines(), (int16_t)regd0, cont1team, cont2team);
}

int lines_lc_on(void)
{
    return feel_auto_lines() || (gameopts & 4);
}

static short call_chk4lc(void *p)
{
    short r;
    __asm__ volatile("call *%1" : "=a"(r) : "r"(chk4lc), "a"(p) : "ecx", "edx", "memory", "cc");
    return r;
}

int lines_after_checkob(uint8_t *p)
{
    if (!feel_auto_lines() || !p) return 0;
    if (!(p[P_PFLAGS] & PFJOY)) return 0;
    return call_chk4lc(p) != 0;
}

__attribute__((naked)) static void slc_thunk(void)
{
    __asm__ volatile(
        "pushal\n\tcall " SYM("feel_auto_lines") "\n\ttest %eax, %eax\n\tpopal\n\t"
        "jnz 1f\n\tpush $0x0C\n\tjmp *" SYM("lines_slc_cont") "\n"
        "1:\n\tret");
}

__attribute__((naked)) static void face_ok_thunk(void)
{
    __asm__ volatile(
        "push %eax\n\tpush %ecx\n\tpush %edx\n\t"
        "call " SYM("lines_faceoff_computer") "\n\t"
        "test %eax, %eax\n\t"           /* ZF: the patched site's jz; EAX (the team in AX) is kept */
        "pop %edx\n\tpop %ecx\n\tpop %eax\n\t"
        "ret");
}

__attribute__((naked)) static void lc_on_thunk(void)
{
    __asm__ volatile(
        "push %eax\n\tpush %ecx\n\tpush %edx\n\t"
        "call " SYM("lines_lc_on") "\n\t"
        "test %eax, %eax\n\t"           /* ZF: the patched site's jz; EAX (the team in AX) is kept */
        "pop %edx\n\tpop %ecx\n\tpop %eax\n\t"
        "ret");
}

__attribute__((naked)) static void checkob_thunk(void)
{
    __asm__ volatile(
        "call " SYM("checkob") "\n\t"
        "pushal\n\tpush %ebx\n\tcall " SYM("lines_after_checkob") "\n\tadd $4, %esp\n\t"
        "test %eax, %eax\n\tpopal\n\t"
        "jz 1f\n\t"
        "add $4, %esp\n\t"
        "pop %edi\n\tpop %esi\n\tpop %ecx\n\tpop %ebx\n\t"
        "ret\n"
        "1:\n\tret");
}

/* cmp ax, [cont1team] / je  / cmp ax, [cont2team] / je  — both je go to the same skip */
static int patch_faceoff_skips(int apply)
{
    uint8_t *base = (uint8_t *)puckfaceoff;
    size_t i, n = 1274;
    uint32_t a1 = (uint32_t)(uintptr_t)&cont1team, a2 = (uint32_t)(uintptr_t)&cont2team;
    int found = 0;
    for (i = 0; i + 18 <= n; i++) {
        uint8_t *p = base + i;
        uint32_t u1, u2;
        int8_t r1, r2;
        uint8_t *t1, *t2, *skip;
        int32_t rel;
        uint8_t code[18];
        int jzrel;
        if (p[0] != 0x66 || p[1] != 0x3B || p[2] != 0x05) continue;
        memcpy(&u1, p + 3, 4);
        if (u1 != a1) continue;
        if (p[7] != 0x74) continue;
        r1 = (int8_t)p[8];
        if (p[9] != 0x66 || p[10] != 0x3B || p[11] != 0x05) continue;
        memcpy(&u2, p + 12, 4);
        if (u2 != a2) continue;
        if (p[16] != 0x74) continue;
        r2 = (int8_t)p[17];
        t1 = p + 9 + r1;
        t2 = p + 18 + r2;
        if (t1 != t2) continue;
        skip = t1;
        rel = (int32_t)((uintptr_t)face_ok_thunk - ((uintptr_t)p + 5));
        memset(code, 0x90, sizeof code);
        code[0] = 0xE8;
        memcpy(code + 1, &rel, 4);
        jzrel = (int)(skip - (p + 9));
        if (jzrel != (int)r1) continue;
        code[7] = 0x74;
        code[8] = (uint8_t)r1;
        if (apply) patch_bytes(p, code, sizeof code);
        found++;
    }
    return found == 2;
}

/* test byte [gameopts], 4 / je skip, immediately before the CompLine controller tests (one site has mov ax, [regd0] in between) */
static int patch_faceoff_lc_on(int apply)
{
    uint8_t *base = (uint8_t *)puckfaceoff;
    size_t i, n = 1274;
    uint32_t ga = (uint32_t)(uintptr_t)&gameopts, a1 = (uint32_t)(uintptr_t)&cont1team;
    int found = 0;
    for (i = 0; i + 9 <= n; i++) {
        uint8_t *p = base + i, *q;
        uint32_t u;
        int32_t rel;
        uint8_t code[9];
        if (p[0] != 0xF6 || p[1] != 0x05 || p[6] != 0x04 || p[7] != 0x74) continue;
        memcpy(&u, p + 2, 4);
        if (u != ga) continue;
        q = p + 9;
        if (q[0] == 0x66 && q[1] == 0x8B && q[2] == 0x05) q += 7;      /* mov ax, [regd0] */
        else if (q[0] == 0x66 && q[1] == 0xA1) q += 6;                 /* the same, moffs form */
        if (q[0] != 0x66 || q[1] != 0x3B || q[2] != 0x05) continue;
        memcpy(&u, q + 3, 4);
        if (u != a1) continue;
        rel = (int32_t)((uintptr_t)lc_on_thunk - ((uintptr_t)p + 5));
        memset(code, 0x90, sizeof code);
        code[0] = 0xE8;
        memcpy(code + 1, &rel, 4);
        code[7] = 0x74;
        code[8] = p[8];
        if (apply) patch_bytes(p, code, sizeof code);
        found++;
    }
    return found == 2;
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

void lines_install(void)
{
    static const uint8_t push0c[5] = { 0x68, 0x0C, 0, 0, 0 };
    ok_slc = !memcmp(SetLCmode, push0c, 5);
    if (ok_slc) {
        lines_slc_cont = SetLCmode + 5;
        patch_jmp(SetLCmode, (void *)slc_thunk);
    } else {
        fprintf(stderr, "Auto line changes: SetLCmode is not the expected code, the line-change box still opens\n");
    }
    ok_face = patch_faceoff_lc_on(0) && patch_faceoff_skips(0);        /* both sites of both kinds, or nothing */
    if (ok_face) { patch_faceoff_lc_on(1); patch_faceoff_skips(1); }
    if (!ok_face) fprintf(stderr, "Auto line changes: puckfaceoff is not the expected code, faceoff CompLine stays computer-only\n");
    ok_checkob = redirect_call(doinput, 1070, checkob, (const void *)checkob_thunk);
    if (!ok_checkob) fprintf(stderr, "Auto line changes: doinput's checkob is not the expected call, on-the-fly changes stay computer-only\n");
}

#endif /* !LINES_TEST */
