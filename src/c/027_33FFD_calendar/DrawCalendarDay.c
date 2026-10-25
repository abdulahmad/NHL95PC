/* Calendar: one month of the team's schedule. */
/* DRAFT: 32 differing under 10.0 GA, 1,675 vs 1,684 bytes. The Home / Away legend has its own block-local x
   (hx), set in two steps per branch (`hx = calcolx[0]; hx += 7;`): that gives hx the savings to choose before hy
   and the EXE's legend registers (esi / edi) without reusing the day loop's dx; declaration order from
   tools/wccre/declsearch.py --conflicts. Left: the day numbers' divisor 7 in ecx (EXE esi, then ecx), game-day
   index, selection sum and temporary stack slots in the selection frame. See docs/UNSURE.md. */
#define DrawCalendarDay DrawCalendarDay_decl
#define sub_913D0 sub_913D0_decl
#include "nhl95.h"
#undef DrawCalendarDay
#undef sub_913D0

void __cdecl sub_913D0(int art, int x, int y);  /* graphics library: draw art (another mode than sub_91370) */

/* DrawCalendarDay (33FFD, PC only): draw a month of the calendar screen for team. Draws the bkgd art and the
   month art "<mm>9<y>" (93 for October to December, 94 after) from bank, team's crest at 26h, 3Fh, and the Home /
   Away legend; numbers every day of the month (monthdays, starting on monthfirstday) in the calrowy / calcolx
   grid; then for each of the ngames 6-byte games (month + 1, day, home, away, home score, away score; FFh is
   unplayed) in this month, the opponent's crest on the home (boxr) or away (boxb) box, the day number and for a
   played game the "<W/L/T>:<us>-<them>" result; the game on calselmonth / calselday gets a double frame in
   colour BBh. month: 0 is January; crests: the crest art per team; unused: not read; font: the text font.
   Restores the text state. No result (the four stack arguments are popped). */
void DrawCalendarDay(int month, int *crests, int unused, unsigned char *games, int ngames, int team, int font,
                     int bank)
{
    char state[0x40];
    char score[0x10];
    char name[0x20];
    unsigned char *g;
    int boxr;
    int x2;
    int box;
    int opp;
    int boxb;
    int sel;
    int y2;
    int dx;
    int dy;
    int x;
    int y;
    int hy;
    int i;
    int d;
    char *cn;

    (void)unused;
    boxr = sub_B30B4(bank, (char *)str_Boxr);
    boxb = sub_B30B4(bank, (char *)str_Boxb);
    sub_9061C(sub_B30B4(bank, (char *)str_Bkgd7));
    sprintf(name, (char *)str_02d9D, month + 1, (month < 9) + 3);
    sub_9061C(sub_B30B4(bank, name));
    cn = ((char **)crestnames)[team];
    name[0] = '!';
    name[1] = cn[0];
    name[2] = cn[1];
    name[3] = cn[2];
    sub_913D0(crests[team], 0x26, 0x3F);
    sub_8E9E8(state);
    sub_8EA18(font);
    fontcolor = 0xC0;
    {
        int hx;

        if (monthfirstday[month]) {
            hx = calcolx[0];
            hx += 7;
            hy = calrowy[0] + 5;
        } else {
            hx = calcolx[6];
            hx += 7;
            hy = calrowy[5] + 5;
        }
        fontcolor = 0xB6;
        sub_91964((char *)str_Home, hx, hy);
        fontcolor = 0xB7;
        hy += 0xC;
        sub_91964((char *)str_Away, hx, hy);
    }
    for (i = 0; i < monthdays[month]; ) {
        d = monthfirstday[month] + i;
        dx = d % 7;
        dy = d / 7;
        dx = calcolx[dx] + 4;
        dy = calrowy[dy] + 1;
        sprintf(name, (char *)str_D8, ++i);
        fontcolor = 0xC0;
        sub_91964(name, dx, dy);
        fontcolor = 0xFF;
        sub_91964(name, dx - 1, dy - 1);
    }
    sel = -1;
    for (i = 0; i < ngames; i++) {
        if (games[i * 6] != month + 1) continue;
        d = games[i * 6 + 1] + monthfirstday[month] - 1;
        x = d % 7;
        y = d / 7;
        x = calcolx[x];
        y = calrowy[y];
        if (games[i * 6 + 2] == team) {
            box = boxr;
            opp = games[i * 6 + 3];
            if (games[i * 6 + 4] > games[i * 6 + 5])
                sprintf(score, (char *)str_SDD2, (char *)str_W5, games[i * 6 + 4], games[i * 6 + 5]);
            else if (games[i * 6 + 4] < games[i * 6 + 5])
                sprintf(score, (char *)str_SDD2, (char *)str_L7, games[i * 6 + 4], games[i * 6 + 5]);
            else
                sprintf(score, (char *)str_SDD2, (char *)str_T5, games[i * 6 + 4], games[i * 6 + 5]);
        } else {
            box = boxb;
            opp = games[i * 6 + 2];
            if (games[i * 6 + 4] > games[i * 6 + 5])
                sprintf(score, (char *)str_SDD2, (char *)str_L7, games[i * 6 + 5], games[i * 6 + 4]);
            else if (games[i * 6 + 4] < games[i * 6 + 5])
                sprintf(score, (char *)str_SDD2, (char *)str_W5, games[i * 6 + 5], games[i * 6 + 4]);
            else
                sprintf(score, (char *)str_SDD2, (char *)str_T5, games[i * 6 + 4], games[i * 6 + 5]);
        }
        g = games + i * 6;
        if (g[4] == 0xFF || g[5] == 0xFF) {
            sub_91370(box, x, y);
            sub_91370(crests[opp], x, y);
            sprintf(name, (char *)str_D8, games[i * 6 + 1]);
            fontcolor = 0xFF;
            sub_91964(name, x + 4, y + 1);
            fontcolor = 0xC0;
            sub_91964(name, x + 3, y);
        } else {
            sub_91370(crests[opp], x, y);
            sprintf(name, (char *)str_D8, g[1]);
            fontcolor = 0xC0;
            sub_91964(name, x + 4, y + 1);
            fontcolor = 0xFF;
            sub_91964(name, x + 3, y);
            sub_91370(box, x, y);
            fontcolor = 0xFF;
            sub_91964(score, x + 0x27 - (fputchar(score) >> 1), y + 0x31);
            fontcolor = 0xC0;
            sub_91964(score, x + 0x26 - (fputchar(score) >> 1), y + 0x30);
        }
        if (games[i * 6] == calselmonth && games[i * 6 + 1] == calselday) sel = i;
    }
    if (sel >= 0) {
        d = games[sel * 6 + 1] + monthfirstday[month] - 1;
        x = d % 7;
        y = d / 7;
        x = calcolx[x];
        y = calrowy[y];
        x2 = x + 0x4C;
        y2 = y + 0x3E;
        sub_B4FAC(x - 1, y - 1, x2, y - 1, 0xBB);
        sub_B4FAC(x, y, x2 - 1, y, 0xBB);
        sub_B4FAC(x - 1, y - 1, x - 1, y2, 0xBB);
        sub_B4FAC(x, y, x, y2 - 1, 0xBB);
        sub_B4FAC(x2, y - 1, x2, y2, 0xBB);
        sub_B4FAC(x2 - 1, y, x2 - 1, y2 - 1, 0xBB);
        sub_B4FAC(x - 1, y2, x2, y2, 0xBB);
        sub_B4FAC(x, y2 - 1, x2 - 1, y2 - 1, 0xBB);
    }
    sub_8EA00(state);
}
