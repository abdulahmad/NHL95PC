/* Create player: the shoots / ratings fields. */
#include "nhl95.h"

/* DrawShootsField (6FA7D) - PC only: print "Shoots" and L / R (byte_D0F94 of the player being created) at y 12Ah,
   then the 14 rating names (off_D0880[1..14]) with their values (rating byte + 5) * 5 below it, in two
   columns (the second, from rating 8, 136h to the right and 68h up). */
void DrawShootsField(void)
{
    int col;
    int i;
    int y;
    unsigned char *rec;

    y = 0x12A;
    rec = &byte_D0F94;
    PrintShadowText(0x1E, y, (char *)str_Shoots);
    PrintShadowText(0xC8, y, byte_D0F94 ? (char *)str_spL : (char *)str_spR);
    col = 0;
    i = 1;
    y += 0xD;
    do {
        if (i == 8) {
            col = 0x136;
            y -= 0x68;
        }
        PrintShadowText(col + 0x1E, y, (char *)off_D0880[i]);
        PrintFmt1(col + 0xC8, y, (char *)str_fmt3d, (rec[i] + 5) * 5);
        y += 0xD;
        i++;
    } while (i < 15);
}

/* DrawGloveField (6FB35) - PC only: the goalie version: "Glove Hand" and L / R (byte_D0FE0), then the 10 goalie
   rating names (off_D09DB[1..10]) with their values, the second column from rating 6 (4Eh up). Its end is
   DrawShootsField's (shared tail), so both are in this file. */
void DrawGloveField(void)
{
    int col;
    int i;
    int y;
    unsigned char *rec;

    y = 0x12A;
    rec = &byte_D0FE0;
    PrintShadowText(0x1E, y, (char *)str_GloveHand);
    PrintShadowText(0xC8, y, byte_D0FE0 ? (char *)str_spL : (char *)str_spR);
    col = 0;
    i = 1;
    y += 0xD;
    do {
        if (i == 6) {
            col = 0x136;
            y -= 0x4E;
        }
        PrintShadowText(col + 0x1E, y, (char *)off_D09DB[i]);
        PrintFmt1(col + 0xC8, y, (char *)str_fmt3d, (rec[i] + 5) * 5);
        y += 0xD;
        i++;
    } while (i < 11);
}
