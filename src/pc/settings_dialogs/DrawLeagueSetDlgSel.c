/* Settings dialogs: the selected league-settings picture. */
#define DrawLeagueSetDlgSel DrawLeagueSetDlgSelDecl
#include "nhl95.h"
#undef DrawLeagueSetDlgSel

/* DrawLeagueSetDlgSel: clear the screen, load Setting5 (leaguesetimg set) or Setting3 from the CD
 when that file is on the disc, draw Dbox2 at (0Ah, 13h), free the bank, set the text colours, and
 when the sound device is 10h label Music and Sound. With music off, label Digitized Speech. Then the
 settings heading (5 lines or 3) in colour FAh. Returns 0. */
int DrawLeagueSetDlgSel(void)
{
    char path[32];
    int img;
    char *name;
    char *dir;
    char *ext;

    sub_B4BA8();
    if (leaguesetimg[0]) {
        ext = 0;
        name = (char *)str_Setting5;
        if (fileoncd[0x175] == 1) dir = (char *)cddriveptr;
        else dir = 0;
        MakePath(path, dir, name, ext);
    } else {
        ext = 0;
        name = (char *)str_Setting3;
        if (fileoncd[0x173] == 1) dir = (char *)cddriveptr;
        else dir = 0;
        MakePath(path, dir, name, ext);
    }
    img = sub_8E83C(path, 0);
    sub_91284(sub_B30B4(img, (char *)str_Dbox2), 0x0A, 0x13);
    FreeMemBlock(img);
    sub_8E9C0(0xF8, 0xFF);
    if (sounddev == 0x10) {
        sub_91964((char *)str_Music, 0x68, 0xAA);
        sub_91964((char *)str_Sound, 0x68, 0xC0);
    }
    if (!musicon) sub_91964((char *)str_DigitizedSpeech, 0x68, 0xD6);
    DrawSettingsHeading(0x0A, 0x13, leaguesetimg[0] ? 5 : 3, gamemode, 0xFA);
    sub_B4BA8();
    return 0;
}
