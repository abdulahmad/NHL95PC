/* Asm helpers: the CD movie player. */
#define PlayMVI PlayMVI_decl
#define CdStreamCreate sub_1B0F3_decl
#define CdStreamOpen sub_1B1C2_decl
#define CmvCreate sub_1AC25_decl
#define TickDeadlinePassed TickDeadlinePassed_decl
#define CdStreamService sub_1B2A7_decl
#define CdStreamNextChunk sub_1B8AC_decl
#define CmvDecodeFrame sub_1B002_decl
#define CmvReadHeader sub_1AD16_decl
#define CmvFrameCount sub_1B092_decl
#define CmvPalette sub_1B0E5_decl
#define CmvPaletteCount sub_1B0D7_decl
#define CmvPaletteFirst sub_1B0C9_decl
#define CmvFrameRate sub_1B0BB_decl
#define CdStreamReleaseChunk sub_1B92E_decl
#define CmvDestroy sub_1ACF1_decl
#define CdStreamClose sub_1B18B_decl
#define PlayDigiBlockLoop sub_8FB8E_decl
#define GetTicks GetTicks_decl
#include "nhl95.h"
#undef GetTicks
#undef PlayMVI
#undef CdStreamCreate
#undef CdStreamOpen
#undef CmvCreate
#undef TickDeadlinePassed
#undef CdStreamService
#undef CdStreamNextChunk
#undef CmvDecodeFrame
#undef CmvReadHeader
#undef CmvFrameCount
#undef CmvPalette
#undef CmvPaletteCount
#undef CmvPaletteFirst
#undef CmvFrameRate
#undef CdStreamReleaseChunk
#undef CmvDestroy
#undef CdStreamClose
#undef PlayDigiBlockLoop

int __cdecl CdStreamCreate(int size, int chunk, int flags);  /* cdstream: create a reader */
void __cdecl CdStreamOpen(int stream, char *path);         /* cdstream: open a file */
int CmvCreate(void);                                    /* cmv_player: create a decoder */
int TickDeadlinePassed(void);
void CdStreamService(void);                                   /* cdstream: service the reader */
int __cdecl CdStreamNextChunk(int stream);                      /* cdstream: next chunk, 0 none yet, -1 at the end */
int CmvDecodeFrame(int dec, int chunk);                      /* cmv_player: decode a frame */
void CmvReadHeader(int dec, int chunk);
int CmvFrameCount(int dec);
int CmvPalette(int dec);
int CmvPaletteCount(int dec);
int CmvPaletteFirst(int dec);
int CmvFrameRate(int dec);
void __cdecl CdStreamReleaseChunk(int stream, int chunk);          /* cdstream: release a chunk */
void CmvDestroy(int dec);
void __cdecl CdStreamClose(int stream);
void PlayDigiBlockLoop(int song, int handle, int a, int b);
int __cdecl GetTicks(void);                              /* timer library (stack arguments, as SetTickDeadline) */

/* PlayMVI (8BEDB, PC only): play the movie file path at x / y through the cdstream reader (493E0h-byte buffer,
   2000h chunks) and the cmv_player decoder, after letting the reader prime for 96h ticks. Per chunk: 'MVIh'
   sets up the decoder, clears the 228 x 176 picture, loads its palette and the frame delay (100 / rate);
   'MVIf' decodes a frame (not the last) and draws it unless it is late, the first one also starting the song
   (when music is on) and the clock, then waits for the frame's time; 'MVIe' counts the end marks (three
   stop); anything else stops. A key or click stops too. Afterwards, with music on, wait on the song's slot
   (SndQuery; WaitClickTimeout cuts it short) and set the song to 50h. Result: the key that stopped it, -1 at
   the end of the file, else 0. */
int PlayMVI(char *path, int x, int y)
{
    int frame;
    int nframes;
    int stream;
    int chunk;
    unsigned id;
    int delay;
    int bad;
    int t0;
    int ends;
    int due;
    int key;
    int dec;
    int n;
    int el;

    ClearInputQueue();
    SetScreenTarget();
    stream = CdStreamCreate(0x493E0, 0x2000, 0x20);
    CdStreamOpen(stream, path);
    dec = CmvCreate();
    SetTickDeadline(0x96);
    while (!TickDeadlinePassed()) CdStreamService();
    delay = 10;
    nframes = n = 0;
    GetTicks();
    key = 0;
    bad = 0;
    due = 0;
    t0 = GetTicks();
    ends = 0;
    CdStreamService();
    do {
        chunk = CdStreamNextChunk(stream);
        if (chunk == -1) {
            key = chunk;
        } else if (chunk) {
            switch (id = ReadBE32((signed char *)chunk)) {
            case 0x4D564966:
                if (n > 1) {
                    due += delay;
                    frame = CmvDecodeFrame(dec, chunk);
                    if (GetTicks() - t0 < due) DrawArtOpaque(frame, x, y);
                    if (!ends && n == nframes) {
                        if (musicon && songdata) PlayDigiBlockLoop(songdata, musichandle, 3, 0x7F);
                        t0 = GetTicks();
                    }
                    n--;
                }
                break;
            case 0x4D564968:
                CmvReadHeader(dec, chunk);
                nframes = n = CmvFrameCount(dec);
                FillRect(x, y, 0xE4, 0xB0, 0);
                VgaSetPalette(CmvPaletteFirst(dec), CmvPaletteCount(dec), (unsigned char *)CmvPalette(dec));
                delay = 100 / CmvFrameRate(dec);
                break;
            case 0x4D564965:
                ends++;
                break;
            default:
                bad = 1;
                break;
            }
            CdStreamReleaseChunk(stream, chunk);
            CdStreamService();
            if (id == 0x4D564966 && (el = GetTicks() - t0) < due) {
                SetTickDeadline(due - el);
                while (!TickDeadlinePassed() && !key) key = AnyInputPressed();
            }
        } else {
            CdStreamService();
        }
        if (!key) key = AnyInputPressed();
    } while (!key && !bad && ends != 3);
    CmvDestroy(dec);
    CdStreamClose(stream);
    if (musicon && songdata) {
        while (!key && !SndQuery(musicslot, 3)) key = WaitClickTimeout(10);
        SetDigiChannelVolume(musichandle, 3, 0x50);
    }
    return key;
}
