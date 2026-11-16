/* Sound config: the sound card dialog. */
#define SoundCardDlgLoop SoundCardDlgLoop_decl
#define SetSoundDevice SetSoundDevice_decl
#define LoadDigiFile sub_8F98F_decl
#define PlayDigiBlockLoop sub_8FB8E_decl
#define SndOpenDriver sub_97079_decl
#define SndInit sub_8EB5B_decl
#define SndShutdown sub_8EB93_decl
#define LoadMusicBank sub_8ECC0_decl
#define LoadSample sub_8F13B_decl
#define FreeSample sub_8F1FE_decl
#include "nhl95.h"
#undef SndOpenDriver
#undef SndInit
#undef SndShutdown
#undef LoadMusicBank
#undef LoadSample
#undef FreeSample
#undef SoundCardDlgLoop
#undef SetSoundDevice
#undef LoadDigiFile
#undef PlayDigiBlockLoop

int SetSoundDevice(int dev);
int LoadDigiFile(char *path);  /* sound library: load a song */
void PlayDigiBlockLoop(int song, int handle, int a, int b);  /* sound library: start a song */

int fprintf(void *fp, const char *fmt, ...);  /* Watcom CRT fprintf_ */
int SndOpenDriver(int dev);                       /* sound library: open a driver, -1 on failure */
void SndInit(void);
void SndShutdown(void);
void LoadMusicBank(char *drv, char *port);        /* sound library: driver and port names */
int LoadSample(char *path);                    /* sound library: load a sample */
void FreeSample(int sample);                   /* sound library: free a sample */
typedef struct { char b[0x11]; } SprHdr;

/* SoundCardDlgLoop (8291E, PC only; owner of the SoundCardDlg_epilogue tail SetSoundDevice ends in): run the
   sound card dialog with the mouse pointer (a POINTER block holds the screen under it; sndtempbuf is freed
   first). A click (event bit 2) on an available device that is not the chosen one (SoundCardHitTest: setbits
   bit, sndcardmissing as a dword of available bits) picks it (bits 1-20h). The OK button (40h) stops the music and
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
    bg = AllocMemBlock((char *)str_Pointer21, t, 0);
    *(SprHdr *)bg = *(SprHdr *)pointerspr;
    ((short *)bg)[2] = ((short *)pointerspr)[2] + 1;
    ((short *)bg)[3] = ((short *)pointerspr)[3] + 1;
    if (sndtempbuf) {
        FreeMemBlock(sndtempbuf);
        sndtempbuf = 0;
    }
    MouseRead(&s.ev, &s.mx, &s.my);
    s.x = s.mx;
    s.y = s.my;
    SetScreenTarget();
    GrabBlock(bg, s.x - 4, s.y);
    DrawArt(pointerspr, s.x - 4, s.y);
    ClearInputQueue();
    for (;;) {
        s.ev = 0;
        while ((t = (int)GetInputEvent()) != 0) {
            s.ev = ((int (*)(unsigned char *, int *, int *))ptrupdatefn)((unsigned char *)t, &s.x, &s.y);
            if (s.ev & 6) break;
        }
        if (!(s.ev & 2) && !(s.ev & 4)) {
            if (s.x != s.mx || s.y != s.my) {
                PutBlock(bg, s.mx - 4, s.my);
                GrabBlock(bg, s.x - 4, s.y);
                DrawArt(pointerspr, s.x - 4, s.y);
                s.mx = s.x;
                s.my = s.y;
            }
        } else if (s.ev & 2) {
            PutBlock(bg, s.mx - 4, s.my);
            if (SoundCardHitTest(s.x, s.y, &s.hit)) {
                s.hit = 1 << s.hit;
                if (!(s.hit & setbits[0]) && (s.hit & *(int *)&sndcardmissing)) {
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
                        DrawSelBoxOn((Rect4 *)sndselbox1);
                        SetDialogColors(0xF9, 0xFA, 0xF8, 0xFA, 0xF7);
                        if (musicon && songdata) {
                            SetDigiChannelVolume(musichandle, 3, 0x64);
                            while (!SndQuery(musicslot, 3));
                            PushMemDescriptorLocked(songdata);
                            songdata = 0;
                        }
                        if (SetSoundDevice(setbits[0])) {
                            sounddev = setbits[0];
                            FreeMemBlock(bg);
                            if (musicon && !songdata) {
                                MakePath(s.path, fileoncd[0x1DB] == 1 ? (char *)cddriveptr : 0, (char *)str_Maindesk2, (char *)str_Iff12);
                                t = LoadDigiFile(s.path);
                                songdata = t;
                                if (t && gameopts.music) PlayDigiBlockLoop(t, musichandle, 3, 0x4C);
                            }
                            if (musicon) gameopts.speech = 1;
                            else gameopts.speech = 0;
                            return 0;
                        }
                        *(int *)&sndcardmissing ^= setbits[0];
                        setbits[0] = sounddev;
                        if (musicon && !songdata) {
                            MakePath(s.path, fileoncd[0x1DB] == 1 ? (char *)cddriveptr : 0, (char *)str_Maindesk2, (char *)str_Iff12);
                            t = LoadDigiFile(s.path);
                            songdata = t;
                            if (t && gameopts.music) PlayDigiBlockLoop(t, musichandle, 3, 0x4C);
                        }
                        DrawSelBoxOff((Rect4 *)sndselbox1);
                        break;
                    case 0x80:
                        DrawSelBoxOn((Rect4 *)sndselbox2);
                        FreeMemBlock(bg);
                        return 0;
                    }
                    RedrawSoundCardOpts();
                }
            }
            GrabBlock(bg, s.x - 4, s.y);
            DrawArt(pointerspr, s.x - 4, s.y);
            s.mx = s.x;
            s.my = s.y;
        } else if (s.ev & 4) {
            PutBlock(bg, s.mx - 4, s.my);
            FreeMemBlock(bg);
            return 0;
        } else {
            PutBlock(bg, s.mx - 4, s.my);
            GrabBlock(bg, s.x - 4, s.y);
            DrawArt(pointerspr, s.x - 4, s.y);
            s.mx = s.x;
            s.my = s.y;
        }
    }
}

/* SetSoundDevice (82D7A, PC only): switch the sound to device dev (setbits bits: 1 PC speaker, 2 Sound Blaster,
   4 AdLib, 8 MT-32, 20h Ultrasound, 10h none). Shut the current one down first (speech and its copy buffer for
   2 / 20h, the AdLib sample for 4). Then open dev's music and digital drivers (SndOpenDriver of musicdriver /
   digidriver); on success name them to the sound library, load the AdLib SLAPSHOT sample, play the MT32HOCK
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
    if (SoundDevActive) {
        if (sounddev == 2 || sounddev == 0x20) {
            ShutdownSpeech();
            FreeMemBlock(dword_ED7A8);
            dword_ED7A8 = 0;
        } else if (sounddev == 4) {
            FreeSample(dword_ED7A4);
        }
        SndShutdown();
    }
    cursndbank = 0x20;
    SoundDevActive = 0;
    do {
        switch (dev) {
        case 1:
            strcpy(s.drv, (char *)str_PCBEEP);
            strcpy(s.port, (char *)str_PC);
            musicdriver = 1;
            digidriver = -1;
            crowddriver = 0;
            break;
        case 2:
            strcpy(s.drv, (char *)str_SBDAC);
            strcpy(s.port, (char *)str_PC);
            musicdriver = 2;
            digidriver = 3;
            crowddriver = musicslot = 1;
            break;
        case 4:
            strcpy(s.drv, (char *)str_ADLIB);
            strcpy(s.port, (char *)str_PC);
            musicdriver = 2;
            digidriver = -1;
            crowddriver = 0;
            break;
        case 8:
            strcpy(s.drv, (char *)str_MT322);
            strcpy(s.port, (char *)str_PC);
            musicdriver = 4;
            digidriver = -1;
            crowddriver = 0;
            break;
        case 0x20:
            strcpy(s.drv, (char *)str_SBDAC2);
            strcpy(s.port, (char *)str_PC);
            musicdriver = 5;
            digidriver = 6;
            crowddriver = musicslot = 1;
            break;
        default:
            strcpy(s.drv, (char *)str_PCBEEP2);
            strcpy(s.port, (char *)str_PC);
            musicdriver = 0;
            digidriver = -1;
            crowddriver = 0;
            break;
        }
        SndInit();
        if (musicdriver >= 0 && (h1 = SndOpenDriver(musicdriver)) != -1) {
            if (digidriver < 0) SoundDevActive = -1;
            else if ((s.h2 = SndOpenDriver(digidriver)) != -1) SoundDevActive = -1;
        }
        if (SoundDevActive) {
            LoadMusicBank(s.drv, s.port);
            if (dev == 4) {
                MakePath(s.path, fileoncd[0x18F] == 1 ? (char *)cddriveptr : 0, (char *)str_Slapshot, 0);
                dword_ED7A4 = LoadSample(s.path);
            }
            if (dev == 8 && !PcSpkSampleReady) {
                MessageBox(-1, -1, (char *)msg_InitMT32, 2, 0, 0, (int)&s.x, (int)&s.y, 0);
                MakePath(s.path, fileoncd[0xF7] == 1 ? (char *)cddriveptr : 0, (char *)str_MT32HOCK, 0);
                t = LoadSample(s.path);
                PcSpkSampleReady = -1;
                sounddev = 8;
                PlayDigiSample((void *)t);
                WaitDigiSample();
                FreeSample(t);
                RestoreDialogBg();
            }
            sounddev = dev;
            crowddriver = crowddriver ? s.h2 : h1;
            musicslot = s.h2;
            setbits[0] = sounddev;
            MakePath(s.path, 0, (char *)str_NHL3, (char *)str_CFG);
            fp = fopen(s.path, (char *)str_R4);
            if (!fp) FatalError((char *)str_CantOpenNhlCfg);
            i = 0;
            while (dev != sounddevids[i]) i++;
            fprintf(fp, (char *)str_04x, i);
            fclose(fp);
            if (sounddev == 2 || sounddev == 0x20) {
                musicon = 1;
                musichandle = digidriver;
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
                MouseRead(&s.btn, &s.x, &s.y);
                MessageBox(-1, -1, (char *)msg_NoSoundCard, 3, 0, 0, (int)&s.x, (int)&s.y, 0);
                do {
                    if ((e = GetInputEvent()) != 0)
                        s.ev = ((int (*)(unsigned char *, int *, int *))ptrupdatefn)(e, &s.x, &s.y);
                } while (!(s.ev & 2));
                RestoreDialogBg();
                dev = 0x10;
            } else {
                SoundDevActive = -1;
            }
            SndShutdown();
            SetTickDeadline(0x64);
            WaitTickDeadline();
        }
    } while (!SoundDevActive);
    if (sounddev == 2 || sounddev == 0x20) {
        dword_ED7A8 = AllocMemBlock((char *)str_Emmcopybuf, 0x400, 0x20);
        InitSpeech(musicslot, dword_C4CFC, dword_ED7A8, 0x400);
    }
    cursndbank = 0;
    return 1;
}
