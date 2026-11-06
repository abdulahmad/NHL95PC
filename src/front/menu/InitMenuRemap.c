/* Menu system: colour remap. */
#include "nhl95.h"

/* Watcom runtime: store n bytes of v at p (the code generator's block fill) */
void __STOSB(void *p, int v, int n);
#pragma aux __STOSB "__STOSB" parm [eax] [edx] [ecx];

/* InitMenuRemap: set up the menu colour remap table: mode 0 maps colours 0-14h to 0, 15h-3Fh down by 15h and
 keeps the rest; otherwise menuremap and menuremap2 are identity for 0-7Fh. Installs menuremap. */
void InitMenuRemap(int mode)
{
    int i;

    if (!mode) {
        __STOSB(menuremap, 0, 0x15);
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
