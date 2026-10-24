/* Engine init and three-stars ceremony: one module across the segment split. */
#define ThreeStarsLoop ThreeStarsLoop_decl
#define PickThreeStars PickThreeStars_decl
#define StartThreeStars StartThreeStars_decl
#define assthreestars assthreestars_decl
#define PreGameIntro PreGameIntro_decl
#define StarCompare StarCompare_decl
#include "nhl95.h"
#undef StarCompare
#undef ThreeStarsLoop
#undef PickThreeStars
#undef StartThreeStars
#undef assthreestars
#undef PreGameIntro
#define REF ((Player *)puckstruct + 2)   /* the referee (E001C) */
#define GSTAT(t, g) ((short *)((char *)word_DC242 + (t) * 18 + (g) * 6))
#define PSTAT(t, j) ((short *)((char *)dword_DB088 + (t) * 0x190 + (j) * 16))
typedef struct { char c[10]; } StarStr10;
/* the goalie stats as an indexed array (the base folds into the displacement: [reg+DC242]) */
#define GS(t, g) (((short (*)[3][3])word_DC242)[t][g])
int ThreeStarsLoop(void);
void PickThreeStars(void);
void StartThreeStars(void);
void assthreestars(Player*p);
void FadeOutPalCycle(void);
void PreGameIntro(void);
int StartPreGame(int skip);
int StarCompare(const void *a, const void *b);

/* FadeOutPalCycle: end the loading screen palette cycle: step all 3 loadpals palettes down to black (one level
 per 2 ticks, the cycle locked while changing them), then remove the LoadScreenPalTick timer and clear
 loadscreenon. */
void FadeOutPalCycle(void)
{
    int done;
    int i;
    int j;

    if (!loadscreenon) return;
    done = 0;
    while (!done) {
        palcyclelock = done = 1;
        for (i = 0; i < 3; i++) {
            for (j = 0; j < 0x300; j++) {
                if ((signed char)loadpals[i * 0x300 + j] > 0) {
                    loadpals[i * 0x300 + j]--;
                    if (done == 1) done = 0;
                }
            }
        }
        palcyclelock = 0;
        SetTickDeadline(2);
        WaitTickDeadline();
    }
    palcyclelock = 1;
    RemoveTimerCallback(LoadScreenPalTick);
    loadscreenon = 0;
}

/* PreGameIntro (47CD6, PC only): set up the pre-game skate: the crowd sample, the home team's power play colours
   (LoadTeamPPV), the text lines, period, seed (mixed with both teams), the 1800-tick sequence timer and no
   controlled players; both teams' energy, lines and players (reenergizeteam, setpersonel, forcepldata); then the
   six players of each team (walking down from unk_DFD9C): the ones not dressed (position 0) stand at the centre
   line facing their end, the others skate in from five random lanes by their side, all with the skate-in
   assignment (25h); the puck held at the boards (1Ah) and the referee at centre ice (26h). Two game frames and a
   sprite sort, the camera and view at the start, the text overlay closed and the HUD panel redrawn. No arguments
   and no result. */
void PreGameIntro(void)
{
    short side;
    short i;
    short y;
    short lane;
    short v;
    short team;
    int r;
    char used[5];
    Player *p;

    PlayCrowdSample(0xA);
    team = byte_CC9B0[HomeTeam];
    y = word_CC9CC[byte_CC9B0[HomeTeam]];
    LoadTeamPPV((short)(team != 1 ? 4 : 3));
    textline5 = 0;
    textline4 = 0;
    textline2 = 0;
    textline1 = 0;
    textline3 = 0;
    curperiod = -1;
    foy = 0;
    fox = 0;
    seed[0] += VisTeam + (HomeTeam << 16);
    shownumbers = 0;
    seqtimer = 0x708;
    exitgame = 0;
    c2playernum[0] = -1;
    c1playernum[0] = -1;
    reenergizeteam(&hmtmstruct);
    setpersonel(&hmtmstruct);
    forcepldata(&hmtmstruct);
    reenergizeteam(&awtmstruct);
    setpersonel(&awtmstruct);
    forcepldata(&awtmstruct);
    resetplstuff();
    p = (Player *)unk_DFD9C;
    for (side = 0; side < 2; side++) {
        for (i = 0; i < 5; i++) used[i] = 0;
        for (i = 0; i < 6; i++, p--) {
            if (p->position == 0) {
                HIWORD(p->Xpos) = 0;
                p->temp3 = 0;
                v = (p->pflags & 0x80) ? -0xDC : 0xDC;
                HIWORD(p->Ypos) = v;
                p->temp4 = v;
                p->temp5 = -0x64;
                p->Yvel = 0;
                p->Xvel = p->Yvel;
                p->facedir = (p->pflags & 0x80) ? 0 : 4;
                SetSPA(p, 0x99);
            } else {
                lane = randomd0(5);
                while (used[lane]) lane = (lane + 1) % 5;
                used[lane] = 1;
                v = lane * 0x28 - 0x50;
                v += randomd0(8) - 4;
                HIWORD(p->Xpos) = v;
                p->temp3 = v;
                HIWORD(p->Xpos) += randomd0(2);
                v = (p->pflags & 0x80) ? -0x3A : 0x30;
                r = randomd0(4);
                v += r - 2;
                HIWORD(p->Ypos) = v;
                p->temp4 = v;
                p->facedir = 4;
                p->Yvel = 0;
                p->Xvel = p->Yvel;
                p->temp5 = y + (randomd0(0x28) - 0x14);
                SetSPA(p, 0);
                p->frame = 0x171;
            }
            assreplace(p, 0x25);
        }
    }
    ((Player *)puckstruct)->temp2 = 0x78;
    HIWORD(((Player *)puckstruct)->Xpos) = 200;
    HIWORD(((Player *)puckstruct)->Ypos) = -0x12C;
    ((Player *)puckstruct)->Xvel = 0;
    ((Player *)puckstruct)->Yvel = 0;
    assreplace((Player *)puckstruct, 0x1A);
    word_E0042 = team;
    HIWORD((REF)->Xpos) = 0x8E;
    word_E0046 = 0x8E;
    HIWORD((REF)->Xpos) += randomd0(2);
    HIWORD((REF)->Ypos) = 0;
    word_E0048 = 0;
    (REF)->facedir = 4;
    word_E002A = 0;
    word_E0028 = 0;
    word_E004A = y;
    SetSPA(REF, 0);
    word_E002E = 0x289;
    assreplace(REF, 0x26);
    RefStep[0] = 0;
    sflags |= 0x40;
    DoGameFrame();
    DoGameFrame();
    SprSort();
    frameaccum = 0;
    inputframes = 0;
    *(unsigned char *)puckc = 0xFF;
    joysampling = 0;
    joyq_flush();
    camx = 0;
    xc1 = 0;
    camy = 0;
    yc1 = 0;
    viewscrollx = 0x20;
    viewscrolly = 0xEC;
    if (ovlseq != -1) CloseTextOverlay();
    SelectScreenBM();
    lcblink[1] = 0;
    lcblink[0] = 0;
    energywarn[1] = 0;
    energywarn[0] = 0;
    UpdateHudPanel();
}

/* Matched under 10.0 GA. The frame loop and exit precede StartPreGame; its entry follows it.
   PickThreeStars keeps the shared pop / ret exit here, across the segment split.
   pieces of ThreeStarsLoop: PreGameIntro_scroll PreGameIntro_end */
/* ThreeStarsLoop (48333, PC only): run the pre-game skate until the sequence timer (seqtimer) runs out, Escape
   (escrequest) or a button (fire 10h / 20h on either pad: skip, with a palette fade): each 4-tick frame run the
   game frames due (6 per 10 input samples), follow the camera with the view (clamped to 0-40h, 0-1A8h), draw
   the rink and its overlays, fade the palette in once (fadeinpending) and update the crowd. At the end free the
   overlay sequence, fade out on Escape (and stop the crowd) or on a skip, and stop the sound and speech.
   Result: -1 after Escape, else 0. */
int ThreeStarsLoop(void)
{
    short n;
    int a;

    TicksSinceLastCall();
    joysampling = 1;
    escrequest = 0;
    rinkscrollx += 0x3E8;
    rinkscrolly += 0x3E8;
    while (seqtimer != 0) {
        SetTickDeadline(4);
        frameaccum += (short)ResetInputSampling() * 6;
        n = frameaccum / 10;
        frameaccum %= 10;
        RunGameFrames(n);
        seqtimer -= n;
        if (seqtimer < 0) seqtimer = 0;
        viewscrollx = camx + 0x20;
        viewscrolly = 0x140 - camy - 0x54;
        if (viewscrollx > 0x40) viewscrollx = 0x40;
        else if (viewscrollx < 0) viewscrollx = 0;
        if (viewscrolly > 0x1A8) viewscrolly = 0x1A8;
        else if (viewscrolly < 0) viewscrolly = 0;
        sub_6AF97(0, 0);
        sub_6B008();
        SetRinkScroll(viewscrollx, viewscrolly);
        sub_6AF52(bgscrollx * 8 + scrollx, bgscrolly * 8 + scrolly, bgscrollx * 8 + scrollx + 0x140, bgscrolly * 8 + scrolly + 0xA8);
        spritedrawcount = 0;
        DrawRinkOverlays((short)viewscrollx, (short)viewscrolly);
        sub_6AF97(-(bgscrollx * 8 + scrollx), -(bgscrolly * 8 + scrolly));
        sub_6ADA7();
        if (fadeinpending) {
            joysampling_save = joysampling;
            joysampling = 0;
            FadePalette(0, gamepal, 0x10);
            fadeinpending = 0;
            joysampling = joysampling_save;
        }
        CrowdNoiseUpdate(n);
        if (escrequest) break;
        Readjoy1();
        if (*(unsigned char *)&regd1 & 0x10 || *(unsigned char *)&regd1 & 0x20) {
            introskipped = 1;
            fadeinpending = 1;
            break;
        }
        Readjoy2();
        if (*(unsigned char *)&regd1 & 0x10 || *(unsigned char *)&regd1 & 0x20) {
            introskipped = 1;
            fadeinpending = 1;
            break;
        }
        WaitTickDeadline();
    }
    joysampling = 0;
    if (ovlseq != -1) {
        FreeMemBlock(dword_E0244);
        ovlseq = -1;
    }
    if (escrequest) {
        sub_8FFB0(0, 0x100, savepal);
        FadePalette(1, savepal, 0x10);
        CrowdFadeOut();
        StopDigiSample();
        SpeechStopQueue();
        escrequest = 0;
        return -1;
    }
    if (introskipped) {
        sub_8FFB0(0, 0x100, savepal);
        FadePalette(1, savepal, 0x10);
    }
    StopDigiSample();
    SpeechStopQueue();
    return 0;
}

/* StartPreGame (4830E, PC only): start the game's pre-game skate unless dword_CC0EC is set (then result 0): the
   intro set-up (PreGameIntro) unless skip, the crowd noise reset, then the skate itself (ThreeStarsLoop, which it
   falls into). skip: leave the set-up out. Result: ThreeStarsLoop's. */
int StartPreGame(int skip)
{
    if (dword_CC0EC) return 0;
    if (!(short)skip) PreGameIntro();
    CrowdNoiseReset();
    return ThreeStarsLoop();
}

/* PickThreeStars (48AC8, PC only; ends in PreGameIntro_popebp): pick the three stars. Clear the three star slots
   (startm / starpl) and the game winner (gwgteam / gwgplayer). In overtime (curperiod beyond 3) with a winner whose
   team touched the puck last, the winning team's scorer (tmpsplayer) is the game-winning scorer, and when the goal
   clinched the cup he is the first star (AddStar). A goalie with a shutout (his opponents' score 0; the goalie of
   the three with the most of the first stats word) gets a star when he faced more shots than the period length's
   minimum (byte_CC9E4). Then the skaters with stats (not position 0 or 2; a position 1 player only with one of the
   stats words set), sorted by StarCompare: a player with more than one point gets a star; at the first one without,
   the goalies with enough shots (byte_CC9E7) and a goals-against rate (per thousand) of at most 4Bh get stars, then
   the rest of the list in order until there are three. No arguments, no result. */
void PickThreeStars(void)
{
    int list[50];
    short n;
    short stars;
    short i;
    short k;
    short *s;

    stars = 0;
    for (i = 0; i < 3; i++) startm[i * 2] = starpl[i * 2] = -1;
    gwgteam = gwgplayer = -1;
    if (curperiod > 3 && (i = awscore - hmscore[0]) != 0) {
        i = i > 0;
        if (i ^ (lasttouch < 6)) {
            gwgteam = i;
            gwgplayer = word_DF644[i * 0x80];
            if (IsCupClinched(hmscore[0], awscore)) stars += AddStar(stars, i, gwgplayer);
        }
    }
    for (i = 0; i < 2; i++) {
        if (hmscore[(i == 0) * 0x80] == 0) {
            k = 0;
            if (GSTAT(i, 1)[0] > GSTAT(i, 0)[0]) k = 1;
            if (GSTAT(i, 2)[0] > GSTAT(i, 0)[0] && GSTAT(i, 2)[0] > GSTAT(i, 1)[0]) k = 2;
            if (GS(i, k)[0] > byte_CC9E4[gameopts.pertime]) stars += AddStar(stars, i, k += 0x19);
        }
    }
    n = 0;
    for (i = 0; i < 0x32; i++) {
        k = hmroster[i / 25 * 0x444 + i % 25 * 39];
        if (k != 0 && k != 2) {
            s = PSTAT(i / 25, i % 25);
            if (k != 1 || s[0] || s[1] || s[2] || s[3] || s[7]) list[n++] = i;
        }
    }
    qsort(list, n, 4, StarCompare);
    for (i = 0; i < n; i++) {
        k = list[i];
        if (*(short *)((char *)dword_DB088 + (((k / 25 * 25) << 4) + k % 25 * 16)) + *(short *)((char *)dword_DB088 + (((k / 25 * 25) << 4) + k % 25 * 16) + 2) > 1) {
            stars += AddStar(stars, k / 25, k % 25);
            if (stars >= 3) return;
        } else {
            for (k = 0; k < 6; k++) {
                if (byte_CC9E7[gameopts.pertime] <= GS(k / 3, k % 3)[0] && (GS(k / 3, k % 3)[1] * 0x3E8 + GS(k / 3, k % 3)[0] / 2) / GS(k / 3, k % 3)[0] <= 0x4B) {
                    stars += AddStar(stars, k / 3, k % 3 + 0x19);
                    if (stars >= 3) return;
                }
            }
            break;
        }
    }
    for (; i < n; i++) {
        k = list[i];
        stars += AddStar(stars, k / 25, k % 25);
        if (stars >= 3) return;
    }
}

/* Matched under 10.0 GA: the parking loop tests at the bottom once q is set before the for.
   The intro and three-stars routines share the epilogue in ThreeStarsLoop. */
/* StartThreeStars (48F0B, PC only; ends in PreGameIntro_popx): the three stars ceremony after the game (not in the
   demo, dword_CC0EC). Input sampling off, fade the saved palette out (the fade-in pending), pick the stars
   (PickThreeStars). Clear the line change and penalty signals, the banner and the text overlay (freeing its art),
   the text lines, end the period count (curperiod -1) and the game-over flags, stop the clock (gmode bit 0 on, bit 7
   off), run the sequence for 2EE0h ticks, release the controllers and empty the penalty boxes. Park the twelve
   players off the ice (x -C8h, no assignment, out of play: pflags bits 3 and 5 off, pflags2 bit 2 on), put the
   puck and the second object at (C8h, -12Ch) on assignments 1Ah / 19h and the referee at (-C8h, 0) on assignment
   15h (assthreestars). Two game frames, the camera at (-20h, 0), close the overlay and run the loop
   (ThreeStarsLoop; when it was cut short the crowd goes quiet). Then the period back, the crowd faded out and the
   music reset (MusicChanReset, or sub_8F633 with the music off). No arguments, no result. */
void StartThreeStars(void)
{
    Player *q;
    int per;
    int i;

    if (dword_CC0EC) return;
    per = curperiod;
    joysampling = 0;
    joyq_flush();
    sub_8FFB0(0, 0x100, savepal);
    FadePalette(1, savepal, 0x10);
    fadeinpending = 1;
    PickThreeStars();
    byte_E9AC8 = 0xFF;
    word_CBC44 = 0;
    RefPen = 0;
    refsignal = 0;
    Penaltytimer = 0;
    bannertimer = 0;
    word_CBEC6 = 0;
    lcboxon[1] = 0;
    lcboxon[0] = 0;
    lcblink[1] = 0;
    lcblink[0] = 0;
    energywarn[1] = 0;
    energywarn[0] = 0;
    lcrequest[1] = 0;
    lcrequest[0] = 0;
    if (ovlseq != -1) FreeMemBlock(dword_E0244);
    ovlseq = ovlstep = bannermsg = -1;
    textline3 = textline1 = textline2 = textline4 = textline5 = 0;
    curperiod = -1;
    gameover = exitgame = 0;
    gmode |= 1;
    gmode &= 0x7F;
    seqtimer = 0x2EE0;
    c1playernum[0] = c2playernum[0] = -1;
    PBnum[1] = 0;
    PBnum[0] = 0;
    q = SortCords;
    for (i = 0; i < 0xC; i++, q++) {
        q->temp3 = HIWORD(q->Xpos) = -0xC8;
        q->temp4 = HIWORD(q->Ypos) = 0;
        q->temp5 = -100;
        q->Xvel = q->Yvel = 0;
        q->frame = -1;
        q->newpnum = q->newpos = -1;
        SetSPA(q, 0);
        assreplace(q, 0);
        q->pflags &= 0xD7;
        q->pflags2 |= 4;
    }
    ((Player *)puckstruct)->temp2 = 0x78;
    HIWORD(((Player *)puckstruct)->Xpos) = 0xC8;
    HIWORD(((Player *)puckstruct)->Ypos) = -0x12C;
    ((Player *)puckstruct)->Xvel = 0;
    ((Player *)puckstruct)->Yvel = 0;
    assreplace((Player *)puckstruct, 0x1A);
    q = (Player *)puckstruct;
    q++;
    q->temp2 = 0x78;
    HIWORD(q->Xpos) = 0xC8;
    HIWORD(q->Ypos) = -0x12C;
    q->Xvel = 0;
    q->Yvel = 0;
    assreplace(q, 0x19);
    word_E0042 = 0;
    word_E0046 = HIWORD(SortCords[0x10].Xpos) = -0xC8;
    word_E0022 = 0;
    word_E0048 = 0;
    word_E002A = 0;
    word_E0028 = 0;
    SetSPA(&SortCords[0x10], 0);
    word_E002E = -1;
    assreplace(&SortCords[0x10], 0x15);
    RefStep[0] = 0;
    sflags |= 0x40;
    DoGameFrame();
    DoGameFrame();
    SprSort();
    inputframes = frameaccum = 0;
    *puckc = -1;
    xc1 = camx = -0x20;
    yc1 = camy = 0;
    CloseTextOverlay();
    if (ThreeStarsLoop() < 0) crowdlevel = 0;
    curperiod = per;
    CrowdFadeOut();
    crowdlevel = 0;
    if (musicon) MusicChanReset();
    else sub_8F633();
}

/* DRAFT: same size under 10.0 GA, 44 differing. The team abbreviation index goes through the int w first, so
   the jersey is recomputed after FormatPlayerName as in the EXE; the star's side, object slot and position each
   have their own local. Left, in the first announcement only: the EXE spills roster + 7 to a frame slot
   (sub esp, 4) for FormatPlayerName where this builds it in ecx (lea), and it sums the jersey index before the
   load (add eax, ebx / xor ebx, ebx). See docs/UNSURE.md. */
/* assthreestars (495B8, PC only; ends in PreGameIntro_popebp): asstab 15h, the referee's part in the three stars.
   Wait while the overlay runs its first 10h ticks or its 258h-267h stretch. A new assignment (bit 1): "EA Sports"
   on the third text line, the third star first (temp1 2), a pause of 14h-27h ticks (DCh more with speech and music
   on), then announce it: "%s Star" with its order word, the player's name with his jersey number (FormatPlayerName
   from the team record and roster) and the speech (PaPlayerNumber). When the pause runs out: after the first star
   end the sequence (seqtimer 0, exitgame and gameover); once the announced star has skated back (temp1 64h, frame -1)
   pause 14h-31h ticks and announce the next star (after the last let the overlay run on at 258h); otherwise bring
   the star out: object 5 or 6 by team (temp3), the crowd up (5DCh, 2BCh for the visitors), set him up as the star
   player (pnum, position 4 or 0 for a goalie, full energy 300h, setplayer) and send him out (assignments 1Dh, 14h,
   9). p: the referee. No result. */
void assthreestars(Player *p)
{
    Player *q;
    int tm;
    int pl;
    int w;
    int side;
    int slot;
    int pos;

    if (ovltimer != -1 && (ovltimer < 0x10 || ovltimer >= 0x258 && ovltimer < 0x268)) return;
    if (p->pflags & 2) {
        p->pflags &= 0xFD;
        *(StarStr10 *)&textline3 = *(StarStr10 *)str_EASports;
        textline4 = textline5 = 0;
        p->temp1 = 2;
        p->temp2 = randomd0(0x14) + 0x14;
        if (gameopts.speech && musicon) p->temp2 += 0xDC;
        p->temp3 = -1;
        tm = startm[p->temp1 * 2];
        pl = starpl[p->temp1 * 2];
        sprintf((char *)&textline1, (char *)str_StarFmt, starordtab[p->temp1]);
        FormatPlayerName((char *)&textline2, (char *)hmteamrec + tm * 0x2E8, hmrosterjersey[tm * 0x444 + pl * 39],
            (char *)hmroster + tm * 0x444 + pl * 39 + 7, (char *)hmroster + tm * 0x444 + pl * 39 + 0x17,
            (char *)unk_C1B3E);
        w = tm ? VisTeam : HomeTeam;
        PaPlayerNumber((char *)teamabbrevs[w], p->temp1 + 1, hmrosterjersey[tm * 0x444 + pl * 39]);
    }
    if (--p->temp2 > 0) return;
    if (p->temp1 < 0) {
        seqtimer = 0;
        gameover = exitgame = 1;
        return;
    }
    q = &SortCords[p->temp3];
    if (p->temp3 >= 0 && q->temp1 == 0x64 && q->frame == -1) {
        p->temp2 = randomd0(0x1E) + 0x14;
        if (gameopts.speech && musicon) p->temp2 += 0xDC;
        p->temp3 = -1;
        if (--p->temp1 < 0) {
            ovltimer = 0x258;
            return;
        }
        tm = startm[p->temp1 * 2];
        pl = starpl[p->temp1 * 2];
        sprintf((char *)&textline1, (char *)str_StarFmt, starordtab[p->temp1]);
        FormatPlayerName((char *)&textline2, (char *)hmteamrec + tm * 0x2E8, hmrosterjersey[tm * 0x444 + pl * 39],
            (char *)hmroster + tm * 0x444 + pl * 39 + 7, (char *)hmroster + tm * 0x444 + pl * 39 + 0x17,
            (char *)unk_C1B3E);
        w = tm ? VisTeam : HomeTeam;
        PaPlayerNumber((char *)teamabbrevs[w], p->temp1 + 1, hmrosterjersey[tm * 0x444 + pl * 39]);
        return;
    }
    if (p->temp2 < 0) return;
    slot = (startm[p->temp1 * 2] != 0) + 5;
    p->temp3 = slot;
    q = &SortCords[p->temp3];
    side = (q->pflags & 0x40) != 0;
    crowdlevel = side ? 0x2BC : 0x5DC;
    q->pnum = starpl[p->temp1 * 2];
    pos = q->pnum < 0x19 ? 4 : 0;
    q->position = pos;
    q->temp1 = 0;
    q->newpos = q->newpnum = -1;
    hmtmpde[side * 0x80 + q->pnum] = 0x300;
    p->pflags2 &= 0xFB;
    setplayer(q, q->pnum);
    assreplace(q, 0);
    assinsert(q, 0x1D);
    assinsert(q, 0x14);
    assinsert(q, 9);
}
