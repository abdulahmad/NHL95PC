/* The part of the Watcom start-up (_cstart_, at 8FFD4 in the DOS build) that depends on DOS/4GW: it reads the program segment
 * prefix and the environment through selectors. The host fills in the same variables for a flat process and then runs the
 * C library start-up (__InitRtns, __CMain) as the original does. */
#include "host.h"
#include "audio.h"

extern uint8_t _Extender, _ExtenderSubtype, _osmajor, _osminor;
extern uint16_t _psp, __no87, _Envptr_w4, __saved_DS;
extern uint32_t _dynend, _curbrk, _LpCmdLine, _LpPgmName, _STACKLOW, _STACKTOP, _Envptr;
extern char stackarea[];

static char envblock[4096];

/* Build the DOS environment block: NAME=value strings, a zero, a word count of 1, then the program's path. */
static void build_environment(const char *program)
{
    char *p = envblock;
    extern char **environ;
    static const char *const pass[] = { "PATH", "TEMP", "TMP", "NO87", "BLASTER", "ULTRASND", "ULTRADIR", "NHL95_SOUND", 0 };
    int i;
    const char *none = getenv("NHL95_SOUND");
    for (i = 0; pass[i]; i++) {
        const char *v = getenv(pass[i]);
        if (!v && !(none && !strcmp(none, "none"))) {      /* the game's drivers find the emulated cards through these */
            if (!strcmp(pass[i], "BLASTER")) v = DEFAULT_BLASTER;
            if (!strcmp(pass[i], "ULTRASND")) v = DEFAULT_ULTRASND;
        }
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
    char *dst = (char *)(((uintptr_t)stackarea + 0xF) & ~0xFu);
    char *e, *cmd;
    int i, no87 = 0;
    uint16_t ds;
    __asm__ volatile("mov %%ds, %0" : "=r"(ds));

    _osmajor = 5;                 /* DOS version 5.0 */
    _osminor = 0;
    _Extender = 1;                 /* running under DOS/4G */
    _ExtenderSubtype = 0;                 /* flat: the data segment starts at linear 0 */
    __saved_DS = ds;                 /* the code keeps a copy of the data selector for its interrupt handlers */
    _psp = ds;                /* "program segment prefix" selector: the PSP itself is not used */
    _Envptr_w4 = ds;                /* environment selector */
    build_environment("HOCKEY.EXE");
    _Envptr = (uint32_t)envblock;
    __asm__ volatile("mov %%esp, %0" : "=r"(_STACKTOP));
    _STACKTOP &= ~3u;
    _curbrk = _STACKTOP;
    _dynend = _STACKTOP;

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
    __no87 = no87;
    _STACKLOW = (uint32_t)cmd;
    _LpCmdLine = (uint32_t)dst;
    _LpPgmName = _Envptr;
}
