/* Menu system: colour remap. */
#include "nhl95.h"

/* InitMenuRemap (1FAA7) - set up the menu colour remap table: mode 0 maps colours 0-14h to 0, 15h-3Fh down by 15h and
   keeps the rest; otherwise menuremap and menuremap2 are identity for 0-7Fh. Installs menuremap. */
void InitMenuRemap(int mode)
{
    int i;

    if (!mode) {
        memset(menuremap, 0, 0x15);
        for (i = 0x15; i < 0x40; i++) menuremap[i] = i - 0x15;
        for (i = 0x40; i < 0x100; i++) menuremap[i] = i;
    } else {
        for (i = 0; i < 0x80; i++) {
            menuremap[i] = i;
            menuremap2[i] = i;
        }
    }
    sub_B4DD4(menuremap);
}
