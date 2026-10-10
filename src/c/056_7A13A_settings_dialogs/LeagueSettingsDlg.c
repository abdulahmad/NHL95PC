/* Settings dialogs: league / playoff settings dialogs (one source block: they share the closing code). */
/* DRAFT: all five bodies match; Watcom merges the shared exit the other way round (LeagueSettingsDlg jumps into MenuPlayoffSettings' pops, the EXE has MenuPlayoffSettings jump to LeagueSettingsDlg_ret). */
#include "nhl95.h"

typedef struct Hdr17 { char c[17]; } Hdr17;

void DrawLeagueSetDlg(int playoffs);  /* 7A6BD */
void LeagueSetEditLoop(int mode);  /* 7ADD3 */

/* LeagueSettingsDlg (7A13A) - the league settings dialog: with the series game number cleared (restored after),
   load the settings shapes, save the screen under the 230 x 338 dialog at 10 / 13h into a BKGD bitmap (pointer
   sprite header), draw the dialog (DrawLeagueSetDlg 0), load the options into the check bits and run it (edit mode
   1); then restore the screen and free the bitmap and the settings file. Returns 0. */
int LeagueSettingsDlg(void)
{
    int bm;
    int sg;

    sg = seriesgameno;
    seriesgameno = 0;
    LoadSettingsShapes();
    sub_B4BA8();
    bm = sub_8CCA8((char *)str_BKGD, 0x1436B, 0x20);
    *(Hdr17 *)bm = *(Hdr17 *)pointerspr;
    ((short *)bm)[2] = 0xE6;
    ((short *)bm)[3] = 0x152;
    sub_91400(bm, 0xA, 0x13);
    DrawLeagueSetDlg(0);
    LeagueOptsToBits();
    LeagueSetEditLoop(1);
    sub_903F0(bm, 0xA, 0x13);
    jctime(bm);
    jctime(settingsfile);
    settingsfile = 0;
    seriesgameno = sg;
    return 0;
}

/* MenuPlayoffSettings (7A1FC) - menu "playoff settings": the same dialog for the playoffs (DrawLeagueSetDlg 1,
   edit mode 0). Returns 0. */
int MenuPlayoffSettings(void)
{
    int bm;

    LoadSettingsShapes();
    sub_B4BA8();
    bm = sub_8CCA8((char *)str_BKGD, 0x1436B, 0x20);
    *(Hdr17 *)bm = *(Hdr17 *)pointerspr;
    ((short *)bm)[2] = 0xE6;
    ((short *)bm)[3] = 0x152;
    sub_91400(bm, 0xA, 0x13);
    DrawLeagueSetDlg(1);
    LeagueOptsToBits();
    LeagueSetEditLoop(0);
    sub_903F0(bm, 0xA, 0x13);
    jctime(bm);
    jctime(settingsfile);
    settingsfile = 0;
    return 0;
}

/* EditPlayoffSettings (7A29C) - edit the playoff settings: the league dialog (DrawLeagueSetDlg 0, edit mode 1)
   run on the playoff state (exhibition state saved, postate loaded, then written back and the exhibition state
   reloaded). Returns 0. */
int EditPlayoffSettings(void)
{
    int bm;

    LoadSettingsShapes();
    sub_B4BA8();
    bm = sub_8CCA8((char *)str_BKGD, 0x1436B, 0x20);
    *(Hdr17 *)bm = *(Hdr17 *)pointerspr;
    ((short *)bm)[2] = 0xE6;
    ((short *)bm)[3] = 0x152;
    sub_91400(bm, 0xA, 0x13);
    SaveModeState(exhstate);
    LoadModeState(postate);
    DrawLeagueSetDlg(0);
    LeagueOptsToBits();
    LeagueSetEditLoop(1);
    WriteModeState(postate);
    LoadModeState(exhstate);
    sub_903F0(bm, 0xA, 0x13);
    jctime(bm);
    jctime(settingsfile);
    settingsfile = 0;
    return 0;
}

/* MenuLeagueSettingsEdit (7A335) - menu "edit league settings": the dialog with the selection drawn
   (DrawLeagueSetDlgSel), edit mode 1. Returns 0. */
int MenuLeagueSettingsEdit(void)
{
    int bm;

    sub_B4BA8();
    LoadSettingsShapes();
    bm = sub_8CCA8((char *)str_BKGD, 0x1436B, 0x20);
    *(Hdr17 *)bm = *(Hdr17 *)pointerspr;
    ((short *)bm)[2] = 0xE6;
    ((short *)bm)[3] = 0x152;
    sub_91400(bm, 0xA, 0x13);
    DrawLeagueSetDlgSel();
    LeagueOptsToBits();
    LeagueSetEditLoop(1);
    sub_903F0(bm, 0xA, 0x13);
    jctime(bm);
    jctime(settingsfile);
    settingsfile = 0;
    return 0;
}

/* MenuShowLeagueSettings (7A39F) - menu "show league settings": the dialog with the selection drawn, view only
   (LeagueSetViewLoop). Returns 0. */
int MenuShowLeagueSettings(void)
{
    int bm;

    LoadSettingsShapes();
    bm = sub_8CCA8((char *)str_BKGD, 0x1436B, 0x20);
    *(Hdr17 *)bm = *(Hdr17 *)pointerspr;
    ((short *)bm)[2] = 0xE6;
    ((short *)bm)[3] = 0x152;
    sub_91400(bm, 0xA, 0x13);
    DrawLeagueSetDlgSel();
    LeagueOptsToBits();
    LeagueSetViewLoop();
    sub_903F0(bm, 0xA, 0x13);
    jctime(bm);
    jctime(settingsfile);
    settingsfile = 0;
    return 0;
}
