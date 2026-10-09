/* Engine input: hold button (93G holdplayer). */
#include "nhl95.h"

/* holdplayer (503CD) - hold button for player p (93G holdplayer): set pflags bit 5; with no impact target: an opponent
   in reach gets a hold (SPA 873h), else a block-shot dive when one is possible; otherwise check the
   impact target SortCords[impactp] (Acheck). */
void holdplayer(Player *p)
{
    p->pflags |= 0x20;
    if (!p->impact) {
        if (OppInReach(p) == 1) {
            SetSPA(p, 0x873);
            return;
        }
        if (CanBlockShot(p)) {
            ((void (*)(Player *))BlockShotDive)(p);  /* edx passed through unchanged */
            return;
        }
    }
    Acheck(p, &SortCords[p->impactp]);
}
