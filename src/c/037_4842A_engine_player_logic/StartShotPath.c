/* Engine player logic: shootout path. */
#include "nhl95.h"

/* StartShotPath (4F9EF) - pick the skating path for a penalty shot / shootout by p: from far out (dist >= 27h) straight
   in when |x| > 20 (path x 0), else 2Ch to one side; close in 3Ah to one side. The side: by stick hand
   (handed) 3 times in 4, else a coin flip; mirrored for the end p attacks (pflags bit 7). Sets sopathx /
   pspathside, sopathy, sopathend (and sopathpoint 2 from far out). */
void StartShotPath(Player *p, int dist)
{
    int x;

    if (dist >= 0x27) {
        x = HIWORD(p->Xpos);
        if (x < 0) x = -x;
        if (x > 0x14) {
            pspathside = sopathx = 0;
        } else {
            x = 0x2C;
            if (randomd0(4)) {
                if (p->handed) x = -0x2C;
            } else if (randomd0(16) < 8) {
                x = -0x2C;
            }
            if (!(p->pflags & pfgoal)) x = -x;
            pspathside = sopathx = x;
        }
        sopathpoint = 2;
        sopathy = 0x97;
        sopathend = 0x66;
        return;
    }
    x = 0x3A;
    if (randomd0(4)) {
        if (p->handed) x = -0x3A;
    } else if (randomd0(16) < 8) {
        x = -0x3A;
    }
    if (!(p->pflags & pfgoal)) x = -x;
    pspathside = sopathx = x;
    sopathy = 0x3C;
    sopathend = 0x1E;
}
