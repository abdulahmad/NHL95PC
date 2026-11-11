/* port/pads4.c helpers: seats to slots, which player a pad may keep, the pad byte. */
#include "pads4.h"

#include <stdio.h>

static int fails;
#define CHECK(c) do { if (!(c)) { printf("FAIL %s:%d %s\n", __FILE__, __LINE__, #c); fails++; } } while (0)

int main(void)
{
    int out[4];
    {   /* two seats: as before */
        int t[2] = { 2, 1 }, kb[2] = { 0, 1 };
        pads4_map_seats(2, t, kb, out);
        CHECK(out[0] == 0 && out[1] == 1);
    }
    {   /* 2 v 2 by team order: away pad, away pad, home keyboard, home pad */
        int t[4] = { 2, 2, 1, 1 }, kb[4] = { 0, 0, 1, 0 };
        pads4_map_seats(4, t, kb, out);
        CHECK(out[2] == 0);             /* the keyboard is a game pad */
        CHECK(out[0] == 1);             /* the first of the other team */
        CHECK(out[1] == 2 && out[3] == 3);
    }
    {   /* three on one team, none on the other */
        int t[3] = { 1, 1, 1 }, kb[3] = { 0, 0, 0 };
        pads4_map_seats(3, t, kb, out);
        CHECK(out[0] == 0 && out[1] == 1 && out[2] == 2);
    }
    {   /* away pretend pad, home keyboard, home pretend pad (the debug option, one person) */
        int t[3] = { 2, 1, 1 }, kb[3] = { 0, 1, 0 };
        pads4_map_seats(3, t, kb, out);
        CHECK(out[1] == 0 && out[0] == 1 && out[2] == 2);
    }
    {
        int16_t o[3] = { 2, 8, -1 };
        CHECK(pads4_keep(3, 1, 3, 0, o, 3));
        CHECK(!pads4_keep(2, 1, 3, 0, o, 3));          /* pad 1's */
        CHECK(!pads4_keep(7, 1, 3, 0, o, 3));          /* the other team's */
        CHECK(!pads4_keep(3, 1, -1, 0, o, 3));         /* off the ice */
        CHECK(!pads4_keep(3, 1, 3, 4, o, 3));          /* leaving */
        CHECK(pads4_keep(5, 1, 0, 0, o, 3));           /* his goalie, taken by B */
        CHECK(pads4_keep(9, 2, 2, 0, o, 3));
    }
    CHECK(pads4_byte(0, 0, 0) == 8);
    CHECK(pads4_byte(1, 0, 0) == 0);
    CHECK(pads4_byte(4, 1, 0) == 0x12);
    CHECK(pads4_byte(8, 0, 1) == 0x26);
    CHECK(pads4_byte(2, 1, 1) == 0x44);
    {   /* 94G chgplayer: his own player, even while controlled; not a teammate another pad has */
        int16_t humans[2] = { 2, 8 };
        CHECK(pads4_may_take(0, 0, 1, humans, 2));       /* his own, joy set */
        CHECK(!pads4_may_take(2, 0, 1, humans, 2));      /* the other human */
        CHECK(!pads4_may_take(2, 0, 0, humans, 2));      /* his number, joy clear (a whistle) */
        CHECK(!pads4_may_take(4, 0, 1, humans, 2));      /* joy, not listed */
        CHECK(pads4_may_take(3, 0, 0, humans, 2));       /* a CPU teammate */
        CHECK(pads4_may_take(2, 2, 1, humans, 2));       /* that human's own pad */
    }
    {   /* pass to the human teammate, then pass again: he is nearest the puck, and must not be taken */
        int16_t humans[1] = { 2 };
        pads4_cand c[6] = {
            { 0, 100, 1, 0, 0, 3 },     /* this pad */
            { 1, 40, 0, 0, 0, 2 },      /* CPU, closer than him */
            { 2, 10, 1, 0, 0, 3 },      /* human teammate, just passed to: closest */
            { 3, 5, 0, 0, 0, 0 },       /* goalie, even closer: not a switch */
            { 4, 20, 0, 1, 0, 2 },      /* locked */
            { 5, 15, 0, 0, 1, 2 },      /* leaving */
        };
        CHECK(pads4_switch_pick(0, humans, 1, c, 6) == 1);
    }
    {   /* every other teammate is a human: stay (the game sweep-checks) */
        int16_t humans[1] = { 1 };
        pads4_cand c[2] = { { 0, 80, 1, 0, 0, 2 }, { 1, 10, 1, 0, 0, 2 } };
        CHECK(pads4_switch_pick(0, humans, 1, c, 2) == 0);
    }
    {   /* two CPUs at the same distance: the later one */
        pads4_cand c[2] = { { 1, 10, 0, 0, 0, 2 }, { 3, 10, 0, 0, 0, 2 } };
        CHECK(pads4_switch_pick(0, NULL, 0, c, 2) == 3);
    }
    CHECK(pads4_switch_pick(4, NULL, 0, NULL, 0) == 4);
    {   /* 94 arrow frames (tile box and opaque pixels from the ROM). The tip sits on the draw point. */
        int hx, hy;
        pads4_arrow_hot(PADS4_PIN_UP, 0, -13, -7, 24, 24, -13, -7, 10, 16, &hx, &hy);
        CHECK(hy == 0 && hx == 13);                     /* tip y -7 is row 0; the shaft stays on x 0 */
        pads4_arrow_hot(PADS4_PIN_DOWN, 1, -13, -7, 24, 24, -13, -7, 10, 16, &hx, &hy);
        CHECK(hy == 23 && hx == 13);                    /* the same tip, flipped, is the last row */
        pads4_arrow_hot(PADS4_PIN_RIGHT, 0, -18, -12, 24, 24, -18, -12, 5, 11, &hx, &hy);
        CHECK(hx == 23 && hy == 12);                    /* tip x 5 is the last column; y stays on the origin */
        pads4_arrow_hot(PADS4_PIN_UP | PADS4_PIN_RIGHT, 0, -19, -5, 24, 24, -16, -5, 4, 15, &hx, &hy);
        CHECK(hx == 23 && hy == 0);
        pads4_arrow_hot(0, 0, -16, -5, 31, 24, -16, -5, 14, 18, &hx, &hy);
        CHECK(hx == 16 && hy == 5);                     /* a star: the origin stays on the player */
    }
    /* passto: only a human goalie follows the pass, and not onto a controlled receiver */
    CHECK(!pads4_pass_switches(0, 1, 0));
    CHECK(!pads4_pass_switches(1, 0, 0));
    CHECK(!pads4_pass_switches(1, 1, 1));
    CHECK(pads4_pass_switches(1, 1, 0));
    /* setd0player: not a pad 3/4 player, and not a controlled goalie while those pads are on */
    CHECK(pads4_give_skip(1, 0, 2, 0));          /* pad 3 or 4 already has him */
    CHECK(!pads4_give_skip(0, 0, 0, 1));         /* no extra pads: 95 PC's own check stands */
    CHECK(pads4_give_skip(0, 1, 0, 1));          /* controlled goalie, pads 3 and 4 on */
    CHECK(!pads4_give_skip(0, 1, 0, 0));         /* CPU goalie: a game pad may take him */
    CHECK(!pads4_give_skip(0, 1, 3, 0));         /* CPU skater who picked the puck up */
    CHECK(!pads4_give_skip(0, 1, 3, 1));         /* a skater's joy is not this check (94G tests the goalie) */
    printf(fails ? "pads4_test: %d failed\n" : "pads4_test: all passed\n", fails);
    return fails != 0;
}
