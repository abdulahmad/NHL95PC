/* Engine display: line tables. */
#include "nhl95.h"

/* RemoveFromLines (655CC, PC only): take roster player pnum of team side (0 home, 1 away) out of the team's line
   table (hmlinetab / awlinetab) and refill every slot that held him. For a defenceman ('D' in his roster record,
   byte +6 of the 27h-byte entries, 444h per team) first count the dressed defencemen (dressed list byte_E9DB4,
   19h per team) whose roster status byte has byte_CD418 set into word_E9F14; for a forward (not 'G') the same for
   the forwards (byte_E9E4A) into word_E9F12. The table is 4 lines of 3 forwards, 3 pairs of defence, two power
   play units (2 x 5) and two penalty kill units (2 x 4) (RefillLineSlots), two goalie slots (PickGoalie) and two
   extra-skater slots (PickExtraSkater). side: the team; pnum: the roster index. No result.
   DRAFT (10.0 GA, 36 differing, 811 vs 807): one dressed-list entry local per counting loop (r, r2: each ranks below
   the side * 444h temporaries as in the EXE) and the defence index as `i + side * 0x19` (the EXE's add order). Left:
   r / r2 take di (EXE ax), the loop zeros use other temporaries, and the goalie loop caches pnum in ecx (original
   compares the stack word). See docs/UNSURE.md. */
void RemoveFromLines(short side, short pnum)
{
    signed char *lt;
    short k;
    short i;
    int j;
    short r;
    short r2;

    lt = (signed char *)(side ? awlinetab : hmlinetab);
    if (byte_DB3AE[side * 0x444 + pnum * 0x27] == 'D') {
        word_E9F14 = 0;
        for (i = 0; i < 0x19; i++) {
            r = byte_E9DB4[i + side * 0x19];
            if (r < 0) break;
            if (byte_CD418[hmroster[side * 0x444 + r * 0x27]] == 1) word_E9F14++;
        }
    } else if (byte_DB3AE[side * 0x444 + pnum * 0x27] != 'G') {
        word_E9F12 = 0;
        for (i = 0; i < 0x19; i++) {
            r2 = byte_E9E4A[side * 0x19 + i];
            if (r2 < 0) break;
            if (byte_CD418[hmroster[side * 0x444 + r2 * 0x27]] == 1) word_E9F12++;
        }
    }
    k = 0;
    for (i = 0; i < 4; i++)
        for (j = 0; (short)j < 3; k++, j++)
            if (*lt++ == pnum) RefillLineSlots(side, k, i, 4, 3);
    for (i = 0; i < 3; i++)
        for (j = 0; (short)j < 2; k++, j++)
            if (*lt++ == pnum) RefillLineSlots(side, k, i, 3, 2);
    for (i = 0; i < 2; i++)
        for (j = 0; (short)j < 5; k++, j++)
            if (*lt++ == pnum) RefillLineSlots(side, k, i, 2, 5);
    for (i = 0; i < 2; i++)
        for (j = 0; (short)j < 4; k++, j++)
            if (*lt++ == pnum) RefillLineSlots(side, k, i, 2, 4);
    for (i = 0; i < 2; k++, i++)
        if (*lt++ == pnum) PickGoalie(side, k, 0);
    for (i = 0; i < 2; k++, i++)
        if (*lt++ == pnum) PickExtraSkater(side, k);
}
