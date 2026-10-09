/* Highlights: highlight description line. */
#include "nhl95.h"

/* FormatHilightDesc (7FCA2) - PC only: write the description of highlight record h into out: "<month> <day>,
   <home city> vs <away city>, Period <p>, Time <mm>:<ss>." (bytes 0, 1, 2 and 1Fh; dwords +3Ch, +40h, +44h). */
void FormatHilightDesc(char *out, unsigned char *h)
{
    sprintf(out, (char *)str_HilightDescFmt, h[0], h[1], (char *)teamcitynames[h[2]], (char *)teamcitynames[h[0x1F]],
            *(int *)(h + 0x3C), *(int *)(h + 0x40), *(int *)(h + 0x44));
}
