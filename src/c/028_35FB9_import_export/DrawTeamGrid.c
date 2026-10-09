/* Import / export: team grid. */
#include "nhl95.h"

/* DrawTeamGrid (37FBA) - print title centred at y 28h, load the crest bank (CALLOGO2) and draw the team grid: 4 rows of up
   to 7 crests (grid, 63h ends a row; x = col * 85 + 40h for rows 0-1, + 16h below; y = row * 92 + 58h), with
   DrawTeamGridName for teams whose record (1Eh bytes) is flagged at +17h; free the bank. */
void DrawTeamGrid(unsigned char *teams, char *title, unsigned char *grid, int arg4)
{
    int r;
    int j;
    int t;
    int crests[26];
    char buf[84];
    int bank;

    strcpy(buf, title);
    PrintCenteredText(0x28, buf);
    MakePath(buf, fileoncd[0x1C2] == 1 ? (char *)cddriveptr : 0, (char *)str_Callogo2, 0);
    bank = sub_8E83C(buf, 0);
    for (r = 0; r < 0x1A; r++) crests[r] = sub_B30B4(bank, (char *)crestnames[r]);
    for (r = 0; r < 4; r++) {
        for (j = 0; j < 7; j++) {
            t = grid[r * 7 + j];
            if (t == 0x63) break;
            sub_91370(crests[t], j * 85 + (r < 2 ? 0x40 : 0x16), r * 92 + 0x58);
            if (teams[t * 30 + 0x17] == 1) DrawTeamGridName(t, teams, arg4, grid);
        }
    }
    jctime(bank);
}
