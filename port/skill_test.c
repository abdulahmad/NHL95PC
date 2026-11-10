/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * 96 Genesis SkillLevelTbl mapped onto 95 PC's updateplayers step of 16 (port/skill.c).
 * sh port/skill_test.sh
 */
#include "skill.h"

#include <stdio.h>

static int fails;

static void eq(int got, int want, const char *what)
{
    if (got == want) return;
    fprintf(stderr, "FAIL %s: got %d want %d\n", what, got, want);
    fails++;
}

int main(void)
{
    eq(skill_gravity(SKILL_PRO, 0), 0x15, "pro AI gravity");
    eq(skill_gravity(SKILL_PRO, 1), 0x15, "pro human gravity");
    eq(skill_gravity(SKILL_ALLSTAR, 0), 0x15, "all-star AI gravity");
    eq(skill_gravity(SKILL_ALLSTAR, 1), 0x15, "all-star human gravity");
    eq(skill_gravity(SKILL_ROOKIE, 0), 0x14, "rookie AI gravity");
    eq(skill_gravity(SKILL_ROOKIE, 1), 0x16, "rookie human gravity");

    eq(skill_step(SKILL_PRO, 0), 16, "pro AI step");
    eq(skill_step(SKILL_PRO, 1), 16, "pro human step");
    eq(skill_step(SKILL_ALLSTAR, 0), 16, "all-star AI step");
    eq(skill_step(SKILL_ALLSTAR, 1), 16, "all-star human step");
    eq(skill_step(SKILL_ROOKIE, 0), 15, "rookie AI step");
    eq(skill_step(SKILL_ROOKIE, 1), 17, "rookie human step");

    if (fails) {
        fprintf(stderr, "%d failed\n", fails);
        return 1;
    }
    puts("skill_test ok");
    return 0;
}
