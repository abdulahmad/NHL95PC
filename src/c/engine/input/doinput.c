/* Engine input: a controlled player's input. */
#define lcselect lcselect_decl
#include "nhl95.h"
#undef lcselect

short lcselect(Player *p, int n);

/* doinput (504DA, 93G logic93 doinput): handle the pad for controlled player p (ctl: the controller, for
 changeplayer). The pads were read by Readjoy1 / Readjoy2: regd0 is the d-pad direction, regd1 the new presses
 (bit 4 B, 5 C, 6 A). Nothing while a penalty shot is set up or live and the clock is stopped. A line change
 request of p's team (lcrequest) goes to lcselect (unless a penalty shot is live; with both pads on one team only
 for controller 1's player; while the clock is stopped only in line change mode), clearing the blink / box when
 it took, then the request. Then: faceoff (gmode2 bit 0) -> faceoffinput; line change mode (pflags2 bit 3) ->
 lineinput; during the intro (puck assignment 1Ch, no penalty shot) B or C skips it (introskipped). Only a
 player under joystick control (pflags bit 3) goes on. Locked (pflags bit 5, not carrying the puck,
 dword_CCC9C clear): B changes player; the pass receiver keeps his one-timer direction (passdir from the d-pad);
 otherwise with the puck loose, C pressed and the pass receiver a team-mate skater who is not under control
 (and not pflags2 bit 2), control moves to him (restorepl for the right pad) for a one-timer (onetimerflag).
 The puck carrier: checkob, then passmode / ShotMode while those modes are on, B setpassmode, A SetLCmode (no
 live penalty shot), C SetShotMode (not the goalie, who also stops while an animation runs), else skate. Others:
 A holdplayer, B changeplayer; the pass receiver C burst (and the one-timer direction / B / skate as above);
 else the same switch to the receiver, C burst, or skate (doplayeracc in the d-pad direction). No result. */
void doinput(Player *p, short ctl)
{
    int team;
    Player *pp;

    team = (p->pflags & 0x40) != 0;
    if ((penshotmode || penshotlive) && (gmode & 1)) return;
    if (lcrequest[team] && !penshotlive && (cont1team != cont2team || p->SCnum == c1playernum[0])) {
        if (!(gmode & 1) || (p->pflags2 & 8)) {
            if (lcselect(p, lcreqchoice[team])) {
                lcblink[team] = 0;
                lcboxon[team] = 0;
            }
        }
        lcrequest[team] = 0;
    }
    if (gmode2 & 1) {
        faceoffinput(p);
        return;
    }
    if (p->pflags2 & 8) {
        lineinput(p);
        return;
    }
    if (puckasslist[((short *)puckstruct)[0xE]] == 0x1C && !penshotmode) {
        if ((regd1.w & 0x10) || (regd1.w & 0x20)) introskipped = 1;
        return;
    }
    if (!(p->pflags & 8)) return;
    if (p->pflags & 0x20) {
        if (*puckc == p->SCnum) return;
        if (dword_CCC9C) return;
        if (regd1.w & 0x10) {
            changeplayer(p, ctl);
            return;
        }
        if (passplayer == p->SCnum) {
            if (onetimerflag) passdir = regd0.w & 0xF;
            return;
        }
        pp = &SortCords[passplayer];
        if (*puckc < 0 && (regd1.w & 0x20) && passplayer >= 0 && pp->position > 0
            && (passplayer < 6) == (p->SCnum < 6) && !(pp->pflags & 8) && !(pp->pflags2 & 4)) {
            if (c1playernum[0] == p->SCnum) {
                if (pp->SCnum != c1playernum[0]) c1playernum[0] = restorepl(pp->SCnum, c1playernum[0]);
            } else {
                if (pp->SCnum != c2playernum[0]) c2playernum[0] = restorepl(pp->SCnum, c2playernum[0]);
            }
            onetimerflag = 1;
        }
        return;
    }
    if (*puckc == p->SCnum) {
        checkob(p);
        if (p->position == 0 && (p->pflags2 & 2)) return;
        if (sflags & 4) {
            passmode(p);
            return;
        }
        if (sflags & 8) {
            ShotMode(p);
            return;
        }
        if (regd1.w & 0x10) {
            setpassmode(p);
            return;
        }
        if ((regd1.w & 0x40) && !penshotlive) {
            SetLCmode(p);
            return;
        }
        if (p->position == 0) return;
        if (regd1.w & 0x20) {
            SetShotMode(p);
            return;
        }
        goto acc;
    }
    if (dword_CCC9C) return;
    if (regd1.w & 0x40) {
        holdplayer(p);
        return;
    }
    if (regd1.w & 0x10) {
        changeplayer(p, ctl);
        return;
    }
    if (p->position == 0) return;
    pp = &SortCords[passplayer];
    if (passplayer == p->SCnum) {
        if (regd1.w & 0x20) burst(p);
        if (onetimerflag) {
            passdir = regd0.w & 0xF;
            return;
        }
        if (regd1.w & 0x10) {
            changeplayer(p, ctl);
            return;
        }
        if (!dword_CCC9C) doplayeracc(p, regd0.w);
        return;
    }
    if (*puckc < 0 && (regd1.w & 0x20) && passplayer >= 0 && (passplayer < 6) == (p->SCnum < 6)
        && !(pp->pflags & 8) && !(pp->pflags2 & 4)) {
        if (c1playernum[0] == p->SCnum) {
            if (pp->SCnum != c1playernum[0]) c1playernum[0] = restorepl(pp->SCnum, c1playernum[0]);
        } else {
            if (pp->SCnum != c2playernum[0]) c2playernum[0] = restorepl(pp->SCnum, c2playernum[0]);
        }
        onetimerflag = 1;
        return;
    }
    if (regd1.w & 0x20) {
        burst(p);
        return;
    }
    if (dword_CCC9C) return;
acc:
    doplayeracc(p, regd0.w);
}
