/* Main / startup: memory statistics. */
#include "nhl95.h"

/* one block of the memory list: start at +0, size +10h, flags byte +19h (bit 7: free), next +20h */
typedef struct MemBlock {
    unsigned start;
    int pad1[3];
    unsigned size;
    char pad2[5];
    signed char flags;
    char pad3[6];
    struct MemBlock *next;
} MemBlock;

/* GetMemStats (1002A) - PC only: walk memory list 1 (GetMemListHead). *used = sizes of the blocks in use, *gaps =
   free bytes between blocks (*biggest the largest gap), *total = used + gaps. */
void GetMemStats(unsigned *total, unsigned *used, unsigned *gaps, unsigned *biggest)
{
    MemBlock *prev;
    MemBlock *b;
    unsigned gap;

    prev = (MemBlock *)GetMemListHead(1);
    b = prev->next;
    *total = *used = *gaps = *biggest = 0;
    while (b != NULL) {
        gap = b->start - prev->start - prev->size;
        if ((b->flags & 0x80) == 0) *used += b->size;
        *gaps += gap;
        if (gap > *biggest) *biggest = gap;
        prev = b;
        b = b->next;
    }
    *total = *used + *gaps;
}
