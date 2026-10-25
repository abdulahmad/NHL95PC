/* Windows platform layer (32-bit, built with mingw-w64): the faults the game causes arrive in a vectored exception handler, and an
 * interrupt is delivered by suspending the game thread, changing its context and resuming it. */
#include "host.h"
#include <SDL.h>

static HANDLE game_handle;

static LONG CALLBACK veh(EXCEPTION_POINTERS *ep)
{
    CONTEXT *c = ep->ContextRecord;
    DWORD code = ep->ExceptionRecord->ExceptionCode;
    uint8_t *ip = (uint8_t *)c->Eip;
    int len;
    if (!IN_GAME_CODE(ip)) return EXCEPTION_CONTINUE_SEARCH;
    if (code != EXCEPTION_PRIV_INSTRUCTION && code != EXCEPTION_ACCESS_VIOLATION && code != EXCEPTION_ILLEGAL_INSTRUCTION)
        return EXCEPTION_CONTINUE_SEARCH;
    __asm__ volatile("cld");
    c->EFlags &= ~0x40000u;
    len = emulate_privileged(c, ip);
    if (len > 0) {
        c->Eip += len;
        return EXCEPTION_CONTINUE_EXECUTION;
    }
    fprintf(stderr, "UNHANDLED exception %08lx eip=%08x bytes=%02x %02x %02x %02x eax=%08x ebx=%08x ecx=%08x edx=%08x cs=%x ds=%x es=%x fs=%x\n",
            code, (unsigned)c->Eip, ip[0], ip[1], ip[2], ip[3], (unsigned)c->Eax, (unsigned)c->Ebx, (unsigned)c->Ecx, (unsigned)c->Edx,
            (unsigned)c->SegCs, (unsigned)c->SegDs, (unsigned)c->SegEs, (unsigned)c->SegFs);
    host_exit(1);
    return EXCEPTION_CONTINUE_SEARCH;
}

void plat_install_traps(void)
{
    AddVectoredExceptionHandler(1, veh);
}

void plat_make_image_writable(void)
{
    MEMORY_BASIC_INFORMATION mbi;
    uint8_t *base = (uint8_t *)GetModuleHandleA(0);
    IMAGE_NT_HEADERS *nt = (IMAGE_NT_HEADERS *)(base + ((IMAGE_DOS_HEADER *)base)->e_lfanew);
    DWORD old;
    (void)mbi;
    VirtualProtect(base, nt->OptionalHeader.SizeOfImage, PAGE_EXECUTE_READWRITE, &old);
}

void *plat_map_fixed(uintptr_t addr, size_t size)
{
    return VirtualAlloc((void *)addr, size, MEM_RESERVE | MEM_COMMIT, PAGE_EXECUTE_READWRITE);
}

void *plat_map_any(size_t size)
{
    /* below 2 GB (the Watcom heap compares addresses as signed numbers); a 32-bit process without the large-address flag has no more */
    static uintptr_t next = 0x10000000;
    size_t len = (size + 0xFFF) & ~0xFFFu;
    void *m = 0;
    while (!m && next + len + 0x10000 <= 0x7F000000u) {
        m = VirtualAlloc((void *)next, len, MEM_RESERVE | MEM_COMMIT, PAGE_EXECUTE_READWRITE);
        next += m ? len + 0x1000 : 0x10000;
    }
    return m;
}

static DWORD WINAPI thread_main(LPVOID arg)
{
    int argc;
    char **argv;
    extern void game_args(int *, char ***);
    (void)arg;
    game_args(&argc, &argv);
    game_run(argc, argv);
    return 0;
}

void plat_start_game(void)
{
    game_handle = CreateThread(0, 16 << 20, thread_main, 0, 0, 0);
}

/* Called from the main thread when an interrupt is pending: only when the game thread is executing game code (not the host, not
 * a system call) is its context changed. */
void plat_kick_game(void)
{
    CONTEXT c;
    if (!game_handle) return;
    if (SuspendThread(game_handle) == (DWORD)-1) return;
    memset(&c, 0, sizeof c);
    c.ContextFlags = CONTEXT_CONTROL | CONTEXT_INTEGER | CONTEXT_SEGMENTS;
    if (GetThreadContext(game_handle, &c) && IN_GAME_CODE(c.Eip) && irq_try_deliver(&c)) SetThreadContext(game_handle, &c);
    ResumeThread(game_handle);
}

int64_t plat_now_ns(void)
{
    static LARGE_INTEGER freq;
    LARGE_INTEGER t;
    if (!freq.QuadPart) QueryPerformanceFrequency(&freq);
    QueryPerformanceCounter(&t);
    return (int64_t)((double)t.QuadPart * 1e9 / (double)freq.QuadPart);
}

void plat_sleep_ms(int ms)
{
    SDL_Delay(ms);
}
