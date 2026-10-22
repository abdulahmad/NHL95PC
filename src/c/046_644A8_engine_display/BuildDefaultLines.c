/* Engine display: default lines, built from the rosters. */
#include "nhl95.h"

/* BuildDefaultLines (64614, PC only; owner of lines_popx): build both teams' default lines from their rosters.
   For each side and each of the 25 roster players (hmroster / awroster status, 0 / 1 not dressed): an offence
   rating (bytes 1, 2, 4, 6, 9, 0Ah, 3, 0Dh of his rating record at unk_DACA0) and a defence rating (1, 2, 4, 6,
   9, 0Bh, 5, 0Ch, 3, 0Dh); then the players sorted by position and rating into the line tables
   (SortPlayersByPos, SortNonDefPlayers), the dressed flags (byte_E9E18 from byte_CD418 by status) and the
   players in the line slots (hmlinetab / awlinetab, 12h) marked as not dressed spares. No arguments, no
   result. */
void BuildDefaultLines(void)
{
    short def[2][25];
    short off[2][25];
    short side;
    short i;
    unsigned char st;
    unsigned char *r;
    unsigned char *lt;

    for (side = 0; side < 2; side++) {
        for (i = 0; i < 25; i++) {
            st = hmroster[side * 0x444 + i * 0x27];
            if (st == 0 || st == 1) {
                off[side][i] = def[side][i] = -1;
            } else {
                r = unk_DACA0 + side * 0x1F4 + i * 0x14;
                off[side][i] = r[1] + r[2] + r[4] + r[6] + r[9] + r[0xA] + r[3] + r[0xD];
                def[side][i] = r[1] + r[2] + r[4] + r[6] + r[9] + r[0xB] + r[5] + r[0xC] + r[3] + r[0xD];
            }
        }
        SortPlayersByPos(side, (signed char *)unk_E9D50 + side * 25, off[side], 0x44);
        SortPlayersByPos(side, (signed char *)unk_E9EAE + side * 25, off[side], 0x52);
        SortPlayersByPos(side, (signed char *)unk_E9DE6 + side * 25, off[side], 0x4C);
        SortPlayersByPos(side, (signed char *)unk_E9CEC + side * 25, off[side], 0x43);
        SortPlayersByPos(side, byte_E9DB4 + side * 25, def[side], 0x44);
        SortPlayersByPos(side, (signed char *)unk_E9D1E + side * 25, def[side], 0x52);
        SortPlayersByPos(side, (signed char *)unk_E9E7C + side * 25, def[side], 0x4C);
        SortPlayersByPos(side, (signed char *)unk_E9D82 + side * 25, def[side], 0x43);
        SortNonDefPlayers(side, byte_E9E4A + side * 25, off[side]);
        SortNonDefPlayers(side, (signed char *)unk_E9EE0 + side * 25, def[side]);
        for (i = 0; i < 25; i++) byte_E9E18[side * 25 + i] = byte_CD418[hmroster[side * 0x444 + i * 0x27]];
        lt = side ? awlinetab : hmlinetab;
        for (i = 0; i < 0x12; i++) byte_E9E18[side * 25 + *(signed char *)lt++] = 0;
    }
}

/* CanRemovePlayer (65B83, PC only; ends in lines_popx): may player p leave his team's dressed lineup? Count the
   dressed players (roster status 3 or 4) in his group: when p is in the forwards list (byte_E9DB4) more than two
   must be dressed, else more than four defencemen (byte_E9E4A). p: the player. Result: 1 when he can go, else 0. */
int CanRemovePlayer(Player *p)
{
    short found;
    short side;
    short n;
    short i;
    short k;
    short st;

    found = 0;
    side = (p->pflags & 0x40) != 0;
    for (n = 0, i = 0; i < 25; i++) {
        k = byte_E9DB4[side * 25 + i];
        if (k < 0) break;
        if (k == p->pnum) found = 1;
        st = hmroster[side * 0x444 + k * 0x27];
        if (st == 4 || st == 3) n++;
    }
    if (found) return n > 2;
    for (n = 0, i = 0; i < 25; i++) {
        k = byte_E9E4A[i + side * 25];
        if (k < 0) break;
        st = hmroster[side * 0x444 + k * 0x27];
        if (st == 4 || st == 3) n++;
    }
    return n > 4;
}

/* SetupTeamLines (658F3, PC only; ends in lines_popx): check side's lines against its dressed players. Count the
   dressed forwards (byte_E9DB4 list, byte_CD418 of the roster status 1) into word_E9F14 and defencemen
   (byte_E9E4A) into word_E9F12, their sum into dword_E9F16; mark every player in a line slot (the 24h skater
   slots of hmlinetab / awlinetab and the two goalie slots +26h / +27h) in dword_E9C24 and take the undressed
   ones (status 0 / 1) out of the lines (RemoveFromLines); refill an empty goalie slot (24h, PickGoalie forced);
   finally byte_E9E18 becomes 1 for the dressed players only. side: 0 home, 1 away. No result. */
void SetupTeamLines(short side)
{
    short i;
    unsigned char *lt;
    short k;
    short st;

    lt = side ? awlinetab : hmlinetab;
    word_E9F14 = 0;
    for (i = 0; i < 25; i++) {
        k = byte_E9DB4[side * 25 + i];
        if (k < 0) break;
        if (byte_CD418[hmroster[side * 0x444 + k * 0x27]] == 1) word_E9F14++;
    }
    word_E9F12 = 0;
    for (i = 0; i < 25; i++) {
        k = byte_E9E4A[i + side * 25];
        if (k < 0) break;
        if (byte_CD418[hmroster[side * 0x444 + k * 0x27]] == 1) word_E9F12++;
    }
    *(short *)dword_E9F16 = word_E9F12 + word_E9F14;
    for (i = 0; i < 25; i++) dword_E9C24[i] = 0;
    for (i = 0; i < 0x24; i++) dword_E9C24[((signed char *)lt)[i]] = 1;
    dword_E9C24[((signed char *)lt)[0x27]] = 1;
    dword_E9C24[((signed char *)lt)[0x26]] = 1;
    for (i = 0; i < 25; i++) {
        st = hmroster[side * 0x444 + i * 0x27];
        if (dword_E9C24[i] && (unsigned short)(st == 0 || st == 1)) RemoveFromLines(side, i);
    }
    for (i = 0x24; i < 0x25; i++) {
        st = hmroster[((signed char *)lt)[i] * 0x27 + side * 0x444];
        if (st == 0 || st == 1) PickGoalie(side, i, 1);
    }
    for (i = 0; i < 25; i++) byte_E9E18[i + side * 25] = byte_E9E18[side * 25 + i] == 1;
}
