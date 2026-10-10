/* Front end: sports desk items that end in DeskScoringSummary's tail (DeskItem_ret2). */
#include "nhl95.h"

/* Draft group: each body matches on its own when placed in DeskScoringSummary.c, but the shared tail does not.
   In the EXE all four jump FORWARD (jmp near) to DeskItem_ret2 inside DeskScoringSummary, and DeskVisitorLines
   jumps back to DeskLines_common in DeskHomeLines. In DeskScoringSummary.c, Watcom merges each "mov eax, 2 /
   pop edx / pop ecx / pop ebx / ret" into the nearest tail compiled so far, which is the next function in the list,
   and it also changes DeskTeamScratches. See HANDOFF "forward jumps". */

/* DeskGoToReplay (1A817) - sports desk instant replay: load the home team's rink (entry 12 for team 26 and up)
   and the player photos, save the palette and fade out, back to the 320x200 screen, InstantReplay(0), restore the
   s1 font, then flag a redraw (dword_C66D0 / dword_C66D4). Returns 2. */
int DeskGoToReplay(void)
{
    LoadRink(HomeTeam >= 26 ? 12 : HomeTeam);
    LoadPlayerPhotos();
    sub_8FFB0(0, 0x100, savepal);
    FadePalette(1, savepal, 0x10);
    SetScreenSize(0x140, 0xC8);
    InstantReplay(0);
    sub_8EA18(s1font);
    dword_C66D0 = dword_C66D4 = 1;
    return 2;
}

/* DeskHomeLines (1A8AA) - sports desk home lines: save the palette, fade out, GameLineEditor for the home team
   (hmlinetab), then save and fade again. Returns 2. */
int DeskHomeLines(void)
{
    sub_8FFB0(0, 0x100, savepal);
    FadePalStep(1, savepal, 0x10);
    GameLineEditor(0, hmlinetab, unk_CF2EF, 2);
    sub_8FFB0(0, 0x100, savepal);
    FadePalStep(1, savepal, 0x10);
    return 2;
}

/* DeskVisitorLines (1A922) - as DeskHomeLines for the visitors (awlinetab). Returns 2. */
int DeskVisitorLines(void)
{
    sub_8FFB0(0, 0x100, savepal);
    FadePalStep(1, savepal, 0x10);
    GameLineEditor(1, awlinetab, unk_CF2EF, 2);
    sub_8FFB0(0, 0x100, savepal);
    FadePalStep(1, savepal, 0x10);
    return 2;
}

/* DeskGameStats (1A96D) - sports desk game stats: save the palette, fade out, GameStatsScreen. Returns 2. */
int DeskGameStats(void)
{
    sub_8FFB0(0, 0x100, savepal);
    FadePalStep(1, savepal, 0x10);
    GameStatsScreen();
    return 2;
}
