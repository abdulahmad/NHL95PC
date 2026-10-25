/* Hardware interrupts for the game. The game installs its own timer (IRQ 0, vector 8) and keyboard (IRQ 1, vector 9)
 * handlers with int 21h/25h or DPMI 0205h. The main thread raises an IRQ (a bit in `pending`); irq_poll asks the platform
 * layer to interrupt the game thread, and irq_try_deliver makes the interrupted code "take the interrupt": it pushes an iret frame
 * so the handler returns through a small stub (which clears the in-service flag) back to the interrupted instruction. */
#include "host.h"

static volatile uint32_t pending;               /* bit n: IRQ n is raised (0-15) */
static volatile uint32_t pic_mask = 0xFFFC;     /* bit n set: IRQ n masked; the BIOS leaves the timer and keyboard on */
static int pic_icw[2], pic_icw_left[2];
volatile int vif = 1;                   /* the game's interrupt flag (cli / sti) */
volatile uint8_t isr_active;
static volatile unsigned pit_divisor = 0x10000;

/* Entered by the handler's iret: re-enable delivery and continue at the interrupted address (it is on the stack). */
#ifdef _WIN32
#define ISR_FLAG "_isr_active"
#else
#define ISR_FLAG "isr_active"
#endif
__attribute__((naked)) static void irq_return_stub(void)
{
    __asm__ volatile("movb $0, " ISR_FLAG "\n\tret");
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
    __sync_fetch_and_and(&pending, ~(1u << irq));
    if (!pm_vec[vec].off) return 0;
    sp = (uint32_t *)R(c, ESP) - 4;
    sp[0] = (uint32_t)irq_return_stub;
    sp[1] = R(c, CS) & 0xFFFF;
    sp[2] = R(c, EFL);
    sp[3] = R(c, EIP);
    R(c, ESP) = (uint32_t)sp;
    R(c, EIP) = pm_vec[vec].off;
    isr_active = 1;
    return 1;
}

/* any thread */
void irq_raise(int irq)
{
    __sync_fetch_and_or(&pending, 1u << irq);
}

/* main thread, every millisecond or so */
void irq_poll(void)
{
    static int64_t last;
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
    (void)c;
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
