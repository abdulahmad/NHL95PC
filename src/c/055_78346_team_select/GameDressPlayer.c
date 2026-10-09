/* Team select: game line editor dress callback. */
#include "nhl95.h"

/* GameDressPlayer (79F41) - game line editor callback: dress the selected player *sel (of the 1Ch dressed list,
   gmroster 16h bytes each): his roster status (side's roster, 27h bytes per player, 444h per team) becomes 3, redraw
   the line jerseys (DrawGameLineJerseys) and reprint his "<num> <name>" line in colour C0h on C1h. The other
   arguments are unused. Returns 0. */
int GameDressPlayer(unsigned char *nums, int a, unsigned char side, int *sel, int art, int b, int c, int d, int e,
                    int f)
{
    char buf[32];

    hmroster[side * 0x444 + gmrosterslot[*sel * 22] * 39] = 3;
    DrawGameLineJerseys(nums, art, side);
    sub_8E9C0(0xC0, 0xC1);
    sprintf(buf, (char *)str_C2dS3, gmroster[*sel * 22], gmrosterjersey[*sel * 22], gmroster + *sel * 22 + 3);
    PrintLineEdStatus(0x1FA, *sel * 13 + 0x16, buf);
    return 0;
}
