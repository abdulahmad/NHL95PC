/* Roster / jersey: trade screen. */
#include "nhl95.h"

/* DrawTradeRow (3E7B3) - print the cursor row of trade list side (16h-byte rows, 268h per side): position letter, jersey
   number and name at x side * 1C0h + 5, y row * line height + 1Dh. */
void DrawTradeRow(int side)
{
    int ofs;

    ofs = tradecursor[side] * 0x16;
    sub_93170(side * 0x1C0 + 5, byte_D42C3 * tradecursor[side] + 0x1D, (char *)str_C2dS,
              traderoster[ofs + side * 0x268], tradejersey[ofs + side * 0x268],
              traderoster + side * 0x268 + ofs + 3);
}
