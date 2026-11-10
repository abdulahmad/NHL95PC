/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * NHL 96 PC main-menu LEVEL, hooked into 95 PC (the Game page's Skill level row).
 *
 * 96 PC GAME SETUP (sub_66589, MAINMENU.FSH resource 4Ch). Widget 1 is LEVEL at (1BCh, 99h),
 * FSH bb01/bb02 (Rookie), bb10/bb11 (Pro), bb19/bb20 (All-Star). Click cycles
 * dword_17C9A8 bits 7-8: 00 -> 80h -> 100h -> 00. Cold start ors 80h (Pro). Screenshot LEVEL: PRO.
 * Not User Setup, not 96 Genesis SkillLevelTbl ($15,$15,$14). The EXE does not contain that table.
 *
 * Engine (every player, no human/CPU test on the playeracc path):
 *   sub_4C860 is 96 PC playeracc: skill-scales (legstr+30h) before dirtab/64 (3/4 Rookie+Pro, 9/8 All-Star)
 *     and the MaxSpeed cap after legspd*energy>>12 (same factors). Tiny *63/64 on another vel path (sub_4DD1B)
 *     is not hooked (Rookie and Pro share it; it is 96 PC's 3/4 family).
 *   checkcheck (sub_3EC30): hit base 64h All-Star / 96h Pro and Rookie, then the same
 *     ((base - p.weight + q.weight)>>1) - q.impact as 95 PC.
 *   sub_43605: AI range 3 Rookie, 4 Pro/All-Star — 95 PC has no matching immediate to patch.
 *
 * Live: Pro is 1× the current feel. feel_playeracc already built 94G or 95 PC stock; skill_scale_action
 * leaves that for Pro and Rookie and takes All-Star at 3/2 (96 PC 9/8 over Pro's 3/4). Do not apply
 * 96 PC's 3/4 to Pro. Hits: 95 PC feel uses 150 / 100; 94G feel uses CCStart's 0x78 as Pro, All-Star
 * 100/150 of that. Rookie skating equals Pro; the only 96 PC Rookie-only extra is AI range (unhooked).
 */
#include "skill.h"

#ifndef SKILL_TEST
#include "feel.h"
#include "host.h"
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#endif

#ifdef _WIN32
#define SYM(s) "_" s
#else
#define SYM(s) s
#endif

int skill_scale_96(int skill, int v)
{
    if (skill == SKILL_ALLSTAR) return v + (v >> 3);    /* 96 PC cdq / sar 3 / add */
    return v - (v >> 2);                                /* Rookie and Pro: sar 2 / sub */
}

int skill_scale_action(int skill, int v)
{
    if (skill == SKILL_ALLSTAR) return v + (v >> 1);    /* 1.5× the feel-mode term */
    return v;                                           /* Pro and Rookie: 1× */
}

int skill_hit_pro_base(int feel94)
{
    return feel94 ? 0x78 : 0x96;                        /* 94G CCStart d0; 96 PC Pro 150 */
}

int skill_hit_base_on(int skill, int pro_base)
{
    if (skill == SKILL_ALLSTAR) return pro_base * 100 / 150;
    return pro_base;
}

int skill_hit_base(int skill)
{
    return skill_hit_base_on(skill, 0x96);
}

int skill_ai_near(int skill)
{
    return skill == SKILL_ROOKIE ? 3 : 4;
}

#ifndef SKILL_TEST

extern char checkcheck[];

#define HIT_OFF 0x237               /* 53A63 - 5382C: test [esi+pflags], 8 */

int skill_scale_now(int v)
{
    return skill_scale_action(feel_skill(), v);
}

int skill_hit_base_now(void)
{
    const feel_profile *f = feel_now();
    int feel94 = f && (f->speed != FEEL_95PC || f->accel != FEEL_95PC);
    return skill_hit_base_on(feel_skill(), skill_hit_pro_base(feel94));
}

__attribute__((naked)) static void hit_thunk(void)
{
    __asm__ volatile(
        "push %eax\n\t"
        "push %ecx\n\t"
        "push %edx\n\t"
        "call " SYM("skill_hit_base_now") "\n\t"
        "mov %eax, %ebx\n\t"
        "pop %edx\n\t"
        "pop %ecx\n\t"
        "pop %eax\n\t"
        "ret");
}

static int check_hit(void)
{
    static const uint8_t want[] = { 0xF6, 0x46, 0x44, 0x08, 0x74, 0x07, 0xBB, 0xA0, 0x00, 0x00, 0x00 };
    return memcmp((uint8_t *)checkcheck + HIT_OFF, want, sizeof want) == 0;
}

void skill_install(void)
{
    uint8_t *p = (uint8_t *)checkcheck + HIT_OFF;
    uint8_t code[7];
    int32_t rel;

    if (!check_hit()) {
        fprintf(stderr, "Skill level: checkcheck is not the expected code, hits stay 95 PC's 160/100\n");
        return;
    }
    rel = (int32_t)((uintptr_t)hit_thunk - ((uintptr_t)p + 5));
    code[0] = 0xE8;
    memcpy(code + 1, &rel, 4);
    code[5] = 0xEB;
    code[6] = 0x2E;                 /* jmp to 53A98 (.28), 0x26C from checkcheck */
    patch_bytes(p, code, sizeof code);
}

#endif /* !SKILL_TEST */
