/* Joystick calibration file: menu hit test. */
#define MenuHitTest MenuHitTestDecl
#include "nhl95.h"
#undef MenuHitTest

typedef struct MenuItem {
    int x1, y1, x2, y2;
    char *text;
    int on1, on2;
    int pad;
} MenuItem;

/* MenuHitTest: from menu i down to 0, the first item whose box (origin + x1,y1,x2,y2) contains
 (x + 4, y). Writes the menu and item indexes. Returns 1 for a hit.
 The item pointer m (declared between j and o, assigned before o) lets Watcom reuse the loop test's i * 4 as
 in the EXE; under 10.0 LA that shape returned through edx, under 10.0 GA it matches. */
int MenuHitTest(int x, int y, MenuItem **menus, int i, int *counts, int *origin,
                int *hitMenu, int *hitItem)
{
    int j;
    MenuItem *m;
    int *o;

    x += 4;
    for (; i >= 0; i--) {
        if (!menus[i]) continue;
        for (j = 0; j < counts[i]; j++) {
            m = &menus[i][j];
            o = origin + i * 2;
            if (x < o[0] + m->x1) continue;
            if (x > o[0] + m->x2) continue;
            if (y < o[1] + m->y1) continue;
            if (y > o[1] + m->y2) continue;
            *hitMenu = i;
            *hitItem = j;
            return 1;
        }
    }
    return 0;
}
