/* Team select: drawing the line editor screen and its dialog frames, in address order. DrawDlgFrame ends in
   DrawLineEditorScreen's exit (StubRet4a) and matches only in one file with it (found by tools/module_try.py). */
#define DrawDlgFrame DrawDlgFrame_decl
#include "nhl95.h"
#undef DrawDlgFrame

void DrawDlgFrame(int x1, int y1, int x2, int y2, int bevel);

/* DrawLineEditorScreen (78500, PC only): draw the line editor for team (0 home, else away): its colour remap
   (identity, entries 80h-FFh from HOMEPALS.BIN's set for the team) and the BKGD art from the team's bank, the menu
   bar (buttons, n entries, colours C0h-C2h), the panel frame with the team crest (LELOGO bank, crestnames), and
   the boxes and labels of the four forward lines, two power-play units, two penalty-kill units, three defence
   pairs, the goaltenders and the extra attackers. shape, zero: not used. */
void DrawLineEditorScreen(int team, int shape, int zero, int buttons, int n)
{
    struct {
        unsigned char remap[0x100];
        char path[0x40];
        char name[0x10];
        int col2;
        int col1;
        int col3;
    } s;
    int bank;
    int pals;
    int i;
    unsigned char *src;
    int art;

    s.col1 = 0xC0;
    s.col2 = 0xC1;
    s.col3 = 0xC2;
    sprintf(s.name, (char *)str_EmbS, hmteamrec + team * 0x2E8);
    MakePath(s.path, fileoncd[0x70] == 1 ? (char *)cddriveptr : 0, s.name, 0);
    bank = sub_8E83C(s.path, 0);
    for (i = 0; i < 0x100; i++) s.remap[i] = i;
    MakePath(s.path, fileoncd[0xA1] == 1 ? (char *)cddriveptr : 0, (char *)str_HOMEPALS3, (char *)str_extBIN);
    pals = sub_8E8A0(s.path, 0);
    src = (unsigned char *)pals + 0xC0 + (team ? VisTeam : HomeTeam) * 0x1C0;
    for (i = 0x80; i < 0x100; i++) s.remap[i] = src[i];
    FreeMemBlock(pals);
    sub_B4DD4(s.remap);
    sub_91FE0(sub_B30B4(bank, (char *)str_Bkgd10), -0x4C, 0);
    FreeMemBlock(bank);
    DrawMenuBar((void *)buttons, n, s.col1, s.col2, s.col3);
    sub_8E9C0(0xC0, 0xC1);
    DrawDlgFrame(0x1F4, 0x13, 0x27F, 0x1DF, 1);
    MakePath(s.path, fileoncd[0x21B] == 1 ? (char *)cddriveptr : 0, (char *)str_Lelogo2, 0);
    bank = sub_8E83C(s.path, 0);
    art = sub_B30B4(bank, (char *)crestnames[team ? VisTeam : HomeTeam]);
    sub_91370(art, 0x218, 0x191);
    FreeMemBlock(bank);
    DrawDlgFrame(5, 0x2C, 0x45, 0x54, 1);
    sub_91964((char *)str_Forward, 0xC, 0x33);
    sub_91964((char *)str_Line1, 0x13, 0x40);
    DrawDlgFrame(5, 0x5D, 0x45, 0x85, 1);
    sub_91964((char *)str_Forward, 0xC, 0x64);
    sub_91964((char *)str_Line2, 0x13, 0x71);
    DrawDlgFrame(5, 0x8E, 0x45, 0xB6, 1);
    sub_91964((char *)str_Forward, 0xC, 0x95);
    sub_91964((char *)str_Line3, 0x13, 0xA2);
    DrawDlgFrame(5, 0xBF, 0x45, 0xE7, 1);
    sub_91964((char *)str_Forward, 0xC, 0xC6);
    sub_91964((char *)str_Line4, 0x13, 0xD3);
    DrawDlgFrame(5, 0xFA, 0x45, 0x122, 1);
    sub_91964((char *)str_Power, 0x10, 0x101);
    sub_91964((char *)str_Play1, 0x11, 0x10E);
    DrawDlgFrame(5, 0x12B, 0x45, 0x153, 1);
    sub_91964((char *)str_Power, 0x10, 0x132);
    sub_91964((char *)str_Play2, 0x11, 0x13F);
    DrawDlgFrame(5, 0x166, 0x45, 0x18E, 1);
    sub_91964((char *)str_Penalty, 0xC, 0x16D);
    sub_91964((char *)str_Kill1, 0x13, 0x17A);
    DrawDlgFrame(5, 0x197, 0x45, 0x1BF, 1);
    sub_91964((char *)str_Penalty, 0xC, 0x19E);
    sub_91964((char *)str_Kill2, 0x13, 0x1AB);
    DrawDlgFrame(0x114, 0x2C, 0x154, 0x54, 1);
    sub_91964((char *)str_Defense3, 0x11B, 0x33);
    sub_91964((char *)str_Line1, 0x120, 0x40);
    DrawDlgFrame(0x114, 0x5D, 0x154, 0x85, 1);
    sub_91964((char *)str_Defense3, 0x11B, 0x64);
    sub_91964((char *)str_Line2, 0x120, 0x71);
    DrawDlgFrame(0x114, 0x8E, 0x154, 0xB6, 1);
    sub_91964((char *)str_Defense3, 0x11B, 0x95);
    sub_91964((char *)str_Line3, 0x120, 0xA2);
    DrawDlgFrame(0x186, 0xC8, 0x1E4, 0xF0, 1);
    sub_91964((char *)str_Goaltenders, 0x18F, 0xD5);
    DrawDlgFrame(0x173, 0x166, 0x1C7, 0x18E, 1);
    sub_91964((char *)str_Extra, 0x189, 0x16D);
    sub_91964((char *)str_Attackers, 0x17D, 0x17A);
}

/* DrawDlgFrame (78BE7, PC only; ends in StubRet4a, DrawLineEditorScreen's exit): draw a dialog frame from x1 y1
   to x2 y2: the fill (dlgfillcol), the top and left edges in dlgedgecol1, the right and bottom edges in
   dlgedgecol2, the two other corners in dlgedgecol3; with bevel a 2 x 2 pixel bevel inside each corner
   (dlgbevelcol1 / 2). No result. */
void DrawDlgFrame(int x1, int y1, int x2, int y2, int bevel)
{
    sub_90D20(x1, y1, x2 - x1 + 1, y2 - y1 + 1, dlgfillcol);
    sub_B4FAC(x1, y1, x2 - 1, y1, dlgedgecol1);
    sub_B4FAC(x1, y1, x1, y2 - 1, dlgedgecol1);
    sub_B4FAC(x2, y1 + 1, x2, y2, dlgedgecol2);
    sub_B4FAC(x1 + 1, y2, x2, y2, dlgedgecol2);
    sub_B5DB0(x1, y2, dlgedgecol3);
    sub_B5DB0(x2, y1, dlgedgecol3);
    if (bevel) {
        sub_B5DB0(x1 + 2, y1 + 2, dlgbevelcol2);
        sub_B5DB0(x1 + 3, y1 + 3, dlgbevelcol2);
        sub_B5DB0(x1 + 3, y1 + 2, dlgbevelcol1);
        sub_B5DB0(x1 + 2, y1 + 3, dlgbevelcol1);
        sub_B5DB0(x1 + 2, y2 - 2, dlgbevelcol1);
        sub_B5DB0(x1 + 3, y2 - 3, dlgbevelcol1);
        sub_B5DB0(x1 + 3, y2 - 2, dlgbevelcol2);
        sub_B5DB0(x1 + 2, y2 - 3, dlgbevelcol2);
        sub_B5DB0(x2 - 3, y1 + 2, dlgbevelcol2);
        sub_B5DB0(x2 - 2, y1 + 3, dlgbevelcol2);
        sub_B5DB0(x2 - 2, y1 + 2, dlgbevelcol1);
        sub_B5DB0(x2 - 3, y1 + 3, dlgbevelcol1);
        sub_B5DB0(x2 - 3, y2 - 2, dlgbevelcol1);
        sub_B5DB0(x2 - 2, y2 - 3, dlgbevelcol1);
        sub_B5DB0(x2 - 2, y2 - 2, dlgbevelcol2);
        sub_B5DB0(x2 - 3, y2 - 3, dlgbevelcol2);
    }
}
