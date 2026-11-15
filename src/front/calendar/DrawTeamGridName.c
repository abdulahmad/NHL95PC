/* Import export: team grid cell. */
#include "nhl95.h"

/* DrawTeamGridName: in the dialog text colours, for the cell of the 4 x 7 team grid tab holding
 team: draw bitmap bm clipped to the cell (SetClipWindow clip 77 wide, the font height + 1 high, from x 57 15 + 85
 per column, y 151 + 92 per row; DrawArt), restore the full-screen clip and print the team's name (names, 30
 bytes per team) centred under it in shadow text. */
void DrawTeamGridName(int team, char *names, int bm, unsigned char *tab)
{
    int c;
    int r;
    int x;
    int y;
    char *s;
    int x2;

    SetTextColors(dlgtextfg, dlgtextbg);
    for (r = 0; r < 4; r++) {
        for (c = 0; c < 7; c++) {
            if ((tab + r * 7)[c] == team) {
                {
                    int col = c * 85;
                    if (r < 2) x = col + 0x39;
                    else x = col + 0xF;
                }
                y = r * 92 + 0x97;
                x2 = x + 0x4D;
                SetClipWindow(x, x2, y, y + byte_D42C3 + 1);
                DrawArt(bm, 0, 0);
                SetClipWindow(0, 0x280, 0, 0x1E0);
                s = names + team * 30;
                x = x + 0x2A - (fputchar(s) >> 1);
                PrintShadowText(x, y, s);
            }
        }
    }
}
