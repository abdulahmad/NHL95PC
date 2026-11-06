/* Computer line change. */
#define getlinee getlinee_decl
#include "nhl95.h"
#undef getlinee

short getlinee(Team *t, short line);

int LineEnergy(Team *t, int line);
#pragma aux LineEnergy "getlinee" parm [eax] [edx] value [eax] modify [eax edx];

/* CompLine: other is the other team, team is the one changing lines. When the on-ice counts differ, pick
 line 4 or 6, and the next line if its energy is higher and this one is under F33h. Otherwise walk the
 byte list off_CBD2E[team byte D5h] at the current line, four entries, and keep a line whose energy is at
 most the dword at D6h and better than the line already set. A line under 4 bumps the rotation count.
 Then draw that line and clear bit 6 of the byte at D4h. */
void CompLine(Team *other, Team *team)
{
    Team *o;
    short line;
    short diff;

    o = other;
    diff = team->tmap - o->tmap;
    if (diff != 0) {
        short e1;

        line = 4;
        if (diff < 0) line = 6;
        e1 = LineEnergy(team, line);
        if (e1 < 0xF33) {
            diff = line;                        /* diff reused for the next line */
            diff++;
            if (e1 < (short)LineEnergy(team, diff)) line = diff;
        }
        team->tmline = line;
    } else {
        signed char *p;
        short saved;
        short best;
        short b;
        short i;

        if (((unsigned char *)team)[0xD4] & 1) {
            line = team->tmline;
            if ((gmode & gmclock) && line < 4 && (((unsigned char *)team)[0xD4] & 0x40) == 0) {
                unsigned lim;

                AvgCline(team);
                if (team->tmap == o->tmap)
                    lim = *(unsigned *)((char *)team + 0xD6);
                else
                    lim = 0xF33;
                if ((unsigned short)regd0.w > lim) return;
            }
            if (line > 3) line = 3;
            if (((unsigned char *)team)[0xD5] == 6 && (line < 4 || line > 5)) line = 3;
        } else {
            line = o->tmline;
            if (line >= 6) line -= 6;
            else if (line >= 4) line -= 4;
        }
        if (((unsigned char *)team)[0xD5] == 1 && (((unsigned char *)team)[0xD4] & 0x80))
            line += 4;
        p = ((signed char **)off_CBD2E)[((signed char *)team)[0xD5]] + line * 4;
        b = -1;
        saved = team->tmline;
        best = LineEnergy(team, saved);
        for (i = 0; i < 4; i++) {
            short e;

            b = *p++;
            if (b < 0) break;
            e = LineEnergy(team, b);
            if ((unsigned)e > *(unsigned *)((char *)team + 0xD6)) break;
            if (e > best) {
                best = e;
                saved = b;
            }
            b = -1;
        }
        if (b < 0) line = saved;
        else line = b;
        if (line != team->tmline) {
            team->tmline = line;
            if (((unsigned char *)team)[0xD5] == 1 && line == 2)
                ((unsigned char *)team)[0xD4] ^= 0x80;
            if (line < 4) {
                if (++team->tmlcnt >= 3) team->tmlcnt -= 3;
            }
        }
    }
    DrawPanelLine((short)(team == &awtmstruct), line);
    ((unsigned char *)team)[0xD4] &= ~0x40;
}

/* getlinee (5A30C; 93G penalty93 getlinee, "energy level of this line"): the average energy of line `line` of
   team t. t->tmlines lists the lines' roster slots: lines 0-3 three each from +0, lines 4 and 5 five each from
   +12h, lines 6 and up four each from +1Ch. Result: the sum of those players' t->tmpde energies divided by their
   count. Watcom places its entry after TeamLineEnergy (which ends by falling into it) and the rest of its code
   before TeamLineEnergy (getlinee_pp, getlinee_sum), as in the EXE, only with CompLine before it in this file. */
short getlinee(Team *t, short line)
{
    unsigned char *p;
    short n;
    short i;

    if (line < 4) {
        p = t->tmlines + line * 3;
        n = 3;
    } else if (line < 6) {
        p = t->tmlines + 0x12 + (line - 4) * 5;
        n = 5;
    } else {
        p = t->tmlines + 0x1C + (line - 6) * 4;
        n = 4;
    }
    line = 0;                                   /* line reused as the sum */
    for (i = 0; i < n; i++) line += t->tmpde[*p++];
    return line / n;
}

/* TeamLineEnergy (5A2EE, PC only): the average energy of line `line` (getlinee) of the away team when team is
   positive, else of the home team. Result: that energy. The call is a tail call into the next function, so the
   code falls through into getlinee's entry. */
short TeamLineEnergy(short team, short line)
{
    Team *t;

    if (team > 0) t = &awtmstruct;
    else t = &hmtmstruct;
    return getlinee(t, line);
}
