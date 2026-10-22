/* Line editor: show the selected player's season stats. */
#define MenuShowPlayerStats MenuShowPlayerStats_decl
#define RunMenu RunMenu_decl
#define DressPlayer DressPlayer_decl
#define ScratchPlayer ScratchPlayer_decl
#define LineEdDone LineEdDone_decl
#define CheckRosterComplete CheckRosterComplete_decl
#include "nhl95.h"
#undef MenuShowPlayerStats
#undef RunMenu
#undef DressPlayer
#undef ScratchPlayer
#undef LineEdDone
#undef CheckRosterComplete

int CheckRosterComplete(int x, int y, int team);

void RunMenu(void *bar, int n, int col1, int col2, int col3);

/* MenuShowPlayerStats: line-editor menu action. nums is the 28h jersey numbers, side is the roster,
 sel points at the roster row (negative skips the status line). Loads the player, skater and goalie
 stat shapes, runs the stats menu, then redraws the line editor and prints "<num> <name>" for that
 row. A scratched player (status 2) uses colour 7Eh. Returns 0. The caller passes six stack arguments;
 the last two are unused here. */
int MenuShowPlayerStats(unsigned char *nums, int ignored, unsigned char side, int *sel, int art,
                        int zero, int buttons, int extra, int u1, int u2)
{
    char buf[32];
    int z;

    statsplayerbuf = (unsigned char *)sub_8CCA8((char *)str_Keys3, 0x5B0, 0);
    rosterpstat = (unsigned char *)sub_8CCA8((char *)str_Pstat3, 0x497, 0);
    rostergstat = (unsigned char *)sub_8CCA8((char *)str_Gstat3, 0x10E, 0);
    ShowRosterStats(0xC0, 0xC1, 0xC2, 0xC3);
    RunMenu(unk_D075E, 2, 0xC0, 0xC1, 0xC2);
    FreeMemBlock((int)rostergstat);
    FreeMemBlock((int)rosterpstat);
    FreeMemBlock((int)statsplayerbuf);
    z = 0;
    statsplayerbuf = (unsigned char *)z;
    rostergstat = (unsigned char *)z;
    rosterpstat = (unsigned char *)z;
    SetDrawBitmap(fullscrbmp);
    sub_B392C(z);
    DrawLineEditorScreen(side, art, zero, buttons, extra);
    DrawLineJerseys(nums, art, side);
    sub_B4BA8();
    sub_9121C(((int *)fullscrbmp)[0x2C / 4]);
    if (*(volatile int *)sel >= 0) {
        if (rosterstat[side * 0x2F4 + *sel * 27] == 2)
            sub_8E9C0(0x7E, 0xC1);
        else
            sub_8E9C0(0xC0, 0xC1);
        sprintf(buf, (char *)str_C2dS2, rosterlist[side * 0x2F4 + *sel * 27],
                rosterjersey[side * 0x2F4 + *sel * 27], rosterlist + side * 0x2F4 + *sel * 27 + 8);
        PrintLineEdStatus(0x1FA, *sel * 13 + 0x16, buf);
    }
    return 0;
}

/* ScratchPlayer: line-editor menu action. Any jersey number in nums that matches the selected
   player's is replaced with 0x64, the row is marked scratched (status 2), and the status line
   is the same tail as MenuShowPlayerStats (MenuShowPlayerStats_status). */
int ScratchPlayer(unsigned char *nums, int ignored, unsigned char side, int *sel, int art,
                  int zero, int buttons, int extra, int u1, int u2)
{
    char buf[32];
    int i;

    (void)ignored;
    (void)zero;
    (void)buttons;
    (void)extra;
    (void)u1;
    (void)u2;
    for (i = 0; i < 0x28; i++) {
        if (nums[i] == rosterjersey[side * 0x2F4 + *sel * 27])
            nums[i] = 0x64;
    }
    rosterstat[side * 0x2F4 + *sel * 27] = 2;
    DrawLineJerseys(nums, art, side);
    sub_8E9C0(0xFD, 0xC1);
    sprintf(buf, (char *)str_C2dS2, rosterlist[side * 0x2F4 + *sel * 27],
            rosterjersey[side * 0x2F4 + *sel * 27],
            rosterlist + side * 0x2F4 + *sel * 27 + 8);
    PrintLineEdStatus(0x1FA, *sel * 13 + 0x16, buf);
    return 0;
}

/* DressPlayer: line-editor menu action. Marks the selected roster row as dressed (status 3),
   redraws the jerseys, and prints the same "<num> <name>" status line as MenuShowPlayerStats.
   The exit pops land in MenuShowPlayerStats_ret (ret 18h), so the stack arguments match. */
int DressPlayer(unsigned char *nums, int ignored, unsigned char side, int *sel, int art,
                int zero, int buttons, int extra, int u1, int u2)
{
    char buf[32];

    (void)ignored;
    (void)zero;
    (void)buttons;
    (void)extra;
    (void)u1;
    (void)u2;
    rosterstat[side * 0x2F4 + *sel * 27] = 3;
    DrawLineJerseys(nums, art, side);
    sub_8E9C0(0xC0, 0xC1);
    sprintf(buf, (char *)str_C2dS2, rosterlist[side * 0x2F4 + *sel * 27],
            rosterjersey[side * 0x2F4 + *sel * 27],
            rosterlist + side * 0x2F4 + *sel * 27 + 8);
    PrintLineEdStatus(0x1FA, *sel * 13 + 0x16, buf);
    return 0;
}

/* LineEdDone: copy the dressed line into the team record.
   DRAFT: 280 vs 280 (10.0 GA). The jersey pointer is lea ebx / [ebx] where the original is
   lea ecx / [ecx], and the inner counter is ebx and the side stride is ecx (original ecx and
   ebx); the scratch loop matches. Do not retry a named row for the jersey index (it becomes
   lea ecx, [ebx+eax]) or n++ inside the subscript (it copies n to edx before the inc).
   nums is the 28h edited jerseys, lines is
   the 30h-byte line (28 jersey slots, then 8 scratch slots). A 64h jersey is copied straight across;
   any other jersey is replaced by the roster slot of the dressed player who wears it. Scratch slots
   are filled with players whose status is neither 0 nor 3. Then 48 bytes at rosterteamrec+0BCh are
   copied to +0ECh. Returns 0 when CheckRosterComplete says the roster is short. The exit is
   MenuShowPlayerStats_ret. */
int LineEdDone(unsigned char *nums, unsigned char *lines, unsigned char side, int ignored,
               int a, int b, int c, int d, int x, int y)
{
    unsigned char *rec;
    unsigned char *p;
    int i;

    (void)ignored;
    (void)a;
    (void)b;
    (void)c;
    (void)d;
    if (CheckRosterComplete(x, y, side))
        return 0;
    for (i = 0; i < 0x28; i++) {
        int stride;
        int j;

        p = nums + i;
        if (*p == 0x64) {
            lines[i] = *p;
            continue;
        }
        for (j = 0; j < 0x1C; j++) {
            stride = side * 0x2F4;
            if (rosterstat[stride + j * 27] != 0 && nums[i] == rosterjersey[stride + j * 27]) {
                lines[i] = rosterslot[stride + j * 27];
                break;
            }
        }
    }
    for (i = 0; i < 8; i++)
        lines[i + 0x28] = 0x64;
    {
        int n;
        int stride;
        int row;

        i = 0;
        n = 0;
        for (; i < 0x1C; i++) {
            stride = side * 0x2F4;
            row = stride + i * 27;
            if (rosterstat[row] != 0 && rosterstat[row] != 3) {
                lines[0x28 + n] = rosterslot[row];
                n++;
            }
        }
    }
    rec = (unsigned char *)rosterteamrec[side];
    {
        typedef struct { int w[12]; } Block;
        *(Block *)(rec + 0xEC) = *(Block *)(rec + 0xBC);
    }
    return 1;
}
