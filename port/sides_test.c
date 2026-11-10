/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * 95 PC seat table -> ctl* (port/sides.c). sh port/sides_test.sh
 */
#include "sides.h"

#include <stdio.h>

static int fails;

static void eq(int got, int want, const char *what)
{
    if (got == want) return;
    fprintf(stderr, "FAIL %s: got %d want %d\n", what, got, want);
    fails++;
}

static void eqU(unsigned got, unsigned want, const char *what)
{
    if (got == want) return;
    fprintf(stderr, "FAIL %s: got %u want %u\n", what, got, want);
    fails++;
}

int main(void)
{
    int32_t team;
    uint32_t side;

    sides_seat_ctl(1, 7, 3, &team, &side);
    eq((int)team, 7, "home seat: HomeTeam");
    eqU(side, 0, "home seat: side 0");

    sides_seat_ctl(0, 7, 3, &team, &side);
    eq((int)team, 3, "away seat: VisTeam");
    eqU(side, 1, "away seat: side 1");

    eqU(sides_dev_for_slot(0, 0), 8, "keyboard is device 8");
    eqU(sides_dev_for_slot(0, 1), 2, "first pad: Joystick One");
    eqU(sides_dev_for_slot(1, 2), 4, "second pad: Joystick Two");
    eqU(sides_dev_for_slot(1, 0), 8, "keyboard on ctl2 still 8");
    eq(sides_pad_index(0), -1, "keyboard is not a pad");
    eq(sides_pad_index(1), 0, "local 1 is pad 0");
    eq(sides_pad_index(3), 2, "local 3 is pad 2");

    eqU(sides_filter_hot(0x3B, 2), 0x3B, "F1 home with a home seat");
    eqU(sides_filter_hot(0x3B, 1), 0, "F1 dropped without a home seat");
    eqU(sides_filter_hot(0x3F, 1), 0x3F, "F5 away with an away seat");
    eqU(sides_filter_hot(0x3F, 2), 0, "F5 dropped without an away seat");
    eqU(sides_filter_hot(0x43, 2), 0x43, "F9 home goalie");
    eqU(sides_filter_hot(0x44, 1), 0x44, "F10 away goalie");
    eqU(sides_filter_hot(0x44, 2), 0, "F10 dropped without an away seat");
    eqU(sides_filter_hot(0x0F, 0), 0x0F, "Tab is not a team key");

    if (fails) {
        fprintf(stderr, "%d failed\n", fails);
        return 1;
    }
    puts("sides_test ok");
    return 0;
}
