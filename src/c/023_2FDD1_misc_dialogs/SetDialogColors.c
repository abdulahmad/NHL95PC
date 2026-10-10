/* Misc dialogs: dialog colour set. */
#include "nhl95.h"

/* SetDialogColors (30A0C) - set the dialog box colours: fill, light edge, shaded edge, text foreground and
   background (the last on the stack). */
void SetDialogColors(int a, int b, int c, int d, int e)
{
    boxfillcolor = a;
    boxlitecolor = b;
    boxshadecolor = c;
    dlgtextfg = d;
    dlgtextbg = e;
}
