/* Linux platform layer: the faults the game causes arrive as signals, interrupts are delivered with a signal to the game thread. */
#define _GNU_SOURCE
#include "host.h"
#include <link.h>
#include <pthread.h>
#include <sys/mman.h>
#include <time.h>
#include <unistd.h>

static pthread_t game_thread;
static char altstack[1 << 16];

static void trap(int sig, siginfo_t *si, void *uc)
{
    ctx_t *c = uc;
    uint8_t *ip = (uint8_t *)R(c, EIP);
    int len;
    /* the game may leave the direction and alignment-check flags set; the C library must not see them */
    __asm__ volatile("cld\n pushf\n andl $0xFFFBFFFF, (%%esp)\n popf" ::: "cc", "memory");
    if (sig == SIGTRAP && IN_GAME_CODE(ip - 1) && ip[-1] == 0xCC) {   /* an int3 that replaced pushf / popf */
        ip--;
        R(c, EIP) = (uintptr_t)ip;
        len = emulate_privileged(c, ip);
        if (len > 0) { R(c, EIP) += len; return; }
    }
    if (sig == SIGSEGV && si->si_code == SI_KERNEL) {
        len = emulate_privileged(c, ip);
        if (len > 0) {
            R(c, EIP) += len;
            return;
        }
    }
    if (sig == SIGSEGV && si->si_code != SI_KERNEL && (uintptr_t)si->si_addr < 0x10000 && IN_GAME_CODE(ip) && emulate_low_memory(c, ip))
        return;
    fprintf(stderr, "UNHANDLED sig=%d code=%d eip=%08x bytes=%02x %02x %02x %02x addr=%p eax=%08x ebx=%08x ecx=%08x edx=%08x\n",
            sig, si->si_code, (unsigned)R(c, EIP), ip[0], ip[1], ip[2], ip[3], si->si_addr, (unsigned)R(c, EAX),
            (unsigned)R(c, EBX), (unsigned)R(c, ECX), (unsigned)R(c, EDX));
    host_exit(1);
}

static void irq_signal(int sig, siginfo_t *si, void *uc)
{
    (void)sig; (void)si;
    irq_try_deliver(uc);
}

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

void plat_make_image_writable(void)
{
    dl_iterate_phdr(writable, 0);
}

void *plat_map_fixed(uintptr_t addr, size_t size)
{
    void *p = mmap((void *)addr, size, PROT_READ | PROT_WRITE | PROT_EXEC, MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED_NOREPLACE, -1, 0);
    return p == MAP_FAILED || p != (void *)addr ? 0 : p;
}

void *plat_map_any(size_t size)
{
    /* below 2 GB because the Watcom heap compares addresses as signed numbers: a bump allocator in 0x10000000-0x7F000000 */
    static uintptr_t next = 0x10000000;
    size_t len = (size + 0xFFF) & ~0xFFFu;
    void *m;
    if (next + len + 0x10000 > 0x7F000000u) return 0;
    m = plat_map_fixed(next, len);
    if (m) next += len + 0x1000;
    return m;
}

void plat_unmap(void *addr, size_t size)
{
    munmap(addr, (size + 0xFFF) & ~0xFFFu);
}

static void *thread_main(void *arg)
{
    stack_t ss;
    int argc;
    char **argv;
    extern void game_args(int *, char ***);
    (void)arg;
    ss.ss_sp = altstack; ss.ss_size = sizeof altstack; ss.ss_flags = 0;
    sigaltstack(&ss, 0);               /* the game's stack pointer is not aligned the way the C library expects */
    game_args(&argc, &argv);
    game_run(argc, argv);
    return 0;
}

void plat_install_traps(void)
{
    struct sigaction sa;
    memset(&sa, 0, sizeof sa);
    sa.sa_sigaction = trap;
    sa.sa_flags = SA_SIGINFO | SA_ONSTACK;
    sigaddset(&sa.sa_mask, SIGUSR1);
    sigaction(SIGSEGV, &sa, 0);
    sigaction(SIGILL, &sa, 0);
    sigaction(SIGBUS, &sa, 0);
    sigaction(SIGFPE, &sa, 0);
    sigaction(SIGTRAP, &sa, 0);
    memset(&sa, 0, sizeof sa);
    sa.sa_sigaction = irq_signal;
    sa.sa_flags = SA_SIGINFO | SA_ONSTACK;
    sigaddset(&sa.sa_mask, SIGSEGV);
    sigaction(SIGUSR1, &sa, 0);
}

void plat_start_game(void)
{
    pthread_attr_t attr;
    pthread_attr_init(&attr);
    pthread_attr_setstacksize(&attr, 16 << 20);
    pthread_create(&game_thread, &attr, thread_main, 0);
}

void plat_kick_game(void)
{
    pthread_kill(game_thread, SIGUSR1);
}

void plat_thread_times(uint64_t *user_ns, uint64_t *kernel_ns)
{
    clockid_t id;
    struct timespec ts;
    if (pthread_getcpuclockid(game_thread, &id) || clock_gettime(id, &ts)) return;
    *user_ns = (uint64_t)ts.tv_sec * 1000000000 + ts.tv_nsec;      /* user and kernel together */
    *kernel_ns = 0;
}

void plat_trace_game(void)
{
}

int64_t plat_now_ns(void)
{
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return (int64_t)ts.tv_sec * 1000000000 + ts.tv_nsec;
}

void plat_sleep_ms(int ms)
{
    usleep(ms * 1000);
}
