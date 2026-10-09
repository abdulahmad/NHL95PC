/* Output files: screen text. */
#include "nhl95.h"

/* WriteScreenTextFile (17816) - save the text screen (textgrid, 24h lines of 64h characters) as <base>.OUT: when the file
   is new and the disk is short of 4 KB say how much is needed; if it exists ask before overwriting; then write the
   lines and report success, or report that it could not be opened. */
void WriteScreenTextFile(char *base)
{
    char line[0x66];
    char name[20];
    int need[2];
    int x;
    int y;
    void *fp;
    char *s;
    int i;
    int r;

    if (!textgrid) return;
    need[0] = 4;
    need[1] = 0;
    strcpy(name, base);
    strcat(name, (char *)str_OUT);
    r = !FileExists(name) ? DiskSpaceShort(0, need) : 0;
    if (r) {
        sprintf((char *)msg_NeedKbytes2, (char *)str_NeedKbytesFmt2, r);
        MessageBox(-1, -1, (char *)off_C659A, 3, 0, 0, (int)&x, (int)&y, 0x320);
        return;
    }
    line[0x65] = 0;
    fp = fopen(name, (char *)str_rt);
    if (fp) {
        fclose(fp);
        if (MessageBox(-1, -1, (char *)off_C648E, 2, (int)unk_C6499, 2, (int)&x, (int)&y, -1) != 1) return;
    }
    fp = fopen(name, (char *)str_wt);
    if (fp) {
        s = (char *)textgrid;
        for (i = 0; i < 0x24; i++) {
            strncpy(line, s, 0x64);
            line[0x64] = '\n';
            line[0x65] = 0;
            fputs(line, fp);
            s += 0x64;
        }
        fclose(fp);
        MessageBox(-1, -1, (char *)unk_C64F5, 1, 0, 0, (int)&x, (int)&y, -1);
    } else {
        MessageBox(-1, -1, (char *)unk_C652A, 1, 0, 0, (int)&x, (int)&y, -1);
    }
}
