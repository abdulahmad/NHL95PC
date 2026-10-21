/* Engine assignment faceoff: the faceoff setup (puckfaceoff) and the drop (puckfaceoff2). */
/* DRAFT: 1259 vs 1270 bytes, first pass; see docs/UNSURE.md. Its match belongs in TakePlayerFromBox.c, between
   PenShotStart and asstakeposition, since it ends in TakePlayerFromBox_ret6. */
#include "nhl95.h"

/* puckfaceoff (516E1, 93G puckfaceoff; ends in TakePlayerFromBox_ret6): asstab 1Bh, the faceoff setup ("this is
   where the action starts"). On a new assignment (pflags bit 1): free the puck (a penalty-shot goalie carrying it
   gets nopuck 78h and the puck stops), then end the game when the clock and ticks are out or gmode bit 6 is set
   (SetExitGame), play on in overtime when the scores differ (clockcont_0) and stop for a delayed penalty (gmode
   bit 3, Stop4Pen). For a penalty shot send both lines (setpersonel, PenShotStart), clear the line-change
   blinks and go to the end. Otherwise, at the start of a penalty shot move each human controller onto a skater
   of its team (restorepl), return pulled goalies, send both lines when line changes are off (gameopts bit 2),
   start the line-change timers (temp1 / temp2), and with line changes on clear the teams' and players'
   line-change flags, re-sort the sprites for a human team, start the humans' faceoff line changes and let the
   computer pick the away line (CompLine). Then for each team whose timer runs (temp1 / temp2, with the changing
   player's number in temp3 / temp4): out of the change mode cancel it, else count down and at the end take the
   line (lcfound); then send the line (setpersonel, PenShotStart, ForceStartLineup). Once both timers are out the
   computer picks the home line, with line changes off the line numbers are reset and the panel lines redrawn,
   and the assignment becomes pfaceoff2 (1Ch) with temp5 1000. p: the object on the assignment. No result. */
void puckfaceoff(Player *p)
{
    short *tp[2];
    int off;
    signed char k;
    Player *o;
    Team *tm;

    tp[0] = &p->temp1;
    tp[1] = &p->temp2;
    if (p->pflags & 2) {
        if (*puckc != 0x10) {
            if (*puckc >= 0 && penshotstart && SortCords[*puckc].position == 0) {
                SortCords[*puckc].nopuck = 0x78;
                *puckvx = *puckvy = 0;
            }
            *puckc = -1;
        }
        p->pflags &= 0xFD;
        if (!gameclock && !clockticks[0] || gmode & 0x40) {
            SetExitGame();
            return;
        }
        if (gsp == 3 && hmscore[0] != awscore) {
            clockcont_0();
            return;
        }
        if (gmode & 8) {
            Stop4Pen(0);
            return;
        }
        if (penshotmode) {
            ((unsigned char *)p)[0x27] = 0xFF;
            ((unsigned char *)p)[0x29] = 0xFF;
            setpersonel(&awtmstruct);
            PenShotStart(1);
            lcblink[1] = 0;
            energywarn[1] = 0;
            lcboxon[1] = 0;
            setpersonel(&hmtmstruct);
            PenShotStart(0);
            lcblink[0] = 0;
            energywarn[0] = 0;
            lcboxon[0] = 0;
            goto done;
        }
        if (penshotstart) {
            if (c1playernum[0] < 0 && cont1team) {
                o = cont1team == 1 ? SortCords : SortCords + 6;
                for (k = 0; k < 6; k++, o++) {
                    if (o->position >= 0 && o->SCnum != c2playernum[0]) {
                        if (o->SCnum != c1playernum[0]) c1playernum[0] = restorepl(o->SCnum, c1playernum[0]);
                        break;
                    }
                }
            }
            if (c2playernum[0] < 0 && cont2team) {
                o = cont2team == 1 ? SortCords : SortCords + 6;
                for (k = 0; k < 6; k++, o++) {
                    if (o->position >= 0 && o->SCnum != c1playernum[0]) {
                        if (o->SCnum != c2playernum[0]) c2playernum[0] = restorepl(o->SCnum, c2playernum[0]);
                        break;
                    }
                }
            }
        }
        ReturnGoalies();
        if (!gameopts.linechanges) {
            setpersonel(&hmtmstruct);
            setpersonel(&awtmstruct);
        }
        ((unsigned char *)p)[0x27] = 0xFF;
        ((unsigned char *)p)[0x29] = 0xFF;
        if (!gameopts.linechanges) goto lines;
        hmtmflags[0] &= 0xFD;
        awtmflags &= 0xFD;
        for (o = SortCords, k = 0; k < 0xC; k++, o++) o->pflags2 &= 0xF7;
        if ((cont1team | cont2team) && word_CBC44) {
            sflags |= 0x40;
            SprSortVert();
            word_CBC44 = 0;
        }
        if ((regd0.w = c1playernum[0]) >= 0) StartFaceoffLineChange(p, &SortCords[regd0.w]);
        if ((regd0.w = c2playernum[0]) >= 0 && cont2team != cont1team) StartFaceoffLineChange(p, &SortCords[regd0.w]);
        regd0.l = 2;
        if (gameopts.linechanges && regd0.w != cont1team && regd0.w != cont2team) {
            CompLine(&hmtmstruct, &awtmstruct);
            setpersonel(&awtmstruct);
            PenShotStart(1);
        }
    }
lines:
    k = 0;
    do {
        if (*tp[k] >= 0) {
            regd1.w = tp[k][2];
            o = &SortCords[regd1.w];
            off = k << 8;
            tm = (Team *)((char *)&hmtmstruct + off);
            if (!(o->pflags2 & 8)) {
                ((unsigned char *)tp[k])[1] = 0xFF;
                lcboxon[k] = lcblink[k] = 0;
            } else {
                --*tp[k];
                if (*tp[k] >= 0) goto next;
                o = &SortCords[regd1.w];
                if (!(o->pflags2 & 8)) goto next;
                regd2.w = 0;
                lcfound(o);
                lcboxon[k] = lcblink[k] = 0;
            }
            setpersonel(tm);
            PenShotStart(k);
            ForceStartLineup(k);
        }
next:
        ;
    } while (++k != 2);
    if (p->temp1 >= 0 || p->temp2 >= 0) return;
    regd0.w = 1;
    if (gameopts.linechanges && regd0.w != cont1team && regd0.w != cont2team) {
        CompLine(&awtmstruct, &hmtmstruct);
        setpersonel(&hmtmstruct);
        PenShotStart(0);
    }
    if (!gameopts.linechanges) {
        hmtmline[0] = hmtmlcnt = awtmline = awtmlcnt = 0;
        DrawPanelLine(0, 0);
        DrawPanelLine(1, 0);
    }
done:
    assreplace(p, 0x1C);
    p->temp5 = 1000;
}

/* puckfaceoff2 (51BDB, 93G pfaceoff2; ends in TakePlayerFromBox_ret6): asstab 1Ch, the faceoff drop. On a new
   assignment (pflags bit 1), once temp5 runs out or right away (demo, skipped intro, the game start), else when
   the referee, the overlay and every player are in place (AllInPlace): reset the overlay, banner and text lines,
   the fade-in, the referee step, the flags, the puck-cross bytes and gmode2 (bits 0 / 2 set); put the camera on
   the faceoff spot (fox / foy, x within 20h, y -BCh to ECh) and the puck there (z -100, 0 for a penalty shot), the
   goalies in their creases. For a penalty shot: move the controllers onto the shooter (restorepl), clear the
   defending goalie, release the other team controller and set the shot up (assreplace 18h, SetupPenaltyShot).
   Otherwise reset the bench and both lines (setpersonel, forcepldata, resetplstuff), and place the 12 players at
   their faceoff spots (word_CBE8C by line and position through apl, mirrored by side and pulled back by the
   faceoff x / y), facing the puck, with their faceoff frames and SPA (a winger with the extra assignment 17h, the
   others 16h), the referee beside the dot dropping the puck (assinsert 1Eh, SPA C57h); human controllers take
   the nearest players (changeplayer) and the drop timer temp1 starts (B4h-12Bh). Later frames count temp1 down:
   the referee lifts the puck at 11h, the drop meter (word_E0398) fills, and at -1 the faceoff ends (Endfaceoff).
   p: the object on the assignment. No result. */
void puckfaceoff2(Player *p)
{
    Player *q;
    Team *t;
    short k;
    int d;

    if (p->pflags & 2) {
        if (--p->temp5 > 0 && !dword_CC0EC && !introskipped && !word_CBEC6) {
            if (gsp || clockticks[0] || gameclock != PerTimeTotal) {
                if (RefStep[0] >= 0) return;
                if (ovltimer >= 0) return;
                if (!AllInPlace()) return;
            }
        }
        p->pflags &= 0xFD;
        if (introskipped && ovlseq != -1) FreeMemBlock(dword_E0244);
        penshotstart = 0;
        joysampling_save = joysampling;
        joysampling = 0;
        FlushGSumQueue();
        joysampling = joysampling_save;
        ovltimer = ovlseq = ovlstep = bannermsg = -1;
        bannertimer = 0;
        textline3 = textline1 = textline2 = textline4 = textline5 = 0;
        if (!dword_CC0EC && !gsp && gameclock == PerTimeTotal && !clockticks[0] && !introskipped) fadeinpending = 0;
        else if (dword_CC0EC || introskipped || word_CBEC6) fadeinpending = 1;
        else fadeinpending = word_CBEC6;
        RefStep[0] = -1;
        introskipped = 0;
        word_CBEC6 = 0;
        sflags &= 0xFE;
        sflags3 &= 0xFE;
        iflags = 0;
        refsignal = 0;
        ((unsigned char *)puckcross)[7] = ((unsigned char *)puckcross)[3] = 0xFF;
        gmode2 &= 0x78;
        gmode2 |= 5;
        passplayer = -1;
        SprSortVert();
        word_CBC44 = 0;
        camx = camy = 0;
        xc1 = fox;
        yc1 = foy;
        if (ABS(xc1) > 0x20) xc1 = fox > 0 ? 0x20 : -0x20;
        if (yc1 <= -0xBC) yc1 = -0xBC;
        else if (yc1 >= 0xEC) yc1 = 0xEC;
        camx = xc1;
        camy = yc1;
        yleader = 0;
        *puckx = fox;
        *pucky = foy;
        if (!penshotmode) *(short *)puckz = -100;
        else *(short *)puckz = 0;
        *puckvx = 0;
        *puckvy = 0;
        *(short *)puckvz = 0;
        *puckc = -1;
        q = &SortCords[0xC];
        HIWORD(q->Xpos) = q->Yvel = q->Xvel = 0;
        HIWORD(q->Ypos) = 0xEC;
        q++;
        HIWORD(q->Xpos) = q->Yvel = q->Xvel = 0;
        HIWORD(q->Ypos) = -0xEC;
        RefPen = 0;
        word_E9AAE = word_C90D8 = -1;
        ltx = fox;
        lty = foy;
        ((Player *)sortobj15)->frame = 0x189;
        ((Player *)sortobj15)->SPA = 0;
        *(short *)((char *)sortobj15 + 0x54) = 0;
        *(short *)((char *)puckstruct + 0x54) = 0;
        ((Player *)puckstruct)->frame = 0x18A;
        sflags &= 0xBF;
        checkwindow();
        if (penshotmode) {
            SprSort();
            if (c1playernum[0] != penshotplayer && c2playernum[0] != penshotplayer) {
                if (cont1team == penshotteam + 1) {
                    if (c1playernum[0] != penshotplayer) c1playernum[0] = restorepl(penshotplayer, c1playernum[0]);
                } else if (cont2team == penshotteam + 1) {
                    if (c2playernum[0] != penshotplayer) c2playernum[0] = restorepl(penshotplayer, c2playernum[0]);
                }
            }
            for (q = SortCords, k = 0; k < 0xC; k++, q++) {
                if (q->position == 0 && ((q->pflags & 0x40) != 0 ^ penshotteam)) break;
            }
            *(short *)((char *)q + 0x48) = 0;
            *(short *)((char *)q + 0x4C) = 0;
            *(short *)((char *)q + 0x4A) = 0;
            q->passlane = 0;
            q->pflags2 &= 0xDB;
            q->pflags &= 0xFB;
            if (cont1team == (penshotteam == 0) + 1) {
                if (c1playernum[0] != -1) c1playernum[0] = restorepl(-1, c1playernum[0]);
            } else if (cont2team == (penshotteam == 0) + 1) {
                if (c2playernum[0] != -1) c2playernum[0] = restorepl(-1, c2playernum[0]);
            }
            CenterMouse();
            StopDigiSample();
            gmode2 &= 0xFA;
            gmode &= 0xFE;
            p->pflags2 &= 0xFE;
            sflags3 |= 0x10;
            p->pflags &= 0xFB;
            assreplace(p, 0x18);
            SetupPenaltyShot();
            return;
        }
        ResetBench();
        setpersonel(&hmtmstruct);
        forcepldata(&hmtmstruct);
        setpersonel(&awtmstruct);
        forcepldata(&awtmstruct);
        resetplstuff();
        q = SortCords;
        regd2.w = 0xC;
        do {
            HIWORD(q->Xpos) = -0xF0;
            HIWORD(q->Ypos) = 0;
            regd1.w = q->position;
            if (q->temp5 == -100) q->temp5 = 0;
            if (regd1.w >= 0) {
                if (regd1.w) {
                    if (regd1.w == 4) {
                        t = q->tmptr;
                        t->tmpsplayer = q->pnum;
                        t->tmast1 = -1;
                        t->tmast2 = -1;
                        t->tmflags &= 0xF7;
                        regd0.w = 0x17;
                    } else {
                        regd0.w = 0x16;
                    }
                    assinsert(q, regd0.w);
                }
                regd4.w = -q->tmptr->tmap;
                if (regd4.w > -6 && q->tmptr->tmgoalie < 0) regd4.w--;
                regd4.w = (regd4.w + 6) << 3;
                regd4.w = apl[regd4.w + regd1.w];
                regd4.w += regd4.w;
                regd0.w = word_CBE8C[regd4.w];
                regd1.w = word_CBE8E[regd4.w];
                if (!(q->pflags & 0x80)) {
                    regd0.w = -regd0.w;
                    regd1.w = -regd1.w;
                }
                if (q->position) {
                    if (regd4.w <= 4) {
                        if ((regd0.w ^ fox) < 0) regd1.w -= foy >> 3;
                        regd0.w -= fox >> 2;
                    }
                    regd0.w += fox;
                    regd1.w += foy;
                } else if (ABS(foy) > 0x27 && ((q->pflags & 0x80) == 0 ^ foy < 0)) {
                    d = foy - (!(q->pflags & 0x80) ? 0x27 : -0x27);
                    d = ABS(d);
                    regd0.w += (short)(fox * d * 3 / 0x1000);
                }
                HIWORD(q->Xpos) = regd0.w;
                HIWORD(q->Ypos) = regd1.w;
                q->Xvel = 0;
                q->Yvel = 0;
                q->facedir = vtoa((short)(*puckx - regd0.w), (short)(*pucky - regd1.w));
                if (q->position == 0) {
                    d = q->handed ? q->facedir : (8 - q->facedir) & 7;
                    q->frame = d * 3 + 0x196;
                    regd1.w = 1;
                    if (q->facedir == 2) q->facedir = q->pflags & 0x80 ? 1 : 3;
                    else if (q->facedir == 6) q->facedir = q->pflags & 0x80 ? 7 : 5;
                } else if (q->position == 4) {
                    q->frame = q->facedir ? 0x167 : 0x16C;
                    regd1.w = 0;
                } else {
                    d = q->handed ? q->facedir : (8 - q->facedir) & 7;
                    q->frame = d * 5;
                    regd1.w = 0x289;
                }
                q->pflags2 &= 0xFB;
                q->pflags &= 0xDF;
                SetSPA(q, regd1.w);
            }
            q->pflags2 &= 0x7F;
            q++;
        } while (--regd2.w);
        q = &SortCords[0x10];
        if (fox <= 0) {
            SortCords[0x10].facedir = 2;
            HIWORD(SortCords[0x10].Xpos) = fox - 0xF;
        } else {
            SortCords[0x10].facedir = 6;
            HIWORD(SortCords[0x10].Xpos) = fox + 0xF;
        }
        HIWORD(q->Ypos) = foy;
        q->frame = q->facedir > 3 ? 0x2C7 : 0x2BF;
        assinsert(q, 0x1E);
        q->Xvel = 0;
        q->Yvel = 0;
        q->pflags &= 0xDF;
        SetSPA(q, 0xC57);
        SprSort();
        c2playernum[0] = c1playernum[0] = -1;
        if (cont1team) changeplayer(p, regd4.w = 0);
        if (cont2team) {
            regd4.l = 2;
            changeplayer(p, regd4.w);
        }
        CenterMouse();
        p->temp1 = randomd0(0x78) + 0xB4;
        fofdata2[0] = 1;
        word_E0392 = 0x8000;
        word_E0394 = 4;
        word_E0396 = 0xA800;
        word_E0398 = 7;
        word_E039A = 0x8000;
        if (!(gmode & 2)) {
            byte_E0393 ^= 8;
            byte_E0397 ^= 8;
        }
        fodir1 = fodir2 = -1;
        return;
    }
    if ((d = --p->temp1) < 0) {
        Endfaceoff(p);
        return;
    }
    if (d == 0x11) SetSPA(&SortCords[0x10], 0xC43);
    if (p->temp1 == 0) return;
    regd0.w = (p->temp1 + 6) >> 3;
    if (regd0.w > 2) return;
    word_E0398 = 0xA - regd0.w;
}
