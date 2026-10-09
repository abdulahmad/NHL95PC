/* LoadSettingsShapes - unless loaded, load the settings dialog bank SETTINGS (from the CD when listed there) into
   settingsfile and look up its shapes: check on / off, accept, cancel, and the option buttons Na01-05, Pg01-07 and
   Pl05-20. */
#include "nhl95.h"

void LoadSettingsShapes(void)
{
    char path[32];

    if (!settingsfile) {
        MakePath(path, fileoncd[0x1C5] == 1 ? (char *)cddriveptr : 0, (char *)str_Settings, 0);
        settingsfile = sub_8E83C(path, 0);
        chkonspr = sub_B30B4(settingsfile, (char *)str_On);
        chkoffspr = sub_B30B4(settingsfile, (char *)str_Off);
        acptspr = sub_B30B4(settingsfile, (char *)str_Acpt);
        fdlg_cancel = sub_B30B4(settingsfile, (char *)str_Canc);
        na01spr = sub_B30B4(settingsfile, (char *)str_Na01);
        na03spr = sub_B30B4(settingsfile, (char *)str_Na03);
        na05spr = sub_B30B4(settingsfile, (char *)str_Na05);
        pg01spr = sub_B30B4(settingsfile, (char *)str_Pg01);
        pg03spr = sub_B30B4(settingsfile, (char *)str_Pg03);
        pg05spr = sub_B30B4(settingsfile, (char *)str_Pg05);
        pg07spr = sub_B30B4(settingsfile, (char *)str_Pg07);
        pl05spr = sub_B30B4(settingsfile, (char *)str_Pl05);
        pl10spr = sub_B30B4(settingsfile, (char *)str_Pl10);
        pl20spr = sub_B30B4(settingsfile, (char *)str_Pl20);
    }
}
