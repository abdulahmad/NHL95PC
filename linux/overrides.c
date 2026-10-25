/* Game routines that talk to hardware are replaced at their entry by a jump to host code (or by a plain ret). */
#include "host.h"
#include <string.h>

extern char __hook387[], __unhook387[], sub_9D352[], sub_8DF70[], sub_B3E98[], sub_B3ED8[], sub_B3F50[];
extern uint32_t dword_D305C, dword_D3060;
extern uint8_t byte_D3064, byte_D3068;
extern uint8_t byte_D4B9C, byte_D51DC;

static void patch_bytes(void *at, const void *bytes, size_t n)
{
    memcpy(at, bytes, n);
}

/* xor eax,eax / ret: the routine does nothing and returns 0 */
static void stub_zero(void *at)
{
    static const uint8_t code[] = { 0x31, 0xC0, 0xC3 };
    patch_bytes(at, code, sizeof code);
}

/* jmp rel32 to a host function that follows the game routine's register convention */
void patch_jmp(void *from, void *to)
{
    uint8_t code[5];
    int32_t rel = (int32_t)((uintptr_t)to - ((uintptr_t)from + 5));
    code[0] = 0xE9;
    memcpy(code + 1, &rel, 4);
    patch_bytes(from, code, 5);
}

/* The start-up code that sets up the floating point emulator: only its two flags are kept (80387 present). */
static void init_fpu_flags(void)
{
    byte_D4B9C = 3;
    byte_D51DC = 1;
}

/* CPU detection: the original toggles the alignment-check flag to tell a 486 from a 386, and leaves it set, which makes every
 * unaligned access fault on Linux. Report a 486 in protected mode instead. */
static void detect_cpu(void)
{
    dword_D305C = 1;
    dword_D3060 = 1;
    byte_D3068 = 1;
    byte_D3064 = 1;
}

void install_overrides(void)
{
    patch_jmp(sub_B3F50, detect_cpu);
    patch_jmp(sub_9D352, init_fpu_flags);
    stub_zero(__hook387);       /* the Watcom floating point emulator is not needed: the host CPU has an FPU */
    stub_zero(__unhook387);
    patch_jmp(sub_8DF70, video_fill_vesa_tables);      /* the VESA probe (the game ran an external program for it) */
    stub_zero(sub_B3E98);       /* save the text mode and the BIOS data area */
    stub_zero(sub_B3ED8);       /* restore them */
}
