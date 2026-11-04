/* Main startup: fade the palette. */
#include "nhl95.h"

/* Watcom runtime: store n bytes of v at p (the code generator's block fill). */
void __STOSB(void *p, int v, int n);
#pragma aux __STOSB "__STOSB" parm [eax] [edx] [ecx];

/* a signed byte of a table, read as the top byte of a dword */
#define SBYTE(t, i) (*(int *)((unsigned char *)(t) + (i) - 3) >> 24)

/* DRAFT: 224 vs 227. The clamp compares steps in ebx (`cmp ebx, 2`); the original reloads the
 stack home into ecx (`mov ecx, [esp]; cmp ecx, 2`) and the rest of the function matches that
 3-byte shift. A volatile parameter dropped ebp. Copying steps to a local, and an inlined
 `mov ecx, [esp]`, both let the compiler rewrite the ternary as `mov ecx, 2`. Do not retry those. */

/* FadePalette: fade towards palette pal. dir 1 fades in (from black; at most 2 steps when already
 faded in, palfadedin set), dir 0 fades out (palfadedin cleared). Under 2 steps: out sets pal at once,
 in sets a black palette. Else the scale runs from the byte at dword_C5131+dir to the byte at
 byte_C5138+dir-3, stepping by the byte at dword_C5133+dir. dword_C5135 and byte_C5138[0] are
 steps-1 and steps+1. Each step writes pal * scale / steps into byte_D8C88 and sets that palette. */
void FadePalette(int dir, unsigned char *pal, int steps)
{
    int c;
    int i;

    if (dir) {
        if (palfadedin) steps = steps > 2 ? 2 : steps;
        palfadedin = 1;
    } else palfadedin = dir;
    if (steps < 2) {
        if (!dir) SetFullPalette(pal);
        else {
            __STOSB(byte_D8C88, 0, 0x300);
            SetFullPalette(byte_D8C88);
        }
        return;
    }
    dword_C5135 = steps - 1;
    byte_C5138[0] = steps + 1;
    for (c = SBYTE((unsigned char *)dword_C5131 + 3, dir); c != SBYTE(byte_C5138, dir); c += SBYTE((unsigned char *)dword_C5133 + 3, dir)) {
        for (i = 0; i < 0x300; i++) byte_D8C88[i] = ((signed char *)pal)[i] * c / steps;
        SetFullPalette(byte_D8C88);
    }
}
