/* Front end: drawing a sprite. */
/* DRAFT (10.0 GA): 78 -> 66 differing, 675 vs 678 bytes. Integer coordinate/flip
   inputs, a short intermediate for mirrored x, and short edges updated in steps give
   the EXE's 16-bit edge arithmetic. Declaring i before r also leaves pal in memory.
   Left: mode/clip/remap register choices and the first flip test's cached value. */
#define DrawSprite DrawSprite_decl
#define MarkZoneRect sub_6AB7C_decl
#define VgaBlitKeyedHot sub_B4CD8_decl
#define VgaBlitKeyedFlipV sub_B500C_decl
#define VgaBlitRemap sub_B4E50_decl
#define VgaBlitRemapFlipV sub_B52B4_decl
#define VgaBlitKeyedFlipH sub_B5584_decl
#define VgaBlitKeyedFlipHV sub_B56B8_decl
#define VgaBlitRemapFlipH sub_B5974_decl
#define VgaBlitRemapFlipHV sub_B5AC8_decl
#include "nhl95.h"
#undef DrawSprite
#undef MarkZoneRect
#undef VgaBlitKeyedHot
#undef VgaBlitKeyedFlipV
#undef VgaBlitRemap
#undef VgaBlitRemapFlipV
#undef VgaBlitKeyedFlipH
#undef VgaBlitKeyedFlipHV
#undef VgaBlitRemapFlipH
#undef VgaBlitRemapFlipHV

typedef struct {
    int flags : 8;
    int : 24;
    short w;
    short h;
    short xoff;
    short yoff;
} SprHdr;

void MarkZoneRect(int n, int x0, int y0, int x1, int y1);
void __cdecl VgaBlitKeyedHot(SprHdr *s, int x, int y);
void __cdecl VgaBlitKeyedFlipV(SprHdr *s, int x, int y);
void __cdecl VgaBlitRemap(SprHdr *s, int x, int y);
void __cdecl VgaBlitRemapFlipV(SprHdr *s, int x, int y);
void __cdecl VgaBlitKeyedFlipH(SprHdr *s, int x, int y);
void __cdecl VgaBlitKeyedFlipHV(SprHdr *s, int x, int y);
void __cdecl VgaBlitRemapFlipH(SprHdr *s, int x, int y);
void __cdecl VgaBlitRemapFlipHV(SprHdr *s, int x, int y);

/* DrawSprite (1CD73, PC only): draw sprite spr with its hot spot (+8h / +0Ah) at x, y, mirrored when flip. Nothing
   is drawn when it lies wholly outside cliprect; it is clipped when it crosses it. With pal not negative the
   colour remap (SetColorRemap, awayremap for pal, else homeremap) is loaded unless it is already the current one
   (lastsprremap = pal + flip * 2); mirrored, the remap's 16-byte groups are flipped (bytes 0/4 and 1/3) around
   the load. The rectangle is recorded (MarkZoneRect, spritedrawcount), and if the sprite's flag byte is set one of
   eight blitters draws it (clipped / remapped / mirrored). spr: the sprite header; unused: not read. */
void DrawSprite(SprHdr *spr, int x, int y, int flip, short pal, int unused)
{
    struct {
        unsigned char t2[8];
        unsigned char t1[8];
        int mode;
        short sx;
        short pad1;
        short flip;
        short pad2;
        short sy;
    } s;
    short x1;
    short y1;
    int i;
    int r;
    unsigned char *p;

    s.flip = flip;
    s.mode = 0;
    if (s.flip) {
        x1 = x;
        x1 -= spr->w;
        s.sx = x1 + spr->xoff + 1;
    }
    else s.sx = x - spr->xoff;
    s.sy = y - spr->yoff;
    x1 = s.sx;
    x1 += spr->w;
    x1--;
    y1 = s.sy;
    y1 += spr->h;
    if (s.sx >= cliprect_x1 || x1 < cliprect_x0 || s.sy >= cliprect_y1 || y1 <= cliprect_y0) return;
    if (s.sx < cliprect_x0 || x1 >= cliprect_x1 || s.sy < cliprect_y0 || y1 >= cliprect_y1) s.mode = 1;
    if (s.flip) s.mode += 4;
    if (pal >= 0) {
        r = pal + s.flip * 2;
        if (r != lastsprremap) {
            if (s.flip) {
                p = pal ? awayremap_eC0 : homeremap_eC0;
                for (i = 0; i < 0x40; i += 0x10) {
                    s.t1[0] = p[i + 4];
                    s.t1[1] = p[i + 3];
                    s.t1[3] = p[i + 1];
                    s.t1[4] = p[i];
                    p[i] = s.t1[0];
                    p[i + 1] = s.t1[1];
                    p[i + 3] = s.t1[3];
                    p[i + 4] = s.t1[4];
                }
            }
            SetColorRemap(pal ? awayremap : homeremap);
            if (s.flip) {
                p = pal ? awayremap_eC0 : homeremap_eC0;
                for (i = 0; i < 0x40; i += 0x10) {
                    s.t2[0] = p[i + 4];
                    s.t2[1] = p[i + 3];
                    s.t2[3] = p[i + 1];
                    s.t2[4] = p[i];
                    p[i] = s.t2[0];
                    p[i + 1] = s.t2[1];
                    p[i + 3] = s.t2[3];
                    p[i + 4] = s.t2[4];
                }
            }
            lastsprremap = r;
        }
        s.mode += 2;
    }
    if (spr->flags) s.mode += 8;
    MarkZoneRect(spritedrawcount++, s.sx, s.sy, s.sx + spr->w, s.sy + spr->h);
    switch ((unsigned short)s.mode) {
    case 8: VgaBlitKeyedHot(spr, s.sx, s.sy); break;
    case 9: VgaBlitKeyedFlipV(spr, s.sx, s.sy); break;
    case 10: VgaBlitRemap(spr, s.sx, s.sy); break;
    case 11: VgaBlitRemapFlipV(spr, s.sx, s.sy); break;
    case 12: VgaBlitKeyedFlipH(spr, s.sx, s.sy); break;
    case 13: VgaBlitKeyedFlipHV(spr, s.sx, s.sy); break;
    case 14: VgaBlitRemapFlipH(spr, s.sx, s.sy); break;
    case 15: VgaBlitRemapFlipHV(spr, s.sx, s.sy); break;
    }
}
