/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * Tonight's Lineup (TonightsGameScreen, 2ABDF) on the 95 PC port.
 *
 * Retail CBUILD=0 still draws the three pages after KEY.DB fails: xor ebp at
 * 2AFFB clears err, FitPlayerName reads [esp+10Ch]+13h, FreeMemBlock of that
 * slot at 2B6B0. The slot is only written after a successful open and
 * sub_8CCA8 (2AF3F). On DOS the leftover was usually not a host C-string and
 * findmemblock rarely ran. The port's bump heap starts at 0x10000000, so the
 * leftover is a host pointer (Abdul's banner (10010060)) and last-name bytes
 * are fragments of that heap (.TIM, WINDOW, GAP).
 *
 * Goalie / lines / skill / season hooks were checked against 6801 retail;
 * those addresses match. This is the stock screen plus the port heap.
 *
 * MATCH src/ stays. Hooks:
 *   FileOpenRead — retry KEY.DB as cwd KEY.DB, then leaguedbfmt/"key"
 *   TonightsGameScreen — still allocate GIPK when the open failed
 *   sub_8CCA8 — zero a GIPK block so unread slots are empty names
 *   FitPlayerName — cap the copy at LINEUP_NAME_MAX
 *   FreeMemBlock — skip a pointer findmemblock would FatalError on
 */
#include "lineup.h"

#include <stdio.h>
#include <string.h>

#ifndef LINEUP_TEST
#include "host.h"
#endif

#ifdef _WIN32
#define SYM(s) "_" s
#else
#define SYM(s) s
#endif

static int same_ci(const char *a, const char *b)
{
    unsigned char ca, cb;
    if (!a || !b) return a == b;
    for (; *a && *b; a++, b++) {
        ca = (unsigned char)*a;
        cb = (unsigned char)*b;
        if (ca >= 'A' && ca <= 'Z') ca = (unsigned char)(ca + 32);
        if (cb >= 'A' && cb <= 'Z') cb = (unsigned char)(cb + 32);
        if (ca != cb) return 0;
    }
    return *a == *b;
}

static int ends_ci(const char *s, const char *suf)
{
    size_t n, m;
    if (!s || !suf) return 0;
    n = strlen(s);
    m = strlen(suf);
    if (n < m) return 0;
    return same_ci(s + n - m, suf);
}

static const char *lineup_basename(const char *path)
{
    const char *b, *p;
    if (!path) return "";
    b = path;
    for (p = path; *p; p++)
        if (*p == '\\' || *p == '/') b = p + 1;
    return b;
}

int lineup_is_key_db(const char *path)
{
    return same_ci(lineup_basename(path), "KEY.DB");
}

int lineup_is_gipk(const char *name)
{
    return name && same_ci(name, "GIPK");
}

int lineup_key_alt(const char *failed, const char *fmt, const char *fmt2, char *alt, size_t n)
{
    const char *base;
    if (!failed || !alt || n < 8) return 0;
    if (!lineup_is_key_db(failed)) return 0;
    base = lineup_basename(failed);
    if (base != failed) {
        snprintf(alt, n, "KEY.DB");
        return 1;
    }
    if (fmt && fmt[0] && strchr(fmt, '%')) {
        snprintf(alt, n, fmt, "key");
        if (alt[0] && !same_ci(alt, failed) && ends_ci(alt, ".DB")) return 1;
    }
    if (fmt2 && fmt2[0] && strchr(fmt2, '%')) {
        snprintf(alt, n, fmt2, "key");
        if (alt[0] && !same_ci(alt, failed) && ends_ci(alt, ".DB")) return 1;
    }
    return 0;
}

void lineup_fit_copy(char *dst, size_t dstn, const char *s)
{
    size_t i;
    if (!dst || !dstn) return;
    if (!s) {
        dst[0] = 0;
        return;
    }
    for (i = 0; i + 1 < dstn && s[i]; i++) dst[i] = s[i];
    dst[i] = 0;
}

static void lineup_join(char *dst, const char *a, const char *sep, const char *b)
{
    size_t i = 0;
    const char *p;
    if (!dst) return;
    for (p = a; p && *p && i + 1 < LINEUP_NAME_MAX; p++) dst[i++] = *p;
    for (p = sep; p && *p && i + 1 < LINEUP_NAME_MAX; p++) dst[i++] = *p;
    for (p = b; p && *p && i + 1 < LINEUP_NAME_MAX; p++) dst[i++] = *p;
    dst[i] = 0;
}

void lineup_fit(char *dst, const char *first, const char *last, int maxw, int (*width)(const char *))
{
    char f[LINEUP_NAME_MAX], l[LINEUP_NAME_MAX];
    if (!dst) return;
    lineup_fit_copy(l, sizeof l, last);
    if (first) {
        lineup_fit_copy(f, sizeof f, first);
        lineup_join(dst, f, " ", l);
        if (width && width(dst) > maxw) {
            char init[4];
            init[0] = f[0] ? f[0] : ' ';
            init[1] = '.';
            init[2] = ' ';
            init[3] = 0;
            lineup_join(dst, init, 0, l);
        }
    } else {
        lineup_join(dst, l, 0, 0);
    }
    if (!width) return;
    while (dst[0] && width(dst) > maxw) dst[strlen(dst) - 1] = 0;
}

int lineup_ea_has(const void *p, const void *lists)
{
    const unsigned char *node, *sent;
    int n;
    if (!p || !lists) return 0;
    node = *(const unsigned char *const *)lists;
    if (!node) return 0;
    node = *(const unsigned char *const *)(node + 0x20);
    sent = *(const unsigned char *const *)((const unsigned char *)lists + 4);
    for (n = 0; n < 10000; n++) {
        if (!node) return 0;
        if (node == sent) return 0;
        if (*(const void *const *)node == p && !(node[0x19] & 0x80)) return 1;
        node = *(const unsigned char *const *)(node + 0x20);
    }
    return 0;
}

#ifndef LINEUP_TEST

extern char FileOpenRead[], FitPlayerName[], FreeMemBlock[], sub_8CCA8[], TonightsGameScreen[];
extern char _dos_open_[];
extern unsigned char leaguedbfmt, leaguedbfmt2;
extern int dword_D2F58;

/* handwritten cdecl (ea_memman_01.asm): name, size, flags, 1 → descriptor; [desc] is the block. */
extern void *__attribute__((cdecl)) sub_8CD04(char *name, int size, int flags, int one);

static void *free_cont;
static int ok_open, ok_fit, ok_free, ok_alloc, ok_always;

static int dos_open_ro(const char *path, int *h)
{
    int r;
    void *fn = _dos_open_;
    __asm__ volatile("call *%[fn]" : "=a"(r) : [fn]"r"(fn), "a"(path), "d"(0x40), "b"(h) : "ecx", "memory", "cc");
    return r;
}

int lineup_open_read(const char *name, int *h)
{
    int err;
    char alt[96];
    err = dos_open_ro(name, h);
    if (!err) return 0;
    if (!lineup_key_alt(name, (const char *)&leaguedbfmt, (const char *)&leaguedbfmt2, alt, sizeof alt))
        return err;
    err = dos_open_ro(alt, h);
    if (!err) fprintf(stderr, "Tonight's Lineup: opened %s (was %s)\n", alt, name);
    return err;
}

int lineup_should_free(const void *p)
{
    if (!p) return 0;
    if (lineup_ea_has(p, (const void *)(uintptr_t)(unsigned)dword_D2F58)) return 1;
    fprintf(stderr, "Tonight's Lineup: skip FreeMemBlock %p (not an EA block)\n", p);
    return 0;
}

void *lineup_named_alloc(char *name, int size, int flags)
{
    void *desc = sub_8CD04(name, size, flags, 1);
    void *data;
    if (!desc) return 0;
    data = *(void **)desc;
    if (data && size > 0 && lineup_is_gipk(name)) memset(data, 0, (size_t)size);
    return data;
}

/* Retail 90AC4 (watcom_clib_10.asm). Do not take the linker symbol fputchar: MinGW stdio.h's
 * int fputchar(int) is _fputchar and wins over the game's NASM label. Same GAME_ADDR pattern as emu.c. */
#define FPUTCHAR_EA 0x90AC4u
#define GAME_FPUTCHAR ((void *)((uint8_t *)sub_10000 + (FPUTCHAR_EA - 0x10000u)))

static int name_width(const char *s)
{
    int r;
    void *fn = GAME_FPUTCHAR;
    __asm__ volatile("push %[s]\n\tcall *%[fn]\n\tadd $4, %%esp" : "=a"(r) : [fn]"r"(fn), [s]"r"(s) : "ecx", "edx", "memory", "cc");
    return r;
}

void lineup_fit_live(char *dst, char *first, char *last, int maxw)
{
    lineup_fit(dst, first, last, maxw, name_width);
}

__attribute__((naked)) static void open_thunk(void)
{
    __asm__ volatile(
        "pushal\n\t"
        "push %edx\n\tpush %eax\n\t"
        "call " SYM("lineup_open_read") "\n\t"
        "add $8, %esp\n\t"
        "mov %eax, (%esp)\n\t"
        "popal\n\t"
        "ret");
}

__attribute__((naked)) static void fit_thunk(void)
{
    __asm__ volatile(
        "pushal\n\t"
        "push %ecx\n\tpush %ebx\n\tpush %edx\n\tpush %eax\n\t"
        "call " SYM("lineup_fit_live") "\n\t"
        "add $16, %esp\n\t"
        "popal\n\t"
        "ret");
}

__attribute__((naked)) static void free_thunk(void)
{
    __asm__ volatile(
        "pushal\n\t"
        "pushl 36(%%esp)\n\t"
        "call " SYM("lineup_should_free") "\n\t"
        "add $4, %%esp\n\t"
        "test %%eax, %%eax\n\t"
        "popal\n\t"
        "jz 1f\n\t"
        "movl 4(%%esp), %%edx\n\t"
        "push %%edx\n\t"
        "jmp *%0\n"
        "1:\n\tret"
        :
        : "m"(free_cont)
        : "memory");
}

__attribute__((naked)) static void alloc_thunk(void)
{
    __asm__ volatile(
        "pushal\n\t"
        "pushl 44(%esp)\n\t"
        "pushl 44(%esp)\n\t"
        "pushl 44(%esp)\n\t"
        "call " SYM("lineup_named_alloc") "\n\t"
        "add $12, %esp\n\t"
        "mov %eax, (%esp)\n\t"
        "popal\n\t"
        "ret");
}

static int check_bytes(const uint8_t *at, const uint8_t *want, size_t n)
{
    return !memcmp(at, want, n);
}

void lineup_install(void)
{
    static const uint8_t push8[5] = { 0x68, 0x08, 0, 0, 0 };
    static const uint8_t push18[5] = { 0x68, 0x18, 0, 0, 0 };
    static const uint8_t free5[5] = { 0x8B, 0x54, 0x24, 0x04, 0x52 };
    static const uint8_t alloc7[7] = { 0x6A, 0x01, 0x8B, 0x54, 0x24, 0x10, 0x52 };
    static const uint8_t skip8[8] = { 0x85, 0xED, 0x0F, 0x85, 0xAE, 0, 0, 0 };
    uint8_t *always = (uint8_t *)TonightsGameScreen + 0x344;

    ok_open = check_bytes((uint8_t *)FileOpenRead, push8, 5);
    if (ok_open) patch_jmp(FileOpenRead, (void *)open_thunk);
    else fprintf(stderr, "Tonight's Lineup: FileOpenRead is not the expected code, KEY.DB is not retried\n");

    {
        static const uint8_t fput5[5] = { 0x68, 0x00, 0x02, 0x00, 0x00 }; /* push 200h at 90AC4 */
        ok_fit = check_bytes((uint8_t *)FitPlayerName, push18, 5)
            && check_bytes((const uint8_t *)GAME_FPUTCHAR, fput5, 5);
        if (ok_fit) patch_jmp(FitPlayerName, (void *)fit_thunk);
        else fprintf(stderr, "Tonight's Lineup: FitPlayerName or game fputchar (90AC4) is not the expected code, names stay unbounded\n");
    }

    ok_free = check_bytes((uint8_t *)FreeMemBlock, free5, 5);
    if (ok_free) {
        free_cont = FreeMemBlock + 5;
        patch_jmp(FreeMemBlock, (void *)free_thunk);
    } else {
        fprintf(stderr, "Tonight's Lineup: FreeMemBlock is not the expected code, unknown blocks still fatal\n");
    }

    ok_alloc = check_bytes((uint8_t *)sub_8CCA8, alloc7, 7);
    if (ok_alloc) patch_jmp(sub_8CCA8, (void *)alloc_thunk);
    else fprintf(stderr, "Tonight's Lineup: sub_8CCA8 is not the expected code, GIPK is not zeroed\n");

    ok_always = check_bytes(always, skip8, 8);
    if (ok_always) {
        static const uint8_t nops[6] = { 0x90, 0x90, 0x90, 0x90, 0x90, 0x90 };
        patch_bytes(always + 2, nops, 6);   /* keep test ebp; fall through to sub_8CCA8 GIPK */
    } else {
        fprintf(stderr, "Tonight's Lineup: TonightsGameScreen KEY skip is not the expected code, GIPK still skipped on a failed open\n");
    }
}

#endif /* !LINEUP_TEST */
