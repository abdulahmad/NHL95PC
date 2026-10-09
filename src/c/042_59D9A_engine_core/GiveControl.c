/* Engine core: give the human the player who got the puck (PC only). */
#include "nhl95.h"

/* GiveControl (5B1CE) - PC only: give a human pad control of player pl (sort object number; 0-5 home, 6+
   away) when he gets the puck. Nothing when a pad already has him. regd1 = his team (1 home, 2 away). The
   pad on that team (cont1team / cont2team) switches to him through restorepl. When pad 2's player equals
   passspeed (the word at C90A2; meaning not known) pad 2 is checked first, else pad 1. */
void GiveControl(short pl)
{
    short c2;

    if (pl == c1playernum[0]) return;
    c2 = c2playernum[0];
    if (pl == c2) return;
    regd1.w = (pl >= 6) + 1;                    /* team of the player: 1 home, 2 away */
    if (c2 != passspeed) {
        if (cont1team == regd1.w) {
            if (pl != c1playernum[0]) c1playernum[0] = restorepl(pl, c1playernum[0]);
        } else if (regd1.w == cont2team) {
            if (pl != c2) c2playernum[0] = restorepl(pl, c2playernum[0]);
        }
    } else {
        if (cont2team == regd1.w) {
            if (pl != c2) c2playernum[0] = restorepl(pl, c2playernum[0]);
        } else if (regd1.w == cont1team) {
            if (pl != c1playernum[0]) c1playernum[0] = restorepl(pl, c1playernum[0]);
        }
    }
}
