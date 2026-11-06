/* Rink tiles: expand a tile map into the rink bitmap. */
/* DRAFT (GA): 459 bytes, 5 differing. The flips are separate if / else arms (Watcom cross-jumps their shared
 tails as in the EXE) and the tile address adds the bitmap base last. Left: height is stored at esp+14h and
 width at esp+18h (the original the other way round), and the mirrored row is `add eax, edi / sub eax, edi /
 sub eax, edi` where the original doubles row in place (`add edi, edi / sub eax, edi`); see docs/UNSURE.md. */
#include "nhl95.h"

/* BlitTileMap: paint shape (width, height, then words) with 8x8 tiles from tiles. Tile bits 4000h and
 2000h flip vertically and horizontally, xored with flags. When flags is set the tile is mirrored
 through y,x. Colour FFh is skipped. x0 is unused. */
void BlitTileMap(unsigned char *shape, unsigned char *tiles, int x0, short y, short x, short flags)
{
    short height;
    short width;
    int row;
    int col;
    int tile;
    int vflip;
    int hflip;
    unsigned char *src;
    unsigned char *dst;
    int r;
    int c;
    unsigned char px;

    (void)x0;
    height = *(short *)(shape + 2);
    width = *(short *)shape;
    shape += 6;
    for (row = 0; row < height; row++) {
        for (col = 0; col < width; col++) {
            tile = *(short *)(shape + (row * width << 1) + (col << 1));
            vflip = (tile & 0x4000) ^ flags;
            hflip = flags ^ (tile & 0x2000);
            src = tiles + ((tile & 0x3FF) << 6);
            if (flags) {
                dst = (unsigned char *)(((rinkwtiles * (y + row - row - row)) << 6)
                    + ((((x + col) - (col << 1)) << 3)) + (*(int *)((char *)rinktilebm + 0x2C) + 0x10));
            } else {
                dst = (unsigned char *)((((y + row) * rinkwtiles) << 6) + ((x + col) << 3)
                    + (*(int *)((char *)rinktilebm + 0x2C) + 0x10));
            }
            if (vflip) {
                dst += rinkwtiles * 56;
                if (hflip) dst += 7;
            } else if (hflip) dst += 7;
            r = 0;
            do {
                c = 0;
                do {
                    px = *src;
                    if (px != 0xFF) *dst = px;
                    src++;
                    if (hflip) dst--;
                    else dst++;
                    c++;
                } while (c < 8);
                if (vflip) {
                    if (hflip) {
                        dst -= rinkwtiles << 3;
                        dst += 8;
                    } else {
                        dst -= rinkwtiles << 3;
                        dst -= 8;
                    }
                } else {
                    if (hflip) {
                        dst += rinkwtiles << 3;
                        dst += 8;
                    } else {
                        dst += rinkwtiles << 3;
                        dst -= 8;
                    }
                }
                r++;
            } while (r < 8);
        }
    }
}
