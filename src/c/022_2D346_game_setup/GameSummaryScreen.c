/* Game setup: the game summary pages (scoring, penalties, extras, other games). */
/* DRAFT (first pass from Ghidra): 7,755 of 8,023 bytes, 802 differing instructions; see docs/UNSURE.md. Every
   call and branch is in the EXE's order, the arrays sit in the EXE's slots (the seasonfh initializer is the
   gsuminitff template, the jump table follows it), and the two equal-arm ternaries give the EXE's dead tests.
   Left: the EXE keeps err (esp+788h) and nearly every scalar in memory and uses ebp as scratch, where this keeps
   err in ebp (`volatile int err` gave 7,936 bytes and 887 differing, but a 7ECh frame and `cmp [err], 0` after
   the first store, so not that); the -1 stores run dbfh, gsumfh, teamfh, copy where the EXE runs teamfh, dbfh,
   copy, gsumfh (declaring them in that order moves the slots: 899 differing); the other scalar slots. */
#define GameSummaryScreen GameSummaryScreen_decl
#define ReadGSummaryRec ReadGSummaryRec_decl
#define sub_913D0 sub_913D0_decl
#define sub_8F13B sub_8F13B_decl
#define sub_8F1FE sub_8F1FE_decl
#define sub_8F98F sub_8F98F_decl
#define sub_8FB8E sub_8FB8E_decl
#include "nhl95.h"
#undef GameSummaryScreen
#undef ReadGSummaryRec
#undef sub_913D0
#undef sub_8F13B
#undef sub_8F1FE
#undef sub_8F98F
#undef sub_8FB8E

int GameSummaryScreen(int mode, unsigned char first, unsigned char last, int unused);
int ReadGSummaryRec(int fh, void *rec, int n);  /* 147FF */
void __cdecl sub_913D0(int shape, int x, int y);
void *sub_8F13B(char *path);
void sub_8F1FE(void *smp);
int sub_8F98F(char *path);
void sub_8FB8E(int song, int handle, int a, int b);

/* A team record (2E8h bytes): the name at +1Ah, the players' key-record positions from +4Ch. */
#define RECKEY(t, k) (((int *)(recs[t] + 0x4C))[k])

/* GameSummaryScreen (2D35A, PC only): the game summary pages after a period or a game. Load the INDUS030 font,
   copy both teams' crests (CTLOGO2) into bitmaps (hmcrestbmp, vscrestbmp), load the CTBKGD2 background and
   palette and the title art for the mode: CTTITLE2 (summary, overtime, the three periods) for the scoring and
   penalty pages (mode bits 0 and 1), CTTITLE12 (defence, forwards, scratches, ...) for bits 2-4, CTTITLE3 for the
   other games (bit 5). Open the GSUMMARY file and read its header (home, visitor, the record count), both team
   records (TEAMS), the league database and both season databases; start the GAMESUM song, or the summary sample
   when the music is off or a song is still loaded. Mode 20h: one page per other game (othergames: both teams'
   names and scores, "1st period" .. "Final (OT)"), the first with PaElseNhl. Mode 4: for each team over its
   crest, the eight extras of its line table (INJURED beside the injured ones). Otherwise read the summary
   records (1 a goal, 2 a penalty, 4 the end of a period with its goals and shots) that the mode shows into an
   EVNT block, point a PRDS block at the period totals, and page through periods first..last: each goal with the
   scorer's goal count (season record plus this game: 1st, 2nd, ...; SH / PP), its time and the assists; each
   penalty with its time, minutes and name (penaltynames); "No Scoring." / "No Penalties." on an empty page, and
   on the scoring pages the shots on goal of both teams. The announcer calls the period (PaScoringPeriod). Each
   page fades in once and waits for a click or 1000 ticks; a click of 2 or more ends the summary. Then fade out
   the song or stop the sample, close the files and free everything. mode: the page bits; first, last: the
   periods to show; unused: not read. Result: 4 when the last click was 3, else 0. */
int GameSummaryScreen(int mode, unsigned char first, unsigned char last, int unused)
{
    unsigned char recs[2][0x2E8];
    char name[0x54];
    char state[0x40];
    char keyrec[0x34];
    int gad[13];
    signed char pgoals[2][0x19];
    unsigned char srec[0x30];
    char path[0x10];
    unsigned char gsum[0xB];
    unsigned char *linetab[2];
    int dbfh = -1;
    int gsumfh = -1;
    int teamfh = -1;
    int seasonfh[2] = { -1, -1 };
    void *smp;
    int nev;
    int newperiod;
    int i;
    int font;
    int done;
    int bkbank;
    int err;
    int titlebank;
    int shown;
    int firstpa;
    int fadein;
    int bkgd;
    int nperiods;
    int sayperiod;
    unsigned char *pal;
    unsigned char **prds;
    int periodend;
    int key;
    int pageend;
    int nshown;
    unsigned char *evbuf;
    int k;
    unsigned char shots[2];
    unsigned char goals[2];
    unsigned char score[2];
    unsigned char home;
    unsigned char period;
    unsigned char vis;
    unsigned char penalties;
    unsigned char scored;
    unsigned char pcount;
    unsigned char *ev;
    int bank;
    int crest;
    int side;
    int y;
    int j;
    int n;
    int d10;
    int d100;

    sub_1BAF3(700000);
    if (musicon && songdata) {
        sub_8FCDF(musichandle, 3, 0x4B);
        while (!sub_8FC8A(musicslot, 3)) ;
        sub_8D2F0(songdata);
        songdata = 0;
    }
    ClearInputQueue();
    for (i = 0; i < 2; i++)
        for (j = 0; j < 0x19; j++) pgoals[i][j] = 0;
    prds = 0;
    evbuf = 0;
    PaOpenBank();
    shown = 0;
    key = 0;
    periodend = 0;
    pageend = 0;
    done = 0;
    sayperiod = -1;
    period = first;
    pcount = 0;
    for (i = 0; i < 2; i++) {
        shots[i] = 0;
        score[i] = 0;
    }
    sub_B4BA8();
    sub_8E9E8(state);
    MakePath(name, fileoncd[0x21A] == 1 ? (char *)cddriveptr : 0, (char *)str_Indus0302, (char *)str_VFN);
    font = sub_8E8A0(name, 0x20);
    sub_8EA18(font);

    /* The crests, each copied into its own bitmap. */
    MakePath(path, fileoncd[0x59] == 1 ? (char *)cddriveptr : 0, (char *)str_Ctlogo2, 0);
    bank = sub_8E83C(path, 0);
    crest = sub_B30B4(bank, (char *)crestnames[HomeTeam]);
    hmcrestbmp[0] = sub_B4F8C(*(short *)(crest + 4), *(short *)(crest + 6), 0x20);
    SetDrawBitmap(hmcrestbmp[0]);
    sub_903F0(crest, 0, 0);
    *(short *)(*(int *)(hmcrestbmp[0] + 0x2C) + 8) = *(short *)(crest + 8);
    *(short *)(*(int *)(hmcrestbmp[0] + 0x2C) + 0xA) = *(short *)(crest + 0xA);
    crest = sub_B30B4(bank, (char *)crestnames[VisTeam]);
    vscrestbmp = sub_B4F8C(*(short *)(crest + 4), *(short *)(crest + 6), 0x20);
    SetDrawBitmap(vscrestbmp);
    sub_903F0(crest, 0, 0);
    *(short *)(*(int *)(vscrestbmp + 0x2C) + 8) = *(short *)(crest + 8);
    *(short *)(*(int *)(vscrestbmp + 0x2C) + 0xA) = *(short *)(crest + 0xA);
    sub_B4BA8();
    FreeMemBlock(bank);

    /* The background, its palette and the title art of the mode. */
    MakePath(path, fileoncd[0x58] == 1 ? (char *)cddriveptr : 0, (char *)str_Ctbkgd2, 0);
    bkbank = sub_8E83C(path, 0);
    bkgd = sub_B30B4(bkbank, (char *)str_Bkgd5);
    pal = (unsigned char *)sub_B30B4(bkbank, (char *)str_Pal13) + 0x10;
    if (mode & 3) {
        MakePath(path, fileoncd[0x5B] == 1 ? (char *)cddriveptr : 0, (char *)str_Cttitle2, 0);
        titlebank = sub_8E83C(path, 0);
        gad[8] = sub_B30B4(titlebank, (char *)str_Summ2);
        gad[2] = sub_B30B4(titlebank, (char *)str_OtShape);
        gad[4] = sub_B30B4(titlebank, (char *)str_Per1);
        gad[5] = sub_B30B4(titlebank, (char *)str_Per2);
        gad[6] = sub_B30B4(titlebank, (char *)str_Per3);
        gad[10] = sub_B30B4(titlebank, (char *)str_Top2);
    } else if (mode & 0x1C) {
        MakePath(path, fileoncd[0x5A] == 1 ? (char *)cddriveptr : 0, (char *)str_Cttitle12, 0);
        titlebank = sub_8E83C(path, 0);
        gad[0] = sub_B30B4(titlebank, (char *)str_Def2);
        gad[1] = sub_B30B4(titlebank, (char *)str_Fowa2);
        gad[7] = sub_B30B4(titlebank, (char *)str_Scra2);
        gad[9] = sub_B30B4(titlebank, (char *)str_Tlu2);
        gad[10] = sub_B30B4(titlebank, (char *)str_Top2);
    } else if (mode & 0x20) {
        MakePath(path, fileoncd[0x5C] == 1 ? (char *)cddriveptr : 0, (char *)str_Cttitle3, 0);
        titlebank = sub_8E83C(path, 0);
        gad[3] = sub_B30B4(titlebank, (char *)str_Ots);
        gad[11] = sub_B30B4(titlebank, (char *)str_Colm);
    }
    SetTextColors(0x40, 0);

    /* The summary header (home, visitor, the record count), the team records and the databases. */
    MakePath(name, (char *)&curleague, (char *)str_Gsummary2, (char *)str_extDB);
    err = FileOpenRead(name, &gsumfh);
    if (!err) err = ReadGSummaryRec(gsumfh, gsum, 0);
    if (!(mode & 0x20)) {
        if (!err) {
            nev = *(short *)(gsum + 5);
            home = gsum[3];
            vis = gsum[4];
            MakePath(name, (char *)&curleague, (char *)leaguedbnames[4], (char *)str_extDB);
            err = FileOpenRead(name, &teamfh);
        }
        if (!err) err = ReadTeamRec(teamfh, recs[0], home);
        if (!err) err = ReadTeamRec(teamfh, recs[1], vis);
        FileClose(&teamfh);
    }
    if (!err) {
        MakePath(name, (char *)&curleague, (char *)leaguedbnames[0], (char *)str_extDB);
        err = FileOpenRead(name, &dbfh);
    }
    if (!err) {
        strcpy(path, (char *)leaguedbnames[5]);
        sprintf(name, (char *)&leaguedbfmt, path);
        err = FileOpenRW(name, &seasonfh[0]);
    }
    if (!err) {
        strcpy(path, (char *)leaguedbnames[5]);
        sprintf(name, (char *)&leaguedbfmt2, path);
        err = FileOpenRW(name, &seasonfh[1]);
    }
    y = (mode & 0x1C) ? 0xA0 : 0xA0;    /* both arms equal: the EXE's lone `test byte [esp], 1Ch` */
    smp = 0;

    /* The GAMESUM song, or the summary sample. */
    if (!(mode & 0x20)) {
        FadeOutPalCycle();
        if (musicon && !songdata) {
            MakePath(name, fileoncd[0x1E4] == 1 ? (char *)cddriveptr : 0, (char *)str_Gamesum, (char *)str_Iff6);
            songdata = sub_8F98F(name);
            if (songdata && gameopts.music) sub_8FB8E(songdata, musichandle, 3, 0x4C);
        } else {
            if (sounddev == 8) MakePath(name, fileoncd[0x102] == 1 ? (char *)cddriveptr : 0, (char *)str_Mtsum, 0);
            else MakePath(name, fileoncd[0x21] == 1 ? (char *)cddriveptr : 0, (char *)str_Adsum, 0);
            dword_CCC94 = 0x20;
            smp = sub_8F13B(name);
            dword_CCC94 = 0;
            PlayDigiSample(smp);
        }
    }
    ClearInputQueue();
    joyq_flush();
    linetab[0] = hmlinetab;
    linetab[1] = awlinetab;
    if (!(mode & 0x24)) {
        sub_913B4(bkgd);
        if (mode & 3) {
            DrawGadgetByType(mode, first, (int)pal, gad, 0, (int)goals);
            sub_913D0(*(int *)(hmcrestbmp[0] + 0x2C), 0x3D, 0x50);
            sub_913D0(*(int *)(vscrestbmp + 0x2C), 0x221, 0x50);
        } else {
            DrawGadgetByType(mode, first, (int)pal, gad, 0, (int)goals);
        }
    } else if (mode & 0x20) {
        /* The other games: one page each. */
        for (i = 0; i < 6 && key < 2 && !err; i++) {
            home = othergames[i * 2];
            vis = othergamesb[i * 2];
            period = otherperiod[i];
            score[0] = otherscores[i * 2];
            score[1] = otherscoresb[i * 2];
            if (!err) {
                MakePath(name, (char *)&curleague, (char *)leaguedbnames[4], (char *)str_extDB);
                err = FileOpenRead(name, &teamfh);
            }
            if (!err) err = ReadTeamRec(teamfh, recs[0], home);
            if (!err) err = ReadTeamRec(teamfh, recs[1], vis);
            FileClose(&teamfh);
            if (!err) {
                if (i) sub_B4BC4(0x72, 0x280, 0x8C, 0x1E0);
                else sub_B4BC4(0, 0x280, 0, 0x1E0);
                FadeOutPalCycle();
                sub_913B4(bkgd);
                DrawGadgetByType(mode, first, (int)pal, gad, 0, (int)goals);
                sub_B4BC4(0, 0x280, 0, 0x1E0);
                strcpy(name, (char *)recs[1] + 0x1A);
                PrintShadowText(0x74, 0xD2, name);
                sprintf(name, (char *)str_D6, score[1]);
                PrintShadowText(0x118, 0xD2, name);
                strcpy(name, (char *)recs[0] + 0x1A);
                PrintShadowText(0x74, 0x114, name);
                sprintf(name, (char *)str_D6, score[0]);
                PrintShadowText(0x118, 0x114, name);
                y = 0xF3;
                switch (period) {
                case 1: sprintf(name, (char *)str_1st2); break;
                case 2: sprintf(name, (char *)str_2nd2); break;
                case 3: sprintf(name, (char *)str_3rd2); break;
                case 4: sprintf(name, (char *)str_OT); break;
                case 5: sprintf(name, (char *)str_FinalOT); break;
                default: sprintf(name, (char *)str_Final); break;
                }
                if (period < 4) strcat(name, (char *)str_Period);
                PrintShadowText(400, y, name);
                if (sayperiod) {
                    PaElseNhl();
                    sayperiod = 0;
                }
                if (!i) FadePalStep(0, pal, 0x10);
                key = WaitClickTimeout(1000);
            }
        }
        done = -1;
    } else if (mode & 4) {
        /* The extras of each team (line table bytes 28h-2Fh, 64h or more for none). */
        for (side = 0; side < 2; side++) {
            if (side) FadePalStep(1, pal, 0x10);
            sub_B392C(0);
            sub_913B4(bkgd);
            DrawGadgetByType(mode, first, (int)pal, gad, 0, (int)goals);
            sub_913D0(*(int *)(hmcrestbmp[side] + 0x2C), 0x3D, 0x50);
            y = byte_D42C3 + 0x78;
            for (i = 0; i < 8 && !err; i++) {
                k = linetab[side][i + 0x28];
                if (k < 0x64) {
                    err = ReadKeyRec(dbfh, keyrec, ((int (*)[0xBA])dword_DBC7C)[side][k]);
                    if (!err) {
                        FitPlayerName(name, 0, keyrec + 0x13, 200);
                        PrintShadowText(0xB4, y, name);
                        if (hmroster[side * 0x444 + k * 0x27] == 1) PrintShadowText(0x226, y, (char *)str_Injured2);
                    }
                    y += byte_D42C3 + 0xE;
                }
            }
            FadePalStep(0, pal, 0x10);
            key = WaitClickTimeout(1000);
        }
        done = -1;
    }

    if (done != -1) {
        /* Keep the records the mode shows (and every end of period), count the periods and the goals. */
        evbuf = (unsigned char *)sub_8CCA8((char *)str_EVNT, nev * 11 + 1, 0x20);
        nshown = 0;
        i = 0;
        nperiods = 0;
        goals[0] = 0;
        goals[1] = 0;
        do {
            err = ReadGSummaryRec(gsumfh, evbuf + nshown * 11, i);
            if ((evbuf[nshown * 11] == 1 && (mode & 1)) || (evbuf[nshown * 11] == 2 && (mode & 2))
                || (evbuf[nshown * 11] == 4 && (mode & 3))) {
                if (evbuf[nshown * 11] == 4) nperiods++;
                if (evbuf[nshown * 11] == 1) goals[evbuf[nshown * 11 + 1]]++;
                nshown++;
            }
            i++;
        } while (!err && i <= nev);
        prds = (unsigned char **)sub_8CCA8((char *)str_PRDS, nperiods * 4 + 1, 0x20);
        firstpa = 1;
        i = 0;
        j = 0;
        fadein = 1;
        newperiod = 0;
        do {
            if (evbuf[i * 11] == 4) {
                prds[j] = evbuf + i * 11 + 1;
                j++;
            }
            i++;
        } while (i <= nev && j < nperiods);
        if (!(mode & 0x24)) {
            if (mode & 3) {
                DrawGadgetByType(mode, first, (int)pal, gad, nperiods, (int)goals);
                sub_913D0(*(int *)(hmcrestbmp[0] + 0x2C), 0x3D, 0x50);
                sub_913D0(*(int *)(vscrestbmp + 0x2C), 0x221, 0x50);
            } else {
                DrawGadgetByType(mode, first, (int)pal, gad, nperiods, (int)goals);
            }
        }
        i = 0;
        scored = 0;
        penalties = 0;
        while (!err && !done && i < nshown && key < 2) {
            sub_B4BC4(0, 0x280, 0, 0x1E0);
            ev = evbuf + i * 11;
            switch (*ev++) {
            case 1:
                /* A goal: side, scorer, assists (FFh none), flags (2 SH, 4 PP), period, minutes, seconds. */
                pgoals[ev[0]][ev[1]]++;
                if (ev[5] >= first && ev[5] <= last && (mode & 1)) {
                    k = ev[1];
                    err = ReadKeyRec(dbfh, keyrec, RECKEY(ev[0], k));
                    if (!err) {
                        sprintf(name, (char *)str_S3, recs[ev[0]]);
                        PrintShadowText(0x96, y, name);
                        FitPlayerName(name, 0, keyrec + 0x13, 200);
                        err = ReadSeasonRec(seasonfh[ev[0]], srec, *(int *)(keyrec + 0x2C));
                    }
                    if (!err) {
                        n = pgoals[ev[0]][k]
                            + (gameopts.fullot ? *(unsigned short *)(srec + 2) : *(unsigned short *)(srec + 0x14));
                        sprintf(path, (char *)str_D5, n);
                        strcat(name, path);
                        d10 = n % 10;
                        d100 = n % 100;
                        if (d10 == 1 && d100 != 11) strcat(name, (char *)str_St);
                        else if (d10 == 2 && d100 != 12) strcat(name, (char *)str_Nd);
                        else if (d10 == 3 && d100 != 13) strcat(name, (char *)str_Rd);
                        else strcat(name, (char *)str_Th);
                        if (ev[4] & 2) strcat(name, (char *)str_SH);
                        else if (ev[4] & 4) strcat(name, (char *)str_PP);
                        PrintShadowText(0xE6, y, name);
                        scored = 0xFF;
                        sprintf(name, (char *)str_02d02d, ev[6], ev[7]);
                        PrintShadowText(0x20D, y, name);
                        y += byte_D42C3;
                        if (ev[2] != 0xFF) {
                            k = ev[2];
                            err = ReadKeyRec(dbfh, keyrec, RECKEY(ev[0], k));
                            if (!err) {
                                FitPlayerName(path, 0, keyrec + 0x13, 200);
                                sprintf(name, (char *)str_S2, path);
                            }
                            if (ev[3] != 0xFF) {
                                k = ev[3];
                                err = ReadKeyRec(dbfh, keyrec, RECKEY(ev[0], k));
                                if (!err) {
                                    FitPlayerName(path, 0, keyrec + 0x13, 200);
                                    strcat(name, (char *)str_CommaSp);
                                    strcat(name, path);
                                }
                            }
                            if (!err) {
                                strcat(name, (char *)str_RParen2);
                                PrintShadowText(0xE6, y, name);
                            }
                        }
                        y += byte_D42C3;
                    }
                }
                break;
            case 2:
                /* A penalty: side, player, penalty, minutes (FFh a misconduct), period, minutes, seconds. */
                if ((mode & 2) && ev[4] >= first && ev[4] <= last) {
                    sprintf(name, (char *)str_S3, recs[ev[0]]);
                    PrintShadowText(0x91, y, name);
                    k = ev[1];
                    err = ReadKeyRec(dbfh, keyrec, RECKEY(ev[0], k));
                    if (!err) {
                        PrintShadowText(0xDC, y, keyrec + 0x13);
                        sprintf(name, (char *)str_02d02d, ev[5], ev[6]);
                        PrintShadowText(0x229, y, name);
                        y += byte_D42C3;
                        if (ev[3] == 0xFF) sprintf(name, (char *)str_SS4, (char *)penaltynames[ev[2]]);
                        else sprintf(name, (char *)str_DMinS, ev[3], (char *)penaltynames[ev[2]]);
                        PrintShadowText(0xDC, y, name);
                        y += byte_D42C3;
                        penalties = 0xFF;
                    }
                }
                break;
            case 4:
                /* The end of a period: home goals, home shots, visitor goals, visitor shots. */
                pcount++;
                if (pcount >= first && pcount <= last) {
                    y = 0x177;
                    periodend = pageend = -1;
                }
                break;
            }
            i++;
            if (y >= 0x177 - byte_D42C3 || pageend || done || err) {
                /* The page is full, or the period is over: the shots on goal, the announcer, then wait. */
                if (mode & 1) {
                    score[0] = 0;
                    score[1] = 0;
                    shots[0] = 0;
                    shots[1] = 0;
                    for (j = 0; j < period; j++) {
                        score[0] += prds[j][0];
                        score[1] += prds[j][2];
                        shots[0] += prds[j][1];
                        shots[1] += prds[j][3];
                    }
                    sprintf(name, (char *)str_ShotsOnGoal);
                    PrintShadowText((500 - fputchar(name)) / 2 + 0x86, 400, name);
                    y = byte_D42C3 + 400;
                    sprintf(name, (char *)str_SDD, (char *)recs[0] + 0x1A, prds[period - 1][1], shots[0]);
                    PrintShadowText(0x17F - fputchar(name) - 0x1E, y, name);
                    sprintf(name, (char *)str_SDD, (char *)recs[1] + 0x1A, prds[period - 1][3], shots[1]);
                    PrintShadowText(0x1A5, y, name);
                }
                if (!shown && !(mode & 0x24)) {
                    if ((mode & 1) && firstpa) {
                        sayperiod = 0;
                        firstpa = 0;
                        if (gameresult == 1 || first != last) PaScoringPeriod(0, 0, -1);
                        else if (period < 4) PaScoringPeriod(period, 0, 0);
                        else if (period < 7 && goals[0] == goals[1] && schedgameidx >= 0x444)
                            PaScoringPeriod(period - 3, -1, 0);
                        else PaScoringPeriod(0, -1, 0);
                    }
                    shown = 1;
                }
                if (!periodend) {
                    /* Nothing more to show in this period: skip to its end. */
                    for (j = i; evbuf[j * 11] != 4; j++) {
                        if ((evbuf[j * 11] == 1 && (mode & 1)) || (evbuf[j * 11] == 2 && (mode & 2))) {
                            j = i;
                            break;
                        }
                    }
                    i = j;
                    if (evbuf[i * 11] == 4) {
                        periodend = -1;
                        i++;
                    }
                }
                if (!scored && (mode & 1))
                    PrintShadowText((500 - fputchar((char *)str_NoScoring)) / 2 + 0x8C, 0x10B, (char *)str_NoScoring);
                if (!penalties && (mode & 2))
                    PrintShadowText((500 - fputchar((char *)str_NoPenalties)) / 2 + 0x8C, 0x10B, (char *)str_NoPenalties);
                if (period == last && (i == nshown || evbuf[i * 11] == 4)) done = -1;
                if (periodend) {
                    if (period < 5) sayperiod = -1;
                    newperiod = 1;
                    period++;
                }
                periodend = 0;
                scored = 0;
                penalties = 0;
                if (fadein) {
                    FadePalStep(0, pal, 0x10);
                    fadein = 0;
                }
                /* Both arms equal: the EXE's dead `test` / `cmp esi, 4` before the call. */
                key = WaitClickTimeout(((mode & 1) && period < 4) ? 1000 : 1000);
                pageend = 0;
                y = 0xA0;
                if (!done && !err && key < 2 && i < nshown) {
                    /* The next page: a new period fades out first. */
                    if (newperiod) {
                        FadePalette(1, pal, 0x10);
                        fadein = 1;
                        newperiod = 0;
                        sub_B4BC4(0, 0x280, 0x8C, 0x1E0);
                    } else {
                        sub_B4BC4(0x80, 0x280, 0x8C, 0x1E0);
                    }
                    sub_913B4(bkgd);
                    if (mode & 3) {
                        DrawGadgetByType(mode, period, (int)pal, gad, nperiods, (int)goals);
                        sub_913D0(*(int *)(hmcrestbmp[0] + 0x2C), 0x3D, 0x50);
                        sub_913D0(*(int *)(vscrestbmp + 0x2C), 0x221, 0x50);
                    } else {
                        DrawGadgetByType(mode, period, (int)pal, gad, nperiods, (int)goals);
                    }
                    if ((mode & 1) && sayperiod) {
                        sayperiod = 0;
                        if (gameresult != 1 && first == last) {
                            if (period < 4) PaScoringPeriod(period, 0, 0);
                            else if (period < 7 && goals[0] == goals[1] && schedgameidx >= 0x444)
                                PaScoringPeriod(period - 3, -1, 0);
                            else PaScoringPeriod(0, -1, 0);
                        }
                    }
                }
            }
        }
    }

    if (musicon && songdata) sub_8FCDF(musichandle, 3, 100);
    FadePalStep(1, pal, 0x10);
    if (musicon && songdata) {
        while (!sub_8FC8A(musicslot, 3)) ;
        sub_8D2F0(songdata);
        songdata = 0;
    } else {
        StopDigiSample();
    }
    sub_B4BA8();
    sub_B392C(0);
    if (prds) FreeMemBlock((int)prds);
    if (evbuf) FreeMemBlock((int)evbuf);
    FileClose(&seasonfh[1]);
    FileClose(&seasonfh[0]);
    FileClose(&dbfh);
    FileClose(&gsumfh);
    sub_8EA00(state);
    FreeMemBlock(font);
    FreeMemBlock(titlebank);
    FreeMemBlock(bkbank);
    FreeMemBlock(hmcrestbmp[0]);
    FreeMemBlock(vscrestbmp);
    if (smp) sub_8F1FE(smp);
    done = 0;
    if (key == 3) done = 4;
    return done;
}
