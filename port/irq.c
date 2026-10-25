/* Hardware interrupts for the game. The game installs its own timer (IRQ 0, vector 8) and keyboard (IRQ 1, vector 9)
 * handlers with int 21h/25h or DPMI 0205h. The main thread raises an IRQ (a bit in `pending`); irq_poll asks the platform
 * layer to interrupt the game thread, and irq_try_deliver makes the interrupted code "take the interrupt": it pushes an iret frame
 * so the handler returns through a small stub (which clears the in-service flag) back to the interrupted instruction. */
#include "host.h"

static volatile uint32_t pending;
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

int irq_deliverable(void)
{
    return vif && !isr_active && pending;
}

int irq_try_deliver(ctx_t *c)
{
    int irq, vec;
    uint32_t *sp;
    if (!irq_deliverable()) return 0;
    irq = __builtin_ctz(pending);
    vec = irq == 0 ? 8 : 9;
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
    if (irq_deliverable()) plat_kick_game();
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
