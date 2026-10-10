/* Engine sound interface: announcer wrappers. */
#include "nhl95.h"

/* PaTonightIntro (59BB5) - with music and announcer speech on: announce tonight's game between home and away
   (abbreviations; the first one is home's, or entry 12 for a team number 26 and up). */
void PaTonightIntro(int home, int away)
{
    int first;

    first = home;
    if (home >= 26) first = 12;
    if (musicon && gameopts.speech)
        SayTonightIntro((char *)teamabbrevs[first], (char *)teamabbrevs[away], (char *)teamabbrevs[home]);
}

/* PaScoringPeriod (59BFC) - with music and announcer speech on: SayScoringPeriod (arguments passed through). */
void PaScoringPeriod(int period, int b, int c)
{
    if (musicon && gameopts.speech) SayScoringPeriod(period, b, c);
}

/* PaNhlIntro (59C1D) - with music and announcer speech on: SayNhlIntro. */
void PaNhlIntro(void)
{
    if (musicon && gameopts.speech) SayNhlIntro();
}

/* PaGoodnight (59C3E) - with music and announcer speech on: SayGoodnight. */
void PaGoodnight(void)
{
    if (musicon && gameopts.speech) SayGoodnight();
}

/* PaLineups (59C5F) - with music and announcer speech on: SayLineups. */
void PaLineups(void)
{
    if (musicon && gameopts.speech) SayLineups();
}

/* PaElseNhl (59C80) - with music and announcer speech on: SayElseNhl. */
void PaElseNhl(void)
{
    if (musicon && gameopts.speech) SayElseNhl();
}
