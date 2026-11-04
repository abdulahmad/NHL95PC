/* Roster / jersey: fixing a duplicate jersey number. */
#define TradeShowStats TradeShowStats_decl
#define RunMenu RunMenu_decl
#define TeamRosterScreen TeamRosterScreen_decl
#define DrawTradeScreen DrawTradeScreen_decl
#define FixJerseyConflict FixJerseyConflict_decl
#define WriteKeyRec WriteKeyRec_decl
#include "nhl95.h"
#undef TradeShowStats
#undef RunMenu
#undef TeamRosterScreen
#undef DrawTradeScreen
#undef FixJerseyConflict
#undef WriteKeyRec

void RunMenu(void *bar, int n, int col1, int col2, int col3);
void TeamRosterScreen(int cat);
void DrawTradeScreen(int list, int s0, int s2, int s1, int s3, int b3, int b2);
int WriteKeyRec(int fh, void *rec, long pos);

/* Compile context (matched in TradeShowStats.c): TradeShowStats: fade out, load the roster stat screens for cat, show the trade menu, then fade
 back and redraw the trade screen. list and the other arguments are the trade screen's own.
 The last stack argument is unused. */
void TradeShowStats(int list, unsigned char cat, int b2, int b3,
                    int s0, int s1, int s2, int s3, int s4)
{
    char path[16];
    char *dir;
    char *name;
    char *ext;
    int pal;
    int bank;
    int shape;
    int c;
    int z;

    sub_B4BA8();
    pal = sub_8CCA8((char *)str_Temp6, 0x300, 0x20);
    sub_8FFB0(0, 0x100, (unsigned char *)pal);
    FadePalStep(1, (unsigned char *)pal, 0x10);
    sub_B392C(0);
    dword_DC738 = 1;
    statsredrawcb = (int)TeamRosterScreen;
    statscategory = cat;
    statsteambuf = sub_8CCA8((char *)str_Tstat, 0x2A4, 0x20);
    statsplayerbuf = (unsigned char *)sub_8CCA8((char *)str_Keys2, 0x5B0, 0x20);
    statsskaterbuf = (unsigned char *)sub_8CCA8((char *)str_Pstat2, 0x497, 0x20);
    statsgoaliebuf = (unsigned char *)sub_8CCA8((char *)str_Gstat2, 0x10E, 0x20);
    ext = 0;
    name = (char *)str_Embpal3;
    if (fileoncd[0x8E] == 1)
        dir = (char *)cddriveptr;
    else
        dir = 0;
    MakePath(path, dir, name, ext);
    bank = sub_8E83C(path, 0);
    shape = sub_B30B4(bank, (char *)str_Pal21);
    memcpy((unsigned char *)pal, (char *)shape + 0x10, 0x300);
    FreeMemBlock(bank);
    InitMenuRemap(1);
    TeamRosterScreen(cat);
    DrawMenuBar(unk_C88E2, 2, 0x40, 0x41, 0x42);
    FadePalStep(0, (unsigned char *)pal, 0x10);
    RunMenu(unk_C88E2, 2, 0x40, 0x41, 0x42);
    c = 0;
    dword_DC738 = c;
    statsredrawcb = c;
    FreeMemBlock(statsteambuf);
    FreeMemBlock((int)statsgoaliebuf);
    FreeMemBlock((int)statsskaterbuf);
    FreeMemBlock((int)statsplayerbuf);
    z = 0;
    statsplayerbuf = (unsigned char *)z;
    statsteambuf = z;
    statsgoaliebuf = (unsigned char *)z;
    statsskaterbuf = (unsigned char *)z;
    sub_B4BA8();
    FadePalStep(1, (unsigned char *)pal, 0x10);
    sub_B392C(z);
    FreeMemBlock(pal);
    DrawTradeScreen(list, s0, s2, s1, s3, b3, b2);
}

/* DRAFT: 16 differing instructions under 10.0 GA, 825 vs 827 bytes. Plain palette and key pointers
   fix the palette store/call registers. TradeShowStats, the EXE's previous function, is compiled first as a
   compile-context copy: after it the compiler state gives tr and pal their EXE slots (fresh: 19, tr / pal
   swapped). Left: the two row-index computations (the ReadKeyRec record index scaled in place, the duplicate
   scan's two rows in the other order). */
/* FixJerseyConflict (3E055, PC only): make sure player k of the team record tr wears a jersey number nobody else
   on the team has. Read the team's 1Ch key records (34h bytes each; record numbers at tr +4Ch); while another
   player has k's number (byte 1), say so (str_TheJerseyNumber2d2 with the team name tr +1Ah, in the DONEPAL
   colours FBh-FEh), ask for a new number from 1 to 63h for him (first and last name, TextInputDialog) and write
   his key record back. fh: the key file; k: the player; tr: the team record. Result: 0 or the I/O error. */
int FixJerseyConflict(int fh, int k, unsigned char *tr)
{
    struct {
        unsigned char key[0x1C][0x34];
        char msg[0x54];
        char name[0x20];
        char num[4];
        int x;
        int y;
        int i;
    } s;
    unsigned char *e;
    int err;
    unsigned char rgb[3];
    int bad;
    int pal;

    err = 0;
    for (s.i = 0; s.i < 0x1C && !err; s.i++) err = ReadKeyRec(fh, s.key[s.i], ((int *)(tr + 0x4C))[s.i]);
    if (err) return err;
    do {
        bad = 0;
        for (s.i = 0; s.i < 0x1C && !bad; s.i++)
            if (k != s.i && s.key[s.i][1] == s.key[k][1]) bad = -1;
        if (bad) {
            pal = sub_8CCA8((char *)str_Donepal, 0xC, 0x20);
            sub_8FFB0(0xFB, 4, (unsigned char *)pal);
            rgb[0] = 0x18;
            rgb[1] = 0;
            rgb[2] = 0;
            sub_B4B88(0xFB, 1, rgb);
            rgb[0] = 0x2A;
            rgb[1] = 0;
            rgb[2] = 0;
            sub_B4B88(0xFC, 1, rgb);
            rgb[0] = 0x3B;
            rgb[1] = 0x12;
            rgb[2] = 0;
            sub_B4B88(0xFD, 1, rgb);
            rgb[0] = 0x3B;
            rgb[1] = 0x3B;
            rgb[2] = 0x3B;
            sub_B4B88(0xFE, 1, rgb);
            e = s.key[k];
            strcpy(s.name, (char *)e + 3);
            strcat(s.name, (char *)&str_space);
            strcat(s.name, (char *)e + 0x13);
            sprintf(s.msg, (char *)str_TheJerseyNumber2d2, s.key[k][1], tr + 0x1A);
            jerseymsg = (int)s.msg;
            sub_B2DCA(&s.i, &s.y, &s.x);
            MessageBox(-1, -1, (char *)&jerseymsg, 1, 0, 0, (int)&s.y, (int)&s.x, -1);
            sub_B4B88(0xFB, 4, (unsigned char *)pal);
            FreeMemBlock(pal);
            sprintf(s.msg, (char *)str_EnterJerseyNumberFor, s.name);
            s.num[0] = 0;
            s.key[k][1] = TextInputDialog(s.msg, s.num, 2, 0x16, -1, 1, 0x63, 0, 0);
            err = WriteKeyRec(fh, e, ((int *)(tr + 0x4C))[k]);
        }
    } while (bad && !err);
    return err;
}
