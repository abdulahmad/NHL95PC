/* Hardware interrupts for the game. The game installs its own timer (IRQ 0, vector 8) and keyboard (IRQ 1, vector 9)
 * handlers with int 21h/25h or DPMI 0205h. The main thread raises an IRQ (a bit in `pending`); irq_poll asks the platform
 * layer to interrupt the game thread, and irq_try_deliver makes the interrupted code "take the interrupt": it pushes an iret frame
 * so the handler returns through a small stub (which clears the in-service flag) back to the interrupted instruction. */
#include "host.h"
#include "audio.h"

static volatile uint32_t pending;               /* bit n: IRQ n is raised (0-15) */
/* Timer ticks that came while the game could not take one (inside host code, in a long trap, with interrupts off) are kept and
 * delivered one after another, like a PIC that is serviced late; the game's clock (tickcount) counts every one. A real PIC would
 * merge ticks too, but only after a much longer stall, so the queue is limited to half a second at 100 Hz. */
#define MAX_TICKS_QUEUED 50
static volatile int ticks_queued;
static volatile uint32_t pic_mask = 0xFFFC;     /* bit n set: IRQ n masked; the BIOS leaves the timer and keyboard on */
static int pic_icw[2], pic_icw_left[2];
volatile int vif = 1;                   /* the game's interrupt flag (cli / sti) */
volatile uint8_t isr_active;
static volatile unsigned pit_divisor = 0x10000;

/* Entered by the handler's iret: re-enable delivery and continue at the interrupted address (it is on the stack). The iret
 * restores the interrupt flag the interrupted code had, which was set (an interrupt is only taken then): the game's interrupt flag
 * is vif, which the CPU's iret does not touch, so the stub sets it (the Sound Blaster handler ends with cli). */
#ifdef _WIN32
#define ISR_FLAG "_isr_active"
#define VIF "_vif"
#else
#define ISR_FLAG "isr_active"
#define VIF "vif"
#endif
__attribute__((naked)) static void irq_return_stub(void)
{
    __asm__ volatile("movl $1, " VIF "\n\tmovb $0, " ISR_FLAG "\n\tret");
}

/* The interrupt controllers: the mask registers (21h, A1h) and the initialisation words the game may write. */
uint32_t pic_in(unsigned port)
{
    if (port == 0x21) return pic_mask & 0xFF;
    if (port == 0xA1) return (pic_mask >> 8) & 0xFF;
    return 0;                                   /* in-service and request registers: nothing in service */
}

void pic_out(unsigned port, uint32_t val)
{
    int chip = port >= 0xA0;
    if ((port & 1) == 0) {
        if (val & 0x10) { pic_icw[chip] = 1; pic_icw_left[chip] = 1 + ((val & 2) ? 0 : 1) + (val & 1); }   /* ICW1: ICW2, ICW3, ICW4 follow */
        return;                                 /* OCW2 / OCW3: end of interrupt, register select */
    }
    if (pic_icw_left[chip] > 0) { pic_icw_left[chip]--; return; }
    if (chip) pic_mask = (pic_mask & 0x00FF) | ((val & 0xFF) << 8);
    else pic_mask = (pic_mask & 0xFF00) | (val & 0xFF);
    TRACE("PIC mask %04x\n", (unsigned)pic_mask);
}

/* Timing of the interrupt path, appended to nhl95-audio.log every 10 s while a sound interrupt (IRQ 2 and up) is in use: how long an
 * interrupt waited between being raised and being taken, how long its handler ran, and what held it back. Class 0: the timer, 1: sound. */
static int64_t raise_ns[16], isr_start_ns;
static int isr_class;
static struct {
    uint32_t n[2], over10[2];
    double wait_max[2], isr_max[2];
    uint32_t b_vif, b_isr, b_other;
} idg;

int irq_deliverable(void)
{
    return vif && !isr_active && (pending & ~pic_mask);
}

int irq_try_deliver(ctx_t *c)
{
    int irq, vec;
    uint32_t *sp;
    if (!irq_deliverable()) return 0;
    irq = __builtin_ctz(pending & ~pic_mask);
    vec = irq < 8 ? 8 + irq : 0x70 + irq - 8;
    if (irq != 0 || __sync_sub_and_fetch(&ticks_queued, 1) <= 0) {
        if (irq == 0) ticks_queued = 0;
        __sync_fetch_and_and(&pending, ~(1u << irq));
    }
    if (!pm_vec[vec].off) return 0;
    {
        int cl = irq > 1;
        int64_t now = plat_now_ns();
        double w = raise_ns[irq] ? (now - raise_ns[irq]) / 1e6 : 0;
        idg.n[cl]++; if (w > idg.wait_max[cl]) idg.wait_max[cl] = w; if (w > 10) idg.over10[cl]++;
        isr_start_ns = now; isr_class = cl;
    }
    { extern volatile uint32_t trap_ring[256]; extern volatile unsigned trap_ring_n; trap_ring[trap_ring_n++ & 255] = 0x80000000u | vec; }
    if (stats_on) stats_irq(irq, 1);
    if (irq > 1) TRACE("irq %d -> vector %02x\n", irq, vec);
    sp = (uint32_t *)R(c, ESP) - 4;
    sp[0] = (uint32_t)irq_return_stub;
    sp[1] = R(c, CS) & 0xFFFF;
    sp[2] = R(c, EFL);
    sp[3] = R(c, EIP);
    R(c, ESP) = (uint32_t)sp;
    R(c, EIP) = pm_vec[vec].off;
    isr_active = 1;
    vif = 0;                            /* an interrupt gate clears IF */
    return 1;
}

/* any thread */
void irq_raise(int irq)
{
    if (stats_on) stats_irq(irq, 0);
    if (irq == 0 && ticks_queued < MAX_TICKS_QUEUED) __sync_fetch_and_add(&ticks_queued, 1);
    if (!(pending & (1u << irq))) raise_ns[irq] = plat_now_ns();
    __sync_fetch_and_or(&pending, 1u << irq);
}

/* main thread, every millisecond or so */
void irq_poll(void)
{
    static int64_t last, dlast;
    int64_t now = plat_now_ns();
    if (isr_start_ns && !isr_active) {                          /* a handler has returned */
        double d = (now - isr_start_ns) / 1e6;
        if (d > idg.isr_max[isr_class]) idg.isr_max[isr_class] = d;
        isr_start_ns = 0;
    }
    {                                                           /* the game's interrupt flag off for a long time outside a handler: where is it? */
        static int64_t off_since;
        static int reported;
        if (!vif && !isr_active) {
            if (!off_since) off_since = now;
            else if (now - off_since > 200000000LL && !reported) {
                reported = 1;
                audio_log("the game's interrupt flag has been off for 200 ms (outside an interrupt handler)");
                if (trace_on) plat_trace_game();
            }
        } else { off_since = 0; reported = 0; }
    }
    if (pending & ~pic_mask & ~1u) {                            /* a sound interrupt is waiting: why? */
        if (!vif) idg.b_vif++; else if (isr_active) idg.b_isr++; else idg.b_other++;
    }
    if (!dlast) dlast = now;
    if (now - dlast > 10000000000LL) {
        dlast = now;
        if (idg.n[1]) {
            audio_log("interrupts, last 10 s: timer %u taken, waited at most %.1f ms (over 10 ms: %u), handler ran at most %.1f ms; "
                      "sound %u taken, waited at most %.1f ms (over 10 ms: %u), handler ran at most %.1f ms; a sound interrupt was held back "
                      "%u ms by interrupts off, %u ms by a running handler, %u ms until the game thread could be stopped",
                      idg.n[0], idg.wait_max[0], idg.over10[0], idg.isr_max[0], idg.n[1], idg.wait_max[1], idg.over10[1], idg.isr_max[1],
                      idg.b_vif, idg.b_isr, idg.b_other);
            memset(&idg, 0, sizeof idg);
        }
    }
    if (irq_deliverable()) plat_kick_game();
    if (trace_on && plat_now_ns() - last > 2000000000LL) {
        last = plat_now_ns();
        fprintf(stderr, "irq state: vif=%d isr_active=%d pending=%x\n", vif, isr_active, (unsigned)pending);
        plat_trace_game();
    }
}

/* called from the trap handler for cli / sti */
void irq_set_enabled(ctx_t *c, int on)
{
    TRACE("%s at %08x %.3f\n", on ? "sti" : "cli", (unsigned)R(c, EIP), plat_now_ns() / 1e9);
    vif = on;
}

void irq_pit_divisor(unsigned divisor)
{
    pit_divisor = divisor ? divisor : 0x10000;
    TRACE("PIT divisor %u (%u Hz)\n", pit_divisor, irq_pit_hz());
}

unsigned irq_pit_hz(void)
{
    return 1193182u / pit_divisor;
}
