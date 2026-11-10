/* SDL2 host for the NHL 95 PC rebuild. The original 32-bit game code (the NASM sources in ../src) runs unchanged as a thread of
 * this program. Instructions that only DOS or the PC hardware could execute (int n, in, out, cli, sti) fault; the platform layer
 * hands them to the emulation here. The main thread owns SDL: window, events, timer ticks. */
#include "host.h"
#include "snap.h"
#include "audio.h"
#include "overbar_client.h"
#include "sides.h"
void sound_init(void);
#include <SDL.h>

int trace_on;
static int g_argc;
static char **g_argv;

#ifdef _WIN32
#define SYM(s) "_" s
static void win32_scrub_portmaster_env(void)
{
    /* Delete, do not _putenv("VAR="): an empty SDL_VIDEODRIVER makes SDL_Init fail. */
    SetEnvironmentVariableA("SDL_RENDER_DRIVER", NULL);
    SetEnvironmentVariableA("SDL_OPENGL_ES_DRIVER", NULL);
    SetEnvironmentVariableA("SDL_VIDEODRIVER", NULL);
    SetEnvironmentVariableA("OVERBAR_HANDHELD", NULL);
    SetEnvironmentVariableA("PORTMASTER", NULL);
    SetEnvironmentVariableA("CFW_NAME", NULL);
    SDL_SetHintWithPriority(SDL_HINT_RENDER_DRIVER, "", SDL_HINT_OVERRIDE);
#ifdef SDL_HINT_OPENGL_ES_DRIVER
    SDL_SetHintWithPriority(SDL_HINT_OPENGL_ES_DRIVER, "0", SDL_HINT_OVERRIDE);
#endif
}
#else
#define SYM(s) s
#endif

/* The game: C library start-up, then main(). Runs on the game thread. */
void game_run(int argc, char **argv)
{
    snap_set_stack_base(__builtin_frame_address(0));
    host_cstart(argc, argv);
    __asm__ volatile("mov $0xFF, %%eax\n call " SYM("__InitRtns") "\n xor %%ebp, %%ebp\n call " SYM("__CMain") ::: "eax", "edx", "ecx", "memory");
    host_exit(0);
}

void game_args(int *argc, char ***argv)
{
    *argc = g_argc;
    *argv = g_argv;
}

extern volatile int intro_skip;

int main(int argc, char **argv)
{
    int64_t next_tick, next_frame;
    g_argc = argc; g_argv = argv;
    trace_on = getenv("NHL95_TRACE") != 0;    stats_init();
#ifdef _WIN32
    /* PortMaster / Overbar packing leftovers (SDL_RENDER_DRIVER=opengles2, OVERBAR_HANDHELD)
     * must be gone before SDL_Init: otherwise Windows creates an ES context or kmsdrm fails. */
    win32_scrub_portmaster_env();
#endif
    SDL_SetMainReady();
    if (SDL_Init(SDL_INIT_VIDEO | SDL_INIT_EVENTS | SDL_INIT_AUDIO | SDL_INIT_JOYSTICK | SDL_INIT_GAMECONTROLLER) < 0) {
        fprintf(stderr, "SDL_Init: %s\n", SDL_GetError());
#ifdef _WIN32
        MessageBoxA(NULL, SDL_GetError(), "NHL Hockey 95 — SDL_Init", MB_ICONERROR);
#endif
        return 1;
    }
#ifdef _WIN32
    win32_scrub_portmaster_env();   /* SDL_Init can copy env into hints; scrub again before the window */
#endif
    ob_present_apply_hints(ob_profile_detect(SDL_GetCurrentVideoDriver(), ob_handheld_env()));
    video_init();
#ifdef _WIN32
    SDL_FlushEvent(SDL_QUIT);   /* leftover from a failed OpenGL window destroy during video_init */
#endif
    input_init();
    sound_init();
    if (map_low_memory()) fprintf(stderr, "cannot map DOS memory below 1 MB\n");
    if (getenv("NHL95_SOUNDTEST")) { extern int soundtest(void); return soundtest(); }
    plat_make_image_writable();
    install_overrides();
    netplay_install();
    plat_install_traps();
    if (getenv("NHL95_CRASHTEST")) { volatile int *p = 0; *p = 1; }      /* checks that a crash is reported */
    plat_start_game();

    next_tick = next_frame = plat_now_ns();
    for (;;) {
        int64_t now = plat_now_ns();
        input_poll();
        if (video_vrr()) {                      /* key 6: when the game's screen has changed (and now and then for the pointer and the window) */
            if (video_changed() || now >= next_frame) { video_present(); next_frame = now + 100000000LL; }
        } else if (now >= next_frame) {           /* on schedule, not "a period after this one": late frames do not lower the rate */
            video_present();
            next_frame += video_present_ns();
            if (now - next_frame > 100000000) next_frame = now;
        }
        /* one tick per period that has passed: a sleep that lasted longer than asked (Windows rounds it to 15.6 ms when it does not
         * treat the process as in the foreground) must not lose ticks. They queue in irq.c. */
        if (overbar_client_quit()) host_exit(0);
#ifdef _WIN32
        if (menu_resync) { menu_resync = 0; next_tick = now; }        /* a menu bar loop ran: no catching up */
#endif
        while (now >= next_tick) {
            if ((!overbar_client_open() && !port_sides_is_open()) || netplay_running()) irq_raise(0);     /* overlay / sides: the game clock waits (not online) */
            next_tick += 1000000000LL / irq_pit_hz() / (intro_skip ? 20 : 1);        /* skipping the splash screens: the game's clock runs fast */
            if (now - next_tick > 200000000) { next_tick = now; break; }
        }
        sb_pump();
        gus_pump();
        if (mpu_roms_missing())
            SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_WARNING, "NHL Hockey 95",
                "The MT-32 is selected, but its ROM images were not found, so there will be no sound.\n\n"
                "Put MT32_CONTROL.ROM and MT32_PCM.ROM in a folder named roms next to the program (or in the game folder), "
                "or set NHL95_MT32_ROMS to the folder that has them.", 0);
        audio_pump();
        netplay_main_poll();
        irq_poll();
        stats_report();
        plat_sleep_ms(1);
    }
    return 0;
}
