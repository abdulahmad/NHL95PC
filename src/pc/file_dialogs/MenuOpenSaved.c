/* File dialogs: the "open saved game" menu. */
#define MenuOpenSaved MenuOpenSaved_decl
#define RunFileDlg RunFileDlg_decl
#define MenuNewExhibition MenuNewExhibition_decl
#define PlayoffModeLoop PlayoffModeLoop_decl
#include "nhl95.h"
#undef MenuOpenSaved
#undef RunFileDlg
#undef MenuNewExhibition
#undef PlayoffModeLoop

typedef struct { char c[17]; } Hdr17;

int RunFileDlg(void);
int MenuNewExhibition(int *fh);
int PlayoffModeLoop(int *fh);

/* MenuOpenSaved (2B944, PC only): the desk's "open a saved game" item. Scan the saved games, save the screen
   under the dialog (a copy of the pointer sprite header, EEh x C6h, at 0Ah, 13h), run the file dialog
   (LoadFileDlgShapes, DrawFileDlg, DrawFileDlgTabs, RunFileDlg), restore the screen and free the shapes. When a
   game was chosen, by the tab: (0) a saved exhibition: copy its game summary (75h bytes in, 0Bh-byte records)
   into GSUMMARY.DB and read the other games' scores and periods, then resume it (MenuNewExhibition); (1) a
   playoff game: copy the summary database into the playoffs directory, resume it (PlayoffModeLoop) and delete
   its GAME.SAV once a game ended (gameresult 1) unless postate bit 7 of +5Ah; (2) a league game, the same with
   lgstate and MenuNextLeagueGame. The stats source menu follows each (1, 2, 3, back to 0). Missing files are
   fatal. a, b: the menu call's arguments, not used. Result: the resumed menu's result, else 0. */
int MenuOpenSaved(int a, int b)
{
    struct {
        char path[0x20];
        unsigned char rec[0xC];
        int dfh;
        int fh;
    } s;
    int r;
    int bm;
    int n;
    int i;

    ScanSavedGames();
    bm = sub_8CCA8((char *)str_Buf, 0xB825, 0x20);
    *(Hdr17 *)bm = *(Hdr17 *)pointerspr;
    ((short *)bm)[2] = 0xEE;
    ((short *)bm)[3] = 0xC6;
    sub_91400(bm, 0xA, 0x13);
    LoadFileDlgShapes();
    DrawFileDlg();
    DrawFileDlgTabs();
    r = RunFileDlg();
    sub_910E0(bm, 0xA, 0x13);
    FreeMemBlock(bm);
    FreeMemBlock(fdlgshapes);
    fdlgshapes = 0;
    BuildSavedGameLabels();
    SetupStatsSourceMenu(0);
    if (!r) return 0;
    switch (fdlgtab) {
    case 0:
        SetupStatsSourceMenu(1);
        strcpy(s.path, (char *)lgfilenames[lgfiles[1]]);
        strcat(s.path, (char *)str_Nhl);
        if (FileOpenRead(s.path, &s.fh)) FatalError((char *)str_fek1);
        if (FileCreate((char *)str_GsummaryDb3, &s.dfh)) FatalError((char *)str_fek2);
        if (FileReadAt(s.fh, s.rec, 0x75, 0xB)) FatalError((char *)str_fek3);
        if (FileWriteAt(s.dfh, s.rec, -1, 0xB)) FatalError((char *)str_fek4);
        n = *(short *)(s.rec + 5);
        for (i = 0; i < n; i++) {
            if (FileReadAt(s.fh, s.rec, -1, 0xB)) FatalError((char *)str_fek5);
            if (FileWriteAt(s.dfh, s.rec, -1, 0xB)) FatalError((char *)str_fek6);
        }
        FileClose(&s.dfh);
        if (FileReadAt(s.fh, othergames, -1, 0xC)) FatalError((char *)str_fek7);
        if (FileReadAt(s.fh, otherscores, -1, 0xC)) FatalError((char *)str_fek8);
        if (FileReadAt(s.fh, otherperiod, -1, 0x18)) FatalError((char *)str_feh7);
        exhstate[0x5A] &= 0x7F;
        r = MenuNewExhibition(&s.fh);
        SetupStatsSourceMenu(0);
        return r;
    case 1:
        if (CopyFile((char *)str_Gsummary, (char *)str_Sav, (char *)str_Db2, (char *)postate + 4, (char *)postate + 4))
            FatalError((char *)str_feA1);
        SetupStatsSourceMenu(2);
        strcpy(s.path, (char *)pofilenames[pofiles[1]]);
        strcat(s.path, (char *)str_PoGameSav);
        if (FileOpenRead(s.path, &s.fh)) FatalError((char *)str_fel1);
        ((unsigned char *)postate)[0x5A] &= 0x7F;
        n = PlayoffModeLoop(&s.fh);
        if (!(((unsigned char *)postate)[0x5A] & 0x80) && gameresult == 1) j_unlink(s.path);
        SetupStatsSourceMenu(0);
        return n;
    case 2:
        if (CopyFile((char *)str_Gsummary, (char *)str_Sav, (char *)str_Db2, (char *)lgstate + 4, (char *)lgstate + 4))
            FatalError((char *)str_feA2);
        SetupStatsSourceMenu(3);
        strcpy(s.path, (char *)exhfilenames[exhfiles[1]]);
        strcat(s.path, (char *)str_LpGameSav);
        if (FileOpenRead(s.path, &s.fh)) FatalError((char *)str_fel2);
        ((unsigned char *)lgstate)[0x5A] &= 0x7F;
        n = MenuNextLeagueGame(&s.fh);
        if (!(((unsigned char *)lgstate)[0x5A] & 0x80) && gameresult == 1) j_unlink(s.path);
        SetupStatsSourceMenu(0);
        return n;
    }
    return 0;
}
