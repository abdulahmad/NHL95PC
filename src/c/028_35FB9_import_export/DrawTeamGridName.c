/* Import / export: team grid cell. */
#include "nhl95.h"

/* DrawTeamGridName (37C53) - PC only: in the dialog text colours, for the cell of the 4 x 7 team grid tab holding
   team: draw bitmap bm clipped to the cell (sub_B4BC4 clip 77 wide, the font height + 1 high, from x 57 / 15 + 85
   per column, y 151 + 92 per row; sub_91370), restore the full-screen clip and print the team's name (names, 30
   bytes per team) centred under it in shadow text. */
void DrawTeamGridName(int team, char *names, int bm, unsigned char *tab)
{
    int c;
    int r;
    int x;
    int y;
    char *s;

    SetTextColors(dlgtextfg, dlgtextbg);
    for (r = 0; r < 4; r++) {
        for (c = 0; c < 7; c++) {
            if ((tab + r * 7)[c] == team) {
                if (r < 2) x = c * 85 + 0x39;
                else x = c * 85 + 0xF;
                y = r * 92 + 0x97;
                sub_B4BC4(x, x + 0x4D, y, y + byte_D42C3 + 1);
                sub_91370(bm, 0, 0);
                sub_B4BC4(0, 0x280, 0, 0x1E0);
                s = names + team * 30;
                PrintShadowText(x + 0x2A - (fputchar(s) >> 1), y, s);
            }
        }
    }
}
