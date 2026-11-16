/* Engine sound interface: crowd volume. */
#define MidiProgramChange sub_8FD84_decl
#define MidiPitchBend sub_8FDE5_decl
#define MidiNoteOn sub_8FE1C_decl
#include "nhl95.h"
#undef MidiProgramChange
#undef MidiPitchBend
#undef MidiNoteOn

void MidiProgramChange(int card, int voice, int vol);
void MidiNoteOn(int card, int voice, int what);
void MidiPitchBend(int card, int voice, int what);

/* Crowd_Noise: with sound effects and a crowd device (sounddev & 2Ah), ease crowdsmooth toward
 Crowdlevel by at most n*30, map that to voice 8 and voice 7, and start or silence those voices.
 n is a signed step. */
void Crowd_Noise(int n)
{
    int step;
    int v;
    int pan;
    int lim;

    if (!gameopts.sfx) return;
    if (!(sounddev & 0x2A)) return;
    n = (short)n;
    step = n;
    step <<= 4;
    step -= n;
    step += step;
    v = *(int *)((char *)&Crowdlevel - 2) >> 16;
    v -= crowdsmooth;
    if ((v < 0 ? -v : v) > step) {
        if (v < 0) step = -step;
        crowdsmooth += step;
    } else
        crowdsmooth = *(int *)((char *)&Crowdlevel - 2) >> 16;
    v = crowdsmooth;
    if (v < 0x200)
        v = 0;
    else if (v < 0x390) {
        v = (v - 0x200) / 10;
        if (sounddev & 8) v += 0x20;
    } else {
        n = (v - 0x390) >> 2;
        v = n + 0x28;
        if (sounddev & 8) v += 0x20;
    }
    if (v > 0x7F) v = 0x7F;
    step = crowdsmooth / 12 + 0x0A;
    if (sounddev & 8) step += 0x32;
    if (step > 0x7F) step = 0x7F;
    if (step < 0x0A) step = 0x0A;
    if (crowdvol8 > 0 && v == 0) {
        MidiSetVolume(crowddriver, 8, 0);
        MidiNoteOff(crowddriver, 8, 0x24);
    } else if (crowdvol8 == 0 && v > 0) {
        MidiProgramChange(crowddriver, 8, 0x7D);
        MidiNoteOn(crowddriver, 8, 0x24);
        MidiPitchBend(crowddriver, 8, 0x40);
    }
    if (v > 0) {
        MidiSetVolume(crowddriver, 8, v);
        if (v >= 0x7F || crowdvol8 >= 0x7F)
            MidiPitchBend(crowddriver, 8, 0x40 - (v >= 0x7F ? (short)randomd0(6) : 0));
    }
    crowdvol8 = v;
    if (crowdvol7 == 0 && step > 0) {
        MidiProgramChange(crowddriver, 7, 0x7E);
        MidiNoteOn(crowddriver, 7, 0x24);
    }
    MidiSetVolume(crowddriver, 7, step);
    pan = step / 3 + 0x20;
    if (sounddev & 8)
        lim = 0x32;
    else
        lim = 0;
    lim += 0x0A;
    if (step == lim)
        pan += (short)randomd0(6);
    MidiPitchBend(crowddriver, 7, pan);
    crowdvol7 = step;
}
