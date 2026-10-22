/* Speech: sample memory. */
#include "nhl95.h"

/* FreeUnrequestedSamples: free the last loaded speech slot (of 400) whose sample is not requested: clear
 loaded, take its size off the bank's used bytes (+3B6Ch) and one off the loaded count (+3B74h). Returns 1
 when one was freed. */
int FreeUnrequestedSamples(void)
{
    int i;

    for (i = 0x18F; i >= 0; i--) {
        if (speechbank[i].loaded == 1 && !IsSampleRequested((char *)&speechbank[i])) {
            speechbank[i].loaded = 0;
            *(int *)((unsigned char *)speechbank + 0x3B6C) -= speechbank[i].size;
            (*(int *)((unsigned char *)speechbank + 0x3B74))--;
            return 1;
        }
    }
    return 0;
}
