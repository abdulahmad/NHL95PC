/* I/O ports. The video and keyboard ports live in video.c and input.c; the PIT is handled here; everything else reads as
 * 0xFF (no device) and ignores writes. */
#include "host.h"

static int pit_state;           /* 0: next byte is the low byte of channel 0's divisor */
static unsigned pit_lo;

uint32_t port_in(ctx_t *c, unsigned port, int size)
{
    uint32_t v;
    (void)c;
    if ((port >= 0x3C0 && port <= 0x3DF) || (port >= 0x1CE && port <= 0x1CF)) v = video_port_in(port);
    else if (port == 0x60 || port == 0x64 || port == 0x61 || port == 0x201) v = input_port_in(port);
    else v = 0xFF;
    TRACE("in  %03x -> %02x\n", port, v & 0xFF);
    if (size == 2) return v | 0xFF00;
    if (size == 4) return v | 0xFFFFFF00u;
    return v & 0xFF;
}

void port_out(ctx_t *c, unsigned port, uint32_t val, int size)
{
    (void)c;
    if (size > 1) {                       /* word and dword writes go out as consecutive bytes (index/data register pairs) */
        int i;
        for (i = 0; i < size; i++) port_out(c, port + i, (val >> (8 * i)) & 0xFF, 1);
        return;
    }
    TRACE("out %03x <- %02x\n", port, val);
    if ((port >= 0x3C0 && port <= 0x3DF) || (port >= 0x1CE && port <= 0x1CF)) { video_port_out(port, val); return; }
    if (port == 0x60 || port == 0x64 || port == 0x61 || port == 0x201) { input_port_out(port, val); return; }
    if (port == 0x43) { pit_state = 0; return; }
    if (port == 0x40) {
        if (pit_state == 0) { pit_lo = val; pit_state = 1; }
        else { irq_pit_divisor((val << 8) | pit_lo); pit_state = 0; }
    }
}
