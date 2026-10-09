/* Database merge: import. */
#include "nhl95.h"

/* ImportDbs (3CF5B) - ask what to import (master league or a player/team file, importtypemsg) and for the floppy
   (importdiskmsg, then SelectFloppyDrive); import it; on success reload the current league's GAME.SET into lgstate
   and re-enable the league menu actions (export, next game, league manager), on failure clear the league name and
   disable them. Dialog colours are set for the questions and restored afterwards. */
void ImportDbs(void)
{
    char path[32];
    int fh;
    int t;
    int x;
    int y;
    int r;

    SetDialogColors(0xF9, 0xFA, 0xF8, 0xFA, 0);
    sub_B2DCA(&t, &x, &y);
    t = MessageBox(-1, -1, (char *)importtypemsg, 2, (int)importtypebtns, 2, (int)&x, (int)&y, -1);
    if (t >= 0) {
        r = MessageBox(-1, -1, (char *)importdiskmsg, 2, 0, 0, (int)&x, (int)&y, -1);
        if (!r) r = SelectFloppyDrive(0, 0);
        if (!r) {
            if (t == 0) r = ImportMasterLeague();
            else r = ImportPlayerTeam();
            if (!r) {
                MakePath(path, (char *)&curleague, (char *)str_GAME3, (char *)str_SET);
                if (!FileOpenRead(path, &fh)) {
                    if (FileReadAt(fh, lgstate, -1, 0x75)) FatalError((char *)str_L1);
                    if (FileClose(&fh)) FatalError((char *)str_L22);
                }
                LoadModeState(lgstate);
                BuildSavedGameLabels();
                SetupStatsSourceMenu(0);
                menuact_export = (int)MenuExportDbs;
                menuact_nextlg = (int)MenuNextLeagueGame;
                menusub_lgmgr = (int)leaguemgrmenu;
            } else {
                ((unsigned char *)lgstate)[4] = 0;
                BuildSavedGameLabels();
                SetupStatsSourceMenu(0);
                menuact_export = 0;
                menuact_nextlg = 0;
                menusub_lgmgr = 0;
            }
        }
    }
    SetDialogColors(0x2A, 0x3F, 0x17, 0x3F, 0);
}
