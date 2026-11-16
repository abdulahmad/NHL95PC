/* Engine sound interface: announcer wrappers. */
#include "nhl95.h"

/* PaTonightIntro: with music and announcer speech on: announce tonight's game between home and away
 (abbreviations; the first one is home's, or entry 12 for a team number 26 and up). */
void PaTonightIntro(int home, int away)
{
    int first;

    first = home;
    if (home >= 26) first = 12;
    if (MusicOn && gameopts.speech)
        SayTonightIntro((char *)teamabbrevs[first], (char *)teamabbrevs[away], (char *)teamabbrevs[home]);
}

/* PaScoringPeriod: with music and announcer speech on: SayScoringPeriod (arguments passed through). */
void PaScoringPeriod(int period, int b, int c)
{
    if (MusicOn && gameopts.speech) SayScoringPeriod(period, b, c);
}

/* PaNhlIntro: with music and announcer speech on: SayNhlIntro. */
void PaNhlIntro(void)
{
    if (MusicOn && gameopts.speech) SayNhlIntro();
}

/* PaGoodnight: with music and announcer speech on: SayGoodnight. */
void PaGoodnight(void)
{
    if (MusicOn && gameopts.speech) SayGoodnight();
}

/* PaLineups: with music and announcer speech on: SayLineups. */
void PaLineups(void)
{
    if (MusicOn && gameopts.speech) SayLineups();
}

/* PaElseNhl: with music and announcer speech on: SayElseNhl. */
void PaElseNhl(void)
{
    if (MusicOn && gameopts.speech) SayElseNhl();
}
