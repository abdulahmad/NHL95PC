/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * Custom keys stay off in menus, and Shoot+Pass is Hold only when Hold has no button of its own.
 * sh port/bindings_test.sh
 */
#include "bindings.h"

#include <stdio.h>
#include <string.h>

static int fails;

static void eq(int got, int want, const char *what)
{
    if (got == want) return;
    fprintf(stderr, "FAIL %s: got %d want %d\n", what, got, want);
    fails++;
}

int main(void)
{
    int swallow = 0;
    unsigned char down[8];

    eq(bindings_remap_on(0, 0, 0), 0, "before a game the keys are normal");
    eq(bindings_remap_on(-1, 0, 0), 0, "no period: normal keys");
    eq(bindings_remap_on(1, 1, 0), 0, "a text field keeps the key");
    eq(bindings_remap_on(1, 0, 1), 0, "a menu keeps the key");
    eq(bindings_remap_on(2, 0, 0), 1, "during a period the map is on");

    eq(bindings_button_mask(1, 0, 0, 0, 0), 1, "pass");
    eq(bindings_button_mask(0, 1, 0, 0, 0), 2, "shoot");
    eq(bindings_button_mask(1, 1, 0, 0, 0), 3, "chord is Hold when Hold is not its own button");
    eq(bindings_button_mask(1, 1, 0, 1, 0), 0, "chord is not Hold once Hold has its own button");
    eq(bindings_button_mask(1, 0, 0, 1, 0), 1, "pass still works beside an own Hold");
    eq(bindings_button_mask(0, 1, 0, 1, 0), 2, "shoot still works beside an own Hold");
    eq(bindings_button_mask(1, 1, 1, 1, 0), 3, "the own Hold button is both game buttons");
    eq(bindings_button_mask(0, 0, 1, 1, 0), 3, "Hold alone");
    eq(bindings_button_mask(1, 1, 0, 1, 1), 3, "C held, then B, is still both buttons");

    {
        int c = 0;
        eq(bindings_note_shot(&c, 0, 1), 0, "C alone is not the fake yet");
        eq(c, 1, "C held first is remembered");
        eq(bindings_note_shot(&c, 0, 1), 0, "C still held");
        eq(bindings_note_shot(&c, 1, 1), 1, "B on top of that C is the fake");
        eq(bindings_note_shot(&c, 0, 1), 0, "releasing B leaves the wind-up");
        eq(c, 1, "C is still the one that was held first");
        eq(bindings_note_shot(&c, 0, 0), 0, "releasing C ends it");
        eq(c, 0, "the sequence is forgotten");
    }
    {
        int c = 0;
        eq(bindings_note_shot(&c, 1, 0), 0, "B first");
        eq(bindings_note_shot(&c, 1, 1), 0, "C after B is not the fake");
        eq(c, 0, "that chord stays disabled");
    }
    {
        int c = 0;
        eq(bindings_note_shot(&c, 1, 1), 0, "B and C together are not the fake");
        eq(c, 0, "together does not count as C held first");
        eq(bindings_note_shot(NULL, 0, 1), 0, "no state pointer");
    }

    bindings_defaults(&bind);
    eq(bindings_button_key(0x38, &swallow), ACT_PASS, "default pass key");
    eq(swallow, 0, "default pass is not swallowed");
    bind.kb[ACT_PASS] = 0x10;                       /* Q */
    eq(bindings_button_key(0x10, &swallow), ACT_PASS, "Q is pass");
    eq(bindings_button_key(0x38, &swallow), -1, "Alt is no longer pass");
    eq(swallow, 1, "the old pass key is swallowed during play");
    bind.kb[ACT_HOLD] = 0x39;                       /* Space, which is also the default shoot */
    swallow = 0;
    eq(bindings_button_key(0x39, &swallow), ACT_SHOOT, "shoot is checked before a later action on the same key");
    eq(bindings_goalie_mapped(), 0, "manual goalie starts unmapped");
    bind.kb[ACT_GOALIE] = 0x2C;
    eq(bindings_goalie_mapped(), 1, "a goalie key counts");
    {
        int out[4];
        eq(bindings_kb(0x2C, out), 0, "manual goalie is not a game key");
    }
    bind.kb[ACT_GOALIE] = 0;

    memset(down, 0, sizeof down);
    bind.ms[2] = 0;
    down[1] = down[3] = 1;                          /* left and right */
    eq(bindings_mouse(down, NULL), 3, "mouse chord is Hold");
    bind.ms[2] = 2;                                 /* middle is Hold */
    eq(bindings_mouse(down, NULL), 0, "mouse chord stops when Hold has a button");
    down[2] = 1;
    eq(bindings_mouse(down, NULL), 3, "the middle button is Hold");
    {
        int c = 0;
        unsigned char seq[8];
        memset(seq, 0, sizeof seq);
        bind.ms[2] = 2;
        seq[3] = 1;                                 /* right: C / shot */
        eq(bindings_mouse(seq, &c), 2, "mouse C alone");
        seq[1] = 1;                                 /* left joins: B / pass */
        eq(bindings_mouse(seq, &c), 3, "mouse C then B is the fake");
    }

    if (fails) {
        fprintf(stderr, "%d failed\n", fails);
        return 1;
    }
    puts("bindings_test ok");
    return 0;
}
