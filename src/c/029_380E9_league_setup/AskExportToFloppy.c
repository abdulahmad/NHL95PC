/* League setup: export. */
#include "nhl95.h"

/* AskExportToFloppy (38386) - mark which of the 26 teams' records (1Eh bytes each) to export: a team flagged (+17h) and
   already marked 2 (+18h) when mode bit 0 is set, or flagged here but not in orig when mode bit 1 is set, is asked
   about (exportmsg names the record, yes/no at the mouse position) when n > 1: yes or no asking marks it 1, no
   marks it 2 (+18h and +16h). Unflagged teams that are not asked about are marked 1. */
void AskExportToFloppy(unsigned char *teams, unsigned char *orig, int mode, int n)
{
    int i;
    int y;
    int x;
    unsigned char *t;
    int r;

    sub_B2DCA(&i, &y, &x);
    for (i = 0; i < 0x1A; i++) {
        if (((mode & 1) && teams[i * 30 + 0x17] == 1 && teams[i * 30 + 0x18] == 2)
            || ((mode & 2) && ((unsigned char (*)[30])teams)[i][0x17] == 1 && ((unsigned char (*)[30])orig)[i][0x17] == 0)) {
            t = teams + i * 30;
            if (n > 1) {
                *(unsigned char **)(exportmsg + 4) = t;
                r = MessageBox(-1, -1, (char *)exportmsg, 3, (int)yesnobtns, 2, (int)&y, (int)&x, -1);
                t = teams + i * 30;
                if (r != 1) {
                    t[0x18] = 2;
                    teams[i * 30 + 0x16] = 2;
                    continue;
                }
            }
        } else {
            t = teams + i * 30;
            if (t[0x17] != 0) continue;
        }
        t[0x18] = 1;
        teams[i * 30 + 0x16] = 1;
    }
}
