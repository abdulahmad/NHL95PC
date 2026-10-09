/* Front end: sports desk. */
#include "nhl95.h"

/* OutputCurrentData (18D7F) - sports desk "output current data": ask for an output file name (8 characters,
   TextInputDialog in the desk colours 41h / 40h / 42h, text 40h on 0) and, unless cancelled (Esc) or empty,
   write the screen's text to it (WriteScreenTextFile). The dialog colours are restored. Returns 0. */
int OutputCurrentData(void)
{
    char name[12];
    int fill;
    int lite;
    int shade;
    int fg;
    int bg;

    fill = boxfillcolor;
    lite = boxlitecolor;
    shade = boxshadecolor;
    fg = dlgtextfg;
    bg = dlgtextbg;
    boxfillcolor = 0x41;
    boxlitecolor = 0x40;
    boxshadecolor = 0x42;
    dlgtextfg = 0x40;
    dlgtextbg = 0;
    if (TextInputDialog((char *)str_PleaseEnterOutputFile, name, 8, 0x22, 0, 0, 0, 0, 5) != 0x1B && name[0] != 0)
        WriteScreenTextFile(name);
    boxfillcolor = fill;
    boxlitecolor = lite;
    boxshadecolor = shade;
    dlgtextfg = fg;
    dlgtextbg = bg;
    return 0;
}
