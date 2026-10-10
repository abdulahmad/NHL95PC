/* Asset loading: in-game graphics (one source block: ReloadGameGfx ends in LoadGameGfx_common). */
#include "nhl95.h"

/* LoadGameGfx (13A91) - load the in-game graphics: screen pitch 52h; the HILIGHT.VFN font (hilightfont) and the
   NUMSHP.PPV number shapes (numshpbank; both from the CD when fileoncd says so), the ten digit shapes "0000".."0009"
   (numshapes), the graphics id list (sub_90B80 into dword_D8C4C), clear the panel penalties, load the transparent
   rink end overlay, colour 4 on FFh, the player photos; then a fade-in is pending (fadeinpending,
   dword_C66D4 / dword_C66D0 = 1). */
void LoadGameGfx(void)
{
    char path[16];
    char name[12];
    int i;

    sub_B4BA8();
    scrpitch = 0x52;
    MakePath(path, fileoncd[0xA0] == 1 ? (char *)cddriveptr : 0, (char *)str_HILIGHT, (char *)str_VFN);
    hilightfont = sub_8E8A0(path, 0x20);
    MakePath(path, fileoncd[0x10B] == 1 ? (char *)cddriveptr : 0, (char *)str_Numshp, (char *)str_PPV);
    numshpbank = sub_8E8A0(path, 0x20);
    for (i = 0; i < 10; i++) {
        sprintf(name, (char *)str_04d, i);
        numshapes[i] = sub_B30B4(numshpbank, name);
    }
    sub_90B80(numshpbank, (char *)str_GfxIdList, dword_D8C4C);
    ClearPanelPenalties();
    LoadTransparentRinkEndOverlay();
    sub_8E9C0(4, 0xFF);
    LoadPlayerPhotos();
    nullsub_2();
    fadeinpending = 1;
    dword_C66D0 = dword_C66D4 = 1;
}

/* ReloadGameGfx (13BB4) - LoadGameGfx without the sub_B4BA8 call first (reload after the graphics were freed). */
void ReloadGameGfx(void)
{
    char path[16];
    char name[12];
    int i;

    scrpitch = 0x52;
    MakePath(path, fileoncd[0xA0] == 1 ? (char *)cddriveptr : 0, (char *)str_HILIGHT, (char *)str_VFN);
    hilightfont = sub_8E8A0(path, 0x20);
    MakePath(path, fileoncd[0x10B] == 1 ? (char *)cddriveptr : 0, (char *)str_Numshp, (char *)str_PPV);
    numshpbank = sub_8E8A0(path, 0x20);
    for (i = 0; i < 10; i++) {
        sprintf(name, (char *)str_04d, i);
        numshapes[i] = sub_B30B4(numshpbank, name);
    }
    sub_90B80(numshpbank, (char *)str_GfxIdList, dword_D8C4C);
    ClearPanelPenalties();
    LoadTransparentRinkEndOverlay();
    sub_8E9C0(4, 0xFF);
    LoadPlayerPhotos();
    nullsub_2();
    fadeinpending = 1;
    dword_C66D0 = dword_C66D4 = 1;
}
