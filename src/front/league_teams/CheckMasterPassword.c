/* Trades: ask for the league master password before a merge. */
#define CheckMasterPassword CheckMasterPassword_decl
#define LeagueCheckStub LeagueCheckStub_decl
#include "nhl95.h"
#undef CheckMasterPassword
#undef LeagueCheckStub

int LeagueCheckStub(char *dir, int mode);

/* CheckMasterPassword: read the current league. When it has not been merged (leagueflags bit 2 clear),
 ask at the mouse; MergeLeagueFiles runs if that box is accepted and the check repeats. Then, unless
 the read failed, ask for the master password. byte_DE268 swaps the dialog colours around that ask.
 Returns the stub, read, or password result. */
int CheckMasterPassword(void)
{
    struct {
        char name[0x10];
        int x;
        int y;
        int btn;
        unsigned char rgb[4];
    } s;
    int shown;
    int err;

    err = LeagueCheckStub((char *)&curleague, 2);
    do {
        shown = 0;
        if (!err)
            err = ReadLeagueInfo((char *)&curleague, leagueteams, (char *)masterpw,
                (short *)&leaguemaster, &humancount, &leagueflags, &leaguesaved, (char *)&savedname);
        if (!err) {
            strcpy(s.name, (char *)&curleague);
            s.name[_fstrcspn(s.name, (char *)&str_dot)] = 0;
            if ((leagueflags & 4) == 0) {
                msg_MasterDB_arg = (int)s.name;
                SetDialogColors(0xF9, 0xFA, 0xF8, 0xFA, err);
                sub_B2DCA(&s.btn, &s.y, &s.x);
                s.btn = MessageBox(-1, -1, (char *)msg_MasterDB, 4, (int)btn_MasterDB, 2,
                    (int)&s.y, (int)&s.x, -1);
                if (!s.btn) {
                    MergeLeagueFiles();
                    shown = -1;
                } else
                    err = -1;
            }
        }
    } while (shown);
    if (!err) {
        if (byte_DE268) {
            sub_B392C(shown);
            s.rgb[2] = s.rgb[1] = s.rgb[0] = 0x17;
            sub_B4B88(0xF8, 1, s.rgb);
            s.rgb[2] = s.rgb[1] = s.rgb[0] = 0x2A;
            sub_B4B88(0xF9, 1, s.rgb);
            s.rgb[2] = s.rgb[1] = s.rgb[0] = 0x3F;
            sub_B4B88(0xFA, 1, s.rgb);
        }
        SetDialogColors(0xF9, 0xFA, 0xF8, 0xFA, 0);
        err = AskMasterPassword(leaguemaster, (char *)leagueteams, (char *)masterpw);
        if (byte_DE268) {
            sub_B392C(0);
            s.rgb[2] = s.rgb[1] = s.rgb[0] = 0;
            sub_B4B88(0xF8, 1, s.rgb);
            sub_B4B88(0xF9, 1, s.rgb);
            sub_B4B88(0xFA, 1, s.rgb);
        }
    }
    return err;
}
