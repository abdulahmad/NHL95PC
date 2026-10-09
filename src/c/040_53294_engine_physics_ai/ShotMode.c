/* Engine physics / AI: shot wind-up. */
#include "nhl95.h"

/* ShotMode (578FA) - shot wind-up of p (frame counter SPAnum): from frame 14 shoot (doshot). Without regd0 bit 3 the
   aim direction (regd0 & 7) becomes passdir. Before frame 10 a release (regd1 bit 4 or 6) ends the wind-up: clear
   sflags bit 3, flag 20h, and switch the slap SPAs 3F9h/491h/DD3h/E2Bh to their follow-through 1265h/12DDh/
   1355h/138Dh. Otherwise before frame 8 count word_C90A6 and jump to the mirrored frame (14 - SPAnum) for a weak
   shooter (shotspd < 10) past frame 4 or when regd2 bit 5 is set. */
void ShotMode(Player *p)
{
    if (p->SPAnum >= 0xE) {
        doshot(p);
        return;
    }
    if (!(regd0.w & 8)) passdir = regd0.w = regd0.w & 7;
    if (p->SPAnum >= 10) return;
    if ((regd1.w & 0x10) || (regd1.w & 0x40)) {
        sflags &= 0xF7;
        p->pflags |= 0x20;
        switch ((unsigned short)p->SPA) {
        case 0x3F9:
            p->SPA = 0x1265;
            break;
        case 0x491:
            p->SPA = 0x12DD;
            break;
        case 0xDD3:
            p->SPA = 0x1355;
            break;
        case 0xE2B:
            p->SPA = 0x138D;
            break;
        }
        return;
    }
    if (p->SPAnum >= 8) return;
    word_C90A6++;
    if (p->shotspd < 10 && p->SPAnum > 4) p->SPAnum = 0xE - p->SPAnum;
    else if (regd2.w & 0x20) p->SPAnum = 0xE - p->SPAnum;
}
