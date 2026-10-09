/* Engine display: goalie pulled / back banner. */
#include "nhl95.h"

#define CTEAM(c) (*(int *)((char *)&(c) - 2) >> 16)  /* the word, read as the top half of a dword */

/* ShowGoalieBanner (671E8) - PC only: when team side is a human team (cont1team / cont2team = side + 1) during a
   game and its goalie is set (tmgoalie top 12 bits not FF0h): toggle the goalie: banner message 1 (goalie in,
   tmgoalie >= 0, i.e. pulled) or 0, shown 80 frames unless a higher message is up. A pulled goalie's menu flag
   (off_CD498 by goalie number) goes 2, the "extra attacker" flag (off_CD4A0) 1 and tmgoalie gets FFF0h; else the
   reverse with the goalie number kept. Then setpersonel. */
void ShowGoalieBanner(short side)
{
    short g;
    short in;
    short m;
    unsigned char *f;

    g = (&hmtmstruct)[side].tmgoalie;
    if (curperiod == -1) return;
    if (CTEAM(cont1team) != side + 1 && CTEAM(cont2team) != side + 1) return;
    if ((g & 0xFFF0) == 0xFF00) return;
    in = (unsigned)(g >= 0);
    m = bannermsg;
    if (in > m || m < 2) {
        bannermsg = in;
        bannertimer = 0x50;
    }
    if (g < 0) {
        *(unsigned char *)*(int *)((char *)off_CD4A0 + side * 12) = 2;
        (&hmtmstruct)[side].tmgoalie &= 0xF;
        f = (unsigned char *)off_CD498[side * 3 + (&hmtmstruct)[side].tmgoalie];
    } else {
        *(unsigned char *)off_CD498[side * 3 + (g & 0xF)] = 2;
        (&hmtmstruct)[side].tmgoalie |= 0xFFF0;
        f = (unsigned char *)*(int *)((char *)off_CD4A0 + side * 12);
    }
    *f = 1;
    setpersonel(&(&hmtmstruct)[side]);
}
