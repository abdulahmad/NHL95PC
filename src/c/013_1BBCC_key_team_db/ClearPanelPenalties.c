/* Key team database: scoreboard penalty panel. */
#include "nhl95.h"

/* ClearPanelPenalties (1CBD8, PC only): empty both penalty panel lists (8 entries of 4 shorts: player -1, the
   rest 0) and reload the scoreboard graphics. The chained -1 store keeps the zero in ecx as in the EXE (found by
   tools/permute.py). No arguments, no result. */
void ClearPanelPenalties(void)
{
    int i;

    for (i = 0; i < 8; i++) {
        hudpenhome[i * 4] = hudpenaway[i * 4] = -1;
        word_C5762[i * 4] = 0;
        word_C5722[i * 4] = 0;
        word_C5760[i * 4] = 0;
        word_C5720[i * 4] = 0;
        word_C575E[i * 4] = 0;
        word_C571E[i * 4] = 0;
    }
    LoadScoreboardGfx();
}
