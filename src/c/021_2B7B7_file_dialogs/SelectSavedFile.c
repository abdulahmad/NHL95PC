/* File dialogs: open a saved file. */
#include "nhl95.h"

/* DRAFT (19 -> 15 differing, 459 vs 455): Watcom hoists t * 4 out of the two abbreviation lookups (`shl` into a
   second register); the EXE indexes each table with `[t*4 + table]`, the second t in ebx. Tried: a ternary in the
   strncpy argument, a second local for the second team, the exhstate words read in place, permute (3 min). */
/* SelectSavedFile: open the file selected in the file dialog's current tab (fdlgtab): 0 an exhibition (.NHL:
 settings into exhstate, the "LA at MTL" title from its two teams; returns 1), 1 a playoff (.PO: settings into
 postate, playoff menu actions on, series game number from the schedule's dword +42h mod 7; returns
 ReadGameSettings' result), 2 a league (.LP: settings into lgstate, league menu actions on). */
int SelectSavedFile(void)
{
    char path[32];
    char name[16];
    int t;
    unsigned char *buf;

    switch (fdlgtab) {
    case 0:
        strcpy(name, (char *)lgfilenames[lgfiles[1]]);
        strcat(name, (char *)str_Nhl);
        ReadGameSettings(exhstate, name, 1);
        LoadModeState(exhstate);
        t = *(int *)(exhstate + 0x51);
        if (t < 0x18) strncpy((char *)str_LAAtMTL, (char *)teamabbrevs[t], 3);
        else strncpy((char *)str_LAAtMTL, (char *)off_C5441[t], 3);
        t = *(int *)(exhstate + 0x55);
        if (t < 0x18) strncpy((char *)str_LAAtMTL + 7, (char *)teamabbrevs[t], 3);
        else strncpy((char *)str_LAAtMTL + 7, (char *)off_C5441[t], 3);
        return 1;
    case 1:
        strcpy(name, (char *)pofilenames[pofiles[1]]);
        strcat(name, (char *)str_Po2);
        t = ReadGameSettings(postate, name, 0);
        menuact_nextpo = (int)PlayoffModeLoop;
        menuact_posettings = (int)EditPlayoffSettings;
        menuact_pohilights = (int)ViewPlayoffHilights;
        MakePath(path, name, (char *)str_ScheduleDb2, 0);
        buf = (unsigned char *)sub_8E8A0(path, 0);
        seriesgameno = *(int *)(buf + 0x42) % 7;
        FreeMemBlock((int)buf);
        return t;
    case 2:
        strcpy(name, (char *)exhfilenames[exhfiles[1]]);
        strcat(name, (char *)str_Lp2);
        t = ReadGameSettings(lgstate, name, 0);
        menuact_export = (int)MenuExportDbs;
        menuact_nextlg = (int)MenuNextLeagueGame;
        menusub_lgmgr = (int)leaguemgrmenu;
        return t;
    }
    return t;
}
