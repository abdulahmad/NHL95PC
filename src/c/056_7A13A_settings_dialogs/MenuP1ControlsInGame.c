/* Settings dialogs: the in-game controls dialog and its control reassignment (one source block: the dialog's end
   follows ClearCtlBlink, and ReassignCtlPlayer / ClearCtlBlink end in its exit). */
#include "nhl95.h"

/* DRAFT (whole file): every function's body matches on its own (ClearCtlBlink and MenuP2ControlsInGame byte for byte,
   ControlsDlgInGame's head and tail, ReassignCtlPlayer up to stack slots / the px register), but the EXE has
   ControlsDlgInGame split: its code from the ctl1team test on (ControlsDlgInGame_side .. ControlsDlg_ret0) sits after
   ClearCtlBlink, where this compiles it in one piece. Neither cc.py nor cdiff can splice a split function yet. */

typedef struct Hdr17 { char c[17]; } Hdr17;
#define TEAM(t) ((&hmtmstruct)[t])


/* MenuP1ControlsInGame (7CAF7) - PC only: the in-game controls dialog for controller 1. */
void MenuP1ControlsInGame(void)
{
    ControlsDlgInGame(0);
}

/* ControlsDlgInGame (7CB03) - PC only: the controls dialog during a game for controller side: load the BKGD4
   background, save the screen under it (at 98h, 0ECh in its header), run the dialog (DrawControlsDlg /
   DrawControlsOpts / ControlsDlgLoop) and restore the screen. Then apply the choice: the controller's team
   (cont1team / cont2team: 0 none, 1 home, 2 away from ctl1team / ctl1side), samesideflag when both controllers
   are on one side, the pad device bit (pad1dev) from ctl1dev, the controlled player (ReassignCtlPlayer) and the
   line change blink (ClearCtlBlink); a team that gets or loses its controllers swaps its score / flags
   (CtlSwapScoreFix / CtlSwapTeamFlag). */
int ControlsDlgInGame(int side)
{
    int bkgd;
    int buf;
    int result;
    int team;
    int old1;
    int old2;

    result = 0;
    buf = bkgd = sub_8CCA8((char *)str_BKGD4, 0x8C31, 0x20);
    *(Hdr17 *)buf = *(Hdr17 *)pointerspr;
    *(short *)(buf + 4) = 0x98;
    *(short *)(buf + 6) = 0xEC;
    sub_91400(buf, 0xA, 0x13);
    DrawControlsDlg(0);
    DrawControlsOpts(side);
    ControlsDlgLoop(side);
    sub_903F0(buf, 0xA, 0x13);
    if (ctl1team[side] < 0) team = 0;
    else if (ctl1side[side] == 0) team = 1;
    else team = 2;
    old1 = cont1team;
    old2 = cont2team;
    if (side) cont2team = team;
    else cont1team = team;
    if (ctl1team[0] >= 0 && ctl2team >= 0 && ctl1side[0] == ctl2side) samesideflag = 1;
    else samesideflag = 0;
    switch (ctl1dev[side]) {
    case 1: pad1dev[side] = 1; break;
    case 2: pad1dev[side] = 2; break;
    case 4: pad1dev[side] = 4; break;
    case 8: pad1dev[side] = 8; break;
    case 0x10: pad1dev[side] = 0; break;
    }
    ReassignCtlPlayer(side);
    ClearCtlBlink();
    if (byte_DFF3A[puckstruct[6] >> 16] == 0x1B && team == 1 && old1 != team && old2 != team) word_DFF42 = 0;
    for (team = 1; team <= 2; team++) {
        if ((old1 == team || old2 == team) && cont1team != team && cont2team != team)
            CtlSwapScoreFix(team == 2);
        else if (old1 != team && old2 != team && (cont1team == team || cont2team == team))
            CtlSwapTeamFlag(team == 2);
    }
    jctime(buf);
    return result;
}

/* MenuP2ControlsInGame (7CB9F) - PC only: the in-game controls dialog for controller 2. */
void MenuP2ControlsInGame(void)
{
    ControlsDlgInGame(1);
}

/* ReassignCtlPlayer (7CCE5) - PC only (as 94G's controller assignment): after the controls changed, give controller
   side the player of its team nearest the puck's next position (puck + velocity / 256): skaters on the ice
   (position >= 0, not pflags2 bit 2 or pflags bit 20h), the puck carrier counting as nearest, not the player the
   other controller has. A controller without a team gives its player up (-1); one whose player is already on its
   team keeps it. restorepl swaps the old and the new player. */
void ReassignCtlPlayer(int side)
{
    short *team;
    short *pnum;
    short py;
    short best;
    short px;
    struct Player *p;
    short n;
    int dx;
    int d;
    int bestd;
    short pl;

    if (side) {
        team = &cont2team;
        pnum = c2playernum;
    } else {
        team = &cont1team;
        pnum = c1playernum;
    }
    if (*team == 0) {
        if (*pnum == -1) return;
        best = -1;
    } else {
        if (*team == 1 && *pnum >= 0 && *pnum <= 5) return;
        if (*team == 2 && *pnum >= 6 && *pnum <= 11) return;
        px = (*puckvx >> 8) + *puckx;
        py = *pucky + (*puckvy >> 8);
        bestd = 0x10000000;
        if (*team == 1) p = SortCords;
        else p = SortCords + 6;
        n = 6;
        do {
            if (p->position >= 0 && !(p->pflags2 & 4) && !(p->pflags & 0x20)) {
                dx = px - HIWORD(p->Xpos);
                d = py - HIWORD(p->Ypos);
                d = dx * dx + d * d;
                if ((short)*puckc == p->SCnum) d = -1;
                if (d <= bestd) {
                    pl = p->SCnum;
                    if (pl != (side ? c1playernum[0] : c2playernum[0])) {
                        bestd = d;
                        best = pl;
                    }
                }
            }
            p++;
        } while (--n);
    }
    if (side == 0) {
        if (best != c1playernum[0]) c1playernum[0] = restorepl(best, c1playernum[0]);
    } else {
        if (best != c2playernum[0]) c2playernum[0] = restorepl(best, c2playernum[0]);
    }
}

/* ClearCtlBlink (7CEA1) - PC only: for each team without a controller: stop its line change blink (lcblink /
   lcboxon), clear pf2lcm on its six players and bit 1 of tmflags, and move it off a line that does not fit the
   strength: short-handed (tmap below the other team's) to line 6 unless already 6 up, power play to line 4 unless
   on 4 / 5, even strength from line 3 up back to line 0. */
void ClearCtlBlink(void)
{
    int t;
    int i;
    int diff;
    int line;
    int team;

    for (t = 0; t < 2; t++) {
        team = (t != 0) + 1;
        if (cont1team == team || cont2team == team) continue;
        lcboxon[t] = lcblink[t] = 0;
        if (t) {
            for (i = 6; i < 12; i++) SortCords[i].pflags2 &= ~pf2lcm;
        } else {
            for (i = 0; i < 6; i++) SortCords[i].pflags2 &= ~pf2lcm;
        }
        TEAM(t).tmflags &= ~2;
        diff = TEAM(t == 0).tmap - TEAM(t).tmap;
        line = TEAM(t).tmline;
        if (diff > 0 && line < 6) TEAM(t).tmline = 6;
        if (diff < 0 && (line > 5 || line < 4)) TEAM(t).tmline = 4;
        if (diff == 0 && line >= 3) TEAM(t).tmline = 0;
    }
}
