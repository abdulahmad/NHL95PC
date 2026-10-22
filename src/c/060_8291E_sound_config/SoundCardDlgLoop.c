/* Sound config: the sound card dialog. */
#define SoundCardDlgLoop SoundCardDlgLoop_decl
#define SetSoundDevice SetSoundDevice_decl
#define sub_8F98F sub_8F98F_decl
#define sub_8FB8E sub_8FB8E_decl
#define sub_97079 sub_97079_decl
#define sub_8EB5B sub_8EB5B_decl
#define sub_8EB93 sub_8EB93_decl
#define sub_8ECC0 sub_8ECC0_decl
#define sub_8F13B sub_8F13B_decl
#define sub_8F1FE sub_8F1FE_decl
#include "nhl95.h"
#undef sub_97079
#undef sub_8EB5B
#undef sub_8EB93
#undef sub_8ECC0
#undef sub_8F13B
#undef sub_8F1FE
#undef SoundCardDlgLoop
#undef SetSoundDevice
#undef sub_8F98F
#undef sub_8FB8E

int SetSoundDevice(int dev);
int sub_8F98F(char *path);  /* sound library: load a song */
void sub_8FB8E(int song, int handle, int a, int b);  /* sound library: start a song */

int fprintf(void *fp, const char *fmt, ...);  /* Watcom CRT fprintf_ */
int sub_97079(int dev);                       /* sound library: open a driver, -1 on failure */
void sub_8EB5B(void);
void sub_8EB93(void);
void sub_8ECC0(char *drv, char *port);        /* sound library: driver and port names */
int sub_8F13B(char *path);                    /* sound library: load a sample */
void sub_8F1FE(int sample);                   /* sound library: free a sample */
typedef struct { char b[0x11]; } SprHdr;

/* SoundCardDlgLoop (8291E, PC only; owner of the SoundCardDlg_epilogue tail SetSoundDevice ends in): run the
   sound card dialog with the mouse pointer (a POINTER block holds the screen under it; dword_D2435 is freed
   first). A click (event bit 2) on an available device that is not the chosen one (SoundCardHitTest: setbits
   bit, byte_C541B as a dword of available bits) picks it (bits 1-20h). The OK button (40h) stops the music and
   tries SetSoundDevice: on success the device becomes sounddev, the music restarts (MAINDESK.IFF, from the CD
   when it is there) and gameopts bit 8 follows musicon; on failure the device is marked unavailable, the old
   one is chosen again and the music restarts. Cancel (80h) or event bit 4 leaves. Result: 0. */
int SoundCardDlgLoop(void)
{
    struct {
        char path[0x20];
        int hit;
        int ev;
        int y;
        int x;
        int my;
        int mx;
    } s;
    int bg;
    int t;  /* the size, the event and the song: one variable keeps the song in eax (a separate one copies it to esi) */

    t = (((short *)pointerspr)[2] + 1) * (((short *)pointerspr)[3] + 1) + 0x11;
    bg = sub_8CCA8((char *)str_Pointer21, t, 0);
    *(SprHdr *)bg = *(SprHdr *)pointerspr;
    ((short *)bg)[2] = ((short *)pointerspr)[2] + 1;
    ((short *)bg)[3] = ((short *)pointerspr)[3] + 1;
    if (dword_D2435) {
        FreeMemBlock(dword_D2435);
        dword_D2435 = 0;
    }
    sub_B2DCA(&s.ev, &s.mx, &s.my);
    s.x = s.mx;
    s.y = s.my;
    sub_B4BA8();
    sub_91400(bg, s.x - 4, s.y);
    sub_91370(pointerspr, s.x - 4, s.y);
    ClearInputQueue();
    for (;;) {
        s.ev = 0;
        while ((t = (int)GetInputEvent()) != 0) {
            s.ev = ((int (*)(unsigned char *, int *, int *))ptrupdatefn)((unsigned char *)t, &s.x, &s.y);
            if (s.ev & 6) break;
        }
        if (!(s.ev & 2) && !(s.ev & 4)) {
            if (s.x != s.mx || s.y != s.my) {
                sub_903F0(bg, s.mx - 4, s.my);
                sub_91400(bg, s.x - 4, s.y);
                sub_91370(pointerspr, s.x - 4, s.y);
                s.mx = s.x;
                s.my = s.y;
            }
        } else if (s.ev & 2) {
            sub_903F0(bg, s.mx - 4, s.my);
            if (SoundCardHitTest(s.x, s.y, &s.hit)) {
                s.hit = 1 << s.hit;
                if (!(s.hit & setbits[0]) && (s.hit & *(int *)&byte_C541B)) {
                    switch ((unsigned)s.hit) {
                    case 1:
                    case 2:
                    case 4:
                    case 8:
                    case 0x10:
                    case 0x20:
                        setbits[0] = s.hit;
                        break;
                    case 0x40:
                        DrawSelBoxOn((Rect4 *)unk_D2403);
                        SetDialogColors(0xF9, 0xFA, 0xF8, 0xFA, 0xF7);
                        if (musicon && songdata) {
                            sub_8FCDF(musichandle, 3, 0x64);
                            while (!sub_8FC8A(musicslot, 3));
                            sub_8D2F0(songdata);
                            songdata = 0;
                        }
                        if (SetSoundDevice(setbits[0])) {
                            sounddev = setbits[0];
                            FreeMemBlock(bg);
                            if (musicon && !songdata) {
                                MakePath(s.path, fileoncd[0x1DB] == 1 ? (char *)cddriveptr : 0, (char *)str_Maindesk2, (char *)str_Iff12);
                                t = sub_8F98F(s.path);
                                songdata = t;
                                if (t && gameopts.music) sub_8FB8E(t, musichandle, 3, 0x4C);
                            }
                            if (musicon) gameopts.speech = 1;
                            else gameopts.speech = 0;
                            return 0;
                        }
                        *(int *)&byte_C541B ^= setbits[0];
                        setbits[0] = sounddev;
                        if (musicon && !songdata) {
                            MakePath(s.path, fileoncd[0x1DB] == 1 ? (char *)cddriveptr : 0, (char *)str_Maindesk2, (char *)str_Iff12);
                            t = sub_8F98F(s.path);
                            songdata = t;
                            if (t && gameopts.music) sub_8FB8E(t, musichandle, 3, 0x4C);
                        }
                        DrawSelBoxOff((Rect4 *)unk_D2403);
                        break;
                    case 0x80:
                        DrawSelBoxOn((Rect4 *)unk_D2413);
                        FreeMemBlock(bg);
                        return 0;
                    }
                    RedrawSoundCardOpts();
                }
            }
            sub_91400(bg, s.x - 4, s.y);
            sub_91370(pointerspr, s.x - 4, s.y);
            s.mx = s.x;
            s.my = s.y;
        } else if (s.ev & 4) {
            sub_903F0(bg, s.mx - 4, s.my);
            FreeMemBlock(bg);
            return 0;
        } else {
            sub_903F0(bg, s.mx - 4, s.my);
            sub_91400(bg, s.x - 4, s.y);
            sub_91370(pointerspr, s.x - 4, s.y);
            s.mx = s.x;
            s.my = s.y;
        }
    }
}

/* DRAFT (SetSoundDevice): 1346 vs 1346 here (it ends in SoundCardDlg_epilogue, so it belongs in this file; alone
   it was 2 bytes long). Left: dword_D2350 is loaded into edx for the MT-32 test and the message box zeros (EXE
   ebx), and the event word is cleared through eax before the mouse read (EXE edx). See docs/UNSURE.md. */
/* SetSoundDevice (82D7A, PC only): switch the sound to device dev (setbits bits: 1 PC speaker, 2 Sound Blaster,
   4 AdLib, 8 MT-32, 20h Ultrasound, 10h none). Shut the current one down first (speech and its copy buffer for
   2 / 20h, the AdLib sample for 4). Then open dev's music and digital drivers (sub_97079 of dword_D2427 /
   dword_D242B); on success name them to the sound library, load the AdLib SLAPSHOT sample, play the MT32HOCK
   sample once for the MT-32 (with a message), make dev sounddev and setbits, set the slots, write its index in
   sounddevids to NHL.CFG and turn music on for 2 / 20h. When a device fails, say so (its name in sndcardname)
   until a click and fall back to 10h. Then start speech for 2 / 20h. Result: 1. */
int SetSoundDevice(int dev)
{
    struct {
        char path[0x10];
        char port[0x10];
        char drv[0x10];
        int y;
        int x;
        int btn;
        int h2;
        int ev;
    } s;
    int h1;
    void *fp;
    int i;
    int t;
    unsigned char *e;

    h1 = 0;
    s.h2 = 1;
    if (dword_D2423) {
        if (sounddev == 2 || sounddev == 0x20) {
            ShutdownSpeech();
            FreeMemBlock(dword_ED7A8);
            dword_ED7A8 = 0;
        } else if (sounddev == 4) {
            sub_8F1FE(dword_ED7A4);
        }
        sub_8EB93();
    }
    dword_CCC94 = 0x20;
    dword_D2423 = 0;
    do {
        switch (dev) {
        case 1:
            strcpy(s.drv, (char *)str_PCBEEP);
            strcpy(s.port, (char *)str_PC);
            dword_D2427 = 1;
            dword_D242B = -1;
            byte_D2439 = 0;
            break;
        case 2:
            strcpy(s.drv, (char *)str_SBDAC);
            strcpy(s.port, (char *)str_PC);
            dword_D2427 = 2;
            dword_D242B = 3;
            byte_D2439 = musicslot = 1;
            break;
        case 4:
            strcpy(s.drv, (char *)str_ADLIB);
            strcpy(s.port, (char *)str_PC);
            dword_D2427 = 2;
            dword_D242B = -1;
            byte_D2439 = 0;
            break;
        case 8:
            strcpy(s.drv, (char *)str_MT322);
            strcpy(s.port, (char *)str_PC);
            dword_D2427 = 4;
            dword_D242B = -1;
            byte_D2439 = 0;
            break;
        case 0x20:
            strcpy(s.drv, (char *)str_SBDAC2);
            strcpy(s.port, (char *)str_PC);
            dword_D2427 = 5;
            dword_D242B = 6;
            byte_D2439 = musicslot = 1;
            break;
        default:
            strcpy(s.drv, (char *)str_PCBEEP2);
            strcpy(s.port, (char *)str_PC);
            dword_D2427 = 0;
            dword_D242B = -1;
            byte_D2439 = 0;
            break;
        }
        sub_8EB5B();
        if (dword_D2427 >= 0 && (h1 = sub_97079(dword_D2427)) != -1
            && (dword_D242B < 0 || (s.h2 = sub_97079(dword_D242B)) != -1))
            dword_D2423 = -1;
        if (dword_D2423) {
            sub_8ECC0(s.drv, s.port);
            if (dev == 4) {
                MakePath(s.path, fileoncd[0x18F] == 1 ? (char *)cddriveptr : 0, (char *)str_Slapshot, 0);
                dword_ED7A4 = sub_8F13B(s.path);
            }
            if (dev == 8 && !dword_D2350) {
                MessageBox(-1, -1, (char *)msg_InitMT32, 2, 0, 0, (int)&s.x, (int)&s.y, 0);
                MakePath(s.path, fileoncd[0xF7] == 1 ? (char *)cddriveptr : 0, (char *)str_MT32HOCK, 0);
                t = sub_8F13B(s.path);
                dword_D2350 = -1;
                sounddev = 8;
                PlayDigiSample((void *)t);
                WaitDigiSample();
                sub_8F1FE(t);
                RestoreDialogBg();
            }
            sounddev = dev;
            byte_D2439 = byte_D2439 ? s.h2 : h1;
            musicslot = s.h2;
            setbits[0] = sounddev;
            MakePath(s.path, 0, (char *)str_NHL3, (char *)str_CFG);
            fp = fopen(s.path, (char *)unk_C36AC);
            if (!fp) FatalError((char *)str_CantOpenNhlCfg);
            i = 0;
            while (dev != sounddevids[i]) i++;
            fprintf(fp, (char *)asc_C36C3, i);
            fclose(fp);
            if (sounddev == 2 || sounddev == 0x20) {
                musicon = 1;
                musichandle = dword_D242B;
            } else {
                musicon = 0;
            }
        } else {
            if (dev != 0x10 && dev != 1) {
                switch (dev) {
                case 2:
                    sndcardname = (int)str_SoundBlaster2;
                    break;
                case 0x20:
                    sndcardname = (int)str_ULTRASOUND;
                    break;
                case 4:
                    sndcardname = (int)str_Adlib;
                    break;
                case 8:
                    sndcardname = (int)str_MT323;
                    break;
                }
                s.ev = 0;
                sub_B2DCA(&s.btn, &s.x, &s.y);
                MessageBox(-1, -1, (char *)unk_D249C, 3, 0, 0, (int)&s.x, (int)&s.y, 0);
                do {
                    if ((e = GetInputEvent()) != 0)
                        s.ev = ((int (*)(unsigned char *, int *, int *))ptrupdatefn)(e, &s.x, &s.y);
                } while (!(s.ev & 2));
                RestoreDialogBg();
                dev = 0x10;
            } else {
                dword_D2423 = -1;
            }
            sub_8EB93();
            SetTickDeadline(0x64);
            WaitTickDeadline();
        }
    } while (!dword_D2423);
    if (sounddev == 2 || sounddev == 0x20) {
        dword_ED7A8 = sub_8CCA8((char *)str_Emmcopybuf, 0x400, 0x20);
        InitSpeech(musicslot, dword_C4CFC, dword_ED7A8, 0x400);
    }
    dword_CCC94 = 0;
    return 1;
}
