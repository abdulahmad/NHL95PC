/* NHL95_SOUNDTEST=1: drive each emulated sound device through its I/O ports the way the game's drivers do, and exit. With
 * NHL95_WAV=file.wav the result can be listened to; the host-side checks print PASS/FAIL. */
#include "host.h"
#include "audio.h"
#include <math.h>

#define PO(p, v) port_out(0, p, v, 1)
#define PI(p) port_in(0, p, 1)

static void wait_ms(int ms)
{
    int64_t end = plat_now_ns() + ms * 1000000LL;
    while (plat_now_ns() < end) { audio_pump(); plat_sleep_ms(1); }
}

static void opl(int r, int v) { PO(0x388, r); PO(0x389, v); }

int soundtest(void)
{
    int i, fails = 0;
    uint8_t *buf = (uint8_t *)0x20000;

    /* AdLib: timer 1 must set status bits 7 and 6 after (256-x)*80us */
    opl(4, 0x60); opl(4, 0x80);
    if (PI(0x388) & 0xE0) { printf("FAIL opl status not clear\n"); fails++; }
    opl(2, 0xF0); opl(4, 0x21); wait_ms(30);
    if ((PI(0x388) & 0xC0) != 0xC0) { printf("FAIL opl timer 1\n"); fails++; } else printf("PASS opl timer 1\n");
    opl(4, 0x60); opl(4, 0x80);
    opl(0x20, 0x01); opl(0x40, 0x10); opl(0x60, 0xF4); opl(0x80, 0x77);
    opl(0x23, 0x01); opl(0x43, 0x00); opl(0x63, 0xF4); opl(0x83, 0x77);
    opl(0xA0, 0x98); opl(0xB0, 0x31);
    wait_ms(400);
    opl(0xB0, 0x11); wait_ms(100);

    /* Sound Blaster: DMA channel 1, a 440 Hz tone at 11 kHz, single cycle, then the block interrupt */
    for (i = 0; i < 4400; i++) buf[i] = 128 + (int)(100 * sin(i * 2 * M_PI * 440 / 11025));
    PO(0x0A, 5); PO(0x0C, 0); PO(0x0B, 0x49); PO(0x02, 0x00); PO(0x02, 0x00); PO(0x83, 2);
    PO(0x03, (4400 - 1) & 0xFF); PO(0x03, (4400 - 1) >> 8); PO(0x0A, 1);
    PO(0x226, 1); wait_ms(5); PO(0x226, 0); wait_ms(5);
    if (PI(0x22A) != 0xAA) { printf("FAIL sb reset byte\n"); fails++; } else printf("PASS sb reset\n");
    PO(0x22C, 0xD1); PO(0x22C, 0x40); PO(0x22C, 256 - 1000000 / 11025);
    PO(0x22C, 0x14); PO(0x22C, (4400 - 1) & 0xFF); PO(0x22C, (4400 - 1) >> 8);
    wait_ms(500);
    PO(0x224, 0x82);
    if (!(PI(0x225) & 1)) { printf("FAIL sb no completion\n"); fails++; } else printf("PASS sb dma block\n");

    /* GUS: a sine into sample RAM, voice 0 looping at its native pitch (fc 0x400 = one sample per output step) */
#define GREG(r, v) do { PO(0x343, r); PO(0x344, (v) & 0xFF); PO(0x345, ((v) >> 8) & 0xFF); } while (0)
#define GREG8(r, v) do { PO(0x343, r); PO(0x345, v); } while (0)
    GREG8(0x4C, 0); GREG8(0x4C, 1);
    GREG8(0x0E, 13);
    PO(0x343, 0x44); PO(0x345, 0);
    for (i = 0; i < 256; i++) { PO(0x343, 0x43); PO(0x344, i); PO(0x345, 0); PO(0x347, (uint8_t)(int8_t)(int)(100 * sin(i * 2 * M_PI / 256))); }
    PO(0x342, 0);
    GREG(0x01, 0x0400);
    GREG(0x02, 0); GREG(0x03, 0);
    GREG(0x04, 1); GREG(0x05, 0xFE00);
    GREG(0x0A, 0); GREG(0x0B, 0);
    GREG(0x09, 0xE000);
    GREG8(0x0C, 7);
    GREG8(0x0D, 0x03);
    GREG8(0x00, 0x08);                  /* loop, running */
    wait_ms(600);
    GREG8(0x00, 0x03);
    PO(0x343, 0x8A); { unsigned pos = PI(0x344) | (PI(0x345) << 8); printf("%s gus position read %u\n", pos ? "PASS" : "NOTE", pos); }
    printf("soundtest done, %d failure(s)\n", fails);
    return fails;
}
