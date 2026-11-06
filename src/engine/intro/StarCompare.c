/* Three stars: qsort order for the player keys. */
#define StarCompare StarCompare_decl
#include "nhl95.h"
#undef StarCompare

int StarElig(int side, int pl);
#pragma aux StarElig "StarEligible" parm [eax] [edx] value [eax] modify [eax edx];

/* StarCompare: qsort comparator. Each key is team * 25 + player. Points are the first two words of the
 16-byte row at dword_DB088; the game-winner row gets two extra. Ties go to the low word, then the word
 at +0Eh, then the word at +6 when either is positive, then which player is eligible, then the byte total
 at unk_DACA0 (20 bytes per player, 500 per team). A higher total sorts first. */
/* DRAFT: 67 differing instructions, 627 vs 653 bytes under 10.0 GA. The EXE keeps pa in ebp and spills pb and sb ([esp+4], [esp+8], with
   [esp] a temporary for the first word of each sum); this keeps sb in ebp and spills pa and pb. See docs/UNSURE.md. */
int StarCompare(int *a, int *b)
{
    int ta;
    int tb;
    int pb;
    int pa;
    int sa;
    int sb;
    short *ra;
    short *rb;
    unsigned char *ua;
    unsigned char *ub;

    ta = *a / 25;
    tb = *b / 25;
    pa = *a % 25;
    pb = *b % 25;
    ra = (short *)((char *)dword_DB088 + ta * 400 + pa * 16);
    rb = (short *)((char *)dword_DB088 + tb * 400 + pb * 16);
    sa = ra[1] + ra[0];
    if (ta == gwgteam && pa == gwgplayer) sa += 2;
    sb = rb[1] + rb[0];
    if (tb == gwgteam && pb == gwgplayer) sb += 2;
    if (sa != sb) return sb - sa;
    if (rb[0] != ra[0]) return rb[0] - ra[0];
    if (sa > 0 && ta != tb) {
        int ds;

        ds = hmscore[tb * 128] - hmscore[ta * 128];
        if (ds != 0 && ((ds > 0) ^ tb)) return ds;
    }
    if (rb[7] != ra[7]) return rb[7] - ra[7];
    if (rb[3] > 0 || ra[3] > 0) return rb[3] - ra[3];
    sa = StarElig(ta, pa);
    sb = StarElig(tb, pb);
    if (sa != sb) {
        if (sb) return 1;
        return -1;
    }
    ua = unk_DACA0 + ta * 25 * 20;
    ua += pa * 20;
    ub = unk_DACA0 + tb * 25 * 20;
    ub += pb * 20;
    sb = ub[1] + ub[2] + ub[4] + ub[6] + ub[9] + ub[10] + ub[3] + ub[13] + ub[11] + ub[5];
    sa = ua[1] + ua[2] + ua[4] + ua[6] + ua[9] + ua[10] + ua[3] + ua[13] + ua[11] + ua[5];
    return sb - sa;
}
