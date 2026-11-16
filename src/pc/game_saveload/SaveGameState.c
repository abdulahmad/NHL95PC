/* Game state save / load: write the game state (SaveGameState) and read it back (LoadGameState). */
/* SaveGameState owns SaveGameState_popx (the LoadGameState draft ends there). */
#define SaveGameState SaveGameState_decl
#define LoadGameState LoadGameState_decl
#include "nhl95.h"
#undef SaveGameState
#undef LoadGameState

extern void __STOSD(void *, int, int);
#pragma aux __STOSD "__STOSD" parm [eax] [edx] [ecx]
extern void __STOSB(void *, int, int);
#pragma aux __STOSB "__STOSB" parm [eax] [edx] [ecx]

typedef struct { int d[4]; } Rec16;
typedef struct { short w[3]; } Rec6;

/* SaveGameState (5FB03, PC only; owner of SaveGameState_popx): write the running game to the open saved-game
   file fh (each write failing is fatal: str_ErrSaveGame): the controller sides, the 17 sort objects (66h bytes
   each), both team structures (D4h), both line tables, then 80h-byte blocks of packed words (teams, camera,
   faceoff data, pass and shot state, controllers, clocks, overlay, penalty-shot and crowd state, line-change
   state, HUD clock, ...), the 20 rink objects, the penalty buffer and the event / HUD penalty records, and the
   player and goalie game stats in 80h-byte chunks. Result: 0. */
int SaveGameState(int fh)
{
    char buf[0x8C];
    short *p;
    char *q;
    int i;
    unsigned n;

    if (FileWriteAt(fh, ctl1side, -1, 4)) FatalError((char *)str_ErrSaveGame);
    for (i = 0; i < 0x11; i++)
        if (FileWriteAt(fh, (Player *)((i << 7) + (int)SortCords), -1, 0x66)) FatalError((char *)str_ErrSaveGame);
    for (i = 0; i < 2; i++)
        if (FileWriteAt(fh, (char *)((i << 8) + (int)&hmtmstruct), -1, 0xD4)) FatalError((char *)str_ErrSaveGame);
    if (FileWriteAt(fh, hmlinetab, -1, 0x30)) FatalError((char *)str_ErrSaveGame);
    if (FileWriteAt(fh, awlinetab, -1, 0x30)) FatalError((char *)str_ErrSaveGame);
    p = (short *)buf;
    *p++ = HomeTeam;
    *p++ = *(short *)(&VisTeam);
    *p++ = *(short *)(&camx);
    *p++ = *(short *)(&camy);
    for (i = 0; i < 6; i++) *p++ = fofdata2[i];
    *p++ = *(short *)(&shotplayer);
    *p++ = *(short *)(&lastplayer);
    *p++ = *(short *)(&passdir);
    *p++ = *(short *)(&passspeed);
    *p++ = *(short *)(&passplayer);
    *p++ = *(short *)(&threat);
    for (i = 0; i < 4; i++) *p++ = ((short *)puckcross)[i];
    *p++ = *(short *)(&lj1);
    *p++ = *(short *)(&lj2);
    *p++ = *(short *)(&lasttouch);
    *p++ = *(short *)(&ltx);
    *p++ = *(short *)(&lty);
    *p++ = *(short *)(&xc1);
    *p++ = *(short *)(&yc1);
    *p++ = *(short *)(&yleader);
    *p++ = *(short *)(&fox);
    *p++ = *(short *)(&foy);
    *p++ = *(short *)(&fodir1);
    *p++ = *(short *)(&fodir2);
    *p++ = *(short *)(&sflags);
    *p++ = *(short *)(&gmode2);
    *p++ = *(short *)(&sflags3);
    *p++ = *(short *)(&c1playernum);
    *p++ = *(short *)(&c2playernum);
    *p++ = *(short *)(&cont1team);
    *p++ = *(short *)(&cont2team);
    *p++ = *(short *)(&Pencntdwn);
    *p++ = *(short *)(&Penaltytimer);
    *p++ = *(short *)(&refsignal);
    *p++ = *(short *)(&RefStep);
    *p++ = *(short *)(&RefPen);
    *p++ = *(short *)(&penaltysc);
    *p++ = *(short *)(&gsp);
    *p++ = *(short *)(&gameclock);
    *p++ = *(short *)(&clockticks);
    *p++ = *(short *)(&shownumbers);
    *p++ = *(short *)(&SortPending);
    *p++ = *(short *)(&exitgame);
    *p++ = *(short *)(&gameover);
    *p++ = *(short *)(&ovltimer);
    *p++ = *(short *)(&refhitcount);
    *p++ = *(short *)(&fadeinpending);
    *p++ = *(short *)(&deferpending);
    *p++ = *(short *)(&injurystop);
    *p++ = *(short *)(&GoalState);
    *p++ = *(short *)(&bannermsg);
    *p++ = *(short *)(&bannertimer);
    *(int *)p = *(int *)(&seed);
    p += 2;
    *p++ = *(short *)(&PBnum);
    *p++ = *(short *)(&iflags);
    if (FileWriteAt(fh, buf, -1, 0x80)) FatalError((char *)str_ErrSaveGame);
    p = (short *)buf;
    for (i = 0; i < 6; i++) *p++ = ((short *)PlList)[i];
    ((char *)p)[0] = *(char *)(&pad1dev);
    ((char *)p)[1] = *(char *)(&pad2dev);
    p++;
    ((char *)p)[0] = *(char *)(&collflag);
    ((char *)p)[1] = *(char *)(&gmode);
    p++;
    *p++ = *(short *)(&energywarn);
    *p++ = *(short *)((char *)&energywarn + 2);
    *p++ = *(short *)(&lcblink);
    *p++ = *(short *)((char *)&lcblink + 2);
    *p++ = *(short *)(&lcblinktime);
    *p++ = *(short *)((char *)&lcblinktime + 2);
    *p++ = *(short *)(&lcsel);
    *p++ = *(short *)(&lcsel_aw);
    *p++ = *(short *)(&lcline);
    *p++ = *(short *)((char *)&lcline + 2);
    *p++ = *(short *)(&lctimer);
    *p++ = *(short *)((char *)&lctimer + 2);
    *p++ = *(short *)(&lcboxon);
    *p++ = *(short *)((char *)&lcboxon + 2);
    *p++ = *(short *)(&lcrequest);
    *p++ = *(short *)((char *)&lcrequest + 2);
    *p++ = *(short *)(&lcreqchoice);
    *p++ = *(short *)((char *)&lcreqchoice + 2);
    *p++ = *(short *)(&savedmousex);
    *p++ = *(short *)(&savedmousey);
    *p++ = *(short *)(&SaveStateSpare);
    *p++ = *(short *)(&SaveStatePad);
    *p++ = *(short *)(&curperiod);
    *p++ = *(short *)(&lldispodd);
    *p++ = *(short *)(&UnusedEventWord);
    *p++ = *(short *)(&penevteam);
    *p++ = *(short *)(&periodendtime);
    *p++ = *(short *)(&SpeechPatchNext);
    *p++ = *(short *)(&ltack);
    *p++ = *(short *)(&lastsfx);
    *p++ = *(short *)(&UnusedSpeechWord);
    *p++ = *(short *)(&crowdlevel);
    *p++ = *(short *)(&UnusedCrowdWordHi);
    *p++ = *(short *)(&UnusedCrowdWord);
    *p++ = *(short *)(&CwdExciteLvl);
    *p++ = *(short *)(&MaxCwdExciteLvl);
    *p++ = *(short *)(&NumCwdExciteLvl);
    *p++ = *(short *)(&SumCwdExciteLvl);
    *p++ = *(short *)(&ctl1team);
    *p++ = *(short *)(&ctl2team);
    *p++ = *(short *)(&ctl1dev);
    *p++ = *(short *)(&ctl2dev);
    *p++ = *(short *)(&hudclockmin);
    *p++ = *(short *)(&hudclocksec);
    *p++ = *(short *)(&hudclockhund);
    *p++ = *(short *)(&Pencntdwn2);
    *p++ = *(short *)(&hudhundaccum);
    *p++ = *(short *)(&frameaccum);
    *p++ = *(short *)(&goalienotebits);
    *p++ = *(short *)(&milestonesaid);
    *p++ = *(short *)(&milestonesaid_b2);
    *p++ = *(short *)(&gamemode);
    ((char *)p)[0] = *(char *)(&UnusedStateByte);
    ((char *)p)[1] = *(char *)(&GameRecordDay);
    p++;
    ((char *)p)[0] = *(char *)(&UnusedStateFlag);
    ((char *)p)[1] = *(char *)(&UnusedStateMode);
    p++;
    ((char *)p)[0] = *(char *)(&UnusedStateSpare);
    ((char *)p)[1] = *(char *)(&onetimerflag);
    if (FileWriteAt(fh, buf, -1, 0x80)) FatalError((char *)str_ErrSaveGame);
    p = (short *)buf;
    for (i = 0; i < 0x14; i++) {
        n = i * 3;
        *p++ = rinkobjs[n * 2];
        *p++ = rinkobjs_w2[n * 2];
    }
    *p++ = *(short *)(&ovlseq);
    *p++ = *(short *)(&ovlstep);
    *p++ = *(short *)(&ovlsteptimer);
    *p++ = *(short *)(&ovlstepidx);
    *p++ = *(short *)(&shotongoal);
    *p++ = *(short *)(&penshotplayer);
    *p++ = *(short *)(&penshotpnum);
    *p++ = *(short *)(&penshotteam);
    *p++ = *(short *)(&penshotctl);
    *p++ = *(short *)(&lcline_aw);
    *p++ = *(short *)(&penshotfox);
    *p++ = *(short *)(&penshotfoy);
    *p++ = *(short *)(&penshotmode);
    *p++ = *(short *)(&penshotstart);
    *p++ = *(short *)(&penshottimer);
    *p++ = *(short *)(&shotontarget);
    *p++ = *(short *)(&penshotlive);
    *p++ = *(short *)(&psendcount);
    *p++ = *(short *)(&sopathx);
    *p++ = *(short *)(&sopathy);
    *p++ = *(short *)(&sopathend);
    *p++ = *(short *)(&sopathpoint);
    *p++ = *(short *)(&pspathside);
    *p++ = *(short *)(&pspathdir);
    if (FileWriteAt(fh, buf, -1, 0x80)) FatalError((char *)str_ErrSaveGame);
    if (FileWriteAt(fh, PenBuf, -1, 0x42)) FatalError((char *)str_ErrSaveGame);
    if (FileWriteAt(fh, &curevent, -1, 0xB)) FatalError((char *)str_ErrSaveGame);
    if (FileWriteAt(fh, &goalevent, -1, 0xB)) FatalError((char *)str_ErrSaveGame);
    if (FileWriteAt(fh, gsumheader, -1, 0xB)) FatalError((char *)str_ErrSaveGame);
    if (FileWriteAt(fh, gsumtail, -1, 0xB)) FatalError((char *)str_ErrSaveGame);
    if (FileWriteAt(fh, hudpenhome, -1, 0x40)) FatalError((char *)str_ErrSaveGame);
    if (FileWriteAt(fh, hudpenaway, -1, 0x40)) FatalError((char *)str_ErrSaveGame);
    q = buf;
    n = 0;
    for (i = 0; i < 0x32; i++) {
        if (n + 0x10 > 0x80) {
            if (FileWriteAt(fh, buf, -1, n)) FatalError((char *)str_ErrSaveGame);
            q = buf;
            n = 0;
        }
        *(Rec16 *)q = *(Rec16 *)((char *)hmplstats + i / 25 * 25 * 16 + i % 25 * 16);
        q += 0x10;
        n += 0x10;
    }
    for (i = 0; i < 6; i++) {
        if (n + 6 > 0x80) {
            if (FileWriteAt(fh, buf, -1, n)) FatalError((char *)str_ErrSaveGame);
            q = buf;
            n = 0;
        }
        *(Rec6 *)q = *(Rec6 *)((char *)hmglstats + i / 3 * 9 * 2 + i % 3 * 3 * 2);
        q += 6;
        n += 6;
    }
    if (n && FileWriteAt(fh, buf, -1, n)) FatalError((char *)str_ErrSaveGame);
    return 0;
}

/* a rink object slot as LoadGameState rebuilds it (12 bytes at rinkobjs) */
typedef struct LRinkObj {
    short id;           /* photo object, -1 free */
    short ts;           /* timer and step bytes */
    signed char frame;  /* rinkobjanim[base + step] */
    short x;
    short y;
    short base;         /* the object's first frame index */
    unsigned char first;
} LRinkObj;
typedef struct { int d[2]; } Rec8;

/* DRAFT (10.0 GA, 30 differing, 6 bytes short): the signed high byte of ts is read as ts >> 8.
   This keeps the frame step signed without a byte-pointer cast and gives the EXE's photo-bit registers
   (the savings-40 load/or temporary now sorts ahead of the skater quotient). The file handle and stats
   record pointers retain their EXE locations. Left: the object frame base/step load order and the skater
   row calculation/registers (add esi, eax instead of lea esi, [eax + ebx]); see docs/UNSURE.md. */
/* LoadGameState (60612, PC only; ends in SaveGameState_popx): read back what SaveGameState wrote to the open
   saved-game file fh (each read failing is fatal: str_ErrLoadGame, the first str_ErrSaveGame): the controller
   sides, the 17 sort objects, both team structures and line tables, the three 80h-byte blocks of packed words
   (the 20 rink objects are rebuilt from their ids: the photo-in-use bits rinkobjused, position and frames from
   rinkobjdefs / rinkobjanim), the penalty buffer and records, the player and goalie game stats. Then set the game
   up again: the mouse to the centre for a mouse controller, the mode state of gamemode, the period length, the
   teams, palette, music and graphics (all photo banks reloaded), the overlay script, the event lines, the replay,
   the team structures' pointers, the sort objects' fixed fields and the y order, the HUD penalty records.
   Result: 0. */
int LoadGameState(int fh)
{
    char buf[0x80];
    char penhome[0x40];
    char penaway[0x40];
    int n;
    int i;
    short *p;
    Rec16 *q;
    Rec6 *r;

    LRinkObj *o;
    int id;
    Player *pl;

    if (FileReadAt(fh, ctl1side, -1, 4)) FatalError((char *)str_ErrSaveGame);
    for (i = 0; i < 0x11; i++)
        if (FileReadAt(fh, (Player *)((i << 7) + (int)SortCords), -1, 0x66)) FatalError((char *)str_ErrLoadGame);
    for (i = 0; i < 2; i++)
        if (FileReadAt(fh, (char *)((i << 8) + (int)&hmtmstruct), -1, 0xD4)) FatalError((char *)str_ErrLoadGame);
    if (FileReadAt(fh, hmlinetab, -1, 0x30)) FatalError((char *)str_ErrLoadGame);
    if (FileReadAt(fh, awlinetab, -1, 0x30)) FatalError((char *)str_ErrLoadGame);
    if (FileReadAt(fh, buf, -1, 0x80)) FatalError((char *)str_ErrLoadGame);
    HomeTeam = *(int *)buf;
    p = (short *)buf;
    p++;
    VisTeam = *p++;
    camx = *p++;
    camy = *p++;
    for (i = 0; i < 6; i++) fofdata2[i] = *p++;
    shotplayer = *p++;
    lastplayer = *p++;
    passdir = *p++;
    passspeed = *p++;
    passplayer = *p++;
    threat = *p++;
    for (i = 0; i < 4; i++) ((short *)puckcross)[i] = *p++;
    lj1 = *p++;
    lj2 = *p++;
    lasttouch = *p++;
    ltx = *p++;
    lty = *p++;
    xc1 = *p++;
    yc1 = *p++;
    yleader = *p++;
    fox = *p++;
    foy = *p++;
    fodir1 = *p++;
    fodir2 = *p++;
    *(short *)&sflags = *p++;
    *(short *)&gmode2 = *p++;
    *(short *)&sflags3 = *p++;
    c1playernum[0] = *p++;
    c2playernum[0] = *p++;
    cont1team = *p++;
    cont2team = *p++;
    Pencntdwn = *p++;
    Penaltytimer = *p++;
    refsignal = *p++;
    RefStep[0] = *p++;
    RefPen = *p++;
    penaltysc = *p++;
    gsp = *p++;
    gameclock = *p++;
    clockticks[0] = *p++;
    shownumbers = *p++;
    SortPending = *p++;
    exitgame = *p++;
    gameover = *p++;
    ovltimer = *p++;
    refhitcount = *p++;
    fadeinpending = *p++;
    deferpending = *p++;
    injurystop = *p++;
    GoalState = *p++;
    bannermsg = *p++;
    bannertimer = *p++;
    *(int *)&seed = *(int *)p;
    p += 2;
    *(short *)&PBnum = *p++;
    *(short *)&iflags = *p++;
    if (FileReadAt(fh, buf, -1, 0x80)) FatalError((char *)str_ErrLoadGame);
    p = (short *)buf;
    for (i = 0; i < 6; i++) ((short *)PlList)[i] = *p++;
    *(char *)&pad1dev = ((char *)p)[0];
    *(char *)&pad2dev = ((char *)p)[1];
    p++;
    *(char *)&collflag = ((char *)p)[0];
    *(char *)&gmode = ((char *)p)[1];
    p++;
    energywarn[0] = *p++;
    *(short *)((char *)&energywarn + 2) = *p++;
    lcblink[0] = *p++;
    *(short *)((char *)&lcblink + 2) = *p++;
    lcblinktime[0] = *p++;
    *(short *)((char *)&lcblinktime + 2) = *p++;
    lcsel[0] = *p++;
    lcsel_aw[0] = *p++;
    lcline[0] = *p++;
    *(short *)((char *)&lcline + 2) = *p++;
    lctimer[0] = *p++;
    *(short *)((char *)&lctimer + 2) = *p++;
    lcboxon[0] = *p++;
    *(short *)((char *)&lcboxon + 2) = *p++;
    lcrequest[0] = *p++;
    *(short *)((char *)&lcrequest + 2) = *p++;
    lcreqchoice[0] = *p++;
    *(short *)((char *)&lcreqchoice + 2) = *p++;
    savedmousex = *p++;
    savedmousey = *p++;
    *(int *)&SaveStateSpare = *p++;
    *(int *)&SaveStatePad = *p++;
    curperiod = *p++;
    lldispodd = *p++;
    UnusedEventWord = *p++;
    penevteam = *p++;
    periodendtime = *p++;
    SpeechPatchNext = *p++;
    ltack = *p++;
    lastsfx = *p++;
    UnusedSpeechWord = *p++;
    crowdsmooth = crowdlevel = *p++;
    UnusedCrowdWordHi = *p++;
    UnusedCrowdWord = *p++;
    CwdExciteLvl = *p++;
    MaxCwdExciteLvl = *p++;
    NumCwdExciteLvl = *p++;
    SumCwdExciteLvl = *p++;
    ctl1team[0] = *p++;
    ctl2team = *p++;
    ctl1dev[0] = *p++;
    ctl2dev = *p++;
    hudclockmin = *p++;
    hudclocksec = *p++;
    hudclockhund = *p++;
    Pencntdwn2[0] = *p++;
    hudhundaccum = *p++;
    frameaccum = *p++;
    goalienotebits = *p++;
    milestonesaid[0] = *p++;
    milestonesaid_b2 = *p++;
    gamemode = *p++;
    *(char *)&UnusedStateByte = ((char *)p)[0];
    *(char *)&GameRecordDay = ((char *)p)[1];
    p++;
    *(char *)&UnusedStateFlag = ((char *)p)[0];
    *(char *)&UnusedStateMode = ((char *)p)[1];
    p++;
    *(char *)&UnusedStateSpare = ((char *)p)[0];
    onetimerflag = ((signed char *)p)[1];
    if (FileReadAt(fh, buf, -1, 0x80)) FatalError((char *)str_ErrLoadGame);
    p = (short *)buf;
    __STOSB(rinkobjused, 0, 0x20);
    i = 0x10;
    for (i = 0; i < 0x14; i++) {
        o = (LRinkObj *)((char *)rinkobjs + i * 12);
        o->id = *p;
        id = o->id;
        rinkobjused[id / 16] |= 1 << id % 16;
        p++;
        o->ts = *p++;
        if (id >= 0) {
            id *= 3;
            o->x = rinkobjdefs[id];
            o->y = rinkobjdefs[++id];
            o->base = rinkobjdefs[++id];
            o->first = rinkobjanim[o->base];
            o->frame = rinkobjanim[o->base + (o->ts >> 8)];
        }
    }
    ovlseq = *p++;
    ovlstep = *p++;
    ovlsteptimer = *p++;
    ovlstepidx = *p++;
    shotongoal = *p++;
    penshotplayer = *p++;
    penshotpnum = *p++;
    penshotteam = *p++;
    penshotctl = *p++;
    *(int *)&lcline_aw = *p++;
    *(int *)&penshotfox = *p++;
    *(int *)&penshotfoy = *p++;
    penshotmode = *p++;
    penshotstart = *p++;
    penshottimer = *p++;
    shotontarget = *p++;
    penshotlive = *p++;
    psendcount = *p++;
    sopathx = *p++;
    sopathy = *p++;
    sopathend = *p++;
    sopathpoint = *p++;
    pspathside = *p++;
    pspathdir = *p++;
    if (FileReadAt(fh, PenBuf, -1, 0x42)) FatalError((char *)str_ErrLoadGame);
    if (FileReadAt(fh, &curevent, -1, 0xB)) FatalError((char *)str_ErrLoadGame);
    if (FileReadAt(fh, &goalevent, -1, 0xB)) FatalError((char *)str_ErrLoadGame);
    if (FileReadAt(fh, gsumheader, -1, 0xB)) FatalError((char *)str_ErrLoadGame);
    if (FileReadAt(fh, gsumtail, -1, 0xB)) FatalError((char *)str_ErrLoadGame);
    if (FileReadAt(fh, penhome, -1, 0x40)) FatalError((char *)str_ErrLoadGame);
    if (FileReadAt(fh, penaway, -1, 0x40)) FatalError((char *)str_ErrLoadGame);
    i = n = 0;
    do {
        if (!n) {
            n = 0x80;
            if (i >= 0x30) n = 0x44;
            if (FileReadAt(fh, buf, -1, n)) FatalError((char *)str_ErrLoadGame);
            q = (Rec16 *)buf;
        }
        *(Rec16 *)((char *)hmplstats + i / 25 * 25 * 16 + i % 25 * 16) = *q++;
        n -= 0x10;
    } while (++i < 0x32);
    r = (Rec6 *)q;
    for (i = 0; i < 6; i++) *(Rec6 *)((char *)hmglstats + i / 3 * 9 * 2 + i % 3 * 3 * 2) = *r++;
    if (pad1dev[0] == 1 || pad2dev == 1) MouseSetPos(0xA0, 0x64);
    switch (gamemode) {
    case 0:
        SaveModeState(exhstate);
        LoadModeState(exhstate);
        break;
    case 1:
        SaveModeState(postate);
        LoadModeState(postate);
        break;
    case 2:
        SaveModeState(lgstate);
        LoadModeState(lgstate);
        break;
    }
    PerTimeTotal = GetPeriodTime();
    LoadGameTeams(1);
    LoadTeamPalette(HomeTeam, VisTeam, gamepal);
    DeskRedrawAll = DeskRedrawFlag = 1;
    hudhundstep = 0;
    LoadRockMusic();
    __STOSD(photobanks, -1, 0x17);
    photobankf = -1;
    LoadGameGfx();
    __STOSD(photobanks, 0, 0x17);
    photobankf = 0;
    if (ovlseq != -1 && ovlstep != -1) ovlscript = ovlscripts[ovlseq];
    BuildEventLines();
    recbpr = replaystart;
    ReplayRecordReset();
    sflags &= 0xEF;
    fadeinpending = 1;
    hmtmsort = (int)SortCords;
    hmtmplattr = (int)hmplattr;
    hmtmglattr = (int)hmglattr;
    hmtmlines[0] = (int)hmlinetab;
    hmtmplstats = (int)hmplstats;
    hmtmglstats = (int)hmglstats;
    hmtmroster = (int)hmroster;
    hmtmptrF2 = (int)hmteamrec;
    awtmsort = (int)(SortCords + 6);
    awtmplattr = (int)awplattr;
    awtmglattr = (int)awglattr;
    awtmlines = (int)awlinetab;
    awtmplstats = (int)awplstats;
    awtmglstats = (int)awglstats;
    awtmroster = (int)awroster;
    awtmptrF2 = (int)awteamrec;
    pl = SortCords;
    for (i = 0; i < 0x11; i++, pl++) {
        pl->SCnum = i;
        pl->radiusx = ObjInitFrame[i * 9];
        pl->radiusy = ObjInitAttr[i * 9];
        pl->tmptr = pl->pflags & 0x40 ? &awtmstruct : &hmtmstruct;
        pl->optmptr = !(pl->pflags & 0x40) ? &awtmstruct : &hmtmstruct;
        pl->OldXpos = pl->Xpos;
        pl->OldYpos = pl->Ypos;
        pl->OldZpos = pl->Zpos;
        OOlist[i] = i;
        OOlistpos[i] = i;
    }
    SprSort();
    for (i = 0; i < 8; i++) {
        *(Rec8 *)((char *)hudpenhome + i * 8) = *(Rec8 *)(penhome + i * 8);
        *(Rec8 *)((char *)hudpenaway + i * 8) = *(Rec8 *)(penaway + i * 8);
    }
    return 0;
}
