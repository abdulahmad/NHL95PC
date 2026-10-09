/* File utilities: disk space. */
#include "nhl95.h"

/* DiskSpaceShort (14825) - whether the files of kb[] (sizes in KB, 0-terminated) fit on drive, counted in whole
   clusters: 0 when they fit, else the KB needed. A DOS error is fatal. */
typedef struct DiskFree {
    unsigned short total_clusters;
    unsigned short avail_clusters;
    unsigned short sectors_per_cluster;
    unsigned short bytes_per_sector;
} DiskFree;

int DiskSpaceShort(int drive, int *kb)
{
    DiskFree d;
    int total;
    int cl;

    total = 0;
    if (_dos_getdiskfree(drive, &d)) FatalError((char *)str_ErrDiskFree4);
    cl = d.bytes_per_sector * d.sectors_per_cluster / 1024;
    for (; *kb; kb++) total += (*kb + cl - 1) / cl;
    if (total <= d.avail_clusters) return 0;
    return total * cl;
}
