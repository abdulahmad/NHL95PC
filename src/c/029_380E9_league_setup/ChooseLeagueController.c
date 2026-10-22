/* League setup: pick the controller and set the master password. */
#define ChooseLeagueController ChooseLeagueController_decl
#define ListDialog ListDialog_decl
#include "nhl95.h"
#undef ChooseLeagueController
#undef ListDialog

int ListDialog(char **items, int n, char *title, int a, int b, int c);

/* ChooseLeagueController: of the human clubs in the 26 team records (30 bytes each, +17h set),
 build the name list and ask who controls the league when more than one human is playing. That club
 is marked controller (+18h and +19h) and becomes leaguemaster. The master password is entered twice
 and stored encrypted. The position pointers arrive in ecx and ebx. */
void ChooseLeagueController(unsigned char *teams, int n, int y, int x);
#pragma aux ChooseLeagueController parm [eax] [edx] [ecx] [ebx];

void ChooseLeagueController(unsigned char *teams, int n, int y, int x)
{
    int ids[26];
    char prompt[84];
    char pw2[12];
    char pw1[12];
    char *names;
    char **list;
    int bad;
    int k;
    int i;
    int bytes;
    unsigned char *t;
    int xpos;
    int ypos;

    xpos = x;
    ypos = y;
    bytes = n * 4;
    list = (char **)sub_8CCA8((char *)str_PLST, bytes, 0x20);
    memset(list, 0, bytes);
    bytes = n * 11;
    names = (char *)sub_8CCA8((char *)str_PTLS, bytes, 0x20);
    memset(names, 0, bytes);
    k = 0;
    for (i = 0; i < 0x1A; i++) {
        t = teams + i * 30;
        if (t[0x17] == 1) {
            strcpy(prompt, (char *)t);
            strcpy(names + k * 11, prompt);
            ids[k] = i;
            list[k] = names + k * 11;
            k++;
        }
    }
    if (n > 1)
        k = ListDialog(list, n, (char *)str_WhoWillControlThe, 0, 0, 0);
    else {
        k = 0;
        for (i = 0; i < 0x1A; i++) {
            if (teams[i * 30 + 0x17] == 1) {
                ids[0] = i;
                i = 0x1A;
            }
        }
    }
    teams[ids[k] * 30 + 0x18] = 1;
    teams[ids[k] * 30 + 0x19] = 1;
    leaguemaster = ids[k];
    do {
        bad = 0;
        strcpy(prompt, (char *)str_EnterMasterControllerPasswor);
        strcat(prompt, (char *)(teams + ids[k] * 30));
        TextInputDialog(prompt, pw1, 10, 0x3C, 0, 0, 0, 0, 2);
        strcpy(prompt, (char *)str_VerifyMasterControllerPasswo);
        strcat(prompt, (char *)(teams + ids[k] * 30));
        TextInputDialog(prompt, pw2, 10, 0x3C, 0, 0, 0, 0, 2);
        if (strcmp(pw1, pw2) != 0) {
            MessageBox(-1, -1, (char *)pwmismatchmsg, 2, 0, 0, xpos, ypos, -1);
            bad = -1;
        }
    } while (bad != 0);
    strcpy((char *)masterpw, pw1);
    EncryptPassword((char *)masterpw, ids[k]);
    *(int *)&leagueflags = 0;
    leaguesaved = 0;
    savedname = 0;
    FreeMemBlock((int)list);
    FreeMemBlock((int)names);
}
