struct rect { int x0, y0, x1, y1; };
extern struct rect rects_C6F88[16];
int hit_rect(int x, int y, int *out)
{
    int i;
    x -= 6; y -= 0x13;
    for (i = 0; i < 16; i++) {
        if (x >= rects_C6F88[i].x0 && x <= rects_C6F88[i].x1 &&
            y >= rects_C6F88[i].y0 && y <= rects_C6F88[i].y1) { *out = i; return 1; }
    }
    return 0;
}
