/* Speech and announcer: shut down, 24-bit reads, slot loading, saying clips. One source module across segments
   060-062, in address order: the slot loaders end in ShutdownSpeech's and ReadBE24's exits; Watcom moves SayClip's
   entry after SayScoringPeriod (its tail caller) and leaves its body (SayClip_body) after LoadClipSlot, so SayClip,
   SayTheGame and SayScoringPeriod match only with this whole group in one file (found by tools/module_try.py).
   EnsureSampleRoom and CompactSpeechMem (segment 061) stay last: CompactSpeechMem ends in FreeClip_ret. */
#include "nhl95.h"

#define BANKD(off) (*(int *)((char *)speechbank + (off)))

/* the speech queue (speechq, 100 bytes): clip slots to say in order, then the playback state */
typedef struct SpeechQ {
    int clip[20];               /* 00h: speechbank slots, -1 ends the sentence */
    int delay;                  /* 50h: ticks until the next clip */
    int count;                  /* 54h: clips queued */
    int pos;                    /* 58h: next clip */
    int idle;                   /* 5Ch: ticks of silence after a sentence */
    int playing;                /* 60h: a sentence is being said */
} SpeechQ;
#define SPEECHQ ((SpeechQ *)speechq)

/* SpeechTimerTick (832BC, PC only; segment 060, the same source file: it ends in ShutdownSpeech_ret5): the timer
   handler InitSpeech installs (addtimer). With the speech system up: count the silence after a sentence down;
   while a sentence plays, count the clip delay down, then start the next clip: its sample (data, size) plays on
   channel dword_D27B2 (toggled 0 / 1 per clip) through sub_8FBE5 for kind 'G' or sub_8FC37 (twice the size), at
   2B11h, volume 7Fh, and its delay is loaded. A slot of -1 ends the sentence; after the last clip the sentence
   ends and the silence is the bank's value at +3B70h. No arguments, no result. */
void SpeechTimerTick(void)
{
    SpeechSlot *s;
    int n;
    int clip;
    int data;
    int len;

    if (!speechinit) return;
    if (SPEECHQ->idle) SPEECHQ->idle--;
    if (!SPEECHQ->playing) return;
    if (SPEECHQ->delay) {
        SPEECHQ->delay--;
        return;
    }
    n = SPEECHQ->pos++;
    if (n < SPEECHQ->count) {
        clip = SPEECHQ->clip[n];
        if (clip == -1) {
            SPEECHQ->playing = 0;
            return;
        }
        s = &speechbank[clip];
        data = s->data;
        len = s->size;
        SPEECHQ->delay = s->delay;
        dword_D27B2++;
        dword_D27B2 &= 1;
        if (s->kind == 'G') sub_8FBE5(data, musichandle, dword_D27B2, len, 0x2B11, 0x7F);
        else {
            len *= 2;
            sub_8FC37(data, musichandle, dword_D27B2, len, 0x2B11, 0x7F);
        }
    } else {
        SPEECHQ->playing = 0;
        SPEECHQ->idle = BANKD(0x3B70);
    }
}

/* ShutdownSpeech: when the speech system is up, remove the SpeechTimerTick timer handler,
 close the open bank file (flag +3B78h, handle +3B7Ch of speechbank), free the speech queue, the sample memory
 (+3B60h, sub_8D2F0), the bank and the request block, and clear speechinit. */
void ShutdownSpeech(void)
{
    if (speechinit != 0) {
        RemoveTimerCallback(SpeechTimerTick);
        if (BANKD(0x3B78) != 0) _dos_close(BANKD(0x3B7C));
        FreeMemBlock(speechq);
        sub_8D2F0(BANKD(0x3B60));
        FreeMemBlock((int)speechbank);
        FreeMemBlock((int)samplereq);
        speechinit = 0;
    }
}


/* ReadBE24: read three bytes from file fh, most significant first (the VIV bank headers are
 big-endian), and return them as a number. */
int ReadBE24(int fh)
{
    unsigned got;
    int value;

    ((unsigned char *)&value)[3] = 0;
    _dos_read(fh, (unsigned char *)&value + 2, 1, &got);
    _dos_read(fh, (unsigned char *)&value + 1, 1, &got);
    _dos_read(fh, (unsigned char *)&value, 1, &got);
    return value;
}

/* an int field of speech slot n (26h bytes each) */
#define SLOTD(n, off) (*(int *)((char *)speechbank + (n) * 0x26 + (off)))
#define SLOTFREQ (*(double *)&qword_C37C8)
#define SLOTRATE (*(double *)&qword_C37D0)

/* LoadSpeechSlot: load sample n into the speech memory right after slot n - 1 (slot 0 at the
 memory start +3B64h): its address (+0Eh), size (ReadSpeechSample, +16h), its play time size * C37C8 C37D0 less
 the bank's +3B70h (+1Eh), loaded (+22h); count the bytes (+3B6Ch) and loaded slots (+3B74h). */
void LoadSpeechSlot(int n)
{
    int addr;
    int size;
    int off;
    int t;
    char *p;

    if (n == 0) addr = BANKD(0x3B64);
    else {
        p = (n - 1) * 0x26 + (char *)speechbank;
        addr = *(int *)(p + 0xE) + *(int *)(p + 0x16);
    }
    off = n * 0x26;
    *(int *)(off + (char *)speechbank + 0xE) = addr;
    size = ReadSpeechSample(n, addr);
    *(int *)(off + (char *)speechbank + 0x16) = size;
    t = BANKD(0x3B70);
    *(int *)(off + (char *)speechbank + 0x1E) = (unsigned)((unsigned)size * SLOTFREQ / SLOTRATE) - t;
    *(int *)(off + (char *)speechbank + 0x22) = 1;
    BANKD(0x3B6C) += size;
    BANKD(0x3B74)++;
}

/* PlaceSpeechSlot: read sample n (file offset +12h, length +1Ah) from the open bank file into the
 speech memory after slot n - 1 and mark it loaded; count the bytes read (+3B6Ch) and loaded slots (+3B74h). */
void PlaceSpeechSlot(int n)
{
    unsigned got;
    unsigned len;
    int addr;
    int fh;

    if (n == 0) addr = BANKD(0x3B64);
    else addr = SLOTD(n - 1, 0xE) + SLOTD(n - 1, 0x16);
    SLOTD(n, 0xE) = addr;
    fh = BANKD(0x3B7C);
    len = SLOTD(n, 0x1A);
    lseek(fh, SLOTD(n, 0x12), 0);
    _dos_read(fh, (void *)addr, len, &got);
    SLOTD(n, 0x22) = 1;
    BANKD(0x3B6C) += got;
    BANKD(0x3B74)++;
}

/* QueueSpeechClip (84418, PC only; announcer segment 062, the same source file: it ends in ShutdownSpeech_ret6):
   append the named clip to the speech queue. A clip whose sample is in memory is queued as it is; otherwise its
   bank slot is swapped with a free slot (FindFreeSpeechSlot) and, when the sample still fits the speech memory
   (bank +3B6Ch used + its size, up to +3B68h), loaded (kind 'G': LoadSpeechSlot) or placed (PlaceSpeechSlot)
   there and that slot queued. name: the clip name. Result: 1 when queued; 0 (and the queue entry dropped) when
   the clip is unknown, no slot is free or the sample does not fit.
   DRAFT: 293 vs 289. slot is in ebp, free in ebx and the swapped slot pointer in edx (original ebx, edx, ebp);
   pos and free, and off and bank, sit in swapped stack slots; the first queue store reloads pos. See UNSURE. */
int QueueSpeechClip(char *name)
{
    int pos;
    int slot;
    int free;
    int loaded;
    SpeechSlot tmp;
    int off;
    SpeechSlot *bank;
    SpeechSlot *dst;

    pos = SPEECHQ->count++;
    slot = FindSpeechSlot(name);
    if (slot == -1) {
fail:
        SPEECHQ->count--;
        return 0;
    }
    loaded = SpeechSlotLoaded(slot);
    if (loaded) {
        SPEECHQ->clip[pos] = slot;
        return 1;
    }
    free = FindFreeSpeechSlot(loaded);
    if (free == -1) goto fail;
    off = free * 0x26;
    bank = speechbank;
    dst = (SpeechSlot *)((char *)bank + off);
    tmp = *dst;
    *dst = bank[slot];
    speechbank[slot] = tmp;
    dst = (SpeechSlot *)((char *)speechbank + off);
    if ((unsigned)(BANKD(0x3B6C) + dst->size) > (unsigned)BANKD(0x3B68)) goto fail;
    if (dst->kind == 'G') LoadSpeechSlot(free);
    else PlaceSpeechSlot(free);
    SPEECHQ->clip[pos] = free;
    return 1;
}

/* LoadClipSlot: swap the named clip's slot with a free slot when the sample still fits,
 then load it (goalie clips, type byte 'G') or place it from the bank. */
int LoadClipSlot(char *name)
{
    int slot;
    int free;
    int loaded;
    SpeechSlot tmp;
    int off;
    SpeechSlot *src;

    slot = FindSpeechSlot(name);
    if (slot == -1)
        return 0;
    loaded = SpeechSlotLoaded(slot);
    if (loaded)
        return 1;
    free = FindFreeSpeechSlot(loaded);
    if (free == -1)
        return 0;
    off = slot * 0x26;
    src = (SpeechSlot *)((char *)speechbank + off);
    if ((unsigned)(BANKD(0x3B6C) + src->size) > (unsigned)BANKD(0x3B68))
        return 0;
    tmp = speechbank[free];
    speechbank[free] = *src;
    speechbank[slot] = tmp;
    if (((unsigned char *)&speechbank[free])[0xD] == 0x47)
        LoadSpeechSlot(free);
    else
        PlaceSpeechSlot(free);
    return 1;
}

/* SayClip (84AAE, PC only): say the speech clip name now: when the speech system is up (speechinit) and idle
   (SpeechIdle), clear the queue and the sample requests, reset the bank's loaded count (+3B70h), request and
   make room for the clip and queue it, then mark the queue busy (speechq +60h). Result: 1 when it was queued,
   else 0. Watcom splits it: the entry (84AAE, up to the speechinit test) sits after SayScoringPeriod, which
   tail-calls it, and the rest (SayClip_body, 8460F) here after LoadClipSlot; both are marked blocks. */
int SayClip(char *name)
{
    if (!speechinit) return 0;
    if (!SpeechIdle()) return 0;
    ResetSpeechQueue();
    ResetSampleReq();
    BANKD(0x3B70) = 0;
    RequestSample(name);
    EnsureSampleRoom();
    QueueSpeechClip(name);
    *(int *)((char *)speechq + 0x60) = 1;
    return 1;
}

/* SayScorePeriod: when speech is up and idle: queue the "scoring by period" clip for period per (scorperclips)
 and start the queue; returns 1, else 0. */
int SayScorePeriod(int per)
{
    if (!speechinit) return 0;
    if (!SpeechIdle()) return 0;
    ResetSpeechQueue();
    ResetSampleReq();
    RequestSample((char *)scorperclips[per]);
    EnsureSampleRoom();
    QueueSpeechClip((char *)scorperclips[per]);
    ((int *)speechq)[0x60 / 4] = 1;
    return 1;
}

/* SayNhlIntro: say the NHL intro clip (SayClip). */
int SayNhlIntro(void)
{
    return SayClip((char *)str_NhlInt);
}

/* SayGoodnight: say the goodnight clip. */
int SayGoodnight(void)
{
    return SayClip((char *)str_GoodniteInt);
}

/* SayLineups: say the lineups clip. */
int SayLineups(void)
{
    return SayClip((char *)str_LineupsInt);
}

/* SayNowBack: say the "now back" clip. */
int SayNowBack(void)
{
    return SayClip((char *)str_NowbackInt);
}

/* FreeNowBack: release the "now back" clip. */
void FreeNowBack(void)
{
    FreeClip((char *)str_NowbackInt);
}

/* SayBackMoment: say the "back in a moment" clip. */
int SayBackMoment(void)
{
    return SayClip((char *)str_BackmomtInt);
}

/* FreeBackMoment: release the "back in a moment" clip. */
void FreeBackMoment(void)
{
    FreeClip((char *)str_BackmomtInt);
}

/* SayCoachClip: say the coach clip. */
int SayCoachClip(void)
{
    return SayClip((char *)str_CoachclpInt);
}

/* FreeCoachClip: release the coach clip (falls into FreeClip). */
void FreeCoachClip(void)
{
    FreeClip((char *)str_CoachclpInt);
}

/* FreeClip: when clip name is loaded in the speech bank (FindSpeechSlot; 38-byte slots) with
 its in-use flag (+22h) 1: clear the flag, take its size (+16h) off the used sample bytes (+3B6Ch of
 speechbank) and one off the clip count (+3B74h), then EnsureSampleRoom. */
void FreeClip(char *name)
{
    int slot;
    unsigned char *e;
    int used;
    int off;

    if ((slot = FindSpeechSlot(name)) == -1) return;
    off = slot * 38;
    e = (unsigned char *)speechbank + off;
    if ((used = *(int *)(e + 0x22)) != 1) return;
    *(int *)(e + 0x22) = 0;
    *(int *)((char *)speechbank + 0x3B6C) -= *(int *)((char *)speechbank + off + 0x16);
    *(int *)((char *)speechbank + 0x3B74) -= used;
    EnsureSampleRoom();
}

/* SayElseNhl: say the "elsewhere in the NHL" clip. */
int SayElseNhl(void)
{
    return SayClip((char *)str_ElsenhlInt);
}

/* SayHighlightIntro: like SayTonightIntro: "Take you now to <rnk> highlight of game between <away> and <home>". */
int SayHighlightIntro(char *rnk, char *away, char *home)
{
    char r[16];
    char a[16];
    char h[16];

    if (!speechinit) return 0;
    if (!SpeechIdle()) return 0;
    *(int *)((char *)speechbank + 0x3B70) = 0;
    sprintf(r, (char *)str_SS5, rnk, str_Rnk);
    sprintf(a, (char *)str_SS5, away, str_Awa);
    sprintf(h, (char *)str_SS5, home, str_Hom);
    ResetSpeechQueue();
    ResetSampleReq();
    RequestSample((char *)str_TakeynowBar);
    RequestSample(r);
    RequestSample((char *)str_HighliteBar);
    RequestSample((char *)str_OfBar);
    RequestSample((char *)str_GamebtwnBar);
    RequestSample(a);
    RequestSample((char *)str_AndBar);
    RequestSample(h);
    EnsureSampleRoom();
    QueueSpeechClip((char *)str_TakeynowBar);
    QueueSpeechClip(r);
    QueueSpeechClip((char *)str_HighliteBar);
    QueueSpeechClip((char *)str_OfBar);
    QueueSpeechClip((char *)str_GamebtwnBar);
    QueueSpeechClip(a);
    QueueSpeechClip((char *)str_AndBar);
    QueueSpeechClip(h);
    ((int *)speechq)[0x60 / 4] = 1;
    return 1;
}

/* SayPlayoffResult: when speech is up and idle: "[In overtime] <team> have won [game <game> of] <round clip>"
 (team clip <team>Awa, round clip from PlayoffRoundClipD; the game number part only when final is 0); starts
 the queue and returns 1, else 0. */
int SayPlayoffResult(char *team, int game, unsigned conf, unsigned round, int ot, int final)
{
    char t[16];
    char rc[16];
    char g[16];
    char num[16];

    if (!speechinit) return 0;
    if (!SpeechIdle()) return 0;
    *(int *)((char *)speechbank + 0x3B70) = 0;
    sprintf(t, (char *)str_SS5, team, str_Awa);
    itoa(game, num, 10);
    sprintf(g, (char *)str_SSS, str_Gamenum, num, str_Bar);
    PlayoffRoundClipD(rc, conf, round);
    ResetSampleReq();
    ResetSpeechQueue();
    if (ot) RequestSample((char *)str_OvertimeBar);
    RequestSample(t);
    RequestSample((char *)str_HavewonBar);
    if (!final) {
        RequestSample((char *)str_GamenumBar);
        RequestSample(g);
        RequestSample((char *)str_OfBar);
    }
    RequestSample(rc);
    EnsureSampleRoom();
    if (ot) QueueSpeechClip((char *)str_OvertimeBar);
    QueueSpeechClip(t);
    QueueSpeechClip((char *)str_HavewonBar);
    if (!final) {
        QueueSpeechClip((char *)str_GamenumBar);
        QueueSpeechClip(g);
        QueueSpeechClip((char *)str_OfBar);
    }
    QueueSpeechClip(rc);
    ((int *)speechq)[0x60 / 4] = 1;
    return 1;
}

/* SayTheGame (84A6C, PC only): say "the game" (thegame.bar). Result: as SayClip (its `jmp short SayClip` reaches
   SayClip's entry, which Watcom moves right after SayScoringPeriod). */
int SayTheGame(void)
{
    return SayClip((char *)str_ThegameBar);
}

/* SayScoringPeriod (84A7D, PC only): say the scoring summary clip for a period: "the game" when over is set; in
   overtime (ot) the 1st, 2nd, 3rd or later overtime clip; else the 1st-3rd period clip (other periods: nothing).
   period: 1-based; ot, over: flags. Result: as SayClip, 0 when nothing is said. Its code is interleaved with
   SayClip's entry: the pieces SayScoringPeriod_ot2 .. _reg follow SayClip's ret (a block of their own). */
int SayScoringPeriod(int period, int ot, int over)
{
    if (over) return SayClip((char *)str_ThegameBar);
    if (ot) {
        switch (period) {
        case 1: return SayClip((char *)str_Scor1otpBar);
        case 2: return SayClip((char *)str_Scor2otpBar);
        case 3: return SayClip((char *)str_Scor3otpBar);
        default: return SayClip((char *)str_ScortotpBar);
        }
    }
    switch (period) {
    case 1: return SayClip((char *)str_Scor1perBar);
    case 2: return SayClip((char *)str_Scor2perBar);
    case 3: return SayClip((char *)str_Scor3perBar);
    }
    return 0;
}

/* EnsureSampleRoom (8426F, PC only; speech segment 061, the same source file): make room in the sample memory
   (MakeSampleRoom) and pack it (CompactSpeechMem, which follows: the tail call falls through). No arguments,
   no result. */
void EnsureSampleRoom(void)
{
    MakeSampleRoom();
    CompactSpeechMem();
}

/* CompactSpeechMem (8427E, PC only; segment 061, ends in FreeClip_ret): pack the loaded samples down: while a free
   slot (FindFreeSpeechSlot, from slot 0) has a loaded slot after it (FindLoadedSpeechSlot), move that one into it
   (CompactSpeechSlot) and continue from the next free slot. When no slot is free at all, the loaded-slot test uses
   whatever free was left in edx (as in the original). FindLoadedSpeechSlot is called without an argument: the
   original loads no eax there and relies on f still being in eax from the FindFreeSpeechSlot call. No arguments,
   no result. */
void CompactSpeechMem(void)
{
    int f;
    int l;

    f = FindFreeSpeechSlot(0);
    if (f == -1) goto test;
again:
    l = ((int (*)(void))FindLoadedSpeechSlot)();
test:
    if (l == -1) return;
    CompactSpeechSlot(f, l);
    f = FindFreeSpeechSlot(f);
    goto again;
}
