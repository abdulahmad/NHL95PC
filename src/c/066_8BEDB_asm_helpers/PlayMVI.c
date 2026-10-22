/* Asm helpers: the CD movie player. */
#define PlayMVI PlayMVI_decl
#define sub_1B0F3 sub_1B0F3_decl
#define sub_1B1C2 sub_1B1C2_decl
#define sub_1AC25 sub_1AC25_decl
#define TickDeadlinePassed TickDeadlinePassed_decl
#define sub_1B2A7 sub_1B2A7_decl
#define sub_1B8AC sub_1B8AC_decl
#define sub_1B002 sub_1B002_decl
#define sub_1AD16 sub_1AD16_decl
#define sub_1B092 sub_1B092_decl
#define sub_1B0E5 sub_1B0E5_decl
#define sub_1B0D7 sub_1B0D7_decl
#define sub_1B0C9 sub_1B0C9_decl
#define sub_1B0BB sub_1B0BB_decl
#define sub_1B92E sub_1B92E_decl
#define sub_1ACF1 sub_1ACF1_decl
#define sub_1B18B sub_1B18B_decl
#define sub_8FB8E sub_8FB8E_decl
#include "nhl95.h"
#undef PlayMVI
#undef sub_1B0F3
#undef sub_1B1C2
#undef sub_1AC25
#undef TickDeadlinePassed
#undef sub_1B2A7
#undef sub_1B8AC
#undef sub_1B002
#undef sub_1AD16
#undef sub_1B092
#undef sub_1B0E5
#undef sub_1B0D7
#undef sub_1B0C9
#undef sub_1B0BB
#undef sub_1B92E
#undef sub_1ACF1
#undef sub_1B18B
#undef sub_8FB8E

int __cdecl sub_1B0F3(int size, int chunk, int flags);  /* cdstream: create a reader */
void __cdecl sub_1B1C2(int stream, char *path);         /* cdstream: open a file */
int sub_1AC25(void);                                    /* cmv_player: create a decoder */
int TickDeadlinePassed(void);
void sub_1B2A7(void);                                   /* cdstream: service the reader */
int __cdecl sub_1B8AC(int stream);                      /* cdstream: next chunk, 0 none yet, -1 at the end */
int sub_1B002(int dec);                                 /* cmv_player: decode a frame */
void sub_1AD16(int dec);
int sub_1B092(int dec);
int sub_1B0E5(int dec);
int sub_1B0D7(int dec);
int sub_1B0C9(int dec);
int sub_1B0BB(int dec);
void __cdecl sub_1B92E(int stream, int chunk);          /* cdstream: release a chunk */
void sub_1ACF1(int dec);
void __cdecl sub_1B18B(int stream);
void sub_8FB8E(int song, int handle, int a, int b);

/* DRAFT: 725 vs 732 under 10.0 GA (23 differing); see docs/UNSURE.md. */
/* PlayMVI (8BEDB, PC only): play the movie file path at x / y through the cdstream reader (493E0h-byte buffer,
   2000h chunks) and the cmv_player decoder, after letting the reader prime for 96h ticks. Per chunk: 'MVIh'
   sets up the decoder, clears the 228 x 176 picture, loads its palette and the frame delay (100 / rate);
   'MVIf' decodes a frame (not the last) and draws it unless it is late, the first one also starting the song
   (when music is on) and the clock, then waits for the frame's time; 'MVIe' counts the end marks (three
   stop); anything else stops. A key or click stops too. Afterwards, with music on, wait on the song's slot
   (sub_8FC8A; WaitClickTimeout cuts it short) and set the song to 50h. Result: the key that stopped it, -1 at
   the end of the file, else 0. */
int PlayMVI(char *path, int x, int y)
{
    struct {
        int frame;
        int chunk;
        unsigned id;
        int delay;
        int nframes;
        int y;
        int x;
        int bad;
        int stream;
        int t0;
        int ends;
        int due;
    } s;
    int key;
    int dec;
    int n;
    int el;

    s.x = x;
    s.y = y;
    ClearInputQueue();
    sub_B4BA8();
    s.stream = sub_1B0F3(0x493E0, 0x2000, 0x20);
    sub_1B1C2(s.stream, path);
    dec = sub_1AC25();
    SetTickDeadline(0x96);
    while (!TickDeadlinePassed()) sub_1B2A7();
    s.delay = 10;
    s.nframes = n = 0;
    GetTicks();
    key = 0;
    s.bad = 0;
    s.due = 0;
    s.t0 = GetTicks();
    s.ends = 0;
    sub_1B2A7();
    do {
        s.chunk = sub_1B8AC(s.stream);
        if (s.chunk == -1) {
            key = s.chunk;
        } else if (s.chunk) {
            switch (s.id = ReadBE32((signed char *)s.chunk)) {
            case 0x4D564966:
                if (n > 1) {
                    s.due += s.delay;
                    s.frame = sub_1B002(dec);
                    if (GetTicks() - s.t0 < s.due) sub_910E0(s.frame, s.x, s.y);
                    if (!s.ends && n == s.nframes) {
                        if (musicon && (el = songdata) != 0) sub_8FB8E(el, musichandle, 3, 0x7F);
                        s.t0 = GetTicks();
                    }
                    n--;
                }
                break;
            case 0x4D564968:
                sub_1AD16(dec);
                s.nframes = n = sub_1B092(dec);
                sub_90D20(s.x, s.y, 0xE4, 0xB0, 0);
                sub_B4B88(sub_1B0C9(dec), sub_1B0D7(dec), (unsigned char *)sub_1B0E5(dec));
                s.delay = 100 / sub_1B0BB(dec);
                break;
            case 0x4D564965:
                s.ends++;
                break;
            default:
                s.bad = 1;
                break;
            }
            sub_1B92E(s.stream, s.chunk);
            sub_1B2A7();
            if (s.id == 0x4D564966 && (el = GetTicks() - s.t0) < s.due) {
                SetTickDeadline(s.due - el);
                while (!TickDeadlinePassed() && !key) key = AnyInputPressed();
            }
        } else {
            sub_1B2A7();
        }
        if (!key) key = AnyInputPressed();
    } while (!key && !s.bad && s.ends != 3);
    sub_1ACF1(dec);
    sub_1B18B(s.stream);
    if (musicon && songdata) {
        while (!key && !sub_8FC8A(musicslot, 3)) key = WaitClickTimeout(10);
        sub_8FCDF(musichandle, 3, 0x50);
    }
    return key;
}
