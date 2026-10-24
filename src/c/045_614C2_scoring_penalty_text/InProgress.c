/* Scoring / penalty text: calling the penalties at a stoppage. */
#define word_CBC44 word_CBC44_decl
#include "nhl95.h"
#undef word_CBC44
/* InProgress compares word_CBC44 in memory on every pass of its goto loop; as a plain short Watcom loads it
   into cx once before the loop. Declared volatile in this module, it is read in place. */
extern volatile short word_CBC44;

void PostPenaltyEvent(int away, int pl, int type, int tag, int min, int sec, int n);

/* DRAFT: same size under 10.0 GA, 88 differing. Everything up to +102 matches (the mins sign tests nested as
   `if (mins <= 0) { if (mins < 0) ... else ... }` give the EXE's jg / jge layout; the puck assignment through
   the int d gives `add eax, puckstruct`). Left: from the PenBuf_pl test on, the register picks (the i * 2
   index in edx, EXE eax; the PenBuf_pl byte in bl, EXE dh) and pl reloaded from [ebp-14h] for pl->pnum (EXE
   keeps it in edx); see docs/UNSURE.md. */
/* InProgress (62EE9, PC only; owner of InProgress_popebp / InProgress_popx): call the next queued penalty when
   play is stopped (RefStep set, no play-by-play talking). With no penalty left (PenBuf empty) and no overlay
   running, update both teams' strength (tmap 6, less one per player in the box down to 4, the box flag bit 13
   cleared) and send the puck to its stoppage assignment (1Bh). Else take the last queued penalty: one already
   called waits for its player to reach the box; a penalty shot (1Ah) starts it; a non-penalty (no minutes)
   only sets the referee's signal (with sflags bit 7 or word_CBC44 set, one other than 7 goes straight on to the
   next queued penalty); a minus-minute entry (a coincidental minor) and a real penalty put the player
   in the box (tmpdst minutes * 60, bits 13 / 14), count it in the team and player stats, add it to the panel
   and the play-by-play (PostPenaltyEvent, the time left in the period), and send him off (assignment 0Ch); a
   player already in the box has one of his teammates on the ice serve it ("served by"). Then the referee's
   signal (SetPA). No arguments, no result. */
void InProgress(void)
{
    Player *pl;
    Team *tm;
    short pen;
    short mins;
    short pnum;
    short i;
    short t;
    int d;
    short n;

    if (!RefStep[0] || PaSpeechBusy()) return;
again:
    if (!PenBuf[0]) {
        if (ovlseq != 0 && ovlseq != 2 && ovltimer >= 0) return;
        for (i = 0, tm = &hmtmstruct; i < 2; i++, tm = &awtmstruct) {
            n = 6;
            for (t = 0x1B; t >= 0; t--) {
                if (tm->tmpdst[t] > 0) {
                    ((unsigned char *)&tm->tmpdst[t])[1] &= 0xDF;
                    if (!(((unsigned char *)&tm->tmpdst[t])[1] & 0x10) && n > 4) n--;
                }
            }
            tm->tmap = n;
        }
        gmode &= 0xFB;
        d = (int)puckstruct + ((Player *)puckstruct)->assnum;
        i = ((signed char *)d)[0x1E];
        if (i == 0x1B || i == 0x1C) return;
        assreplace((Player *)puckstruct, 0x1B);
        return;
    }
    for (i = 1; PenBuf[i * 2]; i++);
    i--;
    if (!(PenBuf_pl[i * 2] & 0x80)) {
        pl = &SortCords[PenBuf_pl[i * 2]];
        if (pl->position >= 0) return;
        PenBuf[i * 2] = PenBuf_pl[i * 2] = 0;
        return;
    }
    PenBuf_pl[i * 2] &= 0x7F;
    pen = PenBuf[i * 2];
    if (pen == 0x1A) {
        StartPenaltyShot();
        t = PerTimeTotal - gameclock;
        if (gameclock < 0x3C && clockticks[0]) t--;
        pl = &SortCords[PenBuf_pl[i * 2]];
        PenBuf[i * 2] = PenBuf_pl[i * 2] = 0;
        PostPenaltyEvent((pl->pflags & 0x40) != 0, pl->pnum, pen - 9, 0, t / 60, t % 60, 0);
        goto signal;
    }
    mins = penmintab[pen];
    if (mins <= 0) {
        if (mins < 0) {
            pl = &SortCords[PenBuf_pl[i * 2]];
            tm = pl->tmptr;
            tm->tmroster[pl->pnum * 0x27] = 8;
            if (tm->tmpdst[pl->pnum] > -3) assreplace(pl, 0x1D);
            tm->tmpdst[pl->pnum] = -5;
            t = PerTimeTotal - gameclock;
            if (gameclock < 0x3C && clockticks[0]) t--;
            PostPenaltyEvent((pl->pflags & 0x40) != 0, pl->pnum, pen - 9, mins, t / 60, t % 60, i);
            word_C90D8 = PenBuf_pl[i * 2];
            PenBuf[i * 2] = PenBuf_pl[i * 2] = 0;
        } else {
            word_C90D8 = PenBuf_pl[i * 2];
            PenBuf[i * 2] = PenBuf_pl[i * 2] = 0;
            if ((sflags & 0x80) || word_CBC44) {
                if (pen != 7) goto again;
            }
        }
        goto signal;
    }
    pl = &SortCords[PenBuf_pl[i * 2]];
    tm = pl->tmptr;
    tm->tmpen++;
    tm->tmpenmin += mins;
    pnum = pl->pnum;
    if (pnum < 0x19) tm->tmplstats[pnum * 8 + 2] += mins;
    PanelAddPenalty((pl->pflags & 0x40) != 0, pl->rostnum, mins);
    t = PerTimeTotal - gameclock;
    if (gameclock < 0x3C && clockticks[0]) t--;
    PostPenaltyEvent((pl->pflags & 0x40) != 0, pl->pnum, pen - 9, mins, t / 60, t % 60, i);
    mins *= 60;
    if (mins == 0x12C) ((unsigned char *)&mins)[1] |= 0x40;
    ((unsigned char *)&mins)[1] |= 0x20;
    if (tm->tmpdst[pnum] == -3 || tm->tmpdst[pnum] == -4) {
        for (pl = tm->tmsort, t = 0; t < 6; t++, pl++) {
            if (pl->position > 0 && tm->tmpdst[pl->pnum] == -1 && !(pl->pflags2 & 0x10)) break;
        }
        if (t == 6) return;
        pnum = pl->pnum;
        PenBuf_pl[i * 2] = PenBuf_pl[i * 2] & 0x80 | pl->SCnum;
        sprintf((char *)&textline5, (char *)str_ServedByD, pl->rostnum);
    }
    if (tm->tmpdst[pnum] >= 0 && (((unsigned char *)&tm->tmpdst[pnum])[1] & 0x10)) ((unsigned char *)&mins)[1] |= 0x10;
    tm->tmpdst[pnum] = mins;
    tm->tmroster[pnum * 0x27] = 5;
    for (i = 0; i < 0x1C; i++)
        if (tm->tmpbox[i] < 0) break;
    tm->tmpbox[i] = pnum;
    tm->tmpbox[i + 1] = -1;
    assreplace(pl, 0xC);
    word_C90D8 = pl->SCnum;
signal:
    SetPA(pen);
}

/* The EXE splits it: its entry (63C0C) follows PenaltyManager, which falls into it (marked with PenaltyManager),
   and the rest (chkprogress_go, chkprogress_x) follows InProgress (marked as chkprogress_go; tools/splice.py). */
/* chkprogress (63C0C; 93G penalty93 chkprogress): the penalty call in progress, each frame while the game runs
   (gmode bit 0): update the text overlay, count word_CC0B0 down (at the end set gmode2 bit 2), and with a call
   pending (gmode bit 2) either run it (InProgress, while Pencntdwn is negative) or count refsignal and Pencntdwn
   down; when Pencntdwn runs out, end the call (gmode bit 3 cleared) and, at the first penalty in PenBuf whose
   type has a penmintab entry, stop play for it: gmode2 bit 2, the puck to no one with the faceoff assignment
   (1Ah), pucktemp1 1C20h, RefStep byte 1 FFh, and the banner cleared when no banner is up. No arguments and no
   result. */
void chkprogress(void)
{
    short i;

    if (!(gmode & 1)) return;
    UpdateTextOverlay();
    if (word_CC0B0[0] >= 0) {
        if (--word_CC0B0[0] < 0) gmode2 |= 4;
    }
    if (!(gmode & 4)) return;
    if (Pencntdwn < 0) {
        InProgress();
        return;
    }
    if (--refsignal < 0) refsignal = 0;
    if (--Pencntdwn >= 0) return;
    gmode &= 0xF7;
    refsignal = 0;
    i = 0;
    for (;;) {
        if (PenBuf[i++ * 2] == 0) return;
        if (penmintab[PenBuf[i * 2 - 2]]) break;
    }
    gmode2 |= 4;
    word_CC0B0[0] = -1;
    word_CBC44 = 1;
    *(unsigned char *)puckc = 0xFF;
    assinsert((Player *)puckstruct, 0x1A);
    pucktemp1 = 0x1C20;
    ((unsigned char *)RefStep)[1] = 0xFF;
    refsignal = 0;
    if (bannertimer == 0) bannermsg = -1;
}


/* ProcessPenaltyList (63A37, PC only; ends in InProgress_popx): once a second, count down the penalties of team
   tm's players in the box (tmpbox, ended by a negative byte): only the first two (regd1 from 2) serve time; a
   player whose minutes (tmpdst, low 14 bits) run out is back on the bench (roster status 7, tmpdst bit 14
   cleared) and the box list shifts down over him. Then the first one or two of them (by how many served) may be
   released onto the ice (CheckAndReleasePlayer). tm: the team. No result. */
void ProcessPenaltyList(Team *tm)
{
    signed char out[4];
    short n;
    short i;
    short k;
    short t;

    regd1.l = 2;
    regd3.l = 2;
    for (n = 0, i = 0; i < 0x1C; i++) {
        k = tm->tmpbox[i];
        if (k < 0) break;
        if (--regd1.w < 0) continue;
        out[n++] = k;
        t = --tm->tmpdst[k];
        if (t & 0x3FFF) continue;
        tm->tmroster[k * 0x27] = 7;
        ((unsigned char *)&tm->tmpdst[k])[1] &= 0xBF;
        for (regd2.w = 1;; regd2.w++) {
            if ((((signed char *)tm)[0xB5 + regd2.w + i] = tm->tmpbox[regd2.w + i]) < 0) break;
        }
        i--;
    }
    if (regd1.w == 1) CheckAndReleasePlayer(tm, out[0]);
    else if (regd1.w == 0) {
        CheckAndReleasePlayer(tm, out[0]);
        CheckAndReleasePlayer(tm, out[1]);
    } else if (regd1.w == -1) CheckAndReleasePlayer(tm, out[1]);
}

/* PenaltyManager (63BF8; 93G penalty93 PenaltyManager): the penalty work of a frame: the penalty times
   (updatepentime), new penalties (checkfornewpen) and the call in progress (chkprogress, which it falls into). No
   arguments and no result. */
void PenaltyManager(void)
{
    updatepentime();
    checkfornewpen();
    chkprogress();
}


/* ShotLaneOpen (64102, PC only; ends in InProgress_popebp): is the puck carrier's shooting lane open? Not when
   nobody has the puck or he is in his own half. Else his distance to the net he attacks (y E8h, vecdist) must be
   shorter than every opposing skater's (position above 0) who is nearer to that net than he is (4 behind him)
   and not skating away from it, and no such skater may be beyond him. Sets shotontarget. No arguments.
   Result: 1 when the lane is open, else 0. The EXE keeps a second stack word m that is always 0 and computes
   `d - m` again on every pass of the opponent loops: m is volatile here (a plain m is folded away). Each
   opponent's distance goes through ty, dead by then (the dead-local pattern), which keeps `d - m` in the loop. */
int ShotLaneOpen(void)
{
    Player *p;
    int y;
    int ty;
    int x;
    int d;
    volatile int m;
    int i;

    shotontarget = 0;
    if (*puckc < 0) return 0;
    x = *puckc;
    p = SortCords + x;
    y = HIWORD(p->Ypos);
    ty = y;
    x = HIWORD(p->Xpos);
    if (p->pflags & 0x80) {
        if (y < 0) return 0;
        y += 4;
        d = vecdist(ty - 0xE8, x);
        m = 0;
        for (i = 0, p = &SortCords[p->SCnum < 6 ? 6 : 0]; i < 6; i++, p++) {
            int px;
            if (p->position <= 0) continue;
            px = HIWORD(p->Xpos);
            if (HIWORD(p->Ypos) > y) return 0;
            if (p->Yvel < 0) continue;
            ty = vecdist(HIWORD(p->Ypos) - 0xE8, px);
            if (ty <= d - m) return 0;
        }
    } else {
        if (y > 0) return 0;
        y -= 4;
        d = vecdist(ty + 0xE8, x);
        m = 0;
        for (i = 0, p = &SortCords[p->SCnum < 6 ? 6 : 0]; i < 6; i++, p++) {
            int px;
            if (p->position <= 0) continue;
            px = HIWORD(p->Xpos);
            if (HIWORD(p->Ypos) < y) return 0;
            if (p->Yvel > 0) continue;
            ty = vecdist(HIWORD(p->Ypos) + 0xE8, px);
            if (ty <= d - m) return 0;
        }
    }
    shotontarget = 1;
    return 1;
}

/* PenGoalStuff (63D69, PC only; ends in InProgress_popebp): after a goal by side, settle the queued penalties
   and the power play. Unless the goal ends a tied shootout-period game (gsp 3, scores not equal), the queued
   penalties that still stand (a match penalty, minutes -1 / 5, or a minor 2 on the team that was not scored on,
   by PenBuf_pl below 6) move to the front of PenBuf; the others are dropped (the player's box flag in scpflags2
   cleared for the skaters). With nothing left the "penalty" banner (6) goes. When the scoring team had the
   advantage (tmap above the other's), the first player in the other team's box serving a minor (tmpdst bit 14
   clear) comes out: tmpdst 0, roster status 7, released (releasepl), off the panel (PanelRemovePenalty), the box
   list shifted down; the scoring team counts a power-play goal (tmppg) and both teams' flags bit 0 are set.
   side: 0 home, 1 away. No result. */
void PenGoalStuff(short side)
{
    Team *st;
    Team *ot;
    short n;
    short i;
    int m;
    int other_side;

    st = side > 0 ? &awtmstruct : &hmtmstruct;
    other_side = side == 0;
    ot = other_side ? &awtmstruct : &hmtmstruct;
    for (n = 0, i = 0; PenBuf[i * 2]; i++) {
        if (gsp != 3 || hmscore[0] == awscore ? 1 : 0) {
            m = penmintab[PenBuf[i * 2]];
            if (m == -1 || penmintab[PenBuf[i * 2]] == 5
                || penmintab[PenBuf[i * 2]] == 2 && (PenBuf_pl[i * 2] < 6) ^ side) {
                if (n != i) {
                    PenBuf[n * 2] = PenBuf[i * 2];
                    PenBuf_pl[n * 2] = PenBuf_pl[i * 2];
                    n++;
                }
                continue;
            }
        }
        if (PenBuf_pl[i * 2] >= 0 && PenBuf_pl[i * 2] < 0xC) scpflags2[PenBuf_pl[i * 2] * 0x80] &= 0xEF;
        PenBuf[i * 2] = PenBuf_pl[i * 2] = 0;
    }
    if (!PenBuf[0] && bannermsg == 6) bannermsg = -1;
    if (st->tmap <= ot->tmap) return;
    for (i = 0; i < 0x1C; i++) {
        n = ot->tmpbox[i];
        if (n < 0) return;
        if (!(((unsigned char *)&ot->tmpdst[n])[1] & 0x40)) break;
    }
    ot->tmpdst[n] = 0;
    ot->tmroster[n * 0x27] = 7;
    releasepl(ot, n);
    PanelRemovePenalty(side == 0, ot->tmroster[n * 0x27 + 5]);
    for (n = 1;; n++) {
        if ((((signed char *)ot)[0xB5 + n + i] = ot->tmpbox[n + i]) < 0) break;
    }
    st->tmppg++;
    hmtmflags[0] |= 1;
    awtmflags |= 1;
}
