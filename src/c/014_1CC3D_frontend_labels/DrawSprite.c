/* Front end: drawing a sprite. */
/* DRAFT (10.0 GA): 78 -> 66 differing, 675 vs 678 bytes. Integer coordinate/flip
   inputs, a short intermediate for mirrored x, and short edges updated in steps give
   the EXE's 16-bit edge arithmetic. Declaring i before r also leaves pal in memory.
   Left: mode/clip/remap register choices and the first flip test's cached value. */
#define DrawSprite DrawSprite_decl
#define sub_6AB7C sub_6AB7C_decl
#define sub_B4CD8 sub_B4CD8_decl
#define sub_B500C sub_B500C_decl
#define sub_B4E50 sub_B4E50_decl
#define sub_B52B4 sub_B52B4_decl
#define sub_B5584 sub_B5584_decl
#define sub_B56B8 sub_B56B8_decl
#define sub_B5974 sub_B5974_decl
#define sub_B5AC8 sub_B5AC8_decl
#include "nhl95.h"
#undef DrawSprite
#undef sub_6AB7C
#undef sub_B4CD8
#undef sub_B500C
#undef sub_B4E50
#undef sub_B52B4
#undef sub_B5584
#undef sub_B56B8
#undef sub_B5974
#undef sub_B5AC8

typedef struct {
    int flags : 8;
    int : 24;
    short w;
    short h;
    short xoff;
    short yoff;
} SprHdr;

void sub_6AB7C(int n, int x0, int y0, int x1, int y1);
void __cdecl sub_B4CD8(SprHdr *s, int x, int y);
void __cdecl sub_B500C(SprHdr *s, int x, int y);
void __cdecl sub_B4E50(SprHdr *s, int x, int y);
void __cdecl sub_B52B4(SprHdr *s, int x, int y);
void __cdecl sub_B5584(SprHdr *s, int x, int y);
void __cdecl sub_B56B8(SprHdr *s, int x, int y);
void __cdecl sub_B5974(SprHdr *s, int x, int y);
void __cdecl sub_B5AC8(SprHdr *s, int x, int y);

/* DrawSprite (1CD73, PC only): draw sprite spr with its hot spot (+8h / +0Ah) at x, y, mirrored when flip. Nothing
   is drawn when it lies wholly outside cliprect; it is clipped when it crosses it. With pal not negative the
   colour remap (sub_B4DD4, byte_DC8D8 for pal, else byte_DC9D8) is loaded unless it is already the current one
   (lastsprremap = pal + flip * 2); mirrored, the remap's 16-byte groups are flipped (bytes 0/4 and 1/3) around
   the load. The rectangle is recorded (sub_6AB7C, spritedrawcount), and if the sprite's flag byte is set one of
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
                p = pal ? unk_DC998 : unk_DCA98;
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
            sub_B4DD4(pal ? byte_DC8D8 : byte_DC9D8);
            if (s.flip) {
                p = pal ? unk_DC998 : unk_DCA98;
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
    sub_6AB7C(spritedrawcount++, s.sx, s.sy, s.sx + spr->w, s.sy + spr->h);
    switch ((unsigned short)s.mode) {
    case 8: sub_B4CD8(spr, s.sx, s.sy); break;
    case 9: sub_B500C(spr, s.sx, s.sy); break;
    case 10: sub_B4E50(spr, s.sx, s.sy); break;
    case 11: sub_B52B4(spr, s.sx, s.sy); break;
    case 12: sub_B5584(spr, s.sx, s.sy); break;
    case 13: sub_B56B8(spr, s.sx, s.sy); break;
    case 14: sub_B5974(spr, s.sx, s.sy); break;
    case 15: sub_B5AC8(spr, s.sx, s.sy); break;
    }
}
