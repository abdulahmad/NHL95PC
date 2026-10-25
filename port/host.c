/* SDL2 host for the NHL 95 PC rebuild. The original 32-bit game code (the NASM sources in ../src) runs unchanged as a thread of
 * this program. Instructions that only DOS or the PC hardware could execute (int n, in, out, cli, sti) fault; the platform layer
 * hands them to the emulation here. The main thread owns SDL: window, events, timer ticks. */
#include "host.h"
#include <SDL.h>

int trace_on;
static int g_argc;
static char **g_argv;

#ifdef _WIN32
#define SYM(s) "_" s
#else
#define SYM(s) s
#endif

/* The game: C library start-up, then main(). Runs on the game thread. */
void game_run(int argc, char **argv)
{
    host_cstart(argc, argv);
    __asm__ volatile("mov $0xFF, %%eax\n call " SYM("__InitRtns") "\n xor %%ebp, %%ebp\n call " SYM("__CMain") ::: "eax", "edx", "ecx", "memory");
    host_exit(0);
}

void game_args(int *argc, char ***argv)
{
    *argc = g_argc;
    *argv = g_argv;
}

int main(int argc, char **argv)
{
    int64_t next_tick, next_frame;
    g_argc = argc; g_argv = argv;
    trace_on = getenv("NHL95_TRACE") != 0;
    SDL_SetMainReady();
    if (SDL_Init(SDL_INIT_VIDEO | SDL_INIT_EVENTS | SDL_INIT_AUDIO) < 0) { fprintf(stderr, "SDL_Init: %s\n", SDL_GetError()); return 1; }
    video_init();
    if (map_low_memory()) fprintf(stderr, "cannot map DOS memory below 1 MB\n");
    plat_make_image_writable();
    install_overrides();
    plat_install_traps();
    plat_start_game();

    next_tick = next_frame = plat_now_ns();
    for (;;) {
        int64_t now = plat_now_ns();
        input_poll();
        if (now >= next_frame) { video_present(); next_frame = now + 16666667; }
        if (now >= next_tick) {
            irq_raise(0);
            next_tick += 1000000000LL / irq_pit_hz();
            if (now - next_tick > 200000000) next_tick = now;
        }
        irq_poll();
        plat_sleep_ms(1);
    }
    return 0;
}
