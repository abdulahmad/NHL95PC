/* Front-end labels: the screen title in the menu bars. */
#include "nhl95.h"

/* SetScreenTitle: put the title of screen n (0 Sports Central, 1 Playoff Tree, 2 League
 Calendar, 3 Broadcast Booth, 4 Intermission Desk, 5 Rink Side) and its pixel width into the title items of
 the menu bars (StatsReturnText...: text, StatsReturnRight CF5D7: width); the other bars get the width clamped to at
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
    PlayerCardReturnDeskText = (int)title;
    RosterReturnDeskText = (int)title;
    StandingsReturnText = (int)title;
    StatsReturnText = (int)title;
    StandingsReturnRight = width;
    StatsReturnRight = width;
    if (width <= 0x7D) width = 0x7D;
    PlayerCardReturnDeskRight = width;
    PlayerCardReturnStandingsRight = width;
    PlayerCardReturnRosterRight = width;
    RosterReturnDeskRight = width;
    RosterReturnStandingsRight = width;
}
