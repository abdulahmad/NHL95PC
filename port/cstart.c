/* The part of the Watcom start-up (_cstart_, at 8FFD4 in the DOS build) that depends on DOS/4GW: it reads the program segment
 * prefix and the environment through selectors. The host fills in the same variables for a flat process and then runs the
 * C library start-up (__InitRtns, __CMain) as the original does. */
#include "host.h"

extern uint8_t byte_D4D06, byte_D4D07, byte_D4D0F, byte_D4D10;
extern uint16_t word_D4CE4, word_D4D04, word_D4D0D, loc_90048;
extern uint32_t dword_D4CD4, dword_D4CD8, dword_D4CDC, dword_D4CE0, dword_D4CE8, dword_D4CEC, dword_D4D09;
extern char unk_F7B88[];

static char envblock[4096];

/* Build the DOS environment block: NAME=value strings, a zero, a word count of 1, then the program's path. */
static void build_environment(const char *program)
{
    char *p = envblock;
    extern char **environ;
    static const char *const pass[] = { "PATH", "TEMP", "TMP", "NO87", "BLASTER", "ULTRASND", "ULTRADIR", "NHL95_SOUND", 0 };
    int i;
    for (i = 0; pass[i]; i++) {
        const char *v = getenv(pass[i]);
        if (v) p += sprintf(p, "%s=%s", pass[i], v) + 1;
    }
    (void)environ;
    *p++ = 0;
    *p++ = 1;
    *p++ = 0;
    sprintf(p, "C:\\NHL95\\%s", program);
}

void host_cstart(int argc, char **argv)
{
    char *dst = (char *)(((uintptr_t)unk_F7B88 + 0xF) & ~0xFu);
    char *e, *cmd;
    int i, no87 = 0;
    uint16_t ds;
    __asm__ volatile("mov %%ds, %0" : "=r"(ds));

    byte_D4D0F = 5;                 /* DOS version 5.0 */
    byte_D4D10 = 0;
    byte_D4D06 = 1;                 /* running under DOS/4G */
    byte_D4D07 = 0;                 /* flat: the data segment starts at linear 0 */
    loc_90048 = ds;                 /* the code keeps a copy of the data selector for its interrupt handlers */
    word_D4CE4 = ds;                /* "program segment prefix" selector: the PSP itself is not used */
    word_D4D0D = ds;                /* environment selector */
    build_environment("HOCKEY.EXE");
    dword_D4D09 = (uint32_t)envblock;
    __asm__ volatile("mov %%esp, %0" : "=r"(dword_D4CEC));
    dword_D4CEC &= ~3u;
    dword_D4CD8 = dword_D4CEC;
    dword_D4CD4 = dword_D4CEC;

    /* command tail, a zero byte pair, then the program name, in the stack area (argv is built from this) */
    cmd = dst;
    for (i = 1; i < argc; i++) {
        if (i > 1) *cmd++ = ' ';
        cmd += sprintf(cmd, "%s", argv[i]);
    }
    *cmd++ = 0;
    *cmd++ = 0;
    cmd--;
    for (e = envblock; *e; e += strlen(e) + 1) {
        if (!strncasecmp(e, "no87=", 5)) no87++;
    }
    e += 1 + 2;                     /* the zero that ends the strings, then the count word */
    strcpy(cmd, e);
    cmd += strlen(e) + 1;
    word_D4D04 = no87;
    dword_D4CE8 = (uint32_t)cmd;
    dword_D4CDC = (uint32_t)dst;
    dword_D4CE0 = dword_D4D09;
}
