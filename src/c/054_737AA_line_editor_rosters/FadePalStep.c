/* Line editor / rosters: palette fades (one source block: FadePalStepSlow ends in FadePalStep's exit). */
/* DRAFT: the EXE spills steps to its stack slot at entry and reloads it for the clamp (C still has it in ebx there); the rest and the shared exit look right. */
#include "nhl95.h"

/* Watcom runtime: store n bytes of v at p (the code generator's block fill) */
void __STOSB(void *p, int v, int n);
#pragma aux __STOSB "__STOSB" parm [eax] [edx] [ecx];

/* a signed byte of a table, read as the top byte of a dword */
#define SBYTE(t, i) (*(int *)((t) + (i) - 3) >> 24)

/* FadePalStep (76429) - fade towards palette pal: dir 1 fades in (from black; at most 2 steps when already faded
   in, palfadedin set), dir 0 out (palfadedin cleared). Under 2 steps: out sets pal at once, in sets a black palette
   and clears the screen. Else the scale runs from fadestart[dir] to fadeend[dir] by fadestep[dir] (the table's
   steps - 1 / steps + 1 entries are set here), each step setting pal x scale / steps. */
void FadePalStep(int dir, unsigned char *pal, int steps)
{
    int c;
    int i;

    if (dir) {
        if (palfadedin) steps = steps > 2 ? 2 : steps;
        palfadedin = 1;
    } else palfadedin = dir;
    if (steps < 2) {
        if (!dir) {
            SetPalette768(pal);
            return;
        }
        __STOSB(fadepal, 0, 0x300);
        SetPalette768(fadepal);
        sub_B392C(0);
        return;
    }
    fadestart[1] = steps - 1;
    fadeend[0] = steps + 1;
    for (c = SBYTE(fadestart, dir); c != SBYTE(fadeend, dir); c += SBYTE(fadestep, dir)) {
        for (i = 0; i < 0x300; i++) fadepal[i] = ((signed char *)pal)[i] * c / steps;
        SetPalette768(fadepal);
    }
}

/* FadePalStepSlow (7651B) - the same on the second tables (fadestart2 / fadeend2 / fadestep2, fadepal2), waiting
   45 ms per step. */
void FadePalStepSlow(int dir, unsigned char *pal, int steps)
{
    int c;
    int i;

    if (dir) {
        if (palfadedin) steps = steps > 2 ? 2 : steps;
        palfadedin = 1;
    } else palfadedin = dir;
    if (steps < 2) {
        if (!dir) {
            SetPalette768(pal);
            return;
        }
        __STOSB(fadepal2, 0, 0x300);
        SetPalette768(fadepal2);
        sub_B392C(0);
        return;
    }
    fadestart2[1] = steps - 1;
    fadeend2[0] = steps + 1;
    for (c = SBYTE(fadestart2, dir); c != SBYTE(fadeend2, dir); c += SBYTE(fadestep2, dir)) {
        for (i = 0; i < 0x300; i++) fadepal2[i] = ((signed char *)pal)[i] * c / steps;
        delay(0x2D);
        SetPalette768(fadepal2);
    }
}
