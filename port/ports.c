/* I/O ports. The video and keyboard ports live in video.c and input.c; the PIT is handled here; everything else reads as
 * 0xFF (no device) and ignores writes. */
#include "host.h"
#include "audio.h"

static int pit_state;           /* 0: next byte is the low byte of channel 0's divisor */
static unsigned pit_lo;

/* Sound Blaster, MPU-401 and Gravis UltraSound ports, wherever the configuration put them (sound_ports.c) */
int sound_port_in(unsigned port, uint32_t *v);
int sound_port_out(unsigned port, uint32_t val);

uint32_t port_in(ctx_t *c, unsigned port, int size)
{
    uint32_t v;
    (void)c;
    if (size > 1 && !(port >= 0x3C0 && port <= 0x3DF)) {          /* word/dword reads: consecutive bytes (16-bit device registers) */
        int i;
        v = 0;
        for (i = 0; i < size; i++) v |= port_in(c, port + i, 1) << (8 * i);
        return v;
    }
    if ((port >= 0x3C0 && port <= 0x3DF) || (port >= 0x1CE && port <= 0x1CF)) v = video_port_in(port);
    else if (port == 0x61 || port == 0x42) v = speaker_in(port);
    else if (port == 0x60 || port == 0x64 || port == 0x201) v = input_port_in(port);
    else if (port == 0x21 || port == 0xA1 || port == 0x20 || port == 0xA0) v = pic_in(port);
    else if (port < 0x10 || (port >= 0x80 && port < 0x90) || (port >= 0xC0 && port < 0xE0)) v = dma_in(port);
    else if ((port >= 0x388 && port <= 0x38B)) v = opl_in(port);
    else if (sound_port_in(port, &v)) {}
    else v = 0xFF;
    if (stats_on) stats_port(port, 0);
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
    if (stats_on) stats_port(port, 1);
    TRACE("out %03x <- %02x\n", port, val);
    if ((port >= 0x3C0 && port <= 0x3DF) || (port >= 0x1CE && port <= 0x1CF)) { video_port_out(port, val); return; }
    if (port == 0x60 || port == 0x64 || port == 0x201) { input_port_out(port, val); return; }
    if (port == 0x61 || port == 0x42) { speaker_out(port, val); return; }
    if (port == 0x20 || port == 0x21 || port == 0xA0 || port == 0xA1) { pic_out(port, val); return; }
    if (port < 0x10 || (port >= 0x80 && port < 0x90) || (port >= 0xC0 && port < 0xE0)) { dma_out(port, val); return; }
    if (port >= 0x388 && port <= 0x38B) { opl_out(port, val); return; }
    if (sound_port_out(port, val)) return;
    if (port == 0x43) { if ((val >> 6) == 0) pit_state = 0; else speaker_out(port, val); return; }
    if (port == 0x40) {
        if (pit_state == 0) { pit_lo = val; pit_state = 1; }
        else { irq_pit_divisor((val << 8) | pit_lo); pit_state = 0; }
    }
}
