/* NHL95_STATS=1: every 2 seconds, what the game thread spent on traps (int, in, out, cli, sti, pushf, popf), by opcode, port and
 * interrupt vector, how long the host side of each trap took, how long video_present took, the game thread's user and kernel CPU time
 * (exception dispatch is mostly kernel time) and the game's tick rate against the PIT rate. Costs a counter increment per trap. */
#include "host.h"

int stats_on;
#define NPORT 0x400
static volatile uint32_t c_op[256], c_in[NPORT], c_out[NPORT], c_int[256], c_ah[256], c_irq_raised[16], c_irq_taken[16], c_ticks;
static volatile uint64_t trap_ns, vp_ns, vp_max_ns;
static volatile uint32_t n_traps, vp_n;
static uint32_t p_op[256], p_in[NPORT], p_out[NPORT], p_int[256], p_ah[256];

void stats_init(void) { stats_on = getenv("NHL95_STATS") != 0; }
void stats_op(unsigned op) { c_op[op & 255]++; }
void stats_port(unsigned port, int out) { if (port < NPORT) (out ? c_out : c_in)[port]++; }
void stats_int(unsigned vec, unsigned ah) { c_int[vec & 255]++; if (vec == 0x21) c_ah[ah & 255]++; }
void stats_irq(int irq, int taken) { if (irq < 16) (taken ? c_irq_taken : c_irq_raised)[irq]++; }
void stats_trap_ns(int64_t ns) { trap_ns += ns; n_traps++; }
void stats_present_ns(int64_t ns) { vp_ns += ns; vp_n++; if ((uint64_t)ns > vp_max_ns) vp_max_ns = ns; }

static void top(const char *what, volatile uint32_t *cur, uint32_t *prev, int n, const char *fmt)
{
    int i, k, best;
    uint32_t d[0x400];
    fprintf(stderr, "  %s:", what);
    for (i = 0; i < n; i++) { d[i] = cur[i] - prev[i]; prev[i] = cur[i]; }
    for (k = 0; k < 8; k++) {
        best = -1;
        for (i = 0; i < n; i++) if (d[i] && (best < 0 || d[i] > d[best])) best = i;
        if (best < 0) break;
        fprintf(stderr, " ");
        fprintf(stderr, fmt, best);
        fprintf(stderr, "=%u/s", (unsigned)(d[best] / 2));
        d[best] = 0;
    }
    fprintf(stderr, "\n");
}

void stats_report(void)
{
    static int64_t last;
    static uint64_t p_trap_ns, p_vp_ns, p_user, p_kernel;
    static uint32_t p_traps, p_vp_n, p_ticks, p_raised[16], p_taken[16];
    extern uint32_t tickcount;
    uint64_t user = 0, kernel = 0;
    int64_t now = plat_now_ns();
    uint32_t t = n_traps, ticks = tickcount, raised = 0, taken = 0;
    int i;
    if (!stats_on || now - last < 2000000000LL) return;
    last = now;
    plat_thread_times(&user, &kernel);
    for (i = 0; i < 16; i++) { raised += c_irq_raised[i] - p_raised[i]; taken += c_irq_taken[i] - p_taken[i]; p_raised[i] = c_irq_raised[i]; p_taken[i] = c_irq_taken[i]; }
    fprintf(stderr, "stats: traps %u/s, host time in them %.1f ms/s | game thread cpu user %.0f ms, kernel %.0f ms per s | "
            "video_present %u/s avg %.2f ms max %.2f ms | game ticks %u/s (PIT %u Hz), irq raised %u/s taken %u/s\n",
            (unsigned)((t - p_traps) / 2), (double)(trap_ns - p_trap_ns) / 2e6, (double)(user - p_user) / 2e6,
            (double)(kernel - p_kernel) / 2e6, (unsigned)((vp_n - p_vp_n) / 2),
            vp_n != p_vp_n ? (double)(vp_ns - p_vp_ns) / (vp_n - p_vp_n) / 1e6 : 0.0, (double)vp_max_ns / 1e6,
            (unsigned)((ticks - p_ticks) / 2), irq_pit_hz(), (unsigned)(raised / 2), (unsigned)(taken / 2));
    p_traps = t; p_trap_ns = trap_ns; p_vp_ns = vp_ns; p_vp_n = vp_n; p_user = user; p_kernel = kernel; p_ticks = ticks; vp_max_ns = 0;
    top("opcode", c_op, p_op, 256, "%02x");
    top("in port", c_in, p_in, NPORT, "%03x");
    top("out port", c_out, p_out, NPORT, "%03x");
    top("int", c_int, p_int, 256, "%02x");
    top("int 21h ah", c_ah, p_ah, 256, "%02x");
}
