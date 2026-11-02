/* Line editor rosters: open the database line editor. */
#include "nhl95.h"

/* DbLineEditor: fade in through the Pal25 palette, quiet the music, and open the line editor for team.
 lines is that team's line block, buttons is the editor button list, and n is passed through to the
 screen and the editor loop. The Lineditp2 bank is loaded from the CD when fileoncd says so. Dialog
 colours become C0h-C3h for the editor and 40h-42h again after it returns. */
void DbLineEditor(unsigned char team, int lines, int buttons, int n)
{
    char path[0x20];
    unsigned char *pal;
    int bank;
    int shape;

    pal = (unsigned char *)sub_8CCA8((char *)str_Pal25, 0x300, 0x20);
    sub_8FFB0(0, 0x100, pal);
    FadePalStep(1, pal, 0x10);
    FreeMemBlock((int)pal);
    if (musicon && songdata) sub_8FCDF(musichandle, 3, 0x32);
    ShowLoadingScreen();
    SetDrawBitmap(fullscrbmp);
    lineedpanel = team;
    dlgfillcol = 0xC1;
    dlgedgecol1 = 0xC0;
    dlgedgecol2 = 0xC1;
    dlgedgecol3 = 0xC2;
    dlgbevelcol1 = 0xC3;
    dlgbevelcol2 = 0xC2;
    MouseSetPos(0x140, 0xF0);
    sub_B4BC4(0, 0x280, 0, 0x1E0);
    MakePath(path, fileoncd[0xE8] == 1 ? (char *)cddriveptr : 0, (char *)str_Lineditp2, 0);
    bank = sub_8E83C(path, 0);
    shape = sub_B30B4(bank, (char *)str_Shrt2);
    DrawLineEditorScreen(team, shape, 0, buttons, n);
    FadeOutPalCycle();
    sub_B4BA8();
    sub_9061C(((int *)fullscrbmp)[0x2C / 4]);
    DbLineEditorLoop(lines, shape, team, 0, buttons, n, bank);
    FreeMemBlock(bank);
    dlgfillcol = 0x41;
    dlgedgecol1 = 0x40;
    dlgedgecol2 = 0x42;
    dlgedgecol3 = 0x41;
    dlgbevelcol1 = 0x40;
    dlgbevelcol2 = 0x42;
}
