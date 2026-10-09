/* Scoring / penalty text: penalties. */
#include "nhl95.h"

/* AddPenalty2 (62D80) - call penalty pen on player p (not in a replay, sflags bit 7, or with word_CBC44): outside a
   penalty shot raise the banner (word_CD39C[pen], timer 50h unless none / 6); major penalties (pen >= 7) raise
   the crowd (+400 up to 800; flag 40h side: CwdExciteLvl +20 and sound 7Dh, else A0h). Then the penalty goes into
   the first free PenBuf slot (pen, SCnum); a penalty with time (penmintab) marks the player (pflags2 bit 4) or,
   when he already has one, frees the slot again. */
void AddPenalty2(Player *p, short pen)
{
    short i;

    if (sflags & 0x80) return;
    if (word_CBC44) return;
    if (!penshotstart && bannermsg < word_CD39C[pen]) {
        bannermsg = word_CD39C[pen];
        if (bannermsg != -1 && bannermsg != 6) bannertimer = 0x50;
    }
    if (pen >= 7) {
        if (crowdlevel <= 800) {
            crowdlevel += 400;
            if (crowdlevel > 800) crowdlevel = 800;
        }
        if (p->pflags & 0x40) {
            CwdExciteLvl += 20;
            sfx(0x7D);
        } else {
            sfx(0xA0);
        }
    }
    for (i = 0; i < 0x20; i++) {
        if (!PenBuf[i * 2]) {
            PenBuf[i * 2] = pen;
            PenBuf_pl[i * 2] = p->SCnum;
            if (!penmintab[pen]) return;
            if (!(p->pflags2 & 0x10)) {
                p->pflags2 |= 0x10;
                return;
            }
            PenBuf[i * 2] = PenBuf_pl[i * 2] = 0;
            return;
        }
    }
}
