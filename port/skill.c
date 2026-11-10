/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * NHL 96 Genesis skill level, hooked into 95 PC (the Game page's Skill level row).
 *
 * 96 PC (HOCKEY.EXE listing, 2026-11-10): dword_17C9A0 is the settings blob. User Setup
 * (sub_29B9F) has 10 rows on byte 1: four bit toggles, Line Changes Off/On/Auto (bits 4-5),
 * two more toggles, one bit of byte 2, Period length (bits 9-10 of the dword at +1), one more
 * toggle. No Pro / All-Star / Rookie row. The EXE has no "skill" / "Rookie" / "Difficulty"
 * strings and no SkillLevelTbl ($15, $15, $14). 96 PC does not implement this option.
 *
 * 96 Genesis (docs/difficulty_skill.md, options96 SetSkillLevel, control96 updateplayers):
 * OptSkill 0 pro / 1 all-star / 2 rookie. SRAM default all-star. Physics only:
 *   - SkillLevelTbl NTSC $15, $15, $14 → skillspeed (PAL $1D, $1D, $1C unused here: 95 PC is 60 Hz)
 *   - updateplayers: position += vel * skillspeed; Z gravity uses the same word
 *   - Rookie + pfjoycon (pflags bit 3): addq #2 before that multiply
 *   - puckvzadj (94G/96G one-timer top-shelf): 95 PC has no puckvzadj, not hooked
 *   - GetRoleAss returns 0 on rookie: still dc.b on 96G, absent from 96 PC and 95 PC, not hooked
 *
 * 95 PC updateplayers (hockey.asm 5C690) writes 16 into regd4 and multiplies velocity by that.
 * Pro/all-star keep 16. Rookie AI 15, rookie human 17: the 96G 20/21/22 table on a 16 base.
 */
#include "skill.h"

#include <stdint.h>
#include <stdio.h>
#include <string.h>

#ifndef SKILL_TEST
#include "feel.h"
#include "host.h"
#endif

#ifdef _WIN32
#define SYM(s) "_" s
#else
#define SYM(s) s
#endif

#define P_PFLAGS 0x44
#define PFJOY 0x08

int skill_gravity(int skill, int human)
{
    /* 96G SkillLevelTbl: dc.w $15, $15, $14. Rookie + joystick: addq #2. */
    int g = skill == SKILL_ROOKIE ? 0x14 : 0x15;
    if (skill == SKILL_ROOKIE && human) g += 2;
    return g;
}

int skill_step(int skill, int human)
{
    int g = skill_gravity(skill, human);
    if (g <= 0x14) return 15;       /* rookie AI: 96G 20 vs 21 */
    if (g >= 0x16) return 17;       /* rookie human: 96G 22 vs 21 */
    return 16;                      /* pro / all-star: 95 PC's own 16 */
}

#ifndef SKILL_TEST

extern char updateplayers[];
extern int32_t regd4;

#define STEP_OFF (0x5C690 - 0x5C40F)    /* mov word [regd4], 10h */

static int ok_step;

void skill_apply_regd4(uint8_t *p)
{
    int human = p && (p[P_PFLAGS] & PFJOY);
    *(int16_t *)&regd4 = (int16_t)skill_step(feel_skill(), human);
}

__attribute__((naked)) static void regd4_thunk(void)
{
    __asm__ volatile(
        "pushal\n\t"
        "push %esi\n\t"
        "call " SYM("skill_apply_regd4") "\n\t"
        "add $4, %esp\n\t"
        "popal\n\t"
        "ret");
}

static int check_step(void)
{
    const uint8_t *p = (const uint8_t *)updateplayers + STEP_OFF;
    return p[0] == 0x66 && p[1] == 0xC7 && p[2] == 0x05 && p[7] == 0x10 && p[8] == 0;
}

void skill_install(void)
{
    uint8_t *p = (uint8_t *)updateplayers + STEP_OFF;
    uint8_t code[9];
    int32_t rel;

    ok_step = check_step();
    if (!ok_step) {
        fprintf(stderr, "Skill level: updateplayers is not the expected code, skating stays 95 PC's 16\n");
        return;
    }
    rel = (int32_t)((uintptr_t)regd4_thunk - ((uintptr_t)p + 5));
    code[0] = 0xE8;
    memcpy(code + 1, &rel, 4);
    memset(code + 5, 0x90, 4);
    patch_bytes(p, code, sizeof code);
}

#endif /* !SKILL_TEST */
