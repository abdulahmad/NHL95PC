/* States of the running game (snap.h). */
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#if defined(_WIN32)
#include <malloc.h>
#else
#include <alloca.h>
#endif
#include "host.h"
#include "snap.h"

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

int snap_save(snap *s, void **jb, char *low, const snap_region *extra, int nextra)
{
    size_t total = 0, at = 0;
    int i;
    if (!stack_base || !low || low >= stack_base) return -1;
    s->valid = 0;
    free(s->mem);
    s->mem = NULL;
    s->nregs = gather(s->r, extra, nextra);
    if (s->nregs < 0) return -1;
    for (i = 0; i < s->nregs; i++) total += s->r[i].n;
    s->stack = (size_t)(stack_base - low);
    s->size = total + s->stack;
    s->mem = malloc(s->size);
    if (!s->mem) return -1;
    for (i = 0; i < s->nregs; i++) { memcpy(s->mem + at, s->r[i].p, s->r[i].n); at += s->r[i].n; }
    memcpy(s->mem + at, low, s->stack);
    s->low = low;
    s->jb_at = jb;
    memcpy(s->jb, jb, sizeof s->jb);
    s->valid = 1;
    return 0;
}

int snap_fits(const snap *s, const snap_region *extra, int nextra)
{
    static snap_region now[SNAP_MAX_REGIONS];
    int n = s->valid ? gather(now, extra, nextra) : -1, i;
    if (n != s->nregs) return -1;
    for (i = 0; i < n; i++) if (now[i].p != s->r[i].p || now[i].n != s->r[i].n) return -1;
    return 0;
}

int snap_restore_memory(const snap *s)
{
    size_t at = 0;
    int i;
    if (!s->valid) return -1;
    for (i = 0; i < s->nregs; i++) { memcpy(s->r[i].p, s->mem + at, s->r[i].n); at += s->r[i].n; }
    return 0;
}

/* (below every byte the state's stack puts back, so no interrupt frame or call here is overwritten) */
NOINLINE static void put_back(const snap *s)
{
    memcpy(s->low, s->mem + (s->size - s->stack), s->stack);
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

void snap_free(snap *s) { free(s->mem); memset(s, 0, sizeof *s); }

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
