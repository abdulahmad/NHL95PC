/* Create player: the shoots ratings fields. */
#include "nhl95.h"

/* DrawShootsField: print "Shoots" and L R (byte_D0F94 of the player being created) at y 12Ah,
 then the 14 rating names (off_D0880[1..14]) with their values (rating byte + 5) * 5 below it, in two
 columns (the second, from rating 8, 136h to the right and 68h up). */
void DrawShootsField(void)
{
    int col;
    int i;
    int y;
    unsigned char *rec;

    y = 0x12A;
    rec = &byte_D0F94;
    PrintShadowText(0x1E, y, (char *)str_Shoots);
    PrintShadowText(0xC8, y, byte_D0F94 ? (char *)str_spL : (char *)str_spR);
    col = 0;
    i = 1;
    y += 0xD;
    do {
        if (i == 8) {
            col = 0x136;
            y -= 0x68;
        }
        PrintShadowText(col + 0x1E, y, (char *)off_D0880[i]);
        PrintFmt1(col + 0xC8, y, (char *)str_fmt3d, (rec[i] + 5) * 5);
        y += 0xD;
        i++;
    } while (i < 15);
}

/* DrawGloveField: the goalie version: "Glove Hand" and L R (byte_D0FE0), then the 10 goalie
 rating names (off_D09DB[1..10]) with their values, the second column from rating 6 (4Eh up). Its end is
 DrawShootsField's (shared tail), so both are in this file. */
void DrawGloveField(void)
{
    int col;
    int i;
    int y;
    unsigned char *rec;

    y = 0x12A;
    rec = &byte_D0FE0;
    PrintShadowText(0x1E, y, (char *)str_GloveHand);
    PrintShadowText(0xC8, y, byte_D0FE0 ? (char *)str_spL : (char *)str_spR);
    col = 0;
    i = 1;
    y += 0xD;
    do {
        if (i == 6) {
            col = 0x136;
            y -= 0x4E;
        }
        PrintShadowText(col + 0x1E, y, (char *)off_D09DB[i]);
        PrintFmt1(col + 0xC8, y, (char *)str_fmt3d, (rec[i] + 5) * 5);
        y += 0xD;
        i++;
    } while (i < 11);
}

typedef struct { char c[16]; } Hdr16;
typedef struct { char c[20]; } Hdr20;

/* CreatePlayerLoop (704A6, PC only; ends in DrawShootsField_pop): the create-player screen. Fades in through a
   black "Temp" palette, copies the default ratings into the player being created (goalie: unk_D0FD0 to
   byte_D0FE0, field 104h; skater: unk_D0F80 to byte_D0F94, field 118h), draws it (DrawCreatePlayer) and puts the
   pointer at 140h, F0h. Then the mouse loop: moves redraw the pointer; a click (bits & 2) goes to the rating
   editor (EditGoalieRating / EditSkaterRating with the pointer and the field), redraws the screen when a rating
   changed, else tests the two buttons (TrackButtons, str_Two) and ends on a hit. p: the new player's record (byte
   +2 is the position, 'G' for a goalie). Result: the button hit. */
int CreatePlayerLoop(unsigned char *p)
{
    int r;
    int field;
    int x;
    int y;
    int pal;
    int result;
    int done;
    int bits;
    int ox;
    int oy;
    unsigned char *ev;

    field = 0x118;
    done = 0;
    pal = sub_8CCA8((char *)str_Temp, 0x300, 0x20);
    sub_8FFB0(0, 0x100, (unsigned char *)pal);
    FadePalStep(1, (unsigned char *)pal, 0x10);
    if (p[2] == 'G') {
        field = 0x104;
        *(Hdr16 *)&byte_D0FE0 = *(Hdr16 *)unk_D0FD0;
    } else {
        *(Hdr20 *)&byte_D0F94 = *(Hdr20 *)unk_D0F80;
    }
    DrawCreatePlayer(p, field);
    oy = 0xF0;
    sub_91400(editptrspr, ox = 0x140, oy);
    sub_91370(pointerspr, ox, oy);
    FadePalStep(0, (unsigned char *)pal, 0x10);
    FreeMemBlock(pal);
    MouseSetPos(x = ox, y = oy);
    ((void (*)(void))mousepollfn)();
    ClearInputQueue();
    do {
        bits = 0;
        do {
            ev = GetInputEvent();
            if (ev) bits = ((int (*)(unsigned char *, int *, int *))ptrupdatefn)(ev, &x, &y);
        } while (ev && !(bits & 2));
        if (!(bits & 2)) {
            if (ox != x || oy != y) {
                sub_903F0(editptrspr, ox, oy);
                sub_91400(editptrspr, x, y);
                sub_91370(pointerspr, x, y);
                ox = x;
                oy = y;
            }
        } else {
            sub_903F0(editptrspr, ox, oy);
            if (p[2] == 'G') r = EditGoalieRating(&x, &y, &field);
            else r = EditSkaterRating(&x, &y, &field);
            if (r)
                DrawCreatePlayer(p, field);
            else if ((result = TrackButtons((int *)str_Two, 2, x, y, bits)) >= 0)
                done = 1;
            sub_91400(editptrspr, x, y);
            sub_91370(pointerspr, x, y);
            ox = x;
            oy = y;
        }
    } while (!done);
    return result;
}
