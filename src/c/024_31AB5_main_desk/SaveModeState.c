/* Main desk: save / restore the game mode state. */
#include "nhl95.h"

/* SaveModeState (3271B) - save the current mode into the state record st: league name (+4), league database
   name formats (+11h, +31h), home / visiting team (+51h / +55h), game options (+59h) and the two controllers'
   team, device and side (+5Dh..+71h). */
void SaveModeState(unsigned char *st)
{
    strcpy((char *)st + 4, (char *)&curleague);
    strcpy((char *)st + 0x11, (char *)&leaguedbfmt);
    strcpy((char *)st + 0x31, (char *)&leaguedbfmt2);
    *(int *)(st + 0x51) = HomeTeam;
    *(int *)(st + 0x55) = VisTeam;
    *(GameOpts *)(st + 0x59) = gameopts;
    *(int *)(st + 0x5D) = ctl1team[0];
    *(int *)(st + 0x61) = ctl2team;
    *(int *)(st + 0x65) = ctl1dev[0];
    *(int *)(st + 0x69) = ctl2dev;
    *(int *)(st + 0x6D) = ctl1side[0];
    *(int *)(st + 0x71) = ctl2side;
}
