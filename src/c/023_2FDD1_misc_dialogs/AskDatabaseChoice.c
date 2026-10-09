/* Misc dialogs: database choice. */
#include "nhl95.h"

/* AskDatabaseChoice (2FDD1) - ask which database to use (original or edited) at the mouse position; sets dbextension
   to .ORG for answer 1, else .DB. Returns the answer. */
int AskDatabaseChoice(void)
{
    int r;
    int y;
    int x;

    sub_B2DCA(&r, &y, &x);
    r = MessageBox(-1, -1, (char *)dbchoicelines, 3, (int)dbchoicebtns, 2, (int)&y, (int)&x, -1);
    if (r == 1) dbextension = (int)str_ORG;
    else dbextension = (int)str_extDB;
    return r;
}
