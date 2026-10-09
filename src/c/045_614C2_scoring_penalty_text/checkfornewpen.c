/* Scoring / penalties: new penalty check (93G checkfornewpen). */
#include "nhl95.h"

/* checkfornewpen (637B5) - 93G checkfornewpen: unless sflags bit 7 or word_CBC44, go over the penalty buffer
   (PenBuf: penalty, player pairs up to a 0). Outside gmode bit 2: a penalty with a minimum (penmintab) is delayed
   while the puck is loose or held by the other team (player < 6 is the home side) - gmode bit 3, ref arm up
   (SetPA 1Ch) - else the ref signals (refsignal 28h, banner timer 50h with a banner up); then stop play for it
   (Stop4Pen). A penalty not yet counted (player bit 7) gets marked, the countdown Pencntdwn raised to its delay
   (pendelaytab x 32; 140h with word_CBEC6; a penalty shot (5) when penshotstart takes byte_C9111 / byte_C9146)
   and word_CC0B0 raised to its box time (byte_C9142 x 32). */
void checkfornewpen(void)
{
    short i;
    signed char pen;
    signed char pl;
    signed char c;
    short t;

    if (sflags & 0x80 || (i = word_CBC44) != 0) return;
    for (; (pen = PenBuf[i * 2]) != 0; i++) {
        pl = PenBuf_pl[i * 2];
        if (!(gmode & 4)) {
            if (penmintab[pen]) {
                c = *(signed char *)puckc;
                if (c < 0 || (c < 6) ^ (pl < 6)) {
                    if (!(gmode & 8)) {
                        gmode |= 8;
                        SetPA(0x1C);
                    }
                    continue;
                }
                refsignal = 0x28;
                if (bannermsg != -1) bannertimer = 0x50;
            }
            Stop4Pen(i);
        }
        pl = PenBuf_pl[i * 2];
        if (pl & 0x80) continue;
        PenBuf_pl[i * 2] = pl | 0x80;
        t = pendelaytab[pen] << 5;
        if (t > Pencntdwn) Pencntdwn = t;
        if (word_CBEC6) Pencntdwn = 0x140;
        if (penshotstart && pen == 5) {
            t = byte_C9146 << 5;
            Pencntdwn = byte_C9111 << 5;
        } else {
            t = byte_C9142[pen] << 5;
        }
        if (t > word_CC0B0[0]) word_CC0B0[0] = t;
    }
}
