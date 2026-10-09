/* Speech: state query. */
#include "nhl95.h"

/* SpeechIsInit (836CA) - 1 when the speech system has been initialised, else 0. */
int SpeechIsInit(void)
{
    return speechinit != 0;
}
