/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * Four players greys the player 1 and player 2 control rows; off makes them editable again.
 * sh port/ctlrows_test.sh
 */
#include "ctlrows.h"

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
    int on = 50, saved = 0, have = 0;
    ctlrows_set(&on, 50, &saved, &have, 1);
    eq(on, 0, "four players clears the handler");
    eq(have, 1, "the handler was saved");
    ctlrows_set(&on, 50, &saved, &have, 1);
    eq(on, 0, "it stays grey");
    ctlrows_set(&on, 50, &saved, &have, 0);
    eq(on, 50, "off puts the handler back");

    on = 9;
    have = 0;
    ctlrows_set(&on, 50, &saved, &have, 1);
    eq(on, 9, "some other row is left alone");
    eq(have, 0, "that row was not saved");

    if (fails) {
        fprintf(stderr, "%d failed\n", fails);
        return 1;
    }
    puts("ctlrows_test ok");
    return 0;
}
