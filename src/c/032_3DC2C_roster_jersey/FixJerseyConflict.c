/* Roster / jersey: fixing a duplicate jersey number. */
#define FixJerseyConflict FixJerseyConflict_decl
#define WriteKeyRec WriteKeyRec_decl
#include "nhl95.h"
#undef FixJerseyConflict
#undef WriteKeyRec

int WriteKeyRec(int fh, void *rec, long pos);

/* DRAFT: 19 differing instructions under 10.0 GA, 825 vs 827 bytes. Plain palette and key pointers
   fix the palette store/call registers; tr/pal slots and the two row-index computations still differ. */
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
