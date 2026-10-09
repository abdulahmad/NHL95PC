/* Main / startup: draw a number in sprites. */
#include "nhl95.h"

/* DrawSpriteNumber (11005) - PC only: draw n (0-99) with the digit sprites (numshapes) at screen x + C0h, 140h - y
   + 0Dh (+0Fh when suffix >= 0): two digits 7 apart from 3 to the left; with suffix > 0 the number moves 4 left and
   suffix sprite dword_D8C4C[suffix] follows 8 after the last digit. */
void DrawSpriteNumber(short x, short y, short n, short suffix)
{
    short sy;
    short sfx;
    int yy;

    sfx = suffix;
    x += 0xC0;
    sy = 0x140 - y + 0xD;
    if (suffix > 0) x -= 4;
    if (sfx >= 0) sy += 2;
    if (n >= 10) {
        x -= 3;
        DrawSprite(numshapes[(short)(n / 10)], x, sy, 0, 0, 0);
        n = n % 10;
        x += 7;
    }
    yy = sy;
    DrawSprite(numshapes[n], x, yy, 0, 0, 0);
    if (sfx > 0) {
        x += 8;
        DrawSprite(dword_D8C4C[sfx], x, yy, 0, 0, 0);
    }
}
