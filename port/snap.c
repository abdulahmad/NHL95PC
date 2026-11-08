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

/* A state holds only the pages that differ from a base, a full copy of the regions taken when the first state is, and again whenever the
 * regions change (a block came or went). Most of the 68 MB is the game's assets, which never change. Restoring copies the base back and
 * lays the state's pages over it. */
#define PAGE 4096u
static uint8_t *base_mem;
static snap_region base_r[SNAP_MAX_REGIONS];
static int base_n;
static unsigned base_id;

static int base_matches(const snap_region *r, int n)
{
    int i;
    if (!base_mem || n != base_n) return 0;
    for (i = 0; i < n; i++) if (r[i].p != base_r[i].p || r[i].n != base_r[i].n) return 0;
    return 1;
}

static int base_take(const snap_region *r, int n)
{
    size_t total = 0, at = 0;
    int i;
    for (i = 0; i < n; i++) total += r[i].n;
    free(base_mem);
    base_mem = malloc(total);
    if (!base_mem) return -1;
    for (i = 0; i < n; i++) { memcpy(base_mem + at, r[i].p, r[i].n); at += r[i].n; base_r[i] = r[i]; }
    base_n = n;
    base_id++;
    return 0;
}

int snap_save(snap *s, void **jb, char *low, const snap_region *extra, int nextra)
{
    size_t at = 0, ndiff = 0, cap, out;
    int i;
    if (!stack_base || !low || low >= stack_base) return -1;
    s->valid = 0;
    free(s->mem);
    s->mem = NULL;
    s->nregs = gather(s->r, extra, nextra);
    if (s->nregs < 0) return -1;
    if (!base_matches(s->r, s->nregs) && base_take(s->r, s->nregs)) return -1;
    s->base_id = base_id;
    s->stack = (size_t)(stack_base - low);
    for (i = 0; i < s->nregs; i++) {                      /* count the pages that differ */
        size_t k;
        for (k = 0; k < s->r[i].n; k += PAGE) {
            size_t len = s->r[i].n - k < PAGE ? s->r[i].n - k : PAGE;
            if (memcmp((uint8_t *)s->r[i].p + k, base_mem + at + k, len)) ndiff++;
        }
        at += s->r[i].n;
    }
    cap = ndiff * (PAGE + sizeof(void *) + sizeof(uint32_t));
    s->size = s->stack + cap;
    s->mem = malloc(s->size ? s->size : 1);
    if (!s->mem) return -1;
    memcpy(s->mem, low, s->stack);
    out = s->stack;
    at = 0;
    for (i = 0; i < s->nregs; i++) {                      /* each page: its address, its length, its bytes */
        size_t k;
        for (k = 0; k < s->r[i].n; k += PAGE) {
            size_t len = s->r[i].n - k < PAGE ? s->r[i].n - k : PAGE;
            void *dst = (uint8_t *)s->r[i].p + k;
            uint32_t l32 = (uint32_t)len;
            if (!memcmp(dst, base_mem + at + k, len)) continue;
            memcpy(s->mem + out, &dst, sizeof dst); out += sizeof dst;
            memcpy(s->mem + out, &l32, sizeof l32); out += sizeof l32;
            memcpy(s->mem + out, dst, len); out += len;
        }
        at += s->r[i].n;
    }
    s->ndiff = ndiff;
    s->size = out;
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
    if (n != s->nregs || s->base_id != base_id) return -1;
    for (i = 0; i < n; i++) if (now[i].p != s->r[i].p || now[i].n != s->r[i].n) return -1;
    return 0;
}

int snap_restore_memory(const snap *s)
{
    size_t at = 0, p;
    int i;
    if (!s->valid || s->base_id != base_id) return -1;
    for (i = 0; i < s->nregs; i++) { memcpy(s->r[i].p, base_mem + at, s->r[i].n); at += s->r[i].n; }
    for (p = s->stack; p < s->size;) {
        void *dst;
        uint32_t len;
        memcpy(&dst, s->mem + p, sizeof dst); p += sizeof dst;
        memcpy(&len, s->mem + p, sizeof len); p += sizeof len;
        memcpy(dst, s->mem + p, len); p += len;
    }
    return 0;
}

/* (below every byte the state's stack puts back, so no interrupt frame or call here is overwritten) */
NOINLINE static void put_back(const snap *s)
{
    memcpy(s->low, s->mem, s->stack);
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
