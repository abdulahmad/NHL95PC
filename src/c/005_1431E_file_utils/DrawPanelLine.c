/* File utils: panel line indicator. */
#include "nhl95.h"

#define PUTSPRITE ((void (__cdecl *)(int spr, int x, int y))sub_B4CD8)

/* DrawPanelLine (14AFE) - draw the line indicator of team side (away when set) for line on the screen bitmap:
   crossing between the forward lines (< 4), the extra lines (< 6) and the rest resets that side's line timer
   (dword_C5860 away, dword_C585C home); store the line (hudawayline / hudhomeline) and draw its sprite
   (linesprites) at FBh / 2Ah, 14h. */
void DrawPanelLine(int side, int line)
{
    SelectScreenBM();
    if ((short)side) {
        if (((hudawayline < 4) ^ ((short)line < 4)) || ((hudawayline < 6) ^ ((short)line < 6))) dword_C5860 = 0;
        hudawayline = (short)line;
        PUTSPRITE(linesprites[hudawayline], 0xFB, 0x14);
    } else {
        if (((hudhomeline < 4) ^ ((short)line < 4)) || ((hudhomeline < 6) ^ ((short)line < 6))) dword_C585C = 0;
        hudhomeline = (short)line;
        PUTSPRITE(linesprites[hudhomeline], 0x2A, 0x14);
    }
    SelectRinkBM();
}
