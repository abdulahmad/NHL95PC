/* The two 8237 DMA controllers (channels 0-3 move bytes, channels 4-7 words) and the page registers. Sound cards read their data
 * from the memory a channel points at; dma_next_byte / dma_advance step the channel like the controller would, and the address and
 * count the game reads back follow the playback. Memory below 1 MB is mapped at the same address, so a physical address is a pointer. */
#include "host.h"
#include "audio.h"

struct dma_chan {
    uint32_t base_addr, cur_addr;      /* in units of the channel (bytes, or words for channels 4-7) */
    uint32_t base_count, cur_count;    /* transfer length minus one, in the same units */
    uint8_t page, mode, masked, tc;
};

static struct dma_chan chan[8] = { { .masked = 1 }, { .masked = 1 }, { .masked = 1 }, { .masked = 1 },
                                   { .masked = 1 }, { .masked = 1 }, { .masked = 1 }, { .masked = 1 } };
static int flip[2];                    /* the byte flip-flop of each controller */
static const int page_chan[16] = { -1, 2, 3, 1, -1, -1, -1, 0, -1, 6, 7, 5, -1, -1, -1, -1 };   /* port 0x80+i -> channel */

static int unit(int ch) { return ch >= 4 ? 2 : 1; }

uint32_t dma_in(unsigned port)
{
    int ctl, ch, reg;
    struct dma_chan *c;
    uint32_t v;
    if (port >= 0x80 && port <= 0x8F) {
        ch = page_chan[port - 0x80];
        return ch < 0 ? 0 : chan[ch].page;
    }
    ctl = port >= 0xC0;
    if (port < 0x08 || (port >= 0xC0 && port < 0xD0)) {
        reg = ctl ? ((port - 0xC0) >> 1) : port;
        ch = (ctl ? 4 : 0) + (reg >> 1);
        c = &chan[ch];
        if (!flip[ctl]) sb_pump();      /* the position the game reads is the one of this moment (not on the high byte: it would tear) */
        v = (reg & 1) ? c->cur_count : c->cur_addr;
        v = flip[ctl] ? (v >> 8) & 0xFF : v & 0xFF;
        flip[ctl] ^= 1;
        return v;
    }
    if (port == 0x08 || port == 0xD0) {          /* status: terminal count flags */
        uint32_t s = 0;
        for (ch = ctl * 4; ch < ctl * 4 + 4; ch++) if (chan[ch].tc) { s |= 1u << (ch & 3); chan[ch].tc = 0; }
        return s;
    }
    return 0;
}

void dma_out(unsigned port, uint32_t val)
{
    int ctl, ch, reg;
    struct dma_chan *c;
    if (port >= 0x80 && port <= 0x8F) {
        ch = page_chan[port - 0x80];
        if (ch >= 0) chan[ch].page = val;
        return;
    }
    ctl = port >= 0xC0;
    if (port < 0x08 || (port >= 0xC0 && port < 0xD0)) {
        reg = ctl ? ((port - 0xC0) >> 1) : port;
        ch = (ctl ? 4 : 0) + (reg >> 1);
        c = &chan[ch];
        if (reg & 1) {
            c->base_count = flip[ctl] ? (c->base_count & 0x00FF) | (val << 8) : (c->base_count & 0xFF00) | val;
            c->cur_count = c->base_count;
        } else {
            c->base_addr = flip[ctl] ? (c->base_addr & 0x00FF) | (val << 8) : (c->base_addr & 0xFF00) | val;
            c->cur_addr = c->base_addr;
        }
        flip[ctl] ^= 1;
        return;
    }
    ctl = (port >= 0xD0);
    switch (ctl ? 0x08 + ((port - 0xD0) >> 1) : port) {
    case 0x0A: ch = (ctl ? 4 : 0) + (val & 3); chan[ch].masked = (val >> 2) & 1; TRACE("dma ch%d mask %d\\n", ch, chan[ch].masked); break;
    case 0x0B: ch = (ctl ? 4 : 0) + (val & 3); chan[ch].mode = val;
        TRACE("dma ch%d mode %02x\\n", ch, (unsigned)val); break;
    case 0x0C: flip[ctl] = 0; break;
    case 0x0D: flip[ctl] = 0; for (ch = ctl * 4; ch < ctl * 4 + 4; ch++) chan[ch].masked = 1; break;
    case 0x0E: for (ch = ctl * 4; ch < ctl * 4 + 4; ch++) chan[ch].masked = 0; break;
    case 0x0F: for (ch = 0; ch < 4; ch++) chan[ctl * 4 + ch].masked = (val >> ch) & 1; break;
    }
}

int dma_masked(int ch) { return chan[ch].masked; }
int dma_is_autoinit(int ch) { return (chan[ch].mode >> 4) & 1; }
int dma_is_read(int ch) { return ((chan[ch].mode >> 2) & 3) == 2; }    /* memory to device */

/* the physical address of the next unit the channel will transfer */
uint32_t dma_address(int ch)
{
    struct dma_chan *c = &chan[ch];
    return ch >= 4 ? ((uint32_t)(c->page & 0xFE) << 16) | (c->cur_addr << 1) : ((uint32_t)c->page << 16) | c->cur_addr;
}

/* units left before terminal count, counting the one about to be transferred */
uint32_t dma_remaining(int ch) { return chan[ch].cur_count + 1; }

/* Transfer up to `n` units (bytes or words): the channel steps forward and wraps or stops at terminal count. Returns how many
 * were available before the terminal count. */
uint32_t dma_advance(int ch, uint32_t n)
{
    struct dma_chan *c = &chan[ch];
    uint32_t left = c->cur_count + 1, done = n < left ? n : left;
    c->cur_addr = (c->cur_addr + done) & 0xFFFF;
    c->cur_count -= done;
    if (done == left) {
        c->tc = 1;
        if (c->mode & 0x10) { c->cur_addr = c->base_addr; c->cur_count = c->base_count; }
        else { c->cur_count = 0xFFFF; c->masked = 1; }
    }
    (void)unit;
    return done;
}

/* The byte `ahead` units after the one the channel is about to transfer, wrapping inside an auto-initialized buffer (a test aid for the
 * Sound Blaster's NHL95_SB_LEAD_MS); the current byte when the channel is not auto-initialized or the buffer is shorter than that. */
uint8_t *dma_peek(int ch, uint32_t ahead)
{
    struct dma_chan *c = &chan[ch];
    uint32_t size = (uint32_t)c->base_count + 1, off = (c->cur_addr - c->base_addr) & 0xFFFF;
    if (ch >= 4 || !(c->mode & 0x10) || ahead >= size) return (uint8_t *)dma_address(ch);
    off = (off + ahead) % size;
    return (uint8_t *)(((uint32_t)c->page << 16) | ((c->base_addr + off) & 0xFFFF));
}
