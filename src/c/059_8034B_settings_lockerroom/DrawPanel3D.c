/* Settings locker room: a filled panel with a light and dark edge, and DrawLockerJersey (8156F), which ends in
 DrawPanel3D's exit (DrawPanel3D_ret). */
#define sub_912C8 sub_912C8_decl
#include "nhl95.h"
#undef sub_912C8

void __cdecl sub_912C8(int art);  /* graphics library: set the palette from an art block */

/* DrawPanel3D: fill x1,y1..x2,y2 in colour 70h. The top and left edges are 77h and the right and
 bottom edges are 62h. When corners is set, the four corners also get a pair of pixels two and three
 steps in: 77h on the outer diagonal and 62h on the inner one. */
void DrawPanel3D(int x1, int y1, int x2, int y2, int corners)
{
    int xa;
    int ya;
    int yb;
    int yc;
    int xc;

    sub_90D20(x1, y1, x2 - x1 + 1, y2 - y1 + 1, 0x70);
    sub_B4FAC(x1, y1, x2, y1, 0x77);
    sub_B4FAC(x1, y1, x1, y2, 0x77);
    sub_B4FAC(x2, y1, x2, y2, 0x62);
    sub_B4FAC(x1, y2, x2, y2, 0x62);
    if (corners) {
        sub_B5DB0(xa = x1 + 2, ya = y1 + 2, 0x77);
        sub_B5DB0(x1 += 3, y1 += 3, 0x77);
        sub_B5DB0(x1, ya, 0x62);
        sub_B5DB0(xa, y1, 0x62);
        sub_B5DB0(xa, yb = y2 - 2, 0x62);
        sub_B5DB0(x1, yc = y2 - 3, 0x62);
        sub_B5DB0(x1, yb, 0x77);
        sub_B5DB0(xa, yc, 0x77);
        sub_B5DB0(xc = x2 - 3, ya, 0x77);
        sub_B5DB0(x2 -= 2, y1, 0x77);
        sub_B5DB0(x2, ya, 0x62);
        sub_B5DB0(xc, y1, 0x62);
        sub_B5DB0(xc, yb, 0x62);
        sub_B5DB0(x2, yc, 0x62);
        sub_B5DB0(x2, yb, 0x77);
        sub_B5DB0(xc, yc, 0x77);
    }
}

#define LR ((Rect4 *)lockerrects)

/* DrawLockerJersey (8156F, PC only; ends in DrawPanel3D_ret): draw one side of the locker room (side 0 home, 1
   visitors) for team: load the team's jersey bank (JERSH / JERSV + the team's file name, from the CD when
   fileoncd says so), remap its 192-byte palette (+190h home, +250h visitors; values under 3Bh brightened by 5, the
   rest 3Fh) into the side's 64 palette entries (C0h home, 80h visitors), draw the side's background and name
   plates and the jersey art (P01, 00002). In a league or playoff (gamemode 1) the title for the division flags divs
   (off_D2230 by dword_D223C) goes on top in the Kaufman font. Then the four neighbour plates (lockerrects 2-5)
   are cleared and labelled with the teams before and after hm and vis (28 teams in exhibition, where an all-star
   team equal to the other side is skipped; else 26), and the two city names go under the jerseys. No result. */
void DrawLockerJersey(int side, int team, int divs, int hm, int vis)
{
    unsigned char pal[0xC0];
    char path[0x40];
    char name[0x10];
    int bank;
    int f;
    signed char *src;
    int i;
    int k;
    int k2;
    char *s;

    sub_B4BA8();
    sprintf(name, side ? (char *)str_JERSV : (char *)str_JERSH, off_D21C0[team]);
    team = dword_D20E0[team];
    f = (side != 0) + 0xA3;
    MakePath(path, fileoncd[team * 2 + f] == 1 ? (char *)cddriveptr : 0, name, 0);
    bank = sub_8E83C(path, 0);
    src = (signed char *)sub_B30B4(bank, (char *)str_P01) + 0x10;
    if (side) {
        for (i = 0; i < 0xC0; i++) {
            if ((src + i)[0x180] < 0x3B) pal[i] = (src + i)[0x180] + 5;
            else pal[i] = 0x3F;
        }
    } else {
        for (i = 0; i < 0xC0; i++) {
            if ((src + i)[0x240] < 0x3B) pal[i] = (src + i)[0x240] + 5;
            else pal[i] = 0x3F;
        }
    }
    if (side) {
        sub_910E0(visbckspr, 0x146, 0x4A);
        sub_910E0(visnamebckspr, 0x152, 0x2C);
        sub_B4B88(0x80, 0x40, pal);
    } else {
        sub_910E0(homebckspr, 0xA, 0x45);
        sub_910E0(homenamebckspr, 0x85, 0x2C);
        sub_B4B88(0xC0, 0x40, pal);
    }
    sub_912C8(sub_B30B4(bank, (char *)str_00002));
    FreeMemBlock(bank);
    sub_8E9C0(0x77, 0xFF);
    SetTextColors(0x77, 0x62);
    if (gamemode == 1) {
        sub_910E0(titlebckspr, 0x2D, 0x11);
        sub_8EA18(kaufmfont);
        s = (char *)off_D2230[dword_D223C[divs]];
        PrintOutlinedText((0x280 - fputchar(s)) / 2, 0x12, s);
        sub_8EA18(mainfont);
    }
    if (gamemode == 0) {
        for (i = 2; i < 6; i++) sub_90D20(LR[i].l + 1, LR[i].t + 1, LR[i].r - LR[i].l - 1, LR[i].b - LR[i].t - 1, 0x70);
        k = (vis + 0x1B) % 0x1C;
        if (k >= 0x1A && k == hm) k = (hm + 0x1B) % 0x1C;
        k = off_D21C0[k];
        PrintShadowText(((LR[4].l + LR[4].r) >> 1) - (fputchar((char *)k) >> 1) + 2, LR[4].t + 3, (char *)k);
        k = (vis + 1) % 0x1C;
        if (k >= 0x1A && k == hm) k = (hm + 1) % 0x1C;
        k = off_D21C0[k];
        PrintShadowText(((LR[5].l + LR[5].r) >> 1) - (fputchar((char *)k) >> 1) + 2, LR[5].t + 3, (char *)k);
        PrintOutlinedText(0x154, 0x2C, (char *)teamcitynames[dword_D2150[vis]]);
        k2 = (hm + 0x1B) % 0x1C;
        if (k2 >= 0x1A && k2 == vis) k2 = (vis + 0x1B) % 0x1C;
        k2 = off_D21C0[k2];
        PrintShadowText(((LR[2].l + LR[2].r) >> 1) - (fputchar((char *)k2) >> 1) + 2, LR[2].t + 3, (char *)k2);
        k2 = (hm + 1) % 0x1C;
        if (k2 >= 0x1A && k2 == vis) k2 = (vis + 1) % 0x1C;
        k2 = off_D21C0[k2];
        PrintShadowText(((LR[3].l + LR[3].r) >> 1) - (fputchar((char *)k2) >> 1) + 2, LR[3].t + 3, (char *)k2);
        k2 = 0x12D - fputchar((char *)teamcitynames[dword_D2150[hm]]);
        PrintOutlinedText(k2, 0x2C, (char *)teamcitynames[dword_D2150[hm]]);
    } else {
        for (i = 2; i < 6; i++) sub_90D20(LR[i].l + 1, LR[i].t + 1, LR[i].r - LR[i].l - 1, LR[i].b - LR[i].t - 1, 0x70);
        k = (vis + 0x19) % 0x1A;
        if (k == hm) k = (hm + 0x19) % 0x1A;
        k = off_D21C0[k];
        PrintShadowText(((LR[4].l + LR[4].r) >> 1) - (fputchar((char *)k) >> 1) + 2, LR[4].t + 3, (char *)k);
        k = (vis + 1) % 0x1A;
        if (k == hm) k = (hm + 1) % 0x1A;
        k = off_D21C0[k];
        PrintShadowText(((LR[5].l + LR[5].r) >> 1) - (fputchar((char *)k) >> 1) + 2, LR[5].t + 3, (char *)k);
        PrintOutlinedText(0x154, 0x2C, (char *)teamcitynames[dword_D2150[vis]]);
        k2 = (hm + 0x19) % 0x1A;
        if (k2 == vis) k2 = (vis + 0x19) % 0x1A;
        k2 = off_D21C0[k2];
        PrintShadowText(((LR[2].l + LR[2].r) >> 1) - (fputchar((char *)k2) >> 1) + 2, LR[2].t + 3, (char *)k2);
        k2 = (hm + 1) % 0x1A;
        if (k2 == vis) k2 = (vis + 1) % 0x1A;
        k2 = off_D21C0[k2];
        PrintShadowText(((LR[3].l + LR[3].r) >> 1) - (fputchar((char *)k2) >> 1) + 2, LR[3].t + 3, (char *)k2);
        k2 = 0x12D - fputchar((char *)teamcitynames[dword_D2150[hm]]);
        PrintOutlinedText(k2, 0x2C, (char *)teamcitynames[dword_D2150[hm]]);
    }
}
