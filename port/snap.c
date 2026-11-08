/* States of the running game (snap.h). */
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#if defined(_WIN32)
#include <malloc.h>
#else
#include <alloca.h>
#endif
#include "host.h"
#include "snap.h"
#include "overbar/snap.h"

#define NOINLINE __attribute__((noinline))
#define DATA_LO 0xC0000u        /* the game's data object (orig addresses: sources/segments.txt, object 2) */
#define DATA_HI 0xFAB90u

extern uint8_t unk_C0000[], byte_D8C88[], unk_F7B88[];
static char *stack_base;

void snap_set_stack_base(void *base) { stack_base = (char *)base; }

NOINLINE char *snap_sp(void) { return (char *)__builtin_frame_address(0) - 512; }

int snap_regions(snap_region *r, int max)
{
    int n = 0;
    if (max < 1) return -1;
#if defined(_WIN32)
    /* the Windows link folds the game's sections into .data and .bss behind the host's own, in the game's order, so the data is found by its
     * symbols, not by its original address */
    r[n].p = (uint8_t *)unk_C0000;
    r[n].n = 0xD8B68u - DATA_LO;
    n++;
    r[n].p = (uint8_t *)(byte_D8C88) - (0xD8C88u - 0xD8B68u);
    r[n].n = (size_t)(((uint8_t *)unk_F7B88 + (DATA_HI - 0xF7B88u)) - (uint8_t *)r[n].p);
    n++;
#else
    r[n].p = (uint8_t *)sub_10000 + (DATA_LO - 0x10000);
    r[n].n = DATA_HI - DATA_LO;
    n++;
#endif
    return dos_snap_regions(r, n, max);
}

static int gather(snap_region *r, const snap_region *extra, int nextra)
{
    int n = snap_regions(r, SNAP_MAX_REGIONS), i;
    if (n < 0 || n + nextra > SNAP_MAX_REGIONS) return -1;
    for (i = 0; i < nextra; i++) r[n++] = extra[i];
    return n;
}

/* The memory is kept by Overbar's overbar/snap: only the pages that differ from a base copy, the DPMI blocks (most of the 68 MB) write-watched.
 * The blob of a state is the game thread's stack from `low` to its base. */
static ob_snap_store *store;
static unsigned snap_saves;

const char *snap_stats(void) { return store ? ob_snap_stats(store) : ""; }

int snap_save(snap *s, void **jb, char *low, const snap_region *extra, int nextra)
{
    static snap_region r[SNAP_MAX_REGIONS];
    int n;
    if (!stack_base || !low || low >= stack_base) return -1;
    s->valid = 0;
    if (!store && !(store = ob_snap_store_new(plat_write_watch))) return -1;
    n = gather(r, extra, nextra);
    if (n < 0) return -1;
    s->stack = (size_t)(stack_base - low);
    if (ob_snap_take(store, &s->os, (const ob_snap_region *)r, n, low, s->stack)) return -1;
    s->nregs = n;
    s->size = s->os.size;
    s->ndiff = s->os.ndiff;
    s->low = low;
    s->jb_at = jb;
    memcpy(s->jb, jb, sizeof s->jb);
    s->valid = 1;
    snap_saves++;
    return 0;
}

int snap_fits(const snap *s, const snap_region *extra, int nextra)
{
    static snap_region now[SNAP_MAX_REGIONS];
    int n = s->valid ? gather(now, extra, nextra) : -1;
    if (n < 0) return -1;
    return ob_snap_fits(store, &s->os, (const ob_snap_region *)now, n);
}

int snap_restore_memory(const snap *s)
{
    if (!s->valid || !store) return -1;
    return ob_snap_put(store, &s->os);
}

/* (below every byte the state's stack puts back, so no interrupt frame or call here is overwritten) */
NOINLINE static void put_back(const snap *s)
{
    memcpy(s->low, ob_snap_blob(&s->os, NULL), s->stack);
    memcpy(s->jb_at, s->jb, sizeof s->jb);
    __builtin_longjmp(s->jb_at, 1);
}

NOINLINE void snap_jump(const snap *s)
{
    char *sp = snap_sp();
    if (sp > s->low - 8192) {
        volatile char *pad = alloca((size_t)(sp - (s->low - 8192)));
        pad[0] = 0;
        put_back(s);
    }
    put_back(s);
    __builtin_unreachable();
}

void snap_free(snap *s) { ob_snap_free(&s->os); memset(s, 0, sizeof *s); }

uint64_t snap_hash(const snap_region *extra, int nextra)
{
    static snap_region now[SNAP_MAX_REGIONS];
    uint64_t h = 1469598103934665603ULL;
    int n = gather(now, extra, nextra), i;
    for (i = 0; i < n; i++) {
        const uint8_t *q = now[i].p;
        size_t k;
        for (k = 0; k < now[i].n; k++) { h ^= q[k]; h *= 1099511628211ULL; }
    }
    return h;
}
