/* Schedule: playoff series length. */
/* DRAFT: 116 vs 116, 10 differing, structured (no labels). A plain switch with each length a ternary and
 the best-of-7 case before the four-or-five case: Watcom cross-jumps the shared `mov esi, 3 / 5 / 7` tails,
 so every case body and every jump table target is the EXE's. Left: the shared `mov eax, esi / pop esi /
 pop edx / pop ecx / ret` is at the end (the last case falls into it); the EXE falls out of `mov esi, 1`
 into it at +39 and the later cases jump back. A return after case 1 (`default: return len;`) still leaves
 the epilogue at the end; `return len` in every case folds the constants (`mov eax, 3`). See UNSURE. */
#include "nhl95.h"

/* SeriesLength: how many games a series record s (7 games, 6 bytes each) is played to. Count games until a
 blank date (byte 0 = FFh), at most 7. One game is best of 1; two is best of 3; three is best of 5 when
 SeriesWinner over 5 games has a winner, else best of 3; four or five is best of 7 when SeriesWinner over
 7 games has a winner, else best of 5; six or seven is best of 7. No games played leaves the length local
 unset, so the result is whatever esi held on entry. */
int SeriesLength(unsigned char *s)
{
    int n;
    unsigned char *p;
    int len;

    p = s;
    n = 0;
    do {
        if (p[n * 6] == 0xFF) break;
        n++;
    } while (n < 7);
    switch (n) {
    case 1:
        len = 1;
        break;
    case 2:
        len = 3;
        break;
    case 3:
        len = SeriesWinner(p, 5) < 0 ? 3 : 5;
        break;
    case 6:
    case 7:
        len = 7;
        break;
    case 4:
    case 5:
        len = SeriesWinner(p, 7) < 0 ? 5 : 7;
        break;
    }
    return len;
}
