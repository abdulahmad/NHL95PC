/* Announcer: fixed-clip say / free wrappers and FreeClip. */
#include "nhl95.h"

/* SayNhlIntro (846B4) - PC only: say the NHL intro clip (SayClip). */
int SayNhlIntro(void)
{
    return SayClip((char *)str_NhlInt);
}

/* SayGoodnight (846C8) - PC only: say the goodnight clip. */
int SayGoodnight(void)
{
    return SayClip((char *)str_GoodniteInt);
}

/* SayLineups (846DC) - PC only: say the lineups clip. */
int SayLineups(void)
{
    return SayClip((char *)str_LineupsInt);
}

/* SayNowBack (846F0) - PC only: say the "now back" clip. */
int SayNowBack(void)
{
    return SayClip((char *)str_NowbackInt);
}

/* FreeNowBack (84704) - PC only: release the "now back" clip. */
void FreeNowBack(void)
{
    FreeClip((char *)str_NowbackInt);
}

/* SayBackMoment (84715) - PC only: say the "back in a moment" clip. */
int SayBackMoment(void)
{
    return SayClip((char *)str_BackmomtInt);
}

/* FreeBackMoment (84729) - PC only: release the "back in a moment" clip. */
void FreeBackMoment(void)
{
    FreeClip((char *)str_BackmomtInt);
}

/* SayCoachClip (8473A) - PC only: say the coach clip. */
int SayCoachClip(void)
{
    return SayClip((char *)str_CoachclpInt);
}

/* FreeCoachClip (8474E) - PC only: release the coach clip (falls into FreeClip). */
void FreeCoachClip(void)
{
    FreeClip((char *)str_CoachclpInt);
}

/* FreeClip (8475D) - PC only: when clip name is loaded in the speech bank (FindSpeechSlot; 38-byte slots) with
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

/* SayElseNhl (847BA) - PC only: say the "elsewhere in the NHL" clip. */
int SayElseNhl(void)
{
    return SayClip((char *)str_ElsenhlInt);
}
