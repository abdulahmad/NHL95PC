/* Announcer: release a loaded clip. */
#include "nhl95.h"

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
