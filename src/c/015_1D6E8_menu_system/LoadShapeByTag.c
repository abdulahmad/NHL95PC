/* Menu system: load one shape out of a tagged shape file. */
/* DRAFT: 392 vs 392, 4 differing (10.0 GA). The index doubles as the directory byte count (esi, as the
 original) and the file position is `offset + (count*8 + 6)` (edi). Left: the width*height size goes
 through i (`mov esi, [esp+6]` / `sar esi, 10h` / ... / `imul esi, eax` / `lea ebp, [esi+11h]`); the
 original multiplies in a temporary (`mov edx, [esp+6]` / `sar edx, 10h` / `mov eax, [esp+8]` /
 `sar eax, 10h` / `imul eax, edx` / `lea ebp, [eax+11h]`). See docs/UNSURE.md for the shapes tried. */
#include "nhl95.h"

/* LoadShapeByTag: open path and return the shape whose 4-byte tag matches, or 0.
 The file has a short count at offset 4, then at offset 6 a directory of count*8 bytes:
 count tags followed by count dword offsets. The shape itself starts at
 count*8 + 6 + offset. Its 17-byte header holds width at +4 and height at +6, and the
 allocated block is width*height + 11h (the header plus the pixels). The directory is
 allocated as "sfh" and the shape as "shape". A failed read of the shape frees it. */
int LoadShapeByTag(char *path, char *tag)
{
    int dir;
    int pos;
    int i;
    int off;
    int base;
    int p;
    int n;
    struct {
        char hdr[0x14];
        char tagbuf[4];
        int handle;
        int count;
        int found;
        int shape;
        int err;
    } s;

    s.handle = -1;
    s.shape = dir = 0;
    s.err = FileOpenRead(path, &s.handle);
    if (s.err == 0) {
        s.err = FileReadAt(s.handle, &s.count, 4, 2);
        *(short *)((char *)&s.count + 2) = 0;
    }
    if (s.err == 0) {
        i = s.count << 3;
        dir = sub_8CCA8((char *)str_sfh, i, 0x20);
        s.err = FileReadAt(s.handle, (void *)dir, 6, i);
    }
    if (s.err == 0) {
        s.found = 0;
        for (i = 0; i < s.count && s.found == 0; i++) {
            off = i << 2;
            memcpy(s.tagbuf, (char *)dir + off, 4);
            if (memcmp(s.tagbuf, tag, 4) == 0) {
                s.found = -1;
                base = s.count << 2;
                base += dir;
                pos = *(int *)(base + off) + ((s.count << 3) + 6);
                s.err = FileReadAt(s.handle, &s, pos, 0x11);
            }
        }
    }
    if (dir) FreeMemBlock(dir);
    if (s.err == 0 && s.found != 0) {
        i = ((short *)s.hdr)[2] * ((short *)s.hdr)[3];
        n = i + 0x11;
        p = sub_8CCA8((char *)str_shape, n, 0x20);
        s.shape = p;
        if (FileReadAt(s.handle, (void *)p, pos, n) < 0) {
            FreeMemBlock(p);
            s.shape = p = 0;
        }
    }
    FileClose(&s.handle);
    return s.shape;
}

/* MakeStatsTitle (1FF86, PC only; ends in LoadShapeByTag_x): build a stats screen title in dst: the label of the
   selected stats source (menu items mi_9394Season, mi_9394Playoffs, mi_LeagueSeason, mi_LeaguePlayoffs,
   mi_PlayoffMode; the playoff labels lose their last character), then suffix. dst: the title buffer; suffix: the
   screen's name. No result. */
void MakeStatsTitle(char *dst, char *suffix)
{
    char *s;
    int cut;
    int n;

    if (mi_9394Season == 1) {
        s = (char *)str_9394Season;
        cut = 0;
    } else if (mi_9394Playoffs == 1) {
        s = (char *)str_9394PlayOffs;
        cut = 1;
    } else if (mi_LeagueSeason == 1) {
        s = (char *)str_LgSeasonTitle;
        cut = 0;
    } else if (mi_LeaguePlayoffs == 1) {
        s = (char *)str_LgPlayoffsTitle;
        cut = 1;
    } else if (mi_PlayoffMode == 1) {
        s = (char *)str_POTitle;
        cut = 1;
    }
    n = strlen(s) - cut;
    strncpy(dst, s, n);
    dst[n] = 0;
    strcat(dst, suffix);
}
