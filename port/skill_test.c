/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * 96 PC main-menu LEVEL helpers (port/skill.c). Pro is 1× the feel-mode term.
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

    /* live path: never 3/4 on Pro. v is already 95 PC or 94G stock. */
    eq(skill_scale_action(SKILL_PRO, 48), 48, "95 PC Pro 1× stock");
    eq(skill_scale_action(SKILL_ROOKIE, 48), 48, "95 PC Rookie skating = Pro");
    eq(skill_scale_action(SKILL_ALLSTAR, 48), 72, "95 PC All-Star 3/2 of 95 PC Pro");
    eq(skill_scale_action(SKILL_ALLSTAR, 100), 150, "95 PC All-Star 100");
    eq(skill_scale_action(SKILL_PRO, 40), 40, "94G Pro 1× that 94G term");
    eq(skill_scale_action(SKILL_ROOKIE, 40), 40, "94G Rookie skating = Pro");
    eq(skill_scale_action(SKILL_ALLSTAR, 40), 60, "94G All-Star 3/2 of that 94G term");
    eq(skill_scale_action(SKILL_PRO, 48) != skill_scale_96(SKILL_PRO, 48), 1, "live Pro is not 96 PC 3/4");

    eq(skill_hit_pro_base(0), 0x96, "95 PC Pro hit 150");
    eq(skill_hit_pro_base(1), 0x78, "94G Pro hit CCStart 0x78");
    eq(skill_hit_base_on(SKILL_PRO, 150), 150, "95 PC Pro hits");
    eq(skill_hit_base_on(SKILL_ROOKIE, 150), 150, "95 PC Rookie hits = Pro");
    eq(skill_hit_base_on(SKILL_ALLSTAR, 150), 100, "95 PC All-Star 100");
    eq(skill_hit_base_on(SKILL_PRO, 0x78), 0x78, "94G Pro hits");
    eq(skill_hit_base_on(SKILL_ROOKIE, 0x78), 0x78, "94G Rookie hits = Pro");
    eq(skill_hit_base_on(SKILL_ALLSTAR, 0x78), 80, "94G All-Star 100/150 of 0x78");
    eq(skill_hit_base(SKILL_ROOKIE), 0x96, "skill_hit_base Rookie 150");
    eq(skill_hit_base(SKILL_PRO), 0x96, "skill_hit_base Pro 150");
    eq(skill_hit_base(SKILL_ALLSTAR), 0x64, "skill_hit_base All-Star 100");

    eq(skill_ai_near(SKILL_ROOKIE), 3, "Rookie AI range (unhooked)");
    eq(skill_ai_near(SKILL_PRO), 4, "Pro AI range");
    eq(skill_ai_near(SKILL_ALLSTAR), 4, "All-Star AI range");

    if (fails) {
        fprintf(stderr, "%d failed\n", fails);
        return 1;
    }
    puts("skill_test ok");
    return 0;
}
