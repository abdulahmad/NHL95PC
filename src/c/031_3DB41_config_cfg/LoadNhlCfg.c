/* Config: NHL.CFG. */
#include "nhl95.h"

#define SETMOUSEHANDLER ((void (__cdecl *)(void *fn))sub_B3454)

/* LoadNhlCfg (3DB41) - read the sound card setting from NHL.CFG (a hex index into sounddevids; device 10h when it
   doesn't parse; fatal error when the file can't be opened); set palette entries 0-3 to the grey ramp, the mouse
   handler and position 0 / 0, the dialog colours, then sub_8FE83(1) and select the sound device. */
void LoadNhlCfg(void)
{
    char buf[16];
    int n;
    void *fp;
    int dev;
    int i;

    MakePath(buf, 0, (char *)str_NHL2, (char *)str_CFG);
    fp = fopen(buf, (char *)str_R3);
    if (!fp) FatalError((char *)str_CannotOpenNhlCfg);
    if (fscanf(fp, (char *)str_fmt4x, &n) == 1) dev = sounddevids[n];
    else dev = 0x10;
    fclose(fp);
    for (i = 0; i < 4; i++) {
        buf[2] = buf[1] = buf[0] = greyramp[i];
        sub_B4B88(i, 1, (unsigned char *)buf);
    }
    SETMOUSEHANDLER(sub_8EB93);
    MouseSetPos(0, 0);
    SetDialogColors(2, 3, 1, 3, 0);
    sub_8FE83(1);
    SetSoundDevice(dev);
}
