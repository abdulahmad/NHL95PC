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
    printf(fails ? "pads4_test: %d failed\n" : "pads4_test: all passed\n", fails);
    return fails != 0;
}
