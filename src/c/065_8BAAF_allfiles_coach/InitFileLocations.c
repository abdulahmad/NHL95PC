/* All files / coach: file locations. */
#include "nhl95.h"

/* InitFileLocations (8BAAF) - read NHL.CFG: its second line starts with the CD drive letter (cddrivestr); open
   <drive>ALLFILES.TXT (or ALLFILES.TXT here) and mark every file listed there (up to 225h) as on the CD
   (fileoncd = 1); then every name left in NHL.CFG is installed on the hard disk (fileoncd = 0). Fatal error when
   either file is missing. */
void InitFileLocations(void)
{
    char names[0x225][16];
    char line[60];
    void *cfg;
    void *fa;
    int i;
    int r;

    cfg = fopen((char *)str_NhlCfg, (char *)unk_C3B0C);
    if (!cfg) FatalError((char *)str_CantOpenNhlCfg2);
    fgets(line, 0x10, cfg);
    fgets(line, 0x10, cfg);
    cddrivestr = line[0];
    line[1] = 0;
    strcat(line, (char *)str_ALLFILESTXT);
    fa = fopen(line, (char *)unk_C3B0C);
    if (!fa) {
        fa = fopen((char *)str_ALLFILESTXT2, (char *)unk_C3B0C);
        if (!fa) {
            fclose(cfg);
            FatalError((char *)str_CouldNotOpenALLFILES);
        }
    }
    i = 0;
    r = 0;
    for (;;) {
        if (i >= 0x225 || r == -1) break;
        fileoncd[i] = 1;
        r = fscanf(fa, (char *)asc_C3B67, names[i]);
        i++;
    }
    fclose(fa);
    r = 0;
    for (;;) {
        if (r == -1) break;
        r = fscanf(cfg, (char *)asc_C3B67, line);
        i = 0;
        for (;;) {
            if (i >= 0x225) break;
            if (!stricmp(line, names[i])) {
                fileoncd[i] = 0;
                i = 0x226;
            } else {
                i++;
            }
        }
    }
    fclose(cfg);
}
