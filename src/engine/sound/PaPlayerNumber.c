/* PaPlayerNumber: the announcer says a player number. When sound is on (MusicOn) and the
 announcer option (gameopts bit 8) is set: reset the music channel (MusicChanReset), then SayPlayerNumber, passing the arguments through: the
 team abbreviation (teamabbrevs[team], the 'frm' clip), a phrase index (the str_Cor2 clip table) and the
 player number ('%d.num' clip). */
#include "nhl95.h"

void PaPlayerNumber(char *team, int phrase, int number)
{
    if (MusicOn && gameopts.speech) {
        MusicChanReset();
        SayPlayerNumber(team, phrase, number);
    }
}
