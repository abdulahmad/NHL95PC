/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * 96 PC main-menu LEVEL helpers (port/skill.c).
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
    eq(skill_scale_96(SKILL_ROOKIE, 48), 36, "96 PC Rookie (legstr+30h) 3/4");
    eq(skill_scale_96(SKILL_PRO, 48), 36, "96 PC Pro (legstr+30h) 3/4");
    eq(skill_scale_96(SKILL_ALLSTAR, 48), 54, "96 PC All-Star (legstr+30h) 9/8");
    eq(skill_scale_96(SKILL_ROOKIE, 100), 75, "96 PC Rookie 100");
    eq(skill_scale_96(SKILL_PRO, 100), 75, "96 PC Pro 100");
    eq(skill_scale_96(SKILL_ALLSTAR, 100), 112, "96 PC All-Star 100");

    eq(skill_scale_action(SKILL_ROOKIE, 48), 48, "95 PC Rookie vs Pro identity");
    eq(skill_scale_action(SKILL_PRO, 48), 48, "95 PC Pro identity (this game's playeracc)");
    eq(skill_scale_action(SKILL_ALLSTAR, 48), 72, "95 PC All-Star 3/2 of Pro");
    eq(skill_scale_action(SKILL_ALLSTAR, 100), 150, "95 PC All-Star 100");

    eq(skill_hit_base(SKILL_ROOKIE), 0x96, "Rookie hit base 150");
    eq(skill_hit_base(SKILL_PRO), 0x96, "Pro hit base 150");
    eq(skill_hit_base(SKILL_ALLSTAR), 0x64, "All-Star hit base 100");

    eq(skill_ai_near(SKILL_ROOKIE), 3, "Rookie AI range");
    eq(skill_ai_near(SKILL_PRO), 4, "Pro AI range");
    eq(skill_ai_near(SKILL_ALLSTAR), 4, "All-Star AI range");

    if (fails) {
        fprintf(stderr, "%d failed\n", fails);
        return 1;
    }
    puts("skill_test ok");
    return 0;
}
