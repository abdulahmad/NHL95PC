/* Game frame: a highlight run of the game engine. */
#define StartHL2 StartHL2_decl
#define SprSortVert SprSortVert_decl
#define SprSort SprSort_decl
#define TicksSinceLastCall TicksSinceLastCall_decl
#define MusicChanReset2 MusicChanReset2_decl
#include "nhl95.h"
#undef StartHL2
#undef SprSortVert
#undef SprSort
#undef TicksSinceLastCall
#undef MusicChanReset2

typedef struct { int c[12]; } LineTab;  /* a team's line table, 30h bytes */

int StartHL2(int home, int vis, int *hsc, int *asc, int period);
void SprSortVert(void);
void SprSort(void);
void TicksSinceLastCall(void);
void MusicChanReset2(void);

/* StartHL2 (69336, PC only): play a highlight of the game in demo mode. Saves the game state (teams, goalies,
   controllers, period, scores, both teams' bench words, the options and the line tables), loads home against vis
   with the given score and period, sets up the rink at the 320 x 200 size with the players around their faceoff
   spots and the puck loose, and runs frames (the announcer's highlight introduction when the screen first fades
   in) until the clock runs out, Esc or a fire button on either pad. Then fades out, restores the saved game and
   returns to it. home, vis: the teams; hsc, asc: their scores (the highlight's final score is stored back);
   period: the period. Result: -1 when it ended on Esc, else 0. */
int StartHL2(int home, int vis, int *hsc, int *asc, int period)
{
    LineTab hml;
    short save[0x44];
    LineTab awl;
    int opts;
    short sgameover;
    short sgmode2;
    short r;
    short *p;
    short *q;
    int i;
    int k;
    int j;
    int t;
    Player *pl;

    dword_CCC98 = 0;
    sgameover = gameover;
    p = save;
    *p++ = HomeTeam;
    *p++ = VisTeam;
    *p++ = hmtmgoalie[0];
    *p++ = awtmgoalie;
    *p++ = cont1team;
    *p++ = cont2team;
    *p++ = curperiod;
    *p++ = gsp;
    *p++ = hmtmap[0];
    *p++ = awtmap;
    *p++ = hmscore[0];
    *p++ = awscore;
    for (i = 0; i < 2; i++) {
        q = (&hmtmstruct)[i].tmpdst;
        for (j = 0; j < 0x1C; j++) *p++ = *q++;
    }
    opts = *(int *)&gameopts;
    hml = *(LineTab *)hmlinetab;
    awl = *(LineTab *)awlinetab;
    FlushGSumQueue();
    *(unsigned char *)&gameopts &= 0xE4;
    gameover = 0;
    CwdExciteLvl = 0;
    HomeTeam = home;
    VisTeam = vis;
    LoadGameTeams(2);
    if (ovlseq != -1) FreeMemBlock(dword_E0244);
    LoadTeamPalette(HomeTeam, VisTeam, gamepal);
    LoadPlayerPhotos();
    awtmgoalie = 0;
    hmtmgoalie[0] = 0;
    restoreteams();
    c2playernum[0] = -1;
    c1playernum[0] = -1;
    cont2team = 0;
    cont1team = 0;
    gameclock = randomd0(0x78) + 0x3C;
    clockticks[0] = 0;
    hudclockmin = gameclock / 60;
    hudclocksec = gameclock % 60;
    hudclockhund = 0;
    curperiod = period;
    gsp = period - 1;
    hmscore[0] = *hsc;
    awscore = *asc;
    hmtmline[0] = randomd0(7) % 4;
    awtmline = randomd0(7) % 4;
    FadeOutPalCycle();
    SetScreenSize(0x140, 0xC8);
    LoadRink(HomeTeam >= 0x1A ? 0xC : HomeTeam);
    DrawHudPanel(HomeTeam, VisTeam, curperiod, 0);
    gmode = 0;
    gmode = 0x10;
    if (gsp & 1 && (gsp != 3 || !gameopts.fullot ? 1 : 0)) gmode |= 2;
    sgmode2 = *(short *)&gmode2;
    *(short *)&sflags3 = 0;
    *(short *)&gmode2 = 0;
    *(short *)&sflags = 0;
    *(short *)&gmode2 = 4;
    icingPlayer = 0;
    iflags = 0;
    passplayer = -1;
    refsignal = 0;
    RefStep[0] = -1;
    Pencntdwn = -1;
    RefPen = 0;
    word_C90D8 = -1;
    ovltimer = -1;
    word_CBC44 = 0;
    bannermsg = -1;
    ovlstep = -1;
    ovlseq = -1;
    bannertimer = 0;
    word_CBEC6 = 0;
    crowdlevel = 0;
    crowdsmooth = 0;
    word_DF81A = -1;
    word_DF816 = -1;
    setupice();
    SprSortVert();
    camy = 0;
    camx = 0;
    yleader = 0;
    yc1 = 0;
    xc1 = 0;
    rinkscrollx += 0x3E8;
    rinkscrolly += 0x3E8;
    ResetBench();
    reenergizeteam(&hmtmstruct);
    setpersonel(&hmtmstruct);
    forcepldata(&hmtmstruct);
    dword_DF648[0] = -1;
    dword_DF646[0] = -1;
    word_DF644[0] = -1;
    reenergizeteam(&awtmstruct);
    setpersonel(&awtmstruct);
    forcepldata(&awtmstruct);
    dword_DF748 = -1;
    word_DF746 = -1;
    word_DF744 = -1;
    resetplstuff();
    pl = SortCords;
    for (i = 0; i < 0xC; i++, pl++) {
        k = (pl->pflags & 0x80 ? 0 : 6) + pl->position;
        j = k + k;
        r = randomd0(0x14) - 10;
        HIWORD(pl->Xpos) = dword_CD9A0[k * 2] + r;
        t = pl->position == 0;
        HIWORD(pl->Ypos) = (randomd0(pl->position == 0 ? 4 : 0x14) - t ? 4 : 0xA) + dword_CD9A0[j + 1];
        pl->Xvel = pl->Yvel = 0;
        pl->facedir = vtoa((short)(*puckx - HIWORD(pl->Xpos)), (short)(*pucky - HIWORD(pl->Ypos)));
    }
    ((short *)puckstruct)[0x14] = 0x78;
    ((short *)puckstruct)[1] = randomd0(0x14) - 10;
    ((short *)puckstruct)[3] = randomd0(0x14) - 10;
    ((short *)puckstruct)[5] = 0;
    ((short *)puckstruct)[6] = randomd0(0x7D0) - 0x3E8;
    ((short *)puckstruct)[7] = randomd0(0x7D0) - 0x3E8;
    ((short *)puckstruct)[9] = 0x18A;
    ((short *)puckstruct)[0x2A] = 0;
    assreplace((Player *)puckstruct, 0x18);
    pl = (Player *)puckstruct;
    pl++;
    ((short *)pl)[9] = 0x189;
    ((short *)pl)[0x2A] = 0;
    assreplace(pl, 0x19);
    HIWORD(SortCords[0x10].Xpos) = -0x78;
    HIWORD(SortCords[0x10].Ypos) = 0;
    SortCords[0x10].facedir = 2;
    SortCords[0x10].Yvel = 0;
    SortCords[0x10].Xvel = 0;
    assreplace(&SortCords[0x10], 0x1F);
    DoGameFrame();
    DoGameFrame();
    SprSort();
    i = 0;
    hudhundaccum = 0;
    inputframes = 0;
    *puckc = -1;
    joysampling = 0;
    joyq_flush();
    exitgame = 0;
    gameover = 0;
    fadeinpending = 2;
    TicksSinceLastCall();
    joysampling = 1;
    demomode = 1;
    escrequest = 0;
    while (!exitgame) {
        i += ResetInputSampling() * 6;
        j = i / 10;
        i %= 10;
        RunGameFrames(j);
        viewscrollx = camx + 0x20;
        viewscrolly = 0x140 - camy - 0x54;
        if (viewscrollx > 0x40) viewscrollx = 0x40;
        else if (viewscrollx < 0) viewscrollx = 0;
        if (viewscrolly > 0x1A8) viewscrolly = 0x1A8;
        else if (viewscrolly < 0) viewscrolly = 0;
        sub_6AF97(0, 0);
        sub_6B008();
        SetRinkScroll(viewscrollx, viewscrolly);
        sub_6AF52(scrollx + bgscrollx * 8, scrolly + bgscrolly * 8, bgscrollx * 8 + scrollx + 0x140,
            scrolly + bgscrolly * 8 + 0xA8);
        spritedrawcount = 0;
        DrawRinkOverlays((short)viewscrollx, (short)viewscrolly);
        sub_6AF97(-(bgscrollx * 8 + scrollx), -(bgscrolly * 8 + scrolly));
        sub_6ADA7();
        if (fadeinpending) {
            joysampling_save = joysampling;
            joysampling = 0;
            sub_8FFB0(0, 0x100, savepal);
            FadePalette(1, savepal, 0x10);
            joysampling = joysampling_save;
        }
        CrowdNoiseUpdate((short)j);
        hudhundstep = hudhundaccum / 0x18;
        hudhundaccum %= 0x18;
        if (exitgame && !(gameclock | clockticks[0]))
            hudhundstep = (hudclockmin * 60 + hudclocksec) * 100 + hudclockhund;
        UpdateHudPanel();
        if (fadeinpending) {
            joysampling_save = joysampling;
            joysampling = 0;
            if (fadeinpending == 2) {
                PaOpenBank();
                PaHighlightIntro(home, vis);
                FadePalette(0, gamepal, 0x10);
                fadeinpending = 0;
                crowdlevel = randomd0(0xC8) + 0x64;
                crowdsmooth = crowdlevel;
            }
            joysampling = joysampling_save;
        }
        if (escrequest) break;
        Readjoy1();
        if (regd1.w & 0x10 || regd1.w & 0x20) break;
        Readjoy2();
        if (regd1.w & 0x10 || regd1.w & 0x20) break;
    }
    joysampling = 0;
    if (ovlseq != -1) FreeMemBlock(dword_E0244);
    bannermsg = -1;
    ovlstep = -1;
    ovlseq = -1;
    demomode = 0;
    dword_CCC98 = 0;
    sub_8FFB0(0, 0x100, savepal);
    FadePalette(1, savepal, 0x10);
    CrowdFadeOut();
    crowdlevel = 0;
    crowdsmooth = 0;
    if (musicon && gameopts.speech) {
        MusicChanReset2();
        while (SpeechBusy());
    } else
        sub_8F633();
    StopDigiSample();
    exitgame = -1;
    SetScreenSize(0x280, 0x1E0);
    if (!escrequest) {
        sub_1BAF3(0x222E0);
        ShowLoadingScreen();
    }
    gameover = sgameover;
    p = save;
    HomeTeam = *p++;
    VisTeam = *p++;
    hmtmgoalie[0] = *p++;
    awtmgoalie = *p++;
    cont1team = *p++;
    cont2team = *p++;
    curperiod = *p++;
    gsp = *p++;
    hmtmap[0] = *p++;
    awtmap = *p++;
    *hsc = hmscore[0];
    *asc = awscore;
    hmscore[0] = *p++;
    awscore = *p++;
    for (i = 0; i < 2; i++) {
        q = (&hmtmstruct)[i].tmpdst;
        for (j = 0; j < 0x1C; j++) *q++ = *p++;
    }
    *(int *)&gameopts = opts;
    *(LineTab *)hmlinetab = hml;
    *(LineTab *)awlinetab = awl;
    LoadGameTeams(4);
    Intermission();
    gmode = 0;
    gmode = 1;
    if (gsp & 1 && (gsp != 3 || !gameopts.fullot ? 1 : 0)) gmode |= 2;
    *(short *)&sflags3 = 0;
    *(short *)&gmode2 = 0;
    *(short *)&sflags = 0;
    *(short *)&gmode2 = sgmode2;
    *puckc = -1;
    ovltimer = -1;
    camx = 0;
    camy = 0;
    LoadTeamPalette(HomeTeam, VisTeam, gamepal);
    energywarn[1] = 0;
    energywarn[0] = 0;
    lcblink[1] = 0;
    lcblink[0] = 0;
    lcline[1] = -1;
    lcline[0] = -1;
    lcboxon[1] = 0;
    lcboxon[0] = 0;
    fadeinpending = 1;
    hudhundaccum = 0;
    refsignal = 0;
    RefStep[0] = -1;
    assreplace(&SortCords[0x10], 0x1E);
    ClearPenaltyBuffer();
    Pencntdwn = -1;
    joyq_flush();
    if (escrequest) {
        escrequest = 0;
        return -1;
    }
    return 0;
}
