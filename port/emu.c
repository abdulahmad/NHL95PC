/* Decode and emulate the privileged instructions the game executes (int n, in, out, cli, sti). */
#include "host.h"

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
