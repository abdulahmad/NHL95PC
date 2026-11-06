/* Roster and jersey: trade screen hit test. */
#define TradeHitTest TradeHitTestDecl
#include "nhl95.h"
#undef TradeHitTest

/* TradeHitTest: x is tested 4 pixels to the right. A point over the four trade buttons (tradebtnx/y,
 3Ah by 28h, stride 8) writes the button into out[slot], or when slot is negative writes slot/2 and
 sets flag to -1. A point in the roster columns (y at least 1Dh, under byte_D42C3 * 28 rows) writes
 the side (x past BEh) into slot and the row + 64h into out[slot]. Returns 1 for a hit.
 The button edges are read in place, and each branch sets hit (Watcom merges the two stores into one). */
int TradeHitTest(int x, int y, int *out, int *slot, int *flag)
{
    int hit;
    int i;
    int row;
    int e;

    hit = 0;
    *flag = hit;
    x += 4;
    if (x > 0xBE && x < 0x1C0) {
        for (i = 0; i < 4; i++) {
            if (x < tradebtnx[i * 2]) continue;
            if (x >= tradebtnx[i * 2] + 0x3A) continue;
            if (y < tradebtny[i * 2]) continue;
            if (y >= tradebtny[i * 2] + 0x28) continue;
            if (*slot >= 0) {
                out[*slot] = i;
                hit = 1;
            } else {
                *slot = i / 2;
                out[*slot] = i;
                *flag = -1;
                hit = 1;
            }
        }
    } else if (y >= 0x1D) {
        if (y < byte_D42C3 * 28 + 0x1D) {
            *slot = x >= 0xBE;
            e = byte_D42C3;
            row = (y - 0x1D) / e;
            out[*slot] = row + 0x64;
            hit = 1;
        }
    }
    return hit;
}

/* TradeScreen (3FF52, PC only; ends in TradeHitTest_ret): the trade screen of league dir between teams[0] and
   teams[1]. Fade to the black "Temp" palette, clear the screen bitmap (dword_DE264), save the text state, load the
   S12 font and the lineditp bank ("Shrt" art), reset the cursors and clicks (tradecursor, tradeclick, tradeside -1)
   and build both trade rosters (BuildTradeRoster into traderoster / +268h, the team records into recs); when both
   load, sort them (TradeRosterCmp) and run the screen (TradeScreenLoop). Then free the bank, restore the text
   state and free the font. dir: the league dir; teams: the two teams; b, c, d: passed on to TradeScreenLoop.
   Result: BuildTradeRoster's error, else TradeScreenLoop's result.
   Matched under 10.0 GA with the locals declared bank, recs, state, path, r, font, shape (the EXE's slots: shape
   +620h, b +624h, c +628h, bank +62Ch, font +630h). */
int TradeScreen(char *dir, int *teams, int b, int c, int d)
{
    int bank;
    unsigned char recs[0x5D0];
    unsigned char state[0x40];
    char path[0x10];
    int r;
    int font;
    int shape;

    sub_B4BA8();
    r = sub_8CCA8((char *)str_Temp6, 0x300, 0x20);
    sub_8FFB0(0, 0x100, (unsigned char *)r);
    FadePalStep(1, (unsigned char *)r, 0x10);
    FreeMemBlock(r);
    SetDrawBitmap(dword_DE264);
    sub_B392C(0);
    sub_8E9E8(state);
    MakePath(path, fileoncd[0xE7] == 1 ? (char *)cddriveptr : 0, (char *)str_S12, (char *)str_VFN);
    font = sub_8E8A0(path, 0);
    sub_8EA18(font);
    MakePath(path, fileoncd[0xE8] == 1 ? (char *)cddriveptr : 0, (char *)str_Lineditp, 0);
    bank = sub_8E83C(path, 0);
    shape = sub_B30B4(bank, (char *)str_Shrt);
    tradeside = tradeclick[1] = tradeclick[0] = tradecursor[1] = tradecursor[0] = -1;
    r = BuildTradeRoster(dir, teams[0], traderoster, recs);
    if (!r) r = BuildTradeRoster(dir, teams[1], traderoster + 0x268, recs + 0x2E8);
    if (!r) {
        qsort(traderoster, 0x1C, 0x16, (int (*)(const void *, const void *))TradeRosterCmp);
        qsort(traderoster + 0x268, 0x1C, 0x16, (int (*)(const void *, const void *))TradeRosterCmp);
        r = ((int (*)(int, unsigned char *, int *, int, int, int, int, int))TradeScreenLoop)(shape, recs, teams, b, c, bank, font, d);
    }
    FreeMemBlock(bank);
    sub_8EA00(state);
    FreeMemBlock(font);
    return r;
}
