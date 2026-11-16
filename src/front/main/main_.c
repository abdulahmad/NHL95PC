/* Main / startup: the program entry. */
#define SetupMemoryPoolReserve sub_8DF54_decl
#define InstallTimer InstallTimer_decl
#define InstallBreakHandler sub_B3036_decl
#define subwindowdefadr sub_8E7A0_decl
#define InitZoneManager sub_6A9CE_decl
#define LoadNhlCfg LoadNhlCfg_decl
#define RunIntro RunIntro_decl
#define CalibrateJoystick sub_B30F4_decl
#define JoyResetCentres sub_B33DB_decl
#define MainDeskLoop MainDeskLoop_decl
#include "nhl95.h"
#undef SetupMemoryPoolReserve
#undef InstallTimer
#undef InstallBreakHandler
#undef subwindowdefadr
#undef InitZoneManager
#undef LoadNhlCfg
#undef RunIntro
#undef CalibrateJoystick
#undef JoyResetCentres
#undef MainDeskLoop

typedef struct {
    unsigned eax, ebx, ecx, edx, esi, edi, cflag;
} DwordRegs;

typedef struct {
    unsigned char hour, minute, second, hsecond;
} DosTime;

void _dos_getdrive(unsigned *drive);           /* Watcom CRT _dos_getdrive_ */
int printf(const char *fmt, ...);              /* Watcom CRT printf_ */
void exit(int status);                         /* Watcom CRT exit_ */
int int386(int no, DwordRegs *in, DwordRegs *out);  /* Watcom CRT int386_ */
void _dos_gettime(DosTime *t);                 /* Watcom CRT _dos_gettime_ */
void srand(unsigned seed);                     /* Watcom CRT srand_ */
void __cdecl SetupMemoryPoolReserve(int a, int b);          /* memory library: set up */
void InstallTimer(void);
void __cdecl InstallBreakHandler(int (*fn)(void));       /* DOS critical error handler */
int __cdecl subwindowdefadr(void *buf, int a, int w, int h, int flags);
void InitZoneManager(int n);
void LoadNhlCfg(void);
void RunIntro(void);
int CalibrateJoystick(void);
void __cdecl JoyResetCentres(int n);
void MainDeskLoop(void);

typedef struct {
    unsigned short total_clusters;
    unsigned short avail_clusters;
    unsigned short sectors_per_cluster;
    unsigned short bytes_per_sector;
} DiskFree;

/* main_x is its epilogue. */
/* main_ (10094, PC only; Watcom's main, named main_ here because this build does not decorate names): check
   there is room on drive C (2 KB, when not running from C) and on the current drive (two clusters' worth), and
   that there is enough memory (1E5D70h bytes, or 200B20h with 7F800h of DOS memory from DPMI 100h); size the
   speech buffer by the memory; set up the video mode, the timer and input sampling (SampleInputTick), the mouse,
   the critical error handler, the file locations, the 320 x 200 screen bitmap, the pointer and the four fonts;
   load the mode state, NHL.CFG and play the intro; calibrate the joysticks that need it; read GAMESET (else
   default the controllers: the first available of left joystick, right joystick, keyboard, mouse, none) and
   load the mode state; seed rand from the clock and run the main desk. Then fade out (TEMP palette), stop the
   music, show the loading screen and the credits, and leave through bailout_vec. */
void main_(void)
{
    struct {
        DwordRegs out;
        DwordRegs in;
        char path[0x14];
        DiskFree df;
        unsigned drive;
        unsigned mem[4];
        int fh;
        DosTime t;
    } s;
    int bps;
    int spc;
    int need;
    int dosmem;
    int pal;
    int r;

    _dos_getdrive(&s.drive);
    if (s.drive != 2 && (int)DiskFreeBytes(3) < 0x800) {
        printf((char *)str_NoDiskSpaceC);
        exit(0);
    }
    if (_dos_getdiskfree(0, &s.df)) FatalError((char *)str_ErrDiskFree2);
    spc = s.df.sectors_per_cluster;
    bps = s.df.bytes_per_sector;
    need = (spc * bps + 0x3FF) / 1024;
    need = (need + 7) / need + 1;
    if (s.df.avail_clusters < need) {
        printf((char *)str_NoDiskSpaceCur, (need * spc * bps + 0x3FF) / 1024);
        exit(0);
    }
    *(unsigned short *)&s.in.eax = 0x100;
    *(unsigned short *)&s.in.ebx = 0xA000;
    r = int386(0x31, &s.in, &s.out);   /* the result held in r, then the paragraph count (r in eax, as in the EXE) */
    r = (unsigned short)s.out.ebx;
    dosmem = r << 4;
    SetupMemoryPoolReserve(0xC8, 0x19000);
    GetMemStats(&s.mem[3], &s.mem[2], &s.mem[1], &s.mem[0]);
    if (s.mem[3] < 0x1E5D70) {
        printf((char *)str_NoMemory);
        printf((char *)str_CheckRefCard);
        exit(0);
    }
    if (s.mem[3] < 0x200B20 && dosmem < 0x7F800) {
        printf((char *)str_NoConvMemory);
        printf((char *)str_CheckRefCard2);
        exit(0);
    }
    if (s.mem[3] > 0x3EF000) SpeechSlotMemSize = 0xC3500;
    else SpeechSlotMemSize = 0x30D40;
    initgraphics(0x280, 0x1E0);
    InstallTimer();
    joysampling = 0;
    addtimer(SampleInputTick);
    ctlavailmask |= 8;
    if (InitMouse()) ctlavailmask |= 1;
    InputInstall();
    ((void (*)(void))mousepollfn)();
    InstallBreakHandler(CritErrHandler);
    InitFileLocations();
    SetScreenSize(0x140, 0xC8);
    screenbm = subwindowdefadr(&BackBufferWidth, 0, 0xA8, 0x140, 0x20);
    SetScreenSize(0x280, 0x1E0);
    InitZoneManager(0x64);
    MakePath(s.path, fileoncd[0x13A] == 1 ? (char *)cddriveptr : 0, (char *)str_Pointer3, 0);
    pntrshapes = LoadBank(s.path, 0);
    pointerspr = FindShape(pntrshapes, (char *)str_Pntr);
    MakePath(s.path, fileoncd[0x162] == 1 ? (char *)cddriveptr : 0, (char *)str_S1, (char *)str_VFN);
    mainfont = s1font = OpenArtArchiveErr(s.path, 0x20);
    MakePath(s.path, fileoncd[0x169] == 1 ? (char *)cddriveptr : 0, (char *)str_Scor2b, (char *)str_VFN);
    scor2font = OpenArtArchiveErr(s.path, 0x20);
    MakePath(s.path, fileoncd[0x16A] == 1 ? (char *)cddriveptr : 0, (char *)str_Scor3b, (char *)str_VFN);
    scor3font = OpenArtArchiveErr(s.path, 0x20);
    MakePath(s.path, fileoncd[0x1C4] == 1 ? (char *)cddriveptr : 0, (char *)str_Kaufm020, (char *)str_VFN);
    kaufmfont = OpenArtArchiveErr(s.path, 0x20);
    TextSetFont(s1font);
    LoadModeState(exhstate);
    LoadNhlCfg();
    RunIntro();
    s.drive = CalibrateJoystick();
    JoyResetCentres(((JoyPortMask & 0xF) == 0xF) + 1);
    if ((JoyPortMask & 3) && (JoyRawX1 || JoyRawY1)) {
        JoystickCalScreen(1, 0, 0, (char *)str_ConfigureLeftJoystick);
        if (joyenablemask & 1) {
            ctlavailmask |= 2;
            joypresent[0] = 1;
        }
    }
    if ((JoyPortMask & 0xC) && (JoyRawX2 || JoyRawY2)) {
        JoystickCalScreen(2, 8, 1, (char *)str_ConfigureRightJoystick);
        if (joyenablemask & 2) {
            ctlavailmask |= 4;
            joypresent[1] = 1;
        }
    }
    if (!FileOpenRead((char *)str_GameSet2, &s.fh)) {
        if (FileReadAt(s.fh, exhstate, -1, 0x75)) FatalError((char *)str_errd3);
        if (FileClose(&s.fh)) FatalError((char *)str_errd4);
    } else {
        if (ctlavailmask & 2) *(int *)(exhstate + 0x65) = 2;
        else if (ctlavailmask & 4) *(int *)(exhstate + 0x65) = 4;
        else if (ctlavailmask & 8) *(int *)(exhstate + 0x65) = 8;
        else if (ctlavailmask & 1) *(int *)(exhstate + 0x65) = 1;
        else *(int *)(exhstate + 0x65) = 0x10;
        *(int *)(exhstate + 0x69) = 0x10;
        *(int *)(exhstate + 0x6D) = 0;
        *(int *)(exhstate + 0x71) = 1;
        if (*(int *)(exhstate + 0x65) != 0x10) *(int *)(exhstate + 0x5D) = 0xC;
        else *(int *)(exhstate + 0x5D) = -1;
        *(int *)(exhstate + 0x61) = -2;
    }
    LoadModeState(exhstate);
    ShowLoadingScreen();
    _dos_gettime(&s.t);
    srand(s.t.hsecond);
    MainDeskLoop();
    pal = AllocMemBlock((char *)str_Temp3, 0x300, 0x20);
    if (MusicOn && songdata) SetDigiChannelVolume(musichandle, 3, 0x64);
    SetPalette(0, 0x100, (unsigned char *)pal);
    FadePalStep(1, (unsigned char *)pal, 0x10);
    if (MusicOn && songdata) {
        while (!SndQuery(musicslot, 3));
        PushMemDescriptorLocked(songdata);
        songdata = 0;
    }
    ShowLoadingScreen();
    InputInstall();
    ShowCredits();
    SetTextMode();
    ((void (*)(void))bailout_vec)();
}
