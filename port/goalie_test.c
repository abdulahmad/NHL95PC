/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * Manual goalie helpers (port/goalie.c): B-hold, the team's goalie slot, 94G crease.
 * sh port/goalie_test.sh
 */
#include "goalie.h"

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
    uint8_t t;

    eq(goalie_slot(0), 5, "home skater -> home goalie");
    eq(goalie_slot(5), 5, "home goalie");
    eq(goalie_slot(6), 0xB, "away skater -> away goalie");
    eq(goalie_slot(11), 0xB, "away goalie");

    eq(goalie_in_crease(0, 0xE0), 1, "crease centre");
    eq(goalie_in_crease(0, -0xE0), 1, "crease other end");
    eq(goalie_in_crease(0x40, 0xE0), 0, "wide of crease");
    eq(goalie_in_crease(0, 0), 0, "centre ice");

    t = 0;
    eq(goalie_bhold(0, 0, 1, 1, 0, &t), GB_PASS, "auto: original changeplayer");
    t = 0;
    eq(goalie_bhold(1, 1, 1, 1, 0, &t), GB_PASS, "manual on goalie: leave via changeplayer");
    t = 0;
    eq(goalie_bhold(1, 0, 1, 1, 0, &t), GB_WAIT, "manual B press starts the hold");
    eq(t, 0x0F, "timer 96 PC 15");
    eq(goalie_bhold(1, 0, 0, 1, 0, &t), GB_WAIT, "holding");
    t = 1;
    eq(goalie_bhold(1, 0, 0, 1, 0, &t), GB_TAKE, "hold ran out: take the goalie");
    t = 8;
    eq(goalie_bhold(1, 0, 0, 0, 1, &t), GB_CHANGE, "short B: changeplayer");
    eq(t, 0x0F, "timer reset after a short B");

    if (fails) {
        fprintf(stderr, "%d failed\n", fails);
        return 1;
    }
    puts("goalie_test ok");
    return 0;
}
