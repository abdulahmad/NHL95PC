/* Title intro: text grid buffer. */
#include "nhl95.h"

/* TextGridFree: free the text grid buffer (if any) and clear the pointer. */
void TextGridFree(void)
{
    if (textgrid) _nfree((void *)textgrid);
    textgrid = 0;
}
