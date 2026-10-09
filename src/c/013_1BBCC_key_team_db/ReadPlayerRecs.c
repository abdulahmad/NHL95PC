/* Key / team databases: player records. */
#include "nhl95.h"

/* ReadPlayerRecs (1C0AF) - read one player's records from four open database files: the 34h-byte key record at off in f1
   (hdr), then n2 bytes of f2 at hdr dword +24h, n3 bytes of f3 at +2Ch and, when n4 is not 0, n4 bytes of f4 at
   +28h (each file rewound first). Any failure is fatal. Returns 0 when n4 is 0 (otherwise the value is
   undefined, as in the original). */
int ReadPlayerRecs(int f1, int f2, int f3, int f4, long off, unsigned char *hdr, void *b2, unsigned n2, void *b3, unsigned n3, void *b4, unsigned n4)
{
    int r;

    if (lseek(f1, 0, 0)) FatalError((char *)str_feD);
    if (lseek(f1, off, 0) < 0) FatalError((char *)str_feE);
    if (FileReadAt(f1, hdr, -1, 0x34)) FatalError((char *)str_feF);
    if (lseek(f2, 0, 0)) FatalError((char *)str_feG);
    if (lseek(f2, *(long *)(hdr + 0x24), 0) < 0) FatalError((char *)str_feH);
    if (FileReadAt(f2, b2, -1, n2)) FatalError((char *)str_feI);
    if (lseek(f3, 0, 0)) FatalError((char *)str_feL);
    if (lseek(f3, *(long *)(hdr + 0x2C), 0) < 0) FatalError((char *)str_feM);
    if (FileReadAt(f3, b3, -1, n3)) FatalError((char *)str_feN);
    if (n4 == 0) {
        r = 0;
    } else {
        if (lseek(f4, 0, 0)) FatalError((char *)str_feO);
        if (lseek(f4, *(long *)(hdr + 0x28), 0) < 0) FatalError((char *)str_feP);
        if (FileReadAt(f4, b4, -1, n4)) FatalError((char *)str_feQ);
    }
    return r;
}
