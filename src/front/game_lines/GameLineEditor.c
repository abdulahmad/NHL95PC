/* Line editor rosters: the in-game line editor. */
#define GameLineEditorLoop GameLineEditorLoop_decl
#include "nhl95.h"
#undef GameLineEditorLoop

void GameLineEditorLoop(int lines, int shape, int team, int zero, int names, int mode, int bank);

/* GameLineEditor: fade in through Pal27, quiet the music and any speech, and open the in-game
 line editor. lines, names and mode are passed through to the screen and the editor loop. The
 Lineditp3 bank is loaded from the CD when fileoncd says so. Dialog and box colours become
 C0h-C3h for the editor and the saved colours are put back when it returns. The game roster is
 sorted before the loop. */
void GameLineEditor(int team, unsigned char *lines, unsigned char *names, int mode)
{
    struct {
        char path[16];
        int fill;
        int boxlite;
        int boxfill;
        int bevel2;
        int lines_slot;
        int bevel1;
        int edge3;
        int textbg;
        int textfg;
        int boxshade;
        int edge1;
        int edge2;
        int mode_slot;
        int names_slot;
    } s;
    unsigned char *pal;
    int c1;
    int c0;
    int c2;
    int bank;
    int shape;

    s.lines_slot = (int)lines;
    s.names_slot = (int)names;
    s.mode_slot = mode;
    pal = (unsigned char *)sub_8CCA8((char *)str_Pal27, 0x300, 0x20);
    sub_8FFB0(0, 0x100, pal);
    FadePalStep(1, pal, 0x10);
    FreeMemBlock((int)pal);
    if (musicon && songdata) {
        sub_8FCDF(musichandle, 3, 0x32);
        while (!sub_8FC8A(*(int *)((char *)&musicslot - 3) >> 24, 3));
        sub_8D2F0(songdata);
        songdata = 0;
    }
    if (musicon && (((unsigned char *)&gameopts)[1] & 1)) {
        MusicChanReset2();
        while (SpeechBusy());
    }
    ShowLoadingScreen();
    s.fill = dlgfillcol;
    s.edge1 = dlgedgecol1;
    s.edge2 = dlgedgecol2;
    s.edge3 = dlgedgecol3;
    s.bevel1 = dlgbevelcol1;
    s.bevel2 = dlgbevelcol2;
    c1 = 0xC1;
    dlgfillcol = c1;
    c0 = 0xC0;
    dlgedgecol1 = c0;
    dlgedgecol2 = c1;
    c2 = 0xC2;
    dlgedgecol3 = c2;
    dlgbevelcol1 = 0xC3;
    dlgbevelcol2 = c2;
    s.boxfill = boxfillcolor;
    s.boxlite = boxlitecolor;
    s.boxshade = boxshadecolor;
    s.textfg = dlgtextfg;
    s.textbg = dlgtextbg;
    boxfillcolor = c1;
    boxlitecolor = c0;
    boxshadecolor = c1;
    dlgtextfg = c0;
    dlgtextbg = c1;
    sub_B4BA8();
    sub_B4BC4(0, 0x280, 0, 0x1E0);
    MouseSetPos(0x140, 0xC8);
    MakePath(s.path, fileoncd[0xE8] == 1 ? (char *)cddriveptr : 0, (char *)str_Lineditp3, 0);
    bank = sub_8E83C(s.path, 0);
    shape = sub_B30B4(bank, (char *)str_Shrt3);
    FadeOutPalCycle();
    DrawLineEditorScreen(team, shape, 0, s.names_slot, s.mode_slot);
    LoadGameRoster(team);
    qsort(gmroster, 0x1C, 0x16, (int (*)(const void *, const void *))GameRosterCmp);
    GameLineEditorLoop(s.lines_slot, shape, team, 0, s.names_slot, s.mode_slot, bank);
    FreeMemBlock(bank);
    dlgfillcol = s.fill;
    dlgedgecol1 = s.edge1;
    dlgedgecol2 = s.edge2;
    dlgedgecol3 = s.edge3;
    dlgbevelcol1 = s.bevel1;
    dlgbevelcol2 = s.bevel2;
    boxfillcolor = s.boxfill;
    boxlitecolor = s.boxlite;
    boxshadecolor = s.boxshade;
    dlgtextfg = s.textfg;
    dlgtextbg = s.textbg;
}
