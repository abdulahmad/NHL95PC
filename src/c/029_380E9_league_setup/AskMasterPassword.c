/* League setup: password prompts. */
#include "nhl95.h"

/* AskMasterPassword (3A49E) - PC only: up to 3 times ask "<team name> enter master password" (team t of names, 30
   bytes each; 10 characters) and compare it with the league master password (masterpw, decrypted for the check
   with EncryptPassword(key, t) and encrypted again); a wrong one shows the message unk_C7965 at the mouse. Returns
   0 when right, -1 when wrong three times or cancelled (Esc). */
int AskMasterPassword(int t, char *names, char *key)
{
    int res;
    int btn;
    int mx;
    int my;
    char pw[12];
    char prompt[84];
    int tries;

    tries = 0;
    do {
        res = 0;
        strcpy(prompt, names + t * 30);
        strcat(prompt, (char *)str_EnterMasterPassword);
        if (TextInputDialog(prompt, pw, 10, 0x3C, 0, 0, 0, 0, 6) == 0x1B) return -1;
        EncryptPassword(key, t);
        if (strcmp((char *)masterpw, pw) != 0) {
            sub_B2DCA(&btn, &mx, &my);
            MessageBox(-1, -1, (char *)unk_C7965, 1, 0, 0, (int)&mx, (int)&my, -1);
            res = -1;
        }
        EncryptPassword(key, t);
        tries++;
    } while (res != 0 && tries < 3);
    return res;
}
