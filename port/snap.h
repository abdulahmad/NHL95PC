/* States of the running game, for online play's rollback (docs/SDL2_PORT.md "Rollback"). A state is
 * the game's data, the DOS memory it has allocated, its DPMI blocks, the host's bookkeeping for those
 * (dos.c), some host variables the caller names, and the game thread's stack from the frame that takes
 * it up to the thread's base, with where to come back to. Loading one puts all of it back and comes
 * back to the taking call (snap_jump) as if it had just returned the first time. Only at a point where
 * the game thread is in game code outside any interrupt (the record hooks of netplay.c), and no host
 * thread is in the middle of a change to this memory. */
#ifndef SNAP_H
#define SNAP_H
#include <stddef.h>
#include <stdint.h>

typedef struct snap_region { void *p; size_t n; } snap_region;

#define SNAP_MAX_REGIONS 560

typedef struct snap {
    uint8_t *mem;               /* the regions' bytes, then the stack's */
    size_t size;
    int nregs;
    snap_region r[SNAP_MAX_REGIONS];
    char *low;
    size_t stack;
    void *jb[5];
    void **jb_at;
    int valid;
} snap;

void snap_set_stack_base(void *base);   /* the game thread's, from its first host frame (host.c game_run) */
/* the regions a state holds, besides the extra ones: the game's data, DOS memory, DPMI blocks and dos.c's tables */
int snap_regions(snap_region *r, int max);
/* an address in the caller's frame, below all of it (pass it as `low`) */
char *snap_sp(void);
/* takes a state. jb: a void *[5] that the caller has just set with __builtin_setjmp in the frame that
 * calls this (it stays live), low: snap_sp() from that frame. 0, or -1 (out of memory, too many blocks) */
int snap_save(snap *s, void **jb, char *low, const snap_region *extra, int nextra);
/* the regions as they are now match the state's (no block came or went): 0, else -1 */
int snap_fits(const snap *s, const snap_region *extra, int nextra);
/* puts the memory back (not the stack), 0 */
int snap_restore_memory(const snap *s);
/* puts the stack back and comes back where snap_save was called; does not return */
void snap_jump(const snap *s) __attribute__((noreturn));
void snap_free(snap *s);
/* a hash of the regions now (the game's data and the extra ones), for tests */
uint64_t snap_hash(const snap_region *extra, int nextra);

#endif
