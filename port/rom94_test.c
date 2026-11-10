/* port/rom94.c against a 94 ROM: NHL94_ROM_DIR=folder sh port/rom94_test.sh (skipped without one) */
#include "rom94.h"

#include <stdio.h>
#include <stdlib.h>

int main(void)
{
    static const int fr[] = { F94_STAR1, F94_STAR2, F94_STARPUCK, F94_STAR3, F94_STAR4, F94_ARROW1, F94_ARROW3, F94_ARROW4 + 2 };
    uint32_t rgb[32], team[16];
    int i, fails = 0;
    if (!getenv("NHL94_ROM_DIR") || rom94_load()) { printf("rom94_test: no 94 ROM, skipped\n"); return 0; }
    rom94_rink_palette(rgb);
    if (rgb[16 + 9] != 0x00006C) { printf("FAIL pad 1's star colour %06x\n", (unsigned)rgb[25]); fails++; }
    for (i = 0; i < (int)(sizeof fr / sizeof fr[0]); i++) {
        f93_frame f;
        if (f93_decode(rom94_sprites(), fr[i], &f) || !f.pix) { printf("FAIL frame %d\n", fr[i]); fails++; continue; }
        printf("frame %d: %dx%d at %d,%d\n", fr[i], f.w, f.h, f.x0, f.y0);
        f93_frame_free(&f);
    }
    {
        static const char *const t[] = { "bos", "ana", "ott", "min", "fla", "wpg", "ase", "asw" };
        for (i = 0; i < 8; i++) {
            if (rom94_team_colours(t[i], 1, team)) { printf("FAIL team %s\n", t[i]); fails++; continue; }
            printf("%s home jersey %06x %06x\n", t[i], (unsigned)team[10], (unsigned)team[11]);
        }
    }
    printf(fails ? "rom94_test: %d failed\n" : "rom94_test: all passed\n", fails);
    return fails != 0;
}
