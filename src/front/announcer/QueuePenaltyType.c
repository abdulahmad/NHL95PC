/* Announcer: preload the penalty number and clip names. */
#include "nhl95.h"

/* QueuePenaltyType: when the speech bank's used bytes (at +3B68h, base at +3B6Ch) pass 100000,
 reset the sample request and the queue, then request and queue "D##Num" for 0-9, 10-19 and 20-29.
 Past the same limit again, do 0-9 with the two-digit format. Past 150000, request and queue the
 14 penaltyclips. */
void QueuePenaltyType(void)
{
    char buf[16];
    int i;
    unsigned used;

    used = *(unsigned *)((char *)speechbank + 0x3B68) - *(unsigned *)((char *)speechbank + 0x3B6C);
    if (used > 0x186A0) {
        ResetSampleReq();
        ResetSpeechQueue();
        i = 0;
        do {
            sprintf(buf, (char *)str_DS, i, str_Num);
            RequestSample(buf);
            i++;
        } while (i < 10);
        i = 0;
        do {
            sprintf(buf, (char *)str_DS, i, str_Num);
            QueueSpeechClip(buf);
            i++;
        } while (i < 10);
    }
    used = *(unsigned *)((char *)speechbank + 0x3B68) - *(unsigned *)((char *)speechbank + 0x3B6C);
    if (used > 0x186A0) {
        ResetSampleReq();
        ResetSpeechQueue();
        i = 10;
        do {
            sprintf(buf, (char *)str_DS, i, str_Num);
            RequestSample(buf);
            i++;
        } while (i < 20);
        i = 10;
        do {
            sprintf(buf, (char *)str_DS, i, str_Num);
            QueueSpeechClip(buf);
            i++;
        } while (i < 20);
    }
    used = *(unsigned *)((char *)speechbank + 0x3B68) - *(unsigned *)((char *)speechbank + 0x3B6C);
    if (used > 0x186A0) {
        ResetSampleReq();
        ResetSpeechQueue();
        i = 20;
        do {
            sprintf(buf, (char *)str_DS, i, str_Num);
            RequestSample(buf);
            i++;
        } while (i < 30);
        i = 20;
        do {
            sprintf(buf, (char *)str_DS, i, str_Num);
            QueueSpeechClip(buf);
            i++;
        } while (i < 30);
    }
    used = *(unsigned *)((char *)speechbank + 0x3B68) - *(unsigned *)((char *)speechbank + 0x3B6C);
    if (used > 0x186A0) {
        ResetSampleReq();
        ResetSpeechQueue();
        i = 0;
        do {
            sprintf(buf, (char *)str_02dS, i, str_Num);
            RequestSample(buf);
            i++;
        } while (i < 10);
        i = 0;
        do {
            sprintf(buf, (char *)str_02dS, i, str_Num);
            QueueSpeechClip(buf);
            i++;
        } while (i < 10);
    }
    used = *(unsigned *)((char *)speechbank + 0x3B68) - *(unsigned *)((char *)speechbank + 0x3B6C);
    if (used > 0x249F0) {
        ResetSampleReq();
        ResetSpeechQueue();
        i = 0;
        do {
            RequestSample((char *)penaltyclips[i]);
            i++;
        } while (i < 14);
        i = 0;
        do {
            QueueSpeechClip((char *)penaltyclips[i]);
            i++;
        } while (i < 14);
    }
}
