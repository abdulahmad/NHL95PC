/* Coach files: the coach cutscene. */
#define PlayMVI PlayMVI_decl
#define sub_8F98F sub_8F98F_decl
#include "nhl95.h"
#undef PlayMVI
#undef sub_8F98F

int PlayMVI(char *path, int x, int y);
int sub_8F98F(char *path);

/* CoachCutScene: fade out, show the coach screen, and play a random coach clip unless the
 user clicks through. Pal29 is copied into a 300h-byte buffer. The coach song loads when
 music is on and nothing is already playing. A speech option plays the coach clip and waits
 for it. Returns the click result, or PlayMVI's result when the clip runs. */
int CoachCutScene(void)
{
    struct {
        unsigned char pal[0x300];
        char path[0x20];
        char name[0x10];
    } s;
    int bank;
    int flag;
    int r;
    int n;

    FadeOutPalCycle();
    InputInstall();
    MakePath(s.path, fileoncd[0x1E6] == 1 ? (char *)cddriveptr : 0, (char *)str_Coachcut, 0);
    bank = sub_8E83C(s.path, 0);
    sub_8FFB0(0, 0x100, s.pal);
    FadePalette(1, s.pal, 0x10);
    sub_B4BA8();
    sub_9061C(sub_B30B4(bank, (char *)str_Scrn4));
    memcpy(s.pal, (unsigned char *)sub_B30B4(bank, (char *)str_Pal29) + 0x10, 0x300);
    FreeMemBlock(bank);
    if (musicon && !songdata) {
        MakePath(s.path, fileoncd[0x21F] == 1 ? (char *)cddriveptr : 0, (char *)str_Coach, (char *)str_Iff13);
        songdata = sub_8F98F(s.path);
    }
    if (musicon && (((unsigned char *)&gameopts)[1] & 1)) {
        flag = 1;
        SayCoachClip();
    } else
        flag = 0;
    FadePalette(0, s.pal, 0x10);
    r = WaitClickTimeout(0xA);
    if (!r) {
        n = rand() % 0x32;
        sprintf(s.name, (char *)str_Clip04d, n + 1);
        MakePath(s.path, fileoncd[0x1E7 + n] == 1 ? (char *)cddriveptr : 0, s.name, (char *)str_Cmv2);
        if (musicon && (((unsigned char *)&gameopts)[1] & 1))
            while (SpeechBusy());
        r = PlayMVI(s.path, 0x161, 0x54);
        sub_8FFB0(0, 0x100, s.pal);
        FadePalette(1, s.pal, 0x10);
        if (musicon && (((unsigned char *)&gameopts)[1] & 1)) {
            MusicChanReset2();
            while (SpeechBusy());
        }
        if (musicon && songdata) {
            while (!sub_8FC8A(*(int *)((char *)&musicslot - 3) >> 24, 3));
            sub_8D2F0(songdata);
            songdata = 0;
        }
    } else {
        sub_8FFB0(0, 0x100, s.pal);
        FadePalette(1, s.pal, 0x10);
        if (musicon && songdata) {
            sub_8D2F0(songdata);
            songdata = 0;
        }
    }
    if (flag == 1) FreeCoachClip();
    InputRemove();
    return r;
}
