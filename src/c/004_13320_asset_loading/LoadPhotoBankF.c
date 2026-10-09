/* Asset loading: player photos. */
#include "nhl95.h"

/* LoadPhotoBankF (138D2) - PC only: load the extra photo bank F000149.PPV once (from the CD when the file is on
   it) and index its 105 photos ("%04d") into photoptrsf. */
void LoadPhotoBankF(void)
{
    char name[16];
    char path[16];
    int i;

    if (photobankf != 0) return;
    MakePath(path, fileoncd[0x90] == 1 ? (char *)cddriveptr : (char *)photobankf, (char *)str_F000149, (char *)str_PPV);
    photobankf = sub_8E8A0(path, 0x20);
    for (i = 0; i < 105; i++) {
        sprintf(name, (char *)str_04d, i);
        photoptrsf[i] = sub_B30B4(photobankf, name);
    }
}

/* LoadPlayerPhotos (1395F) - PC only: load the 23 player photo banks that are not loaded yet: bank b is named
   from b / 2 ("<n>00_<n>49" / "<n>50_<n>99" for the first 20 banks, without the underscore after that, .PPV;
   from the CD when fileoncd[b] says so), then indexed (IndexPhotoBank); then the extra bank (LoadPhotoBankF).
   Its exit is LoadPhotoBankF's (shared tail), so both are in this file. */
void LoadPlayerPhotos(void)
{
    char name[16];
    char path[16];
    int b;
    int half;

    for (b = 0; b < 23; b++) {
        if (photobanks[b] != 0) continue;
        half = b / 2;
        if (b >= 20) {
            if (b % 2) sprintf(name, (char *)str_D50D99, half, half);
            else sprintf(name, (char *)str_D00D49, half, half);
        } else {
            if (b % 2) sprintf(name, (char *)str_D50_D99, half, half);
            else sprintf(name, (char *)str_D00_D49, half, half);
        }
        MakePath(path, fileoncd[b] == 1 ? (char *)cddriveptr : 0, name, (char *)str_PPV);
        photobanks[b] = sub_8E8A0(path, 0x20);
        IndexPhotoBank(b);
    }
    LoadPhotoBankF();
}
