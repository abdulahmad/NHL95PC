/* Engine player logic: the three stars after the game. */
/* DRAFTS; see docs/UNSURE.md. PickThreeStars, StartThreeStars and assthreestars end in PreGameIntro's
   exits (PreGameIntro_popebp / PreGameIntro_popx, segment 036), but PreGameIntro is split: ThreeStarsLoop's frame
   loop and exit sit inside PreGameIntro's range, before StartPreGame and ThreeStarsLoop's own entry. So these drafts
   sit in their own file. */
#define StarCompare StarCompare_decl
#define IsCupClinched IsCupClinched_decl
#define ThreeStarsLoop ThreeStarsLoop_decl
#define PickThreeStars PickThreeStars_decl
#define StartThreeStars StartThreeStars_decl
#define assthreestars assthreestars_decl
#include "nhl95.h"
#undef StarCompare
#undef IsCupClinched
#undef ThreeStarsLoop
#undef PickThreeStars
#undef StartThreeStars
#undef assthreestars

int StarCompare(const void *a, const void *b);
int IsCupClinched(int home, int away);  /* 15C30: int arguments here */
int ThreeStarsLoop(void);  /* 48333 */
void PickThreeStars(void);
void StartThreeStars(void);
void assthreestars(Player *p);

#define GSTAT(t, g) ((short *)((char *)word_DC242 + (t) * 18 + (g) * 6))
#define PSTAT(t, j) ((short *)((char *)dword_DB088 + (t) * 0x190 + (j) * 16))

/* DRAFT: 1,107 vs 1,091 bytes, 105 lines (the roster index split and the stack slots); see docs/UNSURE.md. */
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
    short d;
    short *s;

    stars = 0;
    for (i = 0; i < 3; i++) startm[i * 2] = starpl[i * 2] = -1;
    gwgteam = gwgplayer = -1;
    if (curperiod > 3 && (d = awscore - hmscore[0]) != 0) {
        d = d > 0;
        if (d ^ (lasttouch < 6)) {
            gwgteam = d;
            gwgplayer = word_DF644[d * 0x80];
            if (IsCupClinched(hmscore[0], awscore)) stars += AddStar(stars, d, gwgplayer);
        }
    }
    for (i = 0; i < 2; i++) {
        if (hmscore[(i == 0) * 0x80] == 0) {
            k = 0;
            if (GSTAT(i, 1)[0] > GSTAT(i, 0)[0]) k = 1;
            if (GSTAT(i, 2)[0] > GSTAT(i, 0)[0] && GSTAT(i, 2)[0] > GSTAT(i, 1)[0]) k = 2;
            if (byte_CC9E4[gameopts.pertime] < GSTAT(i, k)[0]) stars += AddStar(stars, i, k += 0x19);
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
        s = PSTAT(k / 25, k % 25);
        if (s[0] + s[1] > 1) {
            stars += AddStar(stars, k / 25, k % 25);
            if (stars >= 3) return;
        } else {
            for (k = 0; k < 6; k++) {
                s = GSTAT(k / 3, k % 3);
                if (byte_CC9E7[gameopts.pertime] <= s[0] && (s[1] * 0x3E8 + s[0] / 2) / s[0] <= 0x4B) {
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

/* DRAFT: 853 bytes, every instruction matches; only its three exits differ: the EXE jumps to PreGameIntro_popx
   (segment 036), C to the pops of a function of this file. The parking loop tests at the bottom once q is set
   before the for (with `for (q = SortCords, i = 0; ...)` C jumps to the test first). See docs/UNSURE.md. */
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

typedef struct { char c[10]; } StarStr10;

/* DRAFT: 1,043 vs 1,056 bytes, 145 lines (the team / player reads and the roster offsets); see docs/UNSURE.md. */
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
    short tm;
    short pl;
    int w;

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
        PaPlayerNumber((char *)teamabbrevs[tm ? VisTeam : HomeTeam], p->temp1 + 1, hmrosterjersey[tm * 0x444 + pl * 39]);
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
        PaPlayerNumber((char *)teamabbrevs[tm ? VisTeam : HomeTeam], p->temp1 + 1, hmrosterjersey[tm * 0x444 + pl * 39]);
        return;
    }
    if (p->temp2 < 0) return;
    p->temp3 = (startm[p->temp1 * 2] != 0) + 5;
    q = &SortCords[p->temp3];
    w = (q->pflags & 0x40) != 0;
    crowdlevel = w ? 0x2BC : 0x5DC;
    q->pnum = starpl[p->temp1 * 2];
    q->position = q->pnum < 0x19 ? 4 : 0;
    q->temp1 = 0;
    q->newpos = q->newpnum = -1;
    hmtmpde[w * 0x80 + q->pnum] = 0x300;
    p->pflags2 &= 0xFB;
    setplayer(q, q->pnum);
    assreplace(q, 0);
    assinsert(q, 0x1D);
    assinsert(q, 0x14);
    assinsert(q, 9);
}
