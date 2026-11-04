/* Create player: rolling a new player's derived numbers. */
#define RandomizeNewRatings RandomizeNewRatings_decl
#define randomd0 randomd0_decl
#include "nhl95.h"
#undef RandomizeNewRatings
#undef randomd0

int randomd0(int range);

#define F(x) (*(float *)&(x))
#define D(x) (*(double *)&(x))

/* RandomizeNewRatings (6F6D4, PC only): roll the derived numbers of a new free agent from his ratings (RatingToFloat
   of bytes 1, 2, 4-7, 9-0Eh and 13h of r). A luck factor (1 - randomd0(14Dh) / C2CACh) and a random 40h-54h
   (out[0], then scaled) multiply every result. out[7] and out[8] come from ratings 0Ah, 0Bh, 0Dh and 0Eh; the
   two numbers out[1] / out[2] from ratings 1, 2, 4, 6, 7, 9, 0Ah, 0Dh and 0Eh, with defencemen (rec +2 'D')
   weighted differently, scaled down to 80h together when larger; out[3] is their sum, out[4] a tenth of out[1],
   out[5] random below that, and out[6] comes from ratings 5 and 0Ch. rec: the player record; r: the rating
   bytes; out: the words to fill (9). */
void RandomizeNewRatings(unsigned char *rec, unsigned char *r, unsigned short *out)
{
    struct {
        float v00;
        float v04;
        float v08;
        float f2;
        float f7;
        float f4;
        float fb;
        float f1;
        float f9;
        float f6;
        float fd;
        float f5;
        float v30;
        float fa;
        float v38;
        float fc;
        float luck;
        float fe;
        float scale;
    } s;
    unsigned short a;
    unsigned short b;
    float f13;  /* RatingToFloat(r[13h]), never read */

    s.f1 = RatingToFloat(r[1]);
    s.f2 = RatingToFloat(r[2]);
    s.f4 = RatingToFloat(r[4]);
    s.f5 = RatingToFloat(r[5]);
    s.f6 = RatingToFloat(r[6]);
    s.f7 = RatingToFloat(r[7]);
    s.f9 = RatingToFloat(r[9]);
    s.fa = RatingToFloat(r[0xA]);
    s.fb = RatingToFloat(r[0xB]);
    s.fc = RatingToFloat(r[0xC]);
    s.fd = RatingToFloat(r[0xD]);
    s.fe = RatingToFloat(r[0xE]);
    f13 = RatingToFloat(r[0x13]);
    s.luck = 1.0 - randomd0(0x14D) / F(dword_C2CAC);
    s.scale = randomd0(0x15) + 0x40;
    out[0] = s.scale;
    s.scale = s.scale / F(dword_C2CB0);
    out[7] = (s.fa + s.fd + s.fe) / F(dword_C2CB4) * F(dword_C2CB8) * s.scale * s.luck;
    out[8] = ((s.fa + s.fb) / F(dword_C2CBC) * F(dword_C2CC0) + F(dword_C2CC4)) * s.scale * s.luck;
    s.v08 = (s.f2 + s.fa + s.f6 + s.f1 + s.fd) / F(dword_C2CC8);
    if (rec[2] != 'D') {
        s.v38 = s.fe / F(dword_C2CD4);
        s.v30 = (F(dword_C2CC0) - s.fe) / F(dword_C2CD8);
    } else {
        s.v38 = s.fe / F(dword_C2CCC);
        s.v30 = (F(dword_C2CC0) - s.fe) / F(dword_C2CD0);
    }
    a = s.v38 < 1.0 ? (unsigned short)(s.v38 * F(dword_C2CDC)) : 0x3A;
    b = s.v30 < 1.0 ? (unsigned short)(s.v30 * F(dword_C2CCC)) : 0x5A;
    s.v04 = (s.f4 + s.f7) / F(dword_C2CBC) * a;
    s.v00 = s.f9 / F(dword_C2CC0) * b;
    a = s.v08 * s.v04 * s.scale * s.luck;
    b = s.v08 * s.v00 * s.scale * s.luck;
    if (a + b > 0x80) {
        a = a / ((a + b) / 0x80);
        b = b / ((a + b) / 0x80);
    }
    out[1] = a;
    out[2] = b;
    out[3] = out[1] + b;
    out[4] = out[1] / 10;
    out[5] = randomd0(out[4]);
    s.fc = s.fc * D(qword_C2CE0);
    s.f5 = s.f5 * D(qword_C2CE8);
    out[6] = (s.fc + s.f5) / F(dword_C2CC0) * F(dword_C2CF0) * s.scale * s.luck;
}
