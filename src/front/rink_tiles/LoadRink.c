/* Rink tiles: loading the rink. */
#define MemPtrSize sub_8DBC0_decl
#define LoadFileToBlockShared sub_92EE4_decl
#define SetHiddenWindow sub_6A0F6_decl
#define SetBackgroundWindow sub_6A156_decl
#define SelectHiddenWindow sub_6A106_decl
#define EraseZones sub_6AD4F_decl
#define SetZoneScreen sub_6AF52_decl
#define SetZoneOrigin sub_6AF97_decl
#include "nhl95.h"
#undef MemPtrSize
#undef LoadFileToBlockShared
#undef SetHiddenWindow
#undef SetBackgroundWindow
#undef SelectHiddenWindow
#undef EraseZones
#undef SetZoneScreen
#undef SetZoneOrigin

int __cdecl MemPtrSize(int blk);              /* memory library: block size */
int __cdecl LoadFileToBlockShared(char *path, int buf);  /* file library: load a file into buf */
void SetHiddenWindow(int bm);
void SetBackgroundWindow(int bm);
void SelectHiddenWindow(void);
void EraseZones(void);
void SetZoneScreen(int x, int y, int w, int h);
void SetZoneOrigin(int x, int y);

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
   for the rink's centre and hand the bitmaps to the display (SetZoneFlags 180h, the 180h x 250h view, SetZoneFlags 1). */
void LoadRink(int rink)
{
    char path[0x10];
    int smap;
    int t;  /* one scratch variable: the RINK bank, rink * 12, the .TIL size, the bitmaps, the scroll (esi) */
    short size;
    short n;
    int tiles;

    if (rinkbm && MemPtrSize(rinkbm) != 0x37840) {
        FreeMemBlock(rinkbm);
        rinkbm = 0;
    }
    if (rinktilebm && MemPtrSize(rinktilebm) != 0x37840) {
        FreeMemBlock(rinktilebm);
        rinktilebm = 0;
    }
    if (!rinktilebm) {
        rinktilebm = CreateBitmap(0x180, 0x250, 0);
        currink = -1;
    }
    if (rink != currink) {
        MakePath(path, fileoncd[0x15B] == 1 ? (char *)cddriveptr : 0, (char *)str_Rink2, 0);
        t = LoadBank(path, 0);
        rinkhtiles = 0x4A;
        rinkwtiles = 0x30;
        SetDrawBitmap(rinktilebm);
        DrawShape(FindShape(t, (char *)str_Rink2));
        FreeMemBlock(t);
        MakePath(path, fileoncd[rinkfileidx[rink] + 1] == 1 ? (char *)cddriveptr : 0, (char *)rinkarenas + (t = rink * 12), (char *)str_Til);
        size = GetFileSize(path);
        t = size;
        if (t % 64) FatalError((char *)str_InvalidFileSize, path, t);
        tiles = AllocMemBlock((char *)str_TILES, size, 0);
        if (!LoadFileToBlockShared(path, tiles)) FatalError((char *)str_ErrorLoadingFile, path);
        MakePath(path, fileoncd[rinkfileidx[rink]] == 1 ? (char *)cddriveptr : 0, (char *)rinkarenas + (t = rink * 12), (char *)str_Map);
        smap = OpenArtArchiveErr(path, 0);
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
    if (!(t = rinkbm)) rinkbm = CreateBitmap(0x180, 0x250, t);
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
    SetZoneFlags(0x180);
    SetZoneOrigin(0, 0);
    SetZoneScreen(0, 0, 0x180, 0x250);
    SetHiddenWindow(rinkbm);
    SetBackgroundWindow(rinktilebm);
    SetZoneFlags(1);
    SelectHiddenWindow();
    EraseZones();
}
