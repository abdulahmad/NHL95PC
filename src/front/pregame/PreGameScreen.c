/* Arena logos: the pre-game scouting report. */
#define PreGameScreen PreGameScreen_decl
#define TonightsGameScreen TonightsGameScreen_decl
#define sub_8F98F sub_8F98F_decl
#define sub_8FB8E sub_8FB8E_decl
#define MusicChanReset2 MusicChanReset2_decl
#include "nhl95.h"
#undef PreGameScreen
#undef TonightsGameScreen
#undef sub_8F98F
#undef sub_8FB8E
#undef MusicChanReset2

typedef struct { char c[17]; } ArtHdr17;

int PreGameScreen(unsigned char home, unsigned char away);
int TonightsGameScreen(int home, int away);
int sub_8F98F(char *path);
void sub_8FB8E(int song, int handle, int a, int b);
void MusicChanReset2(void);

/* PreGameScreen (29F28, PC only): the scouting report before a game. Read both teams' records from the league
   database, fade out (and stop the music), draw the ARENA rink, both crests (SRLOGO), "<away> at <home>" and the
   nine scouting categories (scoutcatnames) with each team's rating, the higher one highlighted, then the buttons
   (away lines, play, cancel, home lines; without off_CEF43 / off_CEF63 the line buttons are left out), start the
   SCOUTING song and the announcer's introduction (PaTonightIntro, or PaPlayoffTonight with the game, the
   conference pairing and the round in the playoffs) and run the pointer until play or cancel. The line buttons
   open the game line editor for a team a human controls. Then fade out, wait for the announcer and, unless
   cancelled, show tonight's game (TonightsGameScreen) and preload the team clips. home, away: the teams. Result:
   4 when cancelled (or TonightsGameScreen returned 3), else 0. */
int PreGameScreen(unsigned char home, unsigned char away)
{
    Button *buttons;
    int btn;
    unsigned char recs[2][0x2E8];
    char state[0x40];
    unsigned char tm[2];
    unsigned char *p1;
    int mf;
    int done;
    int ptrbg;
    unsigned char *apal;
    int key;
    unsigned char *p0;
    int nb;
    char path[0x20];
    unsigned char i;
    int err;
    unsigned char *pal;
    int kf;
    int bank;
    int art;
    int k;
    struct {
        int mx;
        int my;
        int fh;
    } io;
    int y;
    int lc;
    int rc;
    int ct;
    int r;
    unsigned char *ev;
    int sel;
    int scr;
    int oldmy;
    int oldmx;
    int pointer_size;

    io.fh = -1;
    PaOpenBank();
    SetDialogColors(0xF9, 0xFA, 0xF8, 0xFA, 0xF7);
    SetTextColors(0xFA, 0xF7);
    apal = (unsigned char *)sub_8CCA8((char *)str_Apal, 0x300, 0x20);
    tm[0] = home;
    tm[1] = away;
    MakePath(path, (char *)&curleague, (char *)leaguedbnames[4], (char *)str_extDB);
    err = FileOpenRead(path, &io.fh);
    for (i = 0; i < 2 && !err; i++) err = ReadTeamRec(io.fh, recs[i], tm[i]);
    FileClose(&io.fh);
    sub_B4BA8();
    pal = (unsigned char *)sub_8CCA8((char *)str_Pal10, 0x300, 0x20);
    if (musicon && songdata) sub_8FCDF(musichandle, 3, 0x64);
    sub_8FFB0(0, 0x100, pal);
    FadePalStep(1, pal, 0x10);
    FreeMemBlock((int)pal);
    if (musicon && songdata) {
        while (!sub_8FC8A(musicslot, 3));
        sub_8D2F0(songdata);
        songdata = 0;
    }
    kf = kaufmfont;
    mf = mainfont;
    sub_8E9E8(state);
    sub_8EA18(mf);
    MakePath(path, fileoncd[0x27] == 1 ? (char *)cddriveptr : 0, (char *)str_Arena, 0);
    bank = sub_8E83C(path, 0);
    memcpy(apal, (unsigned char *)sub_B30B4(bank, (char *)str_Pal11) + 0x10, 0x300);
    art = sub_B30B4(bank, (char *)str_Rink);
    sub_B4BC4(0, 0x280, 0, 0x1E0);
    sub_9061C(art);
    FreeMemBlock(bank);
    MakePath(path, fileoncd[0x219] == 1 ? (char *)cddriveptr : 0, (char *)str_Srlogo, 0);
    bank = sub_8E83C(path, 0);
    art = sub_B30B4(bank, (char *)crestnames[away]);
    sub_91370(art, 0x3C, 0x6D);
    art = sub_B30B4(bank, (char *)crestnames[home]);
    sub_91370(art, 0x1E5, 0x6D);
    FreeMemBlock(bank);
    sub_8EA18(kf);
    sprintf(path, (char *)str_SAtS, recs[1] + 0x1A, recs[0] + 0x1A);
    PrintOutlinedText((0x280 - fputchar(path)) / 2, 0x93, path);
    sub_90D20(0x6E, 0xCF, 0x1AE, 5, boxfillcolor);
    sub_B4FAC(0x6E, 0xCF, 0x21C, 0xCF, boxlitecolor);
    sub_B4FAC(0x6E, 0xD3, 0x21C, 0xD3, boxshadecolor);
    for (k = 0; k < 9; k++) {
        y = (byte_D42C3 + 3) * k + 0xDA;
        if (k == 8) {
            sub_90D20(0x6E, y + 5, 0x1AE, 5, boxfillcolor);
            y += 0xE;
            sub_B4FAC(0x6E, y - 9, 0x21C, y - 9, boxlitecolor);
            sub_B4FAC(0x6E, y - 5, 0x21C, y - 5, boxshadecolor);
        }
        PrintOutlinedText((0x280 - fputchar((char *)scoutcatnames[k])) / 2, y, (char *)scoutcatnames[k]);
    }
    p1 = recs[1] + 0x2DC;
    p0 = recs[0] + 0x2DC;
    for (k = 0; k < 9; k++) {
        lc = 0xFA;
        rc = 0xFA;
        if (p1[scoutcatidx[k]] > p0[scoutcatidx[k]]) lc = 0xFD;
        else if (p1[scoutcatidx[k]] < p0[scoutcatidx[k]]) rc = 0xFD;
        y = (byte_D42C3 + 3) * k + 0xDA;
        if (k == 8) y += 0xC;
        SetTextColors(lc, 0xF7);
        sprintf(path, (char *)str_D4, p1[scoutcatidx[k]]);
        PrintOutlinedText(0x6E, y, path);
        SetTextColors(rc, 0xF7);
        sprintf(path, (char *)str_D4, p0[scoutcatidx[k]]);
        PrintOutlinedText(0x212, y, path);
    }
    SetTextColors(0xFA, 0xF7);
    sub_8EA18(mf);
    if (!off_CEF43 && !off_CEF63) {
        nb = 2;
        buttons = (Button *)pregamebuttons + 1;
    } else if (!off_CEF43) {
        nb = 3;
        buttons = (Button *)pregamebuttons;
    } else if (!off_CEF63) {
        nb = 3;
        buttons = (Button *)pregamebuttons + 1;
    } else {
        nb = 4;
        buttons = (Button *)pregamebuttons;
    }
    DrawBevelBox(0, 0x1AE, 0x26B, 0x1DF, 1);
    DrawButtons(buttons, nb);
    pointer_size = (*(short *)(pointerspr + 4) + 1) * (*(short *)(pointerspr + 6) + 1) + 0x11;
    ptrbg = sub_8CCA8((char *)str_Pointer4, pointer_size, 0x20);
    *(ArtHdr17 *)ptrbg = *(ArtHdr17 *)pointerspr;
    *(short *)(ptrbg + 4) = *(short *)(pointerspr + 4) + 1;
    *(short *)(ptrbg + 6) = *(short *)(pointerspr + 6) + 1;
    oldmx = 0;
    io.mx = 0;
    oldmy = 0;
    io.my = 0;
    sub_B2E1B(0, 0, 0x280, 0x1E0);
    MouseSetPos(io.mx, io.my);
    sub_91400(ptrbg, 0, 0);
    sub_91370(pointerspr, 0, 0);
    ClearInputQueue();
    if (musicon && !songdata) {
        MakePath(path, fileoncd[0x1E3] == 1 ? (char *)cddriveptr : 0, (char *)str_Scouting, (char *)str_Iff4);
        songdata = sub_8F98F(path);
        if (songdata && gameopts.music) sub_8FB8E(songdata, musichandle, 3, 0x4C);
    }
    FadePalStep(0, apal, 0x10);
    if (schedgameidx < 0x444)
        PaTonightIntro(home, away);
    else {
        if (teamconf[home] != teamconf[away]) ct = 3;
        else ct = (teamconf[home] | teamconf[away]) % 2 + 1;
        r = 1;
        if (schedgameidx >= 0x47C) r = 2;
        if (schedgameidx >= 0x498) r = 3;
        PaPlayoffTonight(home, away, (schedgameidx - 0x444) % 7 + 1, ct, r);
    }
    done = 0;
    key = 0;
    do {
        btn = 0;
        do {
            ev = GetInputEvent();
            if (ev) btn = ((int (*)(unsigned char *, int *, int *))ptrupdatefn)(ev, &io.mx, &io.my);
        } while (ev && !(btn & 6));
        if (!btn) {
            if (oldmx != io.mx || oldmy != io.my) {
                sub_903F0(ptrbg, oldmx, oldmy);
                sub_91400(ptrbg, io.mx, io.my);
                sub_91370(pointerspr, io.mx, io.my);
                oldmx = io.mx;
                oldmy = io.my;
            }
        } else if (btn & 4) {
            done = -1;
            key = 3;
        } else {
            sub_903F0(ptrbg, oldmx, oldmy);
            sel = TrackButtons((int *)buttons, nb, io.mx, io.my, btn);
            if (sel >= 0) {
                if (!off_CEF63) sel++;
                switch (sel) {
                case 0:
                    if (VisTeam == ctl1team[0] || VisTeam == ctl2team) {
                        scr = sub_8CCA8((char *)str_Screen, 0x4B011, 0x20);
                        *(ArtHdr17 *)scr = *(ArtHdr17 *)pointerspr;
                        *(short *)(scr + 4) = 0x280;
                        *(short *)(scr + 6) = 0x1E0;
                        sub_91400(scr, 0, 0);
                        GameLineEditor(1, awlinetab, unk_CF1AF, 3);
                        pal = (unsigned char *)sub_8CCA8((char *)str_Pal10, 0x300, 0x20);
                        sub_8FFB0(0, 0x100, pal);
                        FadePalStep(1, pal, 0x10);
                        FreeMemBlock((int)pal);
                        sub_903F0(scr, 0, 0);
                        FreeMemBlock(scr);
                        FadePalStep(0, apal, 0x10);
                        SetTextColors(0xFA, 0xF7);
                    }
                    break;
                case 1:
                    done = -1;
                    break;
                case 2:
                    done = -1;
                    key = 3;
                    break;
                case 3:
                    if (HomeTeam == ctl1team[0] || HomeTeam == ctl2team) {
                        scr = sub_8CCA8((char *)str_Screen, 0x4B011, 0x20);
                        *(ArtHdr17 *)scr = *(ArtHdr17 *)pointerspr;
                        *(short *)(scr + 4) = 0x280;
                        *(short *)(scr + 6) = 0x1E0;
                        sub_91400(scr, 0, 0);
                        GameLineEditor(0, hmlinetab, unk_CF1AF, 3);
                        pal = (unsigned char *)sub_8CCA8((char *)str_Pal10, 0x300, 0x20);
                        sub_8FFB0(0, 0x100, pal);
                        FadePalStep(1, pal, 0x10);
                        FreeMemBlock((int)pal);
                        sub_903F0(scr, 0, 0);
                        FreeMemBlock(scr);
                        FadePalStep(0, apal, 0x10);
                        SetTextColors(0xFA, 0xF7);
                    }
                    break;
                }
                sub_B4BA8();
            }
            sub_91400(ptrbg, io.mx, io.my);
            if (!done) sub_91370(pointerspr, io.mx, io.my);
            oldmx = io.mx;
            oldmy = io.my;
        }
    } while (done == 0);
    if (musicon && songdata) sub_8FCDF(musichandle, 3, 0x64);
    FadePalStep(1, apal, 0x10);
    if (musicon && songdata) {
        while (!sub_8FC8A(musicslot, 3));
        sub_8D2F0(songdata);
        songdata = 0;
    }
    if (musicon && gameopts.speech) {
        MusicChanReset2();
        while (SpeechBusy());
    }
    sub_8EA00(state);
    FreeMemBlock((int)apal);
    FreeMemBlock(ptrbg);
    if (key < 2) {
        key = TonightsGameScreen(home, away);
        PaPreloadClips(teamabbrevs[home], teamabbrevs[away]);
    }
    done = 0;
    if (key == 3) done = 4;
    return done;
}
