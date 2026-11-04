/* Create player: draw the free-agent card. */
#define DrawCreatePlayer DrawCreatePlayer_decl
#include "nhl95.h"
#undef DrawCreatePlayer

typedef struct { char c[11]; } T11;

/* DrawCreatePlayer: draw the create-player card for pl. units is the ratings still to spend.
 Loads prez22 (palette into savepal, then the ea2 art) and pstatbar, prints "Free Agent", the name,
 number and position, the shoots or glove field, and the ratings line. */
void DrawCreatePlayer(unsigned char *pl, int units)
{
    char buf[0x40];
    int bank;
    int shape;
    char *pos;

    SetDrawBitmap(fullscrbmp);
    MakePath(buf, fileoncd[0x1C3] == 1 ? (char *)cddriveptr : 0, (char *)str_Prez22, 0);
    bank = sub_8E83C(buf, 0x20);
    shape = sub_B30B4(bank, (char *)str_Pal2);
    memcpy(savepal, (char *)shape + 0x10, 0x300);
    sub_913B4(sub_B30B4(bank, (char *)str_ea2));
    FreeMemBlock(bank);
    MakePath(buf, fileoncd[0x13C] == 1 ? (char *)cddriveptr : 0, (char *)str_Pstatbar, 0);
    bank = sub_8E83C(buf, 0);
    sub_913B4(sub_B30B4(bank, (char *)str_Pst2));
    FreeMemBlock(bank);
    sub_8EA18(kaufmfont);
    SetTextColors(0x40, 0x42);
    *(T11 *)buf = *(T11 *)str_FreeAgent;
    PrintOutlinedText(0x140 - (fputchar(buf) >> 1), 0x52, buf);
    SetTextColors(0x40, 0x42);
    sprintf(buf, (char *)str_fmtSS, pl + 3, pl + 0x13);
    PrintCenteredText(0x98, buf);
    sprintf(buf, (char *)str_fmtD, pl[1]);
    switch (pl[2]) {
    case 'C': pos = (char *)str_Center; break;
    case 'D': pos = (char *)str_Defence; break;
    case 'L': pos = (char *)str_LeftWing; break;
    case 'R': pos = (char *)str_RightWing; break;
    case 'G': pos = (char *)str_Goalie; break;
    default: goto shown;
    }
    strcat(buf, pos);
shown:
    PrintCenteredText(0xB2, buf);
    sub_8EA18(mainfont);
    if (pl[2] == 'G')
        DrawGloveField();
    else
        DrawShootsField();
    sprintf(buf, (char *)str_RatingUnitsAvailable3d, units);
    PrintCenteredText(0x110, buf);
    DrawButtons((Button *)str_Two, 2);
    sub_B4BA8();
    sub_9061C(((int *)fullscrbmp)[0x2C / 4]);
}
