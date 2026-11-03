/* Engine display: whether a roster player can take a line slot. */
#define CanFillLineSlot CanFillLineSlot_decl
#include "nhl95.h"
#undef CanFillLineSlot

/* CanFillLineSlot: side 0 is hmlinetab, anything else awlinetab. The roster byte at
 side*444h + player*39 selects a position class in byte_CD418. Class 0 cannot play.
 Class 2 can play only when byte_E9E18[side*25 + player] is 2. Forwards (slots 0-0Bh)
 may already occupy one other slot of a different line-trio third, unless word_E9F12 is
 above 6. Defence pairs (0Ch-11h) are the same with word_E9F14 and a limit of one.
 Slots 12h-1Bh and 1Ch-23h then scan a window that skips the slot itself and its pair
 (slot+5 or slot+4). Returns 0 when the player is already in that window, else 1.
 The position byte read for the window choice is byte_DB3AE. */
int CanFillLineSlot(short side, short slot, short player)
{
    signed char *tab;
    int sidev;
    short st;
    short pos;
    short result;

    tab = (signed char *)(side ? awlinetab : hmlinetab);
    sidev = (short)side;
    {
        unsigned char *row;

        row = hmroster + sidev * 0x444;
        st = byte_CD418[row[(short)player * 39]];
    }
    if (st == 0) {
zero:
        result = 0;
        goto out;
    }
    if (st == 2 && byte_E9E18[sidev * 25 + (short)player] != 2)
        goto zero;
    pos = byte_DB3AE[(short)side * 0x444 + (short)player * 39];
    {
    short i;
    short n;
    short from;
    short to;

    if (slot < 0x0C) {
        n = 0;
        for (i = 0; i < 0x0C; i++) {
            if (i % 3 != slot % 3 || i < slot) {
                if ((short)tab[i] == player)
                    n++;
            }
        }
        if (n >= 2 && word_E9F12 > 6)
            goto zero;
        from = (slot / 3) * 3;
        to = from + 2;
    } else if (slot < 0x12) {
        if (word_E9F14 >= 3) {
            n = 0;
            for (i = 0x0C; i < 0x12; i++) {
                if (i % 2 != slot % 2 || i < slot) {
                    if ((short)tab[i] == player)
                        n++;
                }
            }
            if (n >= 2)
                goto zero;
        }
        from = slot & ~1;
        to = from + 1;
    } else if (slot < 0x1C) {
        if ((pos == 0x44 && word_E9F14 < 4) || (pos != 0x44 && word_E9F12 < 6)) {
            from = slot < 0x17 ? 0x12 : 0x17;
            to = from + 4;
        } else {
            from = 0x12;
            to = 0x1B;
        }
    } else if (pos == 0x44 && word_E9F14 < 4) {
        from = slot < 0x20 ? 0x1C : 0x20;
        to = from + 3;
    } else {
        from = 0x1C;
        to = 0x23;
    }
    for (i = from; i <= to; i++) {
        if (i == slot)
            continue;
        if (slot >= 0x1C) {
            if (i == slot + 4)
                continue;
        } else if (slot >= 0x12) {
            if (i == slot + 5)
                continue;
        }
        if ((short)tab[i] == player) {
            result = (short)tab[i] ^ player;
            goto out;
        }
    }
    result = 1;
    goto out;
    }
out:
    return result;
}

/* FillDressedSlots (64CA8, PC only; ends in lines_addesp10_x): find a player from a dressed list for line slot
   slot of team side: the first entry (up to 19h, the list ends with a negative byte) that is dressed
   (byte_E9E18 of the team) and fits the slot (CanFillLineSlot). A player still marked 2 (dressed but not on the
   roster yet) is taken only while fewer than 18 are dressed (dword_E9F16) and, unless a defenceman, fewer than
   12 forwards (word_E9F12): his roster status becomes 3, he leaves the extra slots 28h-2Fh of the line table, his
   flag becomes 1 and the dressed / defence or forward counts go up. list: the dressed list; side: the team;
   slot: the line slot. Result: the roster index, or -1.
   DRAFT: 440 vs 440, same instructions; only the stack slots differ (original side +0, r +4, slot +8, i +0Ch;
   here i +4, r +8, slot +0Ch). See docs/UNSURE.md. */
short FillDressedSlots(signed char *list, short side, short slot)
{
    short r;
    short i;
    signed char *lt;
    short k;

    for (i = 0; i < 0x19 && (r = list[i]) >= 0; i++) {
        if (!byte_E9E18[side * 0x19 + r]) continue;
        if (!(short)CanFillLineSlot(side, slot, r)) continue;
        if (byte_E9E18[side * 0x19 + r] == 2) {
            if (*(short *)dword_E9F16 >= 0x12) continue;
            if (byte_DB3AE[side * 0x444 + r * 0x27] != 'D' && word_E9F12 >= 0xC) continue;
            hmroster[side * 0x444 + r * 0x27] = 3;
            lt = (signed char *)(side ? awlinetab : hmlinetab);
            for (k = 0x28; k < 0x30; k++)
                if (lt[k] == r) lt[k] = 0x64;
            byte_E9E18[side * 0x19 + r] = 1;
            (*(short *)dword_E9F16)++;
            if (byte_DB3AE[side * 0x444 + r * 0x27] == 'D') word_E9F14++;
            else word_E9F12++;
        }
        return r;
    }
    return -1;
}
