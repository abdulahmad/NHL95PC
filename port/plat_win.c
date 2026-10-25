/* Windows platform layer (32-bit, built with mingw-w64): the faults the game causes arrive in a vectored exception handler, and an
 * interrupt is delivered by suspending the game thread, changing its context and resuming it. */
#include "host.h"
#include <SDL.h>

static HANDLE game_handle;
static volatile DWORD resume_eip;     /* where the exception handler last let the game continue */

/* Windows does not load segment registers from a changed exception context. When the emulation sets ES (int 21h 35h returns the
 * old vector in ES:EBX), the game continues here with the selector and its return address on the stack. */
__attribute__((naked)) static void load_es_stub(void)
{
    __asm__ volatile("pop %es\n\tret");
}

static LONG CALLBACK veh(EXCEPTION_POINTERS *ep)
{
    CONTEXT *c = ep->ContextRecord;
    DWORD code = ep->ExceptionRecord->ExceptionCode;
    uint8_t *ip = (uint8_t *)c->Eip;
    DWORD es = c->SegEs;
    int len;
    if (code == EXCEPTION_BREAKPOINT) {             /* an int3 that replaced pushf / popf: continue from its address */
        ip = (uint8_t *)ep->ExceptionRecord->ExceptionAddress;
        c->Eip = (DWORD)ip;
    }
    if (!IN_GAME_CODE(ip)) return EXCEPTION_CONTINUE_SEARCH;
    if (code != EXCEPTION_PRIV_INSTRUCTION && code != EXCEPTION_ACCESS_VIOLATION && code != EXCEPTION_ILLEGAL_INSTRUCTION &&
        code != EXCEPTION_BREAKPOINT)
        return EXCEPTION_CONTINUE_SEARCH;
    __asm__ volatile("cld");
    c->EFlags &= ~0x40000u;
    len = emulate_privileged(c, ip);
    if (len > 0) {
        c->Eip += len;
        if ((c->SegEs & 0xFFFF) != (es & 0xFFFF)) {
            uint32_t *sp = (uint32_t *)c->Esp - 2;
            sp[0] = c->SegEs & 0xFFFF;
            sp[1] = c->Eip;
            c->Esp = (DWORD)sp;
            c->Eip = (DWORD)load_es_stub;
            c->SegEs = es;
        }
        irq_try_deliver(c);             /* the safe place to take a pending interrupt (see plat_kick_game) */
        resume_eip = c->Eip;
        return EXCEPTION_CONTINUE_EXECUTION;
    }
    if (code == EXCEPTION_ACCESS_VIOLATION && ep->ExceptionRecord->ExceptionInformation[1] < 0x10000 && emulate_low_memory(c, ip))
        return EXCEPTION_CONTINUE_EXECUTION;
    fprintf(stderr, "UNHANDLED exception %08lx eip=%08x bytes=%02x %02x %02x %02x eax=%08x ebx=%08x ecx=%08x edx=%08x esp=%08x cs=%x ds=%x es=%x fs=%x\n",
            code, (unsigned)c->Eip, ip[0], ip[1], ip[2], ip[3], (unsigned)c->Eax, (unsigned)c->Ebx, (unsigned)c->Ecx, (unsigned)c->Edx, (unsigned)c->Esp,
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

/* Windows puts the process parameters, the NLS tables and a thread stack below 1 MB before main runs, so DOS memory cannot be
 * allocated there. The program is linked at 0x10000 with an uninitialized section .lowmem from 0x11000 to 0x100000 (see
 * build-win.sh), which the loader maps before anything else: a range inside the program's own image is already there. */
void *plat_map_fixed(uintptr_t addr, size_t size)
{
    MEMORY_BASIC_INFORMATION mbi;
    void *m = VirtualAlloc((void *)addr, size, MEM_RESERVE | MEM_COMMIT, PAGE_EXECUTE_READWRITE);
    if (m) return m;
    if (addr < 0x11000) { size -= 0x11000 - addr; addr = 0x11000; }    /* the image headers */
    if (VirtualQuery((void *)addr, &mbi, sizeof mbi) && mbi.AllocationBase == GetModuleHandleA(0) &&
        (uintptr_t)mbi.BaseAddress + mbi.RegionSize >= addr + size) {
        DWORD old;
        VirtualProtect((void *)addr, size, PAGE_EXECUTE_READWRITE, &old);
        return (void *)addr;
    }
    return 0;
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

void plat_unmap(void *addr, size_t size)
{
    (void)size;
    VirtualFree(addr, 0, MEM_RELEASE);
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
 * a system call) is its context changed. Not when it is at an instruction that traps: it may be on its way into the exception
 * handler, which has (or will take) a copy of the context, so a change here would be lost or would reach the handler as a
 * fault at the interrupt handler's first instruction. Nor when it is where the exception handler let it continue: it may still be
 * in NtContinue, which would overwrite the change. The exception handler delivers the interrupt instead. */
void plat_kick_game(void)
{
    CONTEXT c;
    if (!game_handle) return;
    if (SuspendThread(game_handle) == (DWORD)-1) return;
    memset(&c, 0, sizeof c);
    c.ContextFlags = CONTEXT_CONTROL | CONTEXT_INTEGER | CONTEXT_SEGMENTS;
    /* nothing in here may take a lock: the game thread may hold one (the C library's, the heap's) */
    if (GetThreadContext(game_handle, &c) && IN_GAME_CODE(c.Eip) && c.Eip != resume_eip && !traps((uint8_t *)c.Eip) &&
        !accesses_low_memory(&c, (uint8_t *)c.Eip) && irq_try_deliver(&c))
        SetThreadContext(game_handle, &c);
    ResumeThread(game_handle);
}

/* NHL95_TRACE: where the game thread is (registers and the top of its stack) */
void plat_trace_game(void)
{
    CONTEXT c;
    uint32_t s[8] = { 0 };
    if (!game_handle || SuspendThread(game_handle) == (DWORD)-1) return;
    memset(&c, 0, sizeof c);
    c.ContextFlags = CONTEXT_CONTROL | CONTEXT_INTEGER;
    GetThreadContext(game_handle, &c);
    ResumeThread(game_handle);
    ReadProcessMemory(GetCurrentProcess(), (void *)c.Esp, s, sizeof s, 0);
    fprintf(stderr, "game thread: eip=%08x esp=%08x eax=%08x ebx=%08x ecx=%08x edx=%08x stack %08x %08x %08x %08x %08x %08x\n",
            (unsigned)c.Eip, (unsigned)c.Esp, (unsigned)c.Eax, (unsigned)c.Ebx, (unsigned)c.Ecx, (unsigned)c.Edx,
            s[0], s[1], s[2], s[3], s[4], s[5]);
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
