/* League setup: password prompts. */
#include "nhl95.h"

/* AskTeamPassword (3A395) - PC only: up to 3 times ask "Enter password for <team name>" (team t of the 30-byte team
   entries ents: name, password at +0Bh; 10 characters) and compare it with the team's password (decrypted for the
   check with EncryptPassword and encrypted again); a wrong one shows the message unk_C7965 at the mouse. Returns
   0 when right, -1 when wrong three times or cancelled (Esc). */
int AskTeamPassword(int t, char *ents)
{
    int tries;
    int res;
    int btn;
    int mx;
    int my;
    char pw[12];
    char prompt[84];
    char *e;
    char *p;

    tries = 0;
    do {
        res = 0;
        strcpy(prompt, (char *)str_EnterPasswordFor);
        e = ents + t * 30;
        strcat(prompt, e);
        if (TextInputDialog(prompt, pw, 10, 0x3C, 0, 0, 0, 0, 6) == 0x1B) return -1;
        p = e + 0xB;
        EncryptPassword(p, t);
        if (strcmp(p, pw) != 0) {
            sub_B2DCA(&btn, &mx, &my);
            MessageBox(-1, -1, (char *)unk_C7965, 1, 0, 0, (int)&mx, (int)&my, -1);
            res = -1;
        }
        EncryptPassword(ents + t * 30 + 0xB, t);
        tries++;
    } while (res != 0 && tries < 3);
    return res;
}


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

/* EncryptPassword (3A597) - PC only: en/decrypt (symmetric) the 10-byte password pw of team t: each byte is
   xored with passkey from position t mod its length forwards and with passkey from its end backwards, both
   wrapping. */
void EncryptPassword(char *pw, int t)
{
    int len;
    int k;
    int j;
    int i;

    len = strlen((char *)passkey);
    k = t % len;
    j = 0;
    for (i = 0; i < 10; i++) {
        pw[i] ^= passkey[k];
        pw[i] ^= passkey_m1[len - j];
        k++;
        j++;
        if (k >= len) k = 0;
        if (j >= len) j = 0;
    }
}
