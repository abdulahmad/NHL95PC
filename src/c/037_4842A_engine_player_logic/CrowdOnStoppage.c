/* Engine player logic: crowd reaction at a stoppage. */
#include "nhl95.h"

/* CrowdOnStoppage (4E71A) - PC only: the crowd's reaction at a whistle, unless replaying (gmode bit 4), an overlay is
   up (ovltimer), and only for the stoppages RefPen 1Dh, 1Eh, 3, 4, 8 and 6: late in a period (clock
   below half of PerTimeTotal, at least 60 s left) with sflags3 bit 7 set a one-time sample 2; the period ending
   (gsp 2) sample 5; with speech on and music on a strength difference sometimes cheers or boos (4 / 1); otherwise
   one of 8: 0 the team power-play / penalty-kill overlay (LoadTeamPPV 0, sfx on, a sound card, crowd not too loud;
   returns 1 when shown), 1 the other overlay (LoadTeamPPV 2) with sample 9, 2-4 samples 6-8, 5 sample 0Bh. Returns
   1 when an overlay was shown, else 0. */
int CrowdOnStoppage(void)
{
    int diff;
    int r;
    int other;                  /* 1: a stoppage the crowd ignores */

    if (gmode & 0x10) return 0;
    if (ovltimer != -1) return 0;
    if (RefPen != 0x1D && RefPen != 0x1E && RefPen != 3 && RefPen != 4 && RefPen != 8 && RefPen != 6) other = 1;
    else other = 0;
    if (other) return 0;
    if (PerTimeTotal >> 1 > gameclock && gameclock >= 0x3C && (sflags3 & 0x80)) {
        sflags3 &= 0x7F;
        PlayCrowdSample(2);
        return 0;
    }
    if (gsp == 2 && gameclock <= periodendtime) {
        periodendtime = -1;
        PlayCrowdSample(5);
        return 0;
    }
    if (gameopts.speech && musicon) {
        diff = awtmap - hmtmap[0];
        if (diff != 0 && !randomd0(4)) {
            if (diff > 0) PlayCrowdSample(4);
            else PlayCrowdSample(1);
            return 0;
        }
    }
    r = randomd0(8);
    if (dword_CC0EC == 0 && r == 0) {
        if (!gameopts.sfx || !(sounddev & 0x2A) || crowdlevel > 700) return 0;
        LoadTeamPPV(0);
        if (ovlseq == -1) return 0;
        CloseTextOverlay();
        return 1;
    }
    if (dword_CC0EC == 0 && r == 1) {
        LoadTeamPPV(2);
        if (ovlseq == -1) return 0;
        PlayCrowdSample(9);
        CloseTextOverlay();
        return r;
    }
    if (r < 5) PlayCrowdSample(r + 4);
    else if (r == 5) PlayCrowdSample(0xB);
    return 0;
}
