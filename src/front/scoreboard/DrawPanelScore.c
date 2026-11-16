/* File utilities: score panel digits. */
#define VgaBlitKeyedHot sub_B4CD8_decl
#include "nhl95.h"
#undef VgaBlitKeyedHot

void __cdecl VgaBlitKeyedHot(int shape, int x, int y);

/* DrawPanelScore: draw score (mod 100) on the screen bitmap at y 4: the tens digit sprite
 (scoredigits; entry 10 is the blank for scores under 10) and the units digit, at x FFh 109h for the away
 side (side nonzero) or 2Eh 38h for home, then select the rink bitmap again. */
void DrawPanelScore(short side, short score)
{
    if (score >= 100) score %= 100;
    SelectScreenBM();
    if (side) {
        VgaBlitKeyedHot(scoredigits[score < 10 ? 10 : score / 10], 0xFF, 4);
        VgaBlitKeyedHot(scoredigits[score % 10], 0x109, 4);
    } else {
        VgaBlitKeyedHot(scoredigits[score < 10 ? 10 : score / 10], 0x2E, 4);
        VgaBlitKeyedHot(scoredigits[score % 10], 0x38, 4);
    }
    SelectRinkBM();
}
