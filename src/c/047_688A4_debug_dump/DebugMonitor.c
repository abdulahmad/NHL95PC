/* Debug dump: the in-game debug monitor and the stats log. DebugMonitor owns DebugMonitor_pop, the exit DumpStatsLog
   jumps into, so both are one file. */
#define DebugPrintf DebugPrintf_decl
#define WaitKey WaitKey_decl
#define sub_93E38 sub_93E38_decl
#define DumpStatsLog DumpStatsLog_decl
#define DebugMonitor DebugMonitor_decl
#include "nhl95.h"
#undef DebugPrintf
#undef WaitKey
#undef sub_93E38
#undef DumpStatsLog
#undef DebugMonitor

void __cdecl DebugPrintf(char *fmt, ...);
int WaitKey(void);
void sub_93E38(void);
void DumpStatsLog(char *name);
int fprintf(void *fp, const char *fmt, ...);

/* DebugMonitor (688A4, PC only; owner of DebugMonitor_pop): the debug monitor, once per frame. In step mode
   (debugstep) print a status line (offside flag, the lines, the penalty shot state, AllInPlace, camera and
   clock, referee, penalty buffer, goalies, game over / exit flags, controllers, puck carrier) and one line per
   object 0-10h except 0Ch, 0Dh and 0Fh (index, jersey, numbers, box time, position name, position and
   velocity, the puck height for 0Eh, assignment name, flags, SPA name), stopping on a bad frame number. Then
   read a key (WaitKey in step mode, else PollKey): 0 bails out, m calls sub_93E38, d dumps the stats log and
   a backslash toggles step mode. No arguments, no result. The last sprintf of an object line builds its
   destination in n itself (n is dead after it: add esi, eax / push esi in the EXE). */
void DebugMonitor(void)
{
    char buf[0x200];
    int n;
    short i;
    short k;
    Player *p;

    if (debugstep) {
        if (gmode2 & 0x80) DebugPrintf((char *)str_dbgO);
        else DebugPrintf((char *)str_dbgDash);
        buf[0] = 0;
        n = 0;
        n += sprintf(buf + n, (char *)str_dbgClin, hmtmstruct.tmline, awtmstruct.tmline);
        n += sprintf(buf + n, (char *)str_dbgPenShot, penshotmode, penshotlive, penshotstart, penshottimer, psendcount,
            penshotplayer, penshotpnum, penshotteam, penshotctl, shotontarget, shotongoal);
        DebugPrintf((char *)str_dbgLip, AllInPlace());
        n += sprintf(buf + n, (char *)str_dbgHVpos, camx, camy, xc1, yc1);
        n += sprintf(buf + n, (char *)str_dbgRef, RefStep[0], refsignal);
        n += sprintf(buf + n, (char *)str_dbgPb, PenBuf[0], PenBuf_pl[0]);
        n += sprintf(buf + n, (char *)str_dbgG, hmtmgoalie[0], awtmgoalie);
        n += sprintf(buf + n, (char *)str_dbgGO, gameover, exitgame, (gmode & 0x40) != 0, (gmode & 0x80) != 0);
        n += sprintf(buf + n, (char *)str_dbgGsp, gameclock, clockticks[0]);
        n += sprintf(buf + n, (char *)str_dbgC12, c1playernum[0], c2playernum[0], cont1team, cont2team);
        sprintf(buf + n, (char *)str_dbgPuckc, *puckc, (gmode & 1) != 0, (gmode & 4) != 0, Pencntdwn);
        DebugPrintf(buf);
        i = 0;
        for (; i < 0x11; i++) {
            if (i == 0xC || i == 0xD || i == 0xF) continue;
            p = (Player *)((i << 7) + (int)SortCords);
            buf[0] = 0;
            n = 0;
            n += sprintf(buf + n, (char *)str_dbgIdx, p->temp5);
            n += sprintf(buf + n, (char *)str_dbgD, p->rostnum);
            n += sprintf(buf + n, (char *)str_dbgD, p->pnum);
            n += sprintf(buf + n, (char *)str_dbgD,
                ((short *)((char *)hmtmstruct.tmpdst + ((p->pflags & 0x40) != 0) * 0x100))[p->pnum]);
            n += sprintf(buf + n, (char *)str_dbgLbD, p->newpnum);
            n += sprintf(buf + n, (char *)str_dbgDRb, p->newpos);
            n += sprintf(buf + n, (char *)str_dbgDS, i, p->position >= 0 ? (char *)dbg_posnames[p->position] : (char *)str_pen);
            n += sprintf(buf + n, (char *)str_dbgPosVel, HIWORD(p->Xpos), HIWORD(p->Ypos), p->Xvel, p->Yvel, p->facedir,
                p->temp3, p->temp4);
            if (i == 0xE) n += sprintf(buf + n, (char *)str_dbgVz, *(short *)puckvz);
            n += sprintf(buf + n, (char *)str_dbgAss, (char *)dbg_assnames[p->asslist[p->assnum]]);
            if (p->pflags & 0x20) n += sprintf(buf + n, (char *)str_dbgL);
            if (p->pflags2 & 2) n += sprintf(buf + n, (char *)str_dbgI);
            n += sprintf(buf + n, (char *)str_dbgSpace);
            k = 0;
            for (; k < 0x78; k++)
                if (p->SPA == dbg_spalist[k]) break;
            if (k >= 0x78) n += sprintf(buf + n, (char *)str_dbgSpa, p->SPA);
            else n += sprintf(buf + n, (char *)str_dbgS, (char *)dbg_spanames[k]);
            if (p->frame < -1 || p->frame >= 0x46E) {
                sprintf((char *)(n += (int)buf), (char *)str_debError, p->SCnum, p->frame);
                DebugPrintf(buf);
                WaitKey();
            } else {
                sprintf((char *)(n += (int)buf), (char *)str_newline);
                DebugPrintf(buf);
            }
        }
    }
    k = debugstep ? WaitKey() : PollKey();
    if (k == '0') {
        DebugPrintf((char *)str_dbgBail);
        ((void (*)(void))bailout_vec)();
    } else if (k == 'm') {
        sub_93E38();
    } else if (k == 'd') {
        DumpStatsLog((char *)str_statslog);
    } else if (k == 0x5C) {
        if (debugstep) joyq_flush();
        debugstep = !debugstep;
    }
}

/* DRAFT (10.0 GA, 21 differing): the EXE spills j * 39 to a stack word (sub esp, 4) in the home skater, home
   goalie and away skater loops and adds it to the roster pointer loaded into eax; C loads the roster pointer into
   edi instead. See docs/UNSURE.md. */
/* DumpStatsLog (68E7B, PC only; ends in DebugMonitor_pop): append the game state to the text file name (mode "at";
   failing: say so with DebugPrintf). Write the frame counters, both team structures (E8h bytes as dwords), the 17
   sort objects (48h bytes as words) and one line of ratings per object, then for each team its totals (shots,
   score, shot / goal counts, power plays, penalties, attack time, passes), one line per skater (jersey and eight
   stat words) and per goalie (jersey, two stat words). name: the file. No result. */
void DumpStatsLog(char *name)
{
    void *f;
    short i;
    short j;
    int *w;
    short *s;
    Player *p;
    Team *tm;
    short *st;
    unsigned char *r;

    f = fopen(name, (char *)str_fmode_at);
    if (!f) {
        DebugPrintf((char *)str_ErrDumpStats);
        return;
    }
    fprintf(f, (char *)str_dumpPool, hudhundaccum, frameaccum, gamemode);
    fprintf(f, (char *)str_dumpTmstructs);
    i = 0;
    for (; i < 2; i++) {
        w = (int *)((char *)&hmtmstruct + i * 0x100);
        j = 0;
        for (; (unsigned)j < 0xE8; j += 4) fprintf(f, (char *)str_dumpHex, *w++);
        fprintf(f, (char *)str_newline);
    }
    fprintf(f, (char *)str_dumpSortcords);
    i = 0;
    for (; i < 0x11; i++) {
        s = (short *)((i << 7) + (int)SortCords);
        j = 0;
        for (; j < 0x48; j += 2) fprintf(f, (char *)str_dumpHex, *s++);
        fprintf(f, (char *)str_newline);
    }
    i = 0;
    for (; i < 0x11; i++) {
        p = &SortCords[i];
        fprintf(f, (char *)str_dumpSortLine, p->SCnum, p->pnum, p->rostnum, p->weight, p->legstr, p->legspd, p->aioff,
            p->aidef, p->shotspd, p->handed, p->checking, p->stickhand, p->shotacc, p->endurance, p->spodds, p->passacc,
            p->aggress, ((unsigned char *)p)[0x63], *(short *)&p->attrlo);
    }
    tm = &hmtmstruct;
    fprintf(f, (char *)str_dumpRule);
    fprintf(f, (char *)str_dumpTeamHdrH);
    fprintf(f, (char *)str_dumpHome, hmtmstruct.tmshots, hmscore[0], hmshotcnt, hmgoalcnt, hmtmstruct.tmppg,
        hmtmstruct.tmpp, hmtmstruct.tmpen, hmtmstruct.tmpenmin, hmtmstruct.tmATOP, hmtmstruct.tmpass,
        hmtmstruct.tmpasscomp);
    st = (short *)hmtmplstats;
    fprintf(f, (char *)str_dumpPlHdrH);
    j = 0;
    for (; j < 0x19; st += 8, j++) {
        r = tm->tmroster + j * 39;
        fprintf(f, (char *)str_dumpPlLineH, j, r[5], st[0], st[1], st[2], st[3], st[4], st[5], st[6], st[7], r[0]);
    }
    st = tm->tmglstats;
    fprintf(f, (char *)str_dumpGlHdrH);
    j = 0;
    for (; j < 3; st += 3, j++) {
        r = tm->tmroster + (j + 0x19) * 39;
        fprintf(f, (char *)str_dumpGlLine, j, r[5], st[0], st[1], r[0]);
    }
    tm = &awtmstruct;
    fprintf(f, (char *)str_dumpTeamHdrA);
    fprintf(f, (char *)str_dumpAway, awtmstruct.tmshots, awscore, awshotcnt, awgoalcnt, awtmstruct.tmppg,
        awtmstruct.tmpp, awtmstruct.tmpen, awtmstruct.tmpenmin, awtmstruct.tmATOP, awtmstruct.tmpass,
        awtmstruct.tmpasscomp);
    st = (short *)awtmplstats;
    fprintf(f, (char *)str_dumpPlHdrA);
    j = 0;
    for (; j < 0x19; st += 8, j++) {
        r = tm->tmroster + j * 39;
        fprintf(f, (char *)str_dumpPlLineA, j, r[5], st[0], st[1], st[2], st[3], st[4], st[5], st[6], st[7], r[0]);
    }
    st = tm->tmglstats;
    fprintf(f, (char *)str_dumpGlHdrA);
    j = 0;
    for (; j < 3; st += 3, j++) {
        r = tm->tmroster + (j + 0x19) * 39;
        fprintf(f, (char *)str_dumpGlLine, j, r[5], st[0], st[1], r[0]);
    }
    fclose(f);
}
