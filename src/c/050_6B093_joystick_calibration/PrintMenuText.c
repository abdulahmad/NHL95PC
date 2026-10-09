/* Joystick calibration file: menu text printers (one source block: the three share their exits). */
#include "nhl95.h"

/* PrintMenuText (6B88E) - print menu text s at x / y with a shadow (PrintShadowText), copied to an 80-byte buffer
   first (at most 79 characters). */
void PrintMenuText(int x, int y, char *s)
{
    char buf[80];
    int i;

    for (i = 0; s[i] && i < 0x4F; i++) buf[i] = s[i];
    buf[i] = s[i];
    PrintShadowText(x, y, buf);
}

/* PrintMenuTextGrey (6B8CB) - the same without the shadow (the greyed item, sub_91964). */
void PrintMenuTextGrey(int x, int y, char *s)
{
    char buf[80];
    int i;

    for (i = 0; s[i] && i < 0x4F; i++) buf[i] = s[i];
    buf[i] = s[i];
    sub_91964(buf, x, y);
}

/* PrintMenuTextAlt (6B910) - the same through the other text printer (sub_92CD0). */
void PrintMenuTextAlt(int x, int y, char *s)
{
    char buf[80];
    int i;

    for (i = 0; s[i] && i < 0x4F; i++) buf[i] = s[i];
    buf[i] = s[i];
    sub_92CD0(buf, x, y);
}
