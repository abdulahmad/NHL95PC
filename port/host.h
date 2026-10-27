#ifndef HOST_H
#define HOST_H
#ifdef _WIN32
#define WIN32_LEAN_AND_MEAN
#include <windows.h>
typedef CONTEXT ctx_t;
#define W_EAX Eax
#define W_EBX Ebx
#define W_ECX Ecx
#define W_EDX Edx
#define W_ESI Esi
#define W_EDI Edi
#define W_EBP Ebp
#define W_ESP Esp
#define W_EIP Eip
#define W_EFL EFlags
#define W_CS SegCs
#define W_ES SegEs
/* register access on the interrupted game context */
#define R(c, r) (*(uint32_t *)&(c)->W_##r)
#else
#define _GNU_SOURCE
#include <signal.h>
#include <ucontext.h>
typedef ucontext_t ctx_t;
#define R(c, r) ((c)->uc_mcontext.gregs[REG_##r])
#endif
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int trace_on;
#define TRACE(...) do { if (trace_on) fprintf(stderr, __VA_ARGS__); } while (0)

/* The game's code section: traps outside it are not the game's. */
extern char sub_10000[];
#define GAME_CODE_SIZE 0xB8000u
#define IN_GAME_CODE(p) ((uintptr_t)(p) >= (uintptr_t)sub_10000 && (uintptr_t)(p) < (uintptr_t)sub_10000 + GAME_CODE_SIZE)

void host_exit(int code);
void install_overrides(void);
void patch_jmp(void *from, void *to);
void patch_bytes(void *at, const void *bytes, size_t n);
int map_low_memory(void);
void host_cstart(int argc, char **argv);
void game_run(int argc, char **argv);      /* the game thread: C library start-up, then main() */

/* platform layer (plat_linux.c, plat_win.c) */
void *plat_map_fixed(uintptr_t addr, size_t size);     /* read/write/execute memory at exactly addr, or NULL */
void *plat_map_any(size_t size);                       /* below 2 GB, or NULL */
void plat_unmap(void *addr, size_t size);              /* give back a block from plat_map_any */
void plat_make_image_writable(void);                   /* the game patches its own code */
void plat_install_traps(void);                         /* int, in, out, cli, sti and friends end up in emulate_privileged */
void plat_start_game(void);                            /* start the game thread */
void plat_kick_game(void);                             /* let the game thread take a pending interrupt */
void plat_trace_game(void);                            /* NHL95_TRACE: print where the game thread is */
void plat_thread_times(uint64_t *user_ns, uint64_t *kernel_ns);   /* NHL95_STATS: CPU time of the game thread */

/* NHL95_STATS (stats.c) */
extern int stats_on;
void stats_init(void);
void stats_op(unsigned op);
void stats_port(unsigned port, int out);
void stats_int(unsigned vec, unsigned ah);
void stats_irq(int irq, int taken);
void stats_trap_ns(int64_t ns);
void stats_present_ns(int64_t ns);
void stats_screen(int changed, int w, int h);          /* a presented image: did it differ from the previous one */
void stats_report(void);                               /* main thread, about every 2 s */
int64_t plat_now_ns(void);
int plat_cpu_percent(void);                            /* this program's share of all the CPUs since the last call, or -1 */
int plat_gpu_percent(void);                            /* this program's 3D engine use of the GPU since the last call, or -1 */
void plat_sleep_ms(int ms);

/* privileged instructions the game executes (emu.c) */
int emulate_privileged(ctx_t *c, uint8_t *ip);
int traps(const uint8_t *ip);
void install_flag_traps(void);                         /* pushf / popf of the game become int3 (emulated with vif) */
int emulate_low_memory(ctx_t *c, uint8_t *ip);         /* an access below 0x10000: continue through a trampoline */
int accesses_low_memory(ctx_t *c, uint8_t *ip);
/* software interrupts: DOS, BIOS, DPMI, mouse (dos.c) */
int dos_int(ctx_t *c, int vec);
struct vec { uint32_t off; uint32_t sel; };
extern struct vec pm_vec[256];
/* I/O ports (ports.c) */
uint32_t port_in(ctx_t *c, unsigned port, int size);
void port_out(ctx_t *c, unsigned port, uint32_t val, int size);
/* interrupt delivery (irq.c) */
void irq_raise(int irq);
void irq_poll(void);                                   /* main thread: deliver what is pending */
int irq_try_deliver(ctx_t *c);                         /* make the interrupted context take a pending interrupt */
void irq_set_enabled(ctx_t *c, int on);
void irq_pit_divisor(unsigned divisor);
unsigned irq_pit_hz(void);
int irq_deliverable(void);
extern volatile int vif;
/* video (video.c) */
int video_int10(ctx_t *c);
uint32_t video_port_in(unsigned port);
int video_port_out(unsigned port, uint32_t val);
void video_init(void);
void video_set_title(const char *title);
void video_view(int *vx, int *vy, int *vw, int *vh);   /* where the 4:3 picture is in the window (window coordinates) */
void video_mode_size(int *w, int *h);                  /* the game's current screen size: 640x480 (menus) or 320x200 (play) */
void video_game_to_window(int gx, int gy, int *wx, int *wy);
void video_confine_mouse(int on);                      /* fullscreen: the host pointer stays on the 4:3 picture */
void video_pacing_key(int n);                          /* keys 1..4: how often the window is drawn, vsync */
int64_t video_present_ns(void);
enum { CMD_REFRESH_60 = 100, CMD_REFRESH_70, CMD_REFRESH_VRR, CMD_VSYNC, CMD_STATS, CMD_HIRES = 200, CMD_LORES = 300, CMD_VSCALE_HI = 400, CMD_VSCALE_LO = 410, CMD_POINTER = 500, CMD_MBRIGHT_HI = 600, CMD_MRESET_HI = 610, CMD_MBRIGHT_LO = 620, CMD_MRESET_LO = 611, CMD_MSCALE_HI = 640, CMD_MSCALE_LO = 650, CMD_MFILE = 1000 };
#define NHIRES_ITEMS 11
#define NLORES_ITEMS 16   /* the menu commands */
void video_command(int id);
int video_command_checked(int id);
#ifdef _WIN32
void menu_init(void *sdl_window);                      /* menu_win.c: the window's menu bar */
void menu_sync(void);
void menu_show(int on);
void menu_event(void *syswm_msg);
int menu_client_size(int *w, int *h);                  /* the client area as Windows has it, 0 if unknown */
#else
static inline void menu_init(void *w) { (void)w; }
static inline void menu_sync(void) {}
static inline void menu_show(int on) { (void)on; }
static inline void menu_event(void *m) { (void)m; }
static inline int menu_client_size(int *w, int *h) { (void)w; (void)h; return 0; }
#endif
int video_vrr(void);
void video_mister_pick(int cls, int kind, const char *rel);  /* a MiSTer look file chosen from the menu, for the menus (cls 0) or the game (1): 0 horizontal filter, 1 vertical filter, 2 gamma, 3 shadow mask, 4 preset */
const char *video_mister_path(int cls, int kind);
int video_pointer_mode(void);                          /* 0 automatic, 1 always show, 2 always hide the Windows pointer */
int64_t game_pointer_ns(void);                        /* when the game last ran its menu pointer code (emu.c), 0 if never */
int video_changed(void);
void video_toggle_fullscreen(void);                    /* Alt+Enter */
int video_is_fullscreen(void);
void video_present(void);              /* main thread */
void video_fill_vesa_tables(void);
void video_window_to_game(int wx, int wy, int *gx, int *gy);
/* input (input.c) */
void input_init(void);                 /* game controllers and the test stick */
void input_poll(void);                 /* main thread: SDL events */
uint32_t input_port_in(unsigned port);
int input_port_out(unsigned port, uint32_t val);
int input_mouse(ctx_t *c);
#endif
