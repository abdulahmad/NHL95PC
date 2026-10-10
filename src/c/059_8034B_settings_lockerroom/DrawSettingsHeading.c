/* Settings / locker room: settings dialog heading. */
#include "nhl95.h"

/* DrawSettingsHeading (8050F) - PC only: print the game mode name (mode 0 Exhibition, 1 Playoff, 2 League) as the
   heading of settings dialog n in the s1font font and colour on FFh, 16h below y and centred from x (dialogs 3 / 5
   at x+59h, 4 / 6 at x+51h); the text state is saved and restored around it. */
void DrawSettingsHeading(int x, int y, int n, int mode, int colour)
{
    char state[0x40];

    sub_8E9E8(state);
    sub_8EA18(s1font);
    sub_8E9C0(colour, 0xFF);
    y += 0x16;
    switch (n) {
    case 3:
    case 5:
        x += 0x59;
        break;
    case 4:
    case 6:
        x += 0x51;
        break;
    }
    switch (mode) {
    case 0:
        sub_91964((char *)str_Exhibition2, x - 0x41, y);
        break;
    case 1:
        sub_91964((char *)str_Playoff, x - 0x32, y);
        break;
    case 2:
        sub_91964((char *)str_League2, x - 0x2F, y);
        break;
    }
    sub_8EA00(state);
}
