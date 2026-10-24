/* Rink tiles: loading the rink. */
#define sub_8DBC0 sub_8DBC0_decl
#define sub_92EE4 sub_92EE4_decl
#define sub_6A0F6 sub_6A0F6_decl
#define sub_6A156 sub_6A156_decl
#define sub_6A106 sub_6A106_decl
#define sub_6AD4F sub_6AD4F_decl
#define sub_6AF52 sub_6AF52_decl
#define sub_6AF97 sub_6AF97_decl
#include "nhl95.h"
#undef sub_8DBC0
#undef sub_92EE4
#undef sub_6A0F6
#undef sub_6A156
#undef sub_6A106
#undef sub_6AD4F
#undef sub_6AF52
#undef sub_6AF97

int __cdecl sub_8DBC0(int blk);              /* memory library: block size */
int __cdecl sub_92EE4(char *path, int buf);  /* file library: load a file into buf */
void sub_6A0F6(int bm);
void sub_6A156(int bm);
void sub_6A106(void);
void sub_6AD4F(void);
void sub_6AF52(int x, int y, int w, int h);
void sub_6AF97(int x, int y);

typedef struct {
    unsigned type:8;
    unsigned rest:24;
    short w;
    short h;
    short x0;
    short y0;
    short x1;
    short y1;
} Shape;

#define SHAPE(bm) (*(Shape **)((bm) + 0x2C))
#define ARENA(o, f) (*(short *)(rinkarenas + (o) + (f)))

/* LoadRink (3377C, PC only): set up the rink bitmaps for arena rink. Free rinkbm / rinktilebm unless they are
   37840h-byte blocks, and create rinktilebm (180h x 250h) if needed (currink -1). For a new rink draw the RINK
   art into rinktilebm (74 x 48 tiles), load the arena's .TIL tiles (a multiple of 64 bytes; fatal otherwise or
   when unreadable) and .MAP bank (from the CD when fileoncd says so) and blit the map at the arena's first and,
   when its x is positive, second spot (flags 6000h); free both and remember the rink. Then give both bitmaps'
   shapes the rink's pixel size and a clear header, create rinkbm if needed, set the background / pixel scroll
   for the rink's centre and hand the bitmaps to the display (sub_6A033 180h, the 180h x 250h view, sub_6A033 1). */
void LoadRink(int rink)
{
    char path[0x10];
    int smap;
    int t;  /* one scratch variable: the RINK bank, rink * 12, the .TIL size, the bitmaps, the scroll (esi) */
    short size;
    short n;
    int tiles;

    if (rinkbm && sub_8DBC0(rinkbm) != 0x37840) {
        FreeMemBlock(rinkbm);
        rinkbm = 0;
    }
    if (rinktilebm && sub_8DBC0(rinktilebm) != 0x37840) {
        FreeMemBlock(rinktilebm);
        rinktilebm = 0;
    }
    if (!rinktilebm) {
        rinktilebm = sub_B4F8C(0x180, 0x250, 0);
        currink = -1;
    }
    if (rink != currink) {
        MakePath(path, fileoncd[0x15B] == 1 ? (char *)cddriveptr : 0, (char *)str_Rink2, 0);
        t = sub_8E83C(path, 0);
        rinkhtiles = 0x4A;
        rinkwtiles = 0x30;
        SetDrawBitmap(rinktilebm);
        sub_913B4(sub_B30B4(t, (char *)str_Rink2));
        FreeMemBlock(t);
        MakePath(path, fileoncd[rinkfileidx[rink] + 1] == 1 ? (char *)cddriveptr : 0, (char *)rinkarenas + (t = rink * 12), (char *)str_Til);
        size = sub_92DE0(path);
        t = size;
        if (t % 64) FatalError((char *)str_InvalidFileSize, path, t);
        tiles = sub_8CCA8((char *)str_TILES, size, 0);
        if (!sub_92EE4(path, tiles)) FatalError((char *)str_ErrorLoadingFile, path);
        MakePath(path, fileoncd[rinkfileidx[rink]] == 1 ? (char *)cddriveptr : 0, (char *)rinkarenas + (t = rink * 12), (char *)str_Map);
        smap = sub_8E8A0(path, 0);
        n = size / 64;
        BlitTileMap((unsigned char *)smap, (unsigned char *)tiles, n, ARENA(t, 6), ARENA(t = rink * 12, 4), 0);
        if (ARENA(t, 8) > 0) BlitTileMap((unsigned char *)smap, (unsigned char *)tiles, n, ARENA(t, 0xA), ARENA(t, 8), 0x6000);
        FreeMemBlock(smap);
        FreeMemBlock(tiles);
        currink = rink;
    }
    SHAPE(rinktilebm)->w = rinkwtiles << 3;
    SHAPE(rinktilebm)->h = rinkhtiles << 3;
    t = rinktilebm;
    n = 0;
    SHAPE(t)->type = n;
    SHAPE(t)->rest = n;
    SHAPE(rinktilebm)->x0 = SHAPE(rinktilebm)->y0 = SHAPE(rinktilebm)->x1 = SHAPE(rinktilebm)->y1 = 0;
    if (!(t = rinkbm)) rinkbm = sub_B4F8C(0x180, 0x250, t);
    SHAPE(rinkbm)->w = rinkwtiles << 3;
    SHAPE(rinkbm)->h = rinkhtiles << 3;
    t = rinkbm;
    n = 0;
    SHAPE(t)->type = n;
    SHAPE(t)->rest = n;
    SHAPE(rinkbm)->x0 = SHAPE(rinkbm)->y0 = SHAPE(rinkbm)->x1 = SHAPE(rinkbm)->y1 = 0;
    t = rinkhtiles * 4 - 0x3C;
    bgscrolly = t / 8;
    scrolly = t % 8;
    t = rinkwtiles * 4;
    bgscrollx = t / 8 - 0x14;
    scrollx = t % 8;
    sub_6A033(0x180);
    sub_6AF97(0, 0);
    sub_6AF52(0, 0, 0x180, 0x250);
    sub_6A0F6(rinkbm);
    sub_6A156(rinktilebm);
    sub_6A033(1);
    sub_6A106();
    sub_6AD4F();
}
