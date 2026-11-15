/* Database save: draw one roster list. */
#define DrawRosterList DrawRosterList_decl
#define XorBar sub_90F38_decl
#define DrawScrollBar DrawScrollBar_decl
#include "nhl95.h"
#undef DrawRosterList
#undef XorBar
#undef DrawScrollBar

void __cdecl XorBar(int x, int y, int w, int h, int col);
void DrawScrollBar(int *sb);

/* DrawRosterList: 28 rows of a team roster, or the free-agent list when rosterisfa[side] is 1.
 Each row is jersey, position and the fitted name. A selected row is inverted. An empty team
 slot ends the list. The free-agent list starts at falisttop and, when dword_D0C20 is set,
 draws its buttons and scroll thumb. x and y are the first row; side is 0 or 1. */
void DrawRosterList(int x, int y, int side)
{
    int step;
    int base;
    int off;
    char buf[0x54];
    int i;
    int n;

    if (rosterisfa[side] != 1) {
        for (i = 0; i < 0x1C; i++) {
            base = side * 0x2F4;
            step = i * 0x1B;
            if (rosterlist[base + step] != 0) {
                sprintf(buf, (char *)str_fmt2d, rosterjersey[base + step]);
                PrintString(buf, x, byte_D42C3 * i + y);
                sprintf(buf, (char *)str_C4, rosterlist[base + step]);
                PrintString(buf, x + 0x28, byte_D42C3 * i + y);
                FitPlayerName(buf, 0, (char *)rosterlist + base + step + 8, 0x91);
                PrintString(buf, x + 0x50, byte_D42C3 * i + y);
                if (rostersel[side * 28 + i] != 0)
                    XorBar(side ? 0x15E : 0x23, byte_D42C3 * i + 0x35, 0xF0, byte_D42C3, 0x80);
            } else
                i = 0x1C;
        }
    } else {
        n = falisttop;
        for (i = 0; i < 0x1C && n < facount; n++, i++) {
            off = n * 0x1B;
            sprintf(buf, (char *)str_fmt2d, falist[off + 1]);
            PrintString(buf, x, byte_D42C3 * i + y);
            sprintf(buf, (char *)str_C4, falist[off]);
            PrintString(buf, x + 0x28, byte_D42C3 * i + y);
            FitPlayerName(buf, 0, (char *)falist + off + 8, 0x91);
            PrintString(buf, x + 0x50, byte_D42C3 * i + y);
            if (((unsigned char *)falistsel)[n] != 0)
                XorBar(side ? 0x15E : 0x23, byte_D42C3 * i + 0x35, 0xF0, byte_D42C3, 0x80);
        }
        if (dword_D0C20) {
            DrawButtons((Button *)btn_RosterList, 2);
            fascrollbar_top = falisttop;
            fascrollbar_thumb = (unsigned)((fascrollbar_len - 4) * *(volatile int *)&fascrollbar_top)
                / (unsigned)fascrollbar_count;
            DrawScrollBar((int *)fascrollbar);
        }
    }
}
