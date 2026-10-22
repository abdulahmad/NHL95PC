/* Create player: roster list click. */
#include "nhl95.h"

#define INVERT ((void (__cdecl *)(int x, int y, int w, int h, int col))sub_90F38)

/* RosterPanelClick: x in the left list (23h..113h) is side 0, x in the right list (15Eh..24Eh)
 is side 1. A y in the 28 rows under 35h, each byte_D42C3 tall, toggles that row. A free-agent
 list toggles falistsel[scroll + row] when the row is on screen. A team list toggles
 rostersel[side * 28 + row] when that rosterlist entry is filled. Then, if the list has a
 selection, point the move-to-free-agents item at MoveToFreeAgents when the other pool has
 room, and the move-to-the-other-roster item at MoveToOtherRoster when the other side is not
 itself the free-agent list. An empty selection clears both items. */
void RosterPanelClick(int x, int y)
{
    int side;
    int h;
    int row;
    int rowy;

    side = -1;
    if (x >= 0x23 && x <= 0x113) side = 0;
    else if (x >= 0x15E && x <= 0x24E) side = 1;
    if (side < 0) return;
    if (y >= 0x35) {
    h = byte_D42C3;
    if (y < h * 28 + 0x35) {
        row = (y - 0x35) / h;
        rowy = row * h + 0x35;
        if (rosterisfa[side] == 1) {
            if (dword_EBCA4 + row < facount) {
                unsigned char *fa;

                INVERT(side ? 0x15E : 0x23, rowy, 0xF0, h, 0x80);
                row += dword_EBCA4;
                fa = (unsigned char *)falistsel;
                fa[row] = ~fa[row];
            }
        } else {
            int base;

            base = side * 756;
            if (rosterlist[base + row * 27]) {
                INVERT(side ? 0x15E : 0x23, rowy, 0xF0, h, 0x80);
                rostersel[side * 28 + row] = ~rostersel[side * 28 + row];
            }
        }
    }
    }
    if (CountSelected(rosterisfa[side] == 1 ? (char *)falistsel : (char *)&rostersel[side * 28]) > 0) {
        if (side == 0) {
            if (rosterisfa[0] != 1 && facount < 0x1E)
                *(void (**)(int *, int *, int *))&menu_r1_tofa = MoveToFreeAgents;
            if (rosterisfa[1] != 1)
                *(void (**)())&menu_r1_toroster2 = MoveToOtherRoster;
        } else {
            if (rosterisfa[1] != 1 && facount < 0x1E)
                *(void (**)(int *, int *, int *))&menu_r2_tofa = MoveToFreeAgents;
            if (rosterisfa[0] != 1)
                *(void (**)())&menu_r2_toroster1 = MoveToOtherRoster;
        }
    } else if (side == 0) {
        menu_r1_tofa = side;
        menu_r1_toroster2 = side;
    } else {
        menu_r2_tofa = 0;
        menu_r2_toroster1 = 0;
    }
}

/* FixJerseyNumber (6DCBE, PC only; ends in RosterPanelClick_ret): a player moved onto a team (roster side, entry
   slot; roster entries are 1Bh bytes, 2F4h per side: jersey byte, then the KEY slot byte) whose jersey number is
   already used by another of the 28 entries is asked for a new one ("The jersey number %2d is already used!" /
   "Please enter a new jersey number for" / his name, InputDialog), until it is free; the number goes into his KEY
   record (+1) and the roster entry. side: the roster side; slot: the entry. No result.
   Matched under 10.0 GA with the counter i declared first: the duplicate loop then keeps side * 2F4h in esi and
   the slot entry in ecx, and compares through bl, as in the EXE. */
void FixJerseyNumber(int side, int slot)
{
    int i;
    int k;
    int *tr;
    char msg[0x54];
    char name[0x20];
    char answer[4];
    unsigned char *rec;
    int dup;

    k = rosterslot[side * 0x2F4 + slot * 0x1B];
    tr = (int *)rosterteamrec[side];
    rec = KeyDbPtr(tr[k + 0x13]);
    do {
        dup = 0;
        for (i = 0; i < 0x1C && !dup; i++)
            if (i != slot && rosterjersey[side * 0x2F4 + slot * 0x1B] == rosterjersey[side * 0x2F4 + i * 0x1B]) dup = -1;
        if (dup) {
            strcpy(name, (char *)rec + 3);
            strcat(name, (char *)&str_space);
            strcat(name, (char *)rec + 0x13);
            sprintf(msg, (char *)str_TheJerseyNumber2d, rec[1]);
            msglines[0] = (int)msg;
            msglines[1] = (int)str_PleaseEnterANew;
            msglines[2] = (int)name;
            answer[0] = 0;
            rec[1] = InputDialog(msglines, 3, answer, 2, 0x16, -1, 0, 0x63, -1);
            rosterjersey[side * 0x2F4 + slot * 0x1B] = rec[1];
        }
    } while (dup);
}
