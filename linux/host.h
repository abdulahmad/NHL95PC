#ifndef HOST_H
#define HOST_H
#define _GNU_SOURCE
#include <pthread.h>
#include <signal.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ucontext.h>

extern int trace_on;
extern pthread_t game_thread;

/* register access on the interrupted game context */
#define R(c, r) ((c)->uc_mcontext.gregs[REG_##r])
#define TRACE(...) do { if (trace_on) fprintf(stderr, __VA_ARGS__); } while (0)

void host_exit(int code);
void install_overrides(void);
void patch_jmp(void *from, void *to);
int map_low_memory(void);
void host_cstart(int argc, char **argv);

/* privileged instructions the game executes (emu.c) */
int emulate_privileged(ucontext_t *c, uint8_t *ip);
/* software interrupts: DOS, BIOS, DPMI, mouse (dos.c) */
int dos_int(ucontext_t *c, int vec);
extern struct vec { uint32_t off; uint32_t sel; } pm_vec[256];
/* I/O ports (ports.c) */
uint32_t port_in(ucontext_t *c, unsigned port, int size);
void port_out(ucontext_t *c, unsigned port, uint32_t val, int size);
/* interrupt delivery (irq.c) */
void irq_init(void);
void irq_raise(int irq);
void irq_set_enabled(ucontext_t *c, int on);
void irq_pit_divisor(unsigned divisor);
unsigned irq_pit_hz(void);
extern volatile int vif;
/* video (video.c) */
int video_int10(ucontext_t *c);
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
int input_mouse(ucontext_t *c);
#endif
