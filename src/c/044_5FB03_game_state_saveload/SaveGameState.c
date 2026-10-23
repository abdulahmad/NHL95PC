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
    *p++ = *(short *)(&word_C90D8);
    *p++ = *(short *)(&gsp);
    *p++ = *(short *)(&gameclock);
    *p++ = *(short *)(&clockticks);
    *p++ = *(short *)(&shownumbers);
    *p++ = *(short *)(&word_CBC44);
    *p++ = *(short *)(&exitgame);
    *p++ = *(short *)(&gameover);
    *p++ = *(short *)(&ovltimer);
    *p++ = *(short *)(&word_CBEC2);
    *p++ = *(short *)(&fadeinpending);
    *p++ = *(short *)(&deferpending);
    *p++ = *(short *)(&word_CBEC6);
    *p++ = *(short *)(&word_E9AB0);
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
    *p++ = *(short *)(&word_CBC60);
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
    *p++ = *(short *)(&word_DEF84);
    *p++ = *(short *)(&word_DEF88);
    *p++ = *(short *)(&curperiod);
    *p++ = *(short *)(&lldispodd);
    *p++ = *(short *)(&dword_E9AB6);
    *p++ = *(short *)(&word_E9AAE);
    *p++ = *(short *)(&periodendtime);
    *p++ = *(short *)(&dword_E9A9E);
    *p++ = *(short *)(&ltack);
    *p++ = *(short *)(&lastsfx);
    *p++ = *(short *)(&word_E9A9C);
    *p++ = *(short *)(&crowdlevel);
    *p++ = *(short *)(&word_E9AAA);
    *p++ = *(short *)(&word_E9AA2);
    *p++ = *(short *)(&CwdExciteLvl);
    *p++ = *(short *)(&word_E9AA4);
    *p++ = *(short *)(&word_E9AA6);
    *p++ = *(short *)(&dword_E009C);
    *p++ = *(short *)(&ctl1team);
    *p++ = *(short *)(&ctl2team);
    *p++ = *(short *)(&ctl1dev);
    *p++ = *(short *)(&ctl2dev);
    *p++ = *(short *)(&hudclockmin);
    *p++ = *(short *)(&hudclocksec);
    *p++ = *(short *)(&hudclockhund);
    *p++ = *(short *)(&word_CC0B0);
    *p++ = *(short *)(&hudhundaccum);
    *p++ = *(short *)(&frameaccum);
    *p++ = *(short *)(&dword_CC0AC);
    *p++ = *(short *)(&byte_E024C);
    *p++ = *(short *)(&word_E024E);
    *p++ = *(short *)(&gamemode);
    ((char *)p)[0] = *(char *)(&byte_DC268);
    ((char *)p)[1] = *(char *)(&byte_DC267);
    p++;
    ((char *)p)[0] = *(char *)(&byte_DC264);
    ((char *)p)[1] = *(char *)(&byte_DC265);
    p++;
    ((char *)p)[0] = *(char *)(&byte_DC266);
    ((char *)p)[1] = *(char *)(&onetimerflag);
    if (FileWriteAt(fh, buf, -1, 0x80)) FatalError((char *)str_ErrSaveGame);
    p = (short *)buf;
    for (i = 0; i < 0x14; i++) {
        n = i * 3;
        *p++ = word_DEE94[n * 2];
        *p++ = word_DEE96[n * 2];
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
    *p++ = *(short *)(&word_CC10C);
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
    if (FileWriteAt(fh, &byte_E9AC8, -1, 0xB)) FatalError((char *)str_ErrSaveGame);
    if (FileWriteAt(fh, &byte_E9AD3, -1, 0xB)) FatalError((char *)str_ErrSaveGame);
    if (FileWriteAt(fh, unk_C5423, -1, 0xB)) FatalError((char *)str_ErrSaveGame);
    if (FileWriteAt(fh, unk_C542E, -1, 0xB)) FatalError((char *)str_ErrSaveGame);
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
        *(Rec16 *)q = *(Rec16 *)((char *)dword_DB088 + i / 25 * 25 * 16 + i % 25 * 16);
        q += 0x10;
        n += 0x10;
    }
    for (i = 0; i < 6; i++) {
        if (n + 6 > 0x80) {
            if (FileWriteAt(fh, buf, -1, n)) FatalError((char *)str_ErrSaveGame);
            q = buf;
            n = 0;
        }
        *(Rec6 *)q = *(Rec6 *)((char *)unk_DC240 + i / 3 * 9 * 2 + i % 3 * 3 * 2);
        q += 6;
        n += 6;
    }
    if (n && FileWriteAt(fh, buf, -1, n)) FatalError((char *)str_ErrSaveGame);
    return 0;
}

/* a rink object slot as LoadGameState rebuilds it (12 bytes at word_DEE94) */
typedef struct LRinkObj {
    short id;           /* photo object, -1 free */
    short ts;           /* timer and step bytes */
    signed char frame;  /* byte_CCE00[base + step] */
    short x;
    short y;
    short base;         /* the object's first frame index */
    unsigned char first;
} LRinkObj;
typedef struct { int d[2]; } Rec8;

/* LoadGameState (60612, PC only; ends in SaveGameState_popx): read back what SaveGameState wrote to the open
   saved-game file fh (each read failing is fatal: str_ErrLoadGame, the first str_ErrSaveGame): the controller
   sides, the 17 sort objects, both team structures and line tables, the three 80h-byte blocks of packed words
   (the 20 rink objects are rebuilt from their ids: the photo-in-use bits word_E9B2C, position and frames from
   word_CCEF8 / byte_CCE00), the penalty buffer and records, the player and goalie game stats. Then set the game
   up again: the mouse to the centre for a mouse controller, the mode state of gamemode, the period length, the
   teams, palette, music and graphics (all photo banks reloaded), the overlay script, the event lines, the replay,
   the team structures' pointers, the sort objects' fixed fields and the y order, the HUD penalty records.
   Result: 0. */
int LoadGameState(int fh)
{
    char buf[0x80];
    char penaway[0x40];
    char penhome[0x40];
    int n;
    int i;
    short *p;
    short *q;

    LRinkObj *o;
    short id;
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
    word_C90D8 = *p++;
    gsp = *p++;
    gameclock = *p++;
    clockticks[0] = *p++;
    shownumbers = *p++;
    word_CBC44 = *p++;
    exitgame = *p++;
    gameover = *p++;
    ovltimer = *p++;
    word_CBEC2 = *p++;
    fadeinpending = *p++;
    deferpending = *p++;
    word_CBEC6 = *p++;
    word_E9AB0 = *p++;
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
    word_CBC60[0] = *p++;
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
    word_DEF84 = *p++;
    word_DEF88 = *p++;
    curperiod = *p++;
    lldispodd = *p++;
    dword_E9AB6 = *p++;
    word_E9AAE = *p++;
    periodendtime = *p++;
    dword_E9A9E = *p++;
    ltack = *p++;
    lastsfx = *p++;
    word_E9A9C = *p++;
    crowdsmooth = crowdlevel = *p++;
    word_E9AAA = *p++;
    word_E9AA2 = *p++;
    CwdExciteLvl = *p++;
    word_E9AA4 = *p++;
    word_E9AA6 = *p++;
    dword_E009C = *p++;
    ctl1team[0] = *p++;
    ctl2team = *p++;
    ctl1dev[0] = *p++;
    ctl2dev = *p++;
    hudclockmin = *p++;
    hudclocksec = *p++;
    hudclockhund = *p++;
    word_CC0B0[0] = *p++;
    hudhundaccum = *p++;
    frameaccum = *p++;
    dword_CC0AC = *p++;
    byte_E024C[0] = *p++;
    word_E024E = *p++;
    gamemode = *p++;
    *(char *)&byte_DC268 = ((char *)p)[0];
    *(char *)&byte_DC267 = ((char *)p)[1];
    p++;
    *(char *)&byte_DC264 = ((char *)p)[0];
    *(char *)&byte_DC265 = ((char *)p)[1];
    p++;
    *(char *)&byte_DC266 = ((char *)p)[0];
    onetimerflag = ((signed char *)p)[1];
    if (FileReadAt(fh, buf, -1, 0x80)) FatalError((char *)str_ErrLoadGame);
    p = (short *)buf;
    __STOSB(word_E9B2C, 0, 0x20);
    i = 0x10;
    for (i = 0; i < 0x14; i++) {
        o = (LRinkObj *)((char *)word_DEE94 + i * 12);
        o->id = *p;
        id = o->id;
        word_E9B2C[id / 16] |= 1 << id % 16;
        p++;
        o->ts = *p++;
        if (id >= 0) {
            id *= 3;
            o->x = word_CCEF8[id];
            o->y = word_CCEF8[++id];
            o->base = word_CCEF8[++id];
            o->first = byte_CCE00[o->base];
            o->frame = byte_CCE00[o->base + ((signed char *)&o->ts)[1]];
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
    word_CC10C = *p++;
    penshotfox = *p++;
    penshotfoy = *p++;
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
    if (FileReadAt(fh, &byte_E9AC8, -1, 0xB)) FatalError((char *)str_ErrLoadGame);
    if (FileReadAt(fh, &byte_E9AD3, -1, 0xB)) FatalError((char *)str_ErrLoadGame);
    if (FileReadAt(fh, unk_C5423, -1, 0xB)) FatalError((char *)str_ErrLoadGame);
    if (FileReadAt(fh, unk_C542E, -1, 0xB)) FatalError((char *)str_ErrLoadGame);
    if (FileReadAt(fh, penhome, -1, 0x40)) FatalError((char *)str_ErrLoadGame);
    if (FileReadAt(fh, penaway, -1, 0x40)) FatalError((char *)str_ErrLoadGame);
    i = n = 0;
    do {
        if (!n) {
            n = 0x80;
            if (i >= 0x30) n = 0x44;
            if (FileReadAt(fh, buf, -1, n)) FatalError((char *)str_ErrLoadGame);
            q = (short *)buf;
        }
        *(Rec16 *)((char *)dword_DB088 + i / 25 * 25 * 16 + i % 25 * 16) = *(Rec16 *)q;
        q += 8;
        n -= 0x10;
    } while (++i < 0x32);
    for (i = 0; i < 6; i++) {
        *(Rec6 *)((char *)unk_DC240 + i / 3 * 9 * 2 + i % 3 * 3 * 2) = *(Rec6 *)q;
        q += 3;
    }
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
    dword_C66D0 = dword_C66D4 = 1;
    hudhundstep = 0;
    LoadRockMusic();
    __STOSD(photobanks, -1, 0x17);
    photobankf = -1;
    LoadGameGfx();
    __STOSD(photobanks, 0, 0x17);
    photobankf = 0;
    if (ovlseq != -1 && ovlstep != -1) ovlscript = off_CC01D[ovlseq];
    BuildEventLines();
    recbpr = replaystart;
    ReplayRecordReset();
    sflags &= 0xEF;
    fadeinpending = 1;
    hmtmsort = (int)SortCords;
    dword_DF6F2 = (int)unk_DACA0;
    dword_DF6F6 = (int)unk_DAC40;
    hmtmlines[0] = (int)hmlinetab;
    hmtmplstats = (int)dword_DB088;
    hmtmglstats = (int)unk_DC240;
    hmtmroster = (int)hmroster;
    hmtmptrF2 = (int)hmteamrec;
    awtmsort = (int)(SortCords + 6);
    dword_DF7F2 = (int)unk_DAE94;
    dword_DF7F6 = (int)unk_DAC70;
    awtmlines = (int)awlinetab;
    awtmplstats = (int)unk_DB218;
    awtmglstats = (int)unk_DC252;
    awtmroster = (int)awroster;
    awtmptrF2 = (int)awteamrec;
    pl = SortCords;
    for (i = 0; i < 0x11; i++, pl++) {
        pl->SCnum = i;
        pl->radiusx = word_CBD64[i * 9];
        pl->radiusy = word_CBD66[i * 9];
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
