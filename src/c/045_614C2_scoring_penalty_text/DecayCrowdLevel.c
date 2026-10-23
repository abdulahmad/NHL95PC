/* Scoring penalty text: crowd level and rink-object slots (DecayCrowdLevel, DrawRinkObjects). DrawRinkObjects
   ends in sfxslots_popx, DecayCrowdLevel's exit, so the two share this file. */
#include "nhl95.h"

/* one rink-object slot, 12 bytes at word_DEE94 (DecayCrowdLevel animates them) */
typedef struct RinkObj {
    short id;           /* photo id, -1 free */
    signed char timer;
    signed char step;
    signed char frame;  /* photoptrsf index */
    short x;
    short y;
    unsigned char pad[3];
} RinkObj;

typedef struct { short x, y; } Pt;

/* DecayCrowdLevel (615A2, PC only; owner of sfxslots_popx): ease crowdlevel down (by 2 above 2BCh, by 3 above
   15Eh, then always by 1) and, if it goes negative, sometimes kick it with a small random. Then walk the 20
   rink-object slots (12 bytes at word_DEE94). A free slot (negative id) counts its timer down and then spawns an
   object (SetRinkObject): slots 12h / 13h a random one of 11h from 89h / 9Ah, slot 11h in the game (gmode bit 0)
   85h or 86h half the time, else a random id below 85h whose bit in word_E9B2C is clear. A live slot counts its
   timer down, steps its frame (byte_CCE00) until the step reaches |byte 0Bh|, or with a negative byte 0Bh
   restarts half the time (byte_CCE01); else it releases its id bit and is freed, its timer armed from the crowd
   level ((3E8h - crowdlevel) / 8, at least 14h, 64h for slots 12h / 13h, 78h for slot 11h in the game,
   randomised). The spawn id and the release timer are separate shorts (one shared short spills it). No
   arguments, no result. */
void DecayCrowdLevel(void)
{
    short i;
    short n;
    signed char *o;
    short delay;

    if (crowdlevel > 0x2BC)
        crowdlevel = crowdlevel - 2;
    else if (crowdlevel > 0x15E)
        crowdlevel = crowdlevel - 3;
    crowdlevel--;
    if (crowdlevel < 0) {
        crowdlevel = 0;
        if (randomd0(0x10) == 0)
            crowdlevel = randomd0(0x20);
    }
    for (i = 0; i < 0x14; i++) {
        o = (signed char *)word_DEE94 + i * 12;
        if (*(short *)o < 0) {
            if (--o[2] >= 0)
                continue;
            if (i == 0x12)
                n = randomd0(0x11) + 0x89;
            else if (i == 0x13)
                n = randomd0(0x11) + 0x9A;
            else if (i == 0x11 && (gmode & 1) && (n = randomd0(4)) < 2)
                n += 0x85;
            else {
                n = randomd0(0x85);
                while (word_E9B2C[n / 16] & (1 << (n % 16))) {
                    n++;
                    if (n >= 0x85)
                        n = 0;
                }
            }
            SetRinkObject(i, n);
        } else {
            if (--o[2] >= 0)
                continue;
            if (o[3] < (o[0xB] < 0 ? -o[0xB] : o[0xB])) {
                o[2] = 0xC;
                o[3]++;
                o[4] = byte_CCE00[*(short *)(o + 9) + o[3]];
                continue;
            }
            if (o[0xB] < 0 && randomd0(2) != 0) {
                o[4] = byte_CCE01[*(short *)(o + 9)];
                o[2] = 0xC;
                o[3] = 1;
                continue;
            }
            word_E9B2C[*(short *)o / 16] &= ~(1 << (*(short *)o % 16));
            *(short *)o = -1;
            delay = (0x3E8 - crowdlevel) / 8;
            if (delay < 0x14)
                delay = 0x14;
            if (i >= 0x12 && delay < 0x64)
                delay = 0x64;
            if (i == 0x11 && (gmode & 1))
                delay = 0x78;
            else
                delay = randomd0(delay);
            o[2] = delay;
        }
    }
}

/* DrawRinkObjects (61862, PC only): draw the live rink objects of slots 0-11h (photoptrsf[frame] at x, y; the
   DrawSprite flag is x > C0h). Then slots 13h and 12h (i = 1, 0): a free slot or a frame over 64h first gets
   the dword_E0220 shape at x 4, y from dword_CD2F8[i], then the live frame is drawn; slot 12h adds the
   dword_E0230 shape, slot 13h the penalty-box door (sortobj15, DrawFrameSprite) when gmode bit 7 is set and its
   frame is 362h or more. No arguments, no result. Matched under 10.0 GA with o declared after i and x (the
   dword_CD2F8 index then goes through eax as in the EXE) and in this file (the near jump to sfxslots_popx). */
void DrawRinkObjects(void)
{
    short i;
    short x;
    RinkObj *o;
    short y;
    short id;

    o = (RinkObj *)word_DEE94;
    for (i = 0; i < 0x12; i++, o++) {
        if (o->id >= 0) DrawSprite(photoptrsf[o->frame], o->x, o->y, (short)(o->x > 0xC0), -1, 0);
    }
    o++;
    for (i = 1; i >= 0; i--, o--) {
        if (o->id < 0) id = -1;
        else id = o->frame;
        x = o->x;
        y = o->y;
        if (id > 0x64 || o->id < 0) DrawSprite(dword_E0220, 4, ((Pt *)dword_CD2F8)[i].y, 0, i, 0);
        if (id >= 0) DrawSprite(photoptrsf[id], x, y, 0, i, 0);
        if (i == 0) DrawSprite(dword_E0230, 4, ((Pt *)dword_CD2F8)[i].y, 0, -1, 0);
        else if ((gmode & 0x80) && ((Player *)sortobj15)->frame >= 0x362)
            DrawFrameSprite(((Player *)sortobj15)->frame, HIWORD(((Player *)sortobj15)->Xpos),
                HIWORD(((Player *)sortobj15)->Ypos), 0, 0);
    }
}
