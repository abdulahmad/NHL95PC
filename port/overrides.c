/* Game routines that talk to hardware are replaced at their entry by a jump to host code (or by a plain ret). */
#include "host.h"
#include <string.h>

extern char __hook387[], __unhook387[], sub_9D352[], sub_8DF70[], sub_B3E98[], sub_B3ED8[], sub_B3F50[], __delay_init_[], __delay_[];
extern uint32_t dword_F24CC;

/* The Watcom delay(): __delay_init_ counts how many int 21h / 2Ch (get time) calls fit in one second, __delay_(ms) makes that many
 * per millisecond. Every one of them is a trap here (about 4 us on Windows): two seconds of start-up spent faulting, and the timer
 * interrupt starved meanwhile. The count is only used by __delay_, so the host sets it without measuring and sleeps for the time. */
#ifdef _WIN32
#define SYM(s) "_" s
#else
#define SYM(s) s
#endif

void host_delay_init(void)
{
    dword_F24CC = 1000000;
}

void host_delay(unsigned ms)
{
    int64_t end = plat_now_ns() + (int64_t)ms * 1000000;
    while (plat_now_ns() < end) plat_sleep_ms(1);
}

/* both keep every register, like the originals */
__attribute__((naked)) static void delay_init_entry(void)
{
    __asm__ volatile("pushal\n\tcall " SYM("host_delay_init") "\n\tpopal\n\tret");
}

__attribute__((naked)) static void delay_entry(void)
{
    __asm__ volatile("pushal\n\tpush %eax\n\tcall " SYM("host_delay") "\n\tadd $4, %esp\n\tpopal\n\tret");
}
extern uint32_t dword_D305C, dword_D3060;
extern uint8_t byte_D3064, byte_D3068;
extern uint8_t byte_D4B9C, byte_D51DC;

void patch_bytes(void *at, const void *bytes, size_t n)
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

#ifdef _WIN32
/* __setenvp_ builds the environment table (environ, dword_D5444, and a flag byte per entry, dword_D5448) by reading the environment
 * block through FS and ES loaded with the DOS/4GW environment selector. FS must keep pointing at the Windows thread information
 * block, so the host builds the same table from the flat block. The sound drivers find the cards through BLASTER and ULTRASND
 * there. Nothing in the game adds variables, so the table can stay in static storage. */
extern char __setenvp_[];
extern uint32_t dword_D4D09, dword_D5444, dword_D5448;

void host_setenvp(void)
{
    static char *env[65];
    static uint8_t flags[64];
    char *p = (char *)dword_D4D09;
    int n = 0;
    if (dword_D5444) return;
    for (; *p && n < 64; p += strlen(p) + 1) env[n++] = p;
    env[n] = 0;
    dword_D5444 = (uint32_t)env;
    dword_D5448 = (uint32_t)flags;
}

/* the original keeps every register */
__attribute__((naked)) static void setenvp_entry(void)
{
    __asm__ volatile("pushal\n\tcall _host_setenvp\n\tpopal\n\tret");
}
#endif


/* MT-32 music with the Sound Blaster's digital effects.
 * The game sets up two sound drivers for each device (SetSoundDevice): the music driver (id 2 FM, 4 MT-32, 5 Ultrasound) and a second, digital
 * one (3 Sound Blaster, 6 Ultrasound). Its sound code already plays digital effects for the MT-32 (the test of sounddev with 2Ah includes
 * 8), and the CD has a scene file for the pair (MT32SBDA.SCN), but the MT-32 branch sets the second driver to none (-1). This puts the
 * Sound Blaster's digital driver in as the second one, as that branch of the Sound Blaster does: the scene is MT32SBDA, the second driver 3
 * and the flag byte_D2439 1. The music stays the MT-32's (sounddev stays 8, so it plays the MT*.KMS songs). NHL95_MT32_NODIGITAL=1 turns it off.
 * The three instructions are checked first. */
static char mt32_scene[] = "MT32SBDA";

static void mt32_digital(void)
{
    uint8_t *p = (uint8_t *)sub_10000 + (0x82EEC - 0x10000);       /* mov edx, str_MT322 */
    uint8_t *q = (uint8_t *)sub_10000 + (0x82F12 - 0x10000);       /* mov dword [dword_D242B], -1 */
    uint8_t *r = (uint8_t *)sub_10000 + (0x82F1C - 0x10000);       /* xor dh, dh / mov byte [byte_D2439], dh */
    uint32_t v;
    uint8_t code[8];
    if (getenv("NHL95_MT32_NODIGITAL")) return;
    memcpy(&v, q + 6, 4);
    if (p[0] != 0xBA || q[0] != 0xC7 || q[1] != 0x05 || v != 0xFFFFFFFFu || r[0] != 0x30 || r[1] != 0xF6 || r[2] != 0x88 || r[3] != 0x35) {
        fprintf(stderr, "MT-32 digital effects: the game's code is not as expected, not patched\n");
        return;
    }
    v = (uint32_t)(uintptr_t)mt32_scene;
    patch_bytes(p + 1, &v, 4);
    v = 3;
    patch_bytes(q + 6, &v, 4);
    code[0] = 0xC6; code[1] = 0x05; memcpy(code + 2, r + 4, 4); code[6] = 0x01; code[7] = 0x90;      /* mov byte [byte_D2439], 1 / nop */
    patch_bytes(r, code, 8);
}

void install_overrides(void)
{
#ifdef _WIN32
    patch_jmp(__setenvp_, setenvp_entry);
#endif
    patch_jmp(sub_B3F50, detect_cpu);
    patch_jmp(sub_9D352, init_fpu_flags);
    stub_zero(__hook387);       /* the Watcom floating point emulator is not needed: the host CPU has an FPU */
    stub_zero(__unhook387);
    patch_jmp(sub_8DF70, video_fill_vesa_tables);      /* the VESA probe (the game ran an external program for it) */
    stub_zero(sub_B3E98);       /* save the text mode and the BIOS data area */
    stub_zero(sub_B3ED8);       /* restore them */
    patch_jmp(__delay_init_, delay_init_entry);
    patch_jmp(__delay_, delay_entry);
    mt32_digital();
    install_flag_traps();
}
