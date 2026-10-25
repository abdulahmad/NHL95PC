/* SDL2 host for the NHL 95 PC rebuild. The original 32-bit game code (the NASM sources in ../src) runs unchanged as a thread of
 * this Linux i386 program. Instructions that only DOS or the PC hardware could execute (int n, in, out, cli, sti) fault; the
 * handler here emulates them. The main thread owns SDL: window, events, timer ticks. */
#define _GNU_SOURCE
#include "host.h"
#include <SDL.h>
#include <link.h>
#include <sys/mman.h>
#include <time.h>
#include <unistd.h>

int trace_on;
pthread_t game_thread;
static int g_argc;
static char **g_argv;

static void trap(int sig, siginfo_t *si, void *uc)
{
    ucontext_t *c = uc;
    gregset_t *g = &c->uc_mcontext.gregs;
    uint8_t *ip = (uint8_t *)(*g)[REG_EIP];
    int len;
    /* the game may leave the direction and alignment-check flags set; the C library must not see them */
    __asm__ volatile("cld\n pushf\n andl $0xFFFBFFFF, (%%esp)\n popf" ::: "cc", "memory");
    if (sig == SIGSEGV && si->si_code == SI_KERNEL) {
        len = emulate_privileged(c, ip);
        if (len > 0) {
            (*g)[REG_EIP] += len;
            return;
        }
    }
    fprintf(stderr, "UNHANDLED sig=%d code=%d eip=%08x bytes=%02x %02x %02x %02x addr=%p eax=%08x ebx=%08x ecx=%08x edx=%08x\n",
            sig, si->si_code, (unsigned)(*g)[REG_EIP], ip[0], ip[1], ip[2], ip[3], si->si_addr, (unsigned)(*g)[REG_EAX],
            (unsigned)(*g)[REG_EBX], (unsigned)(*g)[REG_ECX], (unsigned)(*g)[REG_EDX]);
    host_exit(1);
}

/* The game patches its own code (int386 stores the interrupt number in an instruction), so make the program writable. */
static int writable(struct dl_phdr_info *i, size_t n, void *d)
{
    int k;
    (void)n; (void)d;
    if (i->dlpi_name && i->dlpi_name[0]) return 0;
    for (k = 0; k < i->dlpi_phnum; k++) {
        const ElfW(Phdr) *p = &i->dlpi_phdr[k];
        if (p->p_type == PT_LOAD) {
            uintptr_t a = (i->dlpi_addr + p->p_vaddr) & ~0xFFFu, e = i->dlpi_addr + p->p_vaddr + p->p_memsz;
            mprotect((void *)a, ((e - a) + 0xFFF) & ~0xFFFu, PROT_READ | PROT_WRITE | PROT_EXEC);
        }
    }
    return 1;
}

/* The game: C library start-up, then main(). */
static void *game_main(void *arg)
{
    /* the game's stack pointer is not aligned the way the C library expects, so handlers run on their own stack */
    static char altstack[1 << 16];
    stack_t ss;
    (void)arg;
    ss.ss_sp = altstack; ss.ss_size = sizeof altstack; ss.ss_flags = 0;
    sigaltstack(&ss, 0);
    host_cstart(g_argc, g_argv);
    __asm__ volatile("mov $0xFF, %%eax\n call __InitRtns\n xor %%ebp, %%ebp\n call __CMain" ::: "eax", "edx", "ecx", "memory");
    host_exit(0);
    return 0;
}

static int64_t now_ns(void)
{
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return (int64_t)ts.tv_sec * 1000000000 + ts.tv_nsec;
}

int main(int argc, char **argv)
{
    struct sigaction sa;
    pthread_attr_t attr;
    int64_t next_tick, next_frame;
    g_argc = argc; g_argv = argv;
    trace_on = getenv("NHL95_TRACE") != 0;
    if (SDL_Init(SDL_INIT_VIDEO | SDL_INIT_EVENTS | SDL_INIT_AUDIO) < 0) { fprintf(stderr, "SDL_Init: %s\n", SDL_GetError()); return 1; }
    video_init();
    if (map_low_memory()) fprintf(stderr, "cannot map DOS memory below 1 MB\n");
    dl_iterate_phdr(writable, 0);
    install_overrides();
    irq_init();

    memset(&sa, 0, sizeof sa);
    sa.sa_sigaction = trap;
    sa.sa_flags = SA_SIGINFO | SA_ONSTACK;
    sigaddset(&sa.sa_mask, SIGUSR1);
    sigaction(SIGSEGV, &sa, 0);
    sigaction(SIGILL, &sa, 0);
    sigaction(SIGBUS, &sa, 0);
    sigaction(SIGFPE, &sa, 0);
    sigaction(SIGTRAP, &sa, 0);

    pthread_attr_init(&attr);
    pthread_attr_setstacksize(&attr, 16 << 20);
    pthread_create(&game_thread, &attr, game_main, 0);

    next_tick = next_frame = now_ns();
    for (;;) {
        int64_t now = now_ns();
        input_poll();
        if (now >= next_frame) { video_present(); next_frame = now + 16666667; }
        if (now >= next_tick) {
            irq_raise(0);
            next_tick += 1000000000LL / irq_pit_hz();
            if (now - next_tick > 200000000) next_tick = now;
        }
        usleep(1000);
    }
    return 0;
}
