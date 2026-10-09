/* Settings dialogs: league settings hit test. */
#include "nhl95.h"

typedef struct LRect {
    int x1, y1, x2, y2;
} LRect;
#define LR ((LRect *)leaguesetrects)

/* LeagueSetHitTest (7A9C8) - PC only: the league settings item (27 rects of 4 dwords, leaguesetrects) under point
   x - 6, y - 13h, stored in *item. Greyed-out items do not count: 0Ah-0Bh never, 0Ch-0Fh not with sound device
   10h, 10h-11h only with music on, 15h / 16h / 17h not in the playoffs (gamemode 1) from game 1 / 3 / 5 on.
   Returns 1 for a hit, else 0. */
int LeagueSetHitTest(int x, int y, int *item)
{
    int i;

    x -= 6;
    y -= 0x13;
    for (i = 0; i < 27; i++) {
        if (x >= LR[i].x1 && x <= LR[i].x2 && y >= LR[i].y1 && y <= LR[i].y2) break;
    }
    if (i == 27) return 0;
    switch (i) {
    case 0xA:
    case 0xB:
        return 0;
    case 0xC:
    case 0xD:
    case 0xE:
    case 0xF:
        if (sounddev == 0x10) return 0;
        break;
    case 0x10:
    case 0x11:
        if (!musicon) return 0;
        break;
    case 0x15:
        if (gamemode == 1 && gamemode <= seriesgameno) return 0;
        break;
    case 0x16:
        if (gamemode == 1 && seriesgameno >= 3) return 0;
        break;
    case 0x17:
        if (gamemode == 1 && seriesgameno >= 5) return 0;
        break;
    }
    *item = i;
    return 1;
}
