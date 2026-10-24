/* Game setup: the game summary pages (scoring, penalties, extras, other games). */
/* DRAFT under Watcom 10.0 GA: 287 differing instructions, 8,061 vs 8,023 bytes.
   Other-game byte reads use their doubled index directly. The player index lives in the frame at 7C4h;
   a saved goal-record pointer survives the season read, and the dead crest local holds the displayed goal
   count (C_MATCHING: dead-local reuse). Left: early crest argument picks, extras / period-pointer loop
   temporaries, and event/page register choices. */
#define GameSummaryScreen GameSummaryScreen_decl
#define ReadGSummaryRec ReadGSummaryRec_decl
#define sub_913D0 sub_913D0_decl
#define sub_8F13B sub_8F13B_decl
#define sub_8F1FE sub_8F1FE_decl
#define sub_8F98F sub_8F98F_decl
#define sub_8FB8E sub_8FB8E_decl
#define gsuminitff gsuminitff_decl
#include "nhl95.h"
#undef gsuminitff
extern int gsuminitff[2];
struct SummaryHandles { int first, second; };
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
#define RECKEY(t, k) (((int *)(f.recs[t] + 0x4C))[k])

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
    /* Retail frame after saving mode: byte locals occupy four-byte slots.
       Keep ev and the drawing temporaries outside the address-taken frame. */
    struct {
        unsigned char recs[2][0x2E8];
        char name[0x54];
        char state[0x40];
        int gad[13];
        char keyrec[0x34];
        signed char pgoals[2][0x19];
        unsigned char pad_pgoals[2];
        unsigned char srec[0x30];
        char path[0x10];
        unsigned char gsum[0xB];
        unsigned char pad_gsum;
        unsigned char *linetab[2];
        int seasonfh[2];
        int gsumfh;
        int dbfh;
        int teamfh;
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
        unsigned char pad_shots[2];
        unsigned char goals[2];
        unsigned char pad_goals[2];
        unsigned char score[2];
        unsigned char pad_score[2];
        unsigned char home;
        unsigned char pad_home[3];
        unsigned char period;
        unsigned char pad_period[3];
        unsigned char last;
        unsigned char pad_last[3];
        unsigned char first;
        unsigned char pad_first[3];
        unsigned char vis;
        unsigned char pad_vis[3];
        unsigned char penalties;
        unsigned char pad_penalties[3];
        unsigned char scored;
        unsigned char pad_scored[3];
        unsigned char pcount;
        unsigned char pad_pcount[3];
    } f;
    int homeScore;
    int bank;
    int crest;
    int side;
    int y;
    int j;
    int n;
    int d10;
    int d100;
    unsigned char *ev;
    unsigned char *goal;

    f.first = first;
    f.last = last;
    f.teamfh = -1;
    f.dbfh = -1;
    *(struct SummaryHandles *)f.seasonfh = *(struct SummaryHandles *)gsuminitff;
    f.gsumfh = -1;
    sub_1BAF3(700000);
    if (musicon && songdata) {
        sub_8FCDF(musichandle, 3, 0x4B);
        while (!sub_8FC8A(musicslot, 3)) ;
        sub_8D2F0(songdata);
        songdata = 0;
    }
    ClearInputQueue();
    f.i = 0;
    do {
        for (side = 0; side < 0x19; side++) ((signed char *)f.pgoals)[f.i + ((f.i << 2) - f.i) * 8 + side] = 0;
        f.i++;
    } while (f.i < 2);
    f.prds = 0;
    f.evbuf = 0;
    PaOpenBank();
    f.shown = 0;
    f.key = 0;
    f.periodend = 0;
    f.pageend = 0;
    f.done = 0;
    f.sayperiod = -1;
    f.period = f.first;
    f.pcount = 0;
    f.i = 0;
    do {
        n = f.i;
        f.shots[n] = 0;
        f.score[n] = 0;
        f.i = n + 1;
    } while (f.i < 2);
    sub_B4BA8();
    sub_8E9E8(f.state);
    MakePath(f.name, fileoncd[0x21A] == 1 ? (char *)cddriveptr : 0, (char *)str_Indus0302, (char *)str_VFN);
    f.font = sub_8E8A0(f.name, 0x20);
    sub_8EA18(f.font);

    /* The crests, each copied into its own bitmap. */
    MakePath(f.path, fileoncd[0x59] == 1 ? (char *)cddriveptr : 0, (char *)str_Ctlogo2, 0);
    bank = sub_8E83C(f.path, 0);
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
    MakePath(f.path, fileoncd[0x58] == 1 ? (char *)cddriveptr : 0, (char *)str_Ctbkgd2, 0);
    f.bkbank = bank = sub_8E83C(f.path, 0);
    f.bkgd = sub_B30B4(bank, (char *)str_Bkgd5);
    f.pal = (unsigned char *)sub_B30B4(bank, (char *)str_Pal13) + 0x10;
    if (mode & 3) {
        MakePath(f.path, fileoncd[0x5B] == 1 ? (char *)cddriveptr : 0, (char *)str_Cttitle2, 0);
        f.titlebank = bank = sub_8E83C(f.path, 0);
        f.gad[8] = sub_B30B4(bank, (char *)str_Summ2);
        f.gad[2] = sub_B30B4(bank, (char *)str_OtShape);
        f.gad[4] = sub_B30B4(bank, (char *)str_Per1);
        f.gad[5] = sub_B30B4(bank, (char *)str_Per2);
        f.gad[6] = sub_B30B4(bank, (char *)str_Per3);
        f.gad[10] = sub_B30B4(bank, (char *)str_Top2);
    } else if (mode & 0x1C) {
        MakePath(f.path, fileoncd[0x5A] == 1 ? (char *)cddriveptr : 0, (char *)str_Cttitle12, 0);
        f.titlebank = bank = sub_8E83C(f.path, 0);
        f.gad[0] = sub_B30B4(bank, (char *)str_Def2);
        f.gad[1] = sub_B30B4(bank, (char *)str_Fowa2);
        f.gad[7] = sub_B30B4(bank, (char *)str_Scra2);
        f.gad[9] = sub_B30B4(bank, (char *)str_Tlu2);
        f.gad[10] = sub_B30B4(bank, (char *)str_Top2);
    } else if (mode & 0x20) {
        MakePath(f.path, fileoncd[0x5C] == 1 ? (char *)cddriveptr : 0, (char *)str_Cttitle3, 0);
        f.titlebank = bank = sub_8E83C(f.path, 0);
        f.gad[3] = sub_B30B4(bank, (char *)str_Ots);
        f.gad[11] = sub_B30B4(bank, (char *)str_Colm);
    }
    SetTextColors(0x40, 0);

    /* The summary header (f.home, visitor, the record count), the team records and the databases. */
    MakePath(f.name, (char *)&curleague, (char *)str_Gsummary2, (char *)str_extDB);
    f.err = FileOpenRead(f.name, &f.gsumfh);
    if (!f.err) f.err = ReadGSummaryRec(f.gsumfh, f.gsum, 0);
    if (!(mode & 0x20)) {
        if (!f.err) {
            f.nev = *(short *)(f.gsum + 5);
            f.home = f.gsum[3];
            f.vis = f.gsum[4];
            MakePath(f.name, (char *)&curleague, (char *)leaguedbnames[4], (char *)str_extDB);
            f.err = FileOpenRead(f.name, &f.teamfh);
        }
        if (!f.err) f.err = ReadTeamRec(f.teamfh, f.recs[0], f.home);
        if (!f.err) f.err = ReadTeamRec(f.teamfh, f.recs[1], f.vis);
        FileClose(&f.teamfh);
    }
    if (!f.err) {
        MakePath(f.name, (char *)&curleague, (char *)leaguedbnames[0], (char *)str_extDB);
        f.err = FileOpenRead(f.name, &f.dbfh);
    }
    if (!f.err) {
        strcpy(f.path, (char *)leaguedbnames[5]);
        sprintf(f.name, (char *)&leaguedbfmt, f.path);
        f.err = FileOpenRW(f.name, &f.seasonfh[0]);
    }
    if (!f.err) {
        strcpy(f.path, (char *)leaguedbnames[5]);
        sprintf(f.name, (char *)&leaguedbfmt2, f.path);
        f.err = FileOpenRW(f.name, &f.seasonfh[1]);
    }
    y = (mode & 0x1C) ? 0xA0 : 0xA0;    /* both arms equal: the EXE's lone `test byte [esp], 1Ch` */
    f.smp = 0;

    /* The GAMESUM song, or the summary sample. */
    if (!(mode & 0x20)) {
        FadeOutPalCycle();
        if (musicon && !songdata) {
            MakePath(f.name, fileoncd[0x1E4] == 1 ? (char *)cddriveptr : 0, (char *)str_Gamesum, (char *)str_Iff6);
            songdata = sub_8F98F(f.name);
            if (songdata && gameopts.music) sub_8FB8E(songdata, musichandle, 3, 0x4C);
        } else {
            if (sounddev == 8) MakePath(f.name, fileoncd[0x102] == 1 ? (char *)cddriveptr : 0, (char *)str_Mtsum, 0);
            else MakePath(f.name, fileoncd[0x21] == 1 ? (char *)cddriveptr : 0, (char *)str_Adsum, 0);
            dword_CCC94 = 0x20;
            f.smp = sub_8F13B(f.name);
            dword_CCC94 = 0;
            PlayDigiSample(f.smp);
        }
    }
    ClearInputQueue();
    joyq_flush();
    f.linetab[0] = hmlinetab;
    f.linetab[1] = awlinetab;
    if (!(mode & 0x24)) {
        sub_913B4(f.bkgd);
        if (mode & 3) {
            DrawGadgetByType(mode, f.first, (int)f.pal, f.gad, 0, (int)f.goals);
            sub_913D0(*(int *)(hmcrestbmp[0] + 0x2C), 0x3D, 0x50);
            sub_913D0(*(int *)(vscrestbmp + 0x2C), 0x221, 0x50);
        } else {
            DrawGadgetByType(mode, f.first, (int)f.pal, f.gad, 0, (int)f.goals);
        }
    } else if (mode & 0x20) {
        /* The other games: one page each. */
        for (f.i = 0; f.i < 6 && f.key < 2 && !f.err; f.i++) {
            f.home = othergames[f.i * 2];
            f.vis = othergamesb[f.i * 2];
            f.period = otherperiod[f.i];
            f.score[0] = otherscores[f.i * 2];
            f.score[1] = otherscoresb[f.i * 2];
            if (!f.err) {
                MakePath(f.name, (char *)&curleague, (char *)leaguedbnames[4], (char *)str_extDB);
                f.err = FileOpenRead(f.name, &f.teamfh);
            }
            if (!f.err) f.err = ReadTeamRec(f.teamfh, f.recs[0], f.home);
            if (!f.err) f.err = ReadTeamRec(f.teamfh, f.recs[1], f.vis);
            FileClose(&f.teamfh);
            if (!f.err) {
                if (f.i) sub_B4BC4(0x72, 0x280, 0x8C, 0x1E0);
                else sub_B4BC4(0, 0x280, 0, 0x1E0);
                FadeOutPalCycle();
                sub_913B4(f.bkgd);
                DrawGadgetByType(mode, f.first, (int)f.pal, f.gad, 0, (int)f.goals);
                sub_B4BC4(0, 0x280, 0, 0x1E0);
                strcpy(f.name, (char *)f.recs[1] + 0x1A);
                PrintShadowText(0x74, 0xD2, f.name);
                sprintf(f.name, (char *)str_D6, f.score[1]);
                PrintShadowText(0x118, 0xD2, f.name);
                strcpy(f.name, (char *)f.recs[0] + 0x1A);
                PrintShadowText(0x74, 0x114, f.name);
                sprintf(f.name, (char *)str_D6, f.score[0]);
                PrintShadowText(0x118, 0x114, f.name);
                y = 0xF3;
                switch (f.period) {
                case 1: sprintf(f.name, (char *)str_1st2); break;
                case 2: sprintf(f.name, (char *)str_2nd2); break;
                case 3: sprintf(f.name, (char *)str_3rd2); break;
                case 4: sprintf(f.name, (char *)str_OT); break;
                case 5: sprintf(f.name, (char *)str_FinalOT); break;
                default: sprintf(f.name, (char *)str_Final); break;
                }
                if (f.period < 4) strcat(f.name, (char *)str_Period);
                PrintShadowText(400, y, f.name);
                if (f.sayperiod) {
                    PaElseNhl();
                    f.sayperiod = 0;
                }
                if (!f.i) FadePalStep(0, f.pal, 0x10);
                f.key = WaitClickTimeout(1000);
            }
        }
        f.done = -1;
    } else if (mode & 4) {
        /* The extras of each team (line table bytes 28h-2Fh, 64h or more for none). */
        for (side = 0; side < 2; side++) {
            if (side) FadePalStep(1, f.pal, 0x10);
            sub_B392C(0);
            sub_913B4(f.bkgd);
            DrawGadgetByType(mode, f.first, (int)f.pal, f.gad, 0, (int)f.goals);
            sub_913D0(*(int *)(hmcrestbmp[side] + 0x2C), 0x3D, 0x50);
            y = byte_D42C3 + 0x78;
            for (f.i = 0; f.i < 8 && !f.err; f.i++) {
                f.k = f.linetab[side][f.i + 0x28];
                if (f.k < 0x64) {
                    f.err = ReadKeyRec(f.dbfh, f.keyrec, ((int (*)[0xBA])dword_DBC7C)[side][f.k]);
                    if (!f.err) {
                        FitPlayerName(f.name, 0, f.keyrec + 0x13, 200);
                        PrintShadowText(0xB4, y, f.name);
                        if (hmroster[f.k * 0x27 + side * 0x444] == 1) PrintShadowText(0x226, y, (char *)str_Injured2);
                    }
                    y += byte_D42C3 + 0xE;
                }
            }
            FadePalStep(0, f.pal, 0x10);
            f.key = WaitClickTimeout(1000);
        }
        f.done = -1;
    }

    if (f.done != -1) {
        /* Keep the records the mode shows (and every end of f.period), count the periods and the f.goals. */
        f.evbuf = (unsigned char *)sub_8CCA8((char *)str_EVNT, ((f.nev * 4 - f.nev) * 4 - f.nev) + 1, 0x20);
        f.nshown = 0;
        f.i = 0;
        f.nperiods = 0;
        f.goals[0] = 0;
        f.goals[1] = 0;
        do {
            ev = f.evbuf + ((f.nshown * 4 - f.nshown) * 4 - f.nshown);
            f.err = ReadGSummaryRec(f.gsumfh, ev, f.i);
            if ((ev[0] == 1 && (mode & 1)) || (f.evbuf[((f.nshown * 4 - f.nshown) * 4 - f.nshown)] == 2 && (mode & 2))
                || (f.evbuf[((f.nshown * 4 - f.nshown) * 4 - f.nshown)] == 4 && (mode & 3))) {
                if (f.evbuf[((f.nshown * 4 - f.nshown) * 4 - f.nshown)] == 4) f.nperiods++;
                if (f.evbuf[((f.nshown * 4 - f.nshown) * 4 - f.nshown)] == 1) f.goals[f.evbuf[((f.nshown * 4 - f.nshown) * 4 - f.nshown) + 1]]++;
                f.nshown++;
            }
            f.i++;
        } while (!f.err && f.i <= f.nev);
        f.prds = (unsigned char **)sub_8CCA8((char *)str_PRDS, f.nperiods * 4 + 1, 0x20);
        f.firstpa = 1;
        f.i = 0;
        j = 0;
        f.fadein = 1;
        f.newperiod = 0;
        do {
            if (f.evbuf[((f.i * 4 - f.i) * 4 - f.i)] == 4) {
                f.prds[j] = f.evbuf + ((f.i * 4 - f.i) * 4 - f.i) + 1;
                j++;
            }
            f.i++;
        } while (f.i <= f.nev && j < f.nperiods);
        if (!(mode & 0x24)) {
            if (mode & 3) {
                DrawGadgetByType(mode, f.first, (int)f.pal, f.gad, f.nperiods, (int)f.goals);
                sub_913D0(*(int *)(hmcrestbmp[0] + 0x2C), 0x3D, 0x50);
                sub_913D0(*(int *)(vscrestbmp + 0x2C), 0x221, 0x50);
            } else {
                DrawGadgetByType(mode, f.first, (int)f.pal, f.gad, f.nperiods, (int)f.goals);
            }
        }
        f.i = f.scored = 0;
        f.penalties = 0;
        while (!f.err && !f.done && f.i < f.nshown && f.key < 2) {
            sub_B4BC4(0, 0x280, 0, 0x1E0);
            ev = f.evbuf + ((f.i * 4 - f.i) * 4 - f.i);
            switch (*ev++) {
            case 1:
                /* A goal: side, scorer, assists (FFh none), flags (2 SH, 4 PP), f.period, minutes, seconds. */
                goal = ev;
                f.pgoals[ev[0]][ev[1]]++;
                if (ev[5] >= f.first && ev[5] <= f.last && (mode & 1)) {
                    f.k = ev[1];
                    f.err = ReadKeyRec(f.dbfh, f.keyrec, RECKEY(ev[0], f.k));
                    if (!f.err) {
                        sprintf(f.name, (char *)str_S3, f.recs[ev[0]]);
                        PrintShadowText(0x96, y, f.name);
                        FitPlayerName(f.name, 0, f.keyrec + 0x13, 200);
                        f.err = ReadSeasonRec(f.seasonfh[ev[0]], f.srec, *(int *)(f.keyrec + 0x2C));
                    }
                    if (!f.err) {
                        crest = f.pgoals[goal[0]][f.k];
                        crest += gameopts.fullot ? *(unsigned short *)(f.srec + 2) : *(unsigned short *)(f.srec + 0x14);
                        sprintf(f.path, (char *)str_D5, crest);
                        strcat(f.name, f.path);
                        d10 = crest % 10;
                        d100 = crest % 100;
                        if (d10 == 1 && d100 != 11) strcat(f.name, (char *)str_St);
                        else if (d10 == 2 && d100 != 12) strcat(f.name, (char *)str_Nd);
                        else if (d10 == 3 && d100 != 13) strcat(f.name, (char *)str_Rd);
                        else strcat(f.name, (char *)str_Th);
                        if (goal[4] & 2) strcat(f.name, (char *)str_SH);
                        else if (goal[4] & 4) strcat(f.name, (char *)str_PP);
                        PrintShadowText(0xE6, y, f.name);
                        f.scored = 0xFF;
                        sprintf(f.name, (char *)str_02d02d, goal[6], goal[7]);
                        PrintShadowText(0x20D, y, f.name);
                        y += byte_D42C3;
                        if (goal[2] != 0xFF) {
                            f.k = goal[2];
                            f.err = ReadKeyRec(f.dbfh, f.keyrec, RECKEY(goal[0], f.k));
                            if (!f.err) {
                                FitPlayerName(f.path, 0, f.keyrec + 0x13, 200);
                                sprintf(f.name, (char *)str_S2, f.path);
                            }
                            if (goal[3] != 0xFF) {
                                f.k = goal[3];
                                f.err = ReadKeyRec(f.dbfh, f.keyrec, RECKEY(goal[0], f.k));
                                if (!f.err) {
                                    FitPlayerName(f.path, 0, f.keyrec + 0x13, 200);
                                    strcat(f.name, (char *)str_CommaSp);
                                    strcat(f.name, f.path);
                                }
                            }
                            if (!f.err) {
                                strcat(f.name, (char *)str_RParen2);
                                PrintShadowText(0xE6, y, f.name);
                            }
                        }
                        y += byte_D42C3;
                    }
                }
                break;
            case 2:
                /* A penalty: side, player, penalty, minutes (FFh a misconduct), f.period, minutes, seconds. */
                if ((mode & 2) && ev[4] >= f.first && ev[4] <= f.last) {
                    sprintf(f.name, (char *)str_S3, f.recs[ev[0]]);
                    PrintShadowText(0x91, y, f.name);
                    f.k = ev[1];
                    f.err = ReadKeyRec(f.dbfh, f.keyrec, RECKEY(ev[0], f.k));
                    if (!f.err) {
                        PrintShadowText(0xDC, y, f.keyrec + 0x13);
                        sprintf(f.name, (char *)str_02d02d, ev[5], ev[6]);
                        PrintShadowText(0x229, y, f.name);
                        y += byte_D42C3;
                        if (ev[3] == 0xFF) sprintf(f.name, (char *)str_SS4, (char *)penaltynames[ev[2]]);
                        else sprintf(f.name, (char *)str_DMinS, ev[3], (char *)penaltynames[ev[2]]);
                        PrintShadowText(0xDC, y, f.name);
                        y += byte_D42C3;
                        f.penalties = 0xFF;
                    }
                }
                break;
            case 4:
                /* The end of a f.period: f.home f.goals, f.home f.shots, visitor f.goals, visitor f.shots. */
                f.pcount++;
                if (f.pcount >= f.first && f.pcount <= f.last) {
                    y = 0x177;
                    f.periodend = f.pageend = -1;
                }
                break;
            }
            f.i++;
            if (y >= 0x177 - byte_D42C3 || f.pageend || f.done || f.err) {
                /* The page is full, or the f.period is over: the f.shots on goal, the announcer, then wait. */
                if (mode & 1) {
                    f.score[0] = 0;
                    f.score[1] = 0;
                    f.shots[0] = 0;
                    f.shots[1] = 0;
                    for (j = 0; j < f.period; j++) {
                        f.score[0] += f.prds[j][0];
                        f.score[1] += f.prds[j][2];
                        f.shots[0] += f.prds[j][1];
                        f.shots[1] += f.prds[j][3];
                    }
                    sprintf(f.name, (char *)str_ShotsOnGoal);
                    PrintShadowText((500 - fputchar(f.name)) / 2 + 0x86, 400, f.name);
                    y = byte_D42C3 + 400;
                    sprintf(f.name, (char *)str_SDD, (char *)f.recs[0] + 0x1A, f.prds[f.period - 1][1], f.shots[0]);
                    PrintShadowText(0x17F - fputchar(f.name) - 0x1E, y, f.name);
                    sprintf(f.name, (char *)str_SDD, (char *)f.recs[1] + 0x1A, f.prds[f.period - 1][3], f.shots[1]);
                    PrintShadowText(0x1A5, y, f.name);
                }
                if (!f.shown && !(mode & 0x24)) {
                    if ((mode & 1) && f.firstpa) {
                        f.sayperiod = 0;
                        f.firstpa = 0;
                        if (gameresult == 1 || f.first != f.last) PaScoringPeriod(0, 0, -1);
                        else if (f.period < 4) PaScoringPeriod(f.period, 0, 0);
                        else if (f.period < 7 && f.goals[0] == f.goals[1] && schedgameidx >= 0x444)
                            PaScoringPeriod(f.period - 3, -1, 0);
                        else PaScoringPeriod(0, -1, 0);
                    }
                    f.shown = 1;
                }
                if (!f.periodend) {
                    /* Nothing more to show in this f.period: skip to its end. */
                    for (j = f.i; f.evbuf[j * 11] != 4; j++) {
                        if ((f.evbuf[j * 11] == 1 && (mode & 1)) || (f.evbuf[j * 11] == 2 && (mode & 2))) {
                            j = f.i;
                            break;
                        }
                    }
                    f.i = j;
                    if (f.evbuf[((f.i * 4 - f.i) * 4 - f.i)] == 4) {
                        f.periodend = -1;
                        f.i++;
                    }
                }
                if (!f.scored && (mode & 1))
                    PrintShadowText((500 - fputchar((char *)str_NoScoring)) / 2 + 0x8C, 0x10B, (char *)str_NoScoring);
                if (!f.penalties && (mode & 2))
                    PrintShadowText((500 - fputchar((char *)str_NoPenalties)) / 2 + 0x8C, 0x10B, (char *)str_NoPenalties);
                if (f.period == f.last && (f.i == f.nshown || f.evbuf[((f.i * 4 - f.i) * 4 - f.i)] == 4)) f.done = -1;
                if (f.periodend) {
                    if (f.period < 5) f.sayperiod = -1;
                    f.newperiod = 1;
                    f.period++;
                }
                f.periodend = 0;
                f.scored = 0;
                f.penalties = 0;
                if (f.fadein) {
                    FadePalStep(0, f.pal, 0x10);
                    f.fadein = 0;
                }
                /* Both arms equal: the EXE's dead `test` / `cmp esi, 4` before the call. */
                f.key = WaitClickTimeout(((mode & 1) && f.period < 4) ? 1000 : 1000);
                f.pageend = 0;
                y = 0xA0;
                if (!f.done && !f.err && f.key < 2 && f.i < f.nshown) {
                    /* The next page: a new f.period fades out f.first. */
                    if (f.newperiod) {
                        FadePalette(1, f.pal, 0x10);
                        f.fadein = 1;
                        f.newperiod = 0;
                        sub_B4BC4(0, 0x280, 0x8C, 0x1E0);
                    } else {
                        sub_B4BC4(0x80, 0x280, 0x8C, 0x1E0);
                    }
                    sub_913B4(f.bkgd);
                    if (mode & 3) {
                        DrawGadgetByType(mode, f.period, (int)f.pal, f.gad, f.nperiods, (int)f.goals);
                        sub_913D0(*(int *)(hmcrestbmp[0] + 0x2C), 0x3D, 0x50);
                        sub_913D0(*(int *)(vscrestbmp + 0x2C), 0x221, 0x50);
                    } else {
                        DrawGadgetByType(mode, f.period, (int)f.pal, f.gad, f.nperiods, (int)f.goals);
                    }
                    if ((mode & 1) && f.sayperiod) {
                        f.sayperiod = 0;
                        if (gameresult != 1 && f.first == f.last) {
                            if (f.period < 4) PaScoringPeriod(f.period, 0, 0);
                            else if (f.period < 7 && f.goals[0] == f.goals[1] && schedgameidx >= 0x444)
                                PaScoringPeriod(f.period - 3, -1, 0);
                            else PaScoringPeriod(0, -1, 0);
                        }
                    }
                }
            }
        }
    }

    if (musicon && songdata) sub_8FCDF(musichandle, 3, 100);
    FadePalStep(1, f.pal, 0x10);
    if (musicon && songdata) {
        while (!sub_8FC8A(musicslot, 3)) ;
        sub_8D2F0(songdata);
        songdata = 0;
    } else {
        StopDigiSample();
    }
    sub_B4BA8();
    sub_B392C(0);
    if (f.prds) FreeMemBlock((int)f.prds);
    if (f.evbuf) FreeMemBlock((int)f.evbuf);
    FileClose(&f.seasonfh[1]);
    FileClose(&f.seasonfh[0]);
    FileClose(&f.dbfh);
    FileClose(&f.gsumfh);
    sub_8EA00(f.state);
    FreeMemBlock(f.font);
    FreeMemBlock(f.titlebank);
    FreeMemBlock(f.bkbank);
    FreeMemBlock(hmcrestbmp[0]);
    FreeMemBlock(vscrestbmp);
    if (f.smp) sub_8F1FE(f.smp);
    f.done = 0;
    if (f.key == 3) f.done = 4;
    return f.done;
}
