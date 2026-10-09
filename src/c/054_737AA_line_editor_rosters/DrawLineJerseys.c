/* Line editor / rosters: line slot jerseys. */
#include "nhl95.h"

/* DrawLineJerseys (75046) - line editor: draw the 28h line slot jerseys at lineslotx / y (art; numbers nums[i] up to
   99 by MakeJerseyShape in the colours of team side's rosterteam (byte_D11BC through jerseyremap, byte_D12DE); an
   empty slot gets a plain jersey: remap entries 0-8Fh and C0h-EFh to the second colour), then for the 1Ch roster
   players (rosterlist, 27 bytes each, 2DCh per side) print "<num> <name>" in the colour of their status (2 FCh,
   3 C3h, others keep the last colour); stops at the first empty status. */
void DrawLineJerseys(unsigned char *nums, int art, unsigned char side)
{
    char buf[32];
    unsigned char c2;
    unsigned char c1;
    int i;
    int j;
    int col;
    unsigned char st;

    c1 = byte_D11BC[rosterteam[side] * 4];
    c1 = jerseyremap[c1];
    c2 = byte_D12DE;
    for (i = 0; i < 0x28; i++) {
        if (nums[i] <= 99) {
            MakeJerseyShape(jerseyremap, nums[i], c1, c2);
        } else {
            for (j = 0; j < 0x90; j++) jerseyremap[j] = c2;
            for (j = 0xC0; j < 0xF0; j++) jerseyremap[j] = c2;
        }
        sub_B4DD4(jerseyremap);
        sub_931FC(art, lineslotx[i * 2], linesloty[i * 2]);
    }
    for (i = 0; i < 0x1C; i++) {
        st = rosterstat[side * 0x2DC + i * 27];
        if (!st) return;
        switch (st) {
        case 2: col = 0xFC; break;
        case 3: col = 0xC3; break;
        }
        sub_8E9C0(col, 0xC1);
        sprintf(buf, (char *)str_C2dS2, rosterlist[side * 0x2DC + i * 27], rosterjersey[side * 0x2DC + i * 27],
                rosterlist + side * 0x2DC + i * 27 + 8);
        PrintLineEdStatus(0x1FA, i * 13 + 0x16, buf);
    }
}
