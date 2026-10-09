/* Engine physics / AI: puck over the wall check (93G/94G wallcollb). */
#include "nhl95.h"

/* wallcollb (58B7F) - 93G/94G wallcollb: check for the puck over the wall (called from checkwallcoll). Not the
   puck (SCnum 0Eh), or Zpos up to 12h: wallcoll. Zpos above 1Dh, or above 12h with Ypos below F8h: out of
   play. Otherwise only at |Xpos| 28h-38h with Yvel >= FA0h and lty >= 26h (else wallcoll): halve Yvel, SPA
   821h on the next struct (the glass) at x 3Fh / -40h (by the puck's side), y 10Bh, sfx AEh, crowdlevel +1200
   (max 1500) and CwdExciteLvl +15, then out of play. Out of play: sfslock (sflags bit 6), pfnc (pflags bit 2),
   attribute bit 15 when Ypos < 0, the next struct's frame -1 and, while the clock runs, penalty 3 for the
   last player to touch the puck (lasttouch); the penalty shot ends. */
void wallcollb(Player *pk)
{
    short v;
    short half;
    short level;
    short raised;

    if (pk->SCnum != 0xE) {
wall:
        wallcoll(pk);               /* not puck so wall coll */
        return;
    }
    v = HIWORD(pk->Zpos);
    if (v <= 0x1D) {
        if ((unsigned short)v <= 0x12) goto wall;
        if (HIWORD(pk->Ypos) >= 0xF8) {
            if ((HIWORD(pk->Xpos) < 0 ? -(pk->Xpos >> 16) : pk->Xpos >> 16) < 0x28
             || (HIWORD(pk->Xpos) < 0 ? -(pk->Xpos >> 16) : pk->Xpos >> 16) > 0x38
             || (v = pk->Yvel) < 0xFA0 || lty < 0x26) {
                goto wall;
            }
            half = v >> 1;          /* asr.w Yvel */
            pk->Yvel = half;
            SetSPA(pk + 1, 0x821);  /* next struct (SCstruct) */
            HIWORD(pk[1].Xpos) = HIWORD(pk->Xpos) < 0 ? -0x40 : 0x3F;
            HIWORD(pk[1].Ypos) = 0x10B;
            sfx(0xAE);
            level = crowdlevel;
            if (level <= 1500) {
                raised = level + 1200;
                crowdlevel = raised;
                if (raised > 1500) crowdlevel = 1500;
            }
            CwdExciteLvl += 15;
        }
    }
    sflags |= 0x40;                 /* sfslock */
    pk->pflags |= 4;                /* pfnc */
    if (HIWORD(pk->Ypos) < 0) HIBYTE(ATTRWORD(pk)) |= 0x80;
    pk[1].frame = -1;
    if ((gmode & 1) == 0) AddPenalty2(&SortCords[lasttouch], 3);
    EndPenaltyShot();
    onetimerflag = 0;
    shotongoal = 0;
}
