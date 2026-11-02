/* Misc dialogs: text edit cursor. */
#include "nhl95.h"

#define TEXTWIDTHN ((int (__cdecl *)(char *s, int n))sub_90A40)
#define FILLRECT ((void (__cdecl *)(int x, int y, int w, int h, int col))sub_91044)

/* DrawEditCursor: draw the cursor of the text edit field (when editcuron): clamp editpos to the text, then a
 bar the width of the character under it (a space at the end; the width of "." in fixed-pitch mode, mode bit 2)
 and editcurw high in fontcolor, under the text at editx + the width up to editpos. */
void DrawEditCursor(int mode)
{
    int cw;
    int w;
    int x;
    int y;
    char *s;

    cw = fputchar((char *)str_Dot);
    if (!editcuron) return;
    if ((int)strlen(editbuf) < editpos) editpos = strlen(editbuf);
    s = editbuf + editpos;
    if (*s) {
        if (mode & 2) w = cw;
        else w = TEXTWIDTHN(s, 1);
    } else w = fputchar((char *)str_Space);
    if (mode & 2) x = editpos * cw + editx;
    else x = TEXTWIDTHN(editbuf, editpos) + editx;
    y = byte_D42C5 + edity - editcurw - 2;
    FILLRECT(x, y, w, editcurw, fontcolor);
}

#define CLEARRECT ((void (__cdecl *)(int x, int y, int w, int h, int col))sub_90EC0)

/* DrawEditText (31599, PC only; ends in DrawEditCursor's exits): draw the text of the edit field. With a field
   width (editmaxw), first cut editbuf from the end until it fits (in fixed-pitch mode, mode bit 2, by the width of
   "." per character, else by fputchar); clamp editpos to the text; print it at editx, edity (fixed-pitch: a "."
   per character); then clear the rest of the field (sub_90EC0, byte_D42C5 - 2 high, colour dword_D42AC).
   mode: the edit mode bits. No result.
   The fixed-pitch width test keeps its product in len, and the clamp goes through w, as the EXE's registers
   show. */
void DrawEditText(int mode)
{
    int cw;
    int len;
    int i;
    int w;

    cw = fputchar((char *)str_Dot);
    if (editmaxw) {
        if (mode & 2) {
            while ((len = strlen(editbuf) * cw) > editmaxw && strlen(editbuf))
                editbuf[strlen(editbuf) - 1] = 0;
        } else {
            while (fputchar(editbuf) > editmaxw && strlen(editbuf))
                editbuf[strlen(editbuf) - 1] = 0;
        }
    }
    w = strlen(editbuf);
    len = w;
    if (w < editpos) editpos = w;
    if (mode & 2) {
        for (i = 0; i < len; i++) sub_92CD0((char *)str_Dot, editx + cw * i, edity);
    } else {
        sub_92CD0(editbuf, editx, edity);
    }
    if (!editmaxw) return;
    if (mode & 2) w = len * cw;
    else w = fputchar(editbuf);
    if (editmaxw - w <= 0) return;
    CLEARRECT(editx + w, edity, editmaxw - w, byte_D42C5 - 2, dword_D42AC);
}
