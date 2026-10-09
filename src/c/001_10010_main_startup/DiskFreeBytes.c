/* Main / startup: disk space. */
#include "nhl95.h"

/* DiskFreeBytes (106C8) - free bytes on drive (0 = default): available clusters * sectors per cluster * bytes per
   sector; a DOS error is fatal. */
typedef struct DiskFree {
    unsigned short total_clusters;
    unsigned short avail_clusters;
    unsigned short sectors_per_cluster;
    unsigned short bytes_per_sector;
} DiskFree;

unsigned DiskFreeBytes(int drive)
{
    DiskFree d;

    if (_dos_getdiskfree(drive, &d)) FatalError((char *)str_ErrDiskFree3);
    return (unsigned)d.avail_clusters * d.sectors_per_cluster * d.bytes_per_sector;
}
