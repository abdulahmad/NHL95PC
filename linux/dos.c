/* DOS, BIOS and DPMI services (software interrupts). The game runs as a flat 32-bit program like it did under DOS/4GW. */
#include "host.h"
#include <ctype.h>
#include <dirent.h>
#include <errno.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <sys/statvfs.h>
#include <time.h>
#include <unistd.h>
#include <sys/mman.h>

void host_exit(int code)
{
    fflush(stdout);
    fflush(stderr);
    _exit(code);
}

#define SET_CF(c, on) do { if (on) R(c, EFL) |= 1; else R(c, EFL) &= ~1u; } while (0)
#define AX(c) (R(c, EAX) & 0xFFFF)
#define AH(c) ((R(c, EAX) >> 8) & 0xFF)
#define AL(c) (R(c, EAX) & 0xFF)
#define SETAX(c, v) (R(c, EAX) = (R(c, EAX) & ~0xFFFFu) | ((v) & 0xFFFF))
#define SETAL(c, v) (R(c, EAX) = (R(c, EAX) & ~0xFFu) | ((v) & 0xFF))
#define SETAH(c, v) (R(c, EAX) = (R(c, EAX) & ~0xFF00u) | (((v) & 0xFF) << 8))

/* ---- interrupt vectors the game installs (timer, keyboard, ...) ---- */
struct vec pm_vec[256];

/* What an unhooked vector returns from "get vector": a stub that just returns from the interrupt. */
__attribute__((naked)) static void old_vector_stub(void)
{
    __asm__ volatile("iret");
}

/* ---- paths ---- */
static const char *root(void)
{
    static const char *r;
    if (!r) { r = getenv("NHL95_ROOT"); if (!r) r = "."; }
    return r;
}

/* Resolve a DOS path to a host path: drop the drive, turn backslashes into slashes, match each name ignoring case. */
static int host_path(const char *dos, char *out, size_t n)
{
    char tmp[512], cur[1024];
    char *p, *tok, *save;
    size_t i = 0;
    if (dos[0] && dos[1] == ':') dos += 2;
    for (; *dos && i < sizeof tmp - 1; dos++) tmp[i++] = (*dos == '\\') ? '/' : *dos;
    tmp[i] = 0;
    p = tmp;
    while (*p == '/') p++;
    snprintf(cur, sizeof cur, "%s", root());
    for (tok = strtok_r(p, "/", &save); tok; tok = strtok_r(0, "/", &save)) {
        DIR *d;
        struct dirent *e;
        char next[1024];
        int found = 0;
        if (!strcmp(tok, ".")) continue;
        if (!strcmp(tok, "..")) { strncat(cur, "/..", sizeof cur - strlen(cur) - 1); continue; }
        d = opendir(cur);
        if (d) {
            while ((e = readdir(d))) if (!strcasecmp(e->d_name, tok)) { snprintf(next, sizeof next, "%s/%s", cur, e->d_name); found = 1; break; }
            closedir(d);
        }
        if (!found) snprintf(next, sizeof next, "%s/%s", cur, tok);
        snprintf(cur, sizeof cur, "%s", next);
    }
    snprintf(out, n, "%s", cur);
    return 0;
}

static void dos_error(ucontext_t *c, int err)
{
    int code = 1;
    switch (err) {
    case ENOENT: code = 2; break;
    case ENOTDIR: code = 3; break;
    case EMFILE: code = 4; break;
    case EACCES: case EPERM: case EROFS: code = 5; break;
    case EBADF: code = 6; break;
    case ENOMEM: code = 8; break;
    case EEXIST: code = 80; break;
    }
    SETAX(c, code);
    SET_CF(c, 1);
}

/* ---- find first / find next ---- */
struct find { DIR *dir; char pattern[16]; char base[1024]; };
static struct find finds[8];
static uint8_t *dta;

static int wild(const char *pat, const char *name)
{
    for (; *pat; pat++, name++) {
        if (*pat == '*') { while (*pat == '*') pat++; if (!*pat) return 1; while (*name) if (wild(pat, name++)) return 1; return 0; }
        if (*pat != '?' && toupper((unsigned char)*pat) != toupper((unsigned char)*name)) return 0;
        if (!*name) return 0;
    }
    return !*name;
}

/* DTA layout used by DOS: 0x15 attribute, 0x16 time, 0x18 date, 0x1A size, 0x1E name. We keep the search slot at 0x00. */
static int find_next(ucontext_t *c, struct find *f)
{
    struct dirent *e;
    while ((e = readdir(f->dir))) {
        char full[1100];
        struct stat st;
        if (!wild(f->pattern, e->d_name)) continue;
        snprintf(full, sizeof full, "%s/%s", f->base, e->d_name);
        if (stat(full, &st)) continue;
        struct tm *t = localtime(&st.st_mtime);
        dta[0x15] = S_ISDIR(st.st_mode) ? 0x10 : 0x20;
        *(uint16_t *)(dta + 0x16) = (t->tm_hour << 11) | (t->tm_min << 5) | (t->tm_sec / 2);
        *(uint16_t *)(dta + 0x18) = ((t->tm_year - 80) << 9) | ((t->tm_mon + 1) << 5) | t->tm_mday;
        *(uint32_t *)(dta + 0x1A) = (uint32_t)st.st_size;
        memset(dta + 0x1E, 0, 13);
        for (int i = 0; i < 12 && e->d_name[i]; i++) dta[0x1E + i] = toupper((unsigned char)e->d_name[i]);
        return 1;
    }
    (void)c;
    return 0;
}


/* ---- DOS memory (below 1 MB) ----
 * DOS/4GW lets a flat program reach conventional memory at its physical address. The host maps 0x10000-0xFFFFF the same way (the
 * VGA window at 0xA0000 is plain memory that the video code presents) and hands out real-mode buffers from 0x20000-0x8FFFF. */
#define DOS_POOL_LO 0x20000u
#define DOS_POOL_HI 0x90000u
static uint32_t dos_next = DOS_POOL_LO;

int map_low_memory(void)
{
    void *p = mmap((void *)0x10000, 0xF0000, PROT_READ | PROT_WRITE | PROT_EXEC, MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED_NOREPLACE, -1, 0);
    return p == (void *)0x10000 ? 0 : -1;
}

/* The EA memory manager grabs the biggest block it can get, so a machine with "32 MB" gives it a sane heap size. */
#define DPMI_MAX_BLOCK 0x2000000u

/* DPMI memory: addresses stay below 2 GB because the Watcom heap code compares them as signed numbers. */
static uintptr_t dpmi_next = 0x10000000;

static void *dpmi_alloc(uint32_t size)
{
    uint32_t len = (size + 0xFFF) & ~0xFFFu;
    void *m;
    if (dpmi_next + len + 0x10000 > 0x7F000000u) return MAP_FAILED;
    m = mmap((void *)dpmi_next, len, PROT_READ | PROT_WRITE | PROT_EXEC, MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED_NOREPLACE, -1, 0);
    if (m != MAP_FAILED) dpmi_next += len + 0x1000;
    return m;
}

/* ---- DPMI (int 31h) ---- */
#define BXCX(c) ((R(c, EBX) << 16) | (R(c, ECX) & 0xFFFF))
#define SETBXCX(c, v) do { R(c, EBX) = (R(c, EBX) & ~0xFFFFu) | ((v) >> 16); R(c, ECX) = (R(c, ECX) & ~0xFFFFu) | ((v) & 0xFFFF); } while (0)
#define SIDI(c) ((R(c, ESI) << 16) | (R(c, EDI) & 0xFFFF))
#define SETSIDI(c, v) do { R(c, ESI) = (R(c, ESI) & ~0xFFFFu) | ((v) >> 16); R(c, EDI) = (R(c, EDI) & ~0xFFFFu) | ((v) & 0xFFFF); } while (0)

static int int31(ucontext_t *c)
{
    switch (AX(c)) {
    case 0x0006:                                    /* segment base address: flat */
        R(c, ECX) = (R(c, ECX) & ~0xFFFFu); R(c, EDX) = (R(c, EDX) & ~0xFFFFu); SET_CF(c, 0); return 1;
    case 0x0100: {                                  /* allocate DOS memory: BX paragraphs -> AX segment, DX selector */
        uint32_t bytes = (R(c, EBX) & 0xFFFF) * 16;
        if (dos_next + bytes > DOS_POOL_HI) { SETAX(c, 8); R(c, EBX) = (DOS_POOL_HI - dos_next) / 16; SET_CF(c, 1); return 1; }
        SETAX(c, dos_next >> 4);
        { uint16_t ds; __asm__ volatile("mov %%ds, %0" : "=r"(ds)); R(c, EDX) = (R(c, EDX) & ~0xFFFFu) | ds; }
        dos_next += (bytes + 15) & ~15u;
        SET_CF(c, 0); return 1;
    }
    case 0x0101: SET_CF(c, 0); return 1;            /* free DOS memory: the pool is never reused */
    case 0x0200: R(c, ECX) = (R(c, ECX) & ~0xFFFFu); R(c, EDX) = (R(c, EDX) & ~0xFFFFu); SET_CF(c, 0); return 1;
    case 0x0201: SET_CF(c, 0); return 1;
    case 0x0204: R(c, ECX) = (R(c, ECX) & ~0xFFFFu) | (R(c, CS) & 0xFFFF); R(c, EDX) = pm_vec[R(c, EBX) & 0xFF].off ? pm_vec[R(c, EBX) & 0xFF].off : (uint32_t)old_vector_stub; SET_CF(c, 0); return 1;
    case 0x0205: pm_vec[R(c, EBX) & 0xFF].off = R(c, EDX); pm_vec[R(c, EBX) & 0xFF].sel = R(c, ECX) & 0xFFFF; SET_CF(c, 0);
        TRACE("pm vector %02x -> %04x:%08x\n", (unsigned)(R(c, EBX) & 0xFF), (unsigned)(R(c, ECX) & 0xFFFF), (unsigned)R(c, EDX)); return 1;
    case 0x0400: SETAX(c, 0x005A); R(c, EBX) = 3; R(c, ECX) = (R(c, ECX) & ~0xFF) | 4; R(c, EDX) = 0x0870; SET_CF(c, 0); return 1;
    case 0x0500: {                                  /* free memory information */
        uint32_t *info = (uint32_t *)R(c, EDI);
        memset(info, 0xFF, 48);
        info[0] = DPMI_MAX_BLOCK; info[1] = 0x4000; info[2] = 0x4000; info[3] = 0x4000; info[4] = 0x4000; info[5] = 0x4000;
        SET_CF(c, 0); return 1;
    }
    case 0x0501: {                                  /* allocate linear memory block */
        uint32_t size = BXCX(c);
        void *m = size > DPMI_MAX_BLOCK ? MAP_FAILED : dpmi_alloc(size);
        TRACE("alloc %u -> %p\n", size, m);
        if (m == MAP_FAILED) { SETAX(c, 0x8013); SET_CF(c, 1); return 1; }
        SETBXCX(c, (uint32_t)m);
        SETSIDI(c, (uint32_t)m);                    /* the handle is the address */
        SET_CF(c, 0); return 1;
    }
    case 0x0502: SET_CF(c, 0); return 1;            /* free linear memory block */
    case 0x0503: {                                  /* resize: a fresh block, old contents copied */
        uint32_t old = SIDI(c), size = BXCX(c);
        void *m = dpmi_alloc(size);
        if (m == MAP_FAILED) { SETAX(c, 0x8013); SET_CF(c, 1); return 1; }
        memcpy(m, (void *)old, size);
        SETBXCX(c, (uint32_t)m); SETSIDI(c, (uint32_t)m); SET_CF(c, 0); return 1;
    }
    case 0x0800: {                                  /* map physical memory: identity below 1 MB, a private block above */
        uint32_t phys = BXCX(c), size = SIDI(c);
        if (phys + size <= 0x100000) { SETBXCX(c, phys); }
        else {
            void *m = dpmi_alloc(size);
            if (m == MAP_FAILED) { SETAX(c, 0x8021); SET_CF(c, 1); return 1; }
            SETBXCX(c, (uint32_t)m);
        }
        SET_CF(c, 0); return 1;
    }
    case 0x0900: SETAL(c, 1); SET_CF(c, 0); return 1;   /* disable virtual interrupts: they were enabled */
    case 0x0901: SETAL(c, 1); SET_CF(c, 0); return 1;
    case 0x0902: SETAL(c, 1); SET_CF(c, 0); return 1;
    }
    return 0;
}

static int int21(ucontext_t *c)
{
    char path[1100];
    switch (AH(c)) {
    case 0x02: putchar(R(c, EDX) & 0xFF); return 1;
    case 0x09: { char *s = (char *)R(c, EDX); while (*s != '$') putchar(*s++); return 1; }
    case 0x0E: SETAL(c, 5); return 1;
    case 0x19: SETAL(c, 2); return 1;                          /* current drive C: */
    case 0x1A: dta = (uint8_t *)R(c, EDX); return 1;
    case 0x25: pm_vec[AL(c)].off = R(c, EDX); pm_vec[AL(c)].sel = 0; TRACE("setvect %02x -> %08x\n", AL(c), (unsigned)R(c, EDX)); return 1;
    case 0x35: R(c, EBX) = pm_vec[AL(c)].off ? pm_vec[AL(c)].off : (uint32_t)old_vector_stub; R(c, ES) = R(c, CS); return 1;
    case 0x2A: {
        time_t t = time(0); struct tm *tm = localtime(&t);
        R(c, ECX) = tm->tm_year + 1900; R(c, EDX) = ((tm->tm_mon + 1) << 8) | tm->tm_mday; SETAL(c, tm->tm_wday); return 1;
    }
    case 0x2C: {
        struct timeval tv; gettimeofday(&tv, 0); struct tm *tm = localtime(&tv.tv_sec);
        R(c, ECX) = (tm->tm_hour << 8) | tm->tm_min; R(c, EDX) = (tm->tm_sec << 8) | (tv.tv_usec / 10000); return 1;
    }
    case 0x30: SETAX(c, 0x0005); R(c, EBX) = 0; R(c, ECX) = 0; return 1;      /* DOS 5.0 */
    case 0x36: {                                                /* free disk space: 4 GB of 32 KB clusters */
        SETAX(c, 64); R(c, EBX) = 60000; R(c, ECX) = 512; R(c, EDX) = 65000; return 1;
    }
    case 0x39: host_path((char *)R(c, EDX), path, sizeof path); if (mkdir(path, 0777)) dos_error(c, errno); else SET_CF(c, 0); return 1;
    case 0x3A: host_path((char *)R(c, EDX), path, sizeof path); if (rmdir(path)) dos_error(c, errno); else SET_CF(c, 0); return 1;
    case 0x3B: SET_CF(c, 0); return 1;
    case 0x3C: case 0x3D: {
        int flags, fd;
        host_path((char *)R(c, EDX), path, sizeof path);
        if (AH(c) == 0x3C) flags = O_RDWR | O_CREAT | O_TRUNC;
        else flags = (AL(c) & 3) == 0 ? O_RDONLY : (AL(c) & 3) == 1 ? O_WRONLY : O_RDWR;
        fd = open(path, flags, 0666);
        TRACE("open %s -> %d\n", path, fd);
        if (fd < 0) dos_error(c, errno); else { SETAX(c, fd); SET_CF(c, 0); }
        return 1;
    }
    case 0x3E: if (R(c, EBX) > 4) close(R(c, EBX)); SET_CF(c, 0); return 1;
    case 0x3F: {
        ssize_t n = read(R(c, EBX), (void *)R(c, EDX), R(c, ECX));
        if (n < 0) dos_error(c, errno); else { SETAX(c, n); R(c, EAX) = n; SET_CF(c, 0); }
        return 1;
    }
    case 0x40: {
        ssize_t n = write(R(c, EBX), (void *)R(c, EDX), R(c, ECX));
        if (n < 0) dos_error(c, errno); else { R(c, EAX) = n; SET_CF(c, 0); }
        return 1;
    }
    case 0x41: host_path((char *)R(c, EDX), path, sizeof path); if (unlink(path)) dos_error(c, errno); else SET_CF(c, 0); return 1;
    case 0x42: {
        off_t o = lseek(R(c, EBX), (int32_t)((R(c, ECX) << 16) | (R(c, EDX) & 0xFFFF)), AL(c));
        if (o < 0) dos_error(c, errno); else { SETAX(c, o); R(c, EDX) = (uint32_t)o >> 16; R(c, EAX) = (uint32_t)o & 0xFFFF; SET_CF(c, 0); }
        return 1;
    }
    case 0x44:                                                 /* IOCTL: device info for the C library */
        if (AL(c) == 0) { R(c, EDX) = R(c, EBX) <= 2 ? 0x80D3 : 0x0002; SET_CF(c, 0); return 1; }
        break;
    case 0x48: SETAX(c, 8); R(c, EBX) = 0; SET_CF(c, 1); return 1;         /* allocate memory: none (the heap uses DPMI blocks) */
    case 0x49: case 0x4A: SET_CF(c, 0); return 1;
    case 0x4C: TRACE("exit %d\n", AL(c)); host_exit(AL(c)); return 1;
    case 0x4E: {
        const char *spec = (const char *)R(c, EDX), *name;
        char dir[512], *s;
        struct find *f = &finds[0];
        host_path(spec, path, sizeof path);
        s = strrchr(path, '/');
        if (!s) s = path - 1;
        name = s + 1;
        snprintf(f->pattern, sizeof f->pattern, "%s", name);
        snprintf(dir, sizeof dir, "%.*s", (int)(s - path) > 0 ? (int)(s - path) : 1, s > path ? path : ".");
        snprintf(f->base, sizeof f->base, "%s", dir);
        if (f->dir) closedir(f->dir);
        f->dir = opendir(dir);
        if (!f->dir || !dta || !find_next(c, f)) { SETAX(c, 18); SET_CF(c, 1); } else SET_CF(c, 0);
        return 1;
    }
    case 0x4F:
        if (!finds[0].dir || !find_next(c, &finds[0])) { SETAX(c, 18); SET_CF(c, 1); } else SET_CF(c, 0);
        return 1;
    case 0x5B: host_path((char *)R(c, EDX), path, sizeof path);               /* create new file */
        { int fd = open(path, O_RDWR | O_CREAT | O_EXCL, 0666); if (fd < 0) dos_error(c, errno); else { R(c, EAX) = fd; SET_CF(c, 0); } }
        return 1;
    }
    return 0;
}

extern char sub_10000[];
/* Print the words on the stack that point into the game's code: the likely callers of the routine that trapped. */
static void backtrace_hint(ucontext_t *c)
{
    uint32_t *sp = (uint32_t *)R(c, ESP);
    int i, n = 0;
    fprintf(stderr, "stack callers:");
    for (i = 0; i < 64 && n < 10; i++)
        if (sp[i] >= (uint32_t)sub_10000 && sp[i] < (uint32_t)sub_10000 + 0xB8000) { fprintf(stderr, " %08x", sp[i]); n++; }
    fprintf(stderr, "\n");
}

int dos_int(ucontext_t *c, int vec)
{
    int ok = 0;
    TRACE("int %02xh ax=%04x bx=%08x cx=%08x dx=%08x eip=%08x\n", vec, (unsigned)AX(c), (unsigned)R(c, EBX),
          (unsigned)R(c, ECX), (unsigned)R(c, EDX), (unsigned)R(c, EIP));
    if (vec == 0x21) ok = int21(c);
    else if (vec == 0x31) ok = int31(c);
    else if (vec == 0x10) ok = video_int10(c);
    else if (vec == 0x33) ok = input_mouse(c);
    else if (vec == 0x16) { R(c, EAX) &= ~0xFFFFu; ok = 1; }
    else if (vec == 0x2F) { SETAL(c, 0); ok = 1; }                      /* no multiplex services */
    if (!ok) backtrace_hint(c);
    if (!ok) fprintf(stderr, "unhandled int %02xh ax=%04x bx=%08x cx=%08x dx=%08x\n", vec, (unsigned)AX(c), (unsigned)R(c, EBX), (unsigned)R(c, ECX), (unsigned)R(c, EDX));
    return ok;
}
