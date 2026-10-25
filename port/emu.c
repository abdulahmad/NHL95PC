/* Decode and emulate the privileged instructions the game executes (int n, in, out, cli, sti). */
#include "host.h"

/* Is the instruction at ip one that traps (int n, in, out, ins, outs, cli, sti, and the int3 that replaces pushf / popf)? */
int traps(const uint8_t *ip)
{
    while (*ip == 0x66 || *ip == 0xF3 || *ip == 0xF2) ip++;
    return *ip == 0xCD || *ip == 0xFA || *ip == 0xFB || (*ip >= 0xE4 && *ip <= 0xE7) || (*ip >= 0xEC && *ip <= 0xEF) ||
           (*ip >= 0x6C && *ip <= 0x6F) || *ip == 0xCC;
}

/* ---- pushf / popf ----
 * The game's interrupt flag is vif. The drivers save it with pushf, cli and restore it with popf, but in a user process popf
 * leaves IF alone without trapping, so the restore would be lost and interrupts would stay off. Each pushf / popf of the game's
 * code (flagops.h, from the sources) is replaced by int3 and emulated with vif in place of IF. */
static const struct { uint32_t addr; uint8_t kind; } flagops[] = {
#include "flagops.h"
};
#define NFLAGOPS (int)(sizeof flagops / sizeof *flagops)
#define GAME_ADDR(orig) ((uint8_t *)sub_10000 + ((orig) - 0x10000))

void install_flag_traps(void)
{
    static const uint8_t first[4] = { 0x9C, 0x9D, 0x66, 0x66 };
    int i, n = 0;
    for (i = 0; i < NFLAGOPS; i++) {
        uint8_t *p = GAME_ADDR(flagops[i].addr);
        if (p[0] != first[flagops[i].kind] || (flagops[i].kind >= 2 && p[1] != (flagops[i].kind == 2 ? 0x9C : 0x9D))) continue;
        p[0] = 0xCC;
        n++;
    }
    if (n != NFLAGOPS) fprintf(stderr, "pushf/popf: %d of %d found in the code\n", n, NFLAGOPS);
}

/* the instruction an int3 at ip replaced, or -1 */
static int flagop_kind(const uint8_t *ip)
{
    uint32_t orig = (uint32_t)(ip - (uint8_t *)sub_10000) + 0x10000;
    int lo = 0, hi = NFLAGOPS - 1;
    while (lo <= hi) {
        int mid = (lo + hi) / 2;
        if (flagops[mid].addr == orig) return flagops[mid].kind;
        if (flagops[mid].addr < orig) lo = mid + 1; else hi = mid - 1;
    }
    return -1;
}

#define FLAGS_POPPED 0xCD5u                   /* CF PF AF ZF SF DF OF: what popf may change in a user process, besides IF */

static int emulate_flagop(ctx_t *c, uint8_t *ip)
{
    int kind = flagop_kind(ip);
    uint32_t efl = R(c, EFL), v;
    switch (kind) {
    case 0:
        R(c, ESP) -= 4;
        *(uint32_t *)R(c, ESP) = (efl & ~0x10200u) | (vif ? 0x200 : 0);
        return 1;
    case 2:
        R(c, ESP) -= 2;
        *(uint16_t *)R(c, ESP) = (uint16_t)((efl & ~0x200u) | (vif ? 0x200 : 0));
        return 2;
    case 1: case 3:
        if (kind == 1) { v = *(uint32_t *)R(c, ESP); R(c, ESP) += 4; }
        else { v = *(uint16_t *)R(c, ESP); R(c, ESP) += 2; }
        R(c, EFL) = (efl & ~FLAGS_POPPED) | (v & FLAGS_POPPED);
        vif = (v >> 9) & 1;
        return kind == 1 ? 1 : 2;
    }
    return 0;
}

/* ---- the first 64 KB ----
 * Under DOS/4GW the flat address space starts with the real-mode interrupt table and the BIOS data area, and reading there was
 * harmless; the game does it (for example sub_8D728 reads [eax+18h] when eax is 0). A host process cannot map that page, so an
 * access below 0x10000 is redone on lowmem[]: the instruction is copied into a trampoline with its memory operand turned into an
 * absolute address inside lowmem[], followed by a jump back. Flags and every operation then work as on the CPU. */
static uint8_t lowmem[0x10000 + 16];
static uint8_t tramp[32];

static uint32_t *gpr(ctx_t *c, int i)
{
    switch (i & 7) {
    case 0: return (uint32_t *)&R(c, EAX);
    case 1: return (uint32_t *)&R(c, ECX);
    case 2: return (uint32_t *)&R(c, EDX);
    case 3: return (uint32_t *)&R(c, EBX);
    case 4: return (uint32_t *)&R(c, ESP);
    case 5: return (uint32_t *)&R(c, EBP);
    case 6: return (uint32_t *)&R(c, ESI);
    }
    return (uint32_t *)&R(c, EDI);
}

/* Size of the immediate after the ModRM operand of opcode op (two-byte opcodes as 0x0Fxx), or -1 when op has no ModRM byte. */
static int modrm_imm(unsigned op, int reg, int o16)
{
    int iz = o16 ? 2 : 4;
    if (op < 0x40) return (op & 7) < 4 ? 0 : -1;
    switch (op) {
    case 0x62: case 0x63: case 0x84: case 0x85: case 0x86: case 0x87: case 0x88: case 0x89: case 0x8A: case 0x8B: case 0x8C:
    case 0x8E: case 0x8F: case 0xC4: case 0xC5: case 0xD0: case 0xD1: case 0xD2: case 0xD3: case 0xD8: case 0xD9: case 0xDA:
    case 0xDB: case 0xDC: case 0xDD: case 0xDE: case 0xDF: case 0xFE: case 0xFF:
        return 0;
    case 0x69: case 0x81: case 0xC7: return iz;
    case 0x6B: case 0x80: case 0x83: case 0xC0: case 0xC1: case 0xC6: return 1;
    case 0xF6: return reg < 2 ? 1 : 0;
    case 0xF7: return reg < 2 ? iz : 0;
    case 0x0FBA: case 0x0FA4: case 0x0FAC: return 1;
    }
    if (op >= 0x0F00 && ((op >= 0x0FB0 && op <= 0x0FBF) || (op >= 0x0F90 && op <= 0x0F9F) || op == 0x0FA3 || op == 0x0FAB ||
                         op == 0x0FA5 || op == 0x0FAD || op == 0x0FAF || op == 0x0FB3 || op == 0x0FBB))
        return 0;
    return -1;
}

/* Rewrite the instruction at ip into tramp[] if it accesses memory below 0x10000 (when t is not null). Returns its length, or 0. */
static int low_memory_rewrite(ctx_t *c, uint8_t *ip, uint8_t *t)
{
    int n = 0, o16 = 0, mod, reg, rm, imm, k = 0;
    unsigned op;
    uint32_t ea = 0;
    uint8_t buf[32];
    if (!t) t = buf;
    while (ip[n] == 0x66 || ip[n] == 0x26 || ip[n] == 0x2E || ip[n] == 0x36 || ip[n] == 0x3E || ip[n] == 0xF2 || ip[n] == 0xF3) {
        if (ip[n] == 0x66) o16 = 1;
        n++;
    }
    op = ip[n++];
    if (op == 0x0F) op = 0x0F00 | ip[n++];
    if (op >= 0xA0 && op <= 0xA3) {                    /* mov between al/ax/eax and an absolute address */
        memcpy(&ea, ip + n, 4);
        if (ea >= 0x10000) return 0;
        memcpy(t, ip, n);
        t += n;
        ea = (uint32_t)(lowmem + ea);
        memcpy(t, &ea, 4);
        t += 4;
        n += 4;
    } else {
        mod = ip[n] >> 6; reg = (ip[n] >> 3) & 7; rm = ip[n] & 7;
        imm = modrm_imm(op, reg, o16);
        if (imm < 0 || mod == 3) return 0;
        k = n++;
        if (rm == 4) {
            int sib = ip[n++], base = sib & 7, index = (sib >> 3) & 7;
            if (index != 4) ea += *gpr(c, index) << (sib >> 6);
            if (base == 5 && mod == 0) { uint32_t d; memcpy(&d, ip + n, 4); ea += d; n += 4; }
            else ea += *gpr(c, base);
        } else if (rm == 5 && mod == 0) { uint32_t d; memcpy(&d, ip + n, 4); ea += d; n += 4; }
        else ea += *gpr(c, rm);
        if (mod == 1) { ea += (int8_t)ip[n]; n += 1; }
        else if (mod == 2) { uint32_t d; memcpy(&d, ip + n, 4); ea += d; n += 4; }
        if (ea >= 0x10000) return 0;
        memcpy(t, ip, k);                                /* prefixes and opcode */
        t += k;
        *t++ = (reg << 3) | 5;                           /* [disp32] */
        ea = (uint32_t)(lowmem + ea);
        memcpy(t, &ea, 4);
        t += 4;
        memcpy(t, ip + n, imm);
        t += imm;
        n += imm;
    }
    *t++ = 0xE9;                                         /* jmp back to the next instruction */
    { int32_t rel = (int32_t)((uintptr_t)(ip + n) - ((uintptr_t)t + 4)); memcpy(t, &rel, 4); }
    return n;
}

/* Does the instruction at ip (in context c) fault on memory below 0x10000? */
int accesses_low_memory(ctx_t *c, uint8_t *ip)
{
    return low_memory_rewrite(c, ip, 0) > 0;
}

int emulate_low_memory(ctx_t *c, uint8_t *ip)
{
    if (!low_memory_rewrite(c, ip, tramp)) return 0;
    TRACE("low memory access at %08x\n", (unsigned)(uintptr_t)ip);
    R(c, EIP) = (uint32_t)(uintptr_t)tramp;
    return 1;
}

int emulate_privileged(ctx_t *c, uint8_t *ip)
{
    int o16 = 0, rep = 0, n = 0;
    uint8_t op;
    for (;;) {
        if (ip[n] == 0x66) { o16 = 1; n++; }
        else if (ip[n] == 0xF3 || ip[n] == 0xF2) { rep = 1; n++; }
        else break;
    }
    op = ip[n];
    switch (op) {
    case 0xCC:
        return n ? 0 : emulate_flagop(c, ip);
    case 0xCD:
        return dos_int(c, ip[n + 1]) ? n + 2 : 0;
    case 0xFA: irq_set_enabled(c, 0); return n + 1;                 /* cli */
    case 0xFB: irq_set_enabled(c, 1); return n + 1;                  /* sti: a pending interrupt is taken at the next tick */
    case 0xE4: R(c, EAX) = (R(c, EAX) & ~0xFFu) | port_in(c, ip[n + 1], 1); return n + 2;
    case 0xE5:
        if (o16) R(c, EAX) = (R(c, EAX) & ~0xFFFFu) | port_in(c, ip[n + 1], 2);
        else R(c, EAX) = port_in(c, ip[n + 1], 4);
        return n + 2;
    case 0xE6: port_out(c, ip[n + 1], R(c, EAX) & 0xFF, 1); return n + 2;
    case 0xE7: port_out(c, ip[n + 1], o16 ? R(c, EAX) & 0xFFFF : R(c, EAX), o16 ? 2 : 4); return n + 2;
    case 0xEC: R(c, EAX) = (R(c, EAX) & ~0xFFu) | port_in(c, R(c, EDX) & 0xFFFF, 1); return n + 1;
    case 0xED:
        if (o16) R(c, EAX) = (R(c, EAX) & ~0xFFFFu) | port_in(c, R(c, EDX) & 0xFFFF, 2);
        else R(c, EAX) = port_in(c, R(c, EDX) & 0xFFFF, 4);
        return n + 1;
    case 0xEE: port_out(c, R(c, EDX) & 0xFFFF, R(c, EAX) & 0xFF, 1); return n + 1;
    case 0xEF: port_out(c, R(c, EDX) & 0xFFFF, o16 ? R(c, EAX) & 0xFFFF : R(c, EAX), o16 ? 2 : 4); return n + 1;
    case 0x6C: case 0x6D: case 0x6E: case 0x6F: { /* ins / outs, with rep */
        int size = (op & 1) ? (o16 ? 2 : 4) : 1;
        uint32_t count = rep ? R(c, ECX) : 1;
        int dir = (R(c, EFL) & 0x400) ? -1 : 1;
        while (count--) {
            if (op < 0x6E) {
                uint32_t v = port_in(c, R(c, EDX) & 0xFFFF, size);
                memcpy((void *)R(c, EDI), &v, size);
                R(c, EDI) += dir * size;
            } else {
                uint32_t v = 0;
                memcpy(&v, (void *)R(c, ESI), size);
                port_out(c, R(c, EDX) & 0xFFFF, v, size);
                R(c, ESI) += dir * size;
            }
        }
        if (rep) R(c, ECX) = 0;
        return n + 1;
    }
    }
    return 0;
}
