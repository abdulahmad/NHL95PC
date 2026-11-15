/* Engine display: picking a player for a line slot. */
#define PickForLineSlot PickForLineSlot_decl
#define CanFillLineSlot CanFillLineSlot_decl
#define PickExtraSkater PickExtraSkater_decl
#include "nhl95.h"
#undef PickForLineSlot
#undef CanFillLineSlot
#undef PickExtraSkater

short CanFillLineSlot(int side, int slot, int player);

/* DRAFT under 10.0 GA: 20 differing instructions, original size. The start/position slots and
   two call argument register choices remain. Owner of the lines_popx2 tail (PickExtraSkater). */
/* PickForLineSlot (64E60, PC only): choose a player for line slot slot of team side (home hmlinetab, away
   awlinetab). First the players of the slots after slot in its lineslotgroups group (from lineslotgroupstart[slot], up to the
   -1 end) that CanFillLineSlot allows. Else by the position letter of the slot's current player (hmrosterpos)
   the first FillDressedSlots result from the side's 25-byte lists: D the E9D50 list for slots 12h-1Bh, else
   E9DB4; C the E9CEC, E9DE6 and E9EAE lists, R E9EAE, E9DE6, E9CEC, L E9DE6, E9EAE, E9CEC (from slot 1Ch on
   E9D82, E9E7C and E9D1E instead). Else the group's players from its start up to slot, then the first player
   of two more lists (by the letter and slot: E9D50 / E9DB4 and E9E4A / E9EE0, in either order) that
   CanFillLineSlot allows. Result: the player (a short), or 0. */
short PickForLineSlot(short side, short slot)
{
    short pos;
    short start;
    signed char *tab;
    short i;
    short p;
    short r;
    signed char *list;

    tab = (signed char *)(side ? awlinetab : hmlinetab);
    i = start = lineslotgroupstart[slot];
    while (lineslotgroups[i++] != slot);
    while (lineslotgroups[i] >= 0) {
        p = tab[lineslotgroups[i]];
        if (CanFillLineSlot(side, slot, tab[lineslotgroups[i]])) return p;
        i++;
    }
    pos = hmrosterpos[side * 0x444 + tab[slot] * 39];
    if (pos == 'D') {
        r = FillDressedSlots(slot < 0x1C && slot >= 0x12 ? (signed char *)offsort_d + side * 25 : defsort_d + side * 25, side, slot);
        if (r >= 0) return r;
    } else if (pos == 'C') {
        p = FillDressedSlots(slot < 0x1C ? (signed char *)offsort_c + side * 25 : (signed char *)defsort_c + side * 25, side, slot);
        if (p >= 0) return p;
        p = FillDressedSlots(slot < 0x1C ? (signed char *)offsort_l + side * 25 : (signed char *)defsort_l + side * 25, side, slot);
        if (p >= 0) return p;
        p = FillDressedSlots(slot < 0x1C ? (signed char *)offsort_r + side * 25 : (signed char *)defsort_r + side * 25, side, slot);
        if (p >= 0) return p;
    } else if (pos == 'R') {
        p = FillDressedSlots(slot < 0x1C ? (signed char *)offsort_r + side * 25 : (signed char *)defsort_r + side * 25, side, slot);
        if (p >= 0) return p;
        p = FillDressedSlots(slot < 0x1C ? (signed char *)offsort_l + side * 25 : (signed char *)defsort_l + side * 25, side, slot);
        if (p >= 0) return p;
        p = FillDressedSlots(slot < 0x1C ? (signed char *)offsort_c + side * 25 : (signed char *)defsort_c + side * 25, side, slot);
        if (p >= 0) return p;
    } else if (pos == 'L') {
        p = FillDressedSlots(slot < 0x1C ? (signed char *)offsort_l + side * 25 : (signed char *)defsort_l + side * 25, side, slot);
        if (p >= 0) return p;
        p = FillDressedSlots(slot < 0x1C ? (signed char *)offsort_r + side * 25 : (signed char *)defsort_r + side * 25, side, slot);
        if (p >= 0) return p;
        p = FillDressedSlots(slot < 0x1C ? (signed char *)offsort_c + side * 25 : (signed char *)defsort_c + side * 25, side, slot);
        if (p >= 0) return p;
    }
    i = start;
    while (lineslotgroups[i] != slot) {
        p = tab[lineslotgroups[i]];
        if (CanFillLineSlot(side, slot, tab[lineslotgroups[i]])) return p;
        i++;
    }
    if (pos == 'D')
        list = slot >= 0x12 && slot < 0x1C ? (signed char *)offsort_d + side * 25 : defsort_d + side * 25;
    else
        list = slot < 0x1C ? offsort_fwd + side * 25 : (signed char *)defsort_fwd + side * 25;
    i = 0;
    for (; i < 0x19; i++) {
        p = list[i];
        if (p < 0) break;
        if (CanFillLineSlot(side, slot, p)) return p;
    }
    if (pos == 'D')
        list = slot >= 0x12 && slot < 0x1C ? offsort_fwd + side * 25 : (signed char *)defsort_fwd + side * 25;
    else
        list = slot < 0x1C ? (signed char *)offsort_d + side * 25 : defsort_d + side * 25;
    i = 0;
    for (; i < 0x19; i++) {
        p = list[i];
        if (p < 0) break;
        if (CanFillLineSlot(side, slot, p)) return p;
    }
    return 0;
}

/* PickExtraSkater (653BE, PC only): fill the extra-skater slots 26h / 27h of team side's line table (home
   hmlinetab, away awlinetab). A player counts when dressbystatus of the status byte of that player's 27h-byte
   roster record (hmroster, 444h per team) is 1. For slot 26h: the player in slot 27h if counted, else the first
   counted one of the side's 25-byte offsort_fwd list (up to a negative entry). Then slot 27h gets the first
   counted player of that list who is not in slot 26h. side, slot: shorts. No result; the exit is
   PickForLineSlot's (lines_popx2). */
void PickExtraSkater(short side, short slot)
{
    signed char *tab;
    signed char *list;
    short i;
    short p;

    tab = (signed char *)(side ? awlinetab : hmlinetab);
    list = offsort_fwd + side * 25;
    if (slot == 0x26) {
        p = tab[0x27];
        if (dressbystatus[hmroster[side * 0x444 + p * 39]] == 1) {
            tab[0x26] = p;
        } else {
            for (i = 0; i < 0x19; i++) {
                p = list[i];
                if (p < 0) break;
                if (dressbystatus[hmroster[side * 0x444 + p * 39]] == 1) {
                    tab[0x26] = p;
                    break;
                }
            }
        }
    }
    list = offsort_fwd + side * 25;
    for (i = 0; i < 0x19; i++) {
        p = list[i];
        if (p < 0) break;
        if (dressbystatus[hmroster[side * 0x444 + p * 39]] == 1 && p != tab[0x26]) {
            tab[0x27] = p;
            break;
        }
    }
}
