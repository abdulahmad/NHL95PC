/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * 95 PC seat table -> ctl* (port/sides.c). sh port/sides_test.sh
 */
#include "sides.h"

#include <stdio.h>
#include <string.h>

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

static void eqS(const char *got, const char *want, const char *what)
{
    if (got && want && !strcmp(got, want)) return;
    fprintf(stderr, "FAIL %s: got \"%s\" want \"%s\"\n", what, got ? got : "(null)", want ? want : "(null)");
    fails++;
}

static void eqP(const void *got, const void *want, const char *what)
{
    if (got == want) return;
    fprintf(stderr, "FAIL %s: got %p want %p\n", what, got, want);
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

    /* teamcitynames order (frontend_16.asm): 0 Boston, 4 Detroit, 11 NY Islanders,
     * 26 West All Stars, 27 East All Stars. Exhibition and a season game both index
     * this table with VisTeam / HomeTeam; only which index is home changes. */
    {
        const char *cities[SIDES_NTEAMS];
        char buf[64];
        char longcity[40];
        int i;
        for (i = 0; i < SIDES_NTEAMS; i++) cities[i] = "X";
        cities[0] = "Boston";
        cities[4] = "Detroit";
        cities[11] = "NY Islanders";
        cities[26] = "West All Stars";
        cities[27] = "East All Stars";
        cities[2] = "";

        eqP(sides_city(cities, SIDES_NTEAMS, 0), cities[0], "city 0 is Boston");
        eqP(sides_city(cities, SIDES_NTEAMS, 4), cities[4], "city 4 is Detroit");
        eqP(sides_city(cities, SIDES_NTEAMS, 2), 0, "empty city slot");
        eqP(sides_city(cities, SIDES_NTEAMS, -1), 0, "team -1");
        eqP(sides_city(cities, SIDES_NTEAMS, SIDES_NTEAMS), 0, "team past ASE");
        eqP(sides_city(0, SIDES_NTEAMS, 0), 0, "no table");

        /* exhibition: Boston at home, Detroit away */
        sides_side_label(buf, sizeof buf, "Home", sides_city(cities, SIDES_NTEAMS, 0));
        eqS(buf, "Home Boston", "exhibition home Boston");
        sides_side_label(buf, sizeof buf, "Away", sides_city(cities, SIDES_NTEAMS, 4));
        eqS(buf, "Away Detroit", "exhibition away Detroit");
        /* season: the schedule has Detroit at home, Boston away */
        sides_side_label(buf, sizeof buf, "Home", sides_city(cities, SIDES_NTEAMS, 4));
        eqS(buf, "Home Detroit", "season home Detroit");
        sides_side_label(buf, sizeof buf, "Away", sides_city(cities, SIDES_NTEAMS, 0));
        eqS(buf, "Away Boston", "season away Boston");
        sides_side_label(buf, sizeof buf, "Home", sides_city(cities, SIDES_NTEAMS, 11));
        eqS(buf, "Home NY Islanders", "home keeps the side word");
        sides_side_label(buf, sizeof buf, "Away", sides_city(cities, SIDES_NTEAMS, 26));
        eqS(buf, "Away West All Stars", "all-star west still fits the heading");
        sides_side_label(buf, sizeof buf, "Home", sides_city(cities, SIDES_NTEAMS, 27));
        eqS(buf, "Home East All Stars", "all-star east still fits the heading");
        sides_side_label(buf, sizeof buf, "Home", sides_city(cities, SIDES_NTEAMS, -1));
        eqS(buf, "Home", "missing city keeps Home");
        sides_side_label(buf, sizeof buf, "Away", "");
        eqS(buf, "Away", "empty city keeps Away");
        sides_side_label(buf, sizeof buf, "Home", "Bos\x01ton");
        eqS(buf, "Home Bos?ton", "a non-ascii city byte");
        for (i = 0; i < 39; i++) longcity[i] = 'A' + (i % 26);
        longcity[39] = 0;
        sides_side_label(buf, sizeof buf, "Home", longcity);
        eq((int)strlen(buf), SIDES_LABEL_MAX, "heading cut to what Overbar stores");
        eq(buf[0], 'H', "cut heading still starts with the side");

        eq(sides_names_here(0, 0), 1, "offline names from this machine");
        eq(sides_names_here(1, 1), 1, "the host names from its HomeTeam");
        eq(sides_names_here(1, 0), 0, "a guest does not name from its own teams");
    }

    if (fails) {
        fprintf(stderr, "%d failed\n", fails);
        return 1;
    }
    puts("sides_test ok");
    return 0;
}
