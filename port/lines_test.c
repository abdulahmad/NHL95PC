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

    /* 94 Genesis CompLine */
    {
        int fresh[8] = { 0x1000, 0x1000, 0x1000, 0x1000, 0x1000, 0x1000, 0x1000, 0x1000 };
        int tired0[8] = { 0xB00, 0x1000, 0x1000, 0x1000, 0x1000, 0x1000, 0x1000, 0x1000 };
        int tired01[8] = { 0xB00, 0xC00, 0x1000, 0x1000, 0x1000, 0x1000, 0x1000, 0x1000 };
        int alltired[8] = { 0x800, 0x900, 0xA00, 0x1000, 0x900, 0xA00, 0xA00, 0x900 };
        eq(lines_pick94(1, 0, 0, 0, 0, fresh), 0, "94 home fresh opens on line 1");
        eq(lines_pick94(0, 0, 0, 0, 0, fresh), 0, "94 away fresh opens on line 1");
        eq(lines_pick94(1, 0, 0, 0, 1, fresh), 1, "94 home matches away line 2");
        eq(lines_pick94(1, 0, 0, 0, 2, fresh), 2, "94 home matches away line 3");
        eq(lines_pick94(1, 0, 0, 0, 0, tired0), 1, "94 home line 1 tired -> away order");
        eq(lines_pick94(0, 0, 0, 0, 0, tired01), 2, "94 away 1 and 2 tired -> 3");
        eq(lines_pick94(0, 0, 0, 0, 0, alltired), 2, "94 away all tired -> last tried");
        eq(lines_pick94(0, 0, 1, 1, 0, alltired), 1, "94 away leading 3rd, all tired -> row 0,2,1");
        eq(lines_pick94(1, 0, 1, 1, 0, fresh), 2, "94 home leading 3rd vs line 1 -> 3");
        eq(lines_pick94(1, 0, 1, -1, 2, fresh), 0, "94 home trailing 3rd vs line 3 -> 1");
        eq(lines_pick94(1, 0, 0, 1, 0, fresh), 0, "94 score ignored before the 3rd");
        eq(lines_pick94(1, 1, 0, 0, 0, fresh), 4, "94 power play equal -> PP1");
        eq(lines_pick94(1, 1, 0, 0, 0, alltired), 5, "94 power play fresher PP2");
        eq(lines_pick94(0, -1, 0, 0, 0, alltired), 6, "94 penalty kill fresher PK1");
        eq(lines_pick94(1, 0, 0, 0, 5, fresh), 1, "94 home vs PP2 (94G 4) -> 2");
    }

    if (fails) {
        fprintf(stderr, "%d failed\n", fails);
        return 1;
    }
    puts("lines_test ok");
    return 0;
}
