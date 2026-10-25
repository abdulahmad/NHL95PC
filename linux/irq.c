/* Hardware interrupts for the game. The game installs its own timer (IRQ 0, vector 8) and keyboard (IRQ 1, vector 9)
 * handlers with int 21h/25h or DPMI 0205h. The main thread raises an IRQ by signalling the game thread, and the signal
 * handler makes the interrupted code "take the interrupt": it pushes an iret frame so the handler returns through a small
 * stub (which clears the in-service flag) back to the interrupted instruction. */
#include "host.h"
#include <time.h>

static volatile uint32_t pending;
volatile int vif = 1;                   /* the game's interrupt flag (cli / sti) */
volatile uint8_t isr_active;
static volatile unsigned pit_divisor = 0x10000;

/* Entered by the handler's iret: re-enable delivery and continue at the interrupted address (it is on the stack). */
__attribute__((naked)) static void irq_return_stub(void)
{
    __asm__ volatile("movb $0, isr_active\n\tret");
}

static int try_deliver(ucontext_t *c)
{
    int irq, vec;
    uint32_t *sp;
    if (!vif || isr_active || !pending) return 0;
    irq = __builtin_ctz(pending);
    vec = irq == 0 ? 8 : 9;
    if (!pm_vec[vec].off) { pending &= ~(1u << irq); return 0; }
    pending &= ~(1u << irq);
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

static void irq_signal(int sig, siginfo_t *si, void *uc)
{
    (void)sig; (void)si;
    try_deliver(uc);
}

void irq_init(void)
{
    struct sigaction sa;
    memset(&sa, 0, sizeof sa);
    sa.sa_sigaction = irq_signal;
    sa.sa_flags = SA_SIGINFO | SA_ONSTACK;
    sigaddset(&sa.sa_mask, SIGSEGV);
    sigaction(SIGUSR1, &sa, 0);
}

/* any thread */
void irq_raise(int irq)
{
    __sync_fetch_and_or(&pending, 1u << irq);
    pthread_kill(game_thread, SIGUSR1);
}

/* called from the trap handler for cli / sti */
void irq_set_enabled(ucontext_t *c, int on)
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
