/* Front-end labels: the screen title in the menu bars. */
#include "nhl95.h"

/* SetScreenTitle (1D610) - PC only: put the title of screen n (0 Sports Central, 1 Playoff Tree, 2 League
   Calendar, 3 Broadcast Booth, 4 Intermission Desk, 5 Rink Side) and its pixel width into the title items of
   the menu bars (off_CF51F ...: text, dword_CF517 / CF5D7: width); the other bars get the width clamped to at
   least 7Dh. Another n leaves the registers as they were (no default in the original). */
void SetScreenTitle(int n)
{
    int width;
    unsigned char *title;

    switch (n) {
    case 0:
        title = str_SportsCentral;
        width = 0x67;
        break;
    case 2:
        title = str_LeagueCalendar;
        width = 0x76;
        break;
    case 1:
        title = str_PlayoffTree;
        width = 0x59;
        break;
    case 3:
        title = str_BroadcastBooth;
        width = 0x73;
        break;
    case 4:
        title = str_IntermissionDesk;
        width = 0x7E;
        break;
    case 5:
        title = str_RinkSide;
        width = 0x41;
        break;
    }
    off_CF67F = (int)title;
    off_CF61F = (int)title;
    off_CF5DF = (int)title;
    off_CF51F = (int)title;
    dword_CF5D7 = width;
    dword_CF517 = width;
    if (width <= 0x7D) width = 0x7D;
    dword_CF677 = width;
    dword_CF657 = width;
    dword_CF637 = width;
    dword_CF617 = width;
    dword_CF5F7 = width;
}
