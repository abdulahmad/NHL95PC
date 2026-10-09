/* Season / playoffs: line editing. */
#include "nhl95.h"

/* ClearPlayerFromLines (8B96D) - replace player p by 64h (empty) in a team's line-up block: once per forward line (4 lines
   of 3), once per defence pair (3 pairs of 2), once in each of the special-team groups at 12h (5), 17h (5), 1Ch (4)
   and 20h (4), and in each of the single slots 24h-27h. */
void ClearPlayerFromLines(unsigned char p, unsigned char *lines)
{
    int i;
    unsigned char *l;

    for (i = 0; i < 4; i++) {
        l = lines + i * 3;
        if (p == l[0]) l[0] = 0x64;
        else if (p == l[1]) l[1] = 0x64;
        else if (p == l[2]) l[2] = 0x64;
    }
    for (i = 0; i < 3; i++) {
        l = lines + i * 2;
        if (p == l[0x0C]) l[0x0C] = 0x64;
        else if (p == l[0x0D]) l[0x0D] = 0x64;
    }
    if (p == lines[0x12]) lines[0x12] = 0x64;
    else if (p == lines[0x13]) lines[0x13] = 0x64;
    else if (p == lines[0x14]) lines[0x14] = 0x64;
    else if (p == lines[0x15]) lines[0x15] = 0x64;
    else if (p == lines[0x16]) lines[0x16] = 0x64;
    if (p == lines[0x17]) lines[0x17] = 0x64;
    else if (p == lines[0x18]) lines[0x18] = 0x64;
    else if (p == lines[0x19]) lines[0x19] = 0x64;
    else if (p == lines[0x1A]) lines[0x1A] = 0x64;
    else if (p == lines[0x1B]) lines[0x1B] = 0x64;
    if (p == lines[0x1C]) lines[0x1C] = 0x64;
    else if (p == lines[0x1D]) lines[0x1D] = 0x64;
    else if (p == lines[0x1E]) lines[0x1E] = 0x64;
    else if (p == lines[0x1F]) lines[0x1F] = 0x64;
    if (p == lines[0x20]) lines[0x20] = 0x64;
    else if (p == lines[0x21]) lines[0x21] = 0x64;
    else if (p == lines[0x22]) lines[0x22] = 0x64;
    else if (p == lines[0x23]) lines[0x23] = 0x64;
    if (p == lines[0x24]) lines[0x24] = 0x64;
    if (p == lines[0x25]) lines[0x25] = 0x64;
    if (p == lines[0x26]) lines[0x26] = 0x64;
    if (p == lines[0x27]) lines[0x27] = 0x64;
}
