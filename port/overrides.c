/* Game routines that talk to hardware are replaced at their entry by a jump to host code (or by a plain ret). */
#include "host.h"
#include <string.h>
#include <SDL.h>

extern char __hook387[], __unhook387[], sub_9D352[], sub_8DF70[], sub_B3E98[], sub_B3ED8[], sub_B3F50[], __delay_init_[], __delay_[];
extern uint32_t dword_F24CC;
extern char SetTickDeadline[], WaitTicks[], ShowLoadingScreen[], sub_8FC8A[];

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


/* The MT-32 with the digital sound of the Sound Blaster and the Ultrasound.
 * The game treats the MT-32 like an AdLib: only MIDI. Its other devices have two sound drivers (SetSoundDevice): the music driver (id 2 FM,
 * 4 MT-32, 5 Ultrasound) and a second, digital one (3 Sound Blaster, 6 Ultrasound), and `musicon`, set for the Sound Blaster and the Ultrasound,
 * is what lets the rest of the game play digital music, speech and effects. `sounddev` stays 8 for the MT-32, so everything the game picks by it
 * (the MT*.KMS songs for the MIDI music, the MT-32 setup) stays the MT-32's. This changes, once, when the game starts (the code is checked first):
 *   - the MT-32 branch of SetSoundDevice sets the second driver to 3 (the Sound Blaster's digital driver) and byte_D2439 (the digital driver
 *     the crowd noise uses) as the Sound Blaster branch does;
 *   - its scene is MT32DIGI, a scene file made here: the MT-32 patch map (PCFF002.PAT) and the digital timbres (PCFF001.TIM, which brings
 *     PCFF001.DIG): the CD's MT32SBDA.SCN names the Sound Blaster's patch map and silences the MIDI music;
 *   - the three tests of sounddev for 2 or 20h (the Sound Blaster or the Ultrasound: musicon, starting and stopping speech) take 8 as well.
 * NHL95_MT32_DIGITAL=1 turns it on (not finished). */
static char mt32_scene[] = "MT32DIGI";

static int check_bytes(const uint8_t *at, const uint8_t *want, size_t n) { return !memcmp(at, want, n); }

static int make_scene_file(void)
{
    uint8_t scn[40] = { 4, 2, 0, 1 };           /* patch map 2, then the timbre files */
    int n = 0;
    const char *e = getenv("NHL95_MT32_TIMS") ? getenv("NHL95_MT32_TIMS") : "1";       /* experiment: the timbre file numbers, e.g. 1 or 0,1 */
    char path[1100], *base = SDL_GetBasePath();
    FILE *f;
    while (*e) { if (*e >= '0' && *e <= '9') scn[20 + n++] = (uint8_t)(*e - '0'); e++; }
    scn[3] = (uint8_t)n;
    snprintf(path, sizeof path, "%sMT32DIGI.SCN", base ? base : "");
    SDL_free(base);
    f = fopen(path, "wb");
    if (!f) return 0;
    fwrite(scn, 1, 20 + n, f);
    fclose(f);
    return 1;
}

static void mt32_digital(void)
{
    uint8_t *p = (uint8_t *)sub_10000 + (0x82EEC - 0x10000);       /* mov edx, str_MT322 */
    uint8_t *q = (uint8_t *)sub_10000 + (0x82F12 - 0x10000);       /* mov dword [dword_D242B], -1 */
    uint8_t *r = (uint8_t *)sub_10000 + (0x82F1C - 0x10000);       /* xor dh, dh / mov byte [byte_D2439], dh */
    uint8_t *t1 = (uint8_t *)sub_10000 + (0x82DA8 - 0x10000);      /* cmp ecx, 2 / je (the old device: stop the speech) */
    uint8_t *t2 = (uint8_t *)sub_10000 + (0x83140 - 0x10000);      /* cmp ecx, 2 / je (musicon) */
    uint8_t *t3 = (uint8_t *)sub_10000 + (0x83269 - 0x10000);      /* cmp edx, 2 / je (start the speech) */
    static const uint8_t cmp_cl[4] = { 0x83, 0xF9, 0x02, 0x74 }, cmp_dl[4] = { 0x83, 0xFA, 0x02, 0x74 };
    static const uint8_t test_cl[4] = { 0xF6, 0xC1, 0x2A, 0x75 }, test_dl[4] = { 0xF6, 0xC2, 0x2A, 0x75 };     /* test cl, 2Ah / jne: 2, 8 or 20h */
    uint32_t v;
    uint8_t code[8];
    if (!getenv("NHL95_MT32_DIGITAL")) return;          /* not finished: the game stops at the national anthem */
    memcpy(&v, q + 6, 4);
    if (p[0] != 0xBA || q[0] != 0xC7 || q[1] != 0x05 || v != 0xFFFFFFFFu || r[0] != 0x30 || r[1] != 0xF6 || r[2] != 0x88 || r[3] != 0x35 ||
        !check_bytes(t1, cmp_cl, 4) || !check_bytes(t2, cmp_cl, 4) || !check_bytes(t3, cmp_dl, 4)) {
        fprintf(stderr, "MT-32 digital sound: the game's code is not as expected, not patched\n");
        return;
    }
    if (!make_scene_file()) { fprintf(stderr, "MT-32 digital sound: cannot write MT32DIGI.SCN next to the program, not patched\n"); return; }
    v = (uint32_t)(uintptr_t)mt32_scene;
    patch_bytes(p + 1, &v, 4);
    v = 3;
    patch_bytes(q + 6, &v, 4);
    code[0] = 0xC6; code[1] = 0x05; memcpy(code + 2, r + 4, 4); code[6] = 0x01; code[7] = 0x90;      /* mov byte [byte_D2439], 1 / nop */
    patch_bytes(r, code, 8);
    if (!getenv("NHL95_MT32_NOMUSICON")) {          /* experiment */
        patch_bytes(t1, test_cl, 4);
        patch_bytes(t2, test_cl, 4);
        patch_bytes(t3, test_dl, 4);
    }
}

/* ---- skipping the splash screens ----
 * The pioneer and EA Sports screens and the title screen are timed with SetTickDeadline / WaitTicks. While `intro_skip` is set (input.c sets it when a
 * key or a mouse button is pressed before the front end has been reached) every wait is 0 ticks long, so they run through at once, and the title
 * screen, which ends when a key is pressed, gets one from input.c. Both routines are small, so they are replaced whole. */
volatile int intro_skip;

__attribute__((naked)) static void set_deadline_entry(void)         /* SetTickDeadline(ticks): tickdeadline = tickcount + ticks */
{
    __asm__ volatile(
        "movl 4(%esp), %eax\n\t"
        "cmpl $0, " SYM("intro_skip") "\n\t"
        "je 1f\n\t"
        "xorl %eax, %eax\n"
        "1:\n\t"
        "addl " SYM("tickcount") ", %eax\n\t"
        "movl %eax, " SYM("tickdeadline") "\n\t"
        "ret");
}

__attribute__((naked)) static void wait_ticks_entry(void)           /* WaitTicks(ticks): wait until tickcount has passed tickcount + ticks */
{
    __asm__ volatile(
        "movl 4(%esp), %eax\n\t"
        "cmpl $0, " SYM("intro_skip") "\n\t"
        "je 1f\n\t"
        "xorl %eax, %eax\n"
        "1:\n\t"
        "movl " SYM("tickcount") ", %ebx\n\t"
        "addl %ebx, %eax\n"
        "2:\n\t"
        "movl " SYM("tickcount") ", %ebx\n\t"
        "subl %eax, %ebx\n\t"
        "js 2b\n\t"
        "ret");
}

/* sub_8FC8A(handle, 3): has the digital music of this handle finished? The pioneer, EA Sports and title screens wait for their music to end; while
 * intro_skip is set it has (the screen then stops the music itself). Otherwise the original, copied. */
__attribute__((naked)) static void music_done_entry(void)
{
    __asm__ volatile(
        "cmpl $0, " SYM("intro_skip") "\n\t"
        "je 1f\n\t"
        "movl $1, %eax\n\t"
        "ret\n"
        "1:\n\t"
        "cmpl " SYM("dword_D4F64") ", %eax\n\t"
        "jge 2f\n\t"
        "testl %eax, %eax\n\t"
        "jge 3f\n"
        "2:\n\t"
        "movl $-1, %eax\n\t"
        "ret\n"
        "3:\n\t"
        "shll $16, %edx\n\t"
        "addl $9, %edx\n\t"
        "andl $0xFF, %eax\n\t"
        "jmp " SYM("sub_971F8"));
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
    patch_jmp(SetTickDeadline, set_deadline_entry);
    patch_jmp(WaitTicks, wait_ticks_entry);
    patch_jmp(sub_8FC8A, music_done_entry);
    if (!getenv("NHL95_LOADSCREEN")) stub_zero(ShowLoadingScreen);      /* the loading picture and its palette cycling are not needed on a modern machine */
    mt32_digital();
    install_flag_traps();
}
