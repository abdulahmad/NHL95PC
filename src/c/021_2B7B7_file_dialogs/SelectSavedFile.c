/* File dialogs: open a saved file. */
#include "nhl95.h"

/* SelectSavedFile (2D099) - open the file selected in the file dialog's current tab (fdlgtab): 0 an exhibition (.NHL:
   settings into exhstate, the "LA at MTL" title from its two teams; returns 1), 1 a playoff (.PO: settings into
   postate, playoff menu actions on, series game number from the schedule's dword +42h mod 7; returns
   ReadGameSettings' result), 2 a league (.LP: settings into lgstate, league menu actions on). */
int SelectSavedFile(void)
{
    char path[32];
    char name[16];
    int r;
    int t;
    unsigned char *buf;
    char *a;

    switch (fdlgtab) {
    case 0:
        strcpy(name, (char *)lgfilenames[lgfiles[1]]);
        strcat(name, (char *)str_Nhl);
        ReadGameSettings(exhstate, name, 1);
        LoadModeState(exhstate);
        t = *(int *)(exhstate + 0x51);
        if (t < 0x18) a = (char *)teamabbrevs[t];
        else a = (char *)off_C5441[t];
        strncpy((char *)str_LAAtMTL, a, 3);
        t = *(int *)(exhstate + 0x55);
        if (t < 0x18) a = (char *)teamabbrevs[t];
        else a = (char *)off_C5441[t];
        strncpy((char *)str_LAAtMTL + 7, a, 3);
        return 1;
    case 1:
        strcpy(name, (char *)pofilenames[pofiles[1]]);
        strcat(name, (char *)str_Po2);
        r = ReadGameSettings(postate, name, 0);
        menuact_nextpo = (int)PlayoffModeLoop;
        menuact_posettings = (int)EditPlayoffSettings;
        menuact_pohilights = (int)ViewPlayoffHilights;
        MakePath(path, name, (char *)str_ScheduleDb2, 0);
        buf = (unsigned char *)sub_8E8A0(path, 0);
        seriesgameno = *(int *)(buf + 0x42) % 7;
        jctime((int)buf);
        return r;
    case 2:
        strcpy(name, (char *)exhfilenames[exhfiles[1]]);
        strcat(name, (char *)str_Lp2);
        r = ReadGameSettings(lgstate, name, 0);
        menuact_export = (int)MenuExportDbs;
        menuact_nextlg = (int)MenuNextLeagueGame;
        menusub_lgmgr = (int)leaguemgrmenu;
        return r;
    }
    return r;
}
