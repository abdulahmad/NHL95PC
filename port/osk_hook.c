/* The on-screen keyboard opens by itself while the game edits a line of text (league names, owner names, created players, passwords):
 * every one of those goes through EditTextField. Its entry is wrapped so that the keyboard is asked for when it starts and asked to go when
 * it returns; the wrapper keeps the game's registers and stack (the routine takes its arguments on the stack and returns its result in eax).
 * The game thread only sets a flag; the main thread opens and closes the keyboard (osk_poll, from input_poll). If the routine's first
 * instructions are not ones that can be copied as they are, nothing is patched and F9 still opens the keyboard by hand. */
#include "host.h"
#include <string.h>
#include <stdint.h>
#include <stdio.h>
#ifdef _WIN32
#include <windows.h>
#else
#include <sys/mman.h>
#endif
#include <overbar/plat.h>

extern char EditTextField[];

volatile int osk_text_wanted;                  /* the game is inside EditTextField */
volatile uint32_t osk_ret, osk_tmp, osk_tramp;

void host_osk_text(int on) { osk_text_wanted = on; }

#ifdef _WIN32
#define SYM(s) "_" s
#else
#define SYM(s) s
#endif

__attribute__((naked)) static void osk_wrap(void)
{
    __asm__ volatile(
        "pushal\n\tpush $1\n\tcall " SYM("host_osk_text") "\n\tadd $4, %esp\n\tpopal\n\t"
        "mov %eax, " SYM("osk_tmp") "\n\tpop %eax\n\tmov %eax, " SYM("osk_ret") "\n\tmov " SYM("osk_tmp") ", %eax\n\t"
        "push $2f\n\tjmp *" SYM("osk_tramp") "\n"
        "2:\n\tpushal\n\tpush $0\n\tcall " SYM("host_osk_text") "\n\tadd $4, %esp\n\tpopal\n\tjmp *" SYM("osk_ret"));
}

/* how many bytes at p make whole instructions that do not depend on where they are: pushes of registers, mov reg,reg, sub esp,imm */
static int copyable(const uint8_t *p)
{
    int n = 0;
    while (n < 5) {
        if (p[n] >= 0x50 && p[n] <= 0x57) n += 1;
        else if (p[n] == 0x83 && p[n + 1] == 0xEC) n += 3;
        else if (p[n] == 0x81 && p[n + 1] == 0xEC) n += 6;
        else if ((p[n] == 0x8B || p[n] == 0x89) && (p[n + 1] & 0xC0) == 0xC0) n += 2;
        else return 0;
    }
    return n;
}

void osk_hook_install(void)
{
    uint8_t *f = (uint8_t *)EditTextField, *t;
    int k = copyable(f);
    uint32_t rel;
    if (!k) { fprintf(stderr, "On-screen keyboard: EditTextField starts with code that cannot be wrapped, no automatic keyboard (F9 still opens it)\n"); return; }
#ifdef _WIN32
    t = VirtualAlloc(NULL, 64, MEM_COMMIT | MEM_RESERVE, PAGE_EXECUTE_READWRITE);
#else
    t = mmap(NULL, 64, PROT_READ | PROT_WRITE | PROT_EXEC, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    if (t == (uint8_t *)MAP_FAILED) t = NULL;
#endif
    if (!t) return;
    memcpy(t, f, k);
    t[k] = 0xE9;                                   /* jmp EditTextField + k */
    rel = (uint32_t)((uintptr_t)(f + k) - ((uintptr_t)(t + k) + 5));
    memcpy(t + k + 1, &rel, 4);
    osk_tramp = (uint32_t)(uintptr_t)t;
    patch_jmp(f, osk_wrap);
    if (k > 5) memset(f + 5, 0x90, k - 5);          /* the rest of the copied instructions */
}

/* main thread, every input_poll: the keyboard follows the game's text editing */
void osk_poll(void)
{
    static int shown;
    int want = osk_text_wanted;
    if (want == shown) return;
    shown = want;
    if (want) ob_plat_osk_open(); else ob_plat_osk_close();
}
