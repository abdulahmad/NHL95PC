/* EASN stats: player photo with its palette. */
#include "nhl95.h"

/* DrawPhotoWithPal: take the current palette (the saved stats palette statspal when statspalvalid,
 else read it from the card with start statspalvalid = 0), put the photo's 180 colour bytes at entry 44h and its
 165 bytes at C4h (src), set photoremap, write the palette back the same way and draw photo art at x, y
 (sub_91FE0). */
void DrawPhotoWithPal(unsigned char *src, int art, int x, int y)
{
    unsigned char pal[0x300];
    unsigned char *p;
    int i;

    if (statspalvalid) memcpy(pal, (void *)statspal, 0x300);
    else sub_8FFB0(0, 0x100, pal);
    for (p = pal + 0xCC, i = 0; i < 0xB4; i++, src++, p++) *p = *src;
    for (p = pal + 0x24C, i = 0; i < 0xA5; i++, src++, p++) *p = *src;
    sub_B4DD4(photoremap);
    if (statspalvalid) memcpy((void *)statspal, pal, 0x300);
    else sub_B4B88(0, 0x100, pal);
    sub_91FE0(art, x, y);
}
