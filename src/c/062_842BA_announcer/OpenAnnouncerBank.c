/* Announcer: open the announcer speech bank. */
#include "nhl95.h"

/* OpenAnnouncerBank (85507) - PC only: when the speech system is up and idle, reset the sample requests and the
   speech queue and open the bank XBRUCE2.VIV (from the CD when the file is on it). Returns 1 then; 0 without
   speech, or SpeechIdle's 0 while speech is busy. */
int OpenAnnouncerBank(void)
{
    char path[16];
    int idle;

    if (speechinit == 0) return 0;
    if ((idle = SpeechIdle()) == 0) return idle;
    ResetSampleReq();
    ResetSpeechQueue();
    MakePath(path, fileoncd[0x1C0] == 1 ? (char *)cddriveptr : 0, (char *)str_XBRUCE2, (char *)str_VIV);
    OpenSpeechBank(path, 0);
    return 1;
}
