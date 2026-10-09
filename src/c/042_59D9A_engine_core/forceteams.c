#include "nhl95.h"

/* forceteams (5E0B0) - 93G forceteams: put both teams' current lines on the ice: setpersonel then forcepldata
   for the home team, then for the away team. The last call is a tail call into forcepldata, which follows in this
   file, so it compiles to a fall-through. */
void forceteams(void)
{
    setpersonel(&hmtmstruct);
    forcepldata(&hmtmstruct);
    setpersonel(&awtmstruct);
    forcepldata(&awtmstruct);
}

/* forcepldata (5E0DD) - 93G/94G forcepldata: no skating on/off, force the players of team t to their new data
   (faceoffs only). For each of the team's 6 sort objects: the requested position newpos becomes position; a
   player who stays on the ice gets his position assignment (Setplass), the center also anearest (11h) on top, his
   roster entry is marked on the ice (tmpdst -1, roster status byte 4) and setplayer loads him as newpnum. Then
   newpnum and newpos are cleared (-1). The 94G goalie check (Set4WayPlayerStub) is not here. */
void forcepldata(Team *t)
{
    Player *p = t->tmsort;      /* first sort object of the team */
    short n = 6;                /* will run the loop 6 times */

    do {
        if ((p->position = p->newpos) >= 0) {
            Setplass(p);
            if (p->position == 4) assinsert(p, 0x11);   /* C: $11 = anearest */
            t->tmpdst[p->newpnum] = -1;                 /* on the ice */
            t->tmroster[p->newpnum * 39] = 4;           /* roster status 4: on the ice */
            setplayer(p, p->newpnum);                   /* put player on the ice */
        }
        p->newpnum = -1;
        p->newpos = -1;
        p++;
    } while (--n);
}
