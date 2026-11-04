/* DrawGameLineJerseys - game line editor: draw the 28h line slot jerseys (MakeJerseyShape with nums[i] in the team's colours, byte_D11BC byte_D12DE through jerseyremap) at lineslotx/y, then for the 1Ch dressed players (gmroster, 16h bytes each) print "<num> <name>" in the colour of their roster status (side's roster, 27h bytes per player, 444h per team): 1 C2h, 2 FCh before the game C2h, 3-4 C3h, 5-6 and 8 C2h, 7 unchanged; stops at the first empty status.
   The status is read in place in the test and the switch (Watcom keeps it in dl), and case 2 is a ternary. The
   declaration order (i and col before the colour bytes, c2 before c1) gives the nums[i] address temporary eax
   (`xor edx, edx / mov dl, [esi+eax]`) and the side / c2 / c1 byte slots +24h / +28h / +2Ch. */
#include "nhl95.h"

void DrawGameLineJerseys(unsigned char *nums, int art, unsigned char side)
{
    char buf[32];
    int i;
    int col;
    unsigned char c2;
    unsigned char c1;

    c1 = byte_D11BC[(side ? VisTeam : HomeTeam) * 4];
    c1 = jerseyremap[c1];
    c2 = byte_D12DE;
    for (i = 0; i < 0x28; i++) {
        MakeJerseyShape(jerseyremap, nums[i], c1, c2);
        sub_B4DD4(jerseyremap);
        sub_931FC(art, lineslotx[i * 2], linesloty[i * 2]);
    }
    for (i = 0; i < 0x1C; i++) {
        if (!hmroster[side * 0x444 + gmrosterslot[i * 22] * 39]) return;
        switch (hmroster[side * 0x444 + gmrosterslot[i * 22] * 39]) {
        case 2:
            col = curperiod < 0 ? 0xFC : 0xC2;
            break;
        case 3: case 4: col = 0xC3; break;
        case 1: case 5: case 6: case 8: col = 0xC2; break;
        }
        sub_8E9C0(col, 0xC1);
        sprintf(buf, (char *)str_C2dS3, gmroster[i * 22], gmrosterjersey[i * 22], gmroster + i * 22 + 3);
        PrintLineEdStatus(0x1FA, i * 13 + 0x16, buf);
    }
}
