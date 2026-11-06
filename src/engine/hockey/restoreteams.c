/* Engine core: put both teams' rosters on the bench. */
#include "nhl95.h"

/* restoreteams: put both teams' rosters on the bench. For each team:
 tmap = 6 (players allowed on the ice), and every roster player's tmpdst from his roster status byte through
 word_CCCA8. */
void restoreteams(void)
{
    Team *t;
    short i, k;
    unsigned char *r;
    short *dst;

    for (i = 0, t = &hmtmstruct; i < 2; t = &awtmstruct, i++) {
        t->tmap = 6;
        dst = t->tmpdst;
        r = t->tmroster;
        for (k = 0; k < 28; dst++, k++, r += 0x27)
            *dst = word_CCCA8[*r];
    }
}
