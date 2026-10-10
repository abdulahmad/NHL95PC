/* Misc dialogs: text edit cursor. */
/* DRAFT: all but the final call matches; the EXE has x / y / w in eax / edi / esi for the sub_91044 pushes (C picks other registers). */
#include "nhl95.h"

#define TEXTWIDTHN ((int (__cdecl *)(char *s, int n))sub_90A40)
#define FILLRECT ((void (__cdecl *)(int x, int y, int w, int h, int col))sub_91044)

/* DrawEditCursor (314B4) - draw the cursor of the text edit field (when editcuron): clamp editpos to the text, then a
   bar the width of the character under it (a space at the end; the width of "." in fixed-pitch mode, mode bit 2)
   and editcurw high in fontcolor, under the text at editx + the width up to editpos. */
void DrawEditCursor(int mode)
{
    int cw;
    int w;
    int x;
    int y;
    int h;
    char *s;

    cw = fputchar((char *)str_Dot);
    if (!editcuron) return;
    if ((int)strlen((char *)editbuf) < editpos) editpos = strlen((char *)editbuf);
    s = (char *)editbuf + editpos;
    if (*s) {
        if (mode & 2) w = cw;
        else w = TEXTWIDTHN(s, 1);
    } else w = fputchar((char *)str_Space);
    if (mode & 2) x = editpos * cw;
    else x = TEXTWIDTHN((char *)editbuf, editpos);
    x += editx;
    h = editcurw;
    y = byte_D42C5 + edity - h - 2;
    FILLRECT(x, y, w, h, fontcolor);
}
