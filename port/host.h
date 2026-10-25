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
void plat_make_image_writable(void);                   /* the game patches its own code */
void plat_install_traps(void);                         /* int, in, out, cli, sti and friends end up in emulate_privileged */
void plat_start_game(void);                            /* start the game thread */
void plat_kick_game(void);                             /* let the game thread take a pending interrupt */
int64_t plat_now_ns(void);
void plat_sleep_ms(int ms);

/* privileged instructions the game executes (emu.c) */
int emulate_privileged(ctx_t *c, uint8_t *ip);
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
void video_present(void);              /* main thread */
void video_fill_vesa_tables(void);
void video_window_to_game(int wx, int wy, int *gx, int *gy);
/* input (input.c) */
void input_poll(void);                 /* main thread: SDL events */
uint32_t input_port_in(unsigned port);
int input_port_out(unsigned port, uint32_t val);
int input_mouse(ctx_t *c);
#endif
