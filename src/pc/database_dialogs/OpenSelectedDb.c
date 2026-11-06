/* Database dialogs: open the selected database. */
#include "nhl95.h"

/* The 13 zero bytes after InputDialog live in the code segment. A struct copy reloads ds from cs. */
void copy13(void *s, void *d);
#pragma aux copy13 = "movsd" "movsd" "movsd" "movsb" parm [esi] [edi] modify [edi esi];

/* OpenSelectedDb: open the database the dialog selected (fdlgtab). 0 copies "current" into curdbname and loads
 the empty directory with extension DB; 1 copies "original" and loads extension ORG; 2 copies the chosen temp
 name into curdbname, appends DBX to the directory, and loads extension DB. */
void OpenSelectedDb(void)
{
    char buf[16];

    copy13(&unk13_722FE, buf);
    switch (fdlgtab) {
    case 0:
        *(struct { char b[8]; } *)curdbname = *(struct { char b[8]; } *)str_Current4;
        LoadDbsFromDir(buf, (char *)str_extDB);
        break;
    case 1:
        *(struct { char b[9]; } *)curdbname = *(struct { char b[9]; } *)str_Original2;
        LoadDbsFromDir(buf, (char *)str_ORG);
        break;
    case 2:
        strcpy(buf, (char *)dblisttempnames[dblisttemp[1]]);
        strcpy((char *)curdbname, buf);
        strcat(buf, (char *)str_DBX2);
        LoadDbsFromDir(buf, (char *)str_extDB);
        break;
    }
}
