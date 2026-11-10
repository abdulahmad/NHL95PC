/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * 96 PC faceoff CompLine: Auto always, else only a team with no human controller (port/lines.c).
 * sh port/lines_test.sh
 */
#include "lines.h"

#include <stdio.h>
#include <stdlib.h>

static int fails;

static void eq(int got, int want, const char *what)
{
    if (got == want) return;
    fprintf(stderr, "FAIL %s: got %d want %d\n", what, got, want);
    fails++;
}

int main(void)
{
    /* Auto on: both teams, including a human side */
    eq(lines_team_gets_compline(1, 1, 1, 2), 1, "auto home vs two humans");
    eq(lines_team_gets_compline(1, 2, 1, 2), 1, "auto away vs two humans");
    eq(lines_team_gets_compline(1, 1, 0, 0), 1, "auto no controllers");

    /* Auto off: 95 PC, computer teams only */
    eq(lines_team_gets_compline(0, 1, 1, 2), 0, "off human home");
    eq(lines_team_gets_compline(0, 2, 1, 2), 0, "off human away");
    eq(lines_team_gets_compline(0, 1, 2, 2), 1, "off computer home (both on away)");
    eq(lines_team_gets_compline(0, 2, 1, 1), 1, "off computer away (both on home)");
    eq(lines_team_gets_compline(0, 1, 0, 0), 1, "off no controllers");
    eq(lines_team_gets_compline(0, 2, 1, 0), 1, "off away, only home human");
    eq(lines_team_gets_compline(0, 1, 1, 0), 0, "off home, only home human");

    if (fails) {
        fprintf(stderr, "%d failed\n", fails);
        return 1;
    }
    puts("lines_test ok");
    return 0;
}
